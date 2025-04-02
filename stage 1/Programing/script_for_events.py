# יצירת קובץ CSV חדש עם נתוני MatchEvents

# שם הקובץ ליצירה
file_path = "match_events.csv"

# הגדרות נתונים
num_matches = 63  # כמות המשחקים
num_players = 500  # כמות השחקנים הכוללת
players_per_match = 22  # כל קבוצה עולה עם 11 שחקנים
event_types = ['Goal', 'Yellow Card', 'Red Card', 'Substitution']

# יצירת קובץ וכתיבת כותרות
with open(file_path, "w") as f:
    f.write("match_id,player_id,event_type,minute\n")  # כותרות

    # יצירת נתונים למשחקים
    for match_id in range(1, num_matches + 1):
        # חישוב רשימת שחקנים אפשריים למשחק הנוכחי
        start_player_id = ((match_id - 1) * players_per_match) % num_players + 1
        end_player_id = min(start_player_id + players_per_match, num_players + 1)
        player_ids = list(range(start_player_id, end_player_id))

        # הוספת אירועים לשחקנים
        for player_id in player_ids:
            event_type = event_types[(player_id + match_id) % len(event_types)]
            minute = ((player_id * match_id) % 90) + 1  # משחקים נמשכים 90 דקות

            # כתיבת הנתון לקובץ
            f.write(f"{match_id},{player_id},{event_type},{minute}\n")

print(f"✔ קובץ {file_path} נוצר בהצלחה!")
