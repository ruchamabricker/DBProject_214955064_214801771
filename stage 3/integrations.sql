--לבצע את הירושה בין שחקן לאטלט
CREATE SEQUENCE IF NOT EXISTS athlete_athleteid_seq;
ALTER TABLE athlete ALTER COLUMN athleteid SET DEFAULT nextval('athlete_athleteid_seq');
SELECT setval('athlete_athleteid_seq', (SELECT COALESCE(MAX(athleteid), 0) FROM athlete));

ALTER TABLE players ADD COLUMN athleteid INTEGER;

ALTER TABLE country
ALTER COLUMN totalmedals SET DEFAULT 0;

CREATE SEQUENCE IF NOT EXISTS country_countryid_seq;
ALTER TABLE country ALTER COLUMN countryid SET DEFAULT nextval('country_countryid_seq');
SELECT setval('country_countryid_seq', (SELECT COALESCE(MAX(countryid), 0) FROM country));


INSERT INTO country (countryname)
SELECT DISTINCT t.team_name
FROM teams t
LEFT JOIN country c ON t.team_name = c.countryname
WHERE c.countryname IS NULL;


INSERT INTO athlete (
  athletename,
  gender,
  birthday,
  countryid
)
SELECT
    p.name,
    'male',
    p.birth_date,
  COALESCE(c.countryid, 1)
  FROM players p 
LEFT JOIN teams t ON p.team_id = t.team_id
LEFT JOIN country c ON t.team_name = c.countryname;

UPDATE players p
SET athleteid = a.athleteid
FROM athlete a
WHERE p.name = a.athletename
  AND p.birth_date = a.birthday;

ALTER TABLE players
DROP COLUMN name,
DROP COLUMN birth_date;

--לחבר בין מדינה לקבוצה
ALTER TABLE teams ADD COLUMN country_id INTEGER;

UPDATE teams t
SET country_id = c.countryid
FROM country c
WHERE t.team_name = c.countryname;

-- --מעתיקים את האצטודיונים
CREATE SEQUENCE IF NOT EXISTS venue_venueid_seq;

ALTER TABLE venue
ALTER COLUMN venueid SET DEFAULT nextval('venue_venueid_seq');

SELECT setval('venue_venueid_seq', COALESCE((SELECT MAX(venueid) FROM venue), 0));

INSERT INTO venue (
    venuename,
    venuelocation,
    capacity
)
SELECT 
    name,
    city,
    capacity
FROM stadiums;

ALTER TABLE matches
ADD COLUMN venue_id INTEGER;

UPDATE matches m
SET venue_id = v.venueid
FROM stadiums s
JOIN venue v ON s.name = v.venuename
WHERE m.stadium_id = s.stadium_id;

ALTER TABLE matches
ADD CONSTRAINT matches_venue_id_fkey
FOREIGN KEY (venue_id) REFERENCES venue(venueid);

ALTER TABLE matches
DROP COLUMN stadium_id;

DROP TABLE stadiums;


ALTER TABLE TournamentStages RENAME TO stages;


SELECT conname FROM pg_constraint WHERE conrelid = 'matches'::regclass AND contype = 'f';

ALTER TABLE matches
DROP CONSTRAINT matches_stage_id_fkey;

ALTER TABLE matches
ADD CONSTRAINT matches_stage_id_fkey
FOREIGN KEY (stage_id)
REFERENCES stages(stage_id)
ON DELETE SET NULL;

--חיבור שלבים לתחרויות
ALTER TABLE stages
ADD COLUMN competition_id INTEGER;

ALTER TABLE stages
ADD CONSTRAINT stages_competition_id_fkey
FOREIGN KEY (competition_id)
REFERENCES competition(competitionid)
ON DELETE SET NULL;

WITH ordered_stages AS (
  SELECT stage_id, ROW_NUMBER() OVER () AS rn
  FROM stages
),
ordered_competitions AS (
  SELECT competitionid, ROW_NUMBER() OVER () AS rn
  FROM competition
)
UPDATE stages s
SET competition_id = c.competitionid
FROM ordered_stages os
JOIN ordered_competitions c ON os.rn = c.rn
WHERE s.stage_id = os.stage_id;

--
ALTER TABLE relationship RENAME TO athlete_match;
ALTER TABLE athlete_match ADD COLUMN match_id INTEGER;
ALTER TABLE athlete_match RENAME COLUMN competitionid TO old_competition_id;

ALTER TABLE athlete_match
ADD CONSTRAINT athlete_match_match_id_fkey
FOREIGN KEY (match_id)
REFERENCES matches(match_id)
ON DELETE CASCADE;

ALTER TABLE athlete_match ADD COLUMN is_substitute BOOLEAN DEFAULT TRUE;

INSERT INTO athlete_match (
  athleteid, match_id, is_substitute, athleterank, medal, old_competition_id
)
SELECT
  p.athleteid,
  pm.match_id,
  pm.is_substitute,
  0 AS athleterank,
  NULL AS medal,
  s.competition_id AS old_competition_id
FROM playersinmatches pm
JOIN players p ON pm.player_id = p.player_id
JOIN matches m ON pm.match_id = m.match_id
JOIN stages s ON m.stage_id = s.stage_id
ON CONFLICT (old_competition_id, athleteid) DO NOTHING;


UPDATE athlete_match
SET match_id = 1
WHERE match_id IS NULL;

ALTER TABLE athlete_match DROP COLUMN old_competition_id;

DROP TABLE playersinmatches;

