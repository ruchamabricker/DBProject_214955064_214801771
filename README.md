# Project Report

### Submitted by:
- Michal Yerushalmi 214955064
- Ruchama Bricker 214801771

### System: Sports Competitions Management

### Project Title:
**The Ultimate World Cup**

---

## 📁 Stages

- [Stage 1 Report](#stage-1)
- [Stage 2 Report](#stage-2)
- [Stage 3 Report](#stage-3)
- [Stage 4 Report](#stage-4)
- [Stage 5 Report](#stage-5)


---

## Stage 1

## Table of Contents:
1. [Introduction](#introduction-1)
2. [Diagrams](#diagrams)
3. [Design Decisions](#design-decisions)
4. [Data Insertion](#data-insertion)
5. [Backup and Restore](#backup-and-restore)
6. [System Requirements](#system-requirements)
7. [System Interfaces](#system-interfaces)
8. [Use Cases](#use-cases)

---

## Introduction 1

The system focuses on managing sports competitions. The data stored in the system includes information about tournament matches, players, teams, stages, and match statuses.

The system provides the following functionalities:
- Creating matches between teams
- Managing players and teams in the tournament
- Managing tournament stages (e.g., group stage, quarter-finals, semi-finals, finals)
- Updating match results

The system operates on a **PostgreSQL** database.

---

## Diagrams

The following diagrams illustrate the data structure and relationships between tables:

### ERD (Entity Relationship Diagram)
![ERD](stage%201/ERD/UltimateWorldCup.png)

### DSD (Data Structure Diagram)
![DSD](stage%201/DSD/UltimateWorldCupScheme.png)

---

## Design Decisions

During system planning, several design decisions were made:
- Each match has a unique identifier (match_id) to facilitate result management and match status tracking.
- A separate table for players, linked to teams and matches.
- Tournament stages are stored in a separate table (stages) to allow easy updates and management of multiple tournaments simultaneously.

---

## Data Insertion

Data insertion was carried out using three different methods:

1. **Importing from files (Mockaroo):**
    - We used **Mockaroo** to generate CSV-formatted data.
    - ![Mockaroo Data Import](stage%201/Filesmockaroo/MOCK_DATA_teams_screen_shut.png)

2. **Programming (Python):**
    - Python scripts were used to generate and insert data into the tables.
    - ![Python Script](stage%201/Programing/events_screen_shot.png)

3. **Importing from files (Generatedata):**
    - We used **Generatedata** to create CSV-formatted data.
    - ![SQL Import](stage%201/generatedataFiles/players_screen_shot.png)

---

## Backup and Restore

We performed data backups using **pg_dump** and restored data using **pg_restore**:

1. **Data Backup:**
    - ![SQL Import](stage%201/backupFiles/backup_screen_shot.png)
   
2. **Data Restore:**
    - ![SQL Import](stage%201/backupFiles/restore_screen_shot.png)

---

## System Requirements
- Database system: **PostgreSQL 14+**
- Programming language: **Python 3.8+** (for scripting)
- Data generation tools: **Mockaroo, Generatedata**
- Supported operating systems: **Windows/Linux**

---

## System Interfaces
- **Tournament Management Interface** – Create new tournaments and update existing data.
- **Teams and Players Management Interface** – Update and edit players and teams.
- **Match Results Entry Interface** – Add match results and update tournament stages.

---

## Use Cases
1. **Adding a New Tournament:**
   - The user accesses the management system, clicks "Add Tournament," enters the name and dates, and confirms.
   
2. **Entering Match Results:**
   - The user selects a match from the table, enters the result, and clicks "Save."
   
3. **Updating Team Details:**
   - The admin searches for a team by name, edits the player list, and clicks "Update."
---

## Stage 2

---

### 📚 Table of Contents:
1. [Introduction 2](#introduction-2)
2. [SELECT Queries](#select-queries)
3. [UPDATE Queries](#update-queries)
4. [DELETE Queries](#delete-queries)
5. [Constraints](#constraints)

---

## Introduction 2

This stage focuses on interacting with the database using SQL queries. It includes complex SELECT, UPDATE, and DELETE queries along with added **constraints** to ensure data integrity. Each part is documented with screenshots of both the query and the result.

---

## SELECT Queries

Each query includes a description, screenshot of the query execution, and the result (up to 5 rows).

---

### 1. קבוצות ששיחקו הכי הרבה משחקים בטורניר

### תיאור:
שאילתה זו מציגה את שמות הקבוצות שסך כל המשחקים שלהן בטורניר הוא הגבוה ביותר. היא סופרת לכל קבוצה את מספר הפעמים שהופיעה כקבוצה ראשונה או שנייה במשחקים, ומסדרת את התוצאה מהקבוצה עם הכי הרבה משחקים והלאה.


### מטרה:
מאפשר להבין אילו קבוצות היו פעילות במיוחד לאורך שלבי הטורניר.
### שאילתת SQL:
```sql
SELECT t.team_name, COUNT(m.match_id) AS games_played
FROM Teams t
JOIN Matches m ON t.team_id IN (m.team1_id, m.team2_id)
GROUP BY t.team_name
ORDER BY games_played DESC;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_queries/queries/q1.png)

### תמונת מסך של התוצאה

- ![SQL Import](stage%202/screenshots_queries/output/q1.png)

---

### 2. ממוצע שערים למשחק לכל קבוצה

### תיאור:
שאילתה זו מחשבת את ממוצע השערים שכל קבוצה כבשה למשחק. היא בודקת האם הקבוצה הופיעה כקבוצה ראשונה או שנייה, ומחשבת את השערים בהתאם.

### מטרה:
ניתוח התקפי של כל קבוצה – אילו קבוצות היו בעלות התקפה חזקה יותר לאורך הטורניר.

### שאילתת SQL:
```sql
SELECT t.team_name, 
       ROUND(AVG(CASE WHEN t.team_id = m.team1_id THEN m.score_team1 ELSE m.score_team2 END), 2) AS avg_goals
FROM Teams t
JOIN Matches m ON t.team_id IN (m.team1_id, m.team2_id)
GROUP BY t.team_name
ORDER BY avg_goals DESC;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_queries/queries/q2.png)

### תמונת מסך של התוצאה

- ![SQL Import](stage%202/screenshots_queries/output/q2.png)

---

### 3. רשימת שחקנים שנולדו בחודש מסוים (ינואר)

### תיאור:
שאילתה זו מחזירה את רשימת השחקנים שנולדו בחודש ינואר לפי תאריך הלידה שלהם.

### מטרה:
יכול לשמש לניתוח דפוסי גיל או אפילו לבדיקה אנקדוטלית של תופעת "אפקט גיל ראש השנה" בספורט.

### שאילתת SQL:
```sql
SELECT name, birth_date
FROM Players
WHERE EXTRACT(MONTH FROM birth_date) = 1;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_queries/queries/q3.png)

### תמונת מסך של התוצאה

- ![SQL Import](stage%202/screenshots_queries/output/q3.png)

---

### 4. שמות הקבוצות עם מספר השחקנים הצעירים שלהן (מתחת לגיל 25)

### תיאור:
השאילתה מציגה את שמות הקבוצות יחד עם מספר השחקנים הצעירים (מתחת לגיל 25) בכל קבוצה. המטרה היא לזהות אילו קבוצות נשענות על סגל צעיר, מה שיכול להעיד על השקעה בדור העתיד או סגנון משחק מהיר ודינמי.

### מטרה:
מאפשרת לזהות אילו קבוצות מתבססות יותר על סגל צעיר ודינמי.

### שאילתת SQL:
```sql
SELECT t.team_name, 
       COUNT(p.player_id) AS young_players
FROM Teams t
JOIN Players p ON t.team_id = p.team_id
WHERE EXTRACT(YEAR FROM AGE(p.birth_date)) < 25
GROUP BY t.team_name
ORDER BY young_players DESC;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_queries/queries/q4.png)

### תמונת מסך של התוצאה

- ![SQL Import](stage%202/screenshots_queries/output/q4.png)

---

### 5. שחקנים שהבקיעו יותר מהממוצע הכללי של שערים

### תיאור:
שאילתה זו מציגה את כל השחקנים שכבשו מספר שערים הגבוה מהממוצע הכללי בטורניר.

### מטרה:
מסייעת לזהות שחקנים מצטיינים ביחס לביצועים הכלליים של כלל המשתתפים.

### שאילתת SQL:
```sql
SELECT name, goals
FROM Players
WHERE goals > (
    SELECT AVG(goals)
    FROM Players
)
ORDER BY goals DESC;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_queries/queries/q5.png)

### תמונת מסך של התוצאה

- ![SQL Import](stage%202/screenshots_queries/output/q5.png)

---

### 6. תאריכים שבהם התקיימו יותר מ־2 משחקים

### תיאור:
השאילתה בודקת אילו תאריכים היו עמוסים במיוחד במשחקים – כלומר תאריכים שבהם התקיימו יותר משני משחקים.

### מטרה:
עוזרת בזיהוי עומסי פעילות בטורניר – עשוי לשמש לתכנון לוגיסטי עתידי או ניתוח צפיפות לוחות זמנים.

### שאילתת SQL:
```sql
SELECT match_date, COUNT(*) AS match_count
FROM Matches
GROUP BY match_date
HAVING COUNT(*) > 2
ORDER BY match_count DESC;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_queries/queries/q6.png)

### תמונת מסך של התוצאה

- ![SQL Import](stage%202/screenshots_queries/output/q6.png)

---

### 7. השלב עם הכי הרבה משחקים

### תיאור:
שאילתה זו מציגה את שם שלב הטורניר שבו התקיימו הכי הרבה משחקים (למשל שלב הבתים).

### מטרה:
מאפשרת להבין באיזה שלב היה נפח הפעילות המרכזי של הטורניר – לרוב שלב הבתים מכיל יותר משחקים.

### שאילתת SQL:
```sql
SELECT ts.name AS stage_name, COUNT(m.match_id) AS total_matches
FROM TournamentStages ts
JOIN Matches m ON ts.stage_id = m.stage_id
GROUP BY ts.name
ORDER BY total_matches DESC
LIMIT 1;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_queries/queries/q7.png)

### תמונת מסך של התוצאה

- ![SQL Import](stage%202/screenshots_queries/output/q7.png)

---

### 8. ערים שבהן נערכו משחקים באצטדיונים עם קיבולת מעל 50,000

### תיאור:
שאילתה זו מחפשת את הערים שבהן נערכו משחקים באצטדיונים גדולים במיוחד (מעל 50,000 מקומות).

### מטרה:
מאפשרת לנתח באילו מקומות נערכו משחקים באירוח המוני – אינדיקציה לפופולריות, ביקוש, ותכנון נכון של תשתיות.

### שאילתת SQL:
```sql
SELECT DISTINCT s.city, s.name AS stadium_name, s.capacity
FROM Stadiums s
JOIN Matches m ON s.stadium_id = m.stadium_id
WHERE s.capacity > 50000
ORDER BY s.capacity DESC;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_queries/queries/q8.png)

### תמונת מסך של התוצאה

- ![SQL Import](stage%202/screenshots_queries/output/q8.png)

---

### UPDATE Queries

---

### 1. עדכון מעמד שחקנים שנולדו לפני 1995 ל"וותיק"

### תיאור:
השאילתה מעדכנת את המעמד של שחקנים שנולדו לפני שנת 1995 כך שהתיאור "Veteran - " יתווסף לפני העמדה שלהם.

### מטרה:
מאפשרת לסמן שחקנים ותיקים בעלי ניסיון, לצורך סינון, תצוגה או ניתוח של גילאי הסגל.

### שאילתת SQL:
```sql
UPDATE Players
SET position = 'Veteran - ' || position
WHERE EXTRACT(YEAR FROM birth_date) < 1995;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_updates/query/q1.png)

### תמונת מסך לפני התוצאה

- ![SQL Import](stage%202/screenshots_updates/before/q1.png)

### תמונת מסך אחרי התוצאה

- ![SQL Import](stage%202/screenshots_updates/after/q1.png)

---

### 2. עדכון עמדות של שחקנים מעל גיל 40 ל-"Retired"

### תיאור:
השאילתה מעדכנת את העמדה של שחקנים שגילם מעל 40 לשם "Retired", כדי לשקף שהם כבר לא פעילים.

### מטרה:
מאפשרת זיהוי ברור של שחקנים שיצאו לגמלאות לצורכי ניתוח או סינון מתוך מאגר השחקנים.

### שאילתת SQL:
```sql
UPDATE Players
SET position = 'Retired'
WHERE DATE_PART('year', AGE(CURRENT_DATE, birth_date)) > 40;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_updates/query/q2.png)

### תמונת מסך לפני התוצאה

- ![SQL Import](stage%202/screenshots_updates/before/q2.png)

### תמונת מסך אחרי התוצאה

- ![SQL Import](stage%202/screenshots_updates/after/q2.png)

---

### 3. עדכון דירוג פיפ"א לכל הקבוצות על פי מספר הניצחונות בשנת 2024, ללא כפילויות בדירוג (1 – דירוג גבוה ביותר, 48 – הנמוך ביותר)

### תיאור:
שאילתה זו מעדכנת את דירוג הפיפ"א של כל 48 הקבוצות לפי מספר הניצחונות שלהן בשנת 2024. הקבוצה עם הכי הרבה ניצחונות תקבל דירוג 1 (הגבוה ביותר), והקבוצה עם הכי מעט תקבל דירוג 48 (הנמוך ביותר). דירוגים לא חוזרים על עצמם.

### מטרה:
לדרג את הקבוצות בצורה מדויקת ותחרותית לפי ביצועיהן בפועל בטורניר, באופן שמבטיח דירוג ייחודי לכל קבוצה.


### שאילתת SQL:
```sql
WITH team_wins AS (
  SELECT team_id,
         COUNT(*) AS wins
  FROM (
    SELECT team1_id AS team_id
    FROM Matches
    WHERE score_team1 > score_team2 AND EXTRACT(YEAR FROM match_date) = 2024
    UNION ALL
    SELECT team2_id AS team_id
    FROM Matches
    WHERE score_team2 > score_team1 AND EXTRACT(YEAR FROM match_date) = 2024
  ) AS all_wins
  GROUP BY team_id
),
ranked_teams AS (
  SELECT t.team_id,
         COALESCE(w.wins, 0) AS wins,
         ROW_NUMBER() OVER (ORDER BY COALESCE(w.wins, 0) DESC, t.team_id) AS new_rank
  FROM Teams t
  LEFT JOIN team_wins w ON t.team_id = w.team_id
)
UPDATE Teams
SET fifa_ranking = ranked_teams.new_rank
FROM ranked_teams
WHERE Teams.team_id = ranked_teams.team_id;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_updates/query/q3.png)

### תמונת מסך לפני התוצאה

- ![SQL Import](stage%202/screenshots_updates/before/q3.png)

### תמונת מסך אחרי התוצאה

- ![SQL Import](stage%202/screenshots_updates/after/q3.png)

---

### DELETE Queries

---

### 1. מחיקת משחקים שהתקיימו ביום הראשון של החודש

### תיאור:
השאילתה מוחקת מהמערכת את כל המשחקים שהתרחשו ביום הראשון של כל חודש, ללא תלות בחודש או בשנה.

### מטרה:
מאפשרת ניקוי נתונים ממועדים שאינם רלוונטיים לניתוח – לדוגמה, תאריכים בהם התקיימו משחקי ראווה או ניסוי.

### שאילתת SQL:
```sql
DELETE FROM Matches
WHERE EXTRACT(DAY FROM match_date) = 1;
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_deletes/query/q1.png)

### תמונת מסך לפני התוצאה

- ![SQL Import](stage%202/screenshots_deletes/before_delete/q1.png)

### תמונת מסך אחרי התוצאה

- ![SQL Import](stage%202/screenshots_deletes/after_delete/q1.png)

---

### 2. מחיקת שחקנים שלא השתתפו באף משחק

### תיאור:
השאילתה מסירה מהמערכת את כל השחקנים שלא שובצו ולו פעם אחת לאף משחק.

### מטרה:
ניקוי מאגר הנתונים משחקנים לא פעילים – מאפשר תחזוקה מדויקת ויעילה של טבלאות השחקנים.

### שאילתת SQL:
```sql
DELETE FROM Players
WHERE player_id NOT IN (
  SELECT DISTINCT player_id FROM PlayersInMatches
);
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_deletes/query/q2.png)

### תמונת מסך לפני התוצאה

- ![SQL Import](stage%202/screenshots_deletes/before_delete/q2.png)
-  ![SQL Import](stage%202/screenshots_deletes/before_delete/q2_0.png)

### תמונת מסך אחרי התוצאה

- ![SQL Import](stage%202/screenshots_deletes/after_delete/q2.png)

---

### 3. מחיקת אצטדיונים שלא נערכו בהם משחקים

### תיאור:
השאילתה מסירה אצטדיונים ממאגר הנתונים אם לא התקיים בהם אף משחק.

### מטרה:
שיפור הדיוק של הנתונים וניקוי רשומות מיותרות שאין להן שימוש מעשי בטורניר.

### שאילתת SQL:
```sql
DELETE FROM Stadiums
WHERE stadium_id NOT IN (
  SELECT DISTINCT stadium_id FROM Matches
  WHERE stadium_id IS NOT NULL
);
```

### תמונת מסך של הרצה

- ![SQL Import](stage%202/screenshots_deletes/query/q3.png)

### תמונת מסך לפני התוצאה

- ![SQL Import](stage%202/screenshots_deletes/before_delete/q3.png)

### תמונת מסך אחרי התוצאה

- ![SQL Import](stage%202/screenshots_deletes/after_delete/q3.png)

---

### 🔐 Constraints

We added constraints to ensure data integrity. Below are three examples from different tables.

---

### 1. הוספת אילוץ NOT NULL לעמודת העמדה של שחקן

### תיאור:
השאילתה מוסיפה אילוץ NOT NULL לעמודה position בטבלת השחקנים, כך שלא ניתן יהיה להזין או להשאיר שחקן ללא עמדת משחק.

### מטרה:
שמירה על תקינות המידע והבטחת שלכל שחקן תהיה עמדת משחק מוגדרת.

### שאילתת SQL:
```sql
ALTER TABLE Players
ALTER COLUMN position SET NOT NULL;
```

### שאילתת INSERT שתסתור את האילוץ:
```sql
INSERT INTO Players (team_id, name, birth_date, goals, assists)
VALUES (1, 'John Doe', '1990-04-20', 2, 1);
```

### תמונת מסך של הרצת האילוץ

- ![SQL Import](stage%202/screenshots_constraints/screenshots_query/q1.png)

### תמונת מסך של שגיאת הרצה

- ![SQL Import](stage%202/screenshots_constraints/insert/q1.png)

---

### 2. הוספת אילוץ CHECK על קיבולת אצטדיון

### תיאור:
השאילתה מוסיפה אילוץ CHECK לעמודת capacity בטבלת האצטדיונים, כדי לוודא שהקיבולת היא חיובית ובעלת ערך של לפחות 1,000 מקומות.

### מטרה:
למנוע הזנת ערכים שגויים או לא סבירים בקיבולת של אצטדיון, ולשמור על אמינות הנתונים.

### שאילתת SQL:
```sql
ALTER TABLE Stadiums
ADD CONSTRAINT check_capacity_positive
CHECK (capacity >= 1000);
```

### שאילתת INSERT שתסתור את האילוץ:
```sql
INSERT INTO Stadiums (name, city, capacity)
VALUES ('Tiny Field', 'Smallville', 500);
```

### תמונת מסך של הרצת האילוץ

- ![SQL Import](stage%202/screenshots_constraints/screenshots_query/q2.png)

### תמונת מסך של שגיאת הרצה

- ![SQL Import](stage%202/screenshots_constraints/insert/q2.png)

---

### 3. הוספת ערך ברירת מחדל לדירוג פיפ״א של קבוצה

### תיאור:
השאילתה מגדירה ערך ברירת מחדל לעמודת fifa_ranking בטבלת הקבוצות (Teams), כך שכל קבוצה חדשה שתיווסף ללא דירוג מפורש תקבל דירוג התחלתי של 180.

### מטרה:
להבטיח שכל קבוצה תתחיל עם דירוג בסיסי סביר, גם אם לא הוזן ערך בעת ההוספה.

### שאילתת SQL:
```sql
ALTER TABLE Teams
ALTER COLUMN fifa_ranking SET DEFAULT 180;
```

### שאילתת INSERT שתסתור את האילוץ:
```sql
INSERT INTO Teams (team_name, coach, team_group, fifa_ranking, favorite_color)
VALUES ('Unicorn FC', 'Magical Coach', 'A', 199, 'Pink');
```

### תמונת מסך של הרצת האילוץ

- ![SQL Import](stage%202/screenshots_constraints/screenshots_query/q3.png)

### תמונת מסך של שגיאת הרצה

- ![SQL Import](stage%202/screenshots_constraints/insert/q3.png)

---

## 🧠 Notes

- All constraints were tested using invalid INSERT statements, resulting in runtime errors as expected.
- The system maintains data consistency through proper use of foreign keys, data types, and constraints.


## Stage 3

---

## Table of Contents:
1. [ERD and DSD diagrams](#erd-and-dsd-diagrams)
2. [Integration decisions](#integration-decisions)
3. [Workflow and Commands](#workflow-and-commands)
4. [Views](#views)
5. [View Queries](#view-queries)

---

## ERD and DSD diagrams

---

Below are the updated ERD and DSD diagrams after the integration phase:

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%203/ERD/erd_integration.png?raw=true)  
![DSD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%203/DSD/DSD_INTEGRATION.png?raw=true)

---

## Integration decisions

---

During the integration phase, the following decisions were made:

1. **Combining entities from both models:** All entities from our model (`Teams`, `Players`, `Matches`, `MatchEvents`, `Stadiums`, `TournamentStages`) and the new model (`Athlet`, `Sport`, `Competition`, `Country`, `Venue`, `ticket`) are included in the merged ERD diagram.
2. **Entity renaming:** The entity `TournamentStages` from our model has been renamed to `Stage` in the merged model.
3. **Creating Linking Relationships between Parallel Entities:** We added new relationships that connect entities that represent similar concepts in the two original models:
* **Relationship between `Athlet` and `Players`:** We created a relationship called `AthleteMatches` that connects the entity `Athlet` (from the new model, which represents an athlete in general) and the entity `Players` (from our model, which represents soccer players). This allows us to see that a soccer player is a specific type of athlete.
* **Relationship between `Teams` and `Country`:** We created a relationship called `TeamOfCountry` that connects the entity `Teams` (from our model, which represents teams/national teams) and the entity `Country` (from the new model, which represents countries). This makes sense because national soccer teams represent countries.
4. **Integrating specific concepts (football) into a general structure (competition):** We added relationships that integrate football-specific entities (`Matches`, `Stage`) into the more general `Competition` framework from the Olympics model:
* **Relationship between `Stage` and `Competition`:** We created a relationship called `StageInCompetition` that connects the entity `Stage` (tournament stages, such as group stage, round of 16, etc.) to the entity `Competition`. This places the tournament stages within the context of the larger competition.
5. **Preserving existing relationships and attributes:** Most of the relationships that existed in the original models (e.g. `PlayerInTeam`, `Team1InMatch`, `EventInMatch`, `SportInCompetition`, etc.) and the attributes of the entities have also been preserved in the unified model.

Overall, the main changes are adding the missing entities and relationships from each model to the unified model, and creating new relationships between the corresponding or related entities from each of the original models to create a single linked network representing the information from both domains in a single system.

see the integration file: [integration](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%203/integrations.sql)
---

## Workflow and Commands

---

```sql

--Example of creating an inheritance between a player and a team
CREATE SEQUENCE IF NOT EXISTS athlete_athleteid_seq;
ALTER TABLE athlete ALTER COLUMN athleteid SET DEFAULT nextval('athlete_athleteid_seq');
SELECT setval('athlete_athleteid_seq', (SELECT COALESCE(MAX(athleteid), 0) FROM athlete));

ALTER TABLE players ADD COLUMN athleteid INTEGER;

--Example of creating a connection between a country and a group
ALTER TABLE teams ADD COLUMN country_id INTEGER;

UPDATE teams t
SET country_id = c.countryid
FROM country c
WHERE t.team_name = c.countryname;

--Example of adding a relationship between a team and a country
ALTER TABLE teams
ADD CONSTRAINT teams_country_id_fkey
FOREIGN KEY (country_id)
REFERENCES country(countryid)
ON DELETE SET NULL;

--Example of adding a relationship between a player and an athlete
ALTER TABLE players
ADD CONSTRAINT player_athlete_id_fkey
FOREIGN KEY (athleteid)
REFERENCES athlete(athleteid)
ON DELETE SET NULL;

```

---

## Views

---

### View 1# - view_athletes_matches

**Description**:
This view, view_athletes_matches, provides a summary of athlete participation in matches. It shows each athlete's name and ID, the match they participated in (by ID and date), their rank in the match, any medal they received, and whether they played as a substitute.

```sql
CREATE OR REPLACE VIEW view_athletes_matches AS
SELECT
    am.athlete_id,
    a.athlete_name,
    am.match_id,
    m.match_date,
    am.athlete_rank,
    am.medal,
    am.is_substitute
FROM athlete_match am
JOIN athletes a ON am.athlete_id = a.athlete_id
JOIN matches m ON am.match_id = m.match_id;
```

### Retrieving data from it with select *

```sql
SELECT * FROM public.view_athletes_matches
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%203/Views/athlete_matches_view.png)  

---

### View 2# - view_competition_stages

**Description**:
This view, view_competition_stages, displays the stages within each competition. It includes the competition's ID, name, and date, along with the corresponding stage's ID, name, and start date. It helps link each competition to its individual stages.

```sql
CREATE OR REPLACE VIEW view_competition_stages AS
SELECT
    c.competition_id,
    c.competition_name,
    c.comp_date,
    s.stage_id,
    s.name,
    s.start_date
FROM competitions c
JOIN stages s ON c.competition_id = s.competition_id;
```

### Retrieving data from it with select *

```sql
SELECT * FROM public.view_competition_stages
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%203/Views/view_competition_stages.png)  

---

## View Queries

---

### Query 1: 

**Description**:
This query retrieves a list of athletes who participated in matches as substitutes. It selects the athlete's name, the match ID, and confirms that the athlete was a substitute by filtering only rows where is_substitute = true from the view_athletes_matches view.

```sql
SELECT athlete_name, match_id, is_substitute
FROM view_athletes_matches
WHERE is_substitute = true;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%203/Views/q1.png)  

---

### Query 2: 

**Description**:
This query returns a list of athletes who received medals in matches. It selects the athlete’s name, match ID, rank in the match, and the medal they received. Only records where a medal is present (medal IS NOT NULL) are included, and the results are sorted by athlete_rank in ascending order.

```sql
SELECT athlete_name, match_id, athlete_rank, medal
FROM view_athletes_matches
WHERE medal IS NOT NULL
ORDER BY athlete_rank;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%203/Views/q2.png)  

---

### Query 3: 

**Description**:
This query retrieves the names and start dates of all stages that belong to the competition with ID 1. The results are ordered by start_date in ascending order, showing the timeline of the competition's stages.

```sql
SELECT name, start_date
FROM view_competition_stages
WHERE competition_id = 1
ORDER BY start_date;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%203/Views/q3.png)  

---

### Query 4: 

**Description**:
This query returns the number of stages for each competition. It selects the competition name and counts how many stages (stage_id) are associated with it. The results are grouped by competition_name and sorted in descending order by the number of stages (total_stages).

```sql
SELECT competition_name, COUNT(stage_id) AS total_stages
FROM view_competition_stages
GROUP BY competition_name
ORDER BY total_stages DESC;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%203/Views/q4.png)  

---

## Stage 4

---

## Table of Contents:
1. [Functions](#functions)
2. [Procedures](#procedures)
3. [Triggers](#triggers)
4. [Main programs](#main-programs)
5. [Proofs](#proofs)

---

## Functions

---

### Function #1 - get_total_goals

**Description**:
This function, get_total_goals, takes an athlete's ID as input and returns the total number of goals scored by that athlete, based on data from the players table. If an error occurs, it returns 0 and logs the error message.

```sql
CREATE OR REPLACE FUNCTION get_total_goals(ath_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    total_goals INTEGER;
BEGIN
    SELECT COALESCE(SUM(goals), 0)
    INTO total_goals
    FROM players
    WHERE athlete_id = ath_id;

    RETURN total_goals;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in get_total_goals: %', SQLERRM;
        RETURN 0;
END;
$$ LANGUAGE plpgsql;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%204/Functions/f1.png) 

---

### Function #2 - get_country_info

**Description**:
This function, get_country_info, takes a country name as input and returns a cursor pointing to all rows in the country table where the country name matches the input (case-insensitive). If an error occurs, it logs the error and returns NULL.

```sql
CREATE OR REPLACE FUNCTION get_country_info(country_name_in TEXT)
RETURNS REFCURSOR AS $$
DECLARE
    ref refcursor;
BEGIN
    OPEN ref FOR
    SELECT *
    FROM country
    WHERE country_name ILIKE country_name_in;

    RETURN ref;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in get_country_info: %', SQLERRM;
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%204/Functions/f2.png) 

---

## Procedures

---

### Procedure #1 - update_fifa_ranking

**Description**:
This procedure, update_fifa_ranking, takes a team ID and a new FIFA ranking as input, and updates the corresponding team's ranking in the teams table. If an error occurs, it logs the error message.

```sql
CREATE OR REPLACE PROCEDURE update_fifa_ranking(team_id_in INTEGER, new_rank INTEGER)
AS $$
BEGIN
    UPDATE teams
    SET fifa_ranking = new_rank
    WHERE team_id = team_id_in;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in update_fifa_ranking: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%204/Producers/p1.png) 

---


### Procedure #2 - assign_medal

**Description**:
The assign_medal procedure assigns a medal to an athlete for a specific match. If a record already exists for the athlete and match in the athlete_match table, it updates the medal. Otherwise, it inserts a new record with the given medal. If an error occurs, it logs the error message.

```sql
CREATE OR REPLACE PROCEDURE assign_medal(
    ath_id INTEGER,
    match_id_in INTEGER,
    medal_type VARCHAR
)
AS $$
DECLARE
    exists_record BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM athlete_match
        WHERE athlete_id = ath_id AND match_id = match_id_in
    )
    INTO exists_record;

    IF exists_record THEN
        UPDATE athlete_match
        SET medal = medal_type
        WHERE athlete_id = ath_id AND match_id = match_id_in;
    ELSE
        INSERT INTO athlete_match(athlete_id, match_id, medal, athlete_rank, is_substitute)
        VALUES (ath_id, match_id_in, medal_type, NULL, FALSE);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in assign_medal: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%204/Producers/p2.png) 

---

## Triggers

---

### Trigger #1 - update_country_medals

**Description**:
The update_country_medals trigger function updates the total number of medals for a country when a new medal is assigned to an athlete. The trigger trg_update_medals runs this function automatically after a new row with a non-null medal is inserted into the athlete_match table. If an error occurs, it logs the error and continues.

```sql
CREATE OR REPLACE FUNCTION update_country_medals()
RETURNS TRIGGER AS $$
DECLARE
    c_id INTEGER;
BEGIN
    SELECT country_id INTO c_id
    FROM athletes
    WHERE athlete_id = NEW.athlete_id;

    UPDATE countries
    SET total_medals = COALESCE(total_medals, 0) + 1
    WHERE country_id = c_id;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in update_country_medals: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_update_medals
AFTER INSERT ON athlete_match
FOR EACH ROW
WHEN (NEW.medal IS NOT NULL)
EXECUTE FUNCTION update_country_medals();
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%204/Triggers/t1.png) 

---

### Trigger #2 - check_teams_different

**Description**:
The check_teams_different trigger function ensures that a match does not have the same team assigned to both sides. If team1_id and team2_id are equal, it raises an exception. The trigger trg_check_teams runs this function before a new match is inserted into the matches table. If an error occurs, it logs the error and proceeds.

```sql
CREATE OR REPLACE FUNCTION check_teams_different()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.team1_id = NEW.team2_id THEN
        RAISE EXCEPTION 'A team cannot play against itself';
    END IF;
    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in check_teams_different: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_teams
BEFORE INSERT ON matches
FOR EACH ROW
EXECUTE FUNCTION check_teams_different();
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%204/Triggers/t2.png) 

---

## Main programs

---

### Main program #1

**Description**:
This anonymous PL/pgSQL block calls the update_fifa_ranking procedure to update the FIFA ranking of team 1 to 15, then calls the get_total_goals function to calculate the total goals scored by athlete 405. It displays the result with a notice. If any error occurs during execution, it logs the error message.

```sql
DO $$
DECLARE
    total INTEGER;
BEGIN
    CALL update_fifa_ranking(1, 15);
    total := get_total_goals(405);
    RAISE NOTICE 'Total goals: %', total;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in main block 1: %', SQLERRM;
END;
$$;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%204/Main%20programs/m1.png) 

---

### Main program #2

**Description**:
This anonymous PL/pgSQL block calls the assign_medal procedure to assign a gold medal to athlete 1 for match 1, then retrieves information about the country "Egypt" using the get_country_info function. It loops through the result set, printing each country's name and total medals. If an error occurs, it logs the error message.

```sql
DO $$
DECLARE
    ref refcursor;
    rec RECORD;
BEGIN
    CALL assign_medal(1, 1, 'GOLD');
    ref := get_country_info('Egypt');

    LOOP
        FETCH ref INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Country: %, Medals: %', rec.country_name, rec.total_medals;
    END LOOP;

    CLOSE ref;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in main block 2: %', SQLERRM;
END;
$$;
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%204/Main%20programs/m2.png) 

---

## Proofs

---

**Description**:
This confirms that running this query correctly throws the expected exception.

```sql
INSERT INTO matches(match_id, team1_id, team2_id)
VALUES (100, 5, 5);
```

### Output example

![ERD](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%204/Proofs/p2.png) 

---

## Stage 5

---

## Table of Contents:
1. [User Guide](#user-guide)
2. [App Development](#app-development)

---

## User Guide

---

Welcome to the **Sports App**! 

This application allows you to view, manage, and explore information about athletes and matches in a clean and intuitive interface.

---

### Home Screen

The home screen is the landing page of the app.

It gives you a quick overview and easy access to the main sections: Athletes and Matches.

Use the buttom navigation bar to move between sections.

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/1.png) 

---

### Athletes Screen

This screen displays a list of all the athletes in the system.

Each athlete card includes key details such as:

Full name, Age, Gender, Country

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/2.png) 

### Search & Filter Options

At the top of the screen, you can filter athletes using several criteria:

**Search by Name or Country:** Type into the search bar to instantly filter athletes by their full name or country.

**Filter by Birth Month:** Select a month to see athletes who were born in that month.

This feature uses a custom SQL query implemented in Stage 2 of the project.

**Filter by Gender:** Choose to display - Only male athletes, Only female athletes Or all athletes (default).

These filters can be combined to refine your results. 

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/18.png) 

---

### Athlete Profile Page

This page provides a detailed view of a specific athlete’s information, including personal details and match history.

It is designed for managers and coaches who have full access to view and edit athlete data.

---

**Page Layout & Functionality**

**Back Button:** A button at the top-left corner returns to the full Athletes list.

**Athlete Details (Header):** At the top of the page:

The athlete's full name is displayed.

If the athlete is a football player, a tag like "World Cup Football Player" is shown.

The country or team name appears below.

**Tabs**

There are two tabs on the page:

**Personal Info Tab (default open)**

Displays the athlete’s personal and team information:

Name, Gender, Birthdate, Country (or Team name if a football player)
 
For football players only: Team name, Coach name, Home group, FIFA ranking

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/3.png) 

---

**Edit Athlete Info**

Managers and coaches can click the green edit button to open a modal popup.

You can update the athlete’s name, gender, birthdate, and country.

Changes are saved with a POST request to /athlete/update/{{ athlete.id }}.

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/5.png) 

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/6.png) 

---

**Delete Athlete**

A red delete button allows permanent removal of the athlete.

Deletion is confirmed via popup. After deleting an athlete you get back to all athletes.

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/10.png) 

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/11.png) 

---

**Matches Tab**

Lists all matches the athlete has participated in.

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/9.png) 

If the athlete is a football player, the system also displays:

Total number of goals - that is implemented with one of our functions from stage 4.

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/19.png) 

Match details including:

Date, Sport, Competition, Stage, Venue, Tickets Sold, Ticket Price

🔽 Expand Match Details 
Clicking a row shows detailed results and participants:

For team sports:

Lists each team, coach, scores, and the winner or **Draw**.

For individual sports:

Lists all competing athletes with:

Name, Country, Rank, and Medal

Winner is shown at the bottom

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/4.png) 

---

**Assign Medal**

If the viewed athlete participated in an individual match:

You can assign or change the current athlete`s medal using a dropdown.

Options: Gold, Silver, Bronze

Submit via POST to /athlete/assign_medal/{{ athlete.id }} with the match ID.  

We did this with our procedure from stage 4.

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/7.png) 

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/8.png) 

---

### Matches Page

This page displays all the matches available in the system, each represented as a compact, clickable card. The goal is to present key match information at a glance, while allowing the user to click and explore full match details if needed.

Each card includes:

**Date:** The date the match took place or will take place.

**Venue:** The name of the venue where the match was held or will be held.

**Competition:** The name of the competition or tournament (e.g., World Cup Football, European Championship).

**Stage:** The stage of the competition (e.g., "Group Stage", "Semi-Final", "Final").

**Sport:** The type of sport (e.g., football, athletics, tennis).

All this info is pulled dynamically using templating:

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/12.png) 

---

### Match Details Page

This page presents detailed information about a specific match or event. It's designed to help users view all relevant match data, team or athlete details, and even purchase tickets.

Underneath the main title, the page displays structured data about the match:

**Date:** The date the match takes place.

**Venue:** The venue's name and capacity (number of seats available).

**Venue ID:** An internal identifier used in the system.

**Sport:** The sport being played (e.g., Football, Swimming).

**Competition:** The competition name (e.g., "World Cup Football", "Olympics").

**Stage:** The stage in the competition (e.g., Quarterfinal, Final).

**Tickets Sold:** Number of tickets already sold for this match.

**Ticket Price:** How much it costs to buy a ticket.

### Team or Athlete Display (Based on Sport Type)

The page dynamically adjusts based on whether the match is a team sport or an individual sport.

If it’s a team sport:

You’ll see a "Teams" section, listing all teams:

Team name, Coach name, Score.

The winning team is highlighted in green to indicate they won.

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/13.png) 

### Ticket Purchase (Buy a Ticket)

At the top center, there is a "Buy a ticket" button (green). Clicking this opens a modal window (a popup form) for purchasing a ticket.

Inside the modal: You see the ticket price.

Press "Purchase" to buy the ticket.

Press "Cancel" to close the popup without purchasing.

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/14.png) 

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/15.png) 

