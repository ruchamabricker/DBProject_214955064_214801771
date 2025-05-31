CREATE OR REPLACE PROCEDURE update_fifa_ranking(team_id_in INTEGER, new_rank INTEGER)
AS $$
BEGIN
    UPDATE teams
    SET fifa_ranking = new_rank
    WHERE team_id = team_id_in;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in update_fifa_ranking: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE assign_medal(
    ath_id INTEGER,
    match_id_in INTEGER,
    medal_type VARCHAR
)
AS $$
DECLARE
    exists_record BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM athlete_match
        WHERE athlete_id = ath_id AND match_id = match_id_in
    )
    INTO exists_record;

    IF exists_record THEN
        UPDATE athlete_match
        SET medal = medal_type
        WHERE athlete_id = ath_id AND match_id = match_id_in;
    ELSE
        INSERT INTO athlete_match(athlete_id, match_id, medal, athlete_rank, is_substitute)
        VALUES (ath_id, match_id_in, medal_type, NULL, FALSE);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in assign_medal: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;