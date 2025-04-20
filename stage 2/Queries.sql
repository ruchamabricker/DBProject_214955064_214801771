--קבוצות ששיחקו הכי הרבה משחקים בטורניר:
SELECT t.team_name, COUNT(m.match_id) AS games_played
FROM Teams t
JOIN Matches m ON t.team_id IN (m.team1_id, m.team2_id)
GROUP BY t.team_name
ORDER BY games_played DESC;

--ממוצע שערים למשחק לכל קבוצה:
SELECT t.team_name, 
       ROUND(AVG(CASE WHEN t.team_id = m.team1_id THEN m.score_team1 ELSE m.score_team2 END), 2) AS avg_goals
FROM Teams t
JOIN Matches m ON t.team_id IN (m.team1_id, m.team2_id)
GROUP BY t.team_name
ORDER BY avg_goals DESC;


--רשימת שחקנים שנולדו בחודש מסוים (למשל ינואר):
SELECT name, birth_date
FROM Players
WHERE EXTRACT(MONTH FROM birth_date) = 1;


-- שמות הקבוצות עם מספר השחקנים הצעירים שלהן בני פחות מ25
SELECT t.team_name, 
       COUNT(p.player_id) AS young_players
FROM Teams t
JOIN Players p ON t.team_id = p.team_id
WHERE EXTRACT(YEAR FROM AGE(p.birth_date)) < 25
GROUP BY t.team_name
ORDER BY young_players DESC;

--שחקנים שהבקיעו יותר מממוצע כללי של שערים
SELECT name, goals
FROM Players
WHERE goals > (
    SELECT AVG(goals)
    FROM Players
)
ORDER BY goals DESC;

-- תאריכים שבהם התקיימו יותר מ־2 משחקים
SELECT match_date, COUNT(*) AS match_count
FROM Matches
GROUP BY match_date
HAVING COUNT(*) > 2
ORDER BY match_count DESC;


--השלב עם הכי הרבה משחקים
SELECT ts.name AS stage_name, COUNT(m.match_id) AS total_matches
FROM TournamentStages ts
JOIN Matches m ON ts.stage_id = m.stage_id
GROUP BY ts.name
ORDER BY total_matches DESC
LIMIT 1;

--ערים שבהן נערכו משחקים עם קיבולת אצטדיון מעל 50,000
SELECT DISTINCT s.city, s.name AS stadium_name, s.capacity
FROM Stadiums s
JOIN Matches m ON s.stadium_id = m.stadium_id
WHERE s.capacity > 50000
ORDER BY s.capacity DESC;




--מחיקת כל המשחקים שהתקיימו ביום ה1 לחודש
DELETE FROM Matches
WHERE EXTRACT(DAY FROM match_date) = 1;

--מחיקת שחקנים שלא שובצו לשום משחק 
DELETE FROM Players
WHERE player_id NOT IN (
  SELECT DISTINCT player_id FROM PlayersInMatches
);

--מחיקת אצטדיונים שלא נערכו בהם משחקים
DELETE FROM Stadiums
WHERE stadium_id NOT IN (
  SELECT DISTINCT stadium_id FROM Matches
  WHERE stadium_id IS NOT NULL
);




--עדכון שחקנים שנולדו לפני שנת 1995 למעמד "וותיק"
UPDATE Players
SET position = 'Veteran - ' || position
WHERE EXTRACT(YEAR FROM birth_date) < 1995;


--עדכון עמדות של שחקנים מבוגרים שמעל גיל 40
UPDATE Players
SET position = 'Retired'
WHERE DATE_PART('year', AGE(CURRENT_DATE, birth_date)) > 40;

--עדכון דירוג קבוצות לפי ביצועים בשנת 2024 בשיטת דירוג מותאמת (ככל שהמספר גבוה יותר – הקבוצה טובה יותר)
UPDATE Teams
SET fifa_ranking = 
    CASE
        -- קבוצה עם יותר מ-3 ניצחונות ב-2024 → תעלה בדירוג (המספר יגדל)
        WHEN team_id IN (
            SELECT team_id
            FROM (
                SELECT team1_id AS team_id
                FROM Matches
                WHERE score_team1 > score_team2 AND EXTRACT(YEAR FROM match_date) = 2024
                UNION ALL
                SELECT team2_id AS team_id
                FROM Matches
                WHERE score_team2 > score_team1 AND EXTRACT(YEAR FROM match_date) = 2024
            ) AS wins
            GROUP BY team_id
            HAVING COUNT(*) > 3
        ) THEN 
            CASE
                WHEN fifa_ranking + 20 > 211 THEN 211
                ELSE fifa_ranking + 20
            END
        
        -- קבוצה עם יותר מ-3 הפסדים ב-2024 → תרד בדירוג (המספר יקטן)
        WHEN team_id IN (
            SELECT team_id
            FROM (
                SELECT team1_id AS team_id
                FROM Matches
                WHERE score_team1 < score_team2 AND EXTRACT(YEAR FROM match_date) = 2024
                UNION ALL
                SELECT team2_id AS team_id
                FROM Matches
                WHERE score_team2 < score_team1 AND EXTRACT(YEAR FROM match_date) = 2024
            ) AS losses
            GROUP BY team_id
            HAVING COUNT(*) > 3
        ) THEN 
            CASE
                WHEN fifa_ranking - 15 < 164 THEN 164
                ELSE fifa_ranking - 15
            END

        ELSE fifa_ranking
    END;
