-- אילוץ 1: הוספת אילוץ NOT NULL לעמודת position בטבלת Players
ALTER TABLE Players
ALTER COLUMN position SET NOT NULL;

INSERT INTO Players (team_id, name, birth_date, goals, assists)
VALUES (1, 'John Doe', '1990-04-20', 2, 1);


-- אילוץ 2: הוספת אילוץ CHECK לטבלת Stadiums - לוודא שהקיבולת חיובית וגדולה מ-1000
ALTER TABLE Stadiums
ADD CONSTRAINT check_capacity_positive
CHECK (capacity >= 1000);

INSERT INTO Stadiums (name, city, capacity)
VALUES ('Tiny Field', 'Smallville', 500);


-- אילוץ 3: הוספת ערך ברירת מחדל (DEFAULT) לעמודת fifa_ranking בטבלת Teams
ALTER TABLE Teams
ALTER COLUMN fifa_ranking SET DEFAULT 180;

INSERT INTO Teams (team_name, coach, team_group, fifa_ranking, favorite_color)
VALUES ('Unicorn FC', 'Magical Coach', 'A', 199, 'Pink');

