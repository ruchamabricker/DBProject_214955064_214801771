--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matches (
    match_id integer NOT NULL,
    team1_id integer,
    team2_id integer,
    match_date date NOT NULL,
    stadium_id integer,
    score_team1 integer DEFAULT 0,
    score_team2 integer DEFAULT 0,
    stage_id integer
);


ALTER TABLE public.matches OWNER TO postgres;

--
-- Name: matches_match_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.matches_match_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.matches_match_id_seq OWNER TO postgres;

--
-- Name: matches_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.matches_match_id_seq OWNED BY public.matches.match_id;


--
-- Name: matchevents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matchevents (
    event_id integer NOT NULL,
    match_id integer,
    player_id integer,
    event_type text NOT NULL,
    minute integer,
    CONSTRAINT matchevents_event_type_check CHECK ((event_type = ANY (ARRAY['Goal'::text, 'Yellow Card'::text, 'Red Card'::text, 'Substitution'::text]))),
    CONSTRAINT matchevents_minute_check CHECK (((minute >= 1) AND (minute <= 120)))
);


ALTER TABLE public.matchevents OWNER TO postgres;

--
-- Name: matchevents_event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.matchevents_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.matchevents_event_id_seq OWNER TO postgres;

--
-- Name: matchevents_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.matchevents_event_id_seq OWNED BY public.matchevents.event_id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.players (
    player_id integer NOT NULL,
    team_id integer,
    name character varying(100) NOT NULL,
    "position" character varying(50) NOT NULL,
    birth_date date NOT NULL,
    goals integer DEFAULT 0,
    assists integer DEFAULT 0
);


ALTER TABLE public.players OWNER TO postgres;

--
-- Name: players_player_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.players_player_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.players_player_id_seq OWNER TO postgres;

--
-- Name: players_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.players_player_id_seq OWNED BY public.players.player_id;


--
-- Name: playersinmatches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.playersinmatches (
    is_substitute boolean NOT NULL,
    player_id integer NOT NULL,
    match_id integer NOT NULL
);


ALTER TABLE public.playersinmatches OWNER TO postgres;

--
-- Name: stadiums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stadiums (
    stadium_id integer NOT NULL,
    name character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    capacity integer NOT NULL,
    CONSTRAINT check_capacity_positive CHECK ((capacity >= 1000))
);


ALTER TABLE public.stadiums OWNER TO postgres;

--
-- Name: stadiums_stadium_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stadiums_stadium_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stadiums_stadium_id_seq OWNER TO postgres;

--
-- Name: stadiums_stadium_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stadiums_stadium_id_seq OWNED BY public.stadiums.stadium_id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    team_id integer NOT NULL,
    team_name character varying(100) NOT NULL,
    coach character varying(100),
    team_group character(1),
    fifa_ranking integer DEFAULT 180
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: teams_team_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teams_team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teams_team_id_seq OWNER TO postgres;

--
-- Name: teams_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teams_team_id_seq OWNED BY public.teams.team_id;


--
-- Name: tournamentstages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tournamentstages (
    stage_id integer NOT NULL,
    name text NOT NULL,
    matches_count integer,
    start_date date NOT NULL,
    finish_date date NOT NULL,
    CONSTRAINT tournamentstages_name_check CHECK ((name = ANY (ARRAY['Group Stage'::text, 'Round of 16'::text, 'Quarter Finals'::text, 'Semi Finals'::text, 'Final'::text])))
);


ALTER TABLE public.tournamentstages OWNER TO postgres;

--
-- Name: tournamentstages_stage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tournamentstages_stage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tournamentstages_stage_id_seq OWNER TO postgres;

--
-- Name: tournamentstages_stage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tournamentstages_stage_id_seq OWNED BY public.tournamentstages.stage_id;


--
-- Name: matches match_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches ALTER COLUMN match_id SET DEFAULT nextval('public.matches_match_id_seq'::regclass);


--
-- Name: matchevents event_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchevents ALTER COLUMN event_id SET DEFAULT nextval('public.matchevents_event_id_seq'::regclass);


--
-- Name: players player_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players ALTER COLUMN player_id SET DEFAULT nextval('public.players_player_id_seq'::regclass);


--
-- Name: stadiums stadium_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stadiums ALTER COLUMN stadium_id SET DEFAULT nextval('public.stadiums_stadium_id_seq'::regclass);


--
-- Name: teams team_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams ALTER COLUMN team_id SET DEFAULT nextval('public.teams_team_id_seq'::regclass);


--
-- Name: tournamentstages stage_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournamentstages ALTER COLUMN stage_id SET DEFAULT nextval('public.tournamentstages_stage_id_seq'::regclass);


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matches (match_id, team1_id, team2_id, match_date, stadium_id, score_team1, score_team2, stage_id) FROM stdin;
1	2	7	2024-06-09	2	2	2	1
2	3	1	2024-06-06	1	3	4	1
3	1	2	2024-06-03	3	4	3	1
4	4	3	2024-06-08	1	5	1	1
5	2	6	2024-06-13	2	4	1	1
6	3	8	2024-06-06	1	1	4	1
7	2	7	2024-06-08	3	2	4	1
9	4	3	2024-06-11	1	5	5	1
11	5	4	2024-06-08	2	1	1	1
12	2	5	2024-06-11	2	2	4	1
13	3	2	2024-06-04	3	1	5	1
14	6	8	2024-06-10	1	5	3	1
15	3	5	2024-06-14	2	1	0	1
16	1	2	2024-06-14	3	5	2	1
17	6	3	2024-06-03	2	3	1	1
18	2	3	2024-06-13	1	1	3	1
19	4	1	2024-06-14	1	2	3	1
20	7	4	2024-06-07	1	3	0	1
21	5	1	2024-06-09	3	4	0	1
22	1	4	2024-06-05	3	0	0	1
23	2	6	2024-06-05	3	0	1	1
24	2	3	2024-06-14	1	4	3	1
25	7	2	2024-06-12	3	5	1	1
26	2	1	2024-06-13	1	1	5	1
27	4	2	2024-06-05	2	5	0	1
28	6	7	2024-06-06	3	1	2	1
29	4	3	2024-06-09	1	1	2	1
31	5	8	2024-06-02	1	4	1	1
32	7	6	2024-06-09	3	3	1	1
33	6	1	2024-06-09	3	1	2	1
34	6	8	2024-06-12	2	0	1	1
35	6	3	2024-06-11	3	4	3	1
37	4	5	2024-06-09	3	4	2	1
38	3	7	2024-06-14	1	2	2	1
39	3	2	2024-06-04	3	5	5	1
41	7	5	2024-06-04	2	1	0	1
42	2	3	2024-06-10	3	0	0	1
43	2	1	2024-06-05	1	2	0	1
44	8	6	2024-06-10	1	0	0	1
45	4	3	2024-06-03	1	5	3	1
46	5	7	2024-06-02	1	0	2	1
47	3	2	2024-06-02	3	4	1	1
48	7	6	2024-06-06	2	4	5	1
49	5	1	2024-06-16	2	1	5	2
50	7	1	2024-06-16	1	4	4	2
51	2	8	2024-06-15	1	1	2	2
52	1	7	2024-06-17	1	4	4	2
53	4	3	2024-06-15	2	5	5	2
54	4	2	2024-06-18	2	2	0	2
55	2	5	2024-06-17	3	5	4	2
56	6	7	2024-06-15	1	2	3	2
57	3	5	2024-06-19	3	5	1	3
58	1	4	2024-06-21	3	2	1	3
59	7	1	2024-06-20	2	1	0	3
60	8	5	2024-06-20	3	2	1	3
61	1	3	2024-06-23	1	4	5	4
62	8	2	2024-06-24	2	0	5	4
63	5	3	2024-06-25	1	3	2	5
\.