**You can see that now the number of tickets sold has increased from 6 to 7.**

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/16.png) 

---

### If it’s an individual sport:

You’ll see an "Athletes" section:

Athlete name, Country, Rank

Medal earned (Gold/Silver/Bronze/None)

At the end, the winner’s name is shown clearly.

![screen-shots](https://github.com/ruchamabricker/DBProject_214955064_214801771/blob/master/stage%205/screan_shots/17.png) 

---

### Back Navigation

At the top-left of the page, a button allows the user to return to the Matches Page.

---

## App Development:

### Tools & Process

---

## Flask + HTML + PostgreSQL App

This web application was built using **Python** with **Flask** and **HTML**, connected to a **PostgreSQL** database via **pgAdmin**. The system supports full CRUD operations and executes SQL queries and stored procedures, as part of a full-stack academic project.

---

## 🔧 Technologies Used

🐍 **Python** – Main backend language  

🌐 **Flask** – Micro web framework for routing and logic  

🖼️ **HTML + CSS** – User interface and styling  

🐘 **PostgreSQL** – Relational database  

🧰 **pgAdmin** – GUI for managing PostgreSQL  

🔌 **SQLAlchemy** – For connecting Python to the database  

⚙️ **JavaScript** – For frontend interactivity  

---

## Features and Workflow

### 1. Database Structure

At least **3 tables** in the database

Includes a **junction table** linking two other tables

All relationships implemented with foreign keys

Stored procedures and functions were written in earlier stages

### 2. Backend with Flask

Flask handles server-side logic and routing

SQL queries are executed using psycopg2

Example route:
  
python
  @app.route('/insert_user', methods=['GET', 'POST'])
  def insert_user():
      ...

### 3. Frontend

Built using HTML templates (Jinja2 engine)
Each screen has its own form for user input
Clean and minimal UI with custom styling using CSS

### 4. CRUD Functionality

Supports the four basic database operations on at least **3 tables**:

**Create** – Buy a ticket to a match  
**Read** – Display matches and athletes  
**Update** – Edit the athlete's personal details or set their medal for a specific match 
**Delete** – Delete a player or athlete


### 5. SQL Queries & Procedures
A dedicated screen allows:

✅ Running 2 SQL queries from stage 2

### Query 1: Athletes Born in a Given Month
This query retrieves all athletes who were born in a specific month. If no month is given, it returns all athletes. It also calculates each athlete's age and includes the name of their country.

```sql
SELECT name, birth_date
FROM Players
WHERE EXTRACT(MONTH FROM birth_date) = 1;
```
### Query 2: Match Details and Contextual Information
This SQL query retrieves full details about a specific match, including contextual information from related entities. It joins data across matches, venues, stages, competitions, and sports.

Returned fields include:

Match ID and date

Venue name and capacity

Sport, competition, and stage names

Team IDs and scores (if it's a team-based match)

A computed boolean field is_team_sport that checks whether the match is between two teams (based on team1_id)

Full query (used inside match view route):

```sql
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
    WHERE m.match_id = 402
```
This query enables displaying rich information about any given match, and is used in the route:
/match/<match_id> or within athlete-related match views.

✅ Executing 2 procedures or functions from stage 4

### Procedure 1: assign_medal
This stored procedure assigns a medal to an athlete in a specific match. If the athlete is already registered for the match in athlete_match, it updates the medal. Otherwise, it inserts a new entry.

```sql
CREATE OR REPLACE PROCEDURE assign_medal(
    ath_id INTEGER,
    match_id_in INTEGER,
    medal_type VARCHAR
)
AS $$
DECLARE
    exists_record BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM athlete_match
        WHERE athlete_id = ath_id AND match_id = match_id_in
    )
    INTO exists_record;

    IF exists_record THEN
        UPDATE athlete_match
        SET medal = medal_type
        WHERE athlete_id = ath_id AND match_id = match_id_in;
    ELSE
        INSERT INTO athlete_match(athlete_id, match_id, medal, athlete_rank, is_substitute)
        VALUES (ath_id, match_id_in, medal_type, NULL, FALSE);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in assign_medal: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;
Called from Flask route:
```

```python
@athlete_bp.route('/assign_medal/<int:athlete_id>', methods=['POST'])
def assign_medal(athlete_id):
    match_id = request.form.get('match_id')
    medal = request.form.get('medal')

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
```

### Function 1: get_total_goals
This function returns the total number of goals scored by a given athlete across all teams they played in. If the athlete has no goals, it returns 0.

```sql
CREATE OR REPLACE FUNCTION get_total_goals(ath_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    total_goals INTEGER;
BEGIN
    SELECT COALESCE(SUM(goals), 0)
    INTO total_goals
    FROM players
    WHERE athlete_id = ath_id;

    RETURN total_goals;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in get_total_goals: %', SQLERRM;
        RETURN 0;
END;
$$ LANGUAGE plpgsql;
```
Called from Flask code (inside athlete profile view):

```python
cur.execute("SELECT get_total_goals(%s);", (athlete_id,))
athlete['total_goals'] = cur.fetchone()[0]
```


### 6. UI/UX

Clean, consistent layout with intuitive navigation  

Styled forms, headers, and buttons for a pleasant user experience  

---

## Project Structure

The project is organized into a main app directory that contains all application logic. Inside app, there is a routes folder for organizing different route files (e.g., home, athlete, and match-related routes), and a templates folder that holds all HTML files for rendering views. The db.py file handles database setup or connections. The root-level run.py script is used to start the application.

---

## Assignment Requirements Covered

| Requirement                                                  | Completed |
|--------------------------------------------------------------|-----------|
| At least **5 GUI screens**                                   | ✅        |
| Full **CRUD** for 3 database tables                          | ✅        |
| **Junction table** between two related tables                | ✅        |
| Run **2 SQL queries** from Stage 2                           | ✅        |
| Run **2 stored procedures/functions** from Stage 4           | ✅        |
| **Enter screen** with navigation to the system               | ✅        |
| UI includes **basic styling and usability**                  | ✅        |

---

## Author Notes

This project was created as part of a full-stack database assignment, combining backend development with database logic and user interface design.

Feel free to explore the code, adapt it, or use it as a base for your own applications.

---

## Contact

For questions, suggestions, or feedback — feel free to contact us through GitHub.

https://github.com/michal359

https://github.com/ruchamabricker
