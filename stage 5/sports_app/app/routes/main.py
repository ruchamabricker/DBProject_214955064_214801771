from flask import Flask, render_template, request

import psycopg2
from datetime import date

app = Flask(__name__)

def connect_db():
    try:
        conn = psycopg2.connect(
            dbname="integratedDB",
            user="postgres",
            password="Ruchama613!",
            host="localhost",
            port="5432"
        )
        return conn
    except Exception as e:
        print("Connecting error", e)
        return None

@app.route('/')
def home():
    return render_template('home.html')


@app.route('/athletes')
def athletes():
    conn = connect_db()
    if not conn:
        return "Error connecting to database", 500

    cur = conn.cursor()
    cur.execute("""
        SELECT a.athlete_id, a.athlete_name, a.gender, a.birthday, c.country_name
        FROM athletes a
        JOIN country c ON a.country_id = c.country_id
    """)
    
    today = date.today()
    athletes_list = []
    for row in cur.fetchall():
        birthdate = row[3]
        age = today.year - birthdate.year - ((today.month, today.day) < (birthdate.month, birthdate.day))
        athletes_list.append({
            'id': row[0],
            'name': row[1],
            'gender': row[2].lower(),
            'age': age,
            'country': row[4]
        })

    cur.close()
    conn.close()
    
    return render_template('athletes.html', athletes=athletes_list)


@app.route('/athletes_by_month')
def athletes_by_month():
    month_str = request.args.get('month', "")
    
    conn = connect_db()
    if not conn:
        return "Error connecting to database", 500

    cur = conn.cursor()

    if month_str and month_str.isdigit():
        month = int(month_str)
        if 1 <= month <= 12:
            cur.execute("""
                SELECT a.athlete_id, a.athlete_name, a.gender, a.birthday, c.country_name
                FROM athletes a
                JOIN country c ON a.country_id = c.country_id
                WHERE EXTRACT(MONTH FROM a.birthday) = %s
            """, (month,))
        else:
            return "Month must be between 1 and 12", 400
    else:
        # אין חודש, נחזיר את כולם
        cur.execute("""
            SELECT a.athlete_id, a.athlete_name, a.gender, a.birthday, c.country_name
            FROM athletes a
            JOIN country c ON a.country_id = c.country_id
        """)

    today = date.today()
    athletes_list = []
    for row in cur.fetchall():
        birthdate = row[3]
        age = today.year - birthdate.year - ((today.month, today.day) < (birthdate.month, birthdate.day))
        athletes_list.append({
            'id': row[0],
            'name': row[1],
            'gender': row[2].lower(),
            'age': age,
            'country': row[4]
        })

    cur.close()
    conn.close()

    return render_template('athletes.html', athletes=athletes_list, selected_month=month_str)


# @app.route('/athlete/<int:athlete_id>')
# def athlete_profile(athlete_id):
#     conn = connect_db()
#     if not conn:
#         return "Error connecting to database", 500

#     cur = conn.cursor()

#     # פרטי אתלט בסיסיים
#     cur.execute("""
#         SELECT a.athlete_id, a.athlete_name, a.gender, a.birthday, c.country_name
#         FROM athletes a
#         JOIN country c ON a.country_id = c.country_id
#         WHERE a.athlete_id = %s
#     """, (athlete_id,))
#     row = cur.fetchone()

#     if not row:
#         cur.close()
#         conn.close()
#         return "Athlete not found", 404

#     athlete = {
#         'id': row[0],
#         'name': row[1],
#         'gender': row[2],
#         'birthday': row[3],
#         'age': date.today().year - row[3].year - ((date.today().month, date.today().day) < (row[3].month, row[3].day)),
#         'country': row[4],
#         'is_player': False
#     }

#     # האם הוא גם שחקן בקבוצה?
#     cur.execute("SELECT p.player_id, t.team_name, t.coach, t.fifa_ranking, t.team_group FROM players p JOIN teams t ON p.team_id = t.team_id WHERE p.athlete_id = %s", (athlete_id,))
#     player_info = cur.fetchone()
#     if player_info:
#         athlete['is_player'] = True
#         athlete['team_name'] = player_info[1]
#         athlete['coach'] = player_info[2]
#         athlete['fifa_ranking'] = player_info[3]
#         athlete['group'] = player_info[4]