--
-- Data for Name: matchevents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matchevents (event_id, match_id, player_id, event_type, minute) FROM stdin;
1	1	1	Red Card	2
2	1	2	Substitution	3
5	1	5	Red Card	6
6	1	6	Substitution	7
7	1	7	Goal	8
8	1	8	Yellow Card	9
11	1	11	Goal	12
12	1	12	Yellow Card	13
13	1	13	Red Card	14
16	1	16	Yellow Card	17
17	1	17	Red Card	18
18	1	18	Substitution	19
19	1	19	Goal	20
23	2	23	Yellow Card	47
24	2	24	Red Card	49
25	2	25	Substitution	51
30	2	30	Goal	61
31	2	31	Yellow Card	63
32	2	32	Red Card	65
33	2	33	Substitution	67
34	2	34	Goal	69
36	2	36	Red Card	73
40	2	40	Red Card	81
41	2	41	Substitution	83
43	2	43	Yellow Card	87
44	2	44	Red Card	89
45	3	45	Goal	46
46	3	46	Yellow Card	49
47	3	47	Red Card	52
48	3	48	Substitution	55
51	3	51	Red Card	64
52	3	52	Substitution	67
53	3	53	Goal	70
54	3	54	Yellow Card	73
55	3	55	Red Card	76
56	3	56	Substitution	79
57	3	57	Goal	82
61	3	61	Goal	4
63	3	63	Red Card	10
66	3	66	Yellow Card	19
70	4	70	Red Card	11
71	4	71	Substitution	15
73	4	73	Yellow Card	23
74	4	74	Red Card	27
78	4	78	Red Card	43
79	4	79	Substitution	47
80	4	80	Goal	51
81	4	81	Yellow Card	55
83	4	83	Substitution	63
85	4	85	Yellow Card	71
86	4	86	Red Card	75
87	4	87	Substitution	79
89	5	89	Red Card	86
90	5	90	Substitution	1
91	5	91	Goal	6
92	5	92	Yellow Card	11
95	5	95	Goal	26
98	5	98	Substitution	41
99	5	99	Goal	46
101	5	101	Red Card	56
102	5	102	Substitution	61
103	5	103	Goal	66
105	5	105	Red Card	76
106	5	106	Substitution	81
107	5	107	Goal	86
110	5	110	Substitution	11
112	6	112	Red Card	43
114	6	114	Goal	55
116	6	116	Red Card	67
117	6	117	Substitution	73
118	6	118	Goal	79
119	6	119	Yellow Card	85
124	6	124	Red Card	25
125	6	125	Substitution	31
127	6	127	Yellow Card	43
128	6	128	Red Card	49
129	6	129	Substitution	55
130	6	130	Goal	61
133	7	133	Goal	32
134	7	134	Yellow Card	39
135	7	135	Red Card	46
137	7	137	Goal	60
138	7	138	Yellow Card	67
139	7	139	Red Card	74
140	7	140	Substitution	81
141	7	141	Goal	88
142	7	142	Yellow Card	5
143	7	143	Red Card	12
144	7	144	Substitution	19
145	7	145	Goal	26
146	7	146	Yellow Card	33
148	7	148	Substitution	47
150	7	150	Yellow Card	61
151	7	151	Red Card	68
152	7	152	Substitution	75
153	7	153	Goal	82
178	9	178	Substitution	73
179	9	179	Goal	82
180	9	180	Yellow Card	1
181	9	181	Red Card	10
183	9	183	Goal	28
184	9	184	Yellow Card	37
185	9	185	Red Card	46
186	9	186	Substitution	55
188	9	188	Yellow Card	73
189	9	189	Red Card	82
190	9	190	Substitution	1
191	9	191	Goal	10
192	9	192	Yellow Card	19
194	9	194	Substitution	37
196	9	196	Yellow Card	55
197	9	197	Red Card	64
198	9	198	Substitution	73
221	11	221	Goal	2
222	11	222	Yellow Card	13
223	11	223	Red Card	24
225	11	225	Goal	46
228	11	228	Substitution	79
229	11	229	Goal	90
234	11	234	Yellow Card	55
235	11	235	Red Card	66
236	11	236	Substitution	77
239	11	239	Red Card	20
241	11	241	Goal	42
243	12	243	Substitution	37
246	12	246	Red Card	73
247	12	247	Substitution	85
248	12	248	Goal	7
250	12	250	Red Card	31
251	12	251	Substitution	43
253	12	253	Yellow Card	67
254	12	254	Red Card	79
255	12	255	Substitution	1
256	12	256	Goal	13
257	12	257	Yellow Card	25
258	12	258	Red Card	37
259	12	259	Substitution	49
260	12	260	Goal	61
261	12	261	Yellow Card	73
262	12	262	Red Card	85
263	12	263	Substitution	7
264	12	264	Goal	19
265	13	265	Red Card	26
266	13	266	Substitution	39
270	13	270	Substitution	1
271	13	271	Goal	14
274	13	274	Substitution	53
275	13	275	Goal	66
276	13	276	Yellow Card	79
277	13	277	Red Card	2
278	13	278	Substitution	15
279	13	279	Goal	28
147	7	\N	Red Card	40
149	7	\N	Goal	54
154	7	\N	Yellow Card	89
177	9	\N	Red Card	64
182	9	\N	Substitution	19
187	9	\N	Goal	64
193	9	\N	Red Card	28
195	9	\N	Goal	46
224	11	\N	Substitution	35
226	11	\N	Yellow Card	57
227	11	\N	Red Card	68
230	11	\N	Yellow Card	11
231	11	\N	Red Card	22
232	11	\N	Substitution	33
233	11	\N	Goal	44
237	11	\N	Goal	88
238	11	\N	Yellow Card	9
240	11	\N	Substitution	31
242	11	\N	Yellow Card	53
244	12	\N	Goal	49
245	12	\N	Yellow Card	61
249	12	\N	Yellow Card	19
252	12	\N	Goal	55
267	13	\N	Goal	52
268	13	\N	Yellow Card	65
269	13	\N	Red Card	78
272	13	\N	Yellow Card	27
273	13	\N	Red Card	40
280	13	\N	Yellow Card	41
281	13	281	Red Card	54
282	13	282	Substitution	67
283	13	283	Goal	80
285	13	285	Red Card	16
287	14	287	Yellow Card	59
289	14	289	Substitution	87
290	14	290	Goal	11
291	14	291	Yellow Card	25
292	14	292	Red Card	39
293	14	293	Substitution	53
294	14	294	Goal	67
297	14	297	Substitution	19
300	14	300	Red Card	61
301	14	301	Substitution	75
304	14	304	Red Card	27
305	14	305	Substitution	41
307	14	307	Yellow Card	69
310	15	310	Yellow Card	61
311	15	311	Red Card	76
312	15	312	Substitution	1
313	15	313	Goal	16
314	15	314	Yellow Card	31
315	15	315	Red Card	46
317	15	317	Goal	76
319	15	319	Red Card	16
320	15	320	Substitution	31
322	15	322	Yellow Card	61
323	15	323	Red Card	76
324	15	324	Substitution	1
326	15	326	Yellow Card	31
327	15	327	Red Card	46
330	15	330	Yellow Card	1
331	16	331	Substitution	77
332	16	332	Goal	3
333	16	333	Yellow Card	19
334	16	334	Red Card	35
335	16	335	Substitution	51
336	16	336	Goal	67
337	16	337	Yellow Card	83
338	16	338	Red Card	9
339	16	339	Substitution	25
340	16	340	Goal	41
342	16	342	Red Card	73
343	16	343	Substitution	89
344	16	344	Goal	15
345	16	345	Yellow Card	31
348	16	348	Goal	79
349	16	349	Yellow Card	5
351	16	351	Substitution	37
353	17	353	Red Card	62
354	17	354	Substitution	79
357	17	357	Red Card	40
358	17	358	Substitution	57
359	17	359	Goal	74
360	17	360	Yellow Card	1
364	17	364	Yellow Card	69
367	17	367	Goal	30
369	17	369	Red Card	64
372	17	372	Yellow Card	25
373	17	373	Red Card	42
374	17	374	Substitution	59
375	18	375	Yellow Card	1
380	18	380	Red Card	1
381	18	381	Substitution	19
382	18	382	Goal	37
384	18	384	Red Card	73
385	18	385	Substitution	1
386	18	386	Goal	19
387	18	387	Yellow Card	37
390	18	390	Goal	1
391	18	391	Yellow Card	19
392	18	392	Red Card	37
394	18	394	Goal	73
395	18	395	Yellow Card	1
398	19	398	Yellow Card	3
402	19	402	Yellow Card	79
405	19	405	Goal	46
406	19	406	Yellow Card	65
407	19	407	Red Card	84
409	19	409	Goal	32
411	19	411	Red Card	70
413	19	413	Goal	18
414	19	414	Yellow Card	37
415	19	415	Red Card	56
416	19	416	Substitution	75
417	19	417	Goal	4
418	19	418	Yellow Card	23
419	20	419	Substitution	11
420	20	420	Goal	31
421	20	421	Yellow Card	51
422	20	422	Red Card	71
423	20	423	Substitution	1
425	20	425	Yellow Card	41
426	20	426	Red Card	61
427	20	427	Substitution	81
428	20	428	Goal	11
429	20	429	Yellow Card	31
430	20	430	Red Card	51
433	20	433	Yellow Card	21
434	20	434	Red Card	41
436	20	436	Goal	81
438	20	438	Red Card	31
439	20	439	Substitution	51
440	20	440	Goal	71
441	21	441	Red Card	82
442	21	442	Substitution	13
445	21	445	Red Card	76
446	21	446	Substitution	7
447	21	447	Goal	28
448	21	448	Yellow Card	49
451	21	451	Goal	22
452	21	452	Yellow Card	43
456	21	456	Yellow Card	37
459	21	459	Goal	10
460	21	460	Yellow Card	31
461	21	461	Red Card	52
463	22	463	Yellow Card	17
464	22	464	Red Card	39
465	22	465	Substitution	61
468	22	468	Red Card	37
469	22	469	Substitution	59
472	22	472	Red Card	35
473	22	473	Substitution	57
474	22	474	Goal	79
475	22	475	Yellow Card	11
476	22	476	Red Card	33
477	22	477	Substitution	55
479	22	479	Yellow Card	9
480	22	480	Red Card	31
481	22	481	Substitution	53
482	22	482	Goal	75
483	22	483	Yellow Card	7
484	22	484	Red Card	29
486	23	486	Yellow Card	19
487	23	487	Red Card	42
488	23	488	Substitution	65
489	23	489	Goal	88
490	23	490	Yellow Card	21
491	23	491	Red Card	44
493	23	493	Goal	90
496	23	496	Substitution	69
497	23	497	Goal	2
498	23	498	Yellow Card	25
500	23	500	Substitution	71
501	24	7	Substitution	79
502	24	8	Goal	13
505	24	11	Substitution	85
506	24	12	Goal	19
507	24	13	Yellow Card	43
510	24	16	Goal	25
511	24	17	Yellow Card	49
512	24	18	Red Card	73
513	24	19	Substitution	7
517	24	23	Substitution	13
518	24	24	Goal	37
519	24	25	Yellow Card	61
524	25	30	Substitution	31
525	25	31	Goal	56
526	25	32	Yellow Card	81
527	25	33	Red Card	16
528	25	34	Substitution	41
530	25	36	Yellow Card	1
534	25	40	Yellow Card	11
535	25	41	Red Card	36
537	25	43	Goal	86
538	25	44	Yellow Card	21
539	25	45	Red Card	46
540	25	46	Substitution	71
541	25	47	Goal	6
542	25	48	Yellow Card	31
545	26	51	Yellow Card	67
546	26	52	Red Card	3
547	26	53	Substitution	29
548	26	54	Goal	55
549	26	55	Yellow Card	81
550	26	56	Red Card	17
551	26	57	Substitution	43
555	26	61	Substitution	57
557	26	63	Yellow Card	19
560	26	66	Goal	7
564	26	70	Goal	21
565	26	71	Yellow Card	47
567	27	73	Goal	82
568	27	74	Yellow Card	19
572	27	78	Yellow Card	37
573	27	79	Red Card	64
574	27	80	Substitution	1
575	27	81	Goal	28
577	27	83	Red Card	82
579	27	85	Goal	46
580	27	86	Yellow Card	73
581	27	87	Red Card	10
583	27	89	Goal	64
584	27	90	Yellow Card	1
585	27	91	Red Card	28
586	27	92	Substitution	55
589	28	95	Substitution	51
592	28	98	Red Card	45
593	28	99	Substitution	73
595	28	101	Yellow Card	39
596	28	102	Red Card	67
597	28	103	Substitution	5
599	28	105	Yellow Card	61
600	28	106	Red Card	89
601	28	107	Substitution	27
604	28	110	Red Card	21
606	28	112	Goal	77
608	28	114	Red Card	43
610	28	116	Goal	9
611	29	117	Red Card	64
612	29	118	Substitution	3
613	29	119	Goal	32
618	29	124	Yellow Card	87
619	29	125	Red Card	26
621	29	127	Goal	84
622	29	128	Yellow Card	23
623	29	129	Red Card	52
624	29	130	Substitution	81
627	29	133	Red Card	78
628	29	134	Substitution	17
629	29	135	Goal	46
631	29	137	Red Card	14
632	29	138	Substitution	43
655	31	161	Goal	42
657	31	163	Red Card	14
658	31	164	Substitution	45
659	31	165	Goal	76
664	31	170	Yellow Card	51
665	31	171	Red Card	82
666	31	172	Substitution	23
667	31	173	Goal	54
668	31	174	Yellow Card	85
670	31	176	Substitution	57
672	31	178	Yellow Card	29
673	31	179	Red Card	60
674	31	180	Substitution	1
675	31	181	Goal	32
677	32	183	Substitution	7
678	32	184	Goal	39
679	32	185	Yellow Card	71
680	32	186	Red Card	13
682	32	188	Goal	77
683	32	189	Yellow Card	19
684	32	190	Red Card	51
685	32	191	Substitution	83
686	32	192	Goal	25
688	32	194	Red Card	89
690	32	196	Goal	63
691	32	197	Yellow Card	5
692	32	198	Red Card	37
693	32	199	Substitution	69
694	32	200	Goal	11
696	32	202	Red Card	75
699	33	205	Red Card	16
700	33	206	Substitution	49
561	26	\N	Yellow Card	33
562	26	\N	Red Card	59
563	26	\N	Substitution	85
566	26	\N	Red Card	73
569	27	\N	Red Card	46
570	27	\N	Substitution	73
571	27	\N	Goal	10
576	27	\N	Yellow Card	55
578	27	\N	Substitution	19
582	27	\N	Substitution	37
587	27	\N	Goal	82
588	27	\N	Yellow Card	19
590	28	\N	Goal	79
591	28	\N	Yellow Card	17
594	28	\N	Goal	11
598	28	\N	Goal	33
602	28	\N	Goal	55
603	28	\N	Yellow Card	83
605	28	\N	Substitution	49
607	28	\N	Yellow Card	15
609	28	\N	Substitution	71
614	29	\N	Yellow Card	61
701	33	207	Goal	82
704	33	210	Substitution	1
705	33	211	Goal	34
706	33	212	Yellow Card	67
707	33	213	Red Card	10
708	33	214	Substitution	43
709	33	215	Goal	76
713	33	219	Goal	28
714	33	220	Yellow Card	61
715	33	221	Red Card	4
716	33	222	Substitution	37
717	33	223	Goal	70
719	33	225	Red Card	46
722	34	228	Red Card	13
723	34	229	Substitution	47
728	34	234	Goal	37
729	34	235	Yellow Card	71
730	34	236	Red Card	15
733	34	239	Yellow Card	27
735	34	241	Substitution	5
737	34	243	Yellow Card	73
740	34	246	Goal	85
741	34	247	Yellow Card	29
742	34	248	Red Card	63
744	35	250	Yellow Card	21
745	35	251	Red Card	56
747	35	253	Goal	36
748	35	254	Yellow Card	71
749	35	255	Red Card	16
750	35	256	Substitution	51
751	35	257	Goal	86
752	35	258	Yellow Card	31
753	35	259	Red Card	66
754	35	260	Substitution	11
755	35	261	Goal	46
756	35	262	Yellow Card	81
757	35	263	Red Card	26
758	35	264	Substitution	61
759	35	265	Goal	6
760	35	266	Yellow Card	41
764	35	270	Yellow Card	1
787	37	293	Red Card	42
788	37	294	Substitution	79
791	37	297	Red Card	10
794	37	300	Yellow Card	31
795	37	301	Red Card	68
798	37	304	Yellow Card	89
799	37	305	Red Card	36
801	37	307	Goal	20
804	37	310	Substitution	41
805	37	311	Goal	78
806	37	312	Yellow Card	25
807	37	313	Red Card	62
808	37	314	Substitution	9
809	38	315	Yellow Card	1
811	38	317	Substitution	77
813	38	319	Yellow Card	63
814	38	320	Red Card	11
816	38	322	Goal	87
817	38	323	Yellow Card	35
818	38	324	Red Card	73
820	38	326	Goal	59
821	38	327	Yellow Card	7
824	38	330	Goal	31
825	38	331	Yellow Card	69
826	38	332	Red Card	17
827	38	333	Substitution	55
828	38	334	Goal	3
829	38	335	Yellow Card	41
830	38	336	Red Card	79
831	39	337	Goal	4
832	39	338	Yellow Card	43
833	39	339	Red Card	82
834	39	340	Substitution	31
836	39	342	Yellow Card	19
837	39	343	Red Card	58
838	39	344	Substitution	7
839	39	345	Goal	46
702	33	\N	Yellow Card	25
703	33	\N	Red Card	58
710	33	\N	Yellow Card	19
711	33	\N	Red Card	52
712	33	\N	Substitution	85
718	33	\N	Yellow Card	13
720	33	\N	Substitution	79
721	34	\N	Yellow Card	69
724	34	\N	Goal	81
725	34	\N	Yellow Card	25
726	34	\N	Red Card	59
727	34	\N	Substitution	3
731	34	\N	Substitution	49
732	34	\N	Goal	83
734	34	\N	Red Card	61
736	34	\N	Goal	39
738	34	\N	Red Card	17
739	34	\N	Substitution	51
743	35	\N	Goal	76
746	35	\N	Substitution	1
761	35	\N	Red Card	76
762	35	\N	Substitution	21
842	39	348	Substitution	73
843	39	349	Goal	22
845	39	351	Red Card	10
847	39	353	Goal	88
848	39	354	Yellow Card	37
851	39	357	Goal	64
852	39	358	Yellow Card	13
875	41	381	Red Card	52
876	41	382	Substitution	3
878	41	384	Yellow Card	85
879	41	385	Red Card	36
880	41	386	Substitution	77
881	41	387	Goal	28
884	41	390	Substitution	61
885	41	391	Goal	12
886	41	392	Yellow Card	53
888	41	394	Substitution	45
889	41	395	Goal	86
892	41	398	Substitution	29
896	41	402	Substitution	13
899	42	405	Substitution	1
900	42	406	Goal	43
901	42	407	Yellow Card	85
903	42	409	Substitution	79
905	42	411	Yellow Card	73
907	42	413	Substitution	67
908	42	414	Goal	19
909	42	415	Yellow Card	61
910	42	416	Red Card	13
911	42	417	Substitution	55
912	42	418	Goal	7
913	42	419	Yellow Card	49
914	42	420	Red Card	1
915	42	421	Substitution	43
916	42	422	Goal	85
917	42	423	Yellow Card	37
919	43	425	Goal	6
920	43	426	Yellow Card	49
921	43	427	Red Card	2
922	43	428	Substitution	45
923	43	429	Goal	88
924	43	430	Yellow Card	41
927	43	433	Goal	80
928	43	434	Yellow Card	33
930	43	436	Substitution	29
932	43	438	Yellow Card	25
933	43	439	Red Card	68
934	43	440	Substitution	21
935	43	441	Goal	64
936	43	442	Yellow Card	17
939	43	445	Goal	56
940	43	446	Yellow Card	9
941	44	447	Substitution	49
942	44	448	Goal	3
945	44	451	Substitution	45
946	44	452	Goal	89
950	44	456	Goal	85
953	44	459	Substitution	37
954	44	460	Goal	81
955	44	461	Yellow Card	35
957	44	463	Substitution	33
958	44	464	Goal	77
959	44	465	Yellow Card	31
962	44	468	Goal	73
963	45	469	Red Card	46
966	45	472	Yellow Card	1
967	45	473	Red Card	46
968	45	474	Substitution	1
969	45	475	Goal	46
970	45	476	Yellow Card	1
971	45	477	Red Card	46
973	45	479	Goal	46
974	45	480	Yellow Card	1
975	45	481	Red Card	46
976	45	482	Substitution	1
977	45	483	Goal	46
978	45	484	Yellow Card	1
980	45	486	Substitution	1
841	39	\N	Red Card	34
844	39	\N	Yellow Card	61
846	39	\N	Substitution	49
849	39	\N	Red Card	76
850	39	\N	Substitution	25
877	41	\N	Goal	44
882	41	\N	Yellow Card	69
883	41	\N	Red Card	20
887	41	\N	Red Card	4
890	41	\N	Yellow Card	37
891	41	\N	Red Card	78
893	41	\N	Goal	70
894	41	\N	Yellow Card	21
895	41	\N	Red Card	62
897	42	\N	Yellow Card	7
898	42	\N	Red Card	49
902	42	\N	Red Card	37
904	42	\N	Goal	31
906	42	\N	Red Card	25
918	42	\N	Red Card	79
925	43	\N	Red Card	84
926	43	\N	Substitution	37
929	43	\N	Red Card	76
981	45	487	Goal	46
982	45	488	Yellow Card	1
983	45	489	Red Card	46
984	45	490	Substitution	1
985	46	491	Yellow Card	87
987	46	493	Substitution	89
990	46	496	Red Card	47
991	46	497	Substitution	3
992	46	498	Goal	49
994	46	500	Red Card	51
995	47	13	Goal	72
998	47	16	Substitution	33
999	47	17	Goal	80
1000	47	18	Yellow Card	37
1001	47	19	Red Card	84
1005	47	23	Red Card	2
1006	47	24	Substitution	49
1007	47	25	Goal	6
1012	47	30	Yellow Card	61
1013	47	31	Red Card	18
1014	47	32	Substitution	65
1015	47	33	Goal	22
1016	47	34	Yellow Card	69
1018	48	36	Goal	19
1022	48	40	Goal	31
1023	48	41	Yellow Card	79
1025	48	43	Substitution	85
1026	48	44	Goal	43
1027	48	45	Yellow Card	1
1028	48	46	Red Card	49
1029	48	47	Substitution	7
1030	48	48	Goal	55
1033	48	51	Substitution	19
1034	48	52	Goal	67
1035	48	53	Yellow Card	25
1036	48	54	Red Card	73
1037	48	55	Substitution	31
1038	48	56	Goal	79
1039	49	57	Red Card	4
1043	49	61	Red Card	20
1045	49	63	Goal	28
1048	49	66	Substitution	85
1052	49	70	Substitution	11
1053	49	71	Goal	60
1055	49	73	Red Card	68
1056	49	74	Substitution	27
1060	49	78	Substitution	43
1061	50	79	Yellow Card	81
1062	50	80	Red Card	41
1063	50	81	Substitution	1
1065	50	83	Yellow Card	11
1067	50	85	Substitution	21
1068	50	86	Goal	71
1069	50	87	Yellow Card	31
1071	50	89	Substitution	41
1072	50	90	Goal	1
1073	50	91	Yellow Card	51
1074	50	92	Red Card	11
1077	50	95	Yellow Card	71
1080	50	98	Goal	41
1081	50	99	Yellow Card	1
1083	51	101	Goal	22
1084	51	102	Yellow Card	73
1085	51	103	Red Card	34
1087	51	105	Goal	46
1088	51	106	Yellow Card	7
1089	51	107	Red Card	58
1092	51	110	Yellow Card	31
1094	51	112	Substitution	43
1096	51	114	Yellow Card	55
1098	51	116	Substitution	67
1099	51	117	Goal	28
1100	51	118	Yellow Card	79
1101	51	119	Red Card	40
1106	52	124	Goal	59
1107	52	125	Yellow Card	21
1109	52	127	Substitution	35
1110	52	128	Goal	87
1111	52	129	Yellow Card	49
1112	52	130	Red Card	11
1115	52	133	Yellow Card	77
1116	52	134	Red Card	39
1117	52	135	Substitution	1
1119	52	137	Yellow Card	15
1120	52	138	Red Card	67
1121	52	139	Substitution	29
1122	52	140	Goal	81
1123	52	141	Yellow Card	43
1124	52	142	Red Card	5
1125	52	143	Substitution	57
1126	52	144	Goal	19
1127	53	145	Red Card	36
1128	53	146	Substitution	89
1130	53	148	Yellow Card	15
1132	53	150	Substitution	31
1133	53	151	Goal	84
1134	53	152	Yellow Card	47
1135	53	153	Red Card	10
1137	53	155	Goal	26
1138	53	156	Yellow Card	79
1139	53	157	Red Card	42
1141	53	159	Goal	58
1143	53	161	Red Card	74
1145	53	163	Goal	90
1146	53	164	Yellow Card	53
1147	53	165	Red Card	16
1152	54	170	Goal	1
1153	54	171	Yellow Card	55
1154	54	172	Red Card	19
1155	54	173	Substitution	73
1156	54	174	Goal	37
1158	54	176	Red Card	55
1160	54	178	Goal	73
1161	54	179	Yellow Card	37
1162	54	180	Red Card	1
1163	54	181	Substitution	55
1165	54	183	Yellow Card	73
1166	54	184	Red Card	37
1167	54	185	Substitution	1
1168	54	186	Goal	55
1170	54	188	Red Card	73
1171	55	189	Goal	46
1172	55	190	Yellow Card	11
1173	55	191	Red Card	66
1174	55	192	Substitution	31
1176	55	194	Yellow Card	51
1178	55	196	Substitution	71
1179	55	197	Goal	36
1180	55	198	Yellow Card	1
1181	55	199	Red Card	56
1182	55	200	Substitution	21
1184	55	202	Yellow Card	41
1187	55	205	Goal	26
1188	55	206	Yellow Card	81
1189	55	207	Red Card	46
1192	55	210	Yellow Card	31
1193	56	211	Substitution	27
1194	56	212	Goal	83
1195	56	213	Yellow Card	49
1196	56	214	Red Card	15
1197	56	215	Substitution	71
1201	56	219	Substitution	25
1202	56	220	Goal	81
1203	56	221	Yellow Card	47
1204	56	222	Red Card	13
1205	56	223	Substitution	69
1207	56	225	Yellow Card	1
1210	56	228	Goal	79
1211	56	229	Yellow Card	45
1216	57	234	Substitution	19
1217	57	235	Goal	76
1218	57	236	Yellow Card	43
1221	57	239	Goal	34
1223	57	241	Red Card	58
1225	57	243	Goal	82
1228	57	246	Substitution	73
1229	57	247	Goal	40
1230	57	248	Yellow Card	7
1232	57	250	Substitution	31
1233	57	251	Goal	88
1235	57	253	Red Card	22
1236	57	254	Substitution	79
1237	58	255	Yellow Card	31
1238	58	256	Red Card	89
1239	58	257	Substitution	57
1240	58	258	Goal	25
1241	58	259	Yellow Card	83
1242	58	260	Red Card	51
1243	58	261	Substitution	19
1244	58	262	Goal	77
1245	58	263	Yellow Card	45
1246	58	264	Red Card	13
1247	58	265	Substitution	71
1248	58	266	Goal	39
1252	58	270	Goal	1
1253	58	271	Yellow Card	59
1256	58	274	Goal	53
1257	58	275	Yellow Card	21
1258	58	276	Red Card	79
1259	59	277	Goal	54
1260	59	278	Yellow Card	23
1261	59	279	Red Card	82
1263	59	281	Goal	20
1264	59	282	Yellow Card	79
1265	59	283	Red Card	48
1267	59	285	Goal	76
1269	59	287	Red Card	14
1271	59	289	Goal	42
1272	59	290	Yellow Card	11
1273	59	291	Red Card	70
1274	59	292	Substitution	39
1275	59	293	Goal	8
1276	59	294	Yellow Card	67
1279	59	297	Goal	64
1282	60	300	Goal	1
1283	60	301	Yellow Card	61
1286	60	304	Goal	61
1287	60	305	Yellow Card	31
1289	60	307	Substitution	61
1292	60	310	Red Card	61
1293	60	311	Substitution	31
1294	60	312	Goal	1
1295	60	313	Yellow Card	61
1296	60	314	Red Card	31
1297	60	315	Substitution	1
1299	60	317	Yellow Card	31
1301	60	319	Substitution	61
1302	60	320	Goal	31
1304	61	322	Substitution	23
1305	61	323	Goal	84
1306	61	324	Yellow Card	55
1308	61	326	Substitution	87
1309	61	327	Goal	58
1312	61	330	Substitution	61
1313	61	331	Goal	32
1314	61	332	Yellow Card	3
1315	61	333	Red Card	64
1316	61	334	Substitution	35
1317	61	335	Goal	6
1318	61	336	Yellow Card	67
1319	61	337	Red Card	38
1320	61	338	Substitution	9
1321	61	339	Goal	70
1322	61	340	Yellow Card	41
1324	61	342	Substitution	73
1325	62	343	Yellow Card	27
1326	62	344	Red Card	89
1327	62	345	Substitution	61
1330	62	348	Red Card	67
1331	62	349	Substitution	39
1333	62	351	Yellow Card	73
1335	62	353	Substitution	17
1336	62	354	Goal	79
1339	62	357	Substitution	85
1340	62	358	Goal	57
1341	62	359	Yellow Card	29
1342	62	360	Red Card	1
1346	62	364	Red Card	69
1349	63	367	Red Card	82
1351	63	369	Goal	28
1354	63	372	Substitution	37
1355	63	373	Goal	10
1356	63	374	Yellow Card	73
1357	63	375	Red Card	46
1362	63	380	Substitution	1
1363	63	381	Goal	64
1364	63	382	Yellow Card	37
1366	63	384	Substitution	73
1367	63	385	Goal	46
1368	63	386	Yellow Card	19
3	1	\N	Goal	4
4	1	\N	Yellow Card	5
9	1	\N	Red Card	10
503	24	\N	Yellow Card	37
10	1	\N	Substitution	11
504	24	\N	Red Card	61
14	1	\N	Substitution	15
508	24	\N	Red Card	67
996	47	\N	Yellow Card	29
15	1	\N	Goal	16
509	24	\N	Substitution	1
997	47	\N	Red Card	76
20	1	\N	Yellow Card	21
514	24	\N	Goal	31
1002	47	\N	Substitution	41
21	1	\N	Red Card	22
515	24	\N	Yellow Card	55
1003	47	\N	Goal	88
22	1	\N	Substitution	23
516	24	\N	Red Card	79
1004	47	\N	Yellow Card	45
26	2	\N	Goal	53
520	24	\N	Red Card	85
1008	47	\N	Yellow Card	53
27	2	\N	Yellow Card	55
521	24	\N	Substitution	19
1009	47	\N	Red Card	10
28	2	\N	Red Card	57
522	24	\N	Goal	43
1010	47	\N	Substitution	57
29	2	\N	Substitution	59
523	25	\N	Red Card	6
1011	47	\N	Goal	14
35	2	\N	Yellow Card	71
529	25	\N	Goal	66
1017	48	\N	Substitution	61
37	2	\N	Substitution	75
531	25	\N	Red Card	26
1019	48	\N	Yellow Card	67
38	2	\N	Goal	77
532	25	\N	Substitution	51
1020	48	\N	Red Card	25
39	2	\N	Yellow Card	79
533	25	\N	Goal	76
1021	48	\N	Substitution	73
42	2	\N	Goal	85
536	25	\N	Substitution	61
1024	48	\N	Red Card	37
49	3	\N	Goal	58
543	25	\N	Red Card	56
1031	48	\N	Yellow Card	13
50	3	\N	Yellow Card	61
544	25	\N	Substitution	81
1032	48	\N	Red Card	61
58	3	\N	Yellow Card	85
552	26	\N	Goal	69
1040	49	\N	Substitution	53
59	3	\N	Red Card	88
553	26	\N	Yellow Card	5
1041	49	\N	Goal	12
60	3	\N	Substitution	1
554	26	\N	Red Card	31
1042	49	\N	Yellow Card	61
62	3	\N	Yellow Card	7
556	26	\N	Goal	83
1044	49	\N	Substitution	69
64	3	\N	Substitution	13
558	26	\N	Red Card	45
1046	49	\N	Yellow Card	77
65	3	\N	Goal	16
559	26	\N	Substitution	71
1047	49	\N	Red Card	36
67	4	\N	Substitution	89
1049	49	\N	Goal	44
68	4	\N	Goal	3
1050	49	\N	Yellow Card	3
69	4	\N	Yellow Card	7
1051	49	\N	Red Card	52
72	4	\N	Goal	19
1054	49	\N	Yellow Card	19
75	4	\N	Substitution	31
1057	49	\N	Goal	76
76	4	\N	Goal	35
1058	49	\N	Yellow Card	35
77	4	\N	Yellow Card	39
1059	49	\N	Red Card	84
82	4	\N	Red Card	59
1064	50	\N	Goal	51
84	4	\N	Goal	67
1066	50	\N	Red Card	61
88	4	\N	Goal	83
1070	50	\N	Red Card	81
93	5	\N	Red Card	16
1075	50	\N	Substitution	61
94	5	\N	Substitution	21
1076	50	\N	Goal	21
96	5	\N	Yellow Card	31
1078	50	\N	Red Card	31
97	5	\N	Red Card	36
1079	50	\N	Substitution	81
100	5	\N	Yellow Card	51
1082	50	\N	Red Card	51
104	5	\N	Yellow Card	71
1086	51	\N	Substitution	85
108	5	\N	Yellow Card	1
1090	51	\N	Substitution	19
109	5	\N	Red Card	6
1091	51	\N	Goal	70
111	6	\N	Yellow Card	37
1093	51	\N	Red Card	82
113	6	\N	Substitution	49
1095	51	\N	Goal	4
115	6	\N	Yellow Card	61
1097	51	\N	Red Card	16
120	6	\N	Red Card	1
1102	51	\N	Substitution	1
121	6	\N	Substitution	7
615	29	\N	Red Card	90
1103	51	\N	Goal	52
122	6	\N	Goal	13
616	29	\N	Substitution	29
1104	51	\N	Yellow Card	13
123	6	\N	Yellow Card	19
617	29	\N	Goal	58
1105	52	\N	Substitution	7
126	6	\N	Goal	37
620	29	\N	Substitution	55
1108	52	\N	Red Card	73
131	6	\N	Yellow Card	67
625	29	\N	Goal	20
1113	52	\N	Substitution	63
132	6	\N	Red Card	73
626	29	\N	Yellow Card	49
1114	52	\N	Goal	25
136	7	\N	Substitution	53
630	29	\N	Yellow Card	75
1118	52	\N	Goal	53
1129	53	\N	Goal	52
1131	53	\N	Red Card	68
1136	53	\N	Substitution	63
1140	53	\N	Substitution	5
1142	53	\N	Yellow Card	21
656	31	\N	Yellow Card	73
1144	53	\N	Substitution	37
660	31	\N	Yellow Card	17
1148	53	\N	Substitution	69
661	31	\N	Red Card	48
1149	54	\N	Yellow Card	19
662	31	\N	Substitution	79
1150	54	\N	Red Card	73
663	31	\N	Goal	20
1151	54	\N	Substitution	37
669	31	\N	Red Card	26
1157	54	\N	Yellow Card	1
671	31	\N	Goal	88
1159	54	\N	Substitution	19
676	31	\N	Yellow Card	63
1164	54	\N	Goal	19
681	32	\N	Substitution	45
1169	54	\N	Yellow Card	19
687	32	\N	Yellow Card	57
1175	55	\N	Goal	86
689	32	\N	Substitution	31
1177	55	\N	Red Card	16
695	32	\N	Yellow Card	43
1183	55	\N	Goal	76
697	32	\N	Substitution	17
1185	55	\N	Red Card	6
698	32	\N	Goal	49
1186	55	\N	Substitution	61
1190	55	\N	Substitution	11
1191	55	\N	Goal	66
1198	56	\N	Goal	37
1199	56	\N	Yellow Card	3
1200	56	\N	Red Card	59
1206	56	\N	Goal	35
1208	56	\N	Red Card	57
1209	56	\N	Substitution	23
1212	56	\N	Red Card	11
1213	56	\N	Substitution	67
1214	56	\N	Goal	33
1215	57	\N	Red Card	52
1219	57	\N	Red Card	10
1220	57	\N	Substitution	67
1222	57	\N	Yellow Card	1
1224	57	\N	Substitution	25
1226	57	\N	Yellow Card	49
1227	57	\N	Red Card	16
1231	57	\N	Red Card	64
1234	57	\N	Yellow Card	55
1249	58	\N	Yellow Card	7
1250	58	\N	Red Card	65
763	35	\N	Goal	56
1251	58	\N	Substitution	33
1254	58	\N	Red Card	27
1255	58	\N	Substitution	85
1262	59	\N	Substitution	51
284	13	\N	Yellow Card	3
1266	59	\N	Substitution	17
286	13	\N	Substitution	29
1268	59	\N	Yellow Card	45
288	14	\N	Red Card	73
1270	59	\N	Substitution	73
295	14	\N	Yellow Card	81
789	37	\N	Goal	26
1277	59	\N	Red Card	36
296	14	\N	Red Card	5
790	37	\N	Yellow Card	63
1278	59	\N	Substitution	5
298	14	\N	Goal	33
792	37	\N	Substitution	47
1280	59	\N	Yellow Card	33
299	14	\N	Yellow Card	47
793	37	\N	Goal	84
1281	60	\N	Substitution	31
302	14	\N	Goal	89
796	37	\N	Substitution	15
1284	60	\N	Red Card	31
303	14	\N	Yellow Card	13
797	37	\N	Goal	52
1285	60	\N	Substitution	1
306	14	\N	Goal	55
800	37	\N	Substitution	73
1288	60	\N	Red Card	1
308	14	\N	Red Card	83
802	37	\N	Yellow Card	57
1290	60	\N	Goal	31
309	15	\N	Goal	46
803	37	\N	Red Card	4
1291	60	\N	Yellow Card	1
316	15	\N	Substitution	61
810	38	\N	Red Card	39
1298	60	\N	Goal	61
318	15	\N	Yellow Card	1
812	38	\N	Goal	25
1300	60	\N	Red Card	1
321	15	\N	Goal	46
815	38	\N	Substitution	49
1303	61	\N	Red Card	52
325	15	\N	Goal	16
819	38	\N	Substitution	21
1307	61	\N	Red Card	26
328	15	\N	Substitution	61
822	38	\N	Red Card	45
1310	61	\N	Yellow Card	29
329	15	\N	Goal	76
823	38	\N	Substitution	83
1311	61	\N	Red Card	90
341	16	\N	Yellow Card	57
835	39	\N	Goal	70
1323	61	\N	Red Card	12
346	16	\N	Red Card	47
840	39	\N	Yellow Card	85
1328	62	\N	Goal	33
347	16	\N	Substitution	63
1329	62	\N	Yellow Card	5
350	16	\N	Red Card	21
1332	62	\N	Goal	11
352	16	\N	Goal	53
1334	62	\N	Red Card	45
355	17	\N	Goal	6
1337	62	\N	Yellow Card	51
356	17	\N	Yellow Card	23
1338	62	\N	Red Card	23
361	17	\N	Red Card	18
1343	62	\N	Substitution	63
362	17	\N	Substitution	35
1344	62	\N	Goal	35
363	17	\N	Goal	52
1345	62	\N	Yellow Card	7
365	17	\N	Red Card	86
1347	63	\N	Goal	46
366	17	\N	Substitution	13
1348	63	\N	Yellow Card	19
368	17	\N	Yellow Card	47
1350	63	\N	Substitution	55
370	17	\N	Substitution	81
1352	63	\N	Yellow Card	1
371	17	\N	Goal	8
1353	63	\N	Red Card	64
376	18	\N	Red Card	19
1358	63	\N	Substitution	19
377	18	\N	Substitution	37
1359	63	\N	Goal	82
378	18	\N	Goal	55
1360	63	\N	Yellow Card	55
379	18	\N	Yellow Card	73
1361	63	\N	Red Card	28
383	18	\N	Yellow Card	55
1365	63	\N	Red Card	10
388	18	\N	Red Card	55
389	18	\N	Substitution	73
393	18	\N	Substitution	55
396	18	\N	Red Card	19
397	19	\N	Goal	74
399	19	\N	Red Card	22
400	19	\N	Substitution	41
401	19	\N	Goal	60
403	19	\N	Red Card	8
404	19	\N	Substitution	27
408	19	\N	Substitution	13
410	19	\N	Yellow Card	51
412	19	\N	Substitution	89
424	20	\N	Goal	21
431	20	\N	Substitution	71
432	20	\N	Goal	1
435	20	\N	Substitution	61
437	20	\N	Yellow Card	11
931	43	\N	Goal	72
443	21	\N	Goal	34
937	43	\N	Red Card	60
444	21	\N	Yellow Card	55
938	43	\N	Substitution	13
449	21	\N	Red Card	70
943	44	\N	Yellow Card	47
450	21	\N	Substitution	1
944	44	\N	Red Card	1
453	21	\N	Red Card	64
947	44	\N	Yellow Card	43
454	21	\N	Substitution	85
948	44	\N	Red Card	87
455	21	\N	Goal	16
949	44	\N	Substitution	41
457	21	\N	Red Card	58
951	44	\N	Yellow Card	39
458	21	\N	Substitution	79
952	44	\N	Red Card	83
462	21	\N	Substitution	73
956	44	\N	Red Card	79
466	22	\N	Goal	83
960	44	\N	Red Card	75
467	22	\N	Yellow Card	15
961	44	\N	Substitution	29
470	22	\N	Goal	81
964	45	\N	Substitution	1
471	22	\N	Yellow Card	13
965	45	\N	Goal	46
478	22	\N	Goal	77
972	45	\N	Substitution	1
485	23	\N	Goal	86
979	45	\N	Red Card	46
492	23	\N	Substitution	67
986	46	\N	Red Card	43
494	23	\N	Yellow Card	23
988	46	\N	Goal	45
495	23	\N	Red Card	46
989	46	\N	Yellow Card	1
499	23	\N	Red Card	48
993	46	\N	Yellow Card	5
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.players (player_id, team_id, name, "position", birth_date, goals, assists) FROM stdin;
1	36	Callie Nieves	Veteran - RM,	1992-12-09	10	21
2	21	Chase Britt	Veteran - LB,	1993-08-28	2	16
6	41	Fallon Fulton	RWB,	1998-05-11	5	11
8	28	Quin Walker	RB,	2000-06-04	10	8
5	17	Lysandra Mccormick	Veteran - LW,	1994-06-29	11	10
7	13	Malcolm Beard	Veteran - RM,	1986-06-23	5	10
13	36	Arthur Mcconnell	LWB,	1998-05-10	0	6
11	27	Miranda Bonner	Veteran - GK,	1992-10-30	12	25
12	7	Martha Terry	Veteran - SS	1986-04-20	12	24
24	31	Fulton Kelley	Veteran - RW,	1988-04-16	8	14
17	24	Caesar Baxter	SW,	1996-10-15	2	5
18	4	Kylan Hahn	CM,	1995-03-05	9	15
19	29	Kameko Irwin	CF,	1999-02-08	10	11
30	34	Sydney Lott	Veteran - LW,	1984-10-09	5	2
41	11	Rhiannon Roy	Veteran - ST,	1987-02-20	2	28
48	26	Gloria Slater	Veteran - LM,	1991-05-02	4	10
23	2	Nita Wolfe	GK,	1998-02-25	3	27
25	25	Patricia Fernandez	RWB,	1996-02-23	9	24
51	16	Gannon Clayton	Veteran - CF,	1986-04-02	3	21
52	37	Erin Wong	Veteran - CAM,	1985-05-01	8	6
53	2	Zia Lester	Veteran - RM,	1985-01-13	9	12
54	36	Shellie Frazier	Veteran - LW,	1990-11-20	2	2
31	22	Elliott Saunders	CAM,	1999-09-07	9	20
55	2	Beau Spears	Veteran - LWB,	1989-09-14	11	8
33	17	Iliana Strickland	RB,	1995-01-25	4	25
56	19	Hadassah Duncan	Veteran - LM,	1988-05-23	1	29
66	12	Cherokee Cochran	Veteran - LM,	1988-11-10	4	24
71	19	Mercedes Mcdaniel	Veteran - LW,	1989-03-26	4	12
79	47	Garth Wooten	Veteran - RB,	1994-11-29	10	11
86	36	Austin Bonner	Veteran - CF,	1989-04-15	9	10
90	45	Colin Parks	Veteran - RB,	1991-06-05	1	2
40	23	Curran Roy	ST,	1995-03-01	10	24
43	31	Callum Lambert	LM,	1996-12-07	8	20
44	44	Ian Schmidt	CF,	1998-06-15	4	28
45	16	Idona George	CAM,	1999-02-02	2	13
46	30	Bell Tyler	CAM,	1997-05-03	12	8
57	39	Martina Bradford	CF,	1999-05-16	2	15
61	22	Danielle Wiley	CF,	1996-11-02	1	12
63	39	Germane Turner	CAM,	1998-07-27	9	10
70	11	Aquila Patel	RW,	1998-03-08	6	18
74	47	Cade Thomas	CB,	1999-09-01	5	24
78	37	Yoshio Dickerson	CB,	1995-12-05	12	6
80	2	Rashad Hull	LWB,	1998-11-23	3	23
81	42	Shad Conway	ST,	1997-12-31	3	21
83	3	Belle Hood	SS	1999-05-27	9	21
85	19	Kai Warren	CM,	1996-09-10	8	26
87	19	Ariana Kirkland	LB,	1996-08-30	7	27
89	19	Kai Nielsen	RW,	2000-02-06	10	10
91	15	Clinton Tran	CF,	1999-02-01	5	20
95	23	David Collins	RB,	1998-10-03	11	25
98	44	Maisie Nunez	LWB,	2000-02-26	9	27
103	31	Fredericka Sharp	CB,	2000-09-27	3	15
105	18	Delilah Wells	CDM,	1999-05-26	1	28
107	2	Zena Hopkins	CB,	2000-01-02	13	23
116	24	Macon Anthony	GK,	1996-08-20	12	6
118	6	Eagan Knight	LWB,	1999-03-20	9	23
125	32	Thor Mooney	Retired	1984-03-09	1	18
137	15	Alan Gibson	Retired	1983-09-11	5	27
119	28	Bradley Stafford	Veteran - SW,	1985-02-05	3	3
124	26	Anika Decker	Veteran - LB,	1991-08-07	0	3
127	42	Elliott Burt	Veteran - RB,	1984-11-09	11	5
128	3	Ignacia Booker	Veteran - ST,	1990-06-23	10	19
129	4	Donovan Love	Veteran - LM,	1992-04-08	2	2
133	47	Velma Atkins	Veteran - CDM,	1984-07-26	3	6
134	20	Oren Giles	Veteran - CAM,	1986-11-01	0	22
138	20	Shellie Long	CF,	2000-06-30	3	1
139	15	Anthony Woodward	CM,	1998-03-18	11	10
143	31	Elliott Beard	LWB,	2000-10-09	3	10
145	28	Vivian Burt	RW,	2001-02-14	2	15
146	20	Brody Dudley	ST,	1996-08-06	12	21
135	9	Reece Bell	Veteran - LWB,	1988-07-15	3	28
140	25	Shelley Dixon	Veteran - LW,	1989-11-02	5	4
150	21	Francis Howell	GK,	2001-03-07	4	26
151	2	Briar Alvarez	CB,	1995-09-20	11	15
152	20	Risa Klein	RW,	1999-02-08	12	20
153	34	Scott Miller	CB,	1995-05-02	0	18
141	46	Jonah Greene	Veteran - CF,	1992-06-08	8	26
142	22	Noel Carroll	Veteran - LM,	1986-12-03	11	2
144	13	Shaeleigh Mayer	Veteran - CAM,	1991-05-04	13	6
148	22	Shad Powers	Veteran - CF,	1994-05-16	11	16
163	15	Karly Norman	SW,	1996-08-16	9	24
164	31	Alea Woodard	LB,	1995-11-19	3	28
165	29	Clark Michael	CDM,	1997-11-13	5	11
155	43	Lars Richards	Veteran - CF,	1987-07-03	0	29
156	28	Brett Molina	Veteran - LWB,	1993-10-22	8	11
157	5	Ori Gibbs	Veteran - SS	1989-10-31	11	9
159	34	Malcolm Pitts	Veteran - CDM,	1992-05-03	12	21
170	21	Herman Riggs	CDM,	1996-06-12	5	0
171	41	Candice Nicholson	CM,	1999-12-03	10	12
172	43	Indigo Bailey	CDM,	1996-01-17	7	9
161	21	Addison Kim	Veteran - RM,	1992-04-11	5	18
176	18	Ashton Thomas	CDM,	2000-12-31	2	12
173	28	Nomlanga Dixon	Veteran - RWB,	1994-03-29	2	17
178	12	Kato Carlson	LB,	1997-02-01	1	12
174	38	Jillian Doyle	Veteran - LM,	1987-06-02	2	27
180	3	August Buckley	ST,	1996-09-03	7	5
185	38	Clayton Gonzales	Veteran - LM,	1985-10-16	9	1
186	21	Willa Mack	Veteran - RW,	1990-05-28	12	23
183	34	Ciara Ramos	LB,	1997-04-22	11	2
184	19	Byron Ford	SW,	1999-03-05	12	24
188	8	Kelsie Perkins	Veteran - CDM,	1986-07-15	6	19
189	11	Barrett Hickman	CF,	1997-04-14	3	2
199	20	Kyla Brennan	Veteran - SW,	1989-03-15	4	25
191	48	Kirk Bean	SW,	1998-12-29	8	6
196	46	Mira Franklin	RB,	1996-03-30	6	3
197	40	Dora Shepherd	LW,	1996-09-02	4	16
200	2	Ursula Dodson	CAM,	1997-04-02	4	29
202	7	Leigh Harrison	CAM,	1999-08-06	10	20
210	36	Kuame Lucas	CDM,	1995-10-27	9	7
213	34	Jada Reed	CB,	1995-06-24	7	9
214	46	Dominique Taylor	RB,	1997-01-31	10	20
219	15	Risa Riddle	LW,	1999-09-20	1	9
220	2	Kibo Garza	RWB,	2000-12-02	9	10
234	28	Quyn Patel	RWB,	1996-07-26	0	5
222	25	Gisela Contreras	Veteran - SW,	1989-07-22	3	22
223	48	Karleigh O'connor	Veteran - RWB,	1990-08-04	8	18
239	39	Hyatt Valenzuela	CF,	1999-01-31	12	11
241	26	Francis Hutchinson	CF,	1995-01-08	1	9
225	11	Chaney Jacobs	Veteran - LWB,	1993-12-01	11	24
228	6	Dawn Sweeney	Veteran - CF,	1990-01-21	10	14
229	40	Maris Herring	Veteran - RB,	1987-02-13	2	29
254	20	Tobias Sloan	SS	1998-06-05	8	23
255	4	Zenia Olsen	LW,	1996-03-12	1	17
235	31	Mira Nixon	Veteran - RWB,	1991-04-16	11	24
258	24	Melanie Nunez	LW,	1999-04-16	0	17
243	2	Evangeline Blake	Veteran - LB,	1987-02-20	6	14
263	18	Lucius Blanchard	CAM,	1996-05-17	1	1
266	35	Alma Acosta	CB,	1998-08-26	5	13
246	24	Kelsie Mendoza	Veteran - RB,	1986-10-29	1	21
247	35	Orlando Morgan	Veteran - CDM,	1994-08-21	10	4
250	20	Jasper Mathews	Veteran - SS	1991-07-04	0	15
271	7	Colt Hurley	ST,	2000-05-19	6	27
256	17	Jakeem Carlson	Veteran - CF,	1992-12-31	7	10
259	13	Lyle Mcpherson	Veteran - CM,	1992-06-19	8	5
274	27	Adam Rutledge	CDM,	1996-04-19	4	14
261	14	Signe Pitts	Veteran - CAM,	1988-05-06	12	25
278	10	Irma King	LB,	1996-10-12	9	26
262	39	Marvin Wells	Veteran - CM,	1994-04-06	6	14
282	27	Brandon Reed	ST,	1996-03-26	5	3
264	32	Axel Banks	Veteran - LB,	1987-11-16	3	28
265	36	Lacey Dotson	Veteran - LB,	1985-02-16	10	28
270	42	Flynn Lancaster	Veteran - SS	1994-06-26	2	18
275	47	Maisie Myers	Veteran - RWB,	1992-09-06	5	12
290	24	Kimberley Romero	CAM,	1999-07-26	3	15
276	29	Reece Little	Veteran - LB,	1984-06-09	13	23
292	24	Nora Brennan	ST,	1998-05-02	5	21
293	33	Brenna Floyd	CDM,	1995-01-21	8	5
279	46	Gabriel Rutledge	Veteran - CB,	1985-10-28	7	11
281	41	Wang Castillo	Veteran - RWB,	1986-06-08	12	20
283	45	Charissa Vance	Veteran - LWB,	1994-02-01	12	12
285	41	Ann May	Veteran - CDM,	1988-01-31	13	25
287	41	Kareem Pena	Veteran - LW,	1985-08-17	1	10
426	41	Nerea Foster	Veteran - CAM,	1993-11-02	13	11
430	42	Troy Ball	Veteran - CB,	1991-12-13	2	22
307	35	Keiko Conley	ST,	1995-11-20	10	24
434	12	Madaline Hopper	Veteran - LW,	1992-03-19	8	6
436	3	Bernard Baker	Veteran - RW,	1990-03-10	3	19
438	47	Nolan Compton	Veteran - LWB,	1990-08-10	3	0
311	37	Liberty Mcfarland	RWB,	1996-08-22	7	13
314	44	Jarrod Cotton	LWB,	2000-11-22	2	1
315	14	Denton Mckenzie	SS	1996-05-02	1	23
440	44	Clio Simpson	Veteran - RWB,	1987-09-13	5	10
317	28	Graiden Dickerson	CF,	1998-04-04	7	2
446	39	Joshua Graham	Veteran - LB,	1988-07-04	2	28
323	47	Kevin Leon	CB,	1998-03-28	12	5
330	2	Hanna Fernandez	ST,	1996-07-05	12	0
332	22	Davis Cantu	ST,	1995-06-24	8	16
333	12	Jared Allen	LB,	1998-07-08	7	4
342	33	Ruth Lynn	RB,	1999-04-27	7	8
344	41	Juliet Dorsey	LB,	1995-06-25	8	18
353	11	Gavin Best	LWB,	1995-03-31	11	21
360	12	Bell Sawyer	CM,	2000-07-21	1	18
289	9	Kane Bird	Veteran - CF,	1993-11-04	1	23
364	24	Ira Peterson	RM,	1999-05-28	1	15
369	10	Denton Hunter	LM,	1997-02-03	1	19
291	17	Theodore Franco	Veteran - LWB,	1985-09-01	12	6
374	28	Cody Bird	RWB,	1995-03-01	9	2
294	43	Morgan Malone	Veteran - LWB,	1989-06-30	5	26
297	40	Cameron Odom	Veteran - LB,	1988-03-14	9	28
301	42	Thane Snyder	Veteran - CDM,	1991-08-03	10	24
381	3	Hyacinth Barker	RW,	1996-05-17	10	7
382	36	Mason Rosa	CF,	1998-04-11	4	11
304	19	Kenyon Church	Veteran - LW,	1990-06-18	0	23
385	34	Berk Farmer	LM,	1997-11-16	2	2
386	20	Silas Paul	SW,	2000-11-29	4	10
305	28	Megan Frost	Veteran - LWB,	1992-12-22	3	7
310	4	Kyla Quinn	Veteran - ST,	1990-03-16	6	19
391	29	Madaline Sharpe	RWB,	1997-08-29	12	27
394	4	Beck Charles	LW,	1999-12-26	3	4
312	16	Amethyst Bishop	Veteran - CAM,	1994-09-19	12	4
406	37	Grady Rojas	RM,	1997-05-25	12	8
313	2	Evan Wagner	Veteran - SS	1993-10-13	10	22
414	30	Harrison Melendez	CF,	1998-09-01	9	26
320	19	Cyrus Hester	Veteran - LWB,	1991-08-24	5	6
322	25	Shannon Adams	Veteran - CAM,	1985-09-22	10	11
427	23	Cedric Ortega	LM,	1999-12-30	11	15
428	12	Heather Floyd	SW,	1998-06-17	9	26
429	1	Chelsea Lucas	CAM,	2001-01-07	2	30
324	10	Zoe Key	Veteran - RB,	1992-02-17	7	16
433	47	Emerald Spencer	LWB,	1997-05-24	0	17
326	26	Steel Coleman	Veteran - RB,	1988-05-08	5	26
331	17	Armand Delgado	Veteran - LW,	1985-07-09	10	13
439	23	Cameron Casey	LW,	2001-02-19	4	20
441	42	Cameron Lindsey	RB,	1998-05-16	10	11
442	11	Solomon Neal	RWB,	1996-02-02	2	11
334	46	Avram Neal	Veteran - RW,	1986-11-10	5	10
335	11	Ira Carpenter	Veteran - CB,	1990-09-25	12	16
445	28	Veda Singleton	CB,	1999-09-14	11	23
336	29	Charles Beasley	Veteran - CM,	1993-01-21	0	23
448	26	Harper Vega	CF,	2000-11-16	4	3
337	41	Britanney Benjamin	Veteran - SW,	1992-04-19	9	5
338	2	Tanya Holt	Veteran - SW,	1992-11-14	3	26
451	20	Darrel Middleton	GK,	1997-08-16	2	21
339	23	Damon Preston	Veteran - RB,	1992-12-28	6	18
340	38	Reed Hobbs	Veteran - LW,	1989-03-23	4	14
343	29	Bradley Stone	Veteran - GK,	1994-07-31	1	11
345	40	Yeo Frost	Veteran - SW,	1992-06-18	1	26
349	12	Timothy Osborne	Veteran - CAM,	1988-07-20	4	1
351	17	Rashad Whitley	Veteran - CB,	1988-01-07	12	27
354	43	Amethyst Hayden	Veteran - CDM,	1986-10-25	5	17
357	41	Nigel Sullivan	Veteran - ST,	1989-11-25	11	29
358	6	Aiko Salas	Veteran - SS	1988-02-17	4	5
359	5	Wade Marsh	Veteran - LWB,	1988-06-01	2	12
367	45	Camille Briggs	Veteran - RB,	1991-07-23	9	29
372	15	Jocelyn Guy	Veteran - CF,	1990-09-13	11	24
92	12	Kameko Mccall	Veteran - SW,	1991-02-13	5	3
473	47	Harper Munoz	SS	1995-06-10	13	29
99	37	Lareina Jacobs	Veteran - RWB,	1985-01-11	5	22
101	31	Ira Guerrero	Veteran - SS	1985-06-04	5	15
476	25	Nora Barry	RB,	1999-05-25	3	9
102	37	Xanthus Holt	Veteran - CF,	1988-07-28	2	5
106	8	Buckminster Randolph	Veteran - CF,	1992-08-19	3	6
480	23	Lydia Baxter	LWB,	1998-08-19	10	30
112	36	Xandra Blackwell	Veteran - RWB,	1991-05-19	3	24
117	12	Ciara Moreno	Veteran - CF,	1986-07-13	11	27
206	44	Aileen Torres	Veteran - RM,	1986-12-31	7	25
207	48	Logan Robbins	Veteran - SW,	1992-11-28	11	4
486	4	Brian York	LM,	1997-05-05	1	20
211	17	Petra Barnes	Veteran - RM,	1992-03-04	7	21
212	46	Robin Robles	Veteran - LWB,	1985-07-09	4	27
489	33	Heidi Stevenson	CM,	1997-10-26	4	19
380	23	Gavin Best	Veteran - RB,	1992-06-23	13	3
384	12	Aladdin Ray	Veteran - LB,	1986-09-21	13	18
387	44	Lillith Baldwin	Veteran - LW,	1989-02-08	10	3
390	7	Shoshana Hernandez	Veteran - CB,	1988-11-01	9	24
392	38	Chelsea Ochoa	Veteran - LW,	1985-12-30	11	26
395	44	Edward Kidd	Veteran - CAM,	1985-07-17	13	27
398	18	Debra Gibson	Veteran - ST,	1993-11-02	9	16
402	39	Selma Conrad	Veteran - CB,	1994-05-08	4	2
407	12	Ori Harrison	Veteran - CM,	1984-05-25	7	29
409	4	Travis Conway	Veteran - RW,	1994-11-01	10	19
415	3	Kristen Welch	Veteran - CB,	1990-04-27	3	29
416	46	Jonas Mays	Veteran - LWB,	1986-04-26	0	12
417	39	Hoyt Hinton	Veteran - RWB,	1990-08-27	2	28
419	25	Drake Mcdaniel	Veteran - LM,	1984-12-11	1	1
420	28	Asher Savage	Veteran - CDM,	1990-08-11	6	9
421	33	Kylee Ewing	Veteran - LB,	1986-03-23	4	26
422	25	Aristotle Edwards	Veteran - LW,	1993-12-27	10	11
423	24	Herman Gibbs	Veteran - RWB,	1989-10-05	5	22
425	47	Cole Morales	Veteran - RM,	1987-06-06	6	10
447	13	Gannon Barton	Veteran - RWB,	1992-08-25	7	29
452	10	Ulla Cochran	Veteran - LW,	1991-08-24	10	20
456	2	Cailin Hill	Veteran - SW,	1994-05-12	5	12
459	8	Hayden Yates	Veteran - LW,	1994-07-27	5	11
460	37	Buckminster Morrison	Veteran - RWB,	1993-04-17	4	29
16	39	Hoyt Norman	Retired	1982-10-26	5	27
32	18	Bree Wells	Retired	1983-05-02	7	23
34	6	Vincent Miller	Retired	1982-12-02	1	28
36	17	Bernard Schwartz	Retired	1982-06-07	4	8
47	37	Emerson Brady	Retired	1982-07-15	6	8
73	41	Rae Peck	Retired	1982-10-04	6	30
130	47	Cairo Merrill	Retired	1983-06-26	0	1
179	31	Vernon Holden	Retired	1983-02-08	3	3
181	10	Avye Rice	Retired	1983-09-10	12	30
190	23	Garrison Bolton	Retired	1982-04-14	0	9
192	33	Celeste Moss	Retired	1983-05-16	9	14
194	24	Uriah Bryan	Retired	1982-06-01	2	25
198	21	Candice Anthony	Retired	1983-03-17	7	27
205	35	Beck Frye	Retired	1983-03-22	8	8
215	26	Rana Langley	Retired	1983-03-27	10	11
221	40	Bernard Stokes	Retired	1983-07-13	12	1
236	6	Jaden Wong	Retired	1984-01-02	4	23
248	26	Omar Weeks	Retired	1983-10-31	3	7
251	11	Ava Joyce	Retired	1983-05-13	2	9
253	42	Dolan Hammond	Retired	1983-03-10	1	8
257	4	Timothy Bond	Retired	1983-02-13	11	1
260	38	Hu Farley	Retired	1983-11-12	11	5
277	40	Ariel Yates	Retired	1983-08-18	9	22
300	37	Bert Patrick	Retired	1983-08-02	9	8
319	23	Naomi Petersen	Retired	1983-09-04	10	7
327	7	Pascale Lambert	Retired	1983-06-13	3	8
348	46	Griffin May	Retired	1983-02-16	5	10
373	14	Reuben Berger	Retired	1984-04-12	4	22
110	30	Jordan Melton	Retired	1984-02-18	11	17
114	9	Brielle Doyle	Retired	1984-03-22	12	29
375	35	Willa Lopez	Retired	1983-06-16	5	20
405	40	Montana Morton	Retired	1983-02-05	12	9
411	10	Micah Durham	Retired	1982-07-19	12	27
413	29	Jenna Greene	Retired	1982-04-23	6	25
418	25	Deborah Stephens	Retired	1982-07-02	1	20
463	7	Adria Forbes	Retired	1982-07-06	2	27
479	38	Elliott Allison	Retired	1984-04-08	3	24
481	37	Tarik Cooley	Retired	1982-12-31	1	4
487	24	Seth Dotson	Retired	1982-10-30	5	8
498	31	Charissa Wade	Retired	1983-01-24	2	9
461	42	Shelly Hopper	Veteran - GK,	1993-12-19	1	12
464	15	Hector Ayala	Veteran - CF,	1987-10-14	10	13
465	32	Lila Joyner	Veteran - RW,	1985-02-09	6	13
468	16	Brady Kirby	Veteran - CF,	1984-10-02	3	27
469	45	Tana Meyers	Veteran - SW,	1993-09-11	11	19
472	16	Cyrus Wyatt	Veteran - LM,	1988-03-06	10	22
474	40	Connor Mcbride	Veteran - LM,	1993-09-09	9	8
475	4	Brock Mckee	Veteran - CDM,	1993-05-10	9	14
477	40	Renee Raymond	Veteran - LW,	1990-08-02	2	26
482	12	Nigel Campos	Veteran - RWB,	1992-04-13	12	14
483	8	Eric Montgomery	Veteran - LW,	1986-04-04	6	4
484	40	Rina Irwin	Veteran - SW,	1991-01-30	1	24
488	24	Ivy Yang	Veteran - RM,	1988-02-16	7	25
490	42	Flynn Dillon	Veteran - CDM,	1986-03-05	6	12
491	16	Alexis Cohen	Veteran - LWB,	1994-08-24	0	17
493	41	Charles Banks	Veteran - ST,	1989-07-30	3	18
496	20	Joel Pruitt	Veteran - RB,	1991-12-11	7	15
497	6	Britanney Vega	Veteran - GK,	1992-02-27	9	23
500	19	Maite Mckinney	Veteran - ST,	1986-01-25	2	22
\.


