
DO $$
DECLARE
    total INTEGER;
BEGIN
    CALL update_fifa_ranking(1, 15);
    total := get_total_goals(405);
    RAISE NOTICE 'Total goals: %', total;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in main block 1: %', SQLERRM;
END;
$$;



DO $$
DECLARE
    ref refcursor;
    rec RECORD;
BEGIN
    CALL assign_medal(1, 1, 'GOLD');
    ref := get_country_info('Egypt');

    LOOP
        FETCH ref INTO rec;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Country: %, Medals: %', rec.country_name, rec.total_medals;
    END LOOP;

    CLOSE ref;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in main block 2: %', SQLERRM;
END;
$$;