#         # משחקים של שחקן בקבוצה
#         cur.execute("""
#             SELECT m.match_date, 
#                    t1.team_name, m.score_team1, 
#                    t2.team_name, m.score_team2,
#                    am.medal
#             FROM matches m
#             JOIN teams t1 ON m.team1_id = t1.team_id
#             JOIN teams t2 ON m.team2_id = t2.team_id
#             JOIN athlete_match am ON m.match_id = am.match_id
#             JOIN players p ON am.athlete_id = p.athlete_id
#             WHERE am.athlete_id = %s
#         """, (athlete_id,))
#         matches = []
#         for match in cur.fetchall():
#             score1 = match[2]
#             score2 = match[4]
#             matches.append({
#                 'date': match[0],
#                 'opponent': match[3] if match[1] == athlete['team_name'] else match[1],
#                 'score_us': score1 if match[1] == athlete['team_name'] else score2,
#                 'score_them': score2 if match[1] == athlete['team_name'] else score1,
#                 'medal': match[5]
#             })
#         athlete['matches'] = matches

#     else:
#         # אם הוא לא שחקן - תחרויות אישיות
#         cur.execute("""
#             SELECT c.competition_name, c.comp_date, s.name, am.medal
#             FROM competitions c
#             JOIN stages s ON c.competition_id = s.competition_id
#             JOIN matches m ON m.stage_id = s.stage_id
#             JOIN athlete_match am ON am.match_id = m.match_id
#             WHERE am.athlete_id = %s
#         """, (athlete_id,))
#         competitions = []
#         for comp in cur.fetchall():
#             competitions.append({
#                 'competition_name': comp[0],
#                 'date': comp[1],
#                 'stage_name': comp[2],
#                 'medal': comp[3]
#             })
#         athlete['competitions'] = competitions

#     cur.close()
#     conn.close()
#     return render_template("athlete_profile.html", athlete=athlete)