--
-- Data for Name: playersinmatches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.playersinmatches (is_substitute, player_id, match_id) FROM stdin;
f	54	42
f	198	53
t	344	5
f	150	49
t	262	62
f	434	37
f	260	18
t	360	41
f	486	16
t	180	46
f	219	54
f	381	21
t	493	26
t	222	17
f	387	31
f	241	38
f	164	44
f	117	52
t	57	33
f	406	1
t	134	7
f	314	6
f	418	3
f	407	2
f	481	12
f	340	55
t	139	33
f	199	18
f	63	56
t	391	63
t	476	7
t	16	54
t	56	48
t	425	48
t	359	54
t	315	26
t	335	19
t	119	35
t	18	7
f	70	58
t	429	54
f	428	2
f	213	26
t	349	34
t	294	32
f	150	5
f	333	61
f	317	48
f	202	18
f	228	38
f	197	63
t	191	35
f	335	37
t	427	11
f	387	56
f	45	26
t	173	4
t	189	21
f	54	34
f	74	41
f	382	35
f	236	37
f	116	59
t	241	33
f	452	45
t	107	60
f	337	50
f	440	41
t	188	45
f	46	58
f	11	19
f	493	54
t	153	4
t	375	26
f	384	12
f	373	56
f	43	32
t	421	61
t	55	23
t	488	58
f	74	22
t	171	25
t	156	48
f	13	46
t	331	53
f	18	52
f	493	2
t	282	29
f	214	51
f	80	48
t	319	7
t	251	3
f	340	62
f	99	61
t	291	27
f	107	13
t	179	15
f	90	18
f	141	12
f	45	48
t	174	22
t	130	16
t	469	58
f	282	3
t	493	28
t	186	21
f	86	39
f	74	21
t	274	28
f	146	46
t	125	28
f	176	46
f	479	26
t	312	43
t	430	60
f	490	18
f	417	39
f	433	11
t	23	56
t	474	37
t	48	43
t	105	37
t	183	21
t	459	35
f	127	63
f	261	38
f	36	27
t	78	12
f	367	52
f	142	45
t	89	62
t	491	46
f	429	9
f	253	27
f	99	22
f	112	56
f	324	37
f	51	41
t	323	45
t	290	2
t	364	41
f	213	35
f	171	9
t	207	32
f	474	23
t	420	13
t	390	46
t	163	21
t	81	58
f	239	18
f	422	49
f	140	17
f	25	42
t	473	26
f	150	42
t	423	62
t	380	41
f	40	53
f	402	53
f	114	43
t	433	35
f	277	39
t	259	3
t	215	5
t	438	2
f	419	32
t	46	34
f	192	39
t	5	11
t	211	59
f	487	2
t	475	51
t	310	54
f	106	19
f	210	52
f	206	57
t	305	33
t	445	31
t	110	4
t	359	49
f	343	58
f	107	44
f	239	54
t	287	37
t	61	35
t	369	13
t	142	42
f	390	31
t	210	16
t	24	48
f	159	19
t	8	58
f	448	47
f	124	11
t	297	59
f	234	54
f	32	9
f	85	45
f	291	11
f	354	29
f	354	51
t	172	5
f	413	38
t	475	27
f	357	58
f	78	20
t	488	44
f	461	60
t	307	27
t	30	59
f	23	18
t	292	53
t	225	11
f	336	35
f	305	28
f	334	2
f	135	35
f	464	1
t	184	14
f	465	55
t	384	4
t	43	6
f	176	56
t	200	60
t	156	35
t	248	28
f	465	3
f	317	51
f	460	46
t	143	4
f	30	42
t	474	3
f	116	18
t	441	48
t	206	61
f	250	24
f	256	1
f	351	15
t	228	9
t	353	44
t	220	11
f	418	61
f	481	22
t	92	62
t	337	39
t	343	14
f	312	32
f	19	16
f	257	31
f	289	18
f	446	51
f	255	20
f	342	34
t	32	17
t	349	52
t	200	43
t	264	39
t	304	18
f	416	62
t	266	57
f	324	21
t	103	16
f	221	48
t	348	59
t	189	49
f	391	6
f	235	44
f	159	42
t	133	48
t	144	34
t	265	9
t	326	45
f	188	43
t	276	21
t	358	33
f	150	15
f	2	43
t	129	21
t	463	15
t	323	13
t	192	27
t	247	51
t	118	39
t	31	59
f	386	20
t	394	7
f	293	19
f	34	51
t	405	25
f	155	39
t	63	21
t	409	1
f	384	43
f	375	21
t	311	7
t	413	23
t	18	3
f	331	57
t	143	42
f	480	38
t	165	55
t	489	50
f	439	19
f	71	26
t	313	31
t	157	61
t	197	27
t	270	62
t	472	5
t	95	34
f	46	26
t	30	39
t	290	46
t	152	54
f	392	61
f	41	13
t	66	11
t	326	46
t	127	33
f	196	63
t	395	14
f	426	38
t	334	38
t	301	32
f	285	6
t	236	46
t	322	22
f	221	18
f	279	49
t	145	63
t	254	52
t	124	23
t	373	26
f	320	28
f	283	1
t	338	2
f	263	49
f	87	4
f	255	24
t	212	16
f	137	46
t	181	6
f	223	43
t	271	6
f	463	9
t	327	51
t	133	47
t	128	43
f	145	47
t	80	52
t	418	59
f	44	5
t	156	15
t	91	18
t	484	23
f	151	12
t	46	25
t	46	9
f	320	5
t	99	63
t	407	3
t	307	56
f	170	33
f	63	37
f	243	17
t	421	56
t	89	37
t	1	13
t	333	13
t	52	45
t	266	22
f	290	34
t	385	54
f	483	47
f	445	33
t	451	63
f	163	63
t	398	61
t	487	22
t	127	27
f	46	56
f	155	61
t	105	11
t	330	22
f	258	56
t	138	2
t	79	35
f	477	16
t	497	37
t	442	13
f	436	17
f	281	19
t	358	5
t	409	60
t	32	28
f	428	56
f	161	38
f	219	20
f	51	4
t	83	54
f	95	18
t	414	25
f	33	33
t	101	20
f	278	14
f	202	25
t	411	21
t	156	50
f	456	31
f	300	25
f	192	28
f	423	13
f	427	15
f	47	20
t	473	14
f	248	16
t	500	46
t	148	3
t	332	19
t	194	52
f	179	43
t	7	51
f	498	61
f	374	7
f	421	2
t	32	38
f	112	59
t	285	61
f	315	19
t	415	51
t	73	60
t	413	2
t	447	23
t	6	32
t	205	34
t	427	17
f	102	49
f	185	58
f	90	60
f	468	28
f	482	15
f	496	29
f	275	41
f	246	31
f	114	7
t	190	24
f	87	43
f	489	37
t	339	23
t	98	60
t	142	15
f	12	55
t	265	28
f	493	44
t	390	37
f	53	59
f	345	17
t	17	44
t	178	25
f	294	19
f	414	16
f	229	20
f	185	26
t	372	23
f	25	38
\.


