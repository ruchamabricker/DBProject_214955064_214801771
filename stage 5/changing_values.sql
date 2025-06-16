DROP TABLE IF EXISTS temp_keep_venues;

CREATE TEMP TABLE temp_keep_venues AS
SELECT venue_id
FROM venues
ORDER BY venue_id
LIMIT 15;

INSERT INTO temp_keep_venues
SELECT venue_id
FROM venues
ORDER BY venue_id DESC
LIMIT 3;

-- נשמור את ה-id הראשון כרפרנס לשיוך מחודש
DROP TABLE IF EXISTS temp_fallback_venue;

CREATE TEMP TABLE temp_fallback_venue AS
SELECT venue_id AS new_venue_id
FROM temp_keep_venues
ORDER BY venue_id
LIMIT 1;

UPDATE ticket
SET venue_id = (SELECT new_venue_id FROM temp_fallback_venue)
WHERE venue_id NOT IN (SELECT venue_id FROM temp_keep_venues);

DELETE FROM venues
WHERE venue_id NOT IN (SELECT venue_id FROM temp_keep_venues);

-- נבנה טבלה עם mapping של ID ישן לחדש
DROP TABLE IF EXISTS temp_venue_mapping;

CREATE TEMP TABLE temp_venue_mapping AS
SELECT venue_id AS old_id,
       ROW_NUMBER() OVER (ORDER BY venue_id) AS new_id
FROM venues;

UPDATE athlete_match
SET 
    athlete_rank = FLOOR(random() * 10) + 1,
    medal = CASE 
                WHEN random() < 0.33 THEN 'Gold'
                WHEN random() < 0.66 THEN 'Silver'
                ELSE 'Bronze'
            END
WHERE athlete_rank = 0;


INSERT INTO competitions (competition_id, comp_date, competition_name, sport_id)
SELECT
  400 + s.i AS competition_id,
  CURRENT_DATE + (floor(random()*365))::int AS comp_date,
  'Olympic Event ' || (400 + s.i) AS competition_name,
  (floor(random()*10) + 1)::int AS sport_id
FROM generate_series(1, 20) AS s(i);








ALTER TABLE stages
  DROP CONSTRAINT tournamentstages_name_check,
  ADD CONSTRAINT tournamentstages_name_check
  CHECK (
    name = ANY (ARRAY[
      'Group Stage',
      'Round of 16',
      'Quarter Finals',
      'Semi Finals',
      'Final',
      'Qualification',
      'Preliminary Round',
      'Round of 32',
      'Quarterfinals',
      'Semifinals',
      'Bronze Medal Match',
      'Final / Gold Medal Match',
      'Ranking Round',
      'Heats',
      'Repechage',
      'Final A',
      'Final B / C / D'
    ])
  );





WITH stage_names AS (
  SELECT * FROM (VALUES
    ('Qualification'),
    ('Preliminary Round'),
    ('Group Stage'),
    ('Round of 32'),
    ('Round of 16'),
    ('Quarterfinals'),
    ('Semifinals'),
    ('Bronze Medal Match'),
    ('Final / Gold Medal Match'),
    ('Ranking Round'),
    ('Heats'),
    ('Repechage'),
    ('Final A'),
    ('Final B / C / D')
  ) AS t(name)
),
competitions AS (
  SELECT competition_id, comp_date
  FROM competitions
  WHERE competition_id BETWEEN 401 AND 420
),
stages_to_insert AS (
  SELECT
    ROW_NUMBER() OVER () + (SELECT COALESCE(MAX(stage_id), 0) FROM stages) AS stage_id,
    c.competition_id,
    s.name,
    (floor(random() * 10) + 1)::int AS matches_count,
    (c.comp_date + (ROW_NUMBER() OVER (PARTITION BY c.competition_id ORDER BY s.name)-1) * INTERVAL '3 days')::date AS start_date,
    (c.comp_date + (ROW_NUMBER() OVER (PARTITION BY c.competition_id ORDER BY s.name)-1) * INTERVAL '3 days' + INTERVAL '2 days')::date AS finish_date
  FROM competitions c
  CROSS JOIN stage_names s
)
INSERT INTO stages (stage_id, name, matches_count, start_date, finish_date, competition_id)
SELECT stage_id, name, matches_count, start_date, finish_date, competition_id
FROM stages_to_insert
ORDER BY competition_id, stage_id;




-- הוספת משחקים אולימפיים
