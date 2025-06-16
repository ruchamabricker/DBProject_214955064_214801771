from flask import Blueprint, render_template, request, url_for
from ..db import connect_db

match_bp = Blueprint('matches', __name__)

@match_bp.route('/')
def matches():
    conn = connect_db()
    if not conn:
        return "Error connecting to database", 500

    cur = conn.cursor()
    cur.execute("""
        SELECT
            m.match_id,
            m.match_date,
            v.venue_name,
            c.competition_name,
            s.name AS stage_name,
            sp.sport_name
        FROM matches m
        JOIN venues v ON m.venue_id = v.venue_id
        JOIN stages s ON m.stage_id = s.stage_id
        JOIN competitions c ON s.competition_id = c.competition_id
        JOIN sports sp ON c.sport_id = sp.sport_id
        ORDER BY m.match_date
    """)

    matches_list = [
        {
            'match_id': row[0],
            'match_date': row[1].strftime('%Y-%m-%d'),
            'venue_name': row[2],
            'competition_name': row[3],
            'stage_name': row[4],
            'sport_name': row[5]
        }
        for row in cur.fetchall()
    ]

    cur.close()
    conn.close()

    return render_template('matches.html', matches=matches_list)


@match_bp.route('/match_details/<int:match_id>')
def match_details(match_id):
    conn = connect_db()
    if not conn:
        return "Error connecting to database", 500
    
    cur = conn.cursor()
    # מביאים פרטים על המשחק, בלי מידע על כרטיסים
    cur.execute("""
        SELECT m.match_id, m.match_date,
            v.venue_name, v.capacity,
            s.sport_name,
            c.competition_name,
            st.name as stage_name,
            (CASE WHEN m.team1_id IS NOT NULL THEN TRUE ELSE FALSE END) as is_team_sport,
            m.team1_id, m.team2_id,
            m.score_team1, m.score_team2,
            m.venue_id 
        FROM matches m
        LEFT JOIN venues v ON m.venue_id = v.venue_id
        LEFT JOIN stages st ON m.stage_id = st.stage_id
        LEFT JOIN competitions c ON st.competition_id = c.competition_id
        LEFT JOIN sports s ON c.sport_id = s.sport_id
        WHERE m.match_id = %s
    """, (match_id,))

    
    match_row = cur.fetchone()
    if not match_row:
        cur.close()
        conn.close()
        return "match not found", 404

    match = {
        'match_id': match_row[0],
        'match_date': match_row[1].strftime('%Y-%m-%d'),
        'venue_name': match_row[2],
        'venue_capacity': match_row[3],
        'sport_name': match_row[4],
        'competition_name': match_row[5],
        'stage_name': match_row[6],
        'is_team_sport': match_row[7],
        'venue_id': match_row[12],  # הוספנו את מזהה האצטדיון

    }

    cur.execute("""
        SELECT COUNT(*), MAX(ticket_price)
        FROM ticket t
        JOIN matches m ON t.venue_id = m.venue_id
        WHERE m.match_id = %s
    """, (match['match_id'],))
    ticket_data = cur.fetchone()
    match['tickets_sold'] = ticket_data[0] if ticket_data else 0
    match['ticket_price'] = ticket_data[1] if ticket_data else 0

    if match['is_team_sport']:
        cur.execute("""
            SELECT team_id, team_name, coach
            FROM teams
            WHERE team_id IN (%s, %s)
        """, (match_row[8], match_row[9]))
        teams = []
        teams_data = cur.fetchall()
        for team in teams_data:
            score = match_row[10] if team[0] == match_row[8] else match_row[11]
            teams.append({
                'team_id': team[0],
                'name': team[1],
                'coach': team[2],
                'score': score
            })
        match['teams'] = teams
        if match_row[10] > match_row[11]:
            match['winning_team_id'] = match_row[8]
        elif match_row[11] > match_row[10]:
            match['winning_team_id'] = match_row[9]
        else:
            match['winning_team_id'] = None
    else:
        cur.execute("""
            SELECT a.athlete_name, co.country_name, am.athlete_rank, am.medal
            FROM athlete_match am
            JOIN athletes a ON am.athlete_id = a.athlete_id
            JOIN country co ON a.country_id = co.country_id
            WHERE am.match_id = %s
        """, (match_id,))
        athletes = []
        for athlete_name, country_name, athlete_rank, medal in cur.fetchall():
            athletes.append({
                'name': athlete_name,
                'country': country_name,
                'rank': athlete_rank,
                'medal': medal
            })
        match['athletes'] = athletes
        gold_athletes = [a for a in athletes if a['medal'] == 'Gold']
        if gold_athletes:
            # בחר את הספורטאית עם הדירוג הגבוה ביותר (המספר הקטן ביותר)
            winner = min(gold_athletes, key=lambda a: a['rank'])['name']
        else:
            winner = "N/A"

        match['winner'] = winner

    cur.close()
    conn.close()

    return render_template('match_details.html', match=match)


@match_bp.route('/purchase_ticket/<int:match_id>', methods=['POST'])
def purchase_ticket(match_id):
    match_date = request.form['match_date']
    ticket_price = request.form['ticket_price']
    venue_id = request.form['venue_id']

    conn = connect_db()
    if not conn:
        return "Error connecting to database", 500

    cur = conn.cursor()

    # בדיקה אם יש מספיק מקום באולם
    cur.execute("""
        SELECT v.capacity, 
            (SELECT COUNT(*) 
                FROM ticket t 
                WHERE t.venue_id = v.venue_id) AS tickets_sold
        FROM matches m
        JOIN venues v ON m.venue_id = v.venue_id
        WHERE m.match_id = %s
    """, (match_id,))


    row = cur.fetchone()
    if not row:
        cur.close()
        conn.close()
        return "Match not found", 404

    capacity, tickets_sold = row
    if tickets_sold + 1 > capacity:
        cur.close()
        conn.close()
        return "Not enough tickets available", 400

    try:
        print(f"before New ticket ID:")

        cur.execute("SELECT COALESCE(MAX(card_id), 0) FROM ticket")
        last_id = cur.fetchone()[0]
        new_id = last_id + 1

        print(f"New ticket ID: {new_id}")


        cur.execute("""
            INSERT INTO ticket (card_id, card_date, ticket_price, venue_id)
            VALUES (%s, %s, %s, %s)
        """, (new_id, match_date, ticket_price, venue_id))

        conn.commit()
    except Exception as e:
        conn.rollback()
        cur.close()
        conn.close()
        return str(e), 500

    cur.close()
    conn.close()
    return render_template(
        "message.html",
        title="Ticket Purchase",
        message="The ticket has been successfully purchased.",
        redirect_url=url_for("matches.match_details", match_id = match_id),
        delay=2
    )