@app.route('/athlete/<int:athlete_id>')
def athlete_profile(athlete_id):
    conn = connect_db()
    if not conn:
        return "Error connecting to database", 500

    cur = conn.cursor()

    # פרטי הספורטאי
    cur.execute("""
        SELECT a.athlete_id, a.athlete_name, a.gender, a.birthday, c.country_name
        FROM athletes a
        JOIN country c ON a.country_id = c.country_id
        WHERE a.athlete_id = %s
    """, (athlete_id,))
    athlete_row = cur.fetchone()
    if not athlete_row:
        return "Athlete not found", 404

    athlete = {
        'id': athlete_row[0],
        'name': athlete_row[1],
        'gender': athlete_row[2],
        'birthday': athlete_row[3],
        'country': athlete_row[4]
    }

    # בדיקה אם הספורטאי הוא שחקן בקבוצה
    cur.execute("""
        SELECT p.player_id, t.team_name, t.coach, t.team_group, t.fifa_ranking
        FROM players p
        JOIN teams t ON p.team_id = t.team_id
        WHERE p.athlete_id = %s
    """, (athlete_id,))
    player_row = cur.fetchone()
    if player_row:
        athlete['is_player'] = True
        athlete['team'] = {
            'name': player_row[1],
            'coach': player_row[2],
            'group': player_row[3],
            'fifa_ranking': player_row[4]
        }
    else:
        athlete['is_player'] = False

    # משחקים שבהם השתתף הספורטאי
    cur.execute("""
        SELECT m.match_id, m.match_date, m.team1_id, m.team2_id,
               m.score_team1, m.score_team2,
               am.medal, t1.team_name, t2.team_name
        FROM athlete_match am
        JOIN matches m ON am.match_id = m.match_id
        LEFT JOIN teams t1 ON m.team1_id = t1.team_id
        LEFT JOIN teams t2 ON m.team2_id = t2.team_id
        WHERE am.athlete_id = %s
        ORDER BY m.match_date DESC
    """, (athlete_id,))
    matches = []
    for row in cur.fetchall():
        match = {
            'match_id': row[0],
            'date': row[1],
            'team1_id': row[2],
            'team2_id': row[3],
            'score_team1': row[4],
            'score_team2': row[5],
            'medal': row[6],
            'team1_name': row[7],
            'team2_name': row[8]
        }

        # קביעת הקבוצה של הספורטאי
        if athlete['is_player']:
            cur.execute("""
                SELECT team_id FROM players WHERE athlete_id = %s
            """, (athlete_id,))
            team_id = cur.fetchone()[0]
            if team_id == match['team1_id']:
                match['athlete_team'] = match['team1_name']
                match['opponent_team'] = match['team2_name']
                match['athlete_score'] = match['score_team1']
                match['opponent_score'] = match['score_team2']
            else:
                match['athlete_team'] = match['team2_name']
                match['opponent_team'] = match['team1_name']
                match['athlete_score'] = match['score_team2']
                match['opponent_score'] = match['score_team1']
        else:
            # תחרויות אישיות: קביעת מספר ניצחונות לכל ספורטאי
            cur.execute("""
                SELECT am2.athlete_id, COUNT(*) as wins
                FROM athlete_match am2
                JOIN matches m2 ON am2.match_id = m2.match_id
                WHERE m2.match_id = %s AND am2.medal = 'gold'
                GROUP BY am2.athlete_id
            """, (match['match_id'],))
            wins_data = cur.fetchall()
            athlete_wins = 0
            opponent_wins = 0
            for win_row in wins_data:
                if win_row[0] == athlete_id:
                    athlete_wins = win_row[1]
                else:
                    opponent_wins = win_row[1]
            match['athlete_wins'] = athlete_wins
            match['opponent_wins'] = opponent_wins

        match_id = match['match_id']
        # פרטי האצטדיון (מיקום ותכולה)
    cur.execute("""
        SELECT v.venue_name, v.capacity
        FROM matches m
        JOIN venues v ON m.venue_id = v.venue_id
        WHERE m.match_id = %s
    """, (match_id,))
    venue = cur.fetchone()
    match['venue_name'] = venue[0] if venue else None
    match['venue_capacity'] = venue[1] if venue else None

    # כרטיסים למשחק
    cur.execute("""
        SELECT COUNT(*), MAX(ticket_price)
        FROM ticket t
        JOIN matches m ON t.venue_id = m.venue_id
        WHERE m.match_id = %s
    """, (match_id,))
    ticket_data = cur.fetchone()
    match['tickets_sold'] = ticket_data[0] if ticket_data else 0
    match['ticket_price'] = ticket_data[1] if ticket_data else 0

    # מיקום שחקן, גולים ואסיסטים
    cur.execute("""
        SELECT position, goals, assists
        FROM players
        WHERE athlete_id = %s
    """, (athlete_id,))
    player_stats = cur.fetchone()
    if player_stats:
        match['position'] = player_stats[0]
        match['goals'] = player_stats[1]
        match['assists'] = player_stats[2]
    else:
        match['position'] = None
        match['goals'] = 0
        match['assists'] = 0

    # אירועים במשחק
    cur.execute("""
        SELECT me.event_type, me.minute
        FROM match_events me
        JOIN players p ON me.player_id = p.player_id
        WHERE p.athlete_id = %s AND me.match_id = %s
    """, (athlete_id, match_id))
    match['events'] = cur.fetchall()

    # שלב, תחרות וספורט
    cur.execute("""
        SELECT s.name, c.competition_name, sp.sport_name
        FROM matches m
        JOIN stages s ON m.stage_id = s.stage_id
        JOIN competitions c ON s.competition_id = c.competition_id
        JOIN sports sp ON c.sport_id = sp.sport_id
        WHERE m.match_id = %s
    """, (match_id,))
    stage_info = cur.fetchone()
    if stage_info:
        match['stage_name'] = stage_info[0]
        match['competition_name'] = stage_info[1]
        match['sport_name'] = stage_info[2]
    else:
        match['stage_name'] = None
        match['competition_name'] = None
        match['sport_name'] = None
    
    
    # דירוג ספורטאי
    cur.execute("""
        SELECT athlete_rank
        FROM athlete_match
        WHERE athlete_id = %s AND match_id = %s
    """, (athlete_id, match_id))
    rank_row = cur.fetchone()
    match['athlete_rank'] = rank_row[0] if rank_row else None

    matches.append(match)

    cur.close()
    conn.close()

    return render_template('athlete_profile.html', athlete=athlete, matches=matches)


@app.route('/matches')
def matches():
    conn = connect_db()
    if not conn:
        return "Error connecting to database", 500
    
    cur = conn.cursor()
    cur.execute("SELECT match_id, match_date, venue_id FROM matches")  # תוודאי את שם הטבלה והעמודות
    matches_list = [{'match_id': row[0], 'match_date': row[1].strftime('%Y-%m-%d'), 'venue_id': row[2]} for row in cur.fetchall()]
    
    cur.close()
    conn.close()
    
    return render_template('matches.html', matches=matches_list)

@app.route('/match_details/<int:match_id>')
def match_details(match_id):
    conn = connect_db()
    if not conn:
        return "Error connecting to database", 500
    
    cur = conn.cursor()
    cur.execute("SELECT match_id, match_date, venue_id FROM matches WHERE match_id = %s", (match_id,))
    row = cur.fetchone()
    cur.close()
    conn.close()

    if row:
        match = {'match_id': row[0], 'match_date': row[1].strftime('%Y-%m-%d'), 'venue_id': row[2]}
        return render_template('match_details.html', match=match)
    else:
        return "match not found", 404

if __name__ == '__main__':
    app.run(debug=True)
