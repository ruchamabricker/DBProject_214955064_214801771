PGDMP                       }           integratedDB    17.4    17.4 Z    |           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            }           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            ~           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    25099    integratedDB    DATABASE     t   CREATE DATABASE "integratedDB" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en-US';
    DROP DATABASE "integratedDB";
                     postgres    false            �            1255    33497 1   assign_medal(integer, integer, character varying) 	   PROCEDURE     �  CREATE PROCEDURE public.assign_medal(IN ath_id integer, IN match_id_in integer, IN medal_type character varying)
    LANGUAGE plpgsql
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
$$;
 p   DROP PROCEDURE public.assign_medal(IN ath_id integer, IN match_id_in integer, IN medal_type character varying);
       public               postgres    false            �            1255    33495    check_teams_different()    FUNCTION     e  CREATE FUNCTION public.check_teams_different() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 .   DROP FUNCTION public.check_teams_different();
       public               postgres    false            �            1255    33490    get_country_info(text)    FUNCTION     z  CREATE FUNCTION public.get_country_info(country_name_in text) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
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
$$;
 =   DROP FUNCTION public.get_country_info(country_name_in text);
       public               postgres    false            �            1255    33489    get_total_goals(integer)    FUNCTION     �  CREATE FUNCTION public.get_total_goals(ath_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;
 6   DROP FUNCTION public.get_total_goals(ath_id integer);
       public               postgres    false            �            1255    33493    update_country_medals()    FUNCTION     �  CREATE FUNCTION public.update_country_medals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 .   DROP FUNCTION public.update_country_medals();
       public               postgres    false            �            1255    33491 %   update_fifa_ranking(integer, integer) 	   PROCEDURE     8  CREATE PROCEDURE public.update_fifa_ranking(IN team_id_in integer, IN new_rank integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE teams
    SET fifa_ranking = new_rank
    WHERE team_id = team_id_in;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in update_fifa_ranking: %', SQLERRM;
END;
$$;
 W   DROP PROCEDURE public.update_fifa_ranking(IN team_id_in integer, IN new_rank integer);
       public               postgres    false            �            1259    25326    athlete_athleteid_seq    SEQUENCE     ~   CREATE SEQUENCE public.athlete_athleteid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.athlete_athleteid_seq;
       public               postgres    false            �            1259    25110    athlete_match    TABLE     �   CREATE TABLE public.athlete_match (
    athlete_rank integer NOT NULL,
    medal character varying(50),
    athlete_id integer NOT NULL,
    match_id integer,
    is_substitute boolean DEFAULT true
);
 !   DROP TABLE public.athlete_match;
       public         heap r       postgres    false            �            1259    25100    athletes    TABLE       CREATE TABLE public.athletes (
    athlete_id integer DEFAULT nextval('public.athlete_athleteid_seq'::regclass) NOT NULL,
    athlete_name character varying(50) NOT NULL,
    gender character varying(50) NOT NULL,
    birthday date NOT NULL,
    country_id integer NOT NULL
);
    DROP TABLE public.athletes;
       public         heap r       postgres    false    234            �            1259    25103    competitions    TABLE     �   CREATE TABLE public.competitions (
    competition_id integer NOT NULL,
    comp_date date NOT NULL,
    competition_name character varying(50) NOT NULL,
    sport_id integer NOT NULL
);
     DROP TABLE public.competitions;
       public         heap r       postgres    false            �            1259    25329    country_countryid_seq    SEQUENCE     ~   CREATE SEQUENCE public.country_countryid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.country_countryid_seq;
       public               postgres    false            �            1259    25106    country    TABLE       CREATE TABLE public.country (
    country_id integer DEFAULT nextval('public.country_countryid_seq'::regclass) NOT NULL,
    country_name character varying(50) NOT NULL,
    total_medals integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_totalmedals_positive CHECK ((total_medals >= 0))
);
    DROP TABLE public.country;
       public         heap r       postgres    false    235            �            1259    25173    match_events    TABLE     �  CREATE TABLE public.match_events (
    event_id integer NOT NULL,
    match_id integer,
    player_id integer,
    event_type text NOT NULL,
    minute integer,
    CONSTRAINT matchevents_event_type_check CHECK ((event_type = ANY (ARRAY['Goal'::text, 'Yellow Card'::text, 'Red Card'::text, 'Substitution'::text]))),
    CONSTRAINT matchevents_minute_check CHECK (((minute >= 1) AND (minute <= 120)))
);
     DROP TABLE public.match_events;
       public         heap r       postgres    false            �            1259    25167    matches    TABLE     �   CREATE TABLE public.matches (
    match_id integer NOT NULL,
    team1_id integer,
    team2_id integer,
    match_date date NOT NULL,
    score_team1 integer DEFAULT 0,
    score_team2 integer DEFAULT 0,
    stage_id integer,
    venue_id integer
);
    DROP TABLE public.matches;
       public         heap r       postgres    false            �            1259    25172    matches_match_id_seq    SEQUENCE     �   CREATE SEQUENCE public.matches_match_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.matches_match_id_seq;
       public               postgres    false    224            �           0    0    matches_match_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.matches_match_id_seq OWNED BY public.matches.match_id;
          public               postgres    false    225            �            1259    25180    matchevents_event_id_seq    SEQUENCE     �   CREATE SEQUENCE public.matchevents_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.matchevents_event_id_seq;
       public               postgres    false    226            �           0    0    matchevents_event_id_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.matchevents_event_id_seq OWNED BY public.match_events.event_id;
          public               postgres    false    227            �            1259    25181    players    TABLE     �   CREATE TABLE public.players (
    player_id integer NOT NULL,
    team_id integer,
    "position" character varying(50) NOT NULL,
    goals integer DEFAULT 0,
    assists integer DEFAULT 0,
    athlete_id integer
);
    DROP TABLE public.players;
       public         heap r       postgres    false            �            1259    25186    players_player_id_seq    SEQUENCE     �   CREATE SEQUENCE public.players_player_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.players_player_id_seq;
       public               postgres    false    228            �           0    0    players_player_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.players_player_id_seq OWNED BY public.players.player_id;
          public               postgres    false    229            �            1259    25113    sports    TABLE     �   CREATE TABLE public.sports (
    sport_id integer NOT NULL,
    sport_name character varying(50) NOT NULL,
    category character varying(50) NOT NULL
);
    DROP TABLE public.sports;
       public         heap r       postgres    false            �            1259    25200    stages    TABLE     y  CREATE TABLE public.stages (
    stage_id integer NOT NULL,
    name text NOT NULL,
    matches_count integer,
    start_date date NOT NULL,
    finish_date date NOT NULL,
    competition_id integer,
    CONSTRAINT tournamentstages_name_check CHECK ((name = ANY (ARRAY['Group Stage'::text, 'Round of 16'::text, 'Quarter Finals'::text, 'Semi Finals'::text, 'Final'::text])))
);
    DROP TABLE public.stages;
       public         heap r       postgres    false            �            1259    25195    teams    TABLE     �   CREATE TABLE public.teams (
    team_id integer NOT NULL,
    team_name character varying(100) NOT NULL,
    coach character varying(100),
    team_group character(1),
    fifa_ranking integer DEFAULT 180,
    country_id integer
);
    DROP TABLE public.teams;
       public         heap r       postgres    false            �            1259    25199    teams_team_id_seq    SEQUENCE     �   CREATE SEQUENCE public.teams_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.teams_team_id_seq;
       public               postgres    false    230            �           0    0    teams_team_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.teams_team_id_seq OWNED BY public.teams.team_id;
          public               postgres    false    231            �            1259    25116    ticket    TABLE     �   CREATE TABLE public.ticket (
    card_id integer NOT NULL,
    card_date date NOT NULL,
    ticket_price double precision DEFAULT 100 NOT NULL,
    venue_id integer NOT NULL
);
    DROP TABLE public.ticket;
       public         heap r       postgres    false            �            1259    25206    tournamentstages_stage_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tournamentstages_stage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.tournamentstages_stage_id_seq;
       public               postgres    false    232            �           0    0    tournamentstages_stage_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.tournamentstages_stage_id_seq OWNED BY public.stages.stage_id;
          public               postgres    false    233            �            1259    25338    venue_venueid_seq    SEQUENCE     z   CREATE SEQUENCE public.venue_venueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.venue_venueid_seq;
       public               postgres    false            �            1259    25120    venues    TABLE     �   CREATE TABLE public.venues (
    venue_id integer DEFAULT nextval('public.venue_venueid_seq'::regclass) NOT NULL,
    venue_name character varying(50) NOT NULL,
    venue_location character varying(50) NOT NULL,
    capacity integer NOT NULL
);
    DROP TABLE public.venues;
       public         heap r       postgres    false    236            �            1259    25429    view_athletes_matches    VIEW     R  CREATE VIEW public.view_athletes_matches AS
 SELECT am.athlete_id,
    a.athlete_name,
    am.match_id,
    m.match_date,
    am.athlete_rank,
    am.medal,
    am.is_substitute
   FROM ((public.athlete_match am
     JOIN public.athletes a ON ((am.athlete_id = a.athlete_id)))
     JOIN public.matches m ON ((am.match_id = m.match_id)));
 (   DROP VIEW public.view_athletes_matches;
       public       v       postgres    false    220    217    217    220    220    220    220    224    224            �            1259    25433    view_competition_stages    VIEW       CREATE VIEW public.view_competition_stages AS
 SELECT c.competition_id,
    c.competition_name,
    c.comp_date,
    s.stage_id,
    s.name,
    s.start_date
   FROM (public.competitions c
     JOIN public.stages s ON ((c.competition_id = s.competition_id)));
 *   DROP VIEW public.view_competition_stages;
       public       v       postgres    false    218    218    218    232    232    232    232            �           2604    25208    match_events event_id    DEFAULT     }   ALTER TABLE ONLY public.match_events ALTER COLUMN event_id SET DEFAULT nextval('public.matchevents_event_id_seq'::regclass);
 D   ALTER TABLE public.match_events ALTER COLUMN event_id DROP DEFAULT;
       public               postgres    false    227    226            �           2604    25207    matches match_id    DEFAULT     t   ALTER TABLE ONLY public.matches ALTER COLUMN match_id SET DEFAULT nextval('public.matches_match_id_seq'::regclass);
 ?   ALTER TABLE public.matches ALTER COLUMN match_id DROP DEFAULT;
       public               postgres    false    225    224            �           2604    25209    players player_id    DEFAULT     v   ALTER TABLE ONLY public.players ALTER COLUMN player_id SET DEFAULT nextval('public.players_player_id_seq'::regclass);
 @   ALTER TABLE public.players ALTER COLUMN player_id DROP DEFAULT;
       public               postgres    false    229    228            �           2604    25212    stages stage_id    DEFAULT     |   ALTER TABLE ONLY public.stages ALTER COLUMN stage_id SET DEFAULT nextval('public.tournamentstages_stage_id_seq'::regclass);
 >   ALTER TABLE public.stages ALTER COLUMN stage_id DROP DEFAULT;
       public               postgres    false    233    232            �           2604    25211    teams team_id    DEFAULT     n   ALTER TABLE ONLY public.teams ALTER COLUMN team_id SET DEFAULT nextval('public.teams_team_id_seq'::regclass);
 <   ALTER TABLE public.teams ALTER COLUMN team_id DROP DEFAULT;
       public               postgres    false    231    230            i          0    25110    athlete_match 
   TABLE DATA           a   COPY public.athlete_match (athlete_rank, medal, athlete_id, match_id, is_substitute) FROM stdin;
    public               postgres    false    220   �{       f          0    25100    athletes 
   TABLE DATA           Z   COPY public.athletes (athlete_id, athlete_name, gender, birthday, country_id) FROM stdin;
    public               postgres    false    217   ��       g          0    25103    competitions 
   TABLE DATA           ]   COPY public.competitions (competition_id, comp_date, competition_name, sport_id) FROM stdin;
    public               postgres    false    218   ��       h          0    25106    country 
   TABLE DATA           I   COPY public.country (country_id, country_name, total_medals) FROM stdin;
    public               postgres    false    219   �       o          0    25173    match_events 
   TABLE DATA           Y   COPY public.match_events (event_id, match_id, player_id, event_type, minute) FROM stdin;
    public               postgres    false    226   ��       m          0    25167    matches 
   TABLE DATA           y   COPY public.matches (match_id, team1_id, team2_id, match_date, score_team1, score_team2, stage_id, venue_id) FROM stdin;
    public               postgres    false    224   j�       q          0    25181    players 
   TABLE DATA           ]   COPY public.players (player_id, team_id, "position", goals, assists, athlete_id) FROM stdin;
    public               postgres    false    228   D�       j          0    25113    sports 
   TABLE DATA           @   COPY public.sports (sport_id, sport_name, category) FROM stdin;
    public               postgres    false    221   q�       u          0    25200    stages 
   TABLE DATA           h   COPY public.stages (stage_id, name, matches_count, start_date, finish_date, competition_id) FROM stdin;
    public               postgres    false    232   �       s          0    25195    teams 
   TABLE DATA           `   COPY public.teams (team_id, team_name, coach, team_group, fifa_ranking, country_id) FROM stdin;
    public               postgres    false    230   ��       k          0    25116    ticket 
   TABLE DATA           L   COPY public.ticket (card_id, card_date, ticket_price, venue_id) FROM stdin;
    public               postgres    false    222   �       l          0    25120    venues 
   TABLE DATA           P   COPY public.venues (venue_id, venue_name, venue_location, capacity) FROM stdin;
    public               postgres    false    223         �           0    0    athlete_athleteid_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.athlete_athleteid_seq', 724, true);
          public               postgres    false    234            �           0    0    country_countryid_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.country_countryid_seq', 423, true);
          public               postgres    false    235            �           0    0    matches_match_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.matches_match_id_seq', 63, true);
          public               postgres    false    225            �           0    0    matchevents_event_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.matchevents_event_id_seq', 1368, true);
          public               postgres    false    227            �           0    0    players_player_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.players_player_id_seq', 501, true);
          public               postgres    false    229            �           0    0    teams_team_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.teams_team_id_seq', 311, true);
          public               postgres    false    231            �           0    0    tournamentstages_stage_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.tournamentstages_stage_id_seq', 74, true);
          public               postgres    false    233            �           0    0    venue_venueid_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.venue_venueid_seq', 403, true);
          public               postgres    false    236            �           2606    25124    athletes athlete_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athlete_pkey PRIMARY KEY (athlete_id);
 ?   ALTER TABLE ONLY public.athletes DROP CONSTRAINT athlete_pkey;
       public                 postgres    false    217            �           2606    25126    competitions competition_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.competitions
    ADD CONSTRAINT competition_pkey PRIMARY KEY (competition_id);
 G   ALTER TABLE ONLY public.competitions DROP CONSTRAINT competition_pkey;
       public                 postgres    false    218            �           2606    25128    country country_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);
 >   ALTER TABLE ONLY public.country DROP CONSTRAINT country_pkey;
       public                 postgres    false    219            �           2606    25214    matches matches_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (match_id);
 >   ALTER TABLE ONLY public.matches DROP CONSTRAINT matches_pkey;
       public                 postgres    false    224            �           2606    25216    match_events matchevents_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.match_events
    ADD CONSTRAINT matchevents_pkey PRIMARY KEY (event_id);
 G   ALTER TABLE ONLY public.match_events DROP CONSTRAINT matchevents_pkey;
       public                 postgres    false    226            �           2606    25218    players players_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (player_id);
 >   ALTER TABLE ONLY public.players DROP CONSTRAINT players_pkey;
       public                 postgres    false    228            �           2606    25132    sports sport_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.sports
    ADD CONSTRAINT sport_pkey PRIMARY KEY (sport_id);
 ;   ALTER TABLE ONLY public.sports DROP CONSTRAINT sport_pkey;
       public                 postgres    false    221            �           2606    25224    teams teams_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (team_id);
 :   ALTER TABLE ONLY public.teams DROP CONSTRAINT teams_pkey;
       public                 postgres    false    230            �           2606    25134    ticket ticket_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (card_id);
 <   ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_pkey;
       public                 postgres    false    222            �           2606    25226    stages tournamentstages_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.stages
    ADD CONSTRAINT tournamentstages_pkey PRIMARY KEY (stage_id);
 F   ALTER TABLE ONLY public.stages DROP CONSTRAINT tournamentstages_pkey;
       public                 postgres    false    232            �           2606    25136    venues venue_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.venues
    ADD CONSTRAINT venue_pkey PRIMARY KEY (venue_id);
 ;   ALTER TABLE ONLY public.venues DROP CONSTRAINT venue_pkey;
       public                 postgres    false    223            �           2620    33500    matches trg_check_teams    TRIGGER     }   CREATE TRIGGER trg_check_teams BEFORE INSERT ON public.matches FOR EACH ROW EXECUTE FUNCTION public.check_teams_different();
 0   DROP TRIGGER trg_check_teams ON public.matches;
       public               postgres    false    242    224            �           2620    33499    athlete_match trg_update_medals    TRIGGER     �   CREATE TRIGGER trg_update_medals AFTER INSERT ON public.athlete_match FOR EACH ROW WHEN ((new.medal IS NOT NULL)) EXECUTE FUNCTION public.update_country_medals();
 8   DROP TRIGGER trg_update_medals ON public.athlete_match;
       public               postgres    false    220    241    220            �           2606    25389    athletes athlete_countryid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.athletes
    ADD CONSTRAINT athlete_countryid_fkey FOREIGN KEY (country_id) REFERENCES public.country(country_id);
 I   ALTER TABLE ONLY public.athletes DROP CONSTRAINT athlete_countryid_fkey;
       public               postgres    false    217    4785    219            �           2606    25394 *   athlete_match athlete_match_athleteid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.athlete_match
    ADD CONSTRAINT athlete_match_athleteid_fkey FOREIGN KEY (athlete_id) REFERENCES public.athletes(athlete_id);
 T   ALTER TABLE ONLY public.athlete_match DROP CONSTRAINT athlete_match_athleteid_fkey;
       public               postgres    false    220    4781    217            �           2606    25356 )   athlete_match athlete_match_match_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.athlete_match
    ADD CONSTRAINT athlete_match_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(match_id) ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.athlete_match DROP CONSTRAINT athlete_match_match_id_fkey;
       public               postgres    false    4793    224    220            �           2606    25414 &   competitions competitions_sportid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.competitions
    ADD CONSTRAINT competitions_sportid_fkey FOREIGN KEY (sport_id) REFERENCES public.sports(sport_id);
 P   ALTER TABLE ONLY public.competitions DROP CONSTRAINT competitions_sportid_fkey;
       public               postgres    false    4787    218    221            �           2606    25419 '   match_events match_events_match_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_events
    ADD CONSTRAINT match_events_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(match_id);
 Q   ALTER TABLE ONLY public.match_events DROP CONSTRAINT match_events_match_id_fkey;
       public               postgres    false    4793    226    224            �           2606    25424 (   match_events match_events_player_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.match_events
    ADD CONSTRAINT match_events_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(player_id);
 R   ALTER TABLE ONLY public.match_events DROP CONSTRAINT match_events_player_id_fkey;
       public               postgres    false    226    4797    228            �           2606    25345    matches matches_stage_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.stages(stage_id) ON DELETE SET NULL;
 G   ALTER TABLE ONLY public.matches DROP CONSTRAINT matches_stage_id_fkey;
       public               postgres    false    4801    232    224            �           2606    25237    matches matches_team1_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_team1_id_fkey FOREIGN KEY (team1_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.matches DROP CONSTRAINT matches_team1_id_fkey;
       public               postgres    false    224    4799    230            �           2606    25242    matches matches_team2_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_team2_id_fkey FOREIGN KEY (team2_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.matches DROP CONSTRAINT matches_team2_id_fkey;
       public               postgres    false    230    224    4799            �           2606    25409    matches matches_venue_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_venue_id_fkey FOREIGN KEY (venue_id) REFERENCES public.venues(venue_id);
 G   ALTER TABLE ONLY public.matches DROP CONSTRAINT matches_venue_id_fkey;
       public               postgres    false    4791    224    223            �           2606    25399    players players_athleteid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_athleteid_fkey FOREIGN KEY (athlete_id) REFERENCES public.athletes(athlete_id);
 H   ALTER TABLE ONLY public.players DROP CONSTRAINT players_athleteid_fkey;
       public               postgres    false    217    4781    228            �           2606    25257    players players_team_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.players DROP CONSTRAINT players_team_id_fkey;
       public               postgres    false    230    4799    228            �           2606    25384 !   stages stages_competition_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_competition_id_fkey FOREIGN KEY (competition_id) REFERENCES public.competitions(competition_id);
 K   ALTER TABLE ONLY public.stages DROP CONSTRAINT stages_competition_id_fkey;
       public               postgres    false    232    4783    218            �           2606    25364    teams teams_country_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(country_id) ON DELETE SET NULL;
 E   ALTER TABLE ONLY public.teams DROP CONSTRAINT teams_country_id_fkey;
       public               postgres    false    4785    230    219            �           2606    25404    ticket ticket_venueid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.ticket
    ADD CONSTRAINT ticket_venueid_fkey FOREIGN KEY (venue_id) REFERENCES public.venues(venue_id);
 D   ALTER TABLE ONLY public.ticket DROP CONSTRAINT ticket_venueid_fkey;
       public               postgres    false    4791    222    223            i   �  x�u[M�7;]��a�M��lE�х[�*� ��Oo2�4'}�˅;��i�rrr������wO#����(v��|��JFy���w�?m�-y~��o�T��_?�n�޲���������P���[�x/���?�����{X���ֵ�����?~Vם���PW{:����t��?<�����ճ�Ov}�v��t���*�i�Y����O�S�Y���ϓ�[�ٽM����Y9Qnj2�G�B鷺<g}��9&�R���.塸����"�^�ʞy����0w.aG����@�p��
^Ó�1v�hv�YE�B�\��g��v��5q�5�q���?�k��AE2���D�ziS�[�V&BH��p�[��U̹ �(�jE�D���D D�=�C��g2�A�r�],�{�͛f_VBe�UK�84��>��+�NX�+��s˸C�����g���F��F��j5#�����	K{�84�=��\��\��S �M��l��4��H�^#:�z_F8���j�F-7DV_XQS���4�:5�����AF�����=D�0��%%�]i���g�x�w��� jYV�.x!V�A� �iOi�hM-�IpoX5=i�ZYB�P���]�-]i�FJ���}��d��M���o{��o�-�����ޗ��ą,)�+��+�̆]nP�n���ձ�a'��yG� 	��v�(oQ��;tQc��+��Ěah	�U7ܞ�p�}��TpC�Ց;?�F֊�?e��$��U.�&B������fp�U�a쯽3 '��=AC�z[+O3�h��յ졞�`;��}(g�J@�,�,�C�9��4-e�:���4��-C�csc�$�'�6����;���D�TwZ.JPy��8��ԅ �VQ��9��VTݞ�t�[���*���:���t,ҵ\i��p�V��T߭�F45T��i�=�ƅ'���<͕�Iԅ�qb
�oA� (�P�ڪ��0���Ȃ�d�5��
�ȣ�  -]0x�Z8C����;C�{l9��ƧA��@�{B s�^B��b����nQ�8j
\�H�h�#���C��VWb�җ8�`�\�`l��V� {�D�[DO��	d�Qj%�i�h��^���2��2�ќJ�@_�=��Z�k�@}EX�*�7c�Bf2���inc�D�}""��+�}zĂ�x 4@4��cs������:4tФ
��~��n6�As��;iȘ]�
Ȇ.Ҩ�l�g����"���Q
�m<HImC�!�Lo��mJ����`���0sVal��@��6Se�g�D�i�z�X/��6��Bďv;hѭCٷ* ��ځ�\q}	�|=�-��a���s��Y@��f؂� M�ì��$��lG7D��x#�6��1���h8��F%��M]6�
�R��`B2�S�<+Y��B��vWŚ3ڈ��		���10���lz=�,8ܵ�9�s�^���t$�I}aT�S:�1�F���6�(w8�Д��9�S$��36���A��xL��0P.Gs�eX�b��vv]>ܳKbB��PYQ>�.�B�ݡ<;��V��{v/��s���MyΜ� ��@b�J+�`������]�a8ݪ(1��0@�,e\o�x���$��tL~��(�i�rJ�	�} o�\H����M�Tk)�=��'�gb��)I�Bb艕�����l�1�˕Z0&�Lg<�hB��i-�̆y�W�[E ��[	�\#���00~�jgu�v�  Z�#W�?�N3�@��4#1y 2sa��@��IR��T�| �x6�R%�(	�j�o�G[v�G�6t#�Xq�#�A��o��`��CR+�
��b孁�ںJ���a=~j)����V��RĞ��(���K����eE��͌�SM�//e_�݌u���mf�^6۬���N���a��@s���|�?�i��=��'��NU1�Y���"�!I�Viٽ��k}�MJ��-o󗯶�n'X%,l�˷BiWD�;yLs��H��v�����_��lk���w.�������݁rC�;���k��1[��h�P	�/t�༗���cz��s~�6k�<O��<1U����IF�m���tYi/�\R�O�>#���Zꎠ��5i�#^��	�;��X8�_�FN.�+B��pO������o�T�x"Ǳ�-�B��l/�?$��u�`u��|p��rV8��%�iӡ}�M_4���?�CwQ;�����jx0�r���!�}sd��^cT��|C}@ڦc�m��I*8uB��J�k��\zlhp�����y�:��=��S��zc��u��Q��_f���Z�Sc��N+���_Փ7
3j�*�������z�w���(�L7���-� -�����ɨ����˾��6����t������٬ˬ>��g*>I��<���)�];Q�\&���e�����~�[4��w(�����Y?�Zrhɓ�齣!���>.Р���Ծ��+��m�#�����1��Ÿ|�~xe��ג��&���oN���sb��f�U�������2��
(�L���;p��O�VXU�r���ٜ
����W��]r�_eG�H�2#�5Z�f���$�C�jŹ�Q�%��R�ҳ#��g�u~�c0��s_�"�#�T�5��K=G�R	�\}��sEpN�)����_�q���r�=�id[�|��OTFZ�TR�_��T�U^�	Q%V�qY��.���,�����'��� <�l�~�n�4��dCl�$�i&�s�v?x��=���ݱ� R4��s�������S�˸��t���m|��#�xs9�p帥����U�G!���ݺOկԛ��B�5�W&: ���"�k(9e�E���a������u*P�8>z�o	Fˇ���v5��Dħ�\�^���z���C�h?'�/k_�؈B�3"ל�W39a���0�w%�L,�?����ౣrQj=g1{n����&�v���St��q��}2�3�˪���{Ѩ8�Z�%��]���C�#\�h�"(,"��D�|�yX��(��}�1`P& �������<��1�@9z�ޕ��=�ģ������}lq��u���U�L�!�a,�؄��t�Q�������`�KpL�s_�8�‘��K��`W����Z�!j~�8�N��N�n����
�!�+ftO��>!]֟4{��a^�F�:~4㗜��t���߁k��;�J'$�ݕ�W�Տ?�$���      f      x�m\�r�:�]����^i���R˲-�Im��T�Ul�HY%����9	��{q�:�H���D�Q|[��[�����Zo������89K� �Wq�wz�M�ۄw�z�Y��,�ϒ� W�Jw�Oս��(S�E�YRqVB�>�i���C��"uzgQ�I�*���vm������e_u|Gg�PYA���������U����,��!G�y�F�O�vKD��- �?7��چ_��)9#Ζ�Jqĵ>��׶~+G.�	���S*�}x=�~�N\PCq|{�}x9t�Bk.QYP|�������Z.��ϒ,H��$.�����y������������v���~��7�Q�����n���Β4H".���I�n�^��j�����5f#+��av�Cx�Ƒb�j!��$I YY3�O��zݩ����{��̢(x�Z5�.�DI����7�+[Շw�n�9�0�x���<H�l���N�Wm���<���d���͖f}��v�T!z��Ѫn����M5��'�c��a����+���Wh��-�,"�`eQp�Qc�;�?�~�G�fS�2�lL
~�o<�y��F�۷Ƃ�����K5�1�W�	��[��)3\X�#���7����\eN'NS,W��Z?��y�gz��2��h~ш�����wW�?{��Ow�K�x��:@x��;��j�L(ʀ�\����]��+�b�=l^q{�TO����e�P	>~5l۾���/4��ﾢza�+��ݰQۭj�xsm�5��u?�Z��1�6Eg�#�!R1�z��ƣӠ����V�����O�o����ڠڔ��/��nxC8�	����|_�������PW�`�Y�J��k_��k�=O�AV���NVi��G�[���\�N��b��0�E���~��x���0���<�n���j���1�y�̔��8��ܫ5�ו�!�m�Tl�����Q���r?4}����VY\駁ڿ��;䦒���r^O/T��>nb
V�
�%�n�:��Π����,Ye��F�m��`���5|��\���o*<�k��Ϯ���F�*O.����5���.Alϳ�Q���A������Ip���B�����{���V���%��"8j�����e;k�T�N�*��'#t>��M�:��>S��Z�i-��zŸ������;�ߺ�m��q~*[�Qp��+�d�<��i�K\L��J�N��t:'����Ve��ֵ:|��fFp��Y��*^�yp���n�\m�tƬRB��ɬr3��w���9�*D������d�� �>]������j�2-�GL��]T��(��= �~W;'u����*( ����J|/�I�U�+��aR��;�1�����' ���N`�*2-����o�~C�E��sH�UU_�-�����#��sj���~ۇ��]��}%�&.!��+�Cl��bt&z��\�\p$̼�=;f��)�zU��
���ι�W^��"���i���3�߬��ݎ�vl�/i�I�P�/7|�9jb=�uP��Fl�#OX i�4Bە�?c㹪���`�4	>����a[bgQP!�.rD�'��`�O���]�"��Y�$�?U��?�:
��E��U^�`�m *��?��j��6`�6
2|4���]�/���2,)���� �����	=I8�������F�{Q���>9A@����,�3�!�(~94Uu�OC��w�y|���Sy@�]�@��7�8-7�۹֟ё
���'�?t�& ��'��22h7'Qa��:���3�SH^篛q �Q��Z{1���������~�N���iqp����Z�qM�Ѡ�vqA��u�mx�ُ덟��x\*�GP���O�d'-����n���'��T�+��A?i0�}�һ��k�|%i�Z7z
�\���x�ZF��"?/k�H�.aI��b�-2����!���"�}���� �{�)�Y�CI��;��]�;-��D�m��v���eSFg@���d?Q[��xmͣ�֑}�HA���N@�D�D5�V��� @�k'
H�<��r�Ո;oۑ�	��6�8�2N��TD�)�zU�-�4�E��v(8:M@P�K�������c1 ��N�j��?�Z�Ktd����s�O'E�C-g�= ���;L�+�IM"�j5yO1�6���c�tR"-�.�o��@�m��o��` gAzyب_-��A0�-�������H.N�O�5�2��2��wX�z^�bv�,��XHuD�(Wv��!��~G8sJ8D���.�Z������|�Ô��姷���d�Pn-,��$��G�I6�\���H��\��&Q�@-����~3�u�[ *g����:�X�����|b�\+�PuL����h��	$'�Crw������Œ��p	L�V�k"���O�P�
���ԃ���ô�i�4D��j�x����A �Č`�R�7"�;���.ߤ&�%�У�$$c1�X
 ]w_k5<PO�o:t�;�*�ԂC��K\>�EO��G<��M�@�
�)�!:Fn�w�N,@&>H� gB��o߂R�m�&�>#?�S(Kk�����}x�.	άc�r~i ����}�T��R3'@\���1�wڂY5�� r��GԿ����.a �ހ�uG�� r����b����ʖ;~ޯ�4���BԈ�A��lJl�L���50�~ڜ���A�'	d ��zb���t�%���J�'���ܦ?8��:��K,�
�ĉ�����xſږmx�y\wR�2u�S~����$��u�{�%\��+ ������B��U`s�~���0rc�%��d��g��h�!!=n�n�a���`X����;�O���%9+r/D���Cy?�7�;�A�q�k���ܟp�X>L�.�.�*!�׉�R��n��#wQK Kl�d��}� �ـ���b�� �	��1��5�;���` ����7��l&�D+ ;z8��U�o���)L�����7zP��$����UD�j"��q�~%�Q1��o��>�n��R�E~���<MÐ�Lը&��η�r�R}wk��7��T շ��,��$RU� ���_�� 0�j����z���/����T���R���BP�����^�C�n`^id��_���J�� 5��.B!�P��k�Ÿ�SJ�¼W�����G���+�Fww+Z��mS��I��ө[ӂ�q�Z"&pg�yoZn��RRAc-$�ƪ@� �u�t�_e1���Ri*t��x�b�[a����cST����NmYv���Gry��, 林H8�)�_Z�;����޸g(�EP\L�z.߮���+H���z#�߄?,����NU ���v�y����K62R`�ˍ"���f0c'��]Z�H�`�jr2�!gN��p"��V*S�Y�Ǖ~3p�� H����R��.i��Bd���_�F}���~��}��+e���� �C8�F�	���p�����D��	Dա0�<llH?o4M������Y��*1��4�:y�2 ���c��ب��Jm�v���R�ګRep��,%��Z�p�U��TI��YZu�o�`�I��w��x���!�a�v }W/ Ikf�i㇅ܔ�q�Y
����0��5��]!�)�4�vX�j�Ddԑ3?��Ŝ��s'B%�L�J5���q��%i&��a�!_n��U���,eZ�7��}[���S̓�7���6>�0˚Z��S�S�u�$��)���ˁ1��peIѵ=R��'p@h^�'�#�Jz���H�H�'�]'�h)7|��}'">���İ���j�f1@�sA�*���~6�� �K���Mo�H-����m�<��-I7=����rT�vnD6�-���0�B��u�B��9�Z��0�\I����s"��M����1��F�*f<o����u�    I�<�@�;�؞��v��G
t�Pe��	�G?iRӏ`��<VN��g�^?l��ˌ�E������f�޸���Ѽ�b���B)S(k�#{u�cA�ܣ�a=N0|k�j+5�T"����g��和p����U0Vd&IS~ر�$�iǪ����(c=��N��q����L���p�e��f�j��-eI�DT��x���n��?>�$C��������{���=\#�(���s��q �BX�Ń6
��n$,l�G#�U	�k/�V�z�ݯ�>�m�eSc##F�e�f��7K��5 D�se�-X薎p��m��X�>�7�g< 1�b�j�z��38Ol�$�!�0�M����?������N��ȡ�y*š�V�AGYd)��Ez���\)_�! 5�q�2ּ�L���%y���m�8���
oc�W"��6�QVC�E��7�C��b��b�⍣
!������G�7�'3&O �+�����"T�=�q�����דC��>~��X[�T�<�\�6�V��C�̑�t���4����aD��2Y�phؒ���2[;�@��_p�i���M�����c��>t�ݴ�V	[s,�k��geK)��F S��J���
ݢ�H��\��
��cYF��"���0�²H1g�y���@��B�rvm{^��������:�����
��B�c����q��si�P,B��L��/��/�PRFv�sǂ����%5MH4W�~�zרL��j&�̀��L�ތ����`{I����֍���S3��S�ӽ�T,'��Rv�9 y�9Um{T{��0�O��HIT.�܏�8�gm=f�΀�mnff����J�����z�m��k��SP�'4�k�g}�5֪�	.8��x�c(m!�J���,%�!�U`� �?['(p�,��fR�,�0>�G7U��#ke�����N���g���S3��Fυ�Bcsq�4�D���y�cz�t��{5mT6��XfpĖ��d��뗋��F�L.��Ɖ��l	D
D�64�s7 X�	tq �e
ۗ�JBZ�y�y�+2�Z2�O�6 C�Y�^�[�`�O���1�,�\�Tˊ��}?�1gʌ�r=�������_]�Z4@��9���v�tP�t�'�S�O����!;��,����{���s0��?��bLg����d�o�7;�{��9��H�Բw2�T��A�{3v噪lo�ImK�YK�\�N�r���H���ޜ�����?��|(�L#��~��Zl�l�H�#y���u�������~xS�!�K�:\*~�����1�*��M|��mC��8U'�@� Gs��=�h���ܚ0�w�GG
�FYu���� �1(F�e'sM��-�*e@�9 �4~�2}l�Hֽ�k�,����hxSV�4�+�j�v젶�J����2�8�dv$�f��� �f�椄�@(�dgkB4��@?f�P8�Dx2�X@nA��r0��+�
Y�2�����88�/�$���6&|�5�?0R&���L��n���o%g`�*�8Xw��V��u@��_%fv��Hn�gr�`z�N�N�����,�L�8E:2�����d;�:�RwL�ʡ$���#��ock٧s����D����ewYǜZ�l�Ɇ�����*���ڵ;�؀��u$3e���s��q!9`ͮSӲ3����Q !��g<�6�4��:7�yD��:]�=7��2j�+����b��1$�q�O����J����)�|#~� {��I���8�[H�S��IUK ׫d�M�������"j3��!�ar�.����<BL!W�O���$��Kb���G/�6�T	���<����=A�5�R�K c��{1s	9\���5�|n����Ay.�ҵ��I�%��
Vc�ґ��%�����g�jhNn8�uq��CZ����+���/{P�P����Pv��<!D����4s�F`��+�Gu �s���d��z�6M��c	��>�tT���+���d����ǄA$>��z�l�smҗI!VH8-}��Z�D\���j�<���A�R�7�{����r������g�q������SKX�c��1��X�?�w����?�T��ҋ�'�Lu�<*�����Y�i�Ld�8a�u�oM�M�"���^��2D��"�P�׹=+р�*���N�h�6�CX'� �K.qw�K�E���Eb��0�{By�W�2�z��~+'4�v���8Ϛ�֩j����p���ʷj���-��p1i�!���cu�C�H���tz��9��� ����֌�XM����7j���9��$�G�*��i�{��P�
&&�	��tz�R�2df���Vȓ����<|U�~)lM@vC����8u���܍T �4�������Bbا�R���(�.c�|� �<Kgvuwp��L@Ev�Y�tw�� r-لZ8�����_H1��S
$��,b� %v!~��ـ9��m��=�����1R�9��O����S'	�ɇ5�}�7!.��Ҵ�0CY�/���^�\C�a��$�����z�p��=�;E&�@���s❡�"�����GNQ��ZRsu�i�]�]H��z3g�Q��m���sé� ?V�Y)�{'4.���M�����#�^���%��OE��,"  ,�N�I�w��L��E;��i�啒�X�s�<���W�%L�#5KI��eG�ϊ�T�m�</�8h��Uh�>�ݹ�����_H��D+�b���[�l�e!d�������&
e�t����J�`����~�K4R����~�w���<�1�fbyel/��sERSk�n@C�v���~����*��3��N�Jm�T6gso�;H>(,q ��^��1|*��q����-s�ߙ��FY��ޖ�
�\<G��!y��`%[=�T}|F��<�H	�	2@A	j���Qb�
0Ź�yx��6����De�wR�ɒ7�B@C����J�y@��aby~�W���_�q���"X�Ї����jߝxdm��̹QG�����gKSs�P�
�H�'Ѥ�TUKd���v��ט-�AeL��١Sv"�,�Gb[�����i3����6\�_�8x3?�t>�ˣ�$���#s4�2�:f&��?;�b{�4��7^cľ���N�?�1B�ɷ\���>/u3��y��S�2�� �5��x�2+;L��9Ś�ri�<�:U��@=�5����o'\�
��[y��K�>-��3�r21�z����iO�`���>z���:��7��"J��$�@��N�B��,t���ߪ�[ �+t�n�BN~��q9˭j�������4��P����uI��BSd'r�:U�C�3> 9vz�ǹz.�p Z8�����BxC�|/q������Q�����(�[��m�c|�&��r׏㹉V��d.6����Ive�ZB0� U�}����v3�]���Ư^����Xo�a;�<OL�J�p;�?&�!���c��Y�oӓ{)<�N]E��_o�4����'�ܨC��_˕r�.�<xࣳ7�B�s~-���m�S�0.[@?�_��XW�0�V���������'��?@)>h]�����7Q�a\qR�-�����3SSI9�ݾ�bq1#��|��~���m+X��;�FfZ"Q���#����9 r��� #t�������K��,���~�{R��u�ZLEg���;o|{2/PY�/H�<��'���W�pX$�������n��BA:���� =x���������=�평�#��Veə�g/�)���<޲Ϛ=
 p���g�~��?1�
��F�M�Y0��f� 	4��� !��.3�Ȅj~Oy��E�X������D�zGi@PI3(к��?�٦1��9�(0�9�}[o���<*�����yL詁�U�Ɋ�1��f�B��S�ߴ =CDsYnH'�GR�?�LV��t���<~<m�f�l�b�N�̆�
� ��\�y�3 �  ��z�`���v���<&�1<�"/@<�F��?��8	���|����ҋ�o��D���n���3m��O�l@�>�ڋ��D��A��;��9������l֍\\#7�~S�(�x����^��8l�S~u�d���
�s�� �bS�-�5MN	�R;�U�d(��	L�dw�I;�#nz���@��U%�{���h�VU�s��[��]�׫���DU�����z����vͫH�.�A����e�#e����*���ٸ�(�B�w��8�����b�|��M�_G��-�V�w�l�iW��� ���q���;xW%�-�HV�wD����D�������������9��6A>�v��HA%�K�(-#��RO ��� ��<��U��'�$��/�x����m��R^T��7���S4 ���CP� �"�!)�����������y5�1<�=7'ǎl�1�ŉ��FA�Λ=��n�Q6ѽ�h��y[%�<
�w�W��L$�������>˳�ȘFͧ@�>�2�_��Ńt��O~]1��\�ep�{�����o�ӭ��V���ҝ�M�wx2�)?>����5�z�4�I3��oZ�E��T��(i�,]��\�\�����L~�X$�g��ɏ��J> ������N+S֒ч2�?ǎ�>�F_	�y���?ɺ�I��dʙ��~p�i�C�^�|rR�_�Z��|�+Իz2/��Ȏ�N˴�}'�ɏ���Z���y3���S���I���1�y���j���<�p�w4�����K7�ځ#l�S�R��ɖ���S3��e������il�󛕰�I	O0�_f��;"2C��c\�G�^t���O&f��R0�X��!��B�̧"!���͌�Ac\j�_�25O���J~��/��jvZ^}<?��9�����\d���[��ƛ�@�Z$>�����ޞ�L�)p�;K[TF�^&�S��V��o�Z��C�`p!|n��ȼ�+W��_�������:      g   n  x�uZ;����O��!Q���p���s��WivDN��dQ5EQ$�T~Y�������?�����������_+_�F������U~��c�.�\���]��rW��r��_p{�~���[_(���qԶ�hvM��_�W�Z������Wi���Ϫ�q�������g�~]����ȕ���n���z���dٕ۱N��>�v�_��}�����G68pr���� �d �֓g �9]���{�@ָ,�#�y�h�%`����8'�X P�&��o/�5w�o7 ���k ~���Q/s#� ��e���3"�_%���
@J���圀�>�bg���Z�J96�s$#�z\E|��c�v|5[HN���d�����(2^�Z��5�@JOWY�k����v�tT,���T�H�'��|U�`��c�f����Հu������б�A�
0c�'�S�"R�qt��@d^5EY HE�^�m� �����
�mg 9��壂������=��@r�@�䔔�V��6*b'�lO����C~[��XW{��@���<G%�B�c��@r�WOOv"�nH�4�K�#g�X�z9�ʾ}H����t�,(َ�䬀��ޏIr4�.Ʊ��;"�c}�ŕO Q�!B�'`I�b�s���v�F~�z"s]���S)�����~�z���d�k4?L�aH8��n'Q��c�q��o�����@*�<R�{�ɽ��L@~f~� g9C��>l (���!�&| �u3d�o#��k�U�q�k��T}�5�5Ǔ�ɫ\�/��
��d[ ��k��b ��ue������+���+�堁d�r3���H�ӵąŢg]�W�s�ƹ� �����=����=,�P��$7ԯ)=}�PI,���O,}
D�8�؊�tN�'�;�۰r�q���A�(�#oќ�R��T�i@�� �����;'��U�@hqˏ����&ً!qrBٰJ�rH���C]�� l.���rD���ٓy�U�v����#���n?���wޒ=�v4v��9�P�@ۡ�7VDhd0������W�"�hK�3�g�$�,��� 	��Y ��
���sp=�M������A*�����ẉ�L��r����<(�s*�l�Æ�g1��(�o�N�
��A���!RKQ��>G^�B5bt�~�fF�➫�X�Թ��="@��C��-���EB�U���!� |���^��

�c@��)Q��`B۴��,,�DUa����H{�
U'��!T�cj�c���7����֘��ݬ��:
 R�ܒ�FD 5Jx���
E�=~���ܮzM�T��s���'Uq�U���	\n�Q7 ��c��"�}��B� �'Ĵ�)��
D�s�T
��{{���(bǕ����Ͳj.1!Te�{�� P��D&�D>Š��io�0�Q�Z)��?��ޔ%T)��O�dU��Vi�C^�q�Fv_�U �i5V����Vw���T%DZ��$ڳ&���%�[�y?@�p�X n�{�0���g:�T�
hA��L$ ��g�.�����n���Y��0�7 ԓm��h���wpz�����T>��N-v#��m�zI�!�!�B�TtY,lqW �r�1���b���
EB�%�.��� �[�����F�����
!���[�]��B�E5�i)��;��_/�L��k�&mL�R��4�;�Z�H+�kC=C�[���Aar��}Ԣ�Tr-K�ۢm��;҄&q� �dCਖܲ�	�g-�Ϛnx��c��MuB�|�o�J�:����%�Ery�FB#X������"��� "ɲ3v���w����&�s|jVB�;TA�&��̜�Q m'0��am�]��a�iq@e�f���"tX��;���7�B�Zh�0�S�=[ߓ3���`����P\:����QBe���g%�*(�,�0=�k+n[=�¶+$B�%��ъ���p�z�:#l�nXO�D�n0X	�WUEU	�q}r�	�vW��b�ڇ�eBX$��lFU�El�A��ѱ	q�g^eڂ ������ �i�U�`UH�8䭡'�3��>�0���2w�j���	��߶��܆8Ώ7�؜5�a��db0Ko"dC�ћsu8B�-a���%cXi�/#[&Dώs,����L�Z ⷀH��y���zQ�F�b��!T�^�w e���f)@L��<��i�����о��C�&B�x�P�q?�+�t[�J����/B�O����گ,��è��<����+�7${�$b�A#���o�0�K 9 B�	#T�5q�Ç�Z�b1��9B��0����	�*vO��C�����}�2���=/��ze�b���=D�0h� Jn�c[��3!��������`[A��`zf`v3?�F�P��k��-�ԟ�,+<�U ����w�����#�%ķ!ؘ&*B�1+p�A!�C�����Xqcy�K���X��Ƹ���>8��F��XR�Ǟ"!F���G���+����]���E>�M�
 ���|�-�@(�J^(��@�,����v�(ҟ�"��w�m��*��@�1���Jv3��/�J�d��!�}C$U$�l�k	�L�"�m�C��(�;�:�wH(��G rQ+��Jh+�V%`Yd���b+���R�%�U�pLr��qn��������ТD`e��2%<�I`�(d	�1}TFR���_��o&D�k��q6����W����-Uw��8%�Ķ�5Jx| �m+��}?��a{0��d��-~&�9@�2>����&��pѧ������nPN�0���J(n�jk�K��V�'��`�	�Ƿbl�!�ʇ�<�J��[Li�wP��7�o"4.$���M@�! �O��*t>zd}Kot��k�҂���������4b}@�^�I�F@�)��[ b�*d�j� �S�p��?ñu;@��J��E`Yng<�R�-�@�9��i�ЈW�u��g�z�H�P�ڊbBФ��v�İ��������w���
y'T�����T����+g�ð=�o�;$d�Nxݥ����"!����N�#th�aM�m��Q�h_���\��o�<�6PM�\�/��'�+�gx
� 8�;?���m�!�2�{��� �-� ��~jRFHaj9r��n��Iez奦�|�����N$d�����!t!�����=�2����)jz�F���1x8�(Jh�8T��}��N���O�Y"8E	lLGc�@�/�
�]�/<	��BDЗ��H���N�s�Pz�Y6���1�,!��#��
�EM�>���!#r1]cmU��RA�e�����pV      h   �  x�MXMw�]ӿ�˾E߱Hɖ��L�I�I�����6���jh1�%�(��] ��+&E���ť�Z?���'F-���ڪ�$W�fb�q��>x�1l�}g���M/l�t;��d��q�0�Ъ��5�Q��ݩ��״.���SY��.nl��m�����ў�0dD[�L��{�s�<�
Eﶻ�K���y�M-���ݑfJ2�G�
ㆷ�3uq�Z�4��L]_��#�	�������,��p(���V,x�G�iob׸z���8Yo��3�����a5�����^�S�J��kv5-��'�	�gw䭙�>n6Y.�@���;�1���N��zk��{�6���l�>�FF���4�S���|8n�俄uA�&�}���J�����{���l���am[o�7��N����)��tXF0��u���a�N��>~����	�$��Ϯ9��F����&tmMV�>�c����$�F����L]n; %�3u���[�Phu�֟�9�.��l�/?����Yġ��e���
uyj� �����5�M�P����2W���o��¨����L]E�l�g����5�����v!�kz�<�����(��A�7�����1����	�R]��h�\+5d1K�_/j`���.t�l��ꋭ[��¨/��u�q��/]�pzQ���K�Y��M�cG��Z�h��]�� Pe�_H��*�V�w�;UF����?NR�U�n-��O��V
���[��M�%�����7������Ie6�(j]sj]Mf�L�v �e>[,��и?�(��B,V��<Q�0�s����)ZG�^ju�Z��Ш�s���S������7���L��;����B�1Ǖ�����ǆ]��k��R�:���΀��اe������2������-B�oG�q�}�=���q���3@�[�iJ�׀��= ��:D�B�]�Iz�PϖB)��vW��e ���z��`w�mM���5-S6�����:��Ez��@^�}�g���!�S�6PH�B �zZHS��x�<�x�e������ ��aH�#��(��#2��<r��A:�&E鼶�Kr$��x�GU&J��x�|.�ބ
��{�����.�S�.��=M����i1�%����s�|*TƟcbQ+����`�a|u�^�#��q� jXh�ok�}z���g�v�����8\{�V=+�u$\P`�l��{y	Y(U��̔��Tw�.�U�*�@�a�!	���Eg�됄�>�I���V� �� ]� o2�C<�~�}���,Q�_P�NA�}J�r�6�Q�fr� �
�Lj�����D ���A�!
����<j��+萚7��������� ���(� Xۤ�4��H<b`e�K�)�j�w�����g4 ��9�x5�F�zYJ���AۀO�i+s���w�v�^_�1r9�8�O�u�{?�����"A�}���)�����#�?�"�R����G�P	�n���ކ&5F���d	������^�E�g?�S��o7:�6}����t�Ss�����Bx��ג?P'����W��Y��� ��2
,G��db�� u>yp�x�D��{:��'F���l8�lJ�{|J�F�`���)�(�����F�tDRj��(����+�U/�2B�(��_�(�~v�!��6�}�Y>����R�Ї�0�HS��p�)��X@����F����^R��a��?g
��D�Q�ԯv'df�49�1�$�Oi J�<;�� ��A!� �/a����M�5at"�^��)	ͩ䬓�i�֞�����QBt��Q�1=;W_�yK[ >�&!"���戝��p'��B?�ddAu��4f�!�a�.�&�ؤ�� ��ѡqp	d�Bit�,@�r,�g_A��c}g�B��a8)�p��)8ӳr�>��Lb���3�W��ր���hX����	t-���\�g�U��C����q#11���T�]��w,h�"#5��%mt�#�0���p��j�cF��N�.y��'��w7�>me���rL�������rȣ�m��< ��I�)* ����\��I��p<�
���j0�w��.٬�@cv���S�Ù
���4m�&��ɷ�B;8�r�i���A��>�ֿB!����S�29���lA;}b�I�����u�o����5�M�J;, ��i
�?�[ ^�p-�����A�}ڏY?Q��>=ѿ�E�~`�e|�	'������y��"��W6U��?��̀���f����xѽ�,HuIk6Dܶ�\���Z'�l@�˸���#��č��}�N3*��wE��o ~��0����P���0�C��a��-C�R�N3%E-�J�zMrJw�'�i�so�����F;!�HW˿�T��c*�>d�]?`����D�1(u��A��}�?�#���p0���]��!x�$(9RtC����_�I��^��%e�^��H�³��a����e���sx2>��V�+zt����B���4�@�1�+Q"d��g���F�P�^J���Lڴ!��I��e*
~uI�`(%]R�F���B܋ơ��IL �/.v	E5{��hdtI4��ҬS��I�[� \+)�t_@�ωr�D�"�% ���JAiId��G��*�5J�hЛo{a#Zf�֢F��P�3��dЉ_�5t-$�A^�sZ�)F~���gC�:M�d�f�.+Z.n��T.蹤�:�q��B��{��=*�;9#Z�ʃ�I����n�T7����7\�r�e�7V>J��%})�/495���V�Ƿ6������W�u�0�1��۞������QfJ��4W�ox��slr�n�i��D`����h7�/�mh��׸�ih�6oim��vC?��H�3'��H�w&��T���8�;�������?�c:��l��>�n8	���qo������w2���6�      o      x�u]��5�m�Ϲ�\A�����R$U 7�"����~f��g%J���PKQ\��Dj��	��_��O��O��?}�7���o�������o�����'}���
���ڷl������ߎ�Ͽ���������7�/��I�����3�
�����7�G�,M�7�O��M�7�k�,��>��=^ߘ0P��,s��L8�,���B��,K��8~Ĳ���~f�5}S$'�ob��YX��M�?�r|S���lK��n���z�fv���_G[���Q����&O����'}�s����:�2r#<��o�Ĝ�K�� �L��o���6�'�]ߒ��t��JY����P��'���Z�9����{�oe�u�h׷�Uum|���jj�-s*���U�1}[&<�<b�tb}�lh7���-&f���l�|���u�A坽w?�ҷ�eU'�T����F�m��V ?朗�q�Ϫ������*�n��U!|ϸ�f��v�(�;�73�E��}'!�(�O� J�\�m��u��
u3��C�Kh8r��CG[�4����Bz/m�� {FdR>�A�9#��O]�~/�!d����:��X$Z�:C� rT��];���3����~��|�5e��FV:ݺO0�0oD֥��6�����[��҅����KC�i�6��J����j����y�(d��W�(�l,0����ws6YC�����DVӒ���x����2N�]$�bX!{��޴bA�"��
K`t�[�gL)�m���b@
�a1�����W�C�B����`�Hp�ֈh�'W�н{��d^L��{7NaH��<Qh�&"���0$�po���9�7�a4����޸A��iH4d�"�Q�y3�b��#�� �!��[��W<eAnMb41�yQ�~�T�NT2��*d��m��b�'�S`��6��\��F>q�`ga�"�H�yD�v	)�ۆ��%�<7�],&PI޲D"�L��D "��9� l���	_V+���^&3K%�a��q������j��/�X�Q&�D�Umu�G��F[og�aaL�?�[�<��`7`�#�%�ڶ�bFy f0#An�H߬�V~�;6뵭��/�5�L�vN��@	0t"��^e:�?��d�`!�0м7t�,��q��Os��h��'��چF;���h���V�֫g�0�Xoʲ��N�܍0��O�7GS��#��_���n�ɈW�ڌtv������R�x�f�;2)7�e��@��.q�AcW5{~\��,\�t܄�`�-�#Џ���T�_��xc�2�V̹أ���)�d��Ǔ�-�ٿ̝�h��?�R�8PQ���~1�4n{��)(l�~T���� `jN�������Gs�mѤK���;���- JW6Һ�J��;�ɬi�w��6�a�8H��v����7��G��/-�q6�EKl\���K�g ���X����S4�㵭�MDqpL�D�#vM��C_P�Q�6�h�ƶ �X�Ǘ)�ȇ|��h�H���H2$�e�ې2����b��X��I�7��u:tv܍2�nv:uK	�#�ځ���ɖm89.�N�6&�ˤl�ʏ�&_P.�ⳉ�ߝc�&_^���RL�>:B8�����.��-�L�xHj��Kw�#�1�t�cl�C@u��:�y[������H��:ǜh���Xj6�6�1kj����W*��?NP�y�|~4�O���v��gzC1�>	����g�Є�(��%Z~B�$&�a��;��Ywr&�b���|L8�&���m��,�|�I��e�jR��ɫT�s�4ޤL�g����;��Ag�y1��d�c�;�lж���D�s�x��~������l��!�F"T��ASNR��Z"r炤D��6�p28�	�y�MJ��I�m�.�7ð��3����/|����7W9ٰҴ\8�d�:I�F�O�	�����䘍�z4Y��f�لy�5UƳ�����!�z�n�6Y���1cw+xK�dlADi�]I�������<���,e]G���b}��Mc�\Q��X$��r����g�T�$&��LM��%/1a�~R��_�N�EZ7�\�W�LD�Z\<}n&T�q'�5���g��$�Va�)�4������	vӾ�g���s����ף�܃�a��s��=.�V�۸��l��ۨf_�ie���I��������v~�{��cBLP8B����F�&6���w���8܊�O��dϒ b�9/�].��?��
 ��'7ʥ��c���m�?j*�8Q��ǳx����
v	Q��	͔��/��+:������y��(A]nv��tQ�/x(�!��,9�X14�;�B��=Ľ�@��դt6m"�g�lޅ�8	v�о&5ר�$	�/��J�,��M� ���lx��˜�,���םSɒc��hO_>��eS�����h�+S����жW�9_�6��amZ��t�sQ�)���%�d�`_�@e��j�"��)|F�xci����9J-�ޕ	P�Ɛ��k[��L�O��А7�>}7�׍�O�
-vctI�X7�@]�Rh�s���,MB��x�Bsܘ}B�B;�>�"r����l�K�\�ѣL]2�7)]"��b�7&B�D9�ig.� �I�3phO�ٙ��<���7_[h\��s±аveG׾AF��F���ʔ��Ƶ+M�N�R)L/������Ɩݠ9�K���ǔ�7ZҡT�<M*��P�ԕ�T�ҡ|��W�ʡL������C�����F�4>�`t�ø��5Z�q,QR��ʒ�@�Җ�K�s�MLoM��k49�;�k2�<{Y�`r&�i��E�>�79SY<Ah-ĩش�v��4�T~'Q��u}`Z�j=�5���� ��YM�ǲSMgZ�+z�g����^&X�2۝�b7<�� ��	���)_��~�Q���A[YFEg��V:����.�$hx�Z�)c�G�^ދ�*�)��M��
�a���� w��	=�@��۰J�<^�isՠy�J��}�z���`��fU9Jw�8��x^m�y��-
�շ����1�A?�L�nt3�-ܔg�UZ���-���Б�x�Г�6������L��Ӕ!�7�6se�)C��g�W��_�t`�iw���_V��I��G�r�48�����[���mE<��<+;�E�5�e-%kpd���L ٴ��lxZЛ�l�ċ[��/�;*�&a��1���k�d�kTܢ��\�����0��)I��p44���'�l�X3g��j�X"��������4�$��l�������~�6�<���_T=�v���E�y_cadQ񀩁P7(oj@t/��[�M�w[x���E��~�����l�mK�)�*檍VlLu/Zk��� غ���Z��αA�6\p���q���ZK�[5)��[�����1E��jJ�M}�OjJ".+���)����Y�����n�4��0��"���~N+.@֩76q����� ��6MICw�ѯf�5�/�[�
D�J����O�@JFZ�#�Hi����s1l���� ��$�fк>��,�������)�^�p�=���2̣��޳��C��|���h��5؁<L@_��*�h�l�bڎ�{2��*mt
9�P��>���_�;�s���t�wtOؗ.r��M��d�se_�	E�2�.0턇����8��1��^�&̼[��Y6��6<�}L�B?1���N�p�Gv��I�7�9�ovu�G��_��F�>��p" ^i).}�m��iS��%>�}�@�7N=�dY�_�FgSo��25܄9��j<5��٦��H�
�6O��`��%�g۳��_�)f`�X�Z/�T߆]|/&��m�
��(0�5��6�n�tV��N�.���>({�o���N7�Ȫ����u�%��L�{7Q�{�wӕ���ML�ư����|J�������Y��.�/����rT�M�q]F�m/�ҀԼ���(��i�TD
[� Q�K/�K���p\&i�ΞF0Iú5    �����|�ވ�+���V���,���*�5�r���6R������u��0h(�\������t�T�8b4��[&C�2�ϒ���\m�T��(o�� OAn}b�Ʉ�վ�l#�<iKd��>��H&��i0<##���R�ssPe2U>^��&�����\Y�To�G�FꏣY)���cH�,���|�z��$�����/Y��l���u��v�4���h��(ғ�$�a�V�3��>��W���s5��@0N�UÐE3Br���[� gQޘb�UQ��1�E���¼��mL,���*�h�����x��l@O���`��@�n�{w@O)�5{�ו�:��s�	~�<<#�����ޞ{ ��T��o�Ǿ��
y�{�(x�����yߚ[��f!��|`��bπ[�!;隳�~�p�ѣ\QW��g0������'��%g����z����÷o��f�	
8��:�R�~2٬�n�u�ه�t])��
���|�U�s_8�&���o/x��*��b��p�*��T�̪$�||<��OeT�K��Ry�f�n���1�b��247�@	���] Vˍ�U���IM����?7�~A����i�];�,ؗY�$��6#e	�%me��t��[�.f|�m����ELj���V�I98G��pP�� H��.��ɬW�6�ᢿ�3��- 	面�D��?�S�b ��=�(>���;���ߣ�z�$y��B�?>KY)P���K�"g����O����<)����k�W���
/"^E�g�ȋxW�����\?I{���?w��=Ã�2We�I�'�Q\f_�&J٢/��H��A���j�_�XMҾ��@$�؊Aɢ�3�%�؎��%���)Ae�m�w]>g*�]�0��\�)����w���2��a�r��a���<��@%�7]��_Ф�h��<�Lox� �I�}*z�뛡х���\�t!:*=���]��J�;/�0��/�����QY��X0lۆ*���3/��Cq3a�Zb��ۦ7p�"�<P�h�Υ���M歲�=E:��=�d����}n�U�i��g�7�E���ST7K��z��j�����U��n���:�]���t&�s���*iM��[�t=�����ԵHkyb�N��;.3j���x���jF�[[��o�5?8J�wx�G'h�C�A�f��a��}� {.�ho6X7l������wg8rac��B5��{�:�3l��$�5�����L��f�a�U��b�C�1���1P��]ۧ�>P��|�Y�d�9q�G���XP�T���/Q�"�Ł����]�n薊j��ZE�k���}���h�FsKJ�f�y��nX�"�O�uo��o��*{�BU����E�+U��͈�j�i���@u�ˮ�HWT����@��'�/7n�� ���~_���O"�e��D�[M]�2}�J�e�ƌ[ɖkF{����au��HO�Z&�/�Ĺ(�������@����,��h��v����u���/)'����M_���ͻ7J�L9�;c���KWj�OM^ i-;Ԍp�K��E뿚�@�	s�6�gLR]w��
~� �2�hoc�udai�t;]i�uZf���U�m�OI.��_&6�"*Z��Ejm�>~�^�
��rԗHkR3Pg�(�گ
/PY¶�@}��>�A����r�A!¶�_�:i>�������.�j���1P)��B1�P��5{���"�7�(�;��L��F%��*NpUC�J��z����N1hA.�-R5�smZX3�|0t��2�c�:������AE�F���p��.�0agg`\L`�D2�þ��:D�Ճ��X�{q�:b��Fq�RW�=�-�����tu#��� ��ў�)@���5$������
Lй:��&��<���l ���J��K�� ]
w��h��Hϕ]~�)ڐ�w
ԨH�3E?PU����-�Z��i���@���pԶp��!?�V��-�B����4��{�,P#����jF�爍<���7��Iu��S�^gOR�\�]���X]�J����L�W\3�O���=�`�jK5l�2_�HE������j���ޔ_�p���O��u�}��ޫ�>]� �ۮ������7���|�g�X�6��m�=C�oB��n����O�y��o�yj��e�U�{.� x����>�0��aN[�k5o��G����������߮��)����+�|��ߝ�\��V�&t�{�*2?������������#C�-Œ���(��4�+�5��kV1�
թ^�N
�gz�1X�&�)�ej�O��0���[F�w����-3=�#w����24h#/C�q3r�$��4~�3���j�p���1'��8�Hi�>��b�C=x����;�8�zB٠���p<>�'�����M��)��{���B�9�Or�?E/�;��<���rjf�6=�r��e;1��"�XX5�~v*�o����K)�߄����~��.k���R�p3v�lao��$��ؽ(YC�Qx{�L/�&���ue�вK��/#����0f���e��kV�%�B�"�g���0%��YK'��K%���$�{*m�T����ʊ������.k��������U��J�V�$����Q��D�����.ߌ6���b��Z[��z+��SU$����W��tύu/���#I�q�CV�ڹ�T���{sK�)�������G���NOhr���F�������������KX�=�\��2��1~�9�t��9�5sײ�LR���xw��7A�}���Fك+���}^��z�b<ʢ��i�.�/چ��|�ݼ�\ǥD�.1�D� �k�p��x{���r�����Q���z��$E�~�]����gY�/ߌ~u�~Q�����)��g&��D������2o����W�B׉�s�).��EwY��b�O���t���~�[=��r;�j��	L�fR�w���I���WV�����K��#^�(J;I�f�<4f>������F�zj��ya�����%���fz��Y��>�]�/��	��ǉ����x6Fu�s�{�����h'��x�l���O�V`����\��$��F�EQm��f�&�ɬ�[x���&,.�����R9}k����y;�c��=�sڐNO�5�[1QB�Q�٦�m�Me7@��M�i"&��g�v�tL?�����J��:$N���(��D�<2cSܖ�[].�p��M�7R�]ɞG�rzB_��:^ߌ&?p�_>U �	��i�ٜ)��Zv�R�L�W<�sc���	?�<���ˤ��{~?HU�vs�C:s�.�h^���X�(��"�yD&o�=��)�A�
�gy�8���vy�~:�Q�AG����I]{�'Y��嫭[���t�7�F��j��$��Y�ӻ��z�x�Nr�&v����#{�Wߠ_��U��w=U�ՈLٓ���Y}8��t�pQ��_}Aߙ�7��u罺�ʽ��:(!?�P�'��/����'��@��"*��<��O������"�2��Ɲ����V��t�+�^D�<{�!/G��Jnl	�H�7�����p@ ��5��u~������g4�\�S)<ř7�d*�n���-��k�G��]�<CO��7yֻ���2M�XN5��bkf{�q���A8|�B���h��4^��)��/��.�}�	�4q�'�����n�����M��G�&,���O�����0W��t�������E��?���,�����C:h�
��n��깘��� ��v���%����E�uQ|{Dk�w?R���i8�:m:Q��8�,]N�Y�v����_'?��	���C��$ϡ�'����O~a4<��E�C<=���W�WSނ�A7�?�>�� �Ԕ��L�������}w���/��{'�"�u����PK<*�t�b�Ou���q?2o�<��\���Ϝ�n��$ϜWs;1�'W�9o
����S�2�%�b��mS�4/J��Q�A~n���(�	U�&
D��؞7�oϏ�V}"�g!x�����kw;W}< m   j8��_/m�ǯ�3����;�)���ϭ�\y��ſÕ����o�����#����q������΍����&-�6�o��G�h=�֘#Z�������?U�E�      m   �  x�]�ɕ$!D��K�Cd�2��ђH�Է�~i� h�VÁ�3��x����H�M=�#�.2@���z�(�Q�13�t��%r-�Z�v�������Z�E��sD1�%ǝ���2�8�]�r�����:��3崸qrβ.e�-Ys�6��3~q6+����z�)'áK�/%�=N�?F���DI0*�9�ø��a�'&�e~и�k(���'��$���v��[�>�zB�;L]k��0��L6sE�Dm֝�z��{�NR�Hׄl>�:D�G����1��ן�d�(��=;c���-S�a�;�_�ۓ/�S&uה��&Y#�xf�Ug�:h/O�a�����]�V֫11�ƾQwL����븙5�v�r��E|�_=.���:������|2�wA�,�ުo��v�S�&n~�-��p�i?��=)'�7�?������^��4�:��j����_�6�r      q     x�mY��$�<����	$��;f��2{�>#s�%@��������3-��A�V��"YԤC�����㿿��_>�9R<$S��ڼ�rȑ
�$���x`)��kh���㫟аb��V���#�!�(R��C_�>^��C僫9y앀�z�'�A#j��r=���a�:c��uݤ�3�����շ�ю������⨔B�?���#qEB�t��ͽ% I��Cm�-�K�"�5��t f)t�0��%s�S	�z�t�R��:��J-��ȼ��e�L=d9�
����.@�2�_1�D�$�l+?�	�$ ?�Ï��U4伜�����R,�2�$�y�$�\ �:��I	�Ќ�մ��p�hZ��v��>�$=��:E����1t�/��cM��z0r�ءLI���IT�aǜ�VD?3:����:̈cf�r=t�J�hZC0�hPԟȻ�=Tw�4j8�b�Fn����R��D��B�MB�+#��ޙ!����9d>�<�c!����m�͓Jh�K�ՙj5��%ZE�a���]�C��z�?YH��@ЉaX��2�0:�77��d$b�t����ʊE�0�^eC�(�a���3֘�G��P9>~���?~����L �o��y�2�RЮ���y<��0�R��6�O��l�5��Y�[� ��v��L�-9<3�W]���(}.�5
�o� �eV �:�G�@�+��={��8&�s|X��l�����8����b�k>�^)��W�:3-�UR��goP��c�&��t���e~���N>��*�C���7�[��ͭ VW�)�f�Q^*��e�|v�+}o�˞�^����4&aF!o�xk�?�hp�d�6�~?�m��,��ыg��ee�#���ġyk����#������k@�z �5����N3(�N5x_Y�ƃ��w��VU1{<�p��g2���}���|�fb8�����׳Bvx�ڧ�==��o�@� X��(go�wҿ�_4���@�u�ޜR��'-:<o�D��ڑ#\o�h;�� s���|�m,Qc�5S?�wfȭ���X��J�)��K���x���Ǡ("k�3�ȗ)%�ji�7�
J�'Z��	�Szfc�������ҏ�B2I���Ο� ��Nݒ��B�ب���ZID���bI��y�].���zVS*&p�<�(��o�WEv�F�I��n�)3D�0��V����l��%I�Ȓ�$�։�����]��,�^���'߉�8o�Z�{��(��r�f�O�N�(|g��D[�y'|9|�Ҹ�=���G�@�7R~�<D
IP�gVa�e��eU��z����f���(x @������M����:c2$��DO�Θg%BN�_�ANI��@�3�jJX�w��
e+A9ֽ����&qm�@H���[R�M�rCzIwe�>yo�F
��}υM���%f�� B�IG����pB�	e�Bi�a����;�sfh4i�*��ܧ��k������z\�ݤ�u�N��3)�۳��::H����7~�Etʾ�y�����懳RB�Al/���+K1�4���Nhj�ܓ(��W3t�&{�Ua�A�)e�V4d9{�>�.�*I42�e���I5h9=5>À��1�Uv�-�[��Pq�y�~S�c2�:�zS �C�W��M9�52*,��f˳^�[h6-��o���I�=��5Ա�f�����x�C�i��0�@F���i�28�����@:A�f�n�4��Y �d��S��Mcڨ6�yѦH=g�8h6E�2G>2�M��O�>@f�7���T��M��ɏ9�g�4��'*N��p݋�:!=����g����xKQ������z�m�5���~N�*M�ڄ�p�2Ԛ��:�Q!�T⎅ǃ�$���OB$!�0�����(6��4hJg��J�9eÆu��`���z@�٘��XV���-3��I����F�a,4�}��Co����Ψ�-D�ݘɘ�G��"s�����D��&Yf�'Z���5� �=�_��q�>iX �l�<�b	bNu��b+���F~3|��8�E�|V(�p�X��/z�,\e�cv������>�;T�yjyMb�����Z���� %o1�=��@�i���9xa[X�v�~���U8";����,�㭅z-X���8XU���FI�@vY��|5S�1F�O$��_P�
�3?U ��#;u�����o㢴(oh�:�|�We-��y�-P�)�v=����֦n��n#T��l�gM�5t�:*|��f�|A���k����i#�<��*dU,{�\��B����� ��3�w�s��.��v�2v��&QW�f��� D���a�E(Є
>�eV�y�=�'�r�]a��n�R�{��T����6���l@<2��zmu^r�(�E���>����}�
1�ըYY9�e޿��JiI�RQ��f�h���$�u��_=�Ž{���G+�m�z%t��>��t��4����PMfY{��4�\X��[��A�PW�����R +Z�b��n�%�rZ�2}�9��g
M0�r��xPk�Tx.�ya�q�1WYJ
'EJ�UV�r&x=L�b����k�"l>l<�q/M<E_��I��!��r�����>d�\���"e$]�*��p��6n�k�+��9�0�7�5�j'�1?�r��Bf���/o��ƹ���J8�x���D�р1���Z��h�O��|Y����d��؝��1^���t*�~�Us��Y����4�%�ras�R��dW �Q^��Vr5�ǳs�ѯ8����Z������2�x>�O;qYHK?j�xI&PT"$_)��+���_?�BP��.8�]�J��+��Z�b��+�2`��������?2m���P�]���]S����%�� ��%����~��#���l��K>�U�L���q�3K�Ķ	�o �*u&�P�b��Y�8�����Ͳ`0�M'���_b��,R%T(Nk�S��]����S�T(N���ż���@�o?߾&�
�i]��˄
�i��7rs����9�n���X�{m����4������C�yr�      j   �  x�}��r�6��5|���l���4�N�i�膖h[cYle���/�tL �ː���ok.����w��������>��3g>O���a�͛�y������j�j�7����>����ո�;�5��-/~��;6?L/����i�O^m0����� [��q<M˃�5�o��������y��7��������y36�[��|9N�����|�v7��>��:�v�_G�z�i����^���ۥg�b#_�j��t�5���U�ٙ��0O�fo~<nn��S��6��wrhc~���/x܍��Z���v�6u�rܥg����v�ӓ���<�����-����ޚ_��q~x���!�̛ݴߞ/".�����k�3v<�m���75���?�?��/�[�����|������p�&��7o����i��/z~��<�q�/�֕y=Oё�5v���l*j~�#{�������f��j]�˿�i{.�������q�;[�����9����2m���s���ú��^b��*��ƪ�w��7^}S'S�4j�6���s��˹o��ܷU4��Us�:=��/�}[gs�6�ܷ����+�}�˹o9�]�澳b�;W���gs��j�F�}���:5�]��}7���d�{��}�
s�{=�}-�o
s߷j��.���/�}?�s?T���<��[������Pgs?4r�V���Es?�b�!�{[Uz�me�ɷ�S�o+���kuӯ��_���~������7�j(���������4Ht�'<r,�Qd��!�K�(,	"$�dHN��F��$I1������"�K�H,9"@�I,��Drl���K��(X*D�`�ɂ%E��"�0ؐ%��8�h�䉶��'�0Iu�TI��,����m&��S�^s�e��%Sr%,}�1�\%�	�$a�,QL&	��`�8Y2��2�It�i������Rf�Xɘ Y"&�J1A����Z$T�d�bQLP-�	���1A�(&(�颙�^�K��"��3A�dL-&���"� `
L��L�29�L�	r&f��ɘ b�L���}�3A�H&�1W�p�LP5�	r&c�9b�L����c&H�-�`�UU�	G�,O��c���L8r�Ȅ�jR&i�d�U�|�Я<L m���F>N j���&g�Q7�'
N�H��Q���P���L8�F0�H��	G��L�5��I�p��f�3�	G�(&Q��p!lr&u�1��̈́#o"&Y�2�H�"��&q��MƄ#p�E:G�U(���əpDMʄ{.��#gb&!#�p�L̄�er&-�d���LP2ѩ�ct�f��)3A�dL�6M�� j�L�6�	�F2A�(&��uSz�hs&�]#��k4��b��I� i!jb&虌	Z��1�� g$DM��6�	�&g��)0A��L�5$M���Zc��Yc�w9�d��sJg�q#� j2&�KF1A�$L2�	J&a��L�2K&���%�z:F1A�h&ș2TMʄ'm�L��
&<QSd6�	O�(&<Q#��tM΄�n4��I����`��5�	O��5
�F.R�t�",��!j�u��\�.T�2��
bF/U�3r���),V��ə��MƄ'o4�����dMʄ'i�Lx׭0ቛ&�2&|XGLx:G,T��Y0ቛ�	OԤL��Lx�&LxBF0�)��	O��LxZf���m�	O�D���Lx:F2�ə"��ɘ m"&¢Q�D=�0A�H&(�Q���k�M�	
'c��QL�5�	�F3A�(&H����Ɣ3�&f"�.�L�2�ͦ�9#� j
L��LP79�M�	�&f��ɘ i�Lt���]�3��t���P:K&��Q�1�\2��ާL2�	J&a��L�2K&���%�z:F1A�h&ș2TM�i1֘r&�v�	�F2A�H&��DM��L�������Ty      u   z   x�M�1�0�����@Q�:\ fڕ%U����A���}��3.%׏��L�#ċ6�k<od���u���p��:�ߕZ\k,K*�<N�5Cm?mFK�!��'6�P
X�G�t;�t+:      s   <  x�-U�r�8<�_�/�҃~m���L�JřIm�^`�8�H)9�|�6����`����]+�2��6���s�BwTͨVUE�1�({>r�A���l���� ����޹q(��Pڈk��Ӯ�Qċވ��=�T.��M�O��%�;���ɦ��ӌ*��m�������'���:n�s�Ҏ ץ*A
.�Gh�D���g��.����^�� )�_lôu��Q��0�2`���<�$�Y.�s��2s�~J����GgB���9�[p3SeE����N�����)R����v�ȧ�΅ȾH�� [^ҬPUM�v�}։��й' �R�s��ޱ?�c8I&�����l���%��<�&8��yD� 7��/h^�h�g?уLh���"V47��G�F�HT�bSNnC@�sef�}�-�)���&�B���t��M�+{������'`�5�{����&�A?���	 ���3�U�E�����
 ZjI���Ar2��j�A������tq���i�#�(q�P�K;L���Ui�_�cw�"O��97�E��3U/�'G4�=�I�=Iy��)
�|{���M^�CG�P�*H+��	7��Z-g7��V3z���H�J���{Ws�v���1�^�~���)d=/�;:�V�a���3e�L��	Q��h�,`|7&��3R�֨8F��"�7;k^�jF�vD���j���(ؿ�<�Y�R���������ޝ>ls�;X�b�L��ͺ'FV��<B:�dp#̒�d�:r�������t; ��th�psy�1�?�^���@u����9�KV�::���/η���V���W>��6�GH�fkZ�is#��c����z|˲��p��\�t#�X��|W����l����7%�.���Q��78@����3���Åqq^��	ڠ�4�<B���*�؇>�F��n�x������ܗ��������<��S��=ZwN�ׁ��P�~���ڟ"'����>`�n�I���_�G9�!o*!��;����p�6��C������aH*���.4��c~N���:���B��R�?C���      k   *  x�uZY�ܸ�.ݥ;��]���1�܀r�9f�J"�&`�G����?"�<~��H�''��|$%�/O�b�I�]o[{�^.?�?����j}Dײȏ`y��f��]����b#I�����A�ݽ/so����$��z��n��p�e\������)y��~��bO){=���K{��"b��]�����0U��՞���6cY���v$�<s�9�lw��ב"O�Wh/s�����|�auo,�G�Q�ק�ض�)_�?u���k8YvH�3�KX��)=��7���f�Y��i��H�PڶC����&o{������[��`"vC��v�z?0Yv7���~B����v�����GN� �X[vH�?0H���r��6ZHy���\�ט�bn;	�V�''[p���%4cY�6!�T�'>r"e���`��w9���T�zj�ͣ�O��nʦ⑨KLb�J��62�.@Xr�c}T�� ;f@��V�D��an-���(�Ν,�A�����ЁF'��iuS��Xo��eQd����;�[ڂI7Lu��a<5�h��ɽ~rL{�.�<+kL�c�}�ܨ/���fe�zJ���Ԯ�eG����Z��P�ԓL7\1��l���c�E�Ƨ<Yo�$/2[���vMg7�25��h�gEЅ~V�jV��bU<|O�	�]ԙe��'��+��޿�`�.�f=��ۡ���E͟F#Uh6�} �4h0���d�@4/;̦ҡ�ע����_E���6�eu�4�+iO�6(�i.Wc	�m�?,�@E� ����2��+5�o��V OvCG��F�XA��m\�з���g��=
�'@?���0��6e�������_��Dnp�,�vր�;��(HPod�_����=���GL�[)vS��`�Մ�o��.���@Tgx� ��q;�2�]���x��~,#,=�H7V�:��[�-Z��Ύ�>�؈�~}�Z�|s.�,\.g?q&��-ד��g(	Ov� ����rOU`�0�6� )v8���x����� P��a4��|�l�m3E3�ԁ��k�PG����oi�k<�]"�H���q}J`@��D�<�n$���,��5���$2�������>t�/����8�҉l|�+ķ���%ջ�T}��*vT ��CN'����h��A|�p���
��\f��Q����9�&�ڶF��B1�׹�i�QXE�@;�Jܟ
�<>����ى_{�<���I��S9�.��PvV�dXz7�U�GRD]oW��t<�ܝ�Άd�؆m��҅m���,�M��gx���Hvv\���{#<�A�j�w�_	��W��e�-Eۉߟ�@�j�o��΍-T�z�A
*ErD!�Z�*
T
�-�ml�
l4�]���n��7j�� �!����K+%(_�R�@��n�9�۫o����8]\\���g���t�N��vH����e"ǁJ
0<:�)	�����x/���
�9���@��#]�5����b��/B1+lexJ��� �� l��H���y8#'���u�D�Y���oEn���7�tE���m���F�ܾ``c.�RB3��E��:���V�P��֜}��-���<�f�����1�����	�Oݗ�x�Vˎ�4���ݹ�#j!e���0�����Ifh�_Di�Pc����r͛.�(�1�68t�kɾU9ْ o	�����|�la�Jz]�L0��b�T#P�v
팆��b����[��̕��ա��Y/�P���Ä�QsTv# ��h��~v9�Y�<�Ȗ�&��45s_��Nui���M�$C��4�s�c�V��p��`Bia�����-�e��E,����i�\s<�|�:8�Z���h�^::�&�S�H�On;����Ǒ=$##x�
[���8Gr�ԃ�v��B�ژ��L����lt�ʘ-��BӶ�;`����m(fC(.�\sU�k��)0H2|b�*�M�<�teR���i��R8��O�s7��~J"+����O�#�o^��Y�'�r(hX3���\��9��Y��G�还������Toxb���^��/��O��>h
��o~ 64����NJ�\뱭�0��o�p"��"4�>٤F��Q��g�u�O�Y��	+�p'�l/Aˁ�~��K�wW����֪>�Bl���8@�o��e�e5�L��#o(�K ����9-Xl$S� J�m6�b�a	�q�.{�$dV f�5��K-̟=�:����9�ë�nc��߁C���=��'ab�O�� Wz�Wv?�
�����PG�Wx���q�Ϙؿ��|R�9��+h�Ef��jS5�"k/-K��ɫ����{�p8{�%�)���ą���n����ޑ襄�c��K����E��pOw�Ȟ[�Sz%{�[Z�(��	�f���h~�q���%?�:�[���n1/��r�]�QJ���>��E� dxI�n�-�}�K��sȫu��Z���S�
�)�LX���B�M��Ę��BZ����.(����VQ�:�~j�P��k�rL^�]N_ʉ�����&�t�,2�Ӌ��6��
��鼤����xIu����������Q�0������ �m�q>��iF@ �n&U����L���; U�f��숇;�jS����[_�`a,5����ѫP	/�F�'z'��.���U�ѠZ��=�S��g��Iv =錸����D��+��R�l�D�"��WE�j��1��-On��� ��0��2\�n����I�V<�1�x��s����
�F�wrel�@��r؆�k\�#��v�KZy�:7ċ��F0@�,0��x0��?��r�B�I �zJ*�A�L�s14}G=� #���a�%gpi0ʸ�4��G��,���;�Of=>>����xC2*���8��E^;i��ۙ�UƋ^o�!��%�R�0"�ʼp`*��櫏�����.t���A�{Q���>�nZ��@Uy�<�-:-����{��72��PB�������k{Jp���9�h�7��W��;�I�U���J�6�fH�W'��=׿�tϭj��� �je��Lzb���I��-�_���(Ī.Kʡ���n�r0J�� �������A�D���*Pq��6��Ne�#g���TWGi�H:#&�jîS@�O	��H�+ũp7�v������.Dv������8���'됆�����P��]�2��{,B�^�2jvf���f� J�����%�&��qi��M��lzb���q���#\c�i�惯���<AY����<>t��L��^q.�o���[v���[�G�S���j����>���OM�      l      x�e[�v��r}n~�>@����h���Ҍ#y�+Yy�ȶ�������]URs�r2V��ڵwU!qW��:D���8�?�i���2��C�Ҵn�U꾏���o���[{�.��:Ye�~|��}��a��]�޶����uESԫ�]���G�������v���wIYf٪p���ֿv�������S��^Uy�*�M{���ۇ��]��0N�}��U�������߷㮝/�asq7��w�׋�x��Uq��j��o������$+o�ݣ���h�������"��U����oO~j�����v��y�7~��	�徶S���sy�=��wzl�}�����=Շv�Ҥ.�b�$N�$w����|���+�+Rw;��7Yp�k�6��ʲx�d��n����3y=��8������[��X����}�&k�av?=��y�O�tsdIZW��pW���./�Z�`���o�+��v���8�ۍ��8œKw������T`ɓK�4+WI��J�!c����4�C��HVI�b//>m^�Hς����b?��ѯ�-}"�h�y+ۤ�u�~k����n�wïl�dy�Jc�ͷ4~�j«.vh��0�{āK�4)Wi�{��-����:x��b�Ξ�d��N����a�E���v�=��%��x��p�
N3w��Kz�~���?lڝZP�0�UZ��4ww�ij�r㟦n-�T	�V��zx�t��@I���S�>����`Xyç�{k=�$E�����l�rMrV��5�w�b��슼����~<"6�>Y�u:xċ�{�V,�We�J���t�����_5iY���}�¿��!�������j`�yӬ��]�����m�S��@
�s���i^Y\��Y�>��<Gw��8 �qK��ɿ�9�"��2�{����O����Ҽ�V���7�!�����z��w^n$��*^e�{��n��D؎=B �K;xW����t?��i����o4]^$nx8�a%d��B��%�K���'�ݏ;?��9�4G��/����1`�q@�u�F��W�ne(��U��cې\�ĺ8��#�5o������DӅܓ@�M���*Oݗv�L�q�b��#o0�;2X�u�`\�xxq���5g1��W��i�Y:��s�8E>)�8��[����X�ҒИ��G;����So��sdJ�F�+��1�Y4ܶ�"�q����I�Kk��1�a�7�n��C��	S���@�å��X���8{E)E��ۋ��vc�ªHB6�~�=ܑ����<i�xU�@����-�J���Pw�aӺ�٥�܍1BL���ڵS��<��fU�H0H�j
�_s۵�kU�1�����p���%\���k%�Ң��UQ:x��7z�������$GƯ������o��"�����~��ݛb�u;��`o�#��^I���;���.��8^����E�O���kg�^�E�{��ed1<oU&�[��jhVp��m1�h��M�*S%2zuz����A5J�IG����u�sZKgZV|B q�����bӸI���"�d>�ϟ��dp��D
��f���-�������BG^��d�B��oȸ\��"N큙�!O��F7�vI�Y#-���=�[�4�|��̧a��C+��iլ�X��n6�a�������*1 �k��8i@���mKE�tV��qx�y����w�8XWq���@:��wy��_�bAU[�#1U�#�_^#ӴC�fS��U1�T,� f�����EfR��@8 ���0���lUU�~�C~�W��\�\T�ή��P�gp�i�܆0m�U�QQK���ܭ5�V��U�.DI���-�L5�^~�e9p�N!�Rd�MX��@�"ͪU��oҤ�q�^�\� ���Y�;�KLl)�U��'H�n���yW��q�!�A�W5Bb�q�;H~������q��
��ס��nH��E@���~O�"ID�� C��ǿ%��IV�'��0��X��G�~�*b�mݜ̥4V�3�V����k�p�yV %7 �rr^��yc�0̚���O�//�x � �mҀ�'���#�d sժ������m	C/�1xd��)�U�@H����J0�%/�|[�1��HI�
��y�8iiJ�_�aI)�gx�fj-��Q宧�[t㧁��-he��jS�]�@�?��Y�P�5!�����<���W��[XVP�/��ie�k:���:%�L��z����g^ZOP��`E�>6pB���$�el�7�H�ġ$�^�$��~k��iI���|i����(<��Ue3qƹ�!d�W"˚�z0.����S8�F�Y�t�,ӏy��x.A����{茔g�6 ��Q��jb8Íox�ˬ��Z/FV�ˍ�7uߋ'��b�c��(�s�{Zag����e��� ����0����a�8��[k\Yn0����?Ȃ_N�Z��aC�
�l� h_��Q5"%I'LCLN�r qI�yS#C'�Ɛ"�zS�0ޭ4"+�P��w����~ ��j��߫����*&~���Xy��da�q�L^��i��B�T�t�ی� :>ı��p4C+9��z��t��;H�����}畻%u�;������?"��& ��@�����d��m�`�@���na�'�G(^�8���S�����U�Hș\U8�K����L!/��Ɨ������w��Y��ƅC����-��z�C�C��n�A���x�:��Hk�2���X�r�K�0T�a]d�蛑zS�"��V\l���{�aI�4P�D�=Y����Z�$���y��Ԓ���Jߙ�!�����a,��gJ��fy�����9�>�v���*qMS�V���&al���ňU��Š��ӟ;pj�O"����7�Jb�D�`�
'T����%$h{a�Y��jwՁ��z����-H��`�2n��e{F ��ԓ&Ǔ���&#�.[^6C��,��/.:���[kd	�m|���<P�Z�\�Gĺ��+���̢]�M$(���N��T*O�������<4T�$��	��?b��aZo��G
�*&3u��5~Q2V�vɂ5[]��XS�h�q�N�����誔p%�u����!~���d\*o�3E�-�j!����A��k��|&�!�&���u*I�����@���?Z�ĺ�
X��F�ڽ�8�՜dBW�kXdL��J{@q=�`�=/�pE��0��y�H(�X�l��,�7�}�g�v0G�T[U^ ��%Ƞ��T�F��jP֒p/�ϯ� �D�j�"F��B��S�'P�@,�V���&@��U˭�����(�< ӆlZ�Ǆh����cM�տ�d����.4�T��8Rk��]"� u�	����lwFqA(q+tՍ$���S��T����4b�,��`|o
qYf�ò��g���kH/���[�*�ؤT��UKQl@Q� ���n9�9.��%HJ�U%;��������Y1��Ԯ� p,��"��6P����դ5��mPidj9��1����ڇ�S` vjTqd-/���:��V�>f^A������:��"'���8n��`��Қi���>uV�&�/�nwGHZ��a��@Ε1ߟ�ό��r�U�Յ
s8�q]��U�T����O�A�%R�χ�L��j��A3�������B2ԹȎP�0���6��+Ų�����j<Zu5� ��I�Li:`*�z"���N1G�3�©�(YX����2D���ɭ�)-H,X
���)k���j<01�JH��Y�)�UIs����A��ODG(7Z�f�j�]�9��<���*�w����p� ��z}�m�E){2u���Z��E�\y&W���84�t�I�u��qڰIk�����.zYU��q�sK������R$���4�= T#�!�����QpF-������N�wZ�HHe(�LV��E�'M���N?P^��Uu�*K������$�P��78�B[:����[��V����6��U(O��p�Se@�/M�~T�Xa�]��	US ��*��Y5�����Ҕ��� �  �b���=��`}(�]Cgiδ�3�9g5Q��Ư�w�@5����I������'���5Y��P��)�~�ҳ4�"Y��W՞�T�'�|�v{�1J2��SMk�%Odˡ���r�Z/���W�%�¾C\����a��d�h�B�/��d�d˾b���)�IS��|x����~�5V^��;�Ղ�(��G*��
wՅ�"w�%���W���*�}��0nb� ��YAbI�Z:�t�ee��Rh�0P$i���k��W�+���l �`ܼ�!-H)���p��~�ΊԖ���mqo��j�%�����r#�MM�������Ow/��$[�6�ib��H.�~��=0�S>05aʒ��z�W��(�";Z��ʷ�w�CvsK?Z�qV�Ȑi��(BqA�Y��z��7�i�āpM!5��z�ҽҒsQ&�їxzϝ-s��8HO��Uh}}��X�n��Kc��C43]��%�>���R�#��E�>8ҏ���A��(f�t�p`k��
f�ޤ��U.��L�Z 3����<X�s�W�lN5�;��@���<�"-n�acM��K@�|
�{�߇�i�f��\�b��Eܶ�T}J?$�����r��mJ�z���GE7V����l��F~Â�)��sY�B ���e߂E�4;���P�>���e����<v�//��ب�b��IP�'
s2"�tS��`���=B��{�Q�6zh(� �X�b��&"�֬O��;�<�o?Y�r�iB[�s�t�ʸ��,	u��mdհ
UI�`�cK�`DK��i����Ě���wT4uqǝ����R�]�D���`�$L���C[�|�ڷ�_�49Β7��r������Po[�E��`
'<]�bQr�@I�����6�"�8і`v�$�(t��"*�mX� _���?H�����V����Jt���D!X5�ij�YQX����%WG΋0w����44�PLY �F����@�B�ɜ���n�>��Y�S�>�j0�eL��ViN���X+�
�1��i/m!�H��L���N�|�0΍��9��L���Y�^�l�V�xd�E��� n:+�Z�VnB뚲���p�2wa����fɔcrt$-in�>?���B�Q[�I��UeX��֔���UC�(+�X��ج��Ǵ��PB~
�r\W�Xxmyփ�
Z�`Y�A��	ôb�?	u�Q��y��Gk[^�y�8iZ�����r���J�{�2#��F��Ҷ=������U��{�"p$��BR�dT����k_���˄��*�h���T��� 4�L�QQ*~?LA�?@|�A� k�8��5�LK�������e��h��Hmi��Cw��ÌU�R4 �FHKn���z�j3+�j#T�9��T/=l���(6Kk> �N��L�H�$I�/0���z�J� �$r�:����~�dm��t7.���R�I؃J��)O[��ߤ�����%�F��~eN3�%����U:��/u��y�!�'Nu�8�9�|9,����,ltr1"љ�f��9�Ok8��RٳAR߭m�O�
���̽�ipX�&5$8�>~�ua��G g�����a��[��@����n,T�>����Δ�~c�Ɋ&�_�!5@"	k�
�m¤�6��?:e�y��@��[�5���'��&��u�?�+�t��Z
?�#)�$�p�~�~?%�:�%YG���������T�ж�қ:+��!����}�9�Y-Y,�LJk@�+3�Xh#Q��\
���d��x�y��v����er"��z�7�~�5A��Z1Ԇ ��A�u����6�m�) S���yFN�����1A���fo$.H�,�3%痲w�����ȶ3R�v���6��WpY�]��	xnLCڈ, �Ƴ˴V�k�%��k�ZqX4c_�W�Kx'�K�,�[�}䔴�2C��;�?����hK	�%�!�gi�����>��`�O�a�k��OȾ8R�|�Ĳ��W��إd~���	�.�0HE�����H9.��cE?=��y��8�*g5���@��ŰI�0�Q��_���K�k6�Nz�M&̖�ϢF�� �A1�:�uw���$��k�B�7GR�݃�C��e9uy��l4:�SҒ��<�^vF�AF��r6O�[e���O�Q�p&���0�e�wNbC2DF���1�{,��m�F�R���SW�.��ƙk(��V�85j��S�_+ɦ���<�����tW^�\�`cYr�rwTj�Gm0��O�ɻr]݌��Ʌ�ʶuY�|jf�'
8��؈]�H����s�Z��N�UB)�G��l��x��7ć �"�_�t0]��ap���tw�ӐϢ��ʯM���,�|�1.ӤK��L����sI Y֜�?O��a�|d��Xe�բ2�}�!v�NcMڲA����n��|��+ @Q��t��3=������Q�p �8�[?�Z+3}ow��UB���� Wk/�Bi4�ܹ+]��E���]��vI�ۥz�O� @BP P��)B3���w�C�'0�M�E��G2�p���b���&�5���g������*�I�aY\�L�yS�0Ѧ@��wȿv�ԯeDM�K6g���r���-Ӧ:y�.���MF�141h4���
�Bt	���y�H�<���q��T�f� ')�O� �Ͽ� �?�����H�ᗑ�e�2�ِ|�5�R����r�;�m څS�����w�[����Y2� Ah�çڂ�g����^�6��wߊ�e��[���X�n�IUk��a�ߌ`��7�Ƃ$�V.1�W�+��mO�k(Y�z|_ʄϬ����_<��^т�=�@i�f�^?�� j�P�orX��z�o�u��J𻕯���x�FK�nh��}
K�V�i���'�I��y�/�bw���
��	-���/@���k������Qj�hJ�F(t����db��sM�e�^�桋zʘ��Pm.��k-;��h�V�wŹ�yax�2�J�D4��֢����� �t1�*��N����;���}p��:�KJ��uQg2k����Ym�ƈ=[��#�6o2���T��C
��(��X�:�\������Flh��NZ𙙦��t�٨
_+Kr֌��%��n�jyw�^�[�e!�C�3tpt"��9	�Av�1u{�E�Tm�W���:p����x	�w���z�3a4��A���Њ]�-��|0,$x &Q(�騞�"��]Sn�p�b�P�M�iv�qc�P�K���M-CkZ�F/�+��\�:ѧy?��6P<��Lj%3s@,^�2X��
BeCu��&M�Pז�Y<u+0-�	�$��r���-(.�)C�HA�󧡦
�֦ q�d�X���7N u7�H2�%Ab]F�##7��h}�O�m��{<������!`��*�>�|�:1<�g����C-��	��췇Wx�/}����t�����c���p���� ��u-V�
v�9�xx<_�}y9�����j���Րq     