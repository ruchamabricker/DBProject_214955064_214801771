# Project Report - Stage 1

### Submitted by:
- Michal Yerushalmi 214955064
- Ruchama Bricker 214801771

### System: Sports Competitions Management

### Selected Unit:
The selected unit is **World Cup** - The Ultimate World Cup.

---

## Table of Contents:
1. [Introduction](#introduction)
2. [Diagrams](#diagrams)
3. [Design Decisions](#design-decisions)
4. [Data Insertion](#data-insertion)
5. [Backup and Restore](#backup-and-restore)
6. [System Requirements](#system-requirements)
7. [System Interfaces](#system-interfaces)
8. [Use Cases](#use-cases)

---

## Introduction

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
<div dir="rtl">

# דוח פרויקט - שלב א

### שמות מגישות:
- מיכל ירושלמי 214955064
- רוחמה בריקר 214801771
  
### המערכת: ניהול תחרויות ספורט 

### היחידה הנבחרת:
היחידה הנבחרת היא **מונדיאל** - The Ultimate World Cup

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

---
</div>
