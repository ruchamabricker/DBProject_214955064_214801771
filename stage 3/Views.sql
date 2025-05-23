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


SELECT athlete_name, match_id, is_substitute
FROM view_athletes_matches
WHERE is_substitute = true;

SELECT athlete_name, match_id, athlete_rank, medal
FROM view_athletes_matches
WHERE medal IS NOT NULL
ORDER BY athlete_rank;


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

SELECT name, start_date
FROM view_competition_stages
WHERE competition_id = 1
ORDER BY start_date;

SELECT competition_name, COUNT(stage_id) AS total_stages
FROM view_competition_stages
GROUP BY competition_name
ORDER BY total_stages DESC;