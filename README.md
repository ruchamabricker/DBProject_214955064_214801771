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
