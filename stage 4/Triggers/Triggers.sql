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
        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_medals
AFTER INSERT ON athlete_match
FOR EACH ROW
WHEN (NEW.medal IS NOT NULL)
EXECUTE FUNCTION update_country_medals();


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
        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_teams
BEFORE INSERT ON matches
FOR EACH ROW
EXECUTE FUNCTION check_teams_different();