--למחוק קשר בין תחרות לבין מקום הארוע
ALTER TABLE competition DROP COLUMN venueid;

--להוסיף קשר בין קבוצה למדינה
ALTER TABLE teams
ADD CONSTRAINT teams_country_id_fkey
FOREIGN KEY (country_id)
REFERENCES country(countryid)
ON DELETE SET NULL;

--להוסיף קשר בין שחקן לאטלט
ALTER TABLE players
ADD CONSTRAINT player_athlete_id_fkey
FOREIGN KEY (athleteid)
REFERENCES athlete(athleteid)
ON DELETE SET NULL;

--שינויי שמות של טבלאות

--תחרויות
ALTER TABLE competition DROP CONSTRAINT competition_sportid_fkey;
ALTER TABLE stages DROP CONSTRAINT stages_competition_id_fkey;
ALTER TABLE competition RENAME TO competitions;

ALTER TABLE competitions
ADD CONSTRAINT competitions_sportid_fkey
FOREIGN KEY (sportid)
REFERENCES sport(sportid);

ALTER TABLE stages
ADD CONSTRAINT stages_competition_id_fkey
FOREIGN KEY (competition_id)
REFERENCES competitions(competitionid);


--אטלט
ALTER TABLE athlete DROP CONSTRAINT athlete_countryid_fkey;
ALTER TABLE athlete_match DROP CONSTRAINT relationship_athleteid_fkey;
ALTER TABLE players DROP CONSTRAINT player_athlete_id_fkey;
ALTER TABLE athlete RENAME TO athletes;

ALTER TABLE athletes
ADD CONSTRAINT athlete_countryid_fkey
FOREIGN KEY (countryid)
REFERENCES country(countryid);

ALTER TABLE athlete_match
ADD CONSTRAINT athlete_match_athleteid_fkey
FOREIGN KEY (athleteid)
REFERENCES athletes(athleteid);

ALTER TABLE players
ADD CONSTRAINT players_athleteid_fkey
FOREIGN KEY (athleteid)
REFERENCES athletes(athleteid);


--מקומות
ALTER TABLE ticket DROP CONSTRAINT ticket_venueid_fkey;
ALTER TABLE matches DROP CONSTRAINT matches_venue_id_fkey;

ALTER TABLE venue RENAME TO venues;

ALTER TABLE ticket
ADD CONSTRAINT ticket_venueid_fkey
FOREIGN KEY (venueid)
REFERENCES venues(venueid);

ALTER TABLE matches
ADD CONSTRAINT matches_venue_id_fkey
FOREIGN KEY (venue_id)
REFERENCES venues(venueid);


--ספורט
ALTER TABLE competitions DROP CONSTRAINT competitions_sportid_fkey;

ALTER TABLE sport RENAME TO sports;

ALTER TABLE competitions
ADD CONSTRAINT competitions_sportid_fkey
FOREIGN KEY (sportid)
REFERENCES sports(sportid);

--ארוע במשחק
ALTER TABLE matchevents DROP CONSTRAINT matchevents_match_id_fkey;
ALTER TABLE matchevents DROP CONSTRAINT matchevents_player_id_fkey;
ALTER TABLE matchevents RENAME TO match_events;

ALTER TABLE match_events
ADD CONSTRAINT match_events_match_id_fkey
FOREIGN KEY (match_id)
REFERENCES matches(match_id);

ALTER TABLE match_events
ADD CONSTRAINT match_events_player_id_fkey
FOREIGN KEY (player_id)
REFERENCES players(player_id);

--אטלט במשחק
ALTER TABLE athlete_match DROP CONSTRAINT athlete_match_athleteid_fkey;

ALTER TABLE athlete_match
ADD CONSTRAINT athlete_match_athleteid_fkey
FOREIGN KEY (athleteid)
REFERENCES athletes(athleteid)
ON DELETE CASCADE;

--עדכון עמודות
ALTER TABLE athlete_match RENAME COLUMN athleterank TO athlete_rank;
ALTER TABLE athlete_match RENAME COLUMN athleteid TO athlete_id;

ALTER TABLE athletes RENAME COLUMN athleteid TO athlete_id;
ALTER TABLE athletes RENAME COLUMN athletename TO athlete_name;
ALTER TABLE athletes RENAME COLUMN countryid TO country_id;

ALTER TABLE competitions RENAME COLUMN competitionid TO competition_id;
ALTER TABLE competitions RENAME COLUMN compdate TO comp_date;
ALTER TABLE competitions RENAME COLUMN competitionname TO competition_name;
ALTER TABLE competitions RENAME COLUMN sportid TO sport_id;

ALTER TABLE country RENAME COLUMN countryid TO country_id;
ALTER TABLE country RENAME COLUMN countryname TO country_name;
ALTER TABLE country RENAME COLUMN totalmedals TO total_medals;

ALTER TABLE players RENAME COLUMN athleteid TO athlete_id;

ALTER TABLE sports RENAME COLUMN sportid TO sport_id;
ALTER TABLE sports RENAME COLUMN sportname TO sport_name;

ALTER TABLE ticket RENAME COLUMN cardid TO card_id;
ALTER TABLE ticket RENAME COLUMN carddate TO card_date;
ALTER TABLE ticket RENAME COLUMN ticketprice TO ticket_price;
ALTER TABLE ticket RENAME COLUMN venueid TO venue_id;

ALTER TABLE venues RENAME COLUMN venueid TO venue_id;
ALTER TABLE venues RENAME COLUMN venuename TO venue_name;
ALTER TABLE venues RENAME COLUMN venuelocation TO venue_location;



