import csv
from random import randint, choice
from datetime import datetime, timedelta

teams = [
    (1, 'Team A'), (2, 'Team B'), (3, 'Team C'), (4, 'Team D'),
    (5, 'Team E'), (6, 'Team F'), (7, 'Team G'), (8, 'Team H')
]

stadiums = [
    (1, 'Stadium X', 'City A', 50000),
    (2, 'Stadium Y', 'City B', 60000),
    (3, 'Stadium Z', 'City C', 40000)
]

stages = [
    ('Group Stage', 48, '2024-06-01', '2024-06-14'),
    ('Round of 16', 8, '2024-06-15', '2024-06-18'),
    ('Quarter Finals', 4, '2024-06-19', '2024-06-21'),
    ('Semi Finals', 2, '2024-06-22', '2024-06-24'),
    ('Final', 1, '2024-06-25', '2024-06-25')
]

start_tournament = datetime(2024, 6, 1)
game_dates = [start_tournament + timedelta(days=i) for i in range(30)] 

csv_filename = "matches.csv"
with open(csv_filename, mode="w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["team1_id", "team2_id", "match_date", "stadium_id", "score_team1", "score_team2", "stage_id"])

    stage_id = 1
    for stage_name, matches_count, start_date, finish_date in stages:
        stage_start = datetime.strptime(start_date, "%Y-%m-%d")
        stage_end = datetime.strptime(finish_date, "%Y-%m-%d")

        for match_num in range(matches_count):
            team1, team2 = choice(teams), choice(teams)
            while team1[0] == team2[0]:
                team2 = choice(teams)

            stadium = choice(stadiums)
            match_date = choice([d for d in game_dates if stage_start <= d <= stage_end])

            writer.writerow([
                team1[0],
                team2[0],
                match_date.strftime("%Y-%m-%d"),
                stadium[0],
                randint(0, 5),  # תוצאה אקראית של קבוצה 1
                randint(0, 5),  # תוצאה אקראית של קבוצה 2
                stage_id
            ])

        stage_id += 1

print(f"CSV file '{csv_filename}' created successfully.")
