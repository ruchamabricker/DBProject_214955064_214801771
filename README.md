<div dir="rtl">

# דוח פרויקט - שלב א

### שמות מגישות:
- מיכל ירושלמי 214955064
- רוחמה בריקר 214801771
  
### המערכת: ניהול תחרויות ספורט

### היחידה הנבחרת:
היחידה הנבחרת היא **מונדיאל**.

---

## תוכן עניינים:
1. [מבוא](#מבוא)
2. [תרשימים](#תרשימים)
3. [החלטות עיצוב](#החלטות-עיצוב)
4. [הכנסת נתונים](#הכנסת-נתונים)
5. [גיבוי ושחזור נתונים](#גיבוי-ושחזור-נתונים)
6. [דרישות המערכת](#דרישות-המערכת)
7. [ממשקי המערכת](#ממשקי-המערכת)
8. [מקרים לדוגמה](#מקרים-לדוגמה)

---

## מבוא

המערכת עוסקת בניהול תחרויות ספורט. הנתונים הנשמרים במערכת כוללים את המידע על המשחקים בתחרות, שחקנים, קבוצות, שלבים וסטטוס של המשחקים.
המערכת מספקת את הפונקציות הבאות:
- יצירת משחקים בין קבוצות
- ניהול שחקנים והקבוצות בתחרות
- ניהול שלבים בתחרות (כמו שלב בתים, רבע גמר, חצי גמר, גמר)
- עדכון תוצאות משחקים

המערכת פועלת על בסיס נתונים במערכת **PostgreSQL**.

---

## תרשימים

התרשימים הבאים מציגים את מבנה הנתונים והקשרים בין הטבלאות:

### ERD (Entity Relationship Diagram)
![ERD](stage%201/ERD/UltimateWorldCup.png)

### DSD (Data Structure Diagram)
![DSD](stage%201/DSD/UltimateWorldCupScheme.png)

---

## החלטות עיצוב

במהלך תכנון המערכת, התקבלו מספר החלטות עיצוביות:
- כל משחק יכלול מזהה ייחודי (match_id) כדי להקל על ניהול התוצאות והסטטוס של המשחק.
- טבלה נפרדת עבור שחקנים, עם קשרים לקבוצות ולמשחקים.
- שמירה על שלב התחרות כטבלה נפרדת (stages), כך שניתן יהיה לעדכן את השלבים בקלות ולטפל בכמה תחרויות בבת אחת.

---

## הכנסת נתונים

הכנסת הנתונים בוצעה בעזרת שלוש שיטות שונות:

1. **ייבוא מקבצים (Mockaroo)**:
    - השתמשנו בכלי **Mockaroo** ליצירת נתונים בתצורת CSV.
    - ![Mockaroo Data Import](stage%201/Filesmockaroo/MOCK_DATA_teams_screen_shut.png)

2. **תכנות (Python)**:
    - השתמשנו בסקריפטים ב-Python כדי ליצור את הנתונים ולהזין אותם לטבלאות.
    - ![Python Script](stage%201/Programing/events_screen_shot.png)

3. **ייבוא מקבצים (Generatedata)**:
    - השתמשנו בכלי **Generatedata** ליצירת נתונים בתצורת CSV.
    - ![SQL Import](stage%201/generatedataFiles/players_screen_shot.png)

---

## גיבוי ושחזור נתונים

הכנו גיבוי של הנתונים באמצעות הכלי **pg_dump** ושחזרנו את הנתונים בעזרת **pg_restore**:

1. **גיבוי נתונים**:
    - ![SQL Import](stage%201/backupFiles/backup_screen_shot.png)
   
2. **שחזור נתונים**:
    - ![SQL Import](stage%201/backupFiles/restore_screen_shot.png)

---

## דרישות המערכת
- מערכת בסיס נתונים: **PostgreSQL 14+**
- שפת תכנות: **Python 3.8+** (לצורך סקריפטים)
- כלים ליצירת נתונים: **Mockaroo, Generatedata**
- מערכת הפעלה נתמכת: **Windows/Linux**

---

## ממשקי המערכת
- **ממשק ניהול טורנירים** – יצירת טורנירים חדשים ועדכון נתונים קיימים.
- **ממשק ניהול קבוצות ושחקנים** – עדכון ועריכת שחקנים וקבוצות.
- **ממשק הזנת תוצאות** – הוספת תוצאות משחקים ועדכון שלבים בטורניר.

---

## מקרים לדוגמה
1. **הוספת טורניר חדש**:
   - המשתמש נכנס למערכת הניהול, לוחץ על "הוספת טורניר", מזין שם ותאריכים, ומאשר.
   
2. **הזנת תוצאות משחק**:
   - המשתמש בוחר משחק מהטבלה, מזין את התוצאה ולוחץ "שמור".
   
3. **עדכון פרטי קבוצה**:
   - המנהל מחפש קבוצה לפי שם, עורך את רשימת השחקנים ולוחץ "עדכן".

---</div>
Project Report - Phase A

Submitted by:

Michal Yerushalmi 214955064

Ruchama Bricker 214801771


Sports Competition Management System

Selected Unit: World Cup


---

Table of Contents

1. Introduction


2. Diagrams


3. Design Decisions


4. Data Entry


5. Backup and Restore


6. System Requirements


7. System Interfaces


8. Use Cases




---

Introduction

The system is designed for managing sports competitions. It stores data related to competition matches, players, teams, stages, and match statuses.

Features:

Create matches between teams

Manage players and teams in the competition

Handle competition stages (group stage, quarter-finals, semi-finals, finals)

Update match results


The system operates using a PostgreSQL database.


---

Diagrams

The following diagrams illustrate the data structure and relationships between tables:

ERD (Entity Relationship Diagram)



DSD (Data Structure Diagram)




---

Design Decisions

Key design choices made during system planning:

Each match has a unique identifier (match_id) to manage results and statuses efficiently.

Players are stored in a separate table with relationships to teams and matches.

Competition stages are stored in a dedicated stages table for easy updates and support for multiple tournaments simultaneously.



---

Data Entry

Data was inserted using three methods:

1. File Import (Mockaroo):

Generated CSV files using Mockaroo.





2. Programmatic Entry (Python):

Used Python scripts to generate and insert data.





3. File Import (Generatedata):

Used Generatedata to create CSV-formatted data.







---

Backup and Restore

We implemented backup and restore using pg_dump and pg_restore:

1. Backup:





2. Restore:







---

System Requirements

Database: PostgreSQL 14+

Programming Language: Python 3.8+ (for scripts)

Data Generation Tools: Mockaroo, Generatedata

Supported OS: Windows/Linux



---

System Interfaces

Tournament Management – Create and update tournaments.

Team & Player Management – Edit and update player/team details.

Results Entry – Input match results and update tournament stages.



---

Use Cases

1. Adding a New Tournament:

The user navigates to the management system, clicks "Add Tournament," enters a name and dates, and confirms.



2. Entering Match Results:

The user selects a match, inputs the score, and clicks "Save."



3. Updating Team Details:

The manager searches for a team, edits the player list, and clicks "Update."





---

License

This project is licensed under the MIT License - see the LICENSE file for details.



הטקסט מעודכן בפורמט שמתאים לקריאה ב-README של GitHub. אם יש לך שינויים נוספים או התאמות שתרצי להוסיף, אני כאן!



