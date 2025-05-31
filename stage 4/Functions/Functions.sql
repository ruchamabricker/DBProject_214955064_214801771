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