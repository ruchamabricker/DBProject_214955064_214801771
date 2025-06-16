from flask import Blueprint, render_template, request, redirect, url_for
from datetime import date
from ..db import connect_db

athlete_bp = Blueprint('athlete', __name__)

@athlete_bp.route('/')
def all_athletes():
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


@athlete_bp.route('/athletes_by_month')
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


@athlete_bp.route('/<int:athlete_id>')
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
        cur.close()
        conn.close()
        return "Athlete not found", 404

    athlete = {
        'id': athlete_row[0],
        'name': athlete_row[1],
        'gender': athlete_row[2],
        'birthday': athlete_row[3].strftime('%Y-%m-%d') if athlete_row[3] else '',
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
        athlete_team_id = None
        cur.execute("SELECT team_id FROM players WHERE athlete_id = %s", (athlete_id,))
        team_row = cur.fetchone()
        athlete_team_id = team_row[0] if team_row else None
    else:
        athlete['is_player'] = False
        athlete_team_id = None

    cur.execute("SELECT get_total_goals(%s);", (athlete_id,))
    athlete['total_goals'] = cur.fetchone()[0]

    cur.execute("""
        SELECT match_id
        FROM athlete_match
        WHERE athlete_id = %s;
    """, (athlete_id,))    
    match_ids = [row[0] for row in cur.fetchall()]
    matches = []


    for match_id in match_ids:
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
            continue

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
                SELECT a.athlete_name, co.country_name, am.athlete_rank, am.medal, am.athlete_id
                FROM athlete_match am
                JOIN athletes a ON am.athlete_id = a.athlete_id
                JOIN country co ON a.country_id = co.country_id
                WHERE am.match_id = %s
            """, (match_id,))
            athletes = []
            for athlete_name, country_name, athlete_rank, medal, athlete_id in cur.fetchall():
                athletes.append({
                    'name': athlete_name,
                    'country': country_name,
                    'rank': athlete_rank,
                    'medal': medal,
                    'athlete_id': athlete_id
                })
            match['athletes'] = athletes
            gold_athletes = [a for a in athletes if a['medal'] == 'Gold']
            if gold_athletes:
                # בחר את הספורטאית עם הדירוג הגבוה ביותר (המספר הקטן ביותר)
                winner = min(gold_athletes, key=lambda a: a['rank'])['name']
            else:
                winner = "N/A"

            match['winner'] = winner
        matches.append(match)

    cur.close()
    conn.close()

    return render_template('athlete_profile.html', athlete=athlete, matches=matches)


@athlete_bp.route('/update/<int:athlete_id>', methods=['POST'])
def update_athlete(athlete_id):
    name = request.form['name']
    gender = request.form['gender']
    birthday = request.form['birthday']
    country_name = request.form['country']

    conn = connect_db()
    if not conn:
        return "DB connection failed", 500
    cur = conn.cursor()

    # עדכון טבלת country אם המדינה שונה
    cur.execute("SELECT country_id FROM country WHERE country_name = %s", (country_name,))
    result = cur.fetchone()
    if result:
        country_id = result[0]
    else:
        # הוספת מדינה חדשה אם לא קיימת
        cur.execute("INSERT INTO country (country_name) VALUES (%s) RETURNING country_id", (country_name,))
        country_id = cur.fetchone()[0]

    # עדכון טבלת athletes
    cur.execute("""
        UPDATE athletes
        SET athlete_name = %s, gender = %s, birthday = %s, country_id = %s
        WHERE athlete_id = %s
    """, (name, gender, birthday, country_id, athlete_id))

    conn.commit()
    cur.close()
    conn.close()
    return render_template(
        "message.html",
        title="Athlete Updated",
        message="The athlete has been updated successfully!",
        redirect_url=url_for("athlete.athlete_profile", athlete_id=athlete_id),
        delay=2
    )


@athlete_bp.route("/delete/<int:athlete_id>", methods=["POST"])
def delete_athlete(athlete_id):
    conn = connect_db()
    if not conn:
        return "DB connection failed", 500
    cur = conn.cursor()

    cur.execute("SELECT * FROM athletes WHERE athlete_id = %s", (athlete_id,))
    if not cur.fetchone():
        return "Athlete not found", 404

    try:
        cur.execute("DELETE FROM athlete_match WHERE athlete_id = %s", (athlete_id,))
        cur.execute("DELETE FROM players WHERE athlete_id = %s", (athlete_id,))
        cur.execute("DELETE FROM athletes WHERE athlete_id = %s", (athlete_id,))
        conn.commit()
    except Exception as e:
        conn.rollback()
        return f"שגיאה במחיקה: {str(e)}", 500
    finally:
        cur.close()
        conn.close()

    return render_template(
        "message.html",
        title="Athlete Deleted",
        message="The athlete has been deleted successfully!",
        redirect_url=url_for("athlete.all_athletes"),
        delay=2
    )


@athlete_bp.route('/assign_medal/<int:athlete_id>', methods=['POST'])
def assign_medal(athlete_id):
    print("Assigning medal for athlete:", athlete_id)
    match_id = request.form.get('match_id')
    medal = request.form.get('medal')
    print("Match ID:", match_id)
    print("Medal:", medal)

    conn = connect_db()
    if not conn:
        return "DB connection failed", 500
    cur = conn.cursor()


    cur.execute("CALL assign_medal(%s, %s, %s)", (athlete_id, match_id, medal))
    conn.commit()
    cur.close()
    conn.close()
    return render_template(
        "message.html",
        title="Medal Assigned",
        message=f"The medal '{medal}' has been assigned successfully.",
        redirect_url=url_for("athlete.athlete_profile", athlete_id=athlete_id),
        delay=2
    )