--
-- Data for Name: stadiums; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stadiums (stadium_id, name, city, capacity) FROM stdin;
1	Lusail Iconic Stadium	Lusail	80000
2	Al Bayt Stadium	Al Khor	60000
3	Al Janoub Stadium	Al Wakrah	40000
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teams (team_id, team_name, coach, team_group, fifa_ranking) FROM stdin;
7	Belgium	Emmaline Benton	G	1
1	France	Cassaundra Wornham	A	2
2	Spain	Robbyn Boldecke	E	3
3	England	Noelyn Ellcome	E	4
4	Brazil	Roxy Gladdish	H	5
6	Portugal	Blinni Edwick	C	6
5	Netherlands	Wynn Macveigh	C	7
8	Italy	Lesley Bengal	H	8
9	Germany	Leyla Lieb	F	9
10	Croatia	Lise Peppin	E	10
11	Switzerland	Cathyleen Swinnard	H	11
12	Denmark	Theo Gerrelts	A	12
13	Austria	Tim Illwell	A	13
14	Japan	Ephrayim Kerrey	D	14
15	Iran	Giacomo Laurenz	B	15
16	Senegal	Tully Planks	A	16
17	Morocco	Danica Benian	B	17
18	Uruguay	Andras Twelftree	F	18
19	Colombia	Brigida Pischoff	E	19
20	South Korea	Sinclare Ship	E	20
21	Ecuador	Florance Ringer	F	21
22	Australia	Gabriel Lett	A	22
23	Egypt	Merilee Eagle	G	23
24	Panama	Arthur Casella	A	24
25	Algeria	Kristel Snarie	F	25
26	Ivory Coast	Gilbertina Escala	B	26
27	Paraguay	Vivien Preshaw	F	27
28	Tunisia	Adrien Milksop	D	28
29	Cameroon	Wolfy Yushachkov	E	29
30	Costa Rica	Clark Merle	B	30
31	South Africa	Golda Climson	G	31
32	Uzbekistan	Erie Garnham	C	32
33	Scotland	Caroljean Fortune	A	33
34	Slovenia	Carmencita Datte	C	34
35	Ireland	Reggis Vigurs	G	35
36	Finland	Modesty Papis	E	36
37	Georgia	Nicolis Bernardeschi	B	37
38	Albania	Kaye Iglesia	B	38
39	North Macedonia	Rodina Sellstrom	C	39
40	Iceland	Tana Bracknell	G	40
41	Norway	Grove Netti	C	41
42	Slovakia	Emalee Josefson	B	42
43	Romania	Natala Gaudon	D	43
44	Greece	Danyelle Cranston	B	44
45	Hungary	Danika Bodocs	H	45
46	Czech Republic	Illa Mallon	A	46
47	Wales	Irving Simionato	C	47
48	Saudi Arabia	Ajay Watterson	G	48
\.


