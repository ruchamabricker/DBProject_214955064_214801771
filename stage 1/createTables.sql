CREATE TABLE Teams (
    team_id SERIAL PRIMARY KEY, 
    team_name VARCHAR(100) NOT NULL,
    coach VARCHAR(100),
    team_group CHAR(1),
    fifa_ranking INT
);

-- אתחול הסיקוונס של ה-ID של Teams
ALTER SEQUENCE teams_team_id_seq RESTART WITH 1;

CREATE TABLE Stadiums (
    stadium_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    capacity INT NOT NULL
);

-- אתחול הסיקוונס של ה-ID של Stadiums
ALTER SEQUENCE stadiums_stadium_id_seq RESTART WITH 1;

CREATE TABLE TournamentStages (
    stage_id SERIAL PRIMARY KEY,
    name TEXT CHECK (name IN ('Group Stage', 'Round of 16', 'Quarter Finals', 'Semi Finals', 'Final')) NOT NULL,
    matches_count INT,
    start_date DATE NOT NULL,
    finish_date DATE NOT NULL
);

-- אתחול הסיקוונס של ה-ID של TournamentStages
ALTER SEQUENCE tournamentstages_stage_id_seq RESTART WITH 1;

CREATE TABLE Players (
    player_id SERIAL PRIMARY KEY,
    team_id INT,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    birth_date DATE NOT NULL,
    goals INT DEFAULT 0,
    assists INT DEFAULT 0,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id) ON DELETE CASCADE
);

-- אתחול הסיקוונס של ה-ID של Players
ALTER SEQUENCE players_player_id_seq RESTART WITH 1;

CREATE TABLE Matches (
    match_id SERIAL PRIMARY KEY,
    team1_id INT,
    team2_id INT,
    match_date DATE NOT NULL,
    stadium_id INT,
    score_team1 INT DEFAULT 0,
    score_team2 INT DEFAULT 0,
    stage_id INT,
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id) ON DELETE CASCADE,
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id) ON DELETE CASCADE,
    FOREIGN KEY (stadium_id) REFERENCES Stadiums(stadium_id) ON DELETE SET NULL,
    FOREIGN KEY (stage_id) REFERENCES TournamentStages(stage_id) ON DELETE SET NULL
);

-- אתחול הסיקוונס של ה-ID של Matches
ALTER SEQUENCE matches_match_id_seq RESTART WITH 1;

CREATE TABLE MatchEvents (
    event_id SERIAL PRIMARY KEY,
    match_id INT,
    player_id INT,
    event_type TEXT CHECK (event_type IN ('Goal', 'Yellow Card', 'Red Card', 'Substitution')) NOT NULL,
    minute INT CHECK (minute BETWEEN 1 AND 120),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES Players(player_id) ON DELETE SET NULL
);

-- אתחול הסיקוונס של ה-ID של MatchEvents
ALTER SEQUENCE matchevents_event_id_seq RESTART WITH 1;

CREATE TABLE PlayersInMatches (
    is_substitute BOOLEAN NOT NULL,
    player_id INT NOT NULL,
    match_id INT NOT NULL,
    PRIMARY KEY (player_id, match_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id) ON DELETE CASCADE,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id) ON DELETE CASCADE
);

-- לא צריך ALTER לסיקוונס בטבלה זו כי יש לך מפתח ראשי על שני עמודות