--
-- Data for Name: tournamentstages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tournamentstages (stage_id, name, matches_count, start_date, finish_date) FROM stdin;
1	Group Stage	48	2024-06-01	2024-06-14
2	Round of 16	8	2024-06-15	2024-06-18
3	Quarter Finals	4	2024-06-19	2024-06-21
4	Semi Finals	2	2024-06-22	2024-06-24
5	Final	1	2024-06-25	2024-06-25
\.


--
-- Name: matches_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matches_match_id_seq', 63, true);


--
-- Name: matchevents_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matchevents_event_id_seq', 1368, true);


--
-- Name: players_player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.players_player_id_seq', 501, true);


--
-- Name: stadiums_stadium_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stadiums_stadium_id_seq', 15, true);


--
-- Name: teams_team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teams_team_id_seq', 311, true);


--
-- Name: tournamentstages_stage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tournamentstages_stage_id_seq', 74, true);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (match_id);


--
-- Name: matchevents matchevents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchevents
    ADD CONSTRAINT matchevents_pkey PRIMARY KEY (event_id);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (player_id);


--
-- Name: playersinmatches playersinmatches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playersinmatches
    ADD CONSTRAINT playersinmatches_pkey PRIMARY KEY (player_id, match_id);


--
-- Name: stadiums stadiums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stadiums
    ADD CONSTRAINT stadiums_pkey PRIMARY KEY (stadium_id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (team_id);


--
-- Name: tournamentstages tournamentstages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tournamentstages
    ADD CONSTRAINT tournamentstages_pkey PRIMARY KEY (stage_id);


--
-- Name: matches matches_stadium_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES public.stadiums(stadium_id) ON DELETE SET NULL;


--
-- Name: matches matches_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.tournamentstages(stage_id) ON DELETE SET NULL;


--
-- Name: matches matches_team1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_team1_id_fkey FOREIGN KEY (team1_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: matches matches_team2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_team2_id_fkey FOREIGN KEY (team2_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: matchevents matchevents_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchevents
    ADD CONSTRAINT matchevents_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(match_id) ON DELETE CASCADE;


--
-- Name: matchevents matchevents_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matchevents
    ADD CONSTRAINT matchevents_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(player_id) ON DELETE SET NULL;


--
-- Name: players players_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(team_id) ON DELETE CASCADE;


--
-- Name: playersinmatches playersinmatches_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playersinmatches
    ADD CONSTRAINT playersinmatches_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(match_id) ON DELETE CASCADE;


--
-- Name: playersinmatches playersinmatches_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playersinmatches
    ADD CONSTRAINT playersinmatches_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(player_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

