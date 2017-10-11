--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: call_result; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE call_result (
    id bigint NOT NULL,
    result character varying,
    ivrres character varying,
    descr character varying
);


ALTER TABLE public.call_result OWNER TO pgsql;

--
-- Name: call_result_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE call_result_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.call_result_id_seq OWNER TO pgsql;

--
-- Name: call_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE call_result_id_seq OWNED BY call_result.id;


--
-- Name: call_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('call_result_id_seq', 20, true);


--
-- Name: group_members; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE group_members (
    id bigint NOT NULL,
    group_id bigint NOT NULL,
    modem_id bigint,
    interface character varying
);


ALTER TABLE public.group_members OWNER TO pgsql;

--
-- Name: group_members_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE group_members_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_members_id_seq OWNER TO pgsql;

--
-- Name: group_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE group_members_id_seq OWNED BY group_members.id;


--
-- Name: group_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('group_members_id_seq', 10, true);


--
-- Name: job; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE job (
    id bigint NOT NULL,
    description character varying,
    allowed_times time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    allowed_timee time without time zone DEFAULT '20:00:00'::time without time zone NOT NULL,
    interval_success interval DEFAULT '1 day'::interval NOT NULL,
    interval_busy interval DEFAULT '00:05:00'::interval NOT NULL,
    interval_na interval DEFAULT '01:00:00'::interval NOT NULL,
    next_try timestamp without time zone,
    target character varying,
    template_id bigint NOT NULL,
    active boolean DEFAULT true NOT NULL,
    verified timestamp without time zone,
    verified_by bigint
);


ALTER TABLE public.job OWNER TO pgsql;

--
-- Name: job_elog; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE job_elog (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    t timestamp without time zone DEFAULT now() NOT NULL,
    opearator_id bigint,
    descr character varying,
    changes character varying
);


ALTER TABLE public.job_elog OWNER TO pgsql;

--
-- Name: job_elog_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE job_elog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_elog_id_seq OWNER TO pgsql;

--
-- Name: job_elog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE job_elog_id_seq OWNED BY job_elog.id;


--
-- Name: job_elog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('job_elog_id_seq', 1, false);


--
-- Name: job_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE job_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_id_seq OWNER TO pgsql;

--
-- Name: job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE job_id_seq OWNED BY job.id;


--
-- Name: job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('job_id_seq', 12, true);


--
-- Name: job_log; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE job_log (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    number_id bigint NOT NULL,
    t timestamp without time zone DEFAULT now() NOT NULL,
    result character varying NOT NULL,
    duration interval,
    ivrres character varying
);


ALTER TABLE public.job_log OWNER TO pgsql;

--
-- Name: job_log_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE job_log_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_log_id_seq OWNER TO pgsql;

--
-- Name: job_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE job_log_id_seq OWNED BY job_log.id;


--
-- Name: job_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('job_log_id_seq', 2031, true);


--
-- Name: job_numbers; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE job_numbers (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    number character varying,
    last_attempt timestamp without time zone,
    last_result character varying,
    active boolean DEFAULT true NOT NULL,
    next_try timestamp without time zone
);


ALTER TABLE public.job_numbers OWNER TO pgsql;

--
-- Name: job_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE job_numbers_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_numbers_id_seq OWNER TO pgsql;

--
-- Name: job_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE job_numbers_id_seq OWNED BY job_numbers.id;


--
-- Name: job_numbers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('job_numbers_id_seq', 26, true);


--
-- Name: modem_groups; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE modem_groups (
    id bigint NOT NULL,
    name character varying
);


ALTER TABLE public.modem_groups OWNER TO pgsql;

--
-- Name: modem_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE modem_groups_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.modem_groups_id_seq OWNER TO pgsql;

--
-- Name: modem_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE modem_groups_id_seq OWNED BY modem_groups.id;


--
-- Name: modem_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('modem_groups_id_seq', 5, true);


--
-- Name: notification; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE notification (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    number_id bigint NOT NULL,
    t timestamp without time zone DEFAULT now() NOT NULL,
    result character varying,
    ivrres character varying,
    warning boolean DEFAULT false NOT NULL,
    seen bigint
);


ALTER TABLE public.notification OWNER TO pgsql;

--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE notification_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_id_seq OWNER TO pgsql;

--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE notification_id_seq OWNED BY notification.id;


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('notification_id_seq', 26, true);


--
-- Name: route_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE route_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.route_id_seq OWNER TO pgsql;

--
-- Name: route_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('route_id_seq', 12331, true);


--
-- Name: route; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE route (
    id bigint DEFAULT nextval('route_id_seq'::regclass) NOT NULL,
    pattern character varying,
    group_id bigint,
    prio bigint
);


ALTER TABLE public.route OWNER TO pgsql;

--
-- Name: template; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE template (
    id bigint NOT NULL,
    name character varying,
    exten character varying
);


ALTER TABLE public.template OWNER TO pgsql;

--
-- Name: template_actions; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE template_actions (
    id bigint NOT NULL,
    template_id bigint NOT NULL,
    result_id bigint NOT NULL,
    continue boolean DEFAULT true NOT NULL,
    pause interval,
    info boolean,
    warning boolean,
    npause interval DEFAULT '01:00:00'::interval
);


ALTER TABLE public.template_actions OWNER TO pgsql;

--
-- Name: template_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE template_actions_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.template_actions_id_seq OWNER TO pgsql;

--
-- Name: template_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE template_actions_id_seq OWNED BY template_actions.id;


--
-- Name: template_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('template_actions_id_seq', 180, true);


--
-- Name: template_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE template_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.template_id_seq OWNER TO pgsql;

--
-- Name: template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE template_id_seq OWNED BY template.id;


--
-- Name: template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('template_id_seq', 10, true);


--
-- Name: users; Type: TABLE; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE TABLE users (
    id bigint NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL,
    email character varying NOT NULL,
    fname character varying NOT NULL,
    lname character varying NOT NULL,
    mname character varying,
    secq character varying,
    seca character varying,
    smsnumber character varying,
    allowadvert boolean DEFAULT true NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    comments text,
    sex boolean DEFAULT true NOT NULL,
    birthday character varying,
    longid character varying,
    sms character varying
);


ALTER TABLE public.users OWNER TO pgsql;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: pgsql
--

CREATE SEQUENCE users_id_seq
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO pgsql;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pgsql
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pgsql
--

SELECT pg_catalog.setval('users_id_seq', 4, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY call_result ALTER COLUMN id SET DEFAULT nextval('call_result_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY group_members ALTER COLUMN id SET DEFAULT nextval('group_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY job ALTER COLUMN id SET DEFAULT nextval('job_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY job_elog ALTER COLUMN id SET DEFAULT nextval('job_elog_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY job_log ALTER COLUMN id SET DEFAULT nextval('job_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY job_numbers ALTER COLUMN id SET DEFAULT nextval('job_numbers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY modem_groups ALTER COLUMN id SET DEFAULT nextval('modem_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY notification ALTER COLUMN id SET DEFAULT nextval('notification_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY template ALTER COLUMN id SET DEFAULT nextval('template_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY template_actions ALTER COLUMN id SET DEFAULT nextval('template_actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: call_result; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY call_result (id, result, ivrres, descr) FROM stdin;
5	Success	d	Ответил и прослушал
6	Success	x	Ответил и сбросил недослушав
7	Success	0	Прослушал и нажал 0
8	Success	1	Прослушал и нажал 1
9	Success	2	Прослушал и нажал 2
10	Success	3	Прослушал и нажал 3
11	Success	4	Прослушал и нажал 4
12	Success	5	Прослушал и нажал 5
13	Success	6	Прослушал и нажал 6
14	Success	7	Прослушал и нажал 7
15	Success	8	Прослушал и нажал 8
16	Success	9	Прослушал и нажал 9
17	Success	*	Прослушал и нажал *
18	Success	#	Прослушал и нажал #
2	NotAnswer	\N	Не ответил
1	Busy	\N	Занято
19	Congestion	\N	Сеть занята
20	Success	1+	Нажал 1 и дослушал до конца
\.


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY group_members (id, group_id, modem_id, interface) FROM stdin;
1001	1	1	SIP/g101/1~s
1003	2	3	SIP/g103/3~s
1004	2	4	SIP/g104/4~s
1005	3	5	SIP/g105/5~s
1006	3	6	SIP/g106/6~s
1007	4	7	SIP/g107/7~s
1008	4	8	SIP/g108/8~s
1010	0	0	IAX2/xhome/~s
1002	5	2	SIP/g102/2~s
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY job (id, description, allowed_times, allowed_timee, interval_success, interval_busy, interval_na, next_try, target, template_id, active, verified, verified_by) FROM stdin;
2	Владимир	00:00:00	20:00:00	01:00:00	00:00:30	00:03:00	2013-01-29 00:00:00	001	2	f	2013-01-30 21:31:09.854713	3
1	Иван	00:00:00	24:00:00	00:15:00	00:00:01	00:00:05	2013-01-28 15:01:56.46286	002	2	f	\N	\N
11	Максима	09:00:00	18:00:00	1 day	00:05:00	01:00:00	2013-01-28 15:23:17.50957	\N	2	f	\N	\N
12	Отдел рекламы	09:00:00	17:00:00	1 day	00:05:00	01:00:00	2013-01-28 00:00:00	\N	2	f	\N	\N
10	Семён	00:00:00	24:00:00	01:00:00	00:05:00	00:30:00	2013-01-27 15:49:52.65701	003	2	f	\N	\N
\.


--
-- Data for Name: job_elog; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY job_elog (id, job_id, t, opearator_id, descr, changes) FROM stdin;
\.


--
-- Data for Name: job_log; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY job_log (id, job_id, number_id, t, result, duration, ivrres) FROM stdin;
900	1	19	2013-01-25 23:35:42.613438	Busy	00:00:00	\N
901	1	19	2013-01-25 23:36:18.345062	Busy	00:00:00	\N
902	1	19	2013-01-25 23:36:42.618377	Busy	00:00:00	\N
903	1	19	2013-01-25 23:37:12.620754	Busy	00:00:00	\N
904	1	19	2013-01-25 23:37:47.623273	NotAnswer	00:00:00	\N
905	1	19	2013-01-25 23:39:04.882369	NotAnswer	00:00:00	\N
906	1	19	2013-01-25 23:40:07.663343	Busy	00:00:00	\N
907	1	19	2013-01-25 23:40:42.665805	NotAnswer	00:00:00	\N
908	1	19	2013-01-25 23:41:52.684802	NotAnswer	00:00:00	\N
909	1	19	2013-01-25 23:42:57.703705	Busy	00:00:00	\N
910	1	19	2013-01-25 23:43:32.706262	NotAnswer	00:00:00	\N
911	1	19	2013-01-25 23:44:37.725231	Busy	00:00:00	\N
912	1	19	2013-01-25 23:45:07.727652	Busy	00:00:00	\N
913	1	19	2013-01-25 23:45:37.73017	Busy	00:00:00	\N
914	1	19	2013-01-25 23:46:17.582679	NotAnswer	00:00:00	\N
915	1	19	2013-01-25 23:47:22.753564	Busy	00:00:00	\N
916	1	19	2013-01-25 23:47:55.756085	Success	00:00:05	\N
917	2	20	2013-01-25 23:58:28.007256	NotAnswer	00:00:00	\N
918	1	19	2013-01-26 00:03:03.11324	NotAnswer	00:00:00	\N
919	10	22	2013-01-26 00:03:33.115643	NotAnswer	00:00:00	\N
920	1	19	2013-01-26 00:04:08.122159	Busy	00:00:00	\N
921	1	19	2013-01-26 00:04:46.314703	Busy	00:00:00	\N
922	1	19	2013-01-26 00:05:08.127013	Busy	00:00:00	\N
923	1	19	2013-01-26 00:05:41.129517	Success	00:00:05	\N
924	1	19	2013-01-26 00:20:56.648786	NotAnswer	00:00:00	\N
925	1	19	2013-01-26 00:22:06.517718	Success	00:00:05	\N
926	10	22	2013-01-26 00:33:43.796851	NotAnswer	00:00:00	\N
927	1	19	2013-01-26 00:37:08.873829	Busy	00:00:00	\N
928	1	19	2013-01-26 00:37:41.876199	Success	00:00:05	\N
929	1	19	2013-01-26 00:52:51.308424	Busy	00:00:00	\N
930	1	19	2013-01-26 00:53:19.24582	NotAnswer	00:00:00	\N
931	1	19	2013-01-26 00:54:24.264799	Busy	00:00:00	\N
932	1	19	2013-01-26 00:54:59.267427	NotAnswer	00:00:00	\N
933	1	19	2013-01-26 00:56:07.286245	Success	00:00:05	\N
934	10	22	2013-01-26 01:03:49.469996	Busy	00:00:00	\N
935	10	22	2013-01-26 01:09:00.490536	Busy	00:00:00	\N
936	1	19	2013-01-26 01:11:22.048566	NotAnswer	00:00:00	\N
937	1	19	2013-01-26 01:12:27.653479	Success	00:00:05	\N
938	10	22	2013-01-26 01:14:09.684881	NotAnswer	00:00:00	\N
939	1	19	2013-01-26 01:27:30.008503	Busy	00:00:00	\N
940	1	19	2013-01-26 01:28:05.011026	NotAnswer	00:00:00	\N
941	1	19	2013-01-26 01:29:10.030001	Busy	00:00:00	\N
942	1	19	2013-01-26 01:29:43.032451	Success	00:00:05	\N
943	10	22	2013-01-26 01:44:34.367367	Busy	00:00:00	\N
944	1	19	2013-01-26 01:44:45.388539	Busy	00:00:00	\N
945	1	19	2013-01-26 01:45:15.391	Busy	00:00:00	\N
849	1	19	2012-12-25 14:21:09.765382	Busy	\N	\N
946	1	19	2013-01-26 01:45:54.786518	NotAnswer	00:00:00	\N
947	1	19	2013-01-26 01:47:05.414564	NotAnswer	00:00:00	\N
950	10	22	2013-01-26 01:49:53.455386	Success	00:00:05	\N
952	1	19	2013-01-26 02:05:00.822124	Busy	00:00:00	\N
948	1	19	2013-01-26 01:48:15.433578	NotAnswer	00:00:00	\N
955	1	19	2013-01-26 02:06:40.831634	NotAnswer	00:00:00	\N
949	1	19	2013-01-26 01:49:20.452496	Busy	00:00:00	\N
951	1	19	2013-01-26 01:49:58.456112	Success	00:00:05	\N
953	1	19	2013-01-26 02:05:37.924731	Busy	00:00:00	\N
954	1	19	2013-01-26 02:06:21.916376	Busy	00:00:00	\N
956	1	19	2013-01-26 02:07:50.850668	NotAnswer	00:00:00	\N
957	1	19	2013-01-26 02:09:18.900943	NotAnswer	00:00:00	\N
958	1	19	2013-01-26 02:10:25.896888	Busy	00:00:00	\N
959	1	19	2013-01-26 02:11:00.899425	NotAnswer	00:00:00	\N
960	1	19	2013-01-26 02:12:14.818462	NotAnswer	00:00:00	\N
961	1	19	2013-01-26 02:13:41.896685	NotAnswer	00:00:00	\N
962	1	19	2013-01-26 02:14:48.96466	Success	00:00:05	\N
963	1	19	2013-01-26 02:29:51.32975	Busy	00:00:00	\N
964	1	19	2013-01-26 02:30:26.332333	NotAnswer	00:00:00	\N
965	1	19	2013-01-26 02:31:31.351284	Busy	00:00:00	\N
966	1	19	2013-01-26 02:32:06.353715	NotAnswer	00:00:00	\N
967	1	19	2013-01-26 02:33:11.372685	Busy	00:00:00	\N
968	1	19	2013-01-26 02:33:44.375122	Success	00:00:05	\N
969	1	19	2013-01-26 02:48:51.740309	NotAnswer	00:00:00	\N
970	10	22	2013-01-26 02:49:59.759719	Success	00:00:05	\N
971	1	19	2013-01-26 02:50:12.48157	Busy	00:00:00	\N
972	1	19	2013-01-26 02:50:30.41577	Busy	00:00:00	\N
973	1	19	2013-01-26 02:50:56.764182	Busy	00:00:00	\N
974	1	19	2013-01-26 02:51:31.767662	NotAnswer	00:00:00	\N
975	1	19	2013-01-26 02:52:50.150758	NotAnswer	00:00:00	\N
976	1	19	2013-01-26 02:54:07.677944	NotAnswer	00:00:00	\N
977	1	19	2013-01-26 02:55:16.829947	NotAnswer	00:00:00	\N
978	1	19	2013-01-26 02:56:21.848932	Busy	00:00:00	\N
979	1	19	2013-01-26 02:57:08.836593	NotAnswer	00:00:00	\N
980	1	19	2013-01-26 02:58:21.72467	NotAnswer	00:00:00	\N
981	1	19	2013-01-26 02:59:31.077589	Busy	00:00:00	\N
982	1	19	2013-01-26 03:00:01.898048	NotAnswer	00:00:00	\N
983	1	19	2013-01-26 03:01:06.917029	Busy	00:00:00	\N
984	1	19	2013-01-26 03:01:36.919492	Busy	00:00:00	\N
985	1	19	2013-01-26 03:02:06.937727	Busy	00:00:00	\N
986	1	19	2013-01-26 03:02:41.924438	NotAnswer	00:00:00	\N
987	1	19	2013-01-26 03:03:49.943358	Success	00:00:05	\N
988	1	19	2013-01-26 03:19:11.859728	NotAnswer	00:00:00	\N
989	1	19	2013-01-26 03:20:29.388933	Busy	00:00:00	\N
990	1	19	2013-01-26 03:20:58.05736	Busy	00:00:00	\N
991	1	19	2013-01-26 03:21:17.33967	Busy	00:00:00	\N
992	1	19	2013-01-26 03:21:50.342117	Success	00:00:05	\N
993	1	19	2013-01-26 03:36:52.710334	Busy	00:00:00	\N
994	1	19	2013-01-26 03:37:34.239889	Busy	00:00:00	\N
995	1	19	2013-01-26 03:37:52.715208	Busy	00:00:00	\N
996	1	19	2013-01-26 03:38:41.83693	Busy	00:00:00	\N
997	1	19	2013-01-26 03:39:02.722125	NotAnswer	00:00:00	\N
998	1	19	2013-01-26 03:40:18.434268	NotAnswer	00:00:00	\N
999	1	19	2013-01-26 03:41:22.762243	Busy	00:00:00	\N
1000	1	19	2013-01-26 03:42:06.446809	NotAnswer	00:00:00	\N
1001	1	19	2013-01-26 03:43:20.55592	Busy	00:00:00	\N
1002	1	19	2013-01-26 03:43:47.790342	NotAnswer	00:00:00	\N
1003	1	19	2013-01-26 03:44:57.809275	NotAnswer	00:00:00	\N
1004	1	19	2013-01-26 03:46:02.828267	Busy	00:00:00	\N
1005	1	19	2013-01-26 03:46:32.830727	Busy	00:00:00	\N
1006	1	19	2013-01-26 03:47:07.833224	NotAnswer	00:00:00	\N
1007	1	19	2013-01-26 03:48:17.852232	NotAnswer	00:00:00	\N
1008	1	19	2013-01-26 03:49:22.872194	Busy	00:00:00	\N
1009	1	19	2013-01-26 03:49:52.873598	Busy	00:00:00	\N
1010	10	22	2013-01-26 03:50:22.876495	Busy	00:00:00	\N
1011	1	19	2013-01-26 03:50:33.918205	NotAnswer	00:00:00	\N
1012	1	19	2013-01-26 03:51:51.933387	Success	00:00:05	\N
1013	10	22	2013-01-26 03:55:30.982556	Success	00:00:05	\N
1014	1	19	2013-01-26 04:06:58.258504	Busy	00:00:00	\N
1015	1	19	2013-01-26 04:07:33.26101	NotAnswer	00:00:00	\N
1016	1	19	2013-01-26 04:08:38.279971	Busy	00:00:00	\N
1017	1	19	2013-01-26 04:09:13.282476	NotAnswer	00:00:00	\N
1018	1	19	2013-01-26 04:10:36.410676	NotAnswer	00:00:00	\N
1019	1	19	2013-01-26 04:11:48.327788	NotAnswer	00:00:00	\N
1020	1	19	2013-01-26 04:13:09.243957	NotAnswer	00:00:00	\N
1021	1	19	2013-01-26 04:14:20.687994	NotAnswer	00:00:00	\N
1022	1	19	2013-01-26 04:15:23.388968	Busy	00:00:00	\N
1023	1	19	2013-01-26 04:15:53.391412	Busy	00:00:00	\N
1024	1	19	2013-01-26 04:16:50.467135	NotAnswer	00:00:00	\N
1025	1	19	2013-01-26 04:17:58.421234	NotAnswer	00:00:00	\N
1026	1	19	2013-01-26 04:19:06.445135	Success	00:00:05	\N
1027	1	19	2013-01-26 04:34:08.811281	Busy	00:00:00	\N
1028	1	19	2013-01-26 04:34:52.424978	NotAnswer	00:00:00	\N
1029	1	19	2013-01-26 04:36:08.827032	NotAnswer	00:00:00	\N
1030	1	19	2013-01-26 04:37:22.364098	Busy	00:00:00	\N
1031	1	19	2013-01-26 04:37:54.979592	Success	00:00:05	\N
1032	1	19	2013-01-26 04:53:05.696861	Busy	00:00:00	\N
1033	1	19	2013-01-26 04:53:37.88631	NotAnswer	00:00:00	\N
1034	1	19	2013-01-26 04:54:49.257312	NotAnswer	00:00:00	\N
1035	10	22	2013-01-26 04:55:39.268035	NotAnswer	00:00:00	\N
1036	1	19	2013-01-26 04:56:21.387654	Busy	00:00:00	\N
1037	1	19	2013-01-26 04:56:42.274979	Success	00:00:05	\N
1038	1	19	2013-01-26 05:12:04.106427	Success	00:00:05	\N
1039	10	22	2013-01-26 05:25:49.995397	NotAnswer	00:00:00	\N
1040	1	19	2013-01-26 05:27:15.020603	NotAnswer	00:00:00	\N
1041	1	19	2013-01-26 05:28:25.039559	NotAnswer	00:00:00	\N
1042	1	19	2013-01-26 05:29:55.690915	NotAnswer	00:00:00	\N
1043	1	19	2013-01-26 05:31:15.879203	Success	00:00:05	\N
1044	1	19	2013-01-26 05:46:25.457309	NotAnswer	00:00:00	\N
1045	1	19	2013-01-26 05:47:42.998496	NotAnswer	00:00:00	\N
1046	1	19	2013-01-26 05:48:50.497498	NotAnswer	00:00:00	\N
1047	1	19	2013-01-26 05:50:08.459587	NotAnswer	00:00:00	\N
1048	1	19	2013-01-26 05:51:13.537565	Success	00:00:05	\N
1050	10	22	2013-01-26 06:01:05.76217	NotAnswer	00:00:00	\N
1057	1	19	2013-01-26 06:13:59.013443	Success	00:00:05	\N
1061	1	19	2013-01-26 06:31:44.414902	Success	00:00:05	\N
1064	10	22	2013-01-26 06:46:31.753835	Busy	00:00:00	\N
1067	1	19	2013-01-26 06:48:31.734596	NotAnswer	00:00:00	\N
1075	1	19	2013-01-26 06:55:16.872587	Busy	00:00:00	\N
1077	1	19	2013-01-26 06:56:56.893898	Busy	00:00:00	\N
1080	1	19	2013-01-26 06:58:36.915305	Busy	00:00:00	\N
1082	1	19	2013-01-26 07:00:28.689016	Success	00:00:05	\N
1084	1	19	2013-01-26 07:15:42.840252	Busy	00:00:00	\N
1049	10	22	2013-01-26 05:55:55.645712	Busy	00:00:00	\N
1052	1	19	2013-01-26 06:07:40.90592	NotAnswer	00:00:00	\N
1054	1	19	2013-01-26 06:10:29.860385	NotAnswer	00:00:00	\N
1060	10	22	2013-01-26 06:31:11.412403	Busy	00:00:00	\N
1066	1	19	2013-01-26 06:47:41.762878	Busy	00:00:00	\N
1071	1	19	2013-01-26 06:51:52.816526	NotAnswer	00:00:00	\N
1083	10	22	2013-01-26 07:02:36.982833	NotAnswer	00:00:00	\N
1051	1	19	2013-01-26 06:06:30.056922	NotAnswer	00:00:00	\N
1053	1	19	2013-01-26 06:09:01.225361	NotAnswer	00:00:00	\N
1058	1	19	2013-01-26 06:29:06.378558	NotAnswer	00:00:00	\N
1063	10	22	2013-01-26 06:41:25.922363	Busy	00:00:00	\N
1072	10	22	2013-01-26 06:52:06.112629	Busy	00:00:00	\N
1055	1	19	2013-01-26 06:11:40.975429	NotAnswer	00:00:00	\N
1059	1	19	2013-01-26 06:30:16.397606	NotAnswer	00:00:00	\N
1062	10	22	2013-01-26 06:36:16.518816	Busy	00:00:00	\N
1068	1	19	2013-01-26 06:49:41.790481	NotAnswer	00:00:00	\N
1070	1	19	2013-01-26 06:51:16.812899	Busy	00:00:00	\N
1073	1	19	2013-01-26 06:53:01.834415	NotAnswer	00:00:00	\N
1078	10	22	2013-01-26 06:57:26.896701	Busy	00:00:00	\N
1056	1	19	2013-01-26 06:12:50.994368	NotAnswer	00:00:00	\N
1065	1	19	2013-01-26 06:47:25.654555	Busy	00:00:00	\N
1069	1	19	2013-01-26 06:50:46.809508	Busy	00:00:00	\N
1074	1	19	2013-01-26 06:54:11.853493	NotAnswer	00:00:00	\N
1076	1	19	2013-01-26 06:55:51.874962	NotAnswer	00:00:00	\N
1079	1	19	2013-01-26 06:57:33.897378	NotAnswer	00:00:00	\N
1081	1	19	2013-01-26 06:59:11.917837	NotAnswer	00:00:00	\N
1085	1	19	2013-01-26 07:16:07.29968	NotAnswer	00:00:00	\N
1086	1	19	2013-01-26 07:17:17.318657	NotAnswer	00:00:00	\N
1087	1	19	2013-01-26 07:18:22.337525	Busy	00:00:00	\N
1088	1	19	2013-01-26 07:19:01.022101	Busy	00:00:00	\N
1089	1	19	2013-01-26 07:19:34.020672	NotAnswer	00:00:00	\N
1090	1	19	2013-01-26 07:20:42.363567	NotAnswer	00:00:00	\N
1091	1	19	2013-01-26 07:22:01.240762	NotAnswer	00:00:00	\N
1092	1	19	2013-01-26 07:23:20.068868	NotAnswer	00:00:00	\N
1093	1	19	2013-01-26 07:24:25.427923	Success	00:00:05	\N
1094	10	22	2013-01-26 07:32:47.625166	NotAnswer	00:00:00	\N
1095	1	19	2013-01-26 07:39:39.568175	Success	00:00:05	\N
1096	1	19	2013-01-26 07:54:48.152469	NotAnswer	00:00:00	\N
1097	1	19	2013-01-26 07:56:08.434571	Success	00:00:05	\N
1098	10	22	2013-01-26 08:02:58.335593	NotAnswer	00:00:00	\N
1099	1	19	2013-01-26 08:11:18.533908	NotAnswer	00:00:00	\N
1100	1	19	2013-01-26 08:12:35.46697	Busy	00:00:00	\N
1101	1	19	2013-01-26 08:12:53.555295	Busy	00:00:00	\N
1102	1	19	2013-01-26 08:13:23.55767	Busy	00:00:00	\N
1103	1	19	2013-01-26 08:13:58.560381	NotAnswer	00:00:00	\N
1104	1	19	2013-01-26 08:15:11.284292	NotAnswer	00:00:00	\N
1105	1	19	2013-01-26 08:16:18.598204	NotAnswer	00:00:00	\N
1106	1	19	2013-01-26 08:17:23.617141	Busy	00:00:00	\N
1107	1	19	2013-01-26 08:17:58.619688	NotAnswer	00:00:00	\N
1108	1	19	2013-01-26 08:19:06.639654	Success	00:00:05	\N
1109	10	22	2013-01-26 08:33:17.968116	NotAnswer	00:00:00	\N
1110	1	19	2013-01-26 08:34:18.555983	NotAnswer	00:00:00	\N
1111	1	19	2013-01-26 08:35:29.043102	NotAnswer	00:00:00	\N
1112	1	19	2013-01-26 08:36:42.673161	Busy	00:00:00	\N
1113	1	19	2013-01-26 08:37:16.199638	NotAnswer	00:00:00	\N
1114	1	19	2013-01-26 08:38:19.085539	Busy	00:00:00	\N
1115	1	19	2013-01-26 08:39:07.166244	Success	00:00:05	\N
1116	1	19	2013-01-26 08:54:09.459386	Busy	00:00:00	\N
1117	1	19	2013-01-26 08:54:42.799876	Busy	00:00:00	\N
1118	1	19	2013-01-26 08:55:09.464214	Busy	00:00:00	\N
1119	1	19	2013-01-26 08:55:44.466763	NotAnswer	00:00:00	\N
1120	1	19	2013-01-26 08:56:54.48573	NotAnswer	00:00:00	\N
1121	1	19	2013-01-26 08:57:59.504712	Busy	00:00:00	\N
1122	1	19	2013-01-26 08:58:33.407189	Busy	00:00:00	\N
1123	1	19	2013-01-26 08:58:59.509638	Busy	00:00:00	\N
1124	1	19	2013-01-26 08:59:34.512136	NotAnswer	00:00:00	\N
1125	2	20	2013-01-26 09:00:13.241705	NotAnswer	00:00:00	\N
1126	1	19	2013-01-26 09:00:44.521168	NotAnswer	00:00:00	\N
1127	1	19	2013-01-26 09:01:54.540112	NotAnswer	00:00:00	\N
1128	1	19	2013-01-26 09:03:04.559166	NotAnswer	00:00:00	\N
1129	10	22	2013-01-26 09:03:34.561574	NotAnswer	00:00:00	\N
1130	2	20	2013-01-26 09:03:59.563957	Busy	00:00:00	\N
1131	1	19	2013-01-26 09:04:34.566462	NotAnswer	00:00:00	\N
1132	2	20	2013-01-26 09:05:04.568899	NotAnswer	00:00:00	\N
1133	1	19	2013-01-26 09:05:56.517667	Busy	00:00:00	\N
1134	1	19	2013-01-26 09:06:19.666011	Busy	00:00:00	\N
1135	1	19	2013-01-26 09:06:42.580383	Success	00:00:05	\N
1136	2	20	2013-01-26 09:08:09.607689	Busy	00:00:00	\N
1137	2	20	2013-01-26 09:08:44.612104	Busy	00:00:00	\N
1138	2	20	2013-01-26 09:09:19.616573	Busy	00:00:00	\N
1139	2	20	2013-01-26 09:09:59.621267	NotAnswer	00:00:00	\N
1140	2	20	2013-01-26 09:13:09.699974	NotAnswer	00:00:00	\N
1141	2	20	2013-01-26 09:16:19.76383	NotAnswer	00:00:00	\N
1142	2	20	2013-01-26 09:19:24.832396	Busy	00:00:00	\N
1143	2	20	2013-01-26 09:20:17.103292	NotAnswer	00:00:00	\N
1144	1	19	2013-01-26 09:21:49.871617	NotAnswer	00:00:00	\N
1145	1	19	2013-01-26 09:22:54.890622	Busy	00:00:00	\N
1146	1	19	2013-01-26 09:23:30.894417	NotAnswer	00:00:00	\N
1147	2	20	2013-01-26 09:23:37.895125	NotAnswer	00:00:00	\N
1148	1	19	2013-01-26 09:24:50.246275	NotAnswer	00:00:00	\N
1149	1	19	2013-01-26 09:26:21.200555	NotAnswer	00:00:00	\N
1150	2	20	2013-01-26 09:26:39.943798	Busy	00:00:00	\N
1151	2	20	2013-01-26 09:27:19.948465	NotAnswer	00:00:00	\N
1152	1	19	2013-01-26 09:27:44.950809	Busy	00:00:00	\N
1153	1	19	2013-01-26 09:28:17.953268	Success	00:00:05	\N
1154	2	20	2013-01-26 09:30:28.335167	Busy	00:00:00	\N
1155	2	20	2013-01-26 09:31:12.664837	Busy	00:00:00	\N
1156	2	20	2013-01-26 09:31:50.011393	NotAnswer	00:00:00	\N
1157	10	22	2013-01-26 09:33:45.048978	NotAnswer	00:00:00	\N
1158	2	20	2013-01-26 09:34:55.070066	Busy	00:00:00	\N
1159	2	20	2013-01-26 09:35:35.074676	NotAnswer	00:00:00	\N
1160	2	20	2013-01-26 09:38:45.143411	NotAnswer	00:00:00	\N
1161	2	20	2013-01-26 09:41:53.212185	Success	00:00:05	\N
1162	1	19	2013-01-26 09:43:20.239453	Busy	00:00:00	\N
1163	1	19	2013-01-26 09:43:55.241906	NotAnswer	00:00:00	\N
1164	1	19	2013-01-26 09:45:05.260957	NotAnswer	00:00:00	\N
1165	1	19	2013-01-26 09:46:10.279955	Busy	00:00:00	\N
1166	1	19	2013-01-26 09:46:53.286556	Busy	00:00:00	\N
1167	1	19	2013-01-26 09:47:10.284751	Busy	00:00:00	\N
1168	1	19	2013-01-26 09:47:45.287292	NotAnswer	00:00:00	\N
1169	1	19	2013-01-26 09:48:50.306207	Busy	00:00:00	\N
1170	1	19	2013-01-26 09:49:27.723796	Busy	00:00:00	\N
1171	1	19	2013-01-26 09:50:03.993352	NotAnswer	00:00:00	\N
1173	10	22	2013-01-26 10:04:16.588848	NotAnswer	00:00:00	\N
1174	1	19	2013-01-26 10:06:15.689544	Busy	00:00:00	\N
1175	1	19	2013-01-26 10:06:48.691987	Success	00:00:05	\N
1177	10	22	2013-01-26 10:34:26.359209	NotAnswer	00:00:00	\N
1181	2	20	2013-01-26 10:42:36.522379	NotAnswer	00:00:00	\N
1185	1	19	2013-01-26 10:55:04.662311	NotAnswer	00:00:00	\N
1186	1	19	2013-01-26 10:56:09.810273	Success	00:00:05	\N
1194	1	19	2013-01-26 11:30:17.580249	Busy	00:00:00	\N
1195	1	19	2013-01-26 11:30:47.582682	Busy	00:00:00	\N
1197	1	19	2013-01-26 11:32:32.604193	NotAnswer	00:00:00	\N
1198	1	19	2013-01-26 11:33:39.801153	Busy	00:00:00	\N
1199	1	19	2013-01-26 11:34:12.625596	NotAnswer	00:00:00	\N
1202	1	19	2013-01-26 11:36:27.653535	Busy	00:00:00	\N
1206	1	19	2013-01-26 11:38:32.663473	NotAnswer	00:00:00	\N
1211	2	20	2013-01-26 11:49:37.889209	NotAnswer	00:00:00	\N
1213	2	20	2013-01-26 11:55:58.027188	NotAnswer	00:00:00	\N
1217	2	20	2013-01-26 11:59:31.076176	Success	00:00:05	\N
1218	1	19	2013-01-26 11:59:33.076864	Busy	00:00:00	\N
1220	1	19	2013-01-26 12:01:16.954382	Busy	00:00:00	\N
1222	1	19	2013-01-26 12:16:57.88412	NotAnswer	00:00:00	\N
1223	1	19	2013-01-26 12:18:06.489121	Success	00:00:05	\N
1225	10	22	2013-01-26 12:34:53.925835	NotAnswer	00:00:00	\N
1228	2	20	2013-01-26 12:59:34.518309	Busy	00:00:00	\N
1231	1	19	2013-01-26 13:04:04.598328	NotAnswer	00:00:00	\N
1235	1	19	2013-01-26 13:08:09.66284	Busy	00:00:00	\N
1236	1	19	2013-01-26 13:08:42.665396	Success	00:00:05	\N
1172	1	19	2013-01-26 09:51:13.334324	Success	00:00:05	\N
1178	1	19	2013-01-26 10:37:18.565756	NotAnswer	00:00:00	\N
1183	2	20	2013-01-26 10:48:54.659897	Success	00:00:05	\N
1191	1	19	2013-01-26 11:28:12.14841	NotAnswer	00:00:00	\N
1196	1	19	2013-01-26 11:31:22.585157	NotAnswer	00:00:00	\N
1201	1	19	2013-01-26 11:35:22.634699	NotAnswer	00:00:00	\N
1203	1	19	2013-01-26 11:36:57.656088	Busy	00:00:00	\N
1219	1	19	2013-01-26 12:00:03.078238	NotAnswer	00:00:00	\N
1221	1	19	2013-01-26 12:01:41.099671	Success	00:00:05	\N
1226	1	19	2013-01-26 12:48:33.831798	Busy	00:00:00	\N
1229	2	20	2013-01-26 13:00:09.522889	Busy	00:00:00	\N
1234	1	19	2013-01-26 13:07:06.777912	NotAnswer	00:00:00	\N
1237	10	22	2013-01-26 13:10:44.705142	NotAnswer	00:00:00	\N
1241	1	19	2013-01-26 13:40:30.40816	Busy	00:00:00	\N
1176	1	19	2013-01-26 10:21:54.058265	Success	00:00:05	\N
1179	1	19	2013-01-26 10:38:24.438734	Success	00:00:05	\N
1180	2	20	2013-01-26 10:41:56.517784	Busy	00:00:00	\N
1182	2	20	2013-01-26 10:45:46.591182	NotAnswer	00:00:00	\N
1184	1	19	2013-01-26 10:53:48.882282	NotAnswer	00:00:00	\N
1187	10	22	2013-01-26 11:04:37.009661	NotAnswer	00:00:00	\N
1188	1	19	2013-01-26 11:11:17.16562	NotAnswer	00:00:00	\N
1190	1	19	2013-01-26 11:12:55.187021	Success	00:00:05	\N
1193	1	19	2013-01-26 11:29:56.924939	Busy	00:00:00	\N
1205	1	19	2013-01-26 11:37:57.660912	Busy	00:00:00	\N
1207	1	19	2013-01-26 11:39:42.682436	NotAnswer	00:00:00	\N
1209	1	19	2013-01-26 11:41:27.276978	Success	00:00:05	\N
1214	1	19	2013-01-26 11:56:38.033313	NotAnswer	00:00:00	\N
1224	1	19	2013-01-26 12:33:11.889232	Success	00:00:05	\N
1227	1	19	2013-01-26 12:48:54.438085	Success	00:00:05	\N
1230	2	20	2013-01-26 13:00:47.527481	Success	00:00:05	\N
1232	1	19	2013-01-26 13:05:34.615942	NotAnswer	00:00:00	\N
1238	1	19	2013-01-26 13:23:50.021546	NotAnswer	00:00:00	\N
1240	1	19	2013-01-26 13:25:28.043027	Success	00:00:05	\N
1242	10	22	2013-01-26 13:41:00.411977	Busy	00:00:00	\N
1189	1	19	2013-01-26 11:12:22.184441	Busy	00:00:00	\N
1192	1	19	2013-01-26 11:29:32.372583	Busy	00:00:00	\N
1200	10	22	2013-01-26 11:34:45.630159	Success	00:00:05	\N
1204	1	19	2013-01-26 11:37:27.658532	Busy	00:00:00	\N
1208	1	19	2013-01-26 11:40:47.701426	Busy	00:00:00	\N
1210	2	20	2013-01-26 11:48:57.884527	Busy	00:00:00	\N
1212	2	20	2013-01-26 11:52:47.957905	NotAnswer	00:00:00	\N
1215	1	19	2013-01-26 11:57:55.958402	NotAnswer	00:00:00	\N
1216	1	19	2013-01-26 11:58:58.073323	Busy	00:00:00	\N
1233	10	22	2013-01-26 13:05:36.616637	Busy	00:00:00	\N
1239	1	19	2013-01-26 13:24:55.040455	Busy	00:00:00	\N
1243	1	19	2013-01-26 13:41:10.953724	Busy	00:00:00	\N
1244	1	19	2013-01-26 13:41:30.413985	Busy	00:00:00	\N
1245	1	19	2013-01-26 13:42:00.416411	Busy	00:00:00	\N
1246	1	19	2013-01-26 13:42:30.418845	Busy	00:00:00	\N
1247	1	19	2013-01-26 13:43:05.421352	NotAnswer	00:00:00	\N
1248	1	19	2013-01-26 13:44:26.71463	Busy	00:00:00	\N
1249	1	19	2013-01-26 13:44:43.442868	Success	00:00:05	\N
1250	10	22	2013-01-26 13:46:10.468048	NotAnswer	00:00:00	\N
1251	1	19	2013-01-26 13:59:50.798048	NotAnswer	00:00:00	\N
1252	2	20	2013-01-26 14:00:53.814931	Success	00:00:05	\N
1253	1	19	2013-01-26 14:01:25.818371	NotAnswer	00:00:00	\N
1254	1	19	2013-01-26 14:02:35.837472	NotAnswer	00:00:00	\N
1255	1	19	2013-01-26 14:03:51.97156	NotAnswer	00:00:00	\N
1256	1	19	2013-01-26 14:05:00.87755	NotAnswer	00:00:00	\N
1257	1	19	2013-01-26 14:06:14.015628	Busy	00:00:00	\N
1258	1	19	2013-01-26 14:06:40.899004	NotAnswer	00:00:00	\N
1259	1	19	2013-01-26 14:07:56.217148	Busy	00:00:00	\N
1260	1	19	2013-01-26 14:08:15.920519	Busy	00:00:00	\N
1261	1	19	2013-01-26 14:09:15.281205	NotAnswer	00:00:00	\N
1262	1	19	2013-01-26 14:10:23.942274	Success	00:00:05	\N
1263	10	22	2013-01-26 14:16:16.079292	Busy	00:00:00	\N
1264	10	22	2013-01-26 14:21:21.195758	Busy	00:00:00	\N
1265	1	19	2013-01-26 14:25:31.287403	NotAnswer	00:00:00	\N
1266	10	22	2013-01-26 14:26:26.302273	Busy	00:00:00	\N
1267	1	19	2013-01-26 14:27:02.279806	Busy	00:00:00	\N
1268	1	19	2013-01-26 14:27:31.307118	NotAnswer	00:00:00	\N
1269	1	19	2013-01-26 14:28:39.326157	Success	00:00:05	\N
1270	10	22	2013-01-26 14:31:36.389721	NotAnswer	00:00:00	\N
1271	1	19	2013-01-26 14:44:01.449625	Busy	00:00:00	\N
1272	1	19	2013-01-26 14:44:37.390211	Busy	00:00:00	\N
1273	1	19	2013-01-26 14:45:13.579747	Busy	00:00:00	\N
1274	1	19	2013-01-26 14:45:36.456986	NotAnswer	00:00:00	\N
1275	1	19	2013-01-26 14:47:01.462265	Busy	00:00:00	\N
1276	1	19	2013-01-26 14:47:36.464703	NotAnswer	00:00:00	\N
1277	1	19	2013-01-26 14:49:04.470027	Success	00:00:05	\N
1278	1	19	2013-01-26 14:57:31.497503	Busy	00:00:00	\N
1279	1	19	2013-01-26 14:58:06.499927	NotAnswer	00:00:00	\N
1280	1	19	2013-01-26 14:59:31.505224	Busy	00:00:00	\N
1281	1	19	2013-01-26 15:00:04.507713	Success	00:00:05	\N
1282	2	20	2013-01-26 15:01:36.513998	NotAnswer	00:00:00	\N
1283	10	22	2013-01-26 15:02:01.516408	Busy	00:00:00	\N
1284	2	20	2013-01-26 15:05:51.254732	NotAnswer	00:00:00	\N
1285	10	22	2013-01-26 15:08:06.535661	NotAnswer	00:00:00	\N
1286	2	20	2013-01-26 15:09:34.54094	Success	00:00:05	\N
1287	2	20	2013-01-26 15:09:44.554116	Success	00:00:05	\N
1288	2	20	2013-01-26 15:09:51.567316	Busy	00:00:00	\N
1289	2	20	2013-01-26 15:10:08.87947	Busy	00:00:00	\N
1290	2	20	2013-01-26 15:10:18.892627	Success	00:00:05	\N
1291	2	20	2013-01-26 15:10:30.905799	NotAnswer	00:00:00	\N
1292	1	19	2013-01-26 15:14:19.881436	NotAnswer	00:00:00	\N
1293	2	20	2013-01-26 15:14:32.81428	Busy	00:00:00	\N
1294	1	19	2013-01-26 15:15:49.879705	NotAnswer	00:00:00	\N
1295	2	20	2013-01-26 15:15:51.880568	Busy	00:00:00	\N
1296	1	19	2013-01-26 15:16:36.367127	NotAnswer	00:00:00	\N
1297	2	20	2013-01-26 15:16:44.88662	Busy	00:00:00	\N
1298	1	19	2013-01-26 15:16:46.887372	Busy	00:00:00	\N
1299	1	19	2013-01-26 15:17:19.888037	NotAnswer	00:00:00	\N
1300	2	20	2013-01-26 15:17:44.8903	Busy	00:00:00	\N
1301	1	19	2013-01-26 15:17:51.891367	NotAnswer	00:00:00	\N
1302	1	19	2013-01-26 15:18:19.892777	NotAnswer	00:00:00	\N
1303	2	20	2013-01-26 15:18:44.896391	Busy	00:00:00	\N
1304	1	19	2013-01-26 15:18:54.606125	Success	00:00:05	\N
1305	2	20	2013-01-26 15:20:28.375482	Success	00:00:05	\N
1306	1	19	2013-01-26 15:34:44.943132	Busy	00:00:00	\N
1307	1	19	2013-01-26 15:35:31.712674	Busy	00:00:00	\N
1308	1	19	2013-01-26 15:35:47.948867	Success	00:00:05	\N
1309	10	22	2013-01-26 15:38:17.957075	Success	00:00:05	\N
1310	1	19	2013-01-26 15:51:49.996846	NotAnswer	00:00:00	\N
1311	1	19	2013-01-26 15:52:19.999338	NotAnswer	00:00:00	\N
1312	1	19	2013-01-26 15:52:50.001708	NotAnswer	00:00:00	\N
1313	1	19	2013-01-26 15:53:25.102296	Success	00:00:05	\N
1314	1	19	2013-01-26 16:08:45.049685	Busy	00:00:00	\N
1315	1	19	2013-01-26 16:09:15.05238	Busy	00:00:00	\N
1316	1	19	2013-01-26 16:09:50.054498	NotAnswer	00:00:00	\N
1317	1	19	2013-01-26 16:10:34.609153	NotAnswer	00:00:00	\N
1318	1	19	2013-01-26 16:10:50.059404	NotAnswer	00:00:00	\N
1319	1	19	2013-01-26 16:11:22.477927	Busy	00:00:00	\N
1320	1	19	2013-01-26 16:11:53.957366	Busy	00:00:00	\N
1321	1	19	2013-01-26 16:12:20.066689	NotAnswer	00:00:00	\N
1322	1	19	2013-01-26 16:12:53.025153	Success	00:00:05	\N
1323	2	20	2013-01-26 16:21:18.094574	Success	00:00:05	\N
1324	1	19	2013-01-26 16:28:45.117046	Busy	00:00:00	\N
1325	1	19	2013-01-26 16:29:15.119574	Busy	00:00:00	\N
1326	1	19	2013-01-26 16:29:45.121918	Busy	00:00:00	\N
1332	10	22	2013-01-26 16:44:57.135278	Success	00:00:05	\N
1327	1	19	2013-01-26 16:30:20.124477	NotAnswer	00:00:00	\N
1328	1	19	2013-01-26 16:30:52.761943	NotAnswer	00:00:00	\N
1329	1	19	2013-01-26 16:31:30.67091	NotAnswer	00:00:00	\N
1330	1	19	2013-01-26 16:31:48.131733	Success	00:00:05	\N
1331	10	22	2013-01-26 16:39:15.155268	Busy	00:00:00	\N
1333	1	19	2013-01-26 16:47:20.180334	NotAnswer	00:00:00	\N
1334	1	19	2013-01-26 16:47:48.802638	Busy	00:00:00	\N
1335	1	19	2013-01-26 16:48:20.18507	NotAnswer	00:00:00	\N
1336	1	19	2013-01-26 16:48:50.187545	NotAnswer	00:00:00	\N
1337	1	19	2013-01-26 16:49:33.60617	Busy	00:00:00	\N
1338	1	19	2013-01-26 16:49:59.366584	NotAnswer	00:00:00	\N
1339	1	19	2013-01-26 16:50:15.194786	Busy	00:00:00	\N
1340	1	19	2013-01-26 16:50:45.197254	Busy	00:00:00	\N
1341	1	19	2013-01-26 16:51:20.928688	Busy	00:00:00	\N
1342	1	19	2013-01-26 16:51:55.817281	Busy	00:00:00	\N
1343	1	19	2013-01-26 16:52:25.468729	Busy	00:00:00	\N
1344	1	19	2013-01-26 16:52:50.207057	NotAnswer	00:00:00	\N
1345	1	19	2013-01-26 16:53:15.209391	Busy	00:00:00	\N
1346	1	19	2013-01-26 16:54:04.094104	NotAnswer	00:00:00	\N
1347	1	19	2013-01-26 16:54:24.75145	Success	00:00:05	\N
1348	1	19	2013-01-26 17:10:00.313066	NotAnswer	00:00:00	\N
1349	1	19	2013-01-26 17:10:15.262305	Busy	00:00:00	\N
1350	1	19	2013-01-26 17:10:50.264732	NotAnswer	00:00:00	\N
1351	1	19	2013-01-26 17:11:20.267228	NotAnswer	00:00:00	\N
1352	1	19	2013-01-26 17:11:45.269619	Busy	00:00:00	\N
1353	1	19	2013-01-26 17:12:15.272	Busy	00:00:00	\N
1354	1	19	2013-01-26 17:12:57.694617	Success	00:00:05	\N
1355	2	20	2013-01-26 17:22:28.552906	Busy	00:00:00	\N
1356	2	20	2013-01-26 17:23:45.308002	Busy	00:00:00	\N
1357	2	20	2013-01-26 17:25:15.31328	Busy	00:00:00	\N
1358	2	20	2013-01-26 17:26:50.941667	Busy	00:00:00	\N
1359	1	19	2013-01-26 17:28:24.717467	NotAnswer	00:00:00	\N
1360	2	20	2013-01-26 17:28:31.718176	NotAnswer	00:00:00	\N
1361	1	19	2013-01-26 17:28:45.326389	Busy	00:00:00	\N
1362	1	19	2013-01-26 17:29:15.328799	Busy	00:00:00	\N
1363	1	19	2013-01-26 17:29:45.331299	Busy	00:00:00	\N
1364	1	19	2013-01-26 17:30:20.333743	NotAnswer	00:00:00	\N
1365	1	19	2013-01-26 17:31:08.850542	Busy	00:00:00	\N
1366	1	19	2013-01-26 17:31:15.338546	Busy	00:00:00	\N
1367	2	20	2013-01-26 17:31:50.341523	NotAnswer	00:00:00	\N
1368	1	19	2013-01-26 17:31:52.342098	Busy	00:00:00	\N
1369	1	19	2013-01-26 17:32:21.599499	Busy	00:00:00	\N
1370	1	19	2013-01-26 17:32:50.346025	NotAnswer	00:00:00	\N
1371	1	19	2013-01-26 17:33:15.34836	Busy	00:00:00	\N
1372	1	19	2013-01-26 17:33:48.350777	Success	00:00:05	\N
1373	2	20	2013-01-26 17:35:15.356102	Busy	00:00:00	\N
1374	2	20	2013-01-26 17:36:48.361403	Success	00:00:05	\N
1375	10	22	2013-01-26 17:45:15.387811	Busy	00:00:00	\N
1376	1	19	2013-01-26 17:49:50.400865	NotAnswer	00:00:00	\N
1377	1	19	2013-01-26 17:50:15.40313	Busy	00:00:00	\N
1378	1	19	2013-01-26 17:50:49.407023	Success	00:00:05	\N
1379	10	22	2013-01-26 17:50:51.407737	Busy	00:00:00	\N
1380	10	22	2013-01-26 17:56:20.776466	Success	00:00:05	\N
1381	1	19	2013-01-26 18:06:50.454683	NotAnswer	00:00:00	\N
1382	1	19	2013-01-26 18:07:15.456963	Busy	00:00:00	\N
1383	1	19	2013-01-26 18:07:50.459536	NotAnswer	00:00:00	\N
1384	1	19	2013-01-26 18:08:20.461987	NotAnswer	00:00:00	\N
1385	1	19	2013-01-26 18:08:45.464283	Busy	00:00:00	\N
1386	1	19	2013-01-26 18:09:15.466723	Busy	00:00:00	\N
1387	1	19	2013-01-26 18:09:55.635389	NotAnswer	00:00:00	\N
1388	1	19	2013-01-26 18:10:30.490782	NotAnswer	00:00:00	\N
1389	1	19	2013-01-26 18:10:50.474122	NotAnswer	00:00:00	\N
1390	1	19	2013-01-26 18:11:15.476533	Busy	00:00:00	\N
1391	1	19	2013-01-26 18:11:45.478919	Busy	00:00:00	\N
1392	1	19	2013-01-26 18:12:20.481503	NotAnswer	00:00:00	\N
1393	1	19	2013-01-26 18:12:50.483921	NotAnswer	00:00:00	\N
1394	1	19	2013-01-26 18:13:20.486305	NotAnswer	00:00:00	\N
1395	1	19	2013-01-26 18:13:50.488884	NotAnswer	00:00:00	\N
1396	1	19	2013-01-26 18:14:20.491189	NotAnswer	00:00:00	\N
1397	1	19	2013-01-26 18:14:50.493672	NotAnswer	00:00:00	\N
1398	1	19	2013-01-26 18:15:31.250231	NotAnswer	00:00:00	\N
1399	1	19	2013-01-26 18:15:45.498421	Busy	00:00:00	\N
1400	1	19	2013-01-26 18:16:20.500885	NotAnswer	00:00:00	\N
1401	1	19	2013-01-26 18:16:48.503399	Success	00:00:05	\N
1402	1	19	2013-01-26 18:32:20.548896	NotAnswer	00:00:00	\N
1403	1	19	2013-01-26 18:32:45.551361	Busy	00:00:00	\N
1404	1	19	2013-01-26 18:33:20.553842	NotAnswer	00:00:00	\N
1405	1	19	2013-01-26 18:33:59.132447	NotAnswer	00:00:00	\N
1406	1	19	2013-01-26 18:34:15.558647	Busy	00:00:00	\N
1407	1	19	2013-01-26 18:34:55.051271	Busy	00:00:00	\N
1408	1	19	2013-01-26 18:35:23.682602	Busy	00:00:00	\N
1409	1	19	2013-01-26 18:35:45.565898	Busy	00:00:00	\N
1410	1	19	2013-01-26 18:36:15.568351	Busy	00:00:00	\N
1411	1	19	2013-01-26 18:36:48.570891	Success	00:00:05	\N
1412	2	20	2013-01-26 18:37:19.473339	Busy	00:00:00	\N
1413	2	20	2013-01-26 18:38:56.299698	Busy	00:00:00	\N
1414	2	20	2013-01-26 18:40:15.584814	Busy	00:00:00	\N
1415	2	20	2013-01-26 18:41:45.591177	Busy	00:00:00	\N
1416	2	20	2013-01-26 18:43:32.409749	Success	00:00:05	\N
1417	1	19	2013-01-26 18:52:45.624788	Busy	00:00:00	\N
1418	1	19	2013-01-26 18:53:26.277417	Busy	00:00:00	\N
1419	1	19	2013-01-26 18:53:50.629747	NotAnswer	00:00:00	\N
1420	1	19	2013-01-26 18:54:15.632087	Busy	00:00:00	\N
1421	1	19	2013-01-26 18:54:50.634593	NotAnswer	00:00:00	\N
1422	1	19	2013-01-26 18:55:15.637949	Busy	00:00:00	\N
1423	1	19	2013-01-26 18:55:45.639458	Busy	00:00:00	\N
1424	1	19	2013-01-26 18:56:18.641917	Success	00:00:05	\N
1425	10	22	2013-01-26 18:56:45.644294	Busy	00:00:00	\N
1429	1	19	2013-01-26 19:27:50.737506	NotAnswer	00:00:00	\N
1426	10	22	2013-01-26 19:02:28.956239	NotAnswer	00:00:00	\N
1427	1	19	2013-01-26 19:11:48.689452	Success	00:00:05	\N
1430	1	19	2013-01-26 19:28:20.739914	NotAnswer	00:00:00	\N
1428	1	19	2013-01-26 19:27:15.734978	Busy	00:00:00	\N
1431	1	19	2013-01-26 19:28:45.742391	Busy	00:00:00	\N
1432	1	19	2013-01-26 19:29:25.234897	Busy	00:00:00	\N
1433	1	19	2013-01-26 19:29:45.747143	Busy	00:00:00	\N
1434	1	19	2013-01-26 19:30:20.749679	NotAnswer	00:00:00	\N
1435	1	19	2013-01-26 19:30:55.111196	Success	00:00:05	\N
1436	10	22	2013-01-26 19:33:15.760299	Busy	00:00:00	\N
1437	10	22	2013-01-26 19:38:48.777109	Success	00:00:05	\N
1438	2	20	2013-01-26 19:44:15.793973	Busy	00:00:00	\N
1439	2	20	2013-01-26 19:45:50.799257	NotAnswer	00:00:00	\N
1440	1	19	2013-01-26 19:46:20.80171	NotAnswer	00:00:00	\N
1441	1	19	2013-01-26 19:46:45.804067	Busy	00:00:00	\N
1442	1	19	2013-01-26 19:47:15.806586	Busy	00:00:00	\N
1443	1	19	2013-01-26 19:47:48.809052	Success	00:00:05	\N
1444	2	20	2013-01-26 19:49:20.814333	NotAnswer	00:00:00	\N
1445	2	20	2013-01-26 19:52:49.30443	Busy	00:00:00	\N
1446	2	20	2013-01-26 19:54:22.832752	NotAnswer	00:00:00	\N
1447	2	20	2013-01-26 19:58:00.885012	Busy	00:00:00	\N
1448	2	20	2013-01-26 19:59:20.847098	NotAnswer	00:00:00	\N
1449	2	20	2013-01-26 20:02:48.858128	Success	00:00:05	\N
1450	1	19	2013-01-26 20:03:20.860599	NotAnswer	00:00:00	\N
1451	1	19	2013-01-26 20:03:50.863051	NotAnswer	00:00:00	\N
1452	1	19	2013-01-26 20:04:30.566597	NotAnswer	00:00:00	\N
1453	1	19	2013-01-26 20:04:45.867822	Busy	00:00:00	\N
1454	1	19	2013-01-26 20:05:22.067423	Success	00:00:05	\N
1455	1	19	2013-01-26 20:20:50.915962	NotAnswer	00:00:00	\N
1456	1	19	2013-01-26 20:21:20.918431	NotAnswer	00:00:00	\N
1457	1	19	2013-01-26 20:21:50.920901	NotAnswer	00:00:00	\N
1458	1	19	2013-01-26 20:22:18.923277	Success	00:00:05	\N
1459	1	19	2013-01-26 20:37:50.968836	NotAnswer	00:00:00	\N
1460	1	19	2013-01-26 20:38:18.971356	Success	00:00:05	\N
1461	10	22	2013-01-26 20:39:50.97663	NotAnswer	00:00:00	\N
1462	1	19	2013-01-26 20:54:16.019313	Busy	00:00:00	\N
1463	1	19	2013-01-26 20:54:51.021878	NotAnswer	00:00:00	\N
1464	1	19	2013-01-26 20:55:19.024272	Success	00:00:05	\N
1465	2	20	2013-01-26 21:04:13.502065	Busy	00:00:00	\N
1466	2	20	2013-01-26 21:05:18.093008	Busy	00:00:00	\N
1467	2	20	2013-01-26 21:06:46.061376	Busy	00:00:00	\N
1468	2	20	2013-01-26 21:08:16.066637	Busy	00:00:00	\N
1469	2	20	2013-01-26 21:09:51.072043	NotAnswer	00:00:00	\N
1470	10	22	2013-01-26 21:10:24.510546	Busy	00:00:00	\N
1471	1	19	2013-01-26 21:10:51.076943	NotAnswer	00:00:00	\N
1472	1	19	2013-01-26 21:11:21.079311	NotAnswer	00:00:00	\N
1473	1	19	2013-01-26 21:11:46.081701	Busy	00:00:00	\N
1474	1	19	2013-01-26 21:12:34.827388	NotAnswer	00:00:00	\N
1475	1	19	2013-01-26 21:13:13.291024	Busy	00:00:00	\N
1476	2	20	2013-01-26 21:13:16.088966	Busy	00:00:00	\N
1477	1	19	2013-01-26 21:13:46.091421	Busy	00:00:00	\N
1478	2	20	2013-01-26 21:14:21.094316	NotAnswer	00:00:00	\N
1479	1	19	2013-01-26 21:14:23.095052	Busy	00:00:00	\N
1480	1	19	2013-01-26 21:14:53.594461	Success	00:00:05	\N
1481	10	22	2013-01-26 21:16:21.58379	Busy	00:00:00	\N
1482	2	20	2013-01-26 21:17:51.10707	NotAnswer	00:00:00	\N
1483	2	20	2013-01-26 21:21:19.118164	Success	00:00:05	\N
1484	10	22	2013-01-26 21:21:51.120569	NotAnswer	00:00:00	\N
1485	1	19	2013-01-26 21:30:16.146929	Busy	00:00:00	\N
1486	1	19	2013-01-26 21:30:46.148457	Busy	00:00:00	\N
1487	1	19	2013-01-26 21:31:32.882062	Busy	00:00:00	\N
1488	1	19	2013-01-26 21:32:06.410533	Success	00:00:05	\N
1489	1	19	2013-01-26 21:47:16.198971	Busy	00:00:00	\N
1490	1	19	2013-01-26 21:47:49.201394	Success	00:00:05	\N
1491	10	22	2013-01-26 21:52:16.21636	Busy	00:00:00	\N
1492	10	22	2013-01-26 21:58:02.096427	Success	00:00:05	\N
1493	1	19	2013-01-26 22:03:21.250152	NotAnswer	00:00:00	\N
1494	1	19	2013-01-26 22:03:51.252528	NotAnswer	00:00:00	\N
1495	1	19	2013-01-26 22:04:46.390305	Success	00:00:05	\N
1496	1	19	2013-01-26 22:20:30.689203	NotAnswer	00:00:00	\N
1497	1	19	2013-01-26 22:20:51.306515	NotAnswer	00:00:00	\N
1498	1	19	2013-01-26 22:21:21.309897	NotAnswer	00:00:00	\N
1499	2	20	2013-01-26 22:21:46.312701	Busy	00:00:00	\N
1500	1	19	2013-01-26 22:21:48.313306	Busy	00:00:00	\N
1501	1	19	2013-01-26 22:22:32.447938	Busy	00:00:00	\N
1502	2	20	2013-01-26 22:22:51.317606	NotAnswer	00:00:00	\N
1503	1	19	2013-01-26 22:22:53.318258	Busy	00:00:00	\N
1504	1	19	2013-01-26 22:23:21.319701	NotAnswer	00:00:00	\N
1505	1	19	2013-01-26 22:23:54.51913	NotAnswer	00:00:00	\N
1506	1	19	2013-01-26 22:24:16.324476	Busy	00:00:00	\N
1507	1	19	2013-01-26 22:24:53.2161	Busy	00:00:00	\N
1508	1	19	2013-01-26 22:25:21.329452	NotAnswer	00:00:00	\N
1509	1	19	2013-01-26 22:25:51.331916	NotAnswer	00:00:00	\N
1510	2	20	2013-01-26 22:26:16.334614	Busy	00:00:00	\N
1511	1	19	2013-01-26 22:26:18.335271	Busy	00:00:00	\N
1512	1	19	2013-01-26 22:27:10.071008	NotAnswer	00:00:00	\N
1513	2	20	2013-01-26 22:27:22.466183	Success	00:00:05	\N
1514	1	19	2013-01-26 22:27:46.341534	Busy	00:00:00	\N
1515	1	19	2013-01-26 22:28:21.344037	NotAnswer	00:00:00	\N
1516	1	19	2013-01-26 22:28:51.346541	NotAnswer	00:00:00	\N
1517	1	19	2013-01-26 22:29:41.312234	NotAnswer	00:00:00	\N
1518	1	19	2013-01-26 22:30:46.354243	Busy	00:00:00	\N
1519	1	19	2013-01-26 22:31:21.357711	NotAnswer	00:00:00	\N
1520	1	19	2013-01-26 22:31:51.360216	NotAnswer	00:00:00	\N
1521	1	19	2013-01-26 22:32:21.362595	NotAnswer	00:00:00	\N
1522	1	19	2013-01-26 22:32:51.365011	NotAnswer	00:00:00	\N
1523	1	19	2013-01-26 22:33:21.367471	NotAnswer	00:00:00	\N
1524	1	19	2013-01-26 22:33:51.369947	NotAnswer	00:00:00	\N
1532	1	19	2013-01-26 22:52:46.43265	Busy	00:00:00	\N
1536	10	22	2013-01-26 22:58:26.752626	Busy	00:00:00	\N
1540	1	19	2013-01-26 23:11:21.4963	NotAnswer	00:00:00	\N
1525	1	19	2013-01-26 22:34:16.372386	Busy	00:00:00	\N
1537	10	22	2013-01-26 23:03:51.54636	NotAnswer	00:00:00	\N
1526	1	19	2013-01-26 22:34:54.571879	NotAnswer	00:00:00	\N
1529	1	19	2013-01-26 22:51:21.425388	NotAnswer	00:00:00	\N
1533	1	19	2013-01-26 22:53:49.482497	NotAnswer	00:00:00	\N
1527	1	19	2013-01-26 22:35:26.473309	NotAnswer	00:00:00	\N
1530	1	19	2013-01-26 22:51:46.427742	Busy	00:00:00	\N
1534	1	19	2013-01-26 22:54:21.439986	NotAnswer	00:00:00	\N
1538	1	19	2013-01-26 23:10:25.192482	NotAnswer	00:00:00	\N
1528	1	19	2013-01-26 22:35:49.37964	Success	00:00:05	\N
1531	1	19	2013-01-26 22:52:27.405296	NotAnswer	00:00:00	\N
1535	1	19	2013-01-26 22:54:49.442397	Success	00:00:05	\N
1539	1	19	2013-01-26 23:10:51.49285	NotAnswer	00:00:00	\N
1541	1	19	2013-01-26 23:11:46.498751	Busy	00:00:00	\N
1542	1	19	2013-01-26 23:12:29.480361	NotAnswer	00:00:00	\N
1543	1	19	2013-01-26 23:12:51.503689	NotAnswer	00:00:00	\N
1544	1	19	2013-01-26 23:13:16.506051	Busy	00:00:00	\N
1545	1	19	2013-01-26 23:13:46.508565	Busy	00:00:00	\N
1546	1	19	2013-01-26 23:14:30.122255	NotAnswer	00:00:00	\N
1547	1	19	2013-01-26 23:14:46.513467	Busy	00:00:00	\N
1548	1	19	2013-01-26 23:15:19.515972	Success	00:00:05	\N
1549	2	20	2013-01-26 23:27:51.564081	NotAnswer	00:00:00	\N
1550	2	20	2013-01-26 23:31:20.577507	Success	00:00:05	\N
1551	1	19	2013-01-26 23:31:25.57829	Success	00:00:05	\N
1552	10	22	2013-01-26 23:34:46.58719	Busy	00:00:00	\N
1553	10	22	2013-01-26 23:40:21.604141	NotAnswer	00:00:00	\N
1554	1	19	2013-01-26 23:46:49.623836	Success	00:00:05	\N
1555	1	19	2013-01-27 00:02:16.736434	Busy	00:00:00	\N
1556	1	19	2013-01-27 00:02:46.738857	Busy	00:00:00	\N
1557	1	19	2013-01-27 00:03:16.741334	Busy	00:00:00	\N
1558	1	19	2013-01-27 00:03:51.743807	NotAnswer	00:00:00	\N
1559	1	19	2013-01-27 00:04:21.746232	NotAnswer	00:00:00	\N
1560	1	19	2013-01-27 00:04:59.836792	Success	00:00:05	\N
1561	10	22	2013-01-27 00:11:21.768474	NotAnswer	00:00:00	\N
1562	1	19	2013-01-27 00:20:46.796725	Busy	00:00:00	\N
1563	1	19	2013-01-27 00:21:29.672348	NotAnswer	00:00:00	\N
1564	1	19	2013-01-27 00:21:49.801627	Success	00:00:05	\N
1565	1	19	2013-01-27 00:37:40.47559	NotAnswer	00:00:00	\N
1566	1	19	2013-01-27 00:38:51.853688	NotAnswer	00:00:00	\N
1567	1	19	2013-01-27 00:39:21.856106	NotAnswer	00:00:00	\N
1568	1	19	2013-01-27 00:39:54.880637	NotAnswer	00:00:00	\N
1569	1	19	2013-01-27 00:40:21.957035	Busy	00:00:00	\N
1570	1	19	2013-01-27 00:40:51.876359	NotAnswer	00:00:00	\N
1571	1	19	2013-01-27 00:41:16.866849	Busy	00:00:00	\N
1572	10	22	2013-01-27 00:41:51.868703	NotAnswer	00:00:00	\N
1573	1	19	2013-01-27 00:41:58.86938	NotAnswer	00:00:00	\N
1574	1	19	2013-01-27 00:42:21.870718	NotAnswer	00:00:00	\N
1575	1	19	2013-01-27 00:42:51.873229	NotAnswer	00:00:00	\N
1576	1	19	2013-01-27 00:43:16.875553	Busy	00:00:00	\N
1577	1	19	2013-01-27 00:43:52.889091	Busy	00:00:00	\N
1578	1	19	2013-01-27 00:44:26.980551	Success	00:00:05	\N
1579	1	19	2013-01-27 00:59:50.405264	Busy	00:00:00	\N
1580	1	19	2013-01-27 01:00:21.928691	NotAnswer	00:00:00	\N
1581	1	19	2013-01-27 01:00:49.931025	Success	00:00:05	\N
1582	10	22	2013-01-27 01:12:16.965303	Busy	00:00:00	\N
1583	1	19	2013-01-27 01:16:46.979201	Busy	00:00:00	\N
1584	1	19	2013-01-27 01:17:16.981638	Busy	00:00:00	\N
1585	1	19	2013-01-27 01:17:59.280608	Success	00:00:05	\N
1586	10	22	2013-01-27 01:18:06.28139	NotAnswer	00:00:00	\N
1587	1	19	2013-01-27 01:33:24.549877	Busy	00:00:00	\N
1588	1	19	2013-01-27 01:33:52.032234	NotAnswer	00:00:00	\N
1589	1	19	2013-01-27 01:34:22.034663	NotAnswer	00:00:00	\N
1590	1	19	2013-01-27 01:35:03.557332	Busy	00:00:00	\N
1591	1	19	2013-01-27 01:35:22.039614	NotAnswer	00:00:00	\N
1592	1	19	2013-01-27 01:35:52.042013	NotAnswer	00:00:00	\N
1593	1	19	2013-01-27 01:36:27.519596	Busy	00:00:00	\N
1594	1	19	2013-01-27 01:36:52.071898	Busy	00:00:00	\N
1595	1	19	2013-01-27 01:37:46.58468	Success	00:00:05	\N
1596	10	22	2013-01-27 01:48:29.041209	NotAnswer	00:00:00	\N
1597	1	19	2013-01-27 01:53:55.507973	NotAnswer	00:00:00	\N
1598	1	19	2013-01-27 01:54:17.102348	Busy	00:00:00	\N
1599	1	19	2013-01-27 01:54:54.813863	Success	00:00:05	\N
1600	1	19	2013-01-27 02:10:19.644482	Busy	00:00:00	\N
1601	1	19	2013-01-27 02:10:58.082059	Busy	00:00:00	\N
1602	1	19	2013-01-27 02:11:26.397469	Busy	00:00:00	\N
1603	1	19	2013-01-27 02:11:50.157862	Success	00:00:05	\N
1604	10	22	2013-01-27 02:19:20.180524	Success	00:00:05	\N
1605	1	19	2013-01-27 02:27:50.206024	Success	00:00:05	\N
1606	1	19	2013-01-27 02:43:31.741892	NotAnswer	00:00:00	\N
1607	1	19	2013-01-27 02:43:52.254143	NotAnswer	00:00:00	\N
1608	1	19	2013-01-27 02:44:52.310035	NotAnswer	00:00:00	\N
1609	1	19	2013-01-27 02:45:30.20465	NotAnswer	00:00:00	\N
1610	1	19	2013-01-27 02:45:52.263946	NotAnswer	00:00:00	\N
1611	1	19	2013-01-27 02:46:22.266341	NotAnswer	00:00:00	\N
1612	1	19	2013-01-27 02:46:47.268753	Busy	00:00:00	\N
1613	1	19	2013-01-27 02:47:20.271237	Success	00:00:05	\N
1614	1	19	2013-01-27 03:02:47.316963	Busy	00:00:00	\N
1615	1	19	2013-01-27 03:03:30.438584	NotAnswer	00:00:00	\N
1616	1	19	2013-01-27 03:03:47.321781	Busy	00:00:00	\N
1617	1	19	2013-01-27 03:04:25.232428	Busy	00:00:00	\N
1618	1	19	2013-01-27 03:04:47.326668	Busy	00:00:00	\N
1619	1	19	2013-01-27 03:05:20.329221	Success	00:00:05	\N
1620	10	22	2013-01-27 03:19:47.372045	Busy	00:00:00	\N
1621	1	19	2013-01-27 03:21:33.133627	NotAnswer	00:00:00	\N
1622	1	19	2013-01-27 03:21:47.379779	Busy	00:00:00	\N
1623	1	19	2013-01-27 03:22:17.38226	Busy	00:00:00	\N
1624	1	19	2013-01-27 03:22:52.38504	NotAnswer	00:00:00	\N
1625	1	19	2013-01-27 03:23:22.387315	NotAnswer	00:00:00	\N
1626	1	19	2013-01-27 03:23:52.389725	NotAnswer	00:00:00	\N
1627	1	19	2013-01-27 03:24:20.589104	Busy	00:00:00	\N
1628	1	19	2013-01-27 03:24:51.576594	Busy	00:00:00	\N
1629	10	22	2013-01-27 03:25:22.397389	NotAnswer	00:00:00	\N
1630	1	19	2013-01-27 03:25:29.398107	NotAnswer	00:00:00	\N
1633	1	19	2013-01-27 03:41:47.448589	Busy	00:00:00	\N
1638	1	19	2013-01-27 03:44:20.460825	Success	00:00:05	\N
1641	1	19	2013-01-27 04:00:58.090607	Busy	00:00:00	\N
1645	1	19	2013-01-27 04:17:22.562006	NotAnswer	00:00:00	\N
1650	1	19	2013-01-27 04:19:50.57419	Success	00:00:05	\N
1653	1	19	2013-01-27 04:36:28.493895	NotAnswer	00:00:00	\N
1656	1	19	2013-01-27 04:52:53.861418	Busy	00:00:00	\N
1631	1	19	2013-01-27 03:25:50.399441	Success	00:00:05	\N
1634	1	19	2013-01-27 03:42:22.451171	NotAnswer	00:00:00	\N
1643	1	19	2013-01-27 04:01:27.92696	Success	00:00:05	\N
1646	1	19	2013-01-27 04:17:52.564534	NotAnswer	00:00:00	\N
1654	1	19	2013-01-27 04:36:50.627224	Success	00:00:05	\N
1657	1	19	2013-01-27 04:53:22.677825	NotAnswer	00:00:00	\N
1632	1	19	2013-01-27 03:41:22.446525	NotAnswer	00:00:00	\N
1637	1	19	2013-01-27 03:44:04.399671	Busy	00:00:00	\N
1639	10	22	2013-01-27 03:55:47.495003	Busy	00:00:00	\N
1640	1	19	2013-01-27 04:00:22.509046	NotAnswer	00:00:00	\N
1644	10	22	2013-01-27 04:06:52.530826	NotAnswer	00:00:00	\N
1649	1	19	2013-01-27 04:19:17.571775	Busy	00:00:00	\N
1652	1	19	2013-01-27 04:35:47.622375	Busy	00:00:00	\N
1655	10	22	2013-01-27 04:37:29.412866	NotAnswer	00:00:00	\N
1660	10	22	2013-01-27 05:08:00.068814	NotAnswer	00:00:00	\N
1635	1	19	2013-01-27 03:42:47.453477	Busy	00:00:00	\N
1642	10	22	2013-01-27 04:01:17.514236	Busy	00:00:00	\N
1647	1	19	2013-01-27 04:18:32.549041	NotAnswer	00:00:00	\N
1658	1	19	2013-01-27 04:54:02.205463	NotAnswer	00:00:00	\N
1636	1	19	2013-01-27 03:43:22.455983	NotAnswer	00:00:00	\N
1648	1	19	2013-01-27 04:18:47.569265	Busy	00:00:00	\N
1651	1	19	2013-01-27 04:35:17.619887	Busy	00:00:00	\N
1659	1	19	2013-01-27 04:54:29.961907	Success	00:00:05	\N
1661	1	19	2013-01-27 05:10:22.730866	NotAnswer	00:00:00	\N
1662	1	19	2013-01-27 05:10:50.733356	Success	00:00:05	\N
1663	1	19	2013-01-27 05:26:22.780021	NotAnswer	00:00:00	\N
1664	1	19	2013-01-27 05:26:47.781507	Busy	00:00:00	\N
1665	1	19	2013-01-27 05:27:22.783912	NotAnswer	00:00:00	\N
1666	1	19	2013-01-27 05:27:54.651434	Success	00:00:05	\N
1667	10	22	2013-01-27 05:38:23.651671	Busy	00:00:00	\N
1668	1	19	2013-01-27 05:43:47.834886	Busy	00:00:00	\N
1669	10	22	2013-01-27 05:43:56.232552	Busy	00:00:00	\N
1670	1	19	2013-01-27 05:44:22.83702	NotAnswer	00:00:00	\N
1671	1	19	2013-01-27 05:44:50.839343	Success	00:00:05	\N
1672	10	22	2013-01-27 05:49:47.105693	NotAnswer	00:00:00	\N
1673	1	19	2013-01-27 06:00:31.217203	NotAnswer	00:00:00	\N
1674	1	19	2013-01-27 06:00:52.889524	NotAnswer	00:00:00	\N
1675	1	19	2013-01-27 06:01:17.892962	Busy	00:00:00	\N
1676	1	19	2013-01-27 06:01:57.673527	NotAnswer	00:00:00	\N
1677	1	19	2013-01-27 06:02:30.032038	NotAnswer	00:00:00	\N
1678	1	19	2013-01-27 06:02:52.899252	NotAnswer	00:00:00	\N
1679	1	19	2013-01-27 06:03:22.901728	NotAnswer	00:00:00	\N
1680	1	19	2013-01-27 06:03:47.904112	Busy	00:00:00	\N
1681	1	19	2013-01-27 06:04:27.289749	Busy	00:00:00	\N
1682	1	19	2013-01-27 06:04:52.909089	NotAnswer	00:00:00	\N
1683	1	19	2013-01-27 06:05:20.911419	Success	00:00:05	\N
1684	10	22	2013-01-27 06:20:52.957605	NotAnswer	00:00:00	\N
1685	1	19	2013-01-27 06:20:59.958373	NotAnswer	00:00:00	\N
1686	1	19	2013-01-27 06:21:22.959734	NotAnswer	00:00:00	\N
1687	1	19	2013-01-27 06:21:54.640164	Busy	00:00:00	\N
1688	1	19	2013-01-27 06:22:17.964485	Busy	00:00:00	\N
1689	1	19	2013-01-27 06:22:52.966954	NotAnswer	00:00:00	\N
1690	1	19	2013-01-27 06:23:22.969493	NotAnswer	00:00:00	\N
1691	1	19	2013-01-27 06:23:52.971868	NotAnswer	00:00:00	\N
1692	1	19	2013-01-27 06:24:22.974344	NotAnswer	00:00:00	\N
1693	1	19	2013-01-27 06:24:47.976733	Busy	00:00:00	\N
1694	1	19	2013-01-27 06:25:17.979145	Busy	00:00:00	\N
1695	1	19	2013-01-27 06:25:52.981676	NotAnswer	00:00:00	\N
1696	1	19	2013-01-27 06:26:22.984106	NotAnswer	00:00:00	\N
1697	1	19	2013-01-27 06:27:01.562684	NotAnswer	00:00:00	\N
1698	1	19	2013-01-27 06:27:28.300104	Success	00:00:05	\N
1699	1	19	2013-01-27 06:42:48.034719	Busy	00:00:00	\N
1700	1	19	2013-01-27 06:43:23.037177	NotAnswer	00:00:00	\N
1701	1	19	2013-01-27 06:43:53.039647	NotAnswer	00:00:00	\N
1702	1	19	2013-01-27 06:44:18.042062	Busy	00:00:00	\N
1703	1	19	2013-01-27 06:44:48.044459	Busy	00:00:00	\N
1704	1	19	2013-01-27 06:45:21.0469	Success	00:00:05	\N
1705	10	22	2013-01-27 06:51:53.066671	NotAnswer	00:00:00	\N
1706	1	19	2013-01-27 07:01:21.095052	Success	00:00:05	\N
1707	1	19	2013-01-27 07:16:48.141797	Busy	00:00:00	\N
1708	1	19	2013-01-27 07:17:23.144303	NotAnswer	00:00:00	\N
1709	1	19	2013-01-27 07:17:59.181861	Busy	00:00:00	\N
1710	1	19	2013-01-27 07:18:23.149118	NotAnswer	00:00:00	\N
1711	1	19	2013-01-27 07:18:54.829666	Busy	00:00:00	\N
1712	1	19	2013-01-27 07:19:18.153904	Busy	00:00:00	\N
1713	1	19	2013-01-27 07:19:51.15642	Success	00:00:05	\N
1714	10	22	2013-01-27 07:22:18.164689	Busy	00:00:00	\N
1715	10	22	2013-01-27 07:28:03.093694	NotAnswer	00:00:00	\N
1716	1	19	2013-01-27 07:35:23.204257	NotAnswer	00:00:00	\N
1717	1	19	2013-01-27 07:35:51.206652	Success	00:00:05	\N
1718	1	19	2013-01-27 07:51:23.252401	NotAnswer	00:00:00	\N
1719	1	19	2013-01-27 07:52:01.233965	NotAnswer	00:00:00	\N
1720	1	19	2013-01-27 07:52:18.257269	Busy	00:00:00	\N
1721	1	19	2013-01-27 07:52:53.25976	NotAnswer	00:00:00	\N
1722	1	19	2013-01-27 07:53:47.294495	Busy	00:00:00	\N
1723	1	19	2013-01-27 07:54:18.267023	Busy	00:00:00	\N
1724	1	19	2013-01-27 07:55:16.597852	Busy	00:00:00	\N
1725	1	19	2013-01-27 07:55:48.2743	Busy	00:00:00	\N
1726	1	19	2013-01-27 07:56:18.276687	Busy	00:00:00	\N
1727	1	19	2013-01-27 07:57:03.508475	NotAnswer	00:00:00	\N
1728	1	19	2013-01-27 07:57:21.281699	Success	00:00:05	\N
1729	10	22	2013-01-27 07:58:48.286921	Busy	00:00:00	\N
1730	10	22	2013-01-27 08:04:23.304876	NotAnswer	00:00:00	\N
1731	1	19	2013-01-27 08:12:48.330416	Busy	00:00:00	\N
1732	1	19	2013-01-27 08:13:23.333924	NotAnswer	00:00:00	\N
1733	1	19	2013-01-27 08:13:51.33525	Success	00:00:05	\N
1734	1	19	2013-01-27 08:29:18.381026	Busy	00:00:00	\N
1735	1	19	2013-01-27 08:30:05.958652	Busy	00:00:00	\N
1736	1	19	2013-01-27 08:30:27.110983	NotAnswer	00:00:00	\N
1737	1	19	2013-01-27 08:30:53.624394	Busy	00:00:00	\N
1738	1	19	2013-01-27 08:31:23.391814	NotAnswer	00:00:00	\N
1739	1	19	2013-01-27 08:31:48.394278	Busy	00:00:00	\N
1740	1	19	2013-01-27 08:32:30.63679	NotAnswer	00:00:00	\N
1741	1	19	2013-01-27 08:32:48.399053	Busy	00:00:00	\N
1742	1	19	2013-01-27 08:33:18.40147	Busy	00:00:00	\N
1743	1	19	2013-01-27 08:34:01.840143	NotAnswer	00:00:00	\N
1744	1	19	2013-01-27 08:34:26.455591	Busy	00:00:00	\N
1745	10	22	2013-01-27 08:35:02.513456	NotAnswer	00:00:00	\N
1746	1	19	2013-01-27 08:35:04.514084	Busy	00:00:00	\N
1747	1	19	2013-01-27 08:35:18.411261	Busy	00:00:00	\N
1748	1	19	2013-01-27 08:35:48.413797	Busy	00:00:00	\N
1749	1	19	2013-01-27 08:36:18.41616	Busy	00:00:00	\N
1750	1	19	2013-01-27 08:37:10.850982	NotAnswer	00:00:00	\N
1755	1	19	2013-01-27 08:39:23.430983	NotAnswer	00:00:00	\N
1760	1	19	2013-01-27 08:41:53.443128	NotAnswer	00:00:00	\N
1765	1	19	2013-01-27 08:44:23.455396	NotAnswer	00:00:00	\N
1771	1	19	2013-01-27 09:02:18.513305	Busy	00:00:00	\N
1781	1	19	2013-01-27 09:36:48.622849	Busy	00:00:00	\N
1786	1	19	2013-01-27 09:39:23.63514	NotAnswer	00:00:00	\N
1751	1	19	2013-01-27 08:37:18.421051	Busy	00:00:00	\N
1756	1	19	2013-01-27 08:39:59.654449	NotAnswer	00:00:00	\N
1761	1	19	2013-01-27 08:42:23.445557	NotAnswer	00:00:00	\N
1766	1	19	2013-01-27 08:44:53.457777	NotAnswer	00:00:00	\N
1770	2	20	2013-01-27 09:00:51.507925	Success	00:00:05	\N
1772	1	19	2013-01-27 09:02:56.607808	NotAnswer	00:00:00	\N
1778	1	19	2013-01-27 09:36:01.667198	NotAnswer	00:00:00	\N
1782	1	19	2013-01-27 09:37:23.625334	NotAnswer	00:00:00	\N
1787	1	19	2013-01-27 09:39:48.637432	Busy	00:00:00	\N
1790	1	19	2013-01-27 09:56:18.688133	Busy	00:00:00	\N
1752	1	19	2013-01-27 08:37:48.423541	Busy	00:00:00	\N
1757	1	19	2013-01-27 08:40:26.246852	NotAnswer	00:00:00	\N
1762	1	19	2013-01-27 08:42:53.448011	NotAnswer	00:00:00	\N
1767	1	19	2013-01-27 08:45:22.536244	Busy	00:00:00	\N
1773	1	19	2013-01-27 09:03:18.518094	Busy	00:00:00	\N
1783	1	19	2013-01-27 09:37:53.627827	NotAnswer	00:00:00	\N
1788	1	19	2013-01-27 09:40:23.640004	NotAnswer	00:00:00	\N
1791	1	19	2013-01-27 09:57:00.965715	NotAnswer	00:00:00	\N
1753	1	19	2013-01-27 08:38:18.425964	Busy	00:00:00	\N
1758	1	19	2013-01-27 08:40:48.438206	Busy	00:00:00	\N
1763	1	19	2013-01-27 08:43:18.450384	Busy	00:00:00	\N
1768	1	19	2013-01-27 08:45:48.462694	Busy	00:00:00	\N
1774	1	19	2013-01-27 09:03:56.120804	NotAnswer	00:00:00	\N
1776	10	22	2013-01-27 09:05:53.528449	NotAnswer	00:00:00	\N
1777	1	19	2013-01-27 09:20:21.572224	Success	00:00:05	\N
1779	10	22	2013-01-27 09:36:21.620759	Success	00:00:05	\N
1784	1	19	2013-01-27 09:38:18.630234	Busy	00:00:00	\N
1789	1	19	2013-01-27 09:40:51.642444	Success	00:00:05	\N
1792	1	19	2013-01-27 09:57:23.69311	NotAnswer	00:00:00	\N
1754	1	19	2013-01-27 08:38:48.428384	Busy	00:00:00	\N
1759	1	19	2013-01-27 08:41:23.440759	NotAnswer	00:00:00	\N
1764	1	19	2013-01-27 08:43:48.452878	Busy	00:00:00	\N
1769	1	19	2013-01-27 08:46:25.084177	Success	00:00:05	\N
1775	1	19	2013-01-27 09:04:21.523074	Success	00:00:05	\N
1780	1	19	2013-01-27 09:36:28.621547	NotAnswer	00:00:00	\N
1785	1	19	2013-01-27 09:38:54.3257	Busy	00:00:00	\N
1793	1	19	2013-01-27 09:57:48.695445	Busy	00:00:00	\N
1794	1	19	2013-01-27 09:58:23.697944	NotAnswer	00:00:00	\N
1795	1	19	2013-01-27 09:58:48.70035	Busy	00:00:00	\N
1796	1	19	2013-01-27 09:59:22.884879	Busy	00:00:00	\N
1797	1	19	2013-01-27 09:59:48.705253	Busy	00:00:00	\N
1798	1	19	2013-01-27 10:00:55.025242	NotAnswer	00:00:00	\N
1799	2	20	2013-01-27 10:01:21.712979	Success	00:00:05	\N
1800	1	19	2013-01-27 10:01:28.71375	NotAnswer	00:00:00	\N
1801	1	19	2013-01-27 10:02:04.365197	NotAnswer	00:00:00	\N
1802	1	19	2013-01-27 10:02:18.717454	Busy	00:00:00	\N
1803	1	19	2013-01-27 10:02:57.062007	Success	00:00:05	\N
1804	1	19	2013-01-27 10:18:35.249874	Busy	00:00:00	\N
1805	1	19	2013-01-27 10:18:53.768164	NotAnswer	00:00:00	\N
1806	1	19	2013-01-27 10:19:44.226925	NotAnswer	00:00:00	\N
1807	1	19	2013-01-27 10:20:48.775857	Busy	00:00:00	\N
1808	1	19	2013-01-27 10:21:18.778308	Busy	00:00:00	\N
1809	1	19	2013-01-27 10:21:51.780819	Success	00:00:05	\N
1810	10	22	2013-01-27 10:37:21.826892	Success	00:00:05	\N
1811	1	19	2013-01-27 10:37:31.384703	Busy	00:00:00	\N
1812	1	19	2013-01-27 10:37:48.828956	Busy	00:00:00	\N
1813	1	19	2013-01-27 10:38:31.634637	NotAnswer	00:00:00	\N
1814	1	19	2013-01-27 10:38:53.833841	NotAnswer	00:00:00	\N
1815	1	19	2013-01-27 10:39:28.959411	Busy	00:00:00	\N
1816	1	19	2013-01-27 10:40:03.635978	Busy	00:00:00	\N
1817	1	19	2013-01-27 10:40:18.841192	Busy	00:00:00	\N
1818	1	19	2013-01-27 10:40:56.197674	NotAnswer	00:00:00	\N
1819	1	19	2013-01-27 10:41:23.846081	NotAnswer	00:00:00	\N
1820	1	19	2013-01-27 10:41:53.849605	NotAnswer	00:00:00	\N
1821	1	19	2013-01-27 10:42:34.220127	NotAnswer	00:00:00	\N
1822	1	19	2013-01-27 10:42:53.85353	NotAnswer	00:00:00	\N
1823	1	19	2013-01-27 10:43:25.193942	Success	00:00:05	\N
1824	1	19	2013-01-27 10:58:53.901639	NotAnswer	00:00:00	\N
1825	1	19	2013-01-27 10:59:32.51533	NotAnswer	00:00:00	\N
1826	1	19	2013-01-27 11:00:01.885733	NotAnswer	00:00:00	\N
1827	1	19	2013-01-27 11:00:18.908901	Busy	00:00:00	\N
1828	1	19	2013-01-27 11:00:48.912409	Busy	00:00:00	\N
1829	1	19	2013-01-27 11:01:23.913902	NotAnswer	00:00:00	\N
1830	2	20	2013-01-27 11:01:48.916659	Busy	00:00:00	\N
1831	1	19	2013-01-27 11:01:50.917344	Busy	00:00:00	\N
1832	1	19	2013-01-27 11:02:18.918664	Busy	00:00:00	\N
1833	2	20	2013-01-27 11:02:53.921555	NotAnswer	00:00:00	\N
1834	1	19	2013-01-27 11:03:07.063444	Busy	00:00:00	\N
1835	1	19	2013-01-27 11:03:23.923647	NotAnswer	00:00:00	\N
1836	1	19	2013-01-27 11:03:48.926025	Busy	00:00:00	\N
1837	1	19	2013-01-27 11:04:18.928456	Busy	00:00:00	\N
1838	1	19	2013-01-27 11:04:53.931024	NotAnswer	00:00:00	\N
1839	1	19	2013-01-27 11:05:18.93333	Busy	00:00:00	\N
1840	1	19	2013-01-27 11:05:51.935821	Success	00:00:05	\N
1841	2	20	2013-01-27 11:06:21.186278	Busy	00:00:00	\N
1842	2	20	2013-01-27 11:07:53.943647	NotAnswer	00:00:00	\N
1843	2	20	2013-01-27 11:11:35.943919	Success	00:00:05	\N
1844	1	19	2013-01-27 11:21:48.986396	Busy	00:00:00	\N
1845	1	19	2013-01-27 11:22:23.988509	NotAnswer	00:00:00	\N
1846	1	19	2013-01-27 11:22:51.990939	Success	00:00:05	\N
1847	10	22	2013-01-27 11:38:19.036973	Busy	00:00:00	\N
1848	1	19	2013-01-27 11:38:21.037747	Busy	00:00:00	\N
1849	1	19	2013-01-27 11:38:54.039174	NotAnswer	00:00:00	\N
1850	1	19	2013-01-27 11:39:24.041612	NotAnswer	00:00:00	\N
1851	1	19	2013-01-27 11:40:11.362305	Busy	00:00:00	\N
1852	1	19	2013-01-27 11:40:24.046544	NotAnswer	00:00:00	\N
1853	1	19	2013-01-27 11:40:49.048904	Busy	00:00:00	\N
1854	1	19	2013-01-27 11:41:34.73754	NotAnswer	00:00:00	\N
1855	1	19	2013-01-27 11:41:52.053856	Success	00:00:05	\N
1856	10	22	2013-01-27 11:44:24.062115	NotAnswer	00:00:00	\N
1857	1	19	2013-01-27 11:57:52.102034	Success	00:00:05	\N
1858	2	20	2013-01-27 12:12:33.318974	NotAnswer	00:00:00	\N
1859	1	19	2013-01-27 12:13:52.150132	Success	00:00:05	\N
1860	10	22	2013-01-27 12:15:24.155548	NotAnswer	00:00:00	\N
1861	2	20	2013-01-27 12:15:54.157952	NotAnswer	00:00:00	\N
1862	2	20	2013-01-27 12:19:24.169046	NotAnswer	00:00:00	\N
1863	2	20	2013-01-27 12:23:01.209301	NotAnswer	00:00:00	\N
1864	2	20	2013-01-27 12:26:29.256269	Success	00:00:05	\N
1865	1	19	2013-01-27 12:30:04.428583	NotAnswer	00:00:00	\N
1866	1	19	2013-01-27 12:30:24.204829	NotAnswer	00:00:00	\N
1867	1	19	2013-01-27 12:30:52.207192	Success	00:00:05	\N
1868	10	22	2013-01-27 12:46:24.253315	NotAnswer	00:00:00	\N
1869	1	19	2013-01-27 12:46:31.254048	NotAnswer	00:00:00	\N
1870	1	19	2013-01-27 12:47:04.6506	Busy	00:00:00	\N
1871	1	19	2013-01-27 12:47:24.257803	NotAnswer	00:00:00	\N
1872	1	19	2013-01-27 12:47:54.260321	NotAnswer	00:00:00	\N
1873	1	19	2013-01-27 12:48:32.069915	Success	00:00:05	\N
1874	1	19	2013-01-27 13:03:54.308387	NotAnswer	00:00:00	\N
1875	1	19	2013-01-27 13:04:47.149249	Busy	00:00:00	\N
1876	1	19	2013-01-27 13:05:58.209263	Busy	00:00:00	\N
1877	1	19	2013-01-27 13:06:22.318648	Success	00:00:05	\N
1878	10	22	2013-01-27 13:17:01.872161	NotAnswer	00:00:00	\N
1879	1	19	2013-01-27 13:22:24.36681	NotAnswer	00:00:00	\N
1885	1	19	2013-01-27 13:40:22.424676	Success	00:00:05	\N
1886	10	22	2013-01-27 13:48:06.994542	NotAnswer	00:00:00	\N
1888	1	19	2013-01-27 13:56:54.475274	NotAnswer	00:00:00	\N
1896	1	19	2013-01-27 14:15:54.53812	NotAnswer	00:00:00	\N
1904	1	19	2013-01-27 14:32:58.52327	Busy	00:00:00	\N
1909	1	19	2013-01-27 14:35:22.607308	Success	00:00:05	\N
1913	1	19	2013-01-27 15:07:19.70355	Busy	00:00:00	\N
1928	2	20	2013-01-27 15:48:59.408266	NotAnswer	00:00:00	\N
1930	2	20	2013-01-27 15:52:54.853751	NotAnswer	00:00:00	\N
1933	1	19	2013-01-27 16:12:24.915021	NotAnswer	00:00:00	\N
1880	1	19	2013-01-27 13:22:49.36925	Busy	00:00:00	\N
1889	1	19	2013-01-27 13:57:27.007845	NotAnswer	00:00:00	\N
1892	1	19	2013-01-27 14:13:56.065393	Busy	00:00:00	\N
1897	1	19	2013-01-27 14:16:33.151655	NotAnswer	00:00:00	\N
1901	2	20	2013-01-27 14:27:19.5762	Busy	00:00:00	\N
1905	1	19	2013-01-27 14:33:19.597451	Busy	00:00:00	\N
1911	1	19	2013-01-27 14:51:44.516788	Success	00:00:05	\N
1914	1	19	2013-01-27 15:07:49.705986	Busy	00:00:00	\N
1922	2	20	2013-01-27 15:40:15.367557	NotAnswer	00:00:00	\N
1934	1	19	2013-01-27 16:12:49.91729	Busy	00:00:00	\N
1937	1	19	2013-01-27 16:29:36.040069	NotAnswer	00:00:00	\N
1881	1	19	2013-01-27 13:23:24.371757	NotAnswer	00:00:00	\N
1890	1	19	2013-01-27 13:57:49.480138	Busy	00:00:00	\N
1893	1	19	2013-01-27 14:14:19.530674	Busy	00:00:00	\N
1898	1	19	2013-01-27 14:16:54.427989	Busy	00:00:00	\N
1900	10	22	2013-01-27 14:18:54.550737	NotAnswer	00:00:00	\N
1903	2	20	2013-01-27 14:32:33.489875	Success	00:00:05	\N
1906	1	19	2013-01-27 14:33:54.599963	NotAnswer	00:00:00	\N
1910	10	22	2013-01-27 14:49:52.650047	Success	00:00:05	\N
1915	1	19	2013-01-27 15:08:24.708471	NotAnswer	00:00:00	\N
1918	1	19	2013-01-27 15:25:03.445194	Success	00:00:05	\N
1920	2	20	2013-01-27 15:36:57.669676	Busy	00:00:00	\N
1923	1	19	2013-01-27 15:40:19.809674	Busy	00:00:00	\N
1929	10	22	2013-01-27 15:50:24.845566	NotAnswer	00:00:00	\N
1932	1	19	2013-01-27 15:56:52.867193	Success	00:00:05	\N
1935	1	19	2013-01-27 16:13:29.386876	Success	00:00:05	\N
1936	10	22	2013-01-27 16:20:54.942423	NotAnswer	00:00:00	\N
1938	1	19	2013-01-27 16:29:57.536384	NotAnswer	00:00:00	\N
1882	1	19	2013-01-27 13:23:49.374042	Busy	00:00:00	\N
1891	1	19	2013-01-27 13:58:22.482581	Success	00:00:05	\N
1894	1	19	2013-01-27 14:14:49.533051	Busy	00:00:00	\N
1899	1	19	2013-01-27 14:17:27.992524	Success	00:00:05	\N
1902	2	20	2013-01-27 14:28:54.581632	NotAnswer	00:00:00	\N
1907	1	19	2013-01-27 14:34:37.781618	NotAnswer	00:00:00	\N
1916	1	19	2013-01-27 15:08:49.71088	Busy	00:00:00	\N
1919	2	20	2013-01-27 15:33:33.748734	NotAnswer	00:00:00	\N
1924	1	19	2013-01-27 15:40:49.812125	Busy	00:00:00	\N
1927	2	20	2013-01-27 15:47:19.834862	Busy	00:00:00	\N
1883	1	19	2013-01-27 13:24:34.888773	Success	00:00:05	\N
1884	2	20	2013-01-27 13:26:52.384783	Success	00:00:05	\N
1887	1	19	2013-01-27 13:56:24.472877	NotAnswer	00:00:00	\N
1895	1	19	2013-01-27 14:15:44.311939	Busy	00:00:00	\N
1908	1	19	2013-01-27 14:34:49.604859	Busy	00:00:00	\N
1912	1	19	2013-01-27 15:07:03.514276	Busy	00:00:00	\N
1917	1	19	2013-01-27 15:09:22.713318	Success	00:00:05	\N
1921	2	20	2013-01-27 15:38:23.033956	Busy	00:00:00	\N
1925	1	19	2013-01-27 15:41:22.815547	Success	00:00:05	\N
1926	2	20	2013-01-27 15:43:54.82376	NotAnswer	00:00:00	\N
1931	2	20	2013-01-27 15:56:22.864766	Success	00:00:05	\N
1939	1	19	2013-01-27 16:30:26.123833	Busy	00:00:00	\N
1940	1	19	2013-01-27 16:30:54.97629	NotAnswer	00:00:00	\N
1941	1	19	2013-01-27 16:31:36.050787	NotAnswer	00:00:00	\N
1942	1	19	2013-01-27 16:31:49.982055	Busy	00:00:00	\N
1943	1	19	2013-01-27 16:32:32.119653	NotAnswer	00:00:00	\N
1944	1	19	2013-01-27 16:32:59.489122	Success	00:00:05	\N
1945	2	20	2013-01-27 19:20:50.968875	Success	00:00:05	\N
1946	2	20	2013-01-27 19:44:00.289569	Success	00:00:05	\N
1947	2	20	2013-01-27 19:46:10.620722	Success	00:00:05	\N
1948	2	20	2013-01-27 19:57:22.521591	Success	00:00:06	\N
1949	2	20	2013-01-27 19:59:11.968953	Success	00:00:10	\N
1950	2	20	2013-01-27 20:23:31.701537	Success	00:00:08	8
1951	2	20	2013-01-27 20:27:49.905891	Success	00:00:04	d
1952	2	20	2013-01-27 20:28:44.071187	Success	00:00:21	d
1953	2	20	2013-01-27 20:30:23.160741	Success	00:00:21	d
1954	2	20	2013-01-27 20:32:52.03167	NotAnswer	\N	\N
1955	2	20	2013-01-27 20:36:22.052084	NotAnswer	\N	\N
1956	2	20	2013-01-27 20:39:47.521341	Busy	\N	\N
1957	2	20	2013-01-27 20:51:12.142134	NotAnswer	\N	\N
1958	2	20	2013-01-27 20:54:42.234595	NotAnswer	\N	\N
1959	2	20	2013-01-27 20:58:13.091345	Success	00:00:05	d
1960	2	20	2013-01-27 21:58:43.039088	NotAnswer	\N	\N
1961	2	20	2013-01-28 00:00:25.13396	Success	00:00:07	8
1962	2	20	2013-01-28 00:06:34.895167	NotAnswer	\N	\N
1963	2	20	2013-01-28 01:01:36.118348	Success	00:00:07	6
1964	2	20	2013-01-28 02:01:59.548079	NotAnswer	\N	\N
1965	2	20	2013-01-28 03:02:32.311464	Success	00:00:04	d
1966	2	20	2013-01-28 04:02:57.270804	Busy	\N	\N
1967	2	20	2013-01-28 05:03:24.819961	Success	00:00:04	5
1968	2	20	2013-01-28 06:03:55.697362	Success	00:00:04	5
1969	2	20	2013-01-28 07:04:25.603144	Success	00:00:04	0
1970	2	20	2013-01-28 08:04:54.219386	NotAnswer	\N	\N
1971	2	20	2013-01-28 09:05:25.008572	NotAnswer	\N	\N
1972	2	20	2013-01-28 09:25:01.793547	Success	00:00:06	1
1973	2	20	2013-01-28 09:29:21.215978	Busy	\N	\N
1974	2	20	2013-01-28 09:30:21.034635	Busy	\N	\N
1975	2	20	2013-01-28 09:31:31.908328	Success	00:00:05	1
1976	2	20	2013-01-28 09:33:10.696621	Success	00:00:03	1
1977	2	20	2013-01-28 09:35:21.760148	Success	00:00:04	1
1978	2	20	2013-01-28 09:37:13.363581	Busy	\N	\N
1979	2	20	2013-01-28 09:39:48.134999	NotAnswer	\N	\N
1980	2	20	2013-01-28 09:42:28.208445	NotAnswer	\N	\N
1981	2	23	2013-01-28 09:44:30.394339	Busy	\N	\N
1982	2	23	2013-01-28 09:48:39.676943	Success	00:00:05	1
1983	2	23	2013-01-28 09:52:37.605406	Success	00:00:04	1
1984	2	20	2013-01-28 10:38:14.097691	Success	00:00:15	d
1985	2	23	2013-01-28 10:40:49.016952	Success	00:00:03	1
1986	2	23	2013-01-28 10:59:58.586701	Success	00:00:03	d
1987	2	23	2013-01-28 11:01:38.144236	Success	00:00:02	x
1988	2	23	2013-01-28 11:06:49.283815	Success	00:00:02	x
1989	2	23	2013-01-28 11:10:38.524827	Success	00:00:02	x
1990	2	23	2013-01-28 11:13:54.982803	Success	00:00:02	x
1991	2	23	2013-01-28 11:15:29.950079	Success	00:00:03	x
1992	2	23	2013-01-28 11:16:05.953144	Success	00:00:09	1
1993	2	23	2013-01-28 11:30:46.690991	Success	00:00:09	1
1994	2	23	2013-01-28 11:32:57.80207	Success	00:00:10	3
1995	1	19	2013-01-28 11:40:28.711972	Success	00:00:07	x
1996	2	20	2013-01-28 12:06:27.434399	NotAnswer	\N	\N
1997	2	23	2013-01-28 12:07:04.663405	Success	00:00:16	<unknown>
1998	2	23	2013-01-28 12:09:49.909251	Success	00:00:10	5
1999	2	23	2013-01-28 12:27:49.699839	Success	00:00:10	2
2000	2	23	2013-01-28 12:36:38.065137	Success	00:00:09	1
2001	2	23	2013-01-28 12:37:53.60874	Success	00:00:09	9
2002	2	23	2013-01-28 12:38:48.382379	Success	00:00:07	d
2003	1	19	2013-01-28 12:41:02.256928	Success	00:00:06	x
2004	2	23	2013-01-28 12:53:41.919015	Success	00:00:08	d
2005	2	23	2013-01-28 12:56:05.661421	Success	00:00:02	x
2006	2	23	2013-01-28 12:58:03.82558	Success	00:00:10	6
2007	2	23	2013-01-28 13:01:12.781523	Success	00:00:09	6
2008	2	23	2013-01-28 13:02:52.102487	Success	00:00:09	6
2009	2	23	2013-01-28 13:03:24.30812	Success	00:00:09	4
2010	2	23	2013-01-28 13:03:48.618851	Success	00:00:17	d
2011	2	23	2013-01-28 13:04:23.335901	Success	00:00:17	d
2012	2	23	2013-01-28 13:04:49.287247	Success	00:00:09	6
2013	2	23	2013-01-28 13:04:56.392525	Success	00:00:00	\N
2014	2	23	2013-01-28 13:05:03.153075	Success	00:00:00	\N
2015	2	23	2013-01-28 13:05:20.264196	Success	00:00:11	5
2016	2	23	2013-01-28 13:05:45.155984	Success	00:00:09	4
2017	2	23	2013-01-28 13:06:59.406281	Success	00:00:08	1
2018	2	23	2013-01-28 13:10:05.623983	Success	00:00:09	1
2019	2	23	2013-01-28 13:11:13.265447	Success	00:00:09	1
2020	2	23	2013-01-28 13:11:58.72999	Success	00:00:09	1
2021	2	23	2013-01-28 13:14:49.820731	Success	00:00:09	4
2022	2	23	2013-01-28 13:58:52.543147	Success	00:00:10	7
2023	1	19	2013-01-28 14:01:55.456627	Success	00:00:13	1
2029	12	26	2013-01-28 14:53:23.470994	Busy	\N	\N
2024	2	23	2013-01-28 14:04:21.205385	Success	00:00:10	4
2025	11	24	2013-01-28 14:23:16.503254	Success	00:00:21	1
2028	12	26	2013-01-28 14:51:49.243364	Success	00:00:05	x
2026	12	26	2013-01-28 14:41:44.017198	Success	00:00:19	1
2027	12	26	2013-01-28 14:46:24.88305	Busy	\N	\N
2030	12	26	2013-01-28 14:54:43.754438	Busy	\N	\N
2031	12	26	2013-01-28 14:56:09.800118	Busy	\N	\N
850	1	19	2012-12-25 14:21:42.275158	Busy	\N	\N
851	1	19	2012-12-25 14:22:09.974447	Busy	\N	\N
852	1	19	2012-12-25 14:22:41.987053	Busy	\N	\N
853	1	19	2012-12-25 14:23:12.419762	Busy	\N	\N
854	1	19	2012-12-25 14:24:36.517652	Success	00:00:00	\N
855	2	20	2012-12-25 14:29:02.156344	Busy	\N	\N
856	2	20	2012-12-25 14:30:06.694417	NotAnswer	\N	\N
857	2	20	2012-12-25 14:31:07.410684	Busy	\N	\N
858	1	19	2012-12-25 14:33:13.518501	Success	00:00:07	\N
859	2	20	2012-12-25 14:36:25.900446	Busy	\N	\N
860	2	20	2012-12-25 14:37:16.046845	Busy	\N	\N
861	2	20	2012-12-25 14:38:05.772347	Busy	\N	\N
862	2	20	2012-12-25 14:39:26.137702	Busy	\N	\N
863	2	20	2012-12-25 14:40:16.031701	Busy	\N	\N
864	2	20	2012-12-25 14:42:10.534731	NotAnswer	\N	\N
865	2	20	2012-12-25 14:43:56.608025	Busy	\N	\N
866	2	20	2012-12-25 14:44:45.955155	Busy	\N	\N
867	2	20	2012-12-25 14:45:40.624827	NotAnswer	\N	\N
868	2	20	2012-12-25 14:46:10.562399	NotAnswer	\N	\N
869	2	20	2012-12-25 14:50:01.337266	Success	00:00:34	\N
870	2	20	2012-12-25 15:50:23.263865	NotAnswer	\N	\N
871	2	20	2012-12-25 15:53:48.553574	NotAnswer	\N	\N
872	2	20	2012-12-25 15:57:31.252812	Success	00:00:23	\N
873	2	20	2012-12-25 16:58:01.716323	Success	00:00:16	\N
874	2	20	2012-12-25 22:24:11.424512	Busy	00:00:00	\N
875	2	20	2012-12-25 22:26:56.936952	Busy	00:00:00	\N
876	2	20	2012-12-25 22:35:58.065755	Busy	00:00:00	\N
877	2	20	2012-12-25 22:39:01.482596	Busy	00:00:00	\N
878	2	20	2012-12-25 22:40:46.3441	Busy	00:00:00	\N
879	2	20	2012-12-25 22:42:35.950605	Success	00:00:05	\N
880	10	22	2012-12-25 22:42:42.951835	NotAnswer	00:00:00	\N
881	1	19	2012-12-25 22:44:00.513929	NotAnswer	00:00:00	\N
882	2	20	2012-12-25 22:44:05.515528	Success	00:00:05	\N
883	10	22	2012-12-25 22:47:57.398389	Success	00:00:05	\N
884	1	19	2012-12-25 22:48:02.399123	Success	00:00:05	\N
885	2	20	2012-12-25 22:51:08.481208	NotAnswer	00:00:00	\N
886	1	19	2012-12-25 22:51:17.895927	Busy	00:00:00	\N
887	1	19	2012-12-25 22:51:33.480122	Busy	00:00:00	\N
888	10	22	2012-12-25 22:58:02.715873	NotAnswer	00:00:00	\N
889	1	19	2012-12-25 22:58:12.189988	NotAnswer	00:00:00	\N
890	2	20	2012-12-25 22:58:19.778971	Success	00:00:05	\N
891	1	19	2012-12-25 22:59:19.794963	Success	00:00:05	\N
892	1	19	2012-12-25 23:14:27.163051	NotAnswer	00:00:00	\N
893	1	19	2012-12-25 23:15:47.164138	NotAnswer	00:00:00	\N
894	1	19	2012-12-25 23:16:57.204185	NotAnswer	00:00:00	\N
895	1	19	2012-12-25 23:18:23.705416	NotAnswer	00:00:00	\N
896	1	19	2012-12-25 23:19:32.248488	NotAnswer	00:00:00	\N
897	1	19	2012-12-25 23:20:40.267365	Success	00:00:05	\N
898	10	22	2012-12-25 23:28:07.443899	Busy	00:00:00	\N
899	10	22	2012-12-25 23:33:17.5614	NotAnswer	00:00:00	\N
\.


--
-- Data for Name: job_numbers; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY job_numbers (id, job_id, number, last_attempt, last_result, active, next_try) FROM stdin;
20	2	+79101312571	2013-01-28 12:06:27.43814	NotAnswer	f	2013-01-28 12:36:27.43814
22	10	+79103375492	2013-01-27 16:20:54.946091	NotAnswer	f	2013-01-27 16:50:54.946091
19	1	+79609102371	2013-01-28 14:01:55.460096	Success	t	2013-01-28 15:01:57.460096
23	2	1564	2013-01-28 14:04:21.208812	Success	t	\N
25	11	+79109102311	\N	\N	t	\N
24	11	+79109102311	2013-01-28 14:23:16.506946	Success	f	2013-01-28 15:23:18.506946
26	12	+79135691233	2013-01-28 14:56:09.804407	Busy	t	2013-01-28 14:57:09.804407
\.


--
-- Data for Name: modem_groups; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY modem_groups (id, name) FROM stdin;
1	MTS
2	Beeline
3	Tele2
4	Megafon
0	internal
5	disconnected
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY notification (id, job_id, number_id, t, result, ivrres, warning, seen) FROM stdin;
14	2	23	2013-01-28 13:06:59.415438	Success	1	t	3
2	2	23	2013-01-28 11:32:57.810996	Success	3	t	3
6	2	23	2013-01-28 12:36:38.074334	Success	1	t	3
5	2	23	2013-01-28 12:27:49.709056	Success	2	t	3
17	2	23	2013-01-28 13:11:58.738849	Success	1	t	3
13	2	23	2013-01-28 13:05:45.165118	Success	4	f	3
18	2	23	2013-01-28 13:14:49.829981	Success	4	f	3
12	2	23	2013-01-28 13:02:52.111436	Success	6	f	3
11	2	23	2013-01-28 13:01:12.791629	Success	6	f	3
10	2	23	2013-01-28 12:58:03.834919	Success	6	f	3
9	2	23	2013-01-28 12:53:41.932868	Success	d	f	3
8	2	23	2013-01-28 12:38:48.391705	Success	d	f	3
21	2	23	2013-01-28 14:04:21.214326	Success	4	f	\N
3	2	23	2013-01-28 12:07:04.672291	Success	<unknown>	f	3
4	2	23	2013-01-28 12:09:49.918175	Success	5	f	3
7	2	23	2013-01-28 12:37:53.617805	Success	9	f	3
1	2	23	2013-01-28 11:30:46.699689	Success	1	t	3
15	2	23	2013-01-28 13:10:05.633985	Success	1	t	3
19	2	23	2013-01-28 13:58:52.552223	Success	7	f	3
20	1	19	2013-01-28 14:01:55.465773	Success	1	t	3
16	2	23	2013-01-28 13:11:13.274559	Success	1	t	4
22	11	24	2013-01-28 14:23:16.51256	Success	1	t	4
23	12	26	2013-01-28 14:41:44.026875	Success	1	t	4
24	12	26	2013-01-28 14:53:23.480472	Busy	\N	f	\N
25	12	26	2013-01-28 14:54:43.763657	Busy	\N	f	\N
26	12	26	2013-01-28 14:56:09.81144	Busy	\N	f	\N
\.


--
-- Data for Name: route; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY route (id, pattern, group_id, prio) FROM stdin;
12330	+79	3	0
12331	1	0	1
3	+7904520	3	8
4	+7904521	3	8
5	+7904522	3	8
6	+7904523	3	8
7	+7904524	3	8
8	+7904525	3	8
9	+7904526	3	8
10	+7904527	3	8
11	+7904528	3	8
12	+7904529	3	8
13	+7908120	3	8
14	+7908121	3	8
15	+7908122	3	8
16	+7908123	3	8
17	+7908124	3	8
18	+7908125	3	8
19	+7908126	3	8
20	+7908127	3	8
21	+7908128	3	8
22	+7908129	3	8
23	+7950870	3	8
24	+7950871	3	8
25	+7950872	3	8
26	+7950873	3	8
27	+7950874	3	8
28	+7950875	3	8
29	+7950876	3	8
30	+7950877	3	8
31	+7950878	3	8
32	+7950879	3	8
33	+7910000	1	8
34	+7910001	1	8
35	+7910002	1	8
36	+7910003	1	8
37	+7910004	1	8
38	+7910005	1	8
39	+7910008	1	8
40	+7910009	1	8
41	+7910010	1	8
42	+7910011	1	8
43	+79100120	1	9
44	+79100121	1	9
45	+79100122	1	9
46	+79100123	1	9
47	+79100124	1	9
48	+79100125	1	9
49	+79100126	1	9
50	+79100127	1	9
51	+79100128	1	9
52	+79100129	1	9
53	+7910013	1	8
54	+7910014	1	8
55	+7910015	1	8
56	+7910016	1	8
57	+7910017	1	8
58	+7910018	1	8
59	+7910019	1	8
60	+7910020	1	8
61	+7910021	1	8
62	+7910022	1	8
63	+7910023	1	8
64	+7910024	1	8
65	+7910025	1	8
66	+7910026	1	8
67	+7910027	1	8
68	+7910028	1	8
69	+7910029	1	8
70	+7910030	1	8
71	+7910031	1	8
72	+7910032	1	8
73	+7910033	1	8
74	+7910034	1	8
75	+7910035	1	8
76	+7910036	1	8
77	+7910037	1	8
78	+7910038	1	8
79	+7910039	1	8
80	+7910040	1	8
81	+7910041	1	8
82	+7910042	1	8
83	+7910043	1	8
84	+7910044	1	8
85	+7910045	1	8
86	+7910046	1	8
87	+7910047	1	8
88	+7910048	1	8
89	+7910049	1	8
90	+7910050	1	8
91	+7910051	1	8
92	+7910052	1	8
93	+7910053	1	8
94	+7910054	1	8
95	+7910055	1	8
96	+7910056	1	8
97	+7910060	1	8
98	+7910061	1	8
99	+7910062	1	8
100	+7910063	1	8
101	+7910064	1	8
102	+7910065	1	8
103	+7910066	1	8
104	+7910067	1	8
105	+7910068	1	8
106	+7910069	1	8
107	+7910070	1	8
108	+7910071	1	8
109	+7910072	1	8
110	+7910073	1	8
111	+7910074	1	8
112	+7910075	1	8
113	+7910076	1	8
114	+7910077	1	8
115	+7910078	1	8
116	+7910079	1	8
117	+7910080	1	8
118	+7910081	1	8
119	+7910082	1	8
120	+7910083	1	8
121	+7910084	1	8
122	+7910085	1	8
123	+7910086	1	8
124	+7910087	1	8
125	+7910088	1	8
126	+7910089	1	8
127	+791020	1	7
128	+791021	1	7
129	+791022	1	7
130	+791023	1	7
131	+791024	1	7
132	+791025	1	7
133	+791026	1	7
134	+791027	1	7
135	+791028	1	7
136	+791029	1	7
137	+791030	1	7
138	+791031	1	7
139	+791032	1	7
140	+791033	1	7
141	+791034	1	7
142	+791035	1	7
143	+791036	1	7
144	+79104	1	6
145	+7910730	1	8
146	+7910731	1	8
147	+7910732	1	8
148	+7910733	1	8
149	+7910734	1	8
150	+7910735	1	8
151	+7910736	1	8
152	+7910737	1	8
153	+7910738	1	8
154	+7910739	1	8
155	+7910740	1	8
156	+7910741	1	8
157	+7910742	1	8
158	+7910743	1	8
159	+7910744	1	8
160	+7910745	1	8
161	+7910746	1	8
162	+7910747	1	8
163	+7910748	1	8
164	+7910749	1	8
165	+791100	1	7
166	+791101	1	7
167	+791102	1	7
168	+791103	1	7
169	+7911040	1	8
170	+7911041	1	8
171	+7911042	1	8
172	+7911043	1	8
173	+7911044	1	8
174	+7911045	1	8
175	+7911046	1	8
176	+7911047	1	8
177	+7911048	1	8
178	+7911049	1	8
179	+7911050	1	8
180	+7911051	1	8
181	+7911052	1	8
182	+7911053	1	8
183	+7911054	1	8
184	+7911055	1	8
185	+7911056	1	8
186	+7911057	1	8
187	+7911058	1	8
188	+7911059	1	8
189	+7911060	1	8
190	+7911061	1	8
191	+7911062	1	8
192	+7911063	1	8
193	+7911064	1	8
194	+7911065	1	8
195	+7911066	1	8
196	+7911067	1	8
197	+7911068	1	8
198	+7911069	1	8
199	+7911070	1	8
200	+7911071	1	8
201	+7911072	1	8
202	+7911073	1	8
203	+7911074	1	8
204	+7911075	1	8
205	+7911076	1	8
206	+7911077	1	8
207	+7911078	1	8
208	+7911079	1	8
209	+791108	1	7
210	+791109	1	7
211	+79111	1	6
212	+79112	1	6
213	+791130	1	7
214	+791131	1	7
215	+791132	1	7
216	+791133	1	7
217	+791134	1	7
218	+791135	1	7
219	+791136	1	7
220	+791137	1	7
221	+791138	1	7
222	+791139	1	7
223	+791140	1	7
224	+791141	1	7
225	+791142	1	7
226	+791143	1	7
227	+791144	1	7
228	+791145	1	7
229	+791146	1	7
230	+791147	1	7
231	+791148	1	7
232	+791149	1	7
233	+791150	1	7
234	+791151	1	7
235	+791152	1	7
236	+791153	1	7
237	+791154	1	7
238	+791155	1	7
239	+791156	1	7
240	+791157	1	7
241	+791158	1	7
242	+791159	1	7
243	+791160	1	7
244	+791161	1	7
245	+791162	1	7
246	+791163	1	7
247	+791164	1	7
248	+7911650	1	8
249	+7911651	1	8
250	+7911652	1	8
251	+7911653	1	8
252	+7911654	1	8
253	+7911655	1	8
254	+7911656	1	8
255	+7911657	1	8
256	+7911658	1	8
257	+7911659	1	8
258	+791166	1	7
259	+791167	1	7
260	+791168	1	7
261	+791169	1	7
262	+79117	1	6
263	+791180	1	7
264	+791181	1	7
265	+791182	1	7
266	+791183	1	7
267	+791184	1	7
268	+791185	1	7
269	+791186	1	7
270	+791187	1	7
271	+791188	1	7
272	+791189	1	7
273	+79119	1	6
274	+7912000	1	8
275	+7912003	1	8
276	+7912004	1	8
277	+7912005	1	8
278	+7912006	1	8
279	+7912007	1	8
280	+7912008	1	8
281	+7912009	1	8
282	+791201	1	7
283	+791202	1	7
284	+7912030	1	8
285	+7912031	1	8
286	+7912032	1	8
287	+7912033	1	8
288	+7912034	1	8
289	+7912035	1	8
290	+7912036	1	8
291	+7912037	1	8
292	+7912038	1	8
293	+7912039	1	8
294	+7912040	1	8
295	+7912041	1	8
296	+7912042	1	8
297	+7912043	1	8
298	+7912044	1	8
299	+7912045	1	8
300	+7912046	1	8
301	+7912047	1	8
302	+7912048	1	8
303	+7912049	1	8
304	+7912050	1	8
305	+7912051	1	8
306	+7912052	1	8
307	+7912053	1	8
308	+7912054	1	8
309	+7912055	1	8
310	+7912056	1	8
311	+7912057	1	8
312	+7912058	1	8
313	+7912059	1	8
314	+7912060	1	8
315	+7912061	1	8
316	+7912062	1	8
317	+7912063	1	8
318	+7912064	1	8
319	+79120650	1	9
320	+79120651	1	9
321	+79120652	1	9
322	+79120653	1	9
323	+79120654	1	9
324	+79120655	1	9
325	+79120656	1	9
326	+79120657	1	9
327	+79120658	1	9
328	+79120659	1	9
329	+79120660	1	9
330	+79120661	1	9
331	+79120662	1	9
332	+79120663	1	9
333	+79120664	1	9
334	+79120665	1	9
335	+79120666	1	9
336	+79120667	1	9
337	+79120668	1	9
338	+79120669	1	9
339	+79120670	1	9
340	+79120671	1	9
341	+79120672	1	9
342	+79120673	1	9
343	+79120674	1	9
344	+79120675	1	9
345	+79120676	1	9
346	+79120677	1	9
347	+79120678	1	9
348	+79120679	1	9
349	+7912068	1	8
350	+7912069	1	8
351	+7912070	1	8
352	+7912071	1	8
353	+7912072	1	8
354	+7912073	1	8
355	+7912074	1	8
356	+79120750	1	9
357	+79120751	1	9
358	+79120752	1	9
359	+79120753	1	9
360	+79120754	1	9
361	+79120755	1	9
362	+79120756	1	9
363	+79120757	1	9
364	+79120758	1	9
365	+79120759	1	9
366	+79120760	1	9
367	+79120761	1	9
368	+79120762	1	9
369	+79120763	1	9
370	+79120764	1	9
371	+79120765	1	9
372	+79120766	1	9
373	+7912077	1	8
374	+7912078	1	8
375	+7912079	1	8
376	+7912080	1	8
377	+7912081	1	8
378	+7912082	1	8
379	+7912083	1	8
380	+7912084	1	8
381	+7912085	1	8
382	+7912086	1	8
383	+7912087	1	8
384	+7912088	1	8
385	+7912089	1	8
386	+7912093	1	8
387	+7912094	1	8
388	+7912095	1	8
389	+79121	1	6
390	+79122	1	6
391	+791230	1	7
392	+791231	1	7
393	+791232	1	7
394	+791233	1	7
395	+791234	1	7
396	+791235	1	7
397	+791236	1	7
398	+791237	1	7
399	+791238	1	7
400	+791239	1	7
401	+791240	1	7
402	+791241	1	7
403	+791242	1	7
404	+791243	1	7
405	+791244	1	7
406	+791245	1	7
407	+791246	1	7
408	+791247	1	7
409	+791248	1	7
410	+791249	1	7
411	+791250	1	7
412	+791251	1	7
413	+791252	1	7
414	+791253	1	7
415	+791254	1	7
416	+791255	1	7
417	+791256	1	7
418	+791257	1	7
419	+791258	1	7
420	+791259	1	7
421	+79126	1	6
422	+791270	1	7
423	+791271	1	7
424	+791272	1	7
425	+791273	1	7
426	+791274	1	7
427	+791275	1	7
428	+791276	1	7
429	+791277	1	7
430	+791278	1	7
431	+791279	1	7
432	+791280	1	7
433	+791281	1	7
434	+791282	1	7
435	+791283	1	7
436	+791284	1	7
437	+791285	1	7
438	+791286	1	7
439	+791287	1	7
440	+791288	1	7
441	+791289	1	7
442	+791290	1	7
443	+791291	1	7
444	+791292	1	7
445	+791293	1	7
446	+791294	1	7
447	+791295	1	7
448	+791296	1	7
449	+791297	1	7
450	+791298	1	7
451	+791299	1	7
452	+791300	1	7
453	+791301	1	7
454	+791302	1	7
455	+791303	1	7
456	+791304	1	7
457	+791305	1	7
458	+791306	1	7
459	+791307	1	7
460	+791308	1	7
461	+791309	1	7
462	+791310	1	7
463	+791311	1	7
464	+791312	1	7
465	+791313	1	7
466	+791314	1	7
467	+791315	1	7
468	+791316	1	7
469	+791317	1	7
470	+791318	1	7
471	+791319	1	7
472	+791320	1	7
473	+791321	1	7
474	+791322	1	7
475	+791323	1	7
476	+791324	1	7
477	+791325	1	7
478	+791326	1	7
479	+791327	1	7
480	+791328	1	7
481	+791329	1	7
482	+791330	1	7
483	+791331	1	7
484	+791332	1	7
485	+791334	1	7
486	+791335	1	7
487	+791336	1	7
488	+791337	1	7
489	+791338	1	7
490	+791339	1	7
491	+791340	1	7
492	+791341	1	7
493	+791342	1	7
494	+791343	1	7
495	+791344	1	7
496	+791345	1	7
497	+791346	1	7
498	+791347	1	7
499	+791348	1	7
500	+7913490	1	8
501	+7913491	1	8
502	+7913492	1	8
503	+7913493	1	8
504	+7913494	1	8
505	+7913495	1	8
506	+7913496	1	8
507	+7913497	1	8
508	+7913498	1	8
509	+7913499	1	8
510	+7913500	1	8
511	+7913501	1	8
512	+7913502	1	8
513	+7913503	1	8
514	+7913504	1	8
515	+7913505	1	8
516	+7913506	1	8
517	+7913507	1	8
518	+7913508	1	8
519	+7913509	1	8
520	+791351	1	7
521	+7913520	1	8
522	+7913521	1	8
523	+7913522	1	8
524	+7913523	1	8
525	+7913524	1	8
526	+7913525	1	8
527	+7913526	1	8
528	+7913527	1	8
529	+7913528	1	8
530	+7913529	1	8
531	+7913530	1	8
532	+7913531	1	8
533	+7913532	1	8
534	+7913533	1	8
535	+7913534	1	8
536	+7913535	1	8
537	+7913536	1	8
538	+7913537	1	8
539	+7913538	1	8
540	+7913539	1	8
541	+791354	1	7
542	+791355	1	7
543	+791356	1	7
544	+791357	1	7
545	+791358	1	7
546	+791359	1	7
547	+791360	1	7
548	+791361	1	7
549	+791362	1	7
550	+791363	1	7
551	+791364	1	7
552	+791365	1	7
553	+791366	1	7
554	+791367	1	7
555	+791368	1	7
556	+791369	1	7
557	+79137	1	6
558	+791380	1	7
559	+791381	1	7
560	+791382	1	7
561	+791383	1	7
562	+791384	1	7
563	+791385	1	7
564	+791386	1	7
565	+791387	1	7
566	+791388	1	7
567	+791389	1	7
568	+791390	1	7
569	+791391	1	7
570	+791392	1	7
571	+791393	1	7
572	+791394	1	7
573	+791395	1	7
574	+791396	1	7
575	+791397	1	7
576	+7913980	1	8
577	+7913981	1	8
578	+7913982	1	8
579	+7913983	1	8
580	+7913984	1	8
581	+7913985	1	8
582	+7913986	1	8
583	+7913987	1	8
584	+7913988	1	8
585	+7913989	1	8
586	+7913990	1	8
587	+7913991	1	8
588	+7913992	1	8
589	+7913993	1	8
590	+7913994	1	8
591	+7913995	1	8
592	+7913996	1	8
593	+7913997	1	8
594	+7913998	1	8
595	+7913999	1	8
596	+7914000	1	8
597	+7914001	1	8
598	+7914002	1	8
599	+7914003	1	8
600	+7914004	1	8
601	+7914005	1	8
602	+7914006	1	8
603	+7914007	1	8
604	+7914008	1	8
605	+7914009	1	8
606	+7914010	1	8
607	+7914011	1	8
608	+7914012	1	8
609	+7914013	1	8
610	+7914014	1	8
611	+7914015	1	8
612	+7914016	1	8
613	+7914017	1	8
614	+7914018	1	8
615	+7914019	1	8
616	+791402	1	7
617	+791403	1	7
618	+791404	1	7
619	+791405	1	7
620	+7914060	1	8
621	+7914061	1	8
622	+7914062	1	8
623	+7914063	1	8
624	+7914064	1	8
625	+7914065	1	8
626	+7914066	1	8
627	+7914067	1	8
628	+7914068	1	8
629	+7914069	1	8
630	+7914070	1	8
631	+7914071	1	8
632	+7914072	1	8
633	+7914073	1	8
634	+7914074	1	8
635	+7914075	1	8
636	+7914076	1	8
637	+7914077	1	8
638	+7914078	1	8
639	+7914079	1	8
640	+7914080	1	8
641	+7914081	1	8
642	+7914082	1	8
643	+7914083	1	8
644	+7914084	1	8
645	+7914085	1	8
646	+7914086	1	8
647	+7914087	1	8
648	+7914088	1	8
649	+7914089	1	8
650	+7914090	1	8
651	+7914091	1	8
652	+7914092	1	8
653	+7914093	1	8
654	+7914094	1	8
655	+7914095	1	8
656	+7914096	1	8
657	+7914097	1	8
658	+7914098	1	8
659	+7914099	1	8
660	+791410	1	7
661	+791411	1	7
662	+791415	1	7
663	+791416	1	7
664	+791417	1	7
665	+791418	1	7
666	+791419	1	7
667	+791420	1	7
668	+791421	1	7
669	+791422	1	7
670	+791423	1	7
671	+791424	1	7
672	+791425	1	7
673	+791426	1	7
674	+791427	1	7
675	+791428	1	7
676	+791429	1	7
677	+791430	1	7
678	+791431	1	7
679	+791432	1	7
680	+791433	1	7
681	+791434	1	7
682	+791435	1	7
683	+791436	1	7
684	+791437	1	7
685	+791438	1	7
686	+791439	1	7
687	+791440	1	7
688	+791441	1	7
689	+791442	1	7
690	+7914533	1	8
691	+7914534	1	8
692	+7914535	1	8
693	+7914536	1	8
694	+7914537	1	8
695	+7914538	1	8
696	+79145390	1	9
697	+79145391	1	9
698	+79145392	1	9
699	+791454	1	7
700	+791455	1	7
701	+791456	1	7
702	+791457	1	7
703	+791458	1	7
704	+791459	1	7
705	+791460	1	7
706	+791461	1	7
707	+791462	1	7
708	+791463	1	7
709	+791464	1	7
710	+791465	1	7
711	+791466	1	7
712	+791467	1	7
713	+791468	1	7
714	+791469	1	7
715	+791470	1	7
716	+791471	1	7
717	+791472	1	7
718	+791473	1	7
719	+791474	1	7
720	+791475	1	7
721	+791476	1	7
722	+791477	1	7
723	+791478	1	7
724	+791479	1	7
725	+791480	1	7
726	+791481	1	7
727	+791482	1	7
728	+791483	1	7
729	+791484	1	7
730	+791485	1	7
731	+791486	1	7
732	+791487	1	7
733	+791488	1	7
734	+791489	1	7
735	+791490	1	7
736	+791491	1	7
737	+791492	1	7
738	+791493	1	7
739	+791494	1	7
740	+791495	1	7
741	+791496	1	7
742	+791497	1	7
743	+791498	1	7
744	+791499	1	7
745	+79150	1	6
746	+791550	1	7
747	+791551	1	7
748	+791552	1	7
749	+791553	1	7
750	+791554	1	7
751	+791555	1	7
752	+791556	1	7
753	+791557	1	7
754	+791558	1	7
755	+791580	1	7
756	+791585	1	7
757	+79160	1	6
758	+7917000	1	8
759	+7917001	1	8
760	+7917002	1	8
761	+7917005	1	8
762	+7917006	1	8
763	+7917007	1	8
764	+7917008	1	8
765	+7917009	1	8
766	+791701	1	7
767	+791702	1	7
768	+791703	1	7
769	+791704	1	7
770	+7917050	1	8
771	+7917051	1	8
772	+7917052	1	8
773	+7917053	1	8
774	+7917054	1	8
775	+7917055	1	8
776	+7917056	1	8
777	+7917057	1	8
778	+7917058	1	8
779	+7917059	1	8
780	+7917060	1	8
781	+7917061	1	8
782	+7917062	1	8
783	+7917063	1	8
784	+7917064	1	8
785	+7917065	1	8
786	+7917066	1	8
787	+7917067	1	8
788	+7917068	1	8
789	+7917069	1	8
790	+7917070	1	8
791	+7917071	1	8
792	+7917072	1	8
793	+7917073	1	8
794	+7917074	1	8
795	+7917075	1	8
796	+7917076	1	8
797	+7917077	1	8
798	+7917078	1	8
799	+7917079	1	8
800	+791708	1	7
801	+791709	1	7
802	+791710	1	7
803	+791711	1	7
804	+791712	1	7
805	+791713	1	7
806	+791714	1	7
807	+791715	1	7
808	+791716	1	7
809	+791717	1	7
810	+791718	1	7
811	+791719	1	7
812	+791720	1	7
813	+791721	1	7
814	+791722	1	7
815	+791723	1	7
816	+791724	1	7
817	+791725	1	7
818	+791726	1	7
819	+791727	1	7
820	+791728	1	7
821	+791729	1	7
822	+791730	1	7
823	+791731	1	7
824	+791732	1	7
825	+791733	1	7
826	+791734	1	7
827	+791735	1	7
828	+791736	1	7
829	+791737	1	7
830	+791738	1	7
831	+791739	1	7
832	+79174	1	6
833	+79175	1	6
834	+791760	1	7
835	+791761	1	7
836	+791762	1	7
837	+791763	1	7
838	+791764	1	7
839	+791765	1	7
840	+791766	1	7
841	+791767	1	7
842	+791768	1	7
843	+791769	1	7
844	+791770	1	7
845	+791771	1	7
846	+791772	1	7
847	+791773	1	7
848	+791774	1	7
849	+791775	1	7
850	+791776	1	7
851	+791777	1	7
852	+791778	1	7
853	+791779	1	7
854	+791780	1	7
855	+791781	1	7
856	+791782	1	7
857	+791783	1	7
858	+791784	1	7
859	+791785	1	7
860	+791786	1	7
861	+791787	1	7
862	+791788	1	7
863	+791789	1	7
864	+791790	1	7
865	+791791	1	7
866	+791792	1	7
867	+791793	1	7
868	+791794	1	7
869	+791795	1	7
870	+791798	1	7
871	+791799	1	7
872	+79180	1	6
873	+79181	1	6
874	+791820	1	7
875	+791821	1	7
876	+791822	1	7
877	+791823	1	7
878	+791824	1	7
879	+791825	1	7
880	+791826	1	7
881	+791827	1	7
882	+791828	1	7
883	+791829	1	7
884	+79183	1	6
885	+791840	1	7
886	+791841	1	7
887	+791842	1	7
888	+791843	1	7
889	+791844	1	7
890	+791845	1	7
891	+791846	1	7
892	+791847	1	7
893	+791848	1	7
894	+791849	1	7
895	+79185	1	6
896	+79186	1	6
897	+791870	1	7
898	+791871	1	7
899	+791872	1	7
900	+791873	1	7
901	+791874	1	7
902	+791875	1	7
903	+791876	1	7
904	+791877	1	7
905	+791878	1	7
906	+791879	1	7
907	+791880	1	7
908	+791881	1	7
909	+791882	1	7
910	+791883	1	7
911	+791884	1	7
912	+791885	1	7
913	+791886	1	7
914	+791887	1	7
915	+791888	1	7
916	+791889	1	7
917	+791890	1	7
918	+791891	1	7
919	+791892	1	7
920	+791893	1	7
921	+791894	1	7
922	+791895	1	7
923	+791896	1	7
924	+791897	1	7
925	+791898	1	7
926	+791899	1	7
927	+791909	1	7
928	+791910	1	7
929	+791911	1	7
930	+791912	1	7
931	+7919139	1	8
932	+791914	1	7
933	+791915	1	7
934	+791916	1	7
935	+791917	1	7
936	+791918	1	7
937	+791919	1	7
938	+791920	1	7
939	+791921	1	7
940	+791922	1	7
941	+791923	1	7
942	+791924	1	7
943	+791925	1	7
944	+791926	1	7
945	+791927	1	7
946	+791928	1	7
947	+791929	1	7
948	+791930	1	7
949	+791931	1	7
950	+791932	1	7
951	+791933	1	7
952	+791934	1	7
953	+791935	1	7
954	+791936	1	7
955	+791937	1	7
956	+791938	1	7
957	+791939	1	7
958	+791940	1	7
959	+7919410	1	8
960	+7919411	1	8
961	+791942	1	7
962	+791943	1	7
963	+791944	1	7
964	+791945	1	7
965	+791946	1	7
966	+791947	1	7
967	+791948	1	7
968	+791949	1	7
969	+791950	1	7
970	+791951	1	7
971	+791952	1	7
972	+791953	1	7
973	+791954	1	7
974	+791955	1	7
975	+791956	1	7
976	+791957	1	7
977	+791958	1	7
978	+791959	1	7
979	+791960	1	7
980	+791961	1	7
981	+791962	1	7
982	+791963	1	7
983	+791964	1	7
984	+791965	1	7
985	+791966	1	7
986	+791967	1	7
987	+791968	1	7
988	+791969	1	7
989	+791970	1	7
990	+791971	1	7
991	+791972	1	7
992	+791973	1	7
993	+791974	1	7
994	+791975	1	7
995	+791976	1	7
996	+791977	1	7
997	+7919784	1	8
998	+7919786	1	8
999	+791979	1	7
1000	+791980	1	7
1001	+791981	1	7
1002	+791982	1	7
1003	+791983	1	7
1004	+791984	1	7
1005	+791985	1	7
1006	+791986	1	7
1007	+791987	1	7
1008	+791988	1	7
1009	+791989	1	7
1010	+791990	1	7
1011	+791991	1	7
1012	+791992	1	7
1013	+791993	1	7
1014	+791994	1	7
1015	+791995	1	7
1016	+791996	1	7
1017	+7919970	1	8
1018	+791998	1	7
1019	+791999	1	7
1020	+798024	1	7
1021	+7980250	1	8
1022	+7980251	1	8
1023	+7980252	1	8
1024	+7980253	1	8
1025	+798026	1	7
1026	+798029	1	7
1027	+798030	1	7
1028	+798031	1	7
1029	+798032	1	7
1030	+798033	1	7
1031	+798034	1	7
1032	+798035	1	7
1033	+798036	1	7
1034	+798037	1	7
1035	+798038	1	7
1036	+7980390	1	8
1037	+7980391	1	8
1038	+7980392	1	8
1039	+7980393	1	8
1040	+7980394	1	8
1041	+7980505	1	8
1042	+7980506	1	8
1043	+7980507	1	8
1044	+7980508	1	8
1045	+7980509	1	8
1046	+7980515	1	8
1047	+7980516	1	8
1048	+7980517	1	8
1049	+7980518	1	8
1050	+7980519	1	8
1051	+798052	1	7
1052	+798053	1	7
1053	+798054	1	7
1054	+798055	1	7
1055	+798056	1	7
1056	+7980570	1	8
1057	+7980571	1	8
1058	+7980572	1	8
1059	+7980573	1	8
1060	+7980574	1	8
1061	+7980575	1	8
1062	+7980576	1	8
1063	+7980577	1	8
1064	+7980578	1	8
1065	+7980579	1	8
1066	+7980580	1	8
1067	+7980581	1	8
1068	+7980582	1	8
1069	+7980583	1	8
1070	+7980584	1	8
1071	+7980585	1	8
1072	+7980586	1	8
1073	+7980587	1	8
1074	+7980588	1	8
1075	+7980589	1	8
1076	+798062	1	7
1077	+798063	1	7
1078	+7980640	1	8
1079	+7980641	1	8
1080	+7980642	1	8
1081	+7980643	1	8
1082	+7980644	1	8
1083	+7980645	1	8
1084	+7980646	1	8
1085	+7980647	1	8
1086	+7980648	1	8
1087	+7980649	1	8
1088	+7980665	1	8
1089	+7980666	1	8
1090	+7980667	1	8
1091	+7980668	1	8
1092	+7980669	1	8
1093	+798068	1	7
1094	+7980690	1	8
1095	+7980691	1	8
1096	+7980692	1	8
1097	+7980693	1	8
1098	+7980694	1	8
1099	+7980695	1	8
1100	+7980696	1	8
1101	+798070	1	7
1102	+798071	1	7
1103	+798072	1	7
1104	+798073	1	7
1105	+798074	1	7
1106	+798075	1	7
1107	+798076	1	7
1108	+798077	1	7
1109	+798078	1	7
1110	+798079	1	7
1111	+79811	1	6
1112	+798130	1	7
1113	+798131	1	7
1114	+7981320	1	8
1115	+7981321	1	8
1116	+7981322	1	8
1117	+7981323	1	8
1118	+7981324	1	8
1119	+798134	1	7
1120	+798135	1	7
1121	+7981360	1	8
1122	+7981361	1	8
1123	+7981362	1	8
1124	+7981363	1	8
1125	+7981364	1	8
1126	+7981395	1	8
1127	+7981396	1	8
1128	+7981397	1	8
1129	+7981398	1	8
1130	+7981399	1	8
1131	+798140	1	7
1132	+798141	1	7
1133	+798142	1	7
1134	+798143	1	7
1135	+7981445	1	8
1136	+7981446	1	8
1137	+7981447	1	8
1138	+7981448	1	8
1139	+7981449	1	8
1140	+798145	1	7
1141	+798146	1	7
1142	+798147	1	7
1143	+798148	1	7
1144	+798150	1	7
1145	+7981510	1	8
1146	+7981511	1	8
1147	+7981512	1	8
1148	+7981513	1	8
1149	+7981514	1	8
1150	+7981515	1	8
1151	+7981516	1	8
1152	+7981517	1	8
1153	+7981518	1	8
1154	+7981519	1	8
1155	+7981520	1	8
1156	+7981521	1	8
1157	+7981522	1	8
1158	+7981523	1	8
1159	+7981524	1	8
1160	+798155	1	7
1161	+798156	1	7
1162	+798157	1	7
1163	+798160	1	7
1164	+798161	1	7
1165	+798168	1	7
1166	+798169	1	7
1167	+798170	1	7
1168	+798171	1	7
1169	+798172	1	7
1170	+798173	1	7
1171	+798174	1	7
1172	+798175	1	7
1173	+798176	1	7
1174	+798177	1	7
1175	+798178	1	7
1176	+798179	1	7
1177	+798180	1	7
1178	+798181	1	7
1179	+798182	1	7
1180	+798183	1	7
1181	+798184	1	7
1182	+798185	1	7
1183	+7981860	1	8
1184	+7981861	1	8
1185	+7981862	1	8
1186	+7981863	1	8
1187	+7981864	1	8
1188	+798187	1	7
1189	+798188	1	7
1190	+798189	1	7
1191	+798190	1	7
1192	+798191	1	7
1193	+798192	1	7
1194	+798193	1	7
1195	+798194	1	7
1196	+798195	1	7
1197	+798196	1	7
1198	+798197	1	7
1199	+798198	1	7
1200	+798199	1	7
1201	+7982100	1	8
1202	+7982101	1	8
1203	+7982102	1	8
1204	+7982103	1	8
1205	+7982104	1	8
1206	+7982105	1	8
1207	+7982106	1	8
1208	+7982107	1	8
1209	+7982108	1	8
1210	+7982109	1	8
1211	+7982110	1	8
1212	+7982111	1	8
1213	+7982112	1	8
1214	+7982113	1	8
1215	+7982114	1	8
1216	+7982115	1	8
1217	+7982116	1	8
1218	+7982117	1	8
1219	+7982118	1	8
1220	+7982119	1	8
1221	+798217	1	7
1222	+798218	1	7
1223	+798219	1	7
1224	+798230	1	7
1225	+798231	1	7
1226	+798232	1	7
1227	+798233	1	7
1228	+798234	1	7
1229	+798235	1	7
1230	+798236	1	7
1231	+798237	1	7
1232	+798238	1	7
1233	+7982390	1	8
1234	+7982391	1	8
1235	+7982392	1	8
1236	+7982393	1	8
1237	+7982394	1	8
1238	+7982395	1	8
1239	+7982396	1	8
1240	+7982397	1	8
1241	+7982398	1	8
1242	+7982399	1	8
1243	+798240	1	7
1244	+798241	1	7
1245	+798242	1	7
1246	+798243	1	7
1247	+798244	1	7
1248	+798245	1	7
1249	+798246	1	7
1250	+798247	1	7
1251	+798248	1	7
1252	+798249	1	7
1253	+798250	1	7
1254	+798251	1	7
1255	+798252	1	7
1256	+798253	1	7
1257	+798254	1	7
1258	+798255	1	7
1259	+798256	1	7
1260	+798257	1	7
1261	+798258	1	7
1262	+798259	1	7
1263	+798260	1	7
1264	+798261	1	7
1265	+798262	1	7
1266	+798263	1	7
1267	+798264	1	7
1268	+798265	1	7
1269	+798266	1	7
1270	+798267	1	7
1271	+798268	1	7
1272	+798269	1	7
1273	+798270	1	7
1274	+798271	1	7
1275	+798290	1	7
1276	+798291	1	7
1277	+798292	1	7
1278	+798293	1	7
1279	+798294	1	7
1280	+798295	1	7
1281	+798296	1	7
1282	+798297	1	7
1283	+798299	1	7
1284	+7983000	1	8
1285	+7983001	1	8
1286	+7983002	1	8
1287	+7983003	1	8
1288	+7983050	1	8
1289	+7983051	1	8
1290	+7983052	1	8
1291	+7983053	1	8
1292	+7983054	1	8
1293	+7983055	1	8
1294	+7983056	1	8
1295	+7983057	1	8
1296	+7983070	1	8
1297	+7983075	1	8
1298	+7983077	1	8
1299	+798310	1	7
1300	+798311	1	7
1301	+798312	1	7
1302	+798313	1	7
1303	+798314	1	7
1304	+798315	1	7
1305	+798316	1	7
1306	+798317	1	7
1307	+798318	1	7
1308	+798319	1	7
1309	+798320	1	7
1310	+798321	1	7
1311	+798322	1	7
1312	+798323	1	7
1313	+798324	1	7
1314	+7983250	1	8
1315	+7983251	1	8
1316	+7983252	1	8
1317	+7983253	1	8
1318	+7983254	1	8
1319	+7983255	1	8
1320	+7983256	1	8
1321	+7983257	1	8
1322	+7983258	1	8
1323	+7983259	1	8
1324	+7983260	1	8
1325	+7983261	1	8
1326	+7983262	1	8
1327	+7983263	1	8
1328	+7983264	1	8
1329	+7983265	1	8
1330	+7983266	1	8
1331	+7983267	1	8
1332	+7983268	1	8
1333	+7983269	1	8
1334	+798327	1	7
1335	+798328	1	7
1336	+798329	1	7
1337	+7983300	1	8
1338	+7983301	1	8
1339	+7983302	1	8
1340	+7983303	1	8
1341	+7983304	1	8
1342	+7983305	1	8
1343	+7983306	1	8
1344	+7983307	1	8
1345	+7983308	1	8
1346	+7983309	1	8
1347	+7983310	1	8
1348	+7983311	1	8
1349	+7983312	1	8
1350	+7983313	1	8
1351	+7983314	1	8
1352	+7983315	1	8
1353	+7983316	1	8
1354	+7983317	1	8
1355	+7983318	1	8
1356	+7983319	1	8
1357	+7983320	1	8
1358	+7983321	1	8
1359	+7983322	1	8
1360	+7983323	1	8
1361	+7983324	1	8
1362	+7983325	1	8
1363	+7983326	1	8
1364	+7983327	1	8
1365	+7983328	1	8
1366	+7983329	1	8
1367	+798333	1	7
1368	+798334	1	7
1369	+798335	1	7
1370	+7983360	1	8
1371	+7983361	1	8
1372	+7983362	1	8
1373	+7983363	1	8
1374	+7983364	1	8
1375	+7983365	1	8
1376	+7983366	1	8
1377	+7983367	1	8
1378	+7983368	1	8
1379	+7983369	1	8
1380	+798337	1	7
1381	+798338	1	7
1382	+798339	1	7
1383	+798340	1	7
1384	+798341	1	7
1385	+798342	1	7
1386	+798343	1	7
1387	+798344	1	7
1388	+798345	1	7
1389	+798346	1	7
1390	+798350	1	7
1391	+7983510	1	8
1392	+7983511	1	8
1393	+7983512	1	8
1394	+7983513	1	8
1395	+7983514	1	8
1396	+7983515	1	8
1397	+7983516	1	8
1398	+7983517	1	8
1399	+7983518	1	8
1400	+7983519	1	8
1401	+798352	1	7
1402	+798353	1	7
1403	+798354	1	7
1404	+798355	1	7
1405	+798356	1	7
1406	+798357	1	7
1407	+7983580	1	8
1408	+7983581	1	8
1409	+7983582	1	8
1410	+7983583	1	8
1411	+7983584	1	8
1412	+7983585	1	8
1413	+7983586	1	8
1414	+7983587	1	8
1415	+7983588	1	8
1416	+7983589	1	8
1417	+7983590	1	8
1418	+7983591	1	8
1419	+7983592	1	8
1420	+7983593	1	8
1421	+7983594	1	8
1422	+7983595	1	8
1423	+7983596	1	8
1424	+7983597	1	8
1425	+7983598	1	8
1426	+7983599	1	8
1427	+798360	1	7
1428	+798361	1	7
1429	+798362	1	7
1430	+798410	1	7
1431	+798411	1	7
1432	+7984120	1	8
1433	+7984121	1	8
1434	+7984122	1	8
1435	+7984123	1	8
1436	+7984124	1	8
1437	+7984125	1	8
1438	+7984126	1	8
1439	+7984127	1	8
1440	+7984128	1	8
1441	+7984129	1	8
1442	+798413	1	7
1443	+798414	1	7
1444	+798415	1	7
1445	+798416	1	7
1446	+798417	1	7
1447	+7984180	1	8
1448	+7984181	1	8
1449	+7984182	1	8
1450	+7984183	1	8
1451	+7984184	1	8
1452	+7984188	1	8
1453	+7984189	1	8
1454	+798419	1	7
1455	+798510	1	7
1456	+7985210	1	8
1457	+79852110	1	9
1458	+79852111	1	9
1459	+79852112	1	9
1460	+79852113	1	9
1461	+79852114	1	9
1462	+79852115	1	9
1463	+79852116	1	9
1464	+79852117	1	9
1465	+79852118	1	9
1466	+79852119	1	9
1467	+79852120	1	9
1468	+79852121	1	9
1469	+79852122	1	9
1470	+79852123	1	9
1471	+79852124	1	9
1472	+79852125	1	9
1473	+79852126	1	9
1474	+79852127	1	9
1475	+79852128	1	9
1476	+79852129	1	9
1477	+79852130	1	9
1478	+79852131	1	9
1479	+79852132	1	9
1480	+79852133	1	9
1481	+79852134	1	9
1482	+79852135	1	9
1483	+79852136	1	9
1484	+79852137	1	9
1485	+79852138	1	9
1486	+79852139	1	9
1487	+79852140	1	9
1488	+79852141	1	9
1489	+79852142	1	9
1490	+79852143	1	9
1491	+79852144	1	9
1492	+79852145	1	9
1493	+79852146	1	9
1494	+79852147	1	9
1495	+79852148	1	9
1496	+79852149	1	9
1497	+79852150	1	9
1498	+79852151	1	9
1499	+79852152	1	9
1500	+79852153	1	9
1501	+79852154	1	9
1502	+79852155	1	9
1503	+79852156	1	9
1504	+79852157	1	9
1505	+79852158	1	9
1506	+79852159	1	9
1507	+79852160	1	9
1508	+79852161	1	9
1509	+79852162	1	9
1510	+79852163	1	9
1511	+79852164	1	9
1512	+79852165	1	9
1513	+79852166	1	9
1514	+79852167	1	9
1515	+79852168	1	9
1516	+79852169	1	9
1517	+79852170	1	9
1518	+79852171	1	9
1519	+79852172	1	9
1520	+79852173	1	9
1521	+79852174	1	9
1522	+79852175	1	9
1523	+79852176	1	9
1524	+79852177	1	9
1525	+79852178	1	9
1526	+79852179	1	9
1527	+79852180	1	9
1528	+79852181	1	9
1529	+79852182	1	9
1530	+79852183	1	9
1531	+79852184	1	9
1532	+79852185	1	9
1533	+79852186	1	9
1534	+79852187	1	9
1535	+79852188	1	9
1536	+79852189	1	9
1537	+79852190	1	9
1538	+79852191	1	9
1539	+79852192	1	9
1540	+798522	1	7
1541	+798523	1	7
1542	+798524	1	7
1543	+798525	1	7
1544	+798526	1	7
1545	+798527	1	7
1546	+798528	1	7
1547	+798529	1	7
1548	+798530	1	7
1549	+798531	1	7
1550	+798533	1	7
1551	+798534	1	7
1552	+798535	1	7
1553	+798536	1	7
1554	+7985380	1	8
1555	+7985381	1	8
1556	+7985382	1	8
1557	+7985383	1	8
1558	+7985384	1	8
1559	+7985385	1	8
1560	+7985386	1	8
1561	+7985387	1	8
1562	+7985388	1	8
1563	+7985389	1	8
1564	+7985390	1	8
1565	+7985391	1	8
1566	+7985392	1	8
1567	+7985393	1	8
1568	+7985394	1	8
1569	+7985395	1	8
1570	+7985396	1	8
1571	+7985397	1	8
1572	+7985398	1	8
1573	+7985399	1	8
1574	+7985400	1	8
1575	+7985401	1	8
1576	+7985402	1	8
1577	+7985403	1	8
1578	+7985404	1	8
1579	+7985405	1	8
1580	+7985406	1	8
1581	+7985407	1	8
1582	+7985408	1	8
1583	+7985409	1	8
1584	+7985410	1	8
1585	+7985411	1	8
1586	+7985412	1	8
1587	+7985413	1	8
1588	+7985414	1	8
1589	+7985415	1	8
1590	+7985416	1	8
1591	+7985417	1	8
1592	+7985418	1	8
1593	+7985419	1	8
1594	+7985420	1	8
1595	+7985421	1	8
1596	+7985422	1	8
1597	+7985423	1	8
1598	+7985424	1	8
1599	+7985425	1	8
1600	+7985426	1	8
1601	+7985427	1	8
1602	+7985428	1	8
1603	+7985429	1	8
1604	+7985430	1	8
1605	+7985431	1	8
1606	+7985432	1	8
1607	+7985433	1	8
1608	+7985434	1	8
1609	+7985435	1	8
1610	+7985436	1	8
1611	+7985437	1	8
1612	+7985438	1	8
1613	+7985439	1	8
1614	+7985440	1	8
1615	+7985441	1	8
1616	+7985442	1	8
1617	+7985443	1	8
1618	+7985444	1	8
1619	+7985445	1	8
1620	+7985446	1	8
1621	+7985447	1	8
1622	+7985448	1	8
1623	+7985449	1	8
1624	+7985450	1	8
1625	+7985451	1	8
1626	+7985452	1	8
1627	+7985453	1	8
1628	+7985454	1	8
1629	+7985455	1	8
1630	+7985456	1	8
1631	+7985457	1	8
1632	+7985458	1	8
1633	+7985459	1	8
1634	+7985460	1	8
1635	+7985461	1	8
1636	+7985462	1	8
1637	+7985463	1	8
1638	+7985464	1	8
1639	+7985465	1	8
1640	+7985466	1	8
1641	+7985467	1	8
1642	+7985468	1	8
1643	+7985469	1	8
1644	+7985470	1	8
1645	+7985471	1	8
1646	+7985472	1	8
1647	+7985473	1	8
1648	+7985474	1	8
1649	+7985475	1	8
1650	+7985476	1	8
1651	+7985477	1	8
1652	+7985478	1	8
1653	+7985479	1	8
1654	+7985480	1	8
1655	+7985481	1	8
1656	+7985482	1	8
1657	+7985483	1	8
1658	+7985484	1	8
1659	+7985485	1	8
1660	+7985486	1	8
1661	+7985487	1	8
1662	+7985488	1	8
1663	+7985489	1	8
1664	+7985490	1	8
1665	+7985491	1	8
1666	+7985492	1	8
1667	+7985600	1	8
1668	+7985604	1	8
1669	+798564	1	7
1670	+7985704	1	8
1671	+798572	1	7
1672	+798576	1	7
1673	+798577	1	7
1674	+798578	1	7
1675	+798579	1	7
1676	+798580	1	7
1677	+798581	1	7
1678	+798582	1	7
1679	+798583	1	7
1680	+798584	1	7
1681	+798585	1	7
1682	+798586	1	7
1683	+798587	1	7
1684	+798588	1	7
1685	+798589	1	7
1686	+7985904	1	8
1687	+798591	1	7
1688	+798592	1	7
1689	+798596	1	7
1690	+798597	1	7
1691	+798599	1	7
1692	+798710	1	7
1693	+7987110	1	8
1694	+7987111	1	8
1695	+7987112	1	8
1696	+7987113	1	8
1697	+7987114	1	8
1698	+7987115	1	8
1699	+7987116	1	8
1700	+7987117	1	8
1701	+7987118	1	8
1702	+7987119	1	8
1703	+798712	1	7
1704	+798713	1	7
1705	+798714	1	7
1706	+798715	1	7
1707	+798716	1	7
1708	+798717	1	7
1709	+798718	1	7
1710	+7987190	1	8
1711	+7987191	1	8
1712	+7987192	1	8
1713	+7987193	1	8
1714	+7987194	1	8
1715	+7987195	1	8
1716	+7987196	1	8
1717	+7987197	1	8
1718	+7987198	1	8
1719	+7987199	1	8
1720	+7987200	1	8
1721	+7987201	1	8
1722	+7987202	1	8
1723	+7987203	1	8
1724	+7987204	1	8
1725	+7987205	1	8
1726	+7987206	1	8
1727	+7987207	1	8
1728	+7987208	1	8
1729	+7987209	1	8
1730	+7987210	1	8
1731	+7987211	1	8
1732	+7987212	1	8
1733	+7987213	1	8
1734	+7987214	1	8
1735	+7987215	1	8
1736	+7987216	1	8
1737	+7987217	1	8
1738	+7987218	1	8
1739	+7987219	1	8
1740	+7987220	1	8
1741	+7987221	1	8
1742	+7987222	1	8
1743	+7987223	1	8
1744	+7987224	1	8
1745	+7987225	1	8
1746	+7987226	1	8
1747	+7987227	1	8
1748	+7987228	1	8
1749	+7987229	1	8
1750	+7987230	1	8
1751	+7987231	1	8
1752	+7987232	1	8
1753	+7987233	1	8
1754	+7987234	1	8
1755	+7987235	1	8
1756	+7987236	1	8
1757	+7987237	1	8
1758	+7987238	1	8
1759	+7987239	1	8
1760	+798724	1	7
1761	+798725	1	7
1762	+798726	1	7
1763	+798727	1	7
1764	+798728	1	7
1765	+798729	1	7
1766	+798730	1	7
1767	+798731	1	7
1768	+798732	1	7
1769	+798733	1	7
1770	+798734	1	7
1771	+798735	1	7
1772	+798736	1	7
1773	+798737	1	7
1774	+798738	1	7
1775	+798739	1	7
1776	+798740	1	7
1777	+798741	1	7
1778	+798742	1	7
1779	+7987430	1	8
1780	+7987431	1	8
1781	+7987432	1	8
1782	+7987433	1	8
1783	+7987434	1	8
1784	+7987435	1	8
1785	+7987436	1	8
1786	+7987437	1	8
1787	+7987438	1	8
1788	+7987439	1	8
1789	+7987440	1	8
1790	+7987441	1	8
1791	+7987442	1	8
1792	+7987443	1	8
1793	+7987444	1	8
1794	+7987445	1	8
1795	+7987446	1	8
1796	+7987447	1	8
1797	+7987448	1	8
1798	+7987449	1	8
1799	+7987450	1	8
1800	+7987451	1	8
1801	+7987452	1	8
1802	+7987453	1	8
1803	+7987454	1	8
1804	+7987455	1	8
1805	+7987456	1	8
1806	+7987457	1	8
1807	+7987458	1	8
1808	+7987459	1	8
1809	+7987460	1	8
1810	+7987461	1	8
1811	+7987462	1	8
1812	+7987463	1	8
1813	+7987464	1	8
1814	+7987465	1	8
1815	+7987466	1	8
1816	+7987467	1	8
1817	+7987468	1	8
1818	+7987469	1	8
1819	+798747	1	7
1820	+798748	1	7
1821	+798749	1	7
1822	+798750	1	7
1823	+798751	1	7
1824	+798752	1	7
1825	+798753	1	7
1826	+798754	1	7
1827	+798755	1	7
1828	+7987560	1	8
1829	+7987561	1	8
1830	+7987562	1	8
1831	+7987563	1	8
1832	+7987564	1	8
1833	+7987565	1	8
1834	+7987566	1	8
1835	+7987567	1	8
1836	+7987568	1	8
1837	+7987569	1	8
1838	+7987570	1	8
1839	+7987571	1	8
1840	+7987572	1	8
1841	+7987573	1	8
1842	+7987574	1	8
1843	+7987575	1	8
1844	+7987576	1	8
1845	+7987577	1	8
1846	+7987578	1	8
1847	+7987579	1	8
1848	+798758	1	7
1849	+798759	1	7
1850	+798760	1	7
1851	+798761	1	7
1852	+798762	1	7
1853	+798763	1	7
1854	+798764	1	7
1855	+798765	1	7
1856	+798766	1	7
1857	+798767	1	7
1858	+7987680	1	8
1859	+7987681	1	8
1860	+7987682	1	8
1861	+7987683	1	8
1862	+7987684	1	8
1863	+7987685	1	8
1864	+7987686	1	8
1865	+7987687	1	8
1866	+7987688	1	8
1867	+7987689	1	8
1868	+798769	1	7
1869	+798770	1	7
1870	+798771	1	7
1871	+7987720	1	8
1872	+7987721	1	8
1873	+7987722	1	8
1874	+7987723	1	8
1875	+7987724	1	8
1876	+7987725	1	8
1877	+7987726	1	8
1878	+7987727	1	8
1879	+7987728	1	8
1880	+7987729	1	8
1881	+7987730	1	8
1882	+7987731	1	8
1883	+7987732	1	8
1884	+7987735	1	8
1885	+7987736	1	8
1886	+7987737	1	8
1887	+7987738	1	8
1888	+7987739	1	8
1889	+798774	1	7
1890	+798775	1	7
1891	+798776	1	7
1892	+798777	1	7
1893	+798778	1	7
1894	+798779	1	7
1895	+7987800	1	8
1896	+7987801	1	8
1897	+7987802	1	8
1898	+7987803	1	8
1899	+7987804	1	8
1900	+7987805	1	8
1901	+7987806	1	8
1902	+7987807	1	8
1903	+7987808	1	8
1904	+7987809	1	8
1905	+7987810	1	8
1906	+7987811	1	8
1907	+7987812	1	8
1908	+7987813	1	8
1909	+7987814	1	8
1910	+7987815	1	8
1911	+7987816	1	8
1912	+7987817	1	8
1913	+7987818	1	8
1914	+7987819	1	8
1915	+798782	1	7
1916	+798783	1	7
1917	+798784	1	7
1918	+798785	1	7
1919	+798786	1	7
1920	+798787	1	7
1921	+798788	1	7
1922	+798789	1	7
1923	+798790	1	7
1924	+798791	1	7
1925	+798792	1	7
1926	+798793	1	7
1927	+798794	1	7
1928	+798795	1	7
1929	+798796	1	7
1930	+798797	1	7
1931	+798798	1	7
1932	+798799	1	7
1933	+798800	1	7
1934	+798801	1	7
1935	+798802	1	7
1936	+798803	1	7
1937	+798804	1	7
1938	+798805	1	7
1939	+798806	1	7
1940	+798807	1	7
1941	+7988080	1	8
1942	+7988081	1	8
1943	+7988082	1	8
1944	+7988083	1	8
1945	+7988084	1	8
1946	+7988085	1	8
1947	+7988086	1	8
1948	+7988087	1	8
1949	+7988088	1	8
1950	+7988089	1	8
1951	+798809	1	7
1952	+798810	1	7
1953	+798811	1	7
1954	+798812	1	7
1955	+798813	1	7
1956	+798814	1	7
1957	+798815	1	7
1958	+798816	1	7
1959	+798817	1	7
1960	+798818	1	7
1961	+798820	1	7
1962	+798821	1	7
1963	+798822	1	7
1964	+798823	1	7
1965	+798824	1	7
1966	+798825	1	7
1967	+798826	1	7
1968	+798827	1	7
1969	+798828	1	7
1970	+798829	1	7
1971	+798830	1	7
1972	+7988310	1	8
1973	+7988311	1	8
1974	+7988312	1	8
1975	+7988313	1	8
1976	+7988314	1	8
1977	+7988315	1	8
1978	+7988316	1	8
1979	+7988317	1	8
1980	+7988318	1	8
1981	+7988319	1	8
1982	+7988320	1	8
1983	+7988321	1	8
1984	+7988322	1	8
1985	+7988323	1	8
1986	+7988324	1	8
1987	+7988325	1	8
1988	+7988326	1	8
1989	+7988327	1	8
1990	+7988328	1	8
1991	+7988329	1	8
1992	+7988330	1	8
1993	+7988331	1	8
1994	+7988332	1	8
1995	+7988333	1	8
1996	+7988334	1	8
1997	+7988335	1	8
1998	+7988336	1	8
1999	+7988337	1	8
2000	+7988338	1	8
2001	+7988339	1	8
2002	+7988340	1	8
2003	+7988341	1	8
2004	+7988342	1	8
2005	+7988343	1	8
2006	+7988344	1	8
2007	+7988345	1	8
2008	+7988346	1	8
2009	+7988347	1	8
2010	+7988348	1	8
2011	+7988349	1	8
2012	+7988350	1	8
2013	+7988351	1	8
2014	+7988352	1	8
2015	+7988353	1	8
2016	+7988354	1	8
2017	+7988355	1	8
2018	+7988356	1	8
2019	+7988357	1	8
2020	+7988358	1	8
2021	+7988359	1	8
2022	+7988360	1	8
2023	+7988361	1	8
2024	+7988362	1	8
2025	+7988363	1	8
2026	+7988364	1	8
2027	+7988365	1	8
2028	+7988366	1	8
2029	+7988367	1	8
2030	+7988368	1	8
2031	+7988369	1	8
2032	+7988370	1	8
2033	+7988371	1	8
2034	+7988372	1	8
2035	+7988373	1	8
2036	+7988374	1	8
2037	+7988375	1	8
2038	+7988376	1	8
2039	+7988377	1	8
2040	+7988378	1	8
2041	+7988379	1	8
2042	+7988380	1	8
2043	+7988381	1	8
2044	+7988382	1	8
2045	+7988383	1	8
2046	+7988384	1	8
2047	+7988385	1	8
2048	+7988386	1	8
2049	+7988387	1	8
2050	+7988388	1	8
2051	+7988389	1	8
2052	+798839	1	7
2053	+798840	1	7
2054	+798841	1	7
2055	+7988420	1	8
2056	+7988421	1	8
2057	+7988422	1	8
2058	+7988423	1	8
2059	+7988424	1	8
2060	+7988425	1	8
2061	+7988426	1	8
2062	+7988427	1	8
2063	+7988428	1	8
2064	+7988429	1	8
2065	+7988430	1	8
2066	+7988431	1	8
2067	+7988432	1	8
2068	+7988433	1	8
2069	+7988434	1	8
2070	+7988435	1	8
2071	+7988436	1	8
2072	+7988437	1	8
2073	+7988438	1	8
2074	+7988439	1	8
2075	+7988440	1	8
2076	+7988441	1	8
2077	+7988442	1	8
2078	+7988443	1	8
2079	+7988444	1	8
2080	+7988445	1	8
2081	+7988446	1	8
2082	+7988447	1	8
2083	+7988448	1	8
2084	+7988449	1	8
2085	+7988450	1	8
2086	+7988451	1	8
2087	+7988452	1	8
2088	+7988453	1	8
2089	+7988454	1	8
2090	+7988455	1	8
2091	+7988456	1	8
2092	+7988457	1	8
2093	+7988458	1	8
2094	+7988459	1	8
2095	+7988460	1	8
2096	+7988461	1	8
2097	+7988462	1	8
2098	+7988463	1	8
2099	+7988464	1	8
2100	+7988465	1	8
2101	+7988466	1	8
2102	+7988467	1	8
2103	+7988468	1	8
2104	+7988469	1	8
2105	+7988470	1	8
2106	+7988471	1	8
2107	+7988472	1	8
2108	+7988473	1	8
2109	+7988474	1	8
2110	+7988475	1	8
2111	+7988476	1	8
2112	+7988477	1	8
2113	+7988478	1	8
2114	+7988479	1	8
2115	+7988480	1	8
2116	+7988481	1	8
2117	+7988482	1	8
2118	+7988483	1	8
2119	+7988486	1	8
2120	+7988487	1	8
2121	+7988488	1	8
2122	+7988489	1	8
2123	+798849	1	7
2124	+7988500	1	8
2125	+7988501	1	8
2126	+7988502	1	8
2127	+7988503	1	8
2128	+7988504	1	8
2129	+7988505	1	8
2130	+7988506	1	8
2131	+7988507	1	8
2132	+7988508	1	8
2133	+7988509	1	8
2134	+798851	1	7
2135	+7988520	1	8
2136	+7988521	1	8
2137	+7988522	1	8
2138	+7988523	1	8
2139	+7988524	1	8
2140	+7988525	1	8
2141	+7988526	1	8
2142	+7988527	1	8
2143	+7988528	1	8
2144	+7988529	1	8
2145	+798853	1	7
2146	+798854	1	7
2147	+7988550	1	8
2148	+7988551	1	8
2149	+7988552	1	8
2150	+7988553	1	8
2151	+7988554	1	8
2152	+7988555	1	8
2153	+7988556	1	8
2154	+7988557	1	8
2155	+7988558	1	8
2156	+7988559	1	8
2157	+798856	1	7
2158	+798857	1	7
2159	+798858	1	7
2160	+7988590	1	8
2161	+7988591	1	8
2162	+7988592	1	8
2163	+7988593	1	8
2164	+7988594	1	8
2165	+7988595	1	8
2166	+7988596	1	8
2167	+7988597	1	8
2168	+7988598	1	8
2169	+7988599	1	8
2170	+7988600	1	8
2171	+7988601	1	8
2172	+7988602	1	8
2173	+7988603	1	8
2174	+7988604	1	8
2175	+7988605	1	8
2176	+7988606	1	8
2177	+7988607	1	8
2178	+7988608	1	8
2179	+7988609	1	8
2180	+7988610	1	8
2181	+7988611	1	8
2182	+7988612	1	8
2183	+7988613	1	8
2184	+7988614	1	8
2185	+7988615	1	8
2186	+7988616	1	8
2187	+7988617	1	8
2188	+7988618	1	8
2189	+7988619	1	8
2190	+7988620	1	8
2191	+7988621	1	8
2192	+7988622	1	8
2193	+7988623	1	8
2194	+7988624	1	8
2195	+7988625	1	8
2196	+7988626	1	8
2197	+7988627	1	8
2198	+7988628	1	8
2199	+7988629	1	8
2200	+7988630	1	8
2201	+7988631	1	8
2202	+7988632	1	8
2203	+7988633	1	8
2204	+7988634	1	8
2205	+7988635	1	8
2206	+7988636	1	8
2207	+7988637	1	8
2208	+7988638	1	8
2209	+7988639	1	8
2210	+7988640	1	8
2211	+7988641	1	8
2212	+7988642	1	8
2213	+7988643	1	8
2214	+7988644	1	8
2215	+7988645	1	8
2216	+7988646	1	8
2217	+7988647	1	8
2218	+7988648	1	8
2219	+7988649	1	8
2220	+7988650	1	8
2221	+7988651	1	8
2222	+7988652	1	8
2223	+7988653	1	8
2224	+7988654	1	8
2225	+7988655	1	8
2226	+7988656	1	8
2227	+7988657	1	8
2228	+7988658	1	8
2229	+7988659	1	8
2230	+7988660	1	8
2231	+7988661	1	8
2232	+7988662	1	8
2233	+7988663	1	8
2234	+7988664	1	8
2235	+7988665	1	8
2236	+7988666	1	8
2237	+7988667	1	8
2238	+7988668	1	8
2239	+7988669	1	8
2240	+7988670	1	8
2241	+7988671	1	8
2242	+7988672	1	8
2243	+7988673	1	8
2244	+7988674	1	8
2245	+7988675	1	8
2246	+7988676	1	8
2247	+7988677	1	8
2248	+7988678	1	8
2249	+7988679	1	8
2250	+798868	1	7
2251	+7988690	1	8
2252	+7988691	1	8
2253	+7988692	1	8
2254	+7988693	1	8
2255	+7988694	1	8
2256	+7988695	1	8
2257	+7988696	1	8
2258	+7988697	1	8
2259	+7988698	1	8
2260	+7988699	1	8
2261	+798870	1	7
2262	+798871	1	7
2263	+798872	1	7
2264	+798873	1	7
2265	+798874	1	7
2266	+798875	1	7
2267	+7988760	1	8
2268	+7988761	1	8
2269	+7988762	1	8
2270	+7988763	1	8
2271	+7988764	1	8
2272	+7988765	1	8
2273	+7988766	1	8
2274	+7988767	1	8
2275	+7988768	1	8
2276	+7988769	1	8
2277	+7988770	1	8
2278	+7988771	1	8
2279	+7988772	1	8
2280	+7988773	1	8
2281	+7988774	1	8
2282	+7988775	1	8
2283	+7988776	1	8
2284	+7988777	1	8
2285	+7988778	1	8
2286	+7988779	1	8
2287	+7988780	1	8
2288	+7988781	1	8
2289	+7988782	1	8
2290	+7988783	1	8
2291	+7988784	1	8
2292	+7988785	1	8
2293	+7988786	1	8
2294	+7988787	1	8
2295	+7988788	1	8
2296	+7988789	1	8
2297	+7988790	1	8
2298	+7988791	1	8
2299	+7988792	1	8
2300	+7988793	1	8
2301	+7988794	1	8
2302	+7988795	1	8
2303	+7988796	1	8
2304	+7988797	1	8
2305	+7988798	1	8
2306	+7988799	1	8
2307	+798880	1	7
2308	+798881	1	7
2309	+798882	1	7
2310	+798883	1	7
2311	+798884	1	7
2312	+798885	1	7
2313	+798886	1	7
2314	+798887	1	7
2315	+798888	1	7
2316	+798889	1	7
2317	+798890	1	7
2318	+798891	1	7
2319	+798892	1	7
2320	+798893	1	7
2321	+798894	1	7
2322	+7988950	1	8
2323	+7988951	1	8
2324	+7988952	1	8
2325	+7988953	1	8
2326	+7988954	1	8
2327	+7988955	1	8
2328	+7988956	1	8
2329	+7988957	1	8
2330	+7988958	1	8
2331	+7988959	1	8
2332	+7988960	1	8
2333	+7988961	1	8
2334	+7988962	1	8
2335	+7988963	1	8
2336	+7988964	1	8
2337	+7988965	1	8
2338	+7988966	1	8
2339	+7988967	1	8
2340	+7988968	1	8
2341	+7988969	1	8
2342	+7988970	1	8
2343	+7988971	1	8
2344	+7988972	1	8
2345	+7988973	1	8
2346	+7988974	1	8
2347	+7988975	1	8
2348	+7988976	1	8
2349	+7988977	1	8
2350	+7988978	1	8
2351	+7988979	1	8
2352	+7988980	1	8
2353	+7988981	1	8
2354	+7988982	1	8
2355	+7988983	1	8
2356	+7988984	1	8
2357	+7988985	1	8
2358	+7988986	1	8
2359	+7988987	1	8
2360	+7988988	1	8
2361	+7988989	1	8
2362	+798899	1	7
2363	+798900	1	7
2364	+798901	1	7
2365	+7989020	1	8
2366	+7989021	1	8
2367	+7989022	1	8
2368	+7989023	1	8
2369	+7989024	1	8
2370	+7989025	1	8
2371	+7989026	1	8
2372	+7989027	1	8
2373	+7989028	1	8
2374	+7989029	1	8
2375	+7989030	1	8
2376	+7989031	1	8
2377	+7989032	1	8
2378	+7989033	1	8
2379	+7989034	1	8
2380	+7989035	1	8
2381	+7989036	1	8
2382	+7989037	1	8
2383	+7989038	1	8
2384	+7989039	1	8
2385	+7989040	1	8
2386	+7989041	1	8
2387	+7989042	1	8
2388	+7989043	1	8
2389	+7989044	1	8
2390	+7989045	1	8
2391	+7989046	1	8
2392	+7989047	1	8
2393	+7989048	1	8
2394	+7989049	1	8
2395	+798908	1	7
2396	+798909	1	7
2397	+798910	1	7
2398	+798911	1	7
2399	+798912	1	7
2400	+798913	1	7
2401	+7989140	1	8
2402	+7989141	1	8
2403	+7989142	1	8
2404	+7989143	1	8
2405	+7989144	1	8
2406	+798915	1	7
2407	+798916	1	7
2408	+7989170	1	8
2409	+7989171	1	8
2410	+7989172	1	8
2411	+7989173	1	8
2412	+7989174	1	8
2413	+7989175	1	8
2414	+7989176	1	8
2415	+7989177	1	8
2416	+7989178	1	8
2417	+7989179	1	8
2418	+7989180	1	8
2419	+7989181	1	8
2420	+7989182	1	8
2421	+7989183	1	8
2422	+7989184	1	8
2423	+7989185	1	8
2424	+7989186	1	8
2425	+7989187	1	8
2426	+7989188	1	8
2427	+7989189	1	8
2428	+7989190	1	8
2429	+7989191	1	8
2430	+7989192	1	8
2431	+7989193	1	8
2432	+7989194	1	8
2433	+7989195	1	8
2434	+7989196	1	8
2435	+7989197	1	8
2436	+7989198	1	8
2437	+7989199	1	8
2438	+7989200	1	8
2439	+7989201	1	8
2440	+7989202	1	8
2441	+7989203	1	8
2442	+7989204	1	8
2443	+7989205	1	8
2444	+7989206	1	8
2445	+7989207	1	8
2446	+7989208	1	8
2447	+7989209	1	8
2448	+7989210	1	8
2449	+7989211	1	8
2450	+7989212	1	8
2451	+7989213	1	8
2452	+7989214	1	8
2453	+7989215	1	8
2454	+7989216	1	8
2455	+7989217	1	8
2456	+7989218	1	8
2457	+7989219	1	8
2458	+7989220	1	8
2459	+7989221	1	8
2460	+7989222	1	8
2461	+7989223	1	8
2462	+7989224	1	8
2463	+7989225	1	8
2464	+7989226	1	8
2465	+7989227	1	8
2466	+7989228	1	8
2467	+7989229	1	8
2468	+7989230	1	8
2469	+7989231	1	8
2470	+7989232	1	8
2471	+7989233	1	8
2472	+7989234	1	8
2473	+7989235	1	8
2474	+7989236	1	8
2475	+7989237	1	8
2476	+7989238	1	8
2477	+7989239	1	8
2478	+7989240	1	8
2479	+7989241	1	8
2480	+7989242	1	8
2481	+7989243	1	8
2482	+7989244	1	8
2483	+7989245	1	8
2484	+7989246	1	8
2485	+7989247	1	8
2486	+7989248	1	8
2487	+7989249	1	8
2488	+7989250	1	8
2489	+7989251	1	8
2490	+7989252	1	8
2491	+7989253	1	8
2492	+7989254	1	8
2493	+7989255	1	8
2494	+7989256	1	8
2495	+7989257	1	8
2496	+7989258	1	8
2497	+7989259	1	8
2498	+7989260	1	8
2499	+7989261	1	8
2500	+7989262	1	8
2501	+7989263	1	8
2502	+7989264	1	8
2503	+7989265	1	8
2504	+7989266	1	8
2505	+7989267	1	8
2506	+7989268	1	8
2507	+7989269	1	8
2508	+7989270	1	8
2509	+7989271	1	8
2510	+7989272	1	8
2511	+7989273	1	8
2512	+7989274	1	8
2513	+7989275	1	8
2514	+7989276	1	8
2515	+7989277	1	8
2516	+7989278	1	8
2517	+7989279	1	8
2518	+7989280	1	8
2519	+7989281	1	8
2520	+7989282	1	8
2521	+7989283	1	8
2522	+7989284	1	8
2523	+7989285	1	8
2524	+7989286	1	8
2525	+7989287	1	8
2526	+7989288	1	8
2527	+7989289	1	8
2528	+7989290	1	8
2529	+7989291	1	8
2530	+7989292	1	8
2531	+7989293	1	8
2532	+7989294	1	8
2533	+7989295	1	8
2534	+7989296	1	8
2535	+7989297	1	8
2536	+7989298	1	8
2537	+7989299	1	8
2538	+7989300	1	8
2539	+7989301	1	8
2540	+7989302	1	8
2541	+7989303	1	8
2542	+7989304	1	8
2543	+7989305	1	8
2544	+7989306	1	8
2545	+7989307	1	8
2546	+7989308	1	8
2547	+7989309	1	8
2548	+7989310	1	8
2549	+7989311	1	8
2550	+7989312	1	8
2551	+7989313	1	8
2552	+7989314	1	8
2553	+7989315	1	8
2554	+7989316	1	8
2555	+7989317	1	8
2556	+7989318	1	8
2557	+7989319	1	8
2558	+7989320	1	8
2559	+7989321	1	8
2560	+7989322	1	8
2561	+7989323	1	8
2562	+7989324	1	8
2563	+7989325	1	8
2564	+7989326	1	8
2565	+7989327	1	8
2566	+7989328	1	8
2567	+7989329	1	8
2568	+7989330	1	8
2569	+7989331	1	8
2570	+7989332	1	8
2571	+7989333	1	8
2572	+7989334	1	8
2573	+7989335	1	8
2574	+7989336	1	8
2575	+7989337	1	8
2576	+7989338	1	8
2577	+7989339	1	8
2578	+7989340	1	8
2579	+7989341	1	8
2580	+7989342	1	8
2581	+7989343	1	8
2582	+7989344	1	8
2583	+7989345	1	8
2584	+7989346	1	8
2585	+7989347	1	8
2586	+7989348	1	8
2587	+7989349	1	8
2588	+7989350	1	8
2589	+7989351	1	8
2590	+7989352	1	8
2591	+7989353	1	8
2592	+7989354	1	8
2593	+7989355	1	8
2594	+7989356	1	8
2595	+7989357	1	8
2596	+7989358	1	8
2597	+7989359	1	8
2598	+7989360	1	8
2599	+7989361	1	8
2600	+7989362	1	8
2601	+7989370	1	8
2602	+7989371	1	8
2603	+7989372	1	8
2604	+7989373	1	8
2605	+7989374	1	8
2606	+7989375	1	8
2607	+7989376	1	8
2608	+7989377	1	8
2609	+7989378	1	8
2610	+7989379	1	8
2611	+7989380	1	8
2612	+7989381	1	8
2613	+7989382	1	8
2614	+7989383	1	8
2615	+7989384	1	8
2616	+7989385	1	8
2617	+7989386	1	8
2618	+7989387	1	8
2619	+7989388	1	8
2620	+7989389	1	8
2621	+7989390	1	8
2622	+7989391	1	8
2623	+7989392	1	8
2624	+7989393	1	8
2625	+7989394	1	8
2626	+7989395	1	8
2627	+7989396	1	8
2628	+7989397	1	8
2629	+7989398	1	8
2630	+7989399	1	8
2631	+7989400	1	8
2632	+7989401	1	8
2633	+7989402	1	8
2634	+7989403	1	8
2635	+7989404	1	8
2636	+7989405	1	8
2637	+7989406	1	8
2638	+7989407	1	8
2639	+7989408	1	8
2640	+7989409	1	8
2641	+7989410	1	8
2642	+7989411	1	8
2643	+7989412	1	8
2644	+7989413	1	8
2645	+7989414	1	8
2646	+7989415	1	8
2647	+7989416	1	8
2648	+7989417	1	8
2649	+7989418	1	8
2650	+7989419	1	8
2651	+7989420	1	8
2652	+7989421	1	8
2653	+7989422	1	8
2654	+7989423	1	8
2655	+7989424	1	8
2656	+7989425	1	8
2657	+7989426	1	8
2658	+7989427	1	8
2659	+7989428	1	8
2660	+7989429	1	8
2661	+7989430	1	8
2662	+7989431	1	8
2663	+7989432	1	8
2664	+7989433	1	8
2665	+7989434	1	8
2666	+7989435	1	8
2667	+798944	1	7
2668	+798945	1	7
2669	+798946	1	7
2670	+798947	1	7
2671	+798948	1	7
2672	+798949	1	7
2673	+798950	1	7
2674	+798951	1	7
2675	+798952	1	7
2676	+798953	1	7
2677	+798954	1	7
2678	+798955	1	7
2679	+798956	1	7
2680	+798957	1	7
2681	+798958	1	7
2682	+798959	1	7
2683	+798960	1	7
2684	+798961	1	7
2685	+798962	1	7
2686	+798963	1	7
2687	+798964	1	7
2688	+798965	1	7
2689	+798966	1	7
2690	+798967	1	7
2691	+7989680	1	8
2692	+7989681	1	8
2693	+7989682	1	8
2694	+7989683	1	8
2695	+7989684	1	8
2696	+7989685	1	8
2697	+7989686	1	8
2698	+7989690	1	8
2699	+7989691	1	8
2700	+7989692	1	8
2701	+7989693	1	8
2702	+7989694	1	8
2703	+7989695	1	8
2704	+7989696	1	8
2705	+7989697	1	8
2706	+7989698	1	8
2707	+7989699	1	8
2708	+798970	1	7
2709	+798971	1	7
2710	+798972	1	7
2711	+798973	1	7
2712	+798974	1	7
2713	+798975	1	7
2714	+798976	1	7
2715	+798977	1	7
2716	+798978	1	7
2717	+798979	1	7
2718	+798980	1	7
2719	+798981	1	7
2720	+798982	1	7
2721	+798983	1	7
2722	+798984	1	7
2723	+798985	1	7
2724	+798986	1	7
2725	+798987	1	7
2726	+798988	1	7
2727	+798989	1	7
2728	+798990	1	7
2729	+798991	1	7
2730	+798992	1	7
2731	+798993	1	7
2732	+798994	1	7
2733	+798995	1	7
2734	+798996	1	7
2735	+798997	1	7
2736	+798998	1	7
2737	+798999	1	7
2738	+790300	2	7
2739	+790301	2	7
2740	+7903020	2	8
2741	+7903021	2	8
2742	+7903022	2	8
2743	+7903023	2	8
2744	+7903024	2	8
2745	+7903025	2	8
2746	+7903026	2	8
2747	+7903027	2	8
2748	+7903028	2	8
2749	+7903029	2	8
2750	+7903030	2	8
2751	+7903031	2	8
2752	+7903032	2	8
2753	+7903033	2	8
2754	+7903034	2	8
2755	+7903035	2	8
2756	+7903036	2	8
2757	+7903037	2	8
2758	+7903038	2	8
2759	+7903039	2	8
2760	+7903040	2	8
2761	+7903041	2	8
2762	+7903042	2	8
2763	+7903043	2	8
2764	+7903044	2	8
2765	+7903045	2	8
2766	+7903046	2	8
2767	+7903047	2	8
2768	+7903048	2	8
2769	+7903049	2	8
2770	+7903050	2	8
2771	+7903051	2	8
2772	+7903052	2	8
2773	+7903053	2	8
2774	+7903054	2	8
2775	+7903055	2	8
2776	+7903056	2	8
2777	+7903057	2	8
2778	+7903058	2	8
2779	+7903059	2	8
2780	+7903060	2	8
2781	+7903061	2	8
2782	+7903062	2	8
2783	+7903063	2	8
2784	+7903064	2	8
2785	+7903065	2	8
2786	+7903066	2	8
2787	+7903067	2	8
2788	+7903068	2	8
2789	+7903069	2	8
2790	+7903070	2	8
2791	+7903071	2	8
2792	+7903072	2	8
2793	+7903073	2	8
2794	+7903074	2	8
2795	+7903075	2	8
2796	+7903076	2	8
2797	+7903077	2	8
2798	+7903078	2	8
2799	+7903079	2	8
2800	+7903080	2	8
2801	+7903081	2	8
2802	+7903082	2	8
2803	+7903083	2	8
2804	+7903084	2	8
2805	+7903085	2	8
2806	+7903086	2	8
2807	+7903087	2	8
2808	+7903088	2	8
2809	+7903089	2	8
2810	+7903090	2	8
2811	+7903091	2	8
2812	+7903092	2	8
2813	+7903093	2	8
2814	+7903094	2	8
2815	+7903095	2	8
2816	+7903096	2	8
2817	+7903097	2	8
2818	+7903098	2	8
2819	+7903099	2	8
2820	+79031	2	6
2821	+79032	2	6
2822	+7903300	2	8
2823	+7903301	2	8
2824	+7903302	2	8
2825	+7903303	2	8
2826	+7903304	2	8
2827	+7903305	2	8
2828	+7903306	2	8
2829	+7903307	2	8
2830	+7903308	2	8
2831	+7903309	2	8
2832	+7903310	2	8
2833	+7903311	2	8
2834	+7903312	2	8
2835	+7903313	2	8
2836	+7903314	2	8
2837	+7903315	2	8
2838	+7903316	2	8
2839	+7903317	2	8
2840	+7903318	2	8
2841	+7903319	2	8
2842	+7903320	2	8
2843	+7903321	2	8
2844	+7903322	2	8
2845	+7903323	2	8
2846	+7903324	2	8
2847	+7903325	2	8
2848	+7903326	2	8
2849	+7903327	2	8
2850	+7903328	2	8
2851	+7903329	2	8
2852	+7903330	2	8
2853	+7903331	2	8
2854	+7903332	2	8
2855	+7903333	2	8
2856	+7903334	2	8
2857	+7903335	2	8
2858	+7903336	2	8
2859	+7903337	2	8
2860	+7903338	2	8
2861	+7903339	2	8
2862	+7903340	2	8
2863	+7903341	2	8
2864	+7903342	2	8
2865	+7903343	2	8
2866	+7903344	2	8
2867	+7903345	2	8
2868	+7903346	2	8
2869	+7903347	2	8
2870	+7903348	2	8
2871	+7903349	2	8
2872	+7903350	2	8
2873	+7903351	2	8
2874	+7903352	2	8
2875	+7903353	2	8
2876	+7903354	2	8
2877	+7903355	2	8
2878	+7903356	2	8
2879	+7903357	2	8
2880	+7903358	2	8
2881	+7903359	2	8
2882	+7903360	2	8
2883	+7903361	2	8
2884	+7903362	2	8
2885	+7903363	2	8
2886	+7903364	2	8
2887	+7903365	2	8
2888	+7903366	2	8
2889	+7903367	2	8
2890	+7903368	2	8
2891	+7903369	2	8
2892	+7903370	2	8
2893	+7903371	2	8
2894	+7903372	2	8
2895	+7903373	2	8
2896	+7903374	2	8
2897	+7903375	2	8
2898	+7903376	2	8
2899	+7903377	2	8
2900	+7903378	2	8
2901	+7903379	2	8
2902	+7903380	2	8
2903	+7903381	2	8
2904	+7903382	2	8
2905	+7903383	2	8
2906	+7903384	2	8
2907	+7903385	2	8
2908	+7903386	2	8
2909	+7903387	2	8
2910	+7903388	2	8
2911	+7903389	2	8
2912	+790339	2	7
2913	+7903400	2	8
2914	+7903401	2	8
2915	+7903402	2	8
2916	+7903403	2	8
2917	+7903404	2	8
2918	+7903405	2	8
2919	+7903406	2	8
2920	+7903407	2	8
2921	+7903408	2	8
2922	+7903409	2	8
2923	+7903410	2	8
2924	+7903411	2	8
2925	+7903412	2	8
2926	+7903413	2	8
2927	+7903414	2	8
2928	+7903415	2	8
2929	+7903416	2	8
2930	+7903417	2	8
2931	+7903418	2	8
2932	+7903419	2	8
2933	+7903420	2	8
2934	+7903421	2	8
2935	+7903422	2	8
2936	+7903423	2	8
2937	+7903424	2	8
2938	+7903425	2	8
2939	+7903426	2	8
2940	+7903427	2	8
2941	+7903428	2	8
2942	+7903429	2	8
2943	+790343	2	7
2944	+7903440	2	8
2945	+7903441	2	8
2946	+7903442	2	8
2947	+7903443	2	8
2948	+7903444	2	8
2949	+7903445	2	8
2950	+7903446	2	8
2951	+7903447	2	8
2952	+7903448	2	8
2953	+7903449	2	8
2954	+790345	2	7
2955	+7903460	2	8
2956	+7903461	2	8
2957	+7903462	2	8
2958	+7903463	2	8
2959	+7903464	2	8
2960	+7903465	2	8
2961	+7903466	2	8
2962	+7903467	2	8
2963	+7903468	2	8
2964	+7903469	2	8
2965	+7903470	2	8
2966	+7903471	2	8
2967	+7903472	2	8
2968	+7903473	2	8
2969	+7903474	2	8
2970	+7903475	2	8
2971	+7903476	2	8
2972	+7903477	2	8
2973	+7903478	2	8
2974	+7903479	2	8
2975	+7903480	2	8
2976	+7903481	2	8
2977	+7903482	2	8
2978	+7903483	2	8
2979	+7903484	2	8
2980	+7903485	2	8
2981	+7903486	2	8
2982	+7903487	2	8
2983	+7903488	2	8
2984	+7903489	2	8
2985	+7903490	2	8
2986	+7903491	2	8
2987	+7903492	2	8
2988	+7903493	2	8
2989	+7903494	2	8
2990	+7903495	2	8
2991	+7903496	2	8
2992	+7903497	2	8
2993	+7903498	2	8
2994	+7903499	2	8
2995	+79035	2	6
2996	+790360	2	7
2997	+790361	2	7
2998	+790362	2	7
2999	+7903630	2	8
3000	+7903631	2	8
3001	+7903632	2	8
3002	+7903633	2	8
3003	+7903634	2	8
3004	+7903635	2	8
3005	+7903636	2	8
3006	+7903637	2	8
3007	+7903638	2	8
3008	+7903639	2	8
3009	+7903640	2	8
3010	+7903641	2	8
3011	+7903642	2	8
3012	+7903643	2	8
3013	+7903644	2	8
3014	+7903645	2	8
3015	+7903646	2	8
3016	+7903647	2	8
3017	+7903648	2	8
3018	+7903649	2	8
3019	+7903650	2	8
3020	+7903651	2	8
3021	+7903652	2	8
3022	+7903653	2	8
3023	+7903654	2	8
3024	+7903655	2	8
3025	+7903656	2	8
3026	+7903657	2	8
3027	+7903658	2	8
3028	+7903659	2	8
3029	+790366	2	7
3030	+790367	2	7
3031	+790368	2	7
3032	+7903690	2	8
3033	+7903691	2	8
3034	+7903692	2	8
3035	+7903693	2	8
3036	+7903694	2	8
3037	+7903695	2	8
3038	+7903696	2	8
3039	+7903697	2	8
3040	+7903698	2	8
3041	+7903699	2	8
3042	+79037	2	6
3043	+790380	2	7
3044	+7903810	2	8
3045	+7903811	2	8
3046	+7903812	2	8
3047	+7903813	2	8
3048	+7903814	2	8
3049	+7903815	2	8
3050	+7903816	2	8
3051	+7903817	2	8
3052	+7903818	2	8
3053	+7903819	2	8
3054	+790382	2	7
3055	+7903830	2	8
3056	+7903831	2	8
3057	+7903832	2	8
3058	+7903833	2	8
3059	+7903834	2	8
3060	+7903835	2	8
3061	+7903836	2	8
3062	+7903837	2	8
3063	+7903838	2	8
3064	+7903839	2	8
3065	+7903840	2	8
3066	+7903841	2	8
3067	+7903842	2	8
3068	+7903843	2	8
3069	+7903844	2	8
3070	+7903845	2	8
3071	+7903846	2	8
3072	+7903847	2	8
3073	+7903848	2	8
3074	+7903849	2	8
3075	+790385	2	7
3076	+7903860	2	8
3077	+7903861	2	8
3078	+7903862	2	8
3079	+7903863	2	8
3080	+7903864	2	8
3081	+7903865	2	8
3082	+7903866	2	8
3083	+7903867	2	8
3084	+7903868	2	8
3085	+7903869	2	8
3086	+7903870	2	8
3087	+7903871	2	8
3088	+7903872	2	8
3089	+7903873	2	8
3090	+7903874	2	8
3091	+7903875	2	8
3092	+7903876	2	8
3093	+7903877	2	8
3094	+7903878	2	8
3095	+7903879	2	8
3096	+7903880	2	8
3097	+7903881	2	8
3098	+7903882	2	8
3099	+7903883	2	8
3100	+7903884	2	8
3101	+7903885	2	8
3102	+7903886	2	8
3103	+7903887	2	8
3104	+7903888	2	8
3105	+7903889	2	8
3106	+7903890	2	8
3107	+7903891	2	8
3108	+7903892	2	8
3109	+7903893	2	8
3110	+7903894	2	8
3111	+7903895	2	8
3112	+7903896	2	8
3113	+7903897	2	8
3114	+7903898	2	8
3115	+7903899	2	8
3116	+7903900	2	8
3117	+7903901	2	8
3118	+7903902	2	8
3119	+7903903	2	8
3120	+7903904	2	8
3121	+7903905	2	8
3122	+7903906	2	8
3123	+7903907	2	8
3124	+7903908	2	8
3125	+7903909	2	8
3126	+7903910	2	8
3127	+7903911	2	8
3128	+7903912	2	8
3129	+7903913	2	8
3130	+7903914	2	8
3131	+7903915	2	8
3132	+7903916	2	8
3133	+7903917	2	8
3134	+7903918	2	8
3135	+7903919	2	8
3136	+7903920	2	8
3137	+7903921	2	8
3138	+7903922	2	8
3139	+7903923	2	8
3140	+7903924	2	8
3141	+7903925	2	8
3142	+7903926	2	8
3143	+7903927	2	8
3144	+7903928	2	8
3145	+7903929	2	8
3146	+790393	2	7
3147	+7903940	2	8
3148	+7903941	2	8
3149	+7903942	2	8
3150	+7903943	2	8
3151	+7903944	2	8
3152	+7903945	2	8
3153	+7903946	2	8
3154	+7903947	2	8
3155	+7903948	2	8
3156	+7903949	2	8
3157	+7903950	2	8
3158	+7903951	2	8
3159	+7903952	2	8
3160	+7903953	2	8
3161	+7903954	2	8
3162	+7903955	2	8
3163	+7903956	2	8
3164	+7903957	2	8
3165	+7903958	2	8
3166	+7903959	2	8
3167	+790396	2	7
3168	+790397	2	7
3169	+7903980	2	8
3170	+7903981	2	8
3171	+7903982	2	8
3172	+7903983	2	8
3173	+7903984	2	8
3174	+7903985	2	8
3175	+7903986	2	8
3176	+7903987	2	8
3177	+7903988	2	8
3178	+7903989	2	8
3179	+7903990	2	8
3180	+7903991	2	8
3181	+7903992	2	8
3182	+7903993	2	8
3183	+7903994	2	8
3184	+7903995	2	8
3185	+7903996	2	8
3186	+7903997	2	8
3187	+7903998	2	8
3188	+7903999	2	8
3189	+7905000	2	8
3190	+7905001	2	8
3191	+7905002	2	8
3192	+7905003	2	8
3193	+7905004	2	8
3194	+7905005	2	8
3195	+7905006	2	8
3196	+7905007	2	8
3197	+7905008	2	8
3198	+7905009	2	8
3199	+7905010	2	8
3200	+7905011	2	8
3201	+7905012	2	8
3202	+7905013	2	8
3203	+7905014	2	8
3204	+7905015	2	8
3205	+7905016	2	8
3206	+7905017	2	8
3207	+7905018	2	8
3208	+7905019	2	8
3209	+7905020	2	8
3210	+7905021	2	8
3211	+7905022	2	8
3212	+7905023	2	8
3213	+7905024	2	8
3214	+7905025	2	8
3215	+7905026	2	8
3216	+7905027	2	8
3217	+7905028	2	8
3218	+7905029	2	8
3219	+7905030	2	8
3220	+7905031	2	8
3221	+7905032	2	8
3222	+7905033	2	8
3223	+7905034	2	8
3224	+7905035	2	8
3225	+7905036	2	8
3226	+7905037	2	8
3227	+7905038	2	8
3228	+7905039	2	8
3229	+7905040	2	8
3230	+7905041	2	8
3231	+7905042	2	8
3232	+7905043	2	8
3233	+7905044	2	8
3234	+7905045	2	8
3235	+7905046	2	8
3236	+7905047	2	8
3237	+7905048	2	8
3238	+7905049	2	8
3239	+7905050	2	8
3240	+7905051	2	8
3241	+7905052	2	8
3242	+7905053	2	8
3243	+7905054	2	8
3244	+7905055	2	8
3245	+7905056	2	8
3246	+7905057	2	8
3247	+7905058	2	8
3248	+7905059	2	8
3249	+7905060	2	8
3250	+7905061	2	8
3251	+7905062	2	8
3252	+7905063	2	8
3253	+7905064	2	8
3254	+7905065	2	8
3255	+7905066	2	8
3256	+7905067	2	8
3257	+7905068	2	8
3258	+7905069	2	8
3259	+7905070	2	8
3260	+7905071	2	8
3261	+7905072	2	8
3262	+7905073	2	8
3263	+7905074	2	8
3264	+7905075	2	8
3265	+7905076	2	8
3266	+7905077	2	8
3267	+7905078	2	8
3268	+7905079	2	8
3269	+7905080	2	8
3270	+7905081	2	8
3271	+7905082	2	8
3272	+7905083	2	8
3273	+7905084	2	8
3274	+7905085	2	8
3275	+7905086	2	8
3276	+7905087	2	8
3277	+7905088	2	8
3278	+7905089	2	8
3279	+7905090	2	8
3280	+7905091	2	8
3281	+7905092	2	8
3282	+7905093	2	8
3283	+7905094	2	8
3284	+7905095	2	8
3285	+7905096	2	8
3286	+7905097	2	8
3287	+7905098	2	8
3288	+7905099	2	8
3289	+7905100	2	8
3290	+7905101	2	8
3291	+7905102	2	8
3292	+7905103	2	8
3293	+7905104	2	8
3294	+7905105	2	8
3295	+7905106	2	8
3296	+7905107	2	8
3297	+7905108	2	8
3298	+7905109	2	8
3299	+790511	2	7
3300	+7905120	2	8
3301	+7905121	2	8
3302	+7905122	2	8
3303	+7905123	2	8
3304	+7905124	2	8
3305	+7905125	2	8
3306	+7905126	2	8
3307	+7905127	2	8
3308	+7905128	2	8
3309	+7905129	2	8
3310	+790513	2	7
3311	+790514	2	7
3312	+7905150	2	8
3313	+7905151	2	8
3314	+7905152	2	8
3315	+7905153	2	8
3316	+7905154	2	8
3317	+7905155	2	8
3318	+7905156	2	8
3319	+7905157	2	8
3320	+7905158	2	8
3321	+7905159	2	8
3322	+7905160	2	8
3323	+7905161	2	8
3324	+7905162	2	8
3325	+7905163	2	8
3326	+7905164	2	8
3327	+7905165	2	8
3328	+7905166	2	8
3329	+7905167	2	8
3330	+7905168	2	8
3331	+7905169	2	8
3332	+7905170	2	8
3333	+7905171	2	8
3334	+7905172	2	8
3335	+7905173	2	8
3336	+7905174	2	8
3337	+7905175	2	8
3338	+7905176	2	8
3339	+7905177	2	8
3340	+7905178	2	8
3341	+7905179	2	8
3342	+7905180	2	8
3343	+7905181	2	8
3344	+7905182	2	8
3345	+7905183	2	8
3346	+7905184	2	8
3347	+7905185	2	8
3348	+7905186	2	8
3349	+7905187	2	8
3350	+7905188	2	8
3351	+7905189	2	8
3352	+7905190	2	8
3353	+7905191	2	8
3354	+7905192	2	8
3355	+7905193	2	8
3356	+7905194	2	8
3357	+7905195	2	8
3358	+7905196	2	8
3359	+7905197	2	8
3360	+7905198	2	8
3361	+7905199	2	8
3362	+790520	2	7
3363	+790521	2	7
3364	+790522	2	7
3365	+7905230	2	8
3366	+7905231	2	8
3367	+7905232	2	8
3368	+7905233	2	8
3369	+7905234	2	8
3370	+7905235	2	8
3371	+7905236	2	8
3372	+7905237	2	8
3373	+7905238	2	8
3374	+7905239	2	8
3375	+790524	2	7
3376	+790525	2	7
3377	+790526	2	7
3378	+790527	2	7
3379	+790528	2	7
3380	+7905290	2	8
3381	+7905291	2	8
3382	+7905292	2	8
3383	+7905293	2	8
3384	+7905294	2	8
3385	+7905295	2	8
3386	+7905296	2	8
3387	+7905297	2	8
3388	+7905298	2	8
3389	+7905299	2	8
3390	+7905300	2	8
3391	+7905301	2	8
3392	+7905302	2	8
3393	+7905303	2	8
3394	+7905304	2	8
3395	+7905305	2	8
3396	+7905306	2	8
3397	+7905307	2	8
3398	+7905308	2	8
3399	+7905309	2	8
3400	+790531	2	7
3401	+790532	2	7
3402	+790533	2	7
3403	+7905340	2	8
3404	+7905341	2	8
3405	+7905342	2	8
3406	+7905343	2	8
3407	+7905344	2	8
3408	+7905345	2	8
3409	+7905346	2	8
3410	+7905347	2	8
3411	+7905348	2	8
3412	+7905349	2	8
3413	+790535	2	7
3414	+7905360	2	8
3415	+7905361	2	8
3416	+7905362	2	8
3417	+7905363	2	8
3418	+7905364	2	8
3419	+7905365	2	8
3420	+7905366	2	8
3421	+7905367	2	8
3422	+7905368	2	8
3423	+7905369	2	8
3424	+7905370	2	8
3425	+7905371	2	8
3426	+7905372	2	8
3427	+7905373	2	8
3428	+7905374	2	8
3429	+7905375	2	8
3430	+7905376	2	8
3431	+7905377	2	8
3432	+7905378	2	8
3433	+7905379	2	8
3434	+7905380	2	8
3435	+7905381	2	8
3436	+7905382	2	8
3437	+7905383	2	8
3438	+7905384	2	8
3439	+7905385	2	8
3440	+7905386	2	8
3441	+7905387	2	8
3442	+7905388	2	8
3443	+7905389	2	8
3444	+790539	2	7
3445	+7905400	2	8
3446	+7905401	2	8
3447	+7905402	2	8
3448	+7905403	2	8
3449	+7905404	2	8
3450	+7905405	2	8
3451	+7905406	2	8
3452	+7905407	2	8
3453	+7905408	2	8
3454	+7905409	2	8
3455	+790541	2	7
3456	+7905420	2	8
3457	+7905421	2	8
3458	+7905422	2	8
3459	+7905423	2	8
3460	+7905424	2	8
3461	+7905425	2	8
3462	+7905426	2	8
3463	+7905427	2	8
3464	+7905428	2	8
3465	+7905429	2	8
3466	+7905430	2	8
3467	+7905431	2	8
3468	+7905432	2	8
3469	+7905433	2	8
3470	+7905434	2	8
3471	+7905435	2	8
3472	+7905436	2	8
3473	+7905437	2	8
3474	+7905438	2	8
3475	+7905439	2	8
3476	+790544	2	7
3477	+790545	2	7
3478	+790546	2	7
3479	+7905470	2	8
3480	+7905471	2	8
3481	+7905472	2	8
3482	+7905473	2	8
3483	+7905474	2	8
3484	+7905475	2	8
3485	+7905476	2	8
3486	+7905477	2	8
3487	+7905478	2	8
3488	+7905479	2	8
3489	+7905480	2	8
3490	+7905481	2	8
3491	+7905482	2	8
3492	+7905483	2	8
3493	+7905484	2	8
3494	+7905485	2	8
3495	+7905486	2	8
3496	+7905487	2	8
3497	+7905488	2	8
3498	+7905489	2	8
3499	+7905490	2	8
3500	+7905491	2	8
3501	+7905492	2	8
3502	+7905493	2	8
3503	+7905494	2	8
3504	+7905495	2	8
3505	+7905496	2	8
3506	+7905497	2	8
3507	+7905498	2	8
3508	+7905499	2	8
3509	+79055	2	6
3510	+790560	2	7
3511	+790561	2	7
3512	+790562	2	7
3513	+790563	2	7
3514	+7905640	2	8
3515	+7905641	2	8
3516	+7905642	2	8
3517	+7905643	2	8
3518	+7905644	2	8
3519	+7905645	2	8
3520	+7905646	2	8
3521	+7905647	2	8
3522	+7905648	2	8
3523	+7905649	2	8
3524	+790565	2	7
3525	+790566	2	7
3526	+790567	2	7
3527	+790568	2	7
3528	+7905690	2	8
3529	+7905691	2	8
3530	+7905692	2	8
3531	+7905693	2	8
3532	+7905694	2	8
3533	+7905695	2	8
3534	+7905696	2	8
3535	+7905697	2	8
3536	+7905698	2	8
3537	+7905699	2	8
3538	+79057	2	6
3539	+790580	2	7
3540	+790581	2	7
3541	+7905820	2	8
3542	+7905821	2	8
3543	+7905822	2	8
3544	+7905823	2	8
3545	+7905824	2	8
3546	+7905825	2	8
3547	+7905826	2	8
3548	+7905827	2	8
3549	+7905828	2	8
3550	+7905829	2	8
3551	+790583	2	7
3552	+790584	2	7
3553	+7905850	2	8
3554	+7905851	2	8
3555	+7905852	2	8
3556	+7905853	2	8
3557	+7905854	2	8
3558	+7905855	2	8
3559	+7905856	2	8
3560	+7905857	2	8
3561	+7905858	2	8
3562	+7905859	2	8
3563	+7905860	2	8
3564	+7905861	2	8
3565	+7905862	2	8
3566	+7905863	2	8
3567	+7905864	2	8
3568	+7905865	2	8
3569	+7905866	2	8
3570	+7905867	2	8
3571	+7905868	2	8
3572	+7905869	2	8
3573	+7905870	2	8
3574	+7905871	2	8
3575	+7905872	2	8
3576	+7905873	2	8
3577	+7905874	2	8
3578	+7905875	2	8
3579	+7905876	2	8
3580	+7905877	2	8
3581	+7905878	2	8
3582	+7905879	2	8
3583	+790588	2	7
3584	+790589	2	7
3585	+790590	2	7
3586	+790591	2	7
3587	+7905920	2	8
3588	+7905921	2	8
3589	+7905922	2	8
3590	+7905923	2	8
3591	+7905924	2	8
3592	+7905925	2	8
3593	+7905926	2	8
3594	+7905927	2	8
3595	+7905928	2	8
3596	+7905929	2	8
3597	+790593	2	7
3598	+7905940	2	8
3599	+7905941	2	8
3600	+7905942	2	8
3601	+7905943	2	8
3602	+7905944	2	8
3603	+7905945	2	8
3604	+7905946	2	8
3605	+7905947	2	8
3606	+7905948	2	8
3607	+7905949	2	8
3608	+790595	2	7
3609	+790596	2	7
3610	+7905970	2	8
3611	+7905971	2	8
3612	+7905972	2	8
3613	+7905973	2	8
3614	+7905974	2	8
3615	+7905975	2	8
3616	+7905976	2	8
3617	+7905977	2	8
3618	+7905978	2	8
3619	+7905979	2	8
3620	+790598	2	7
3621	+7905990	2	8
3622	+7905991	2	8
3623	+7905992	2	8
3624	+7905993	2	8
3625	+7905994	2	8
3626	+7905995	2	8
3627	+7905996	2	8
3628	+7905997	2	8
3629	+7905998	2	8
3630	+7905999	2	8
3631	+79060	2	6
3632	+790610	2	7
3633	+7906110	2	8
3634	+7906111	2	8
3635	+7906112	2	8
3636	+7906113	2	8
3637	+7906114	2	8
3638	+7906115	2	8
3639	+7906116	2	8
3640	+7906117	2	8
3641	+7906118	2	8
3642	+7906119	2	8
3643	+7906120	2	8
3644	+7906121	2	8
3645	+7906122	2	8
3646	+7906123	2	8
3647	+7906124	2	8
3648	+7906125	2	8
3649	+7906126	2	8
3650	+7906127	2	8
3651	+7906128	2	8
3652	+7906129	2	8
3653	+7906130	2	8
3654	+7906131	2	8
3655	+7906132	2	8
3656	+7906133	2	8
3657	+7906134	2	8
3658	+7906135	2	8
3659	+7906136	2	8
3660	+7906137	2	8
3661	+7906138	2	8
3662	+7906139	2	8
3663	+7906140	2	8
3664	+7906141	2	8
3665	+7906142	2	8
3666	+7906143	2	8
3667	+7906144	2	8
3668	+7906145	2	8
3669	+7906146	2	8
3670	+7906147	2	8
3671	+7906148	2	8
3672	+7906149	2	8
3673	+7906150	2	8
3674	+7906151	2	8
3675	+7906152	2	8
3676	+7906153	2	8
3677	+7906154	2	8
3678	+7906155	2	8
3679	+7906156	2	8
3680	+7906157	2	8
3681	+7906158	2	8
3682	+7906159	2	8
3683	+7906160	2	8
3684	+7906161	2	8
3685	+7906162	2	8
3686	+7906163	2	8
3687	+7906164	2	8
3688	+790616	2	7
3689	+790617	2	7
3690	+7906176	2	8
3691	+7906177	2	8
3692	+7906178	2	8
3693	+7906179	2	8
3694	+7906180	2	8
3695	+7906181	2	8
3696	+7906182	2	8
3697	+7906183	2	8
3698	+7906184	2	8
3699	+7906185	2	8
3700	+7906186	2	8
3701	+7906187	2	8
3702	+7906188	2	8
3703	+7906189	2	8
3704	+7906190	2	8
3705	+7906191	2	8
3706	+7906192	2	8
3707	+7906193	2	8
3708	+7906194	2	8
3709	+7906195	2	8
3710	+7906196	2	8
3711	+7906197	2	8
3712	+7906198	2	8
3713	+7906199	2	8
3714	+7906200	2	8
3715	+7906201	2	8
3716	+7906202	2	8
3717	+7906203	2	8
3718	+7906204	2	8
3719	+7906205	2	8
3720	+7906206	2	8
3721	+7906207	2	8
3722	+7906208	2	8
3723	+7906209	2	8
3724	+790621	2	7
3725	+7906220	2	8
3726	+7906221	2	8
3727	+7906222	2	8
3728	+7906223	2	8
3729	+7906224	2	8
3730	+7906225	2	8
3731	+7906226	2	8
3732	+7906227	2	8
3733	+7906228	2	8
3734	+7906229	2	8
3735	+790623	2	7
3736	+790624	2	7
3737	+790625	2	7
3738	+790626	2	7
3739	+790627	2	7
3740	+7906280	2	8
3741	+7906281	2	8
3742	+7906282	2	8
3743	+7906283	2	8
3744	+7906284	2	8
3745	+7906285	2	8
3746	+7906286	2	8
3747	+7906287	2	8
3748	+7906288	2	8
3749	+7906289	2	8
3750	+7906290	2	8
3751	+7906291	2	8
3752	+7906292	2	8
3753	+7906293	2	8
3754	+7906294	2	8
3755	+7906295	2	8
3756	+7906296	2	8
3757	+7906297	2	8
3758	+7906298	2	8
3759	+7906299	2	8
3760	+790630	2	7
3761	+790631	2	7
3762	+790632	2	7
3763	+7906330	2	8
3764	+7906331	2	8
3765	+7906332	2	8
3766	+7906333	2	8
3767	+7906334	2	8
3768	+7906335	2	8
3769	+7906336	2	8
3770	+790633	2	7
3771	+790634	2	7
3772	+7906348	2	8
3773	+7906349	2	8
3774	+7906350	2	8
3775	+7906351	2	8
3776	+7906352	2	8
3777	+7906353	2	8
3778	+7906354	2	8
3779	+7906355	2	8
3780	+7906356	2	8
3781	+7906357	2	8
3782	+7906358	2	8
3783	+7906359	2	8
3784	+7906360	2	8
3785	+7906361	2	8
3786	+7906362	2	8
3787	+7906363	2	8
3788	+7906364	2	8
3789	+7906365	2	8
3790	+7906366	2	8
3791	+7906367	2	8
3792	+7906368	2	8
3793	+7906369	2	8
3794	+7906370	2	8
3795	+7906371	2	8
3796	+7906372	2	8
3797	+7906373	2	8
3798	+7906374	2	8
3799	+7906375	2	8
3800	+7906376	2	8
3801	+7906377	2	8
3802	+7906378	2	8
3803	+7906379	2	8
3804	+790638	2	7
3805	+7906390	2	8
3806	+7906391	2	8
3807	+7906392	2	8
3808	+7906393	2	8
3809	+7906394	2	8
3810	+7906395	2	8
3811	+7906396	2	8
3812	+7906397	2	8
3813	+7906398	2	8
3814	+7906399	2	8
3815	+790640	2	7
3816	+790641	2	7
3817	+7906411	2	8
3818	+7906412	2	8
3819	+7906413	2	8
3820	+7906414	2	8
3821	+7906415	2	8
3822	+7906416	2	8
3823	+7906417	2	8
3824	+7906418	2	8
3825	+7906419	2	8
3826	+7906420	2	8
3827	+7906421	2	8
3828	+7906422	2	8
3829	+7906423	2	8
3830	+7906424	2	8
3831	+7906425	2	8
3832	+7906426	2	8
3833	+7906427	2	8
3834	+7906428	2	8
3835	+7906429	2	8
3836	+7906430	2	8
3837	+7906431	2	8
3838	+7906432	2	8
3839	+7906433	2	8
3840	+7906434	2	8
3841	+7906435	2	8
3842	+7906436	2	8
3843	+7906437	2	8
3844	+7906438	2	8
3845	+7906439	2	8
3846	+7906440	2	8
3847	+7906441	2	8
3848	+7906442	2	8
3849	+7906443	2	8
3850	+7906444	2	8
3851	+7906445	2	8
3852	+7906446	2	8
3853	+7906447	2	8
3854	+7906448	2	8
3855	+7906449	2	8
3856	+7906450	2	8
3857	+7906451	2	8
3858	+7906452	2	8
3859	+7906453	2	8
3860	+7906454	2	8
3861	+7906455	2	8
3862	+7906456	2	8
3863	+7906457	2	8
3864	+7906458	2	8
3865	+7906459	2	8
3866	+790646	2	7
3867	+790647	2	7
3868	+7906480	2	8
3869	+7906481	2	8
3870	+7906482	2	8
3871	+7906483	2	8
3872	+7906484	2	8
3873	+7906485	2	8
3874	+7906486	2	8
3875	+7906487	2	8
3876	+7906488	2	8
3877	+7906489	2	8
3878	+7906490	2	8
3879	+7906491	2	8
3880	+7906492	2	8
3881	+7906493	2	8
3882	+7906494	2	8
3883	+7906495	2	8
3884	+7906496	2	8
3885	+7906497	2	8
3886	+7906498	2	8
3887	+7906499	2	8
3888	+7906500	2	8
3889	+7906501	2	8
3890	+7906502	2	8
3891	+7906503	2	8
3892	+7906504	2	8
3893	+7906505	2	8
3894	+7906506	2	8
3895	+7906507	2	8
3896	+7906508	2	8
3897	+7906509	2	8
3898	+7906510	2	8
3899	+7906511	2	8
3900	+7906512	2	8
3901	+7906513	2	8
3902	+7906514	2	8
3903	+7906515	2	8
3904	+7906516	2	8
3905	+7906517	2	8
3906	+7906518	2	8
3907	+7906519	2	8
3908	+7906520	2	8
3909	+7906521	2	8
3910	+7906522	2	8
3911	+7906523	2	8
3912	+7906524	2	8
3913	+7906525	2	8
3914	+7906526	2	8
3915	+7906527	2	8
3916	+7906528	2	8
3917	+7906529	2	8
3918	+790653	2	7
3919	+7906540	2	8
3920	+7906541	2	8
3921	+7906542	2	8
3922	+7906543	2	8
3923	+7906544	2	8
3924	+7906545	2	8
3925	+7906546	2	8
3926	+7906547	2	8
3927	+7906548	2	8
3928	+7906549	2	8
3929	+7906550	2	8
3930	+7906551	2	8
3931	+7906552	2	8
3932	+7906553	2	8
3933	+7906554	2	8
3934	+7906555	2	8
3935	+7906556	2	8
3936	+7906557	2	8
3937	+7906558	2	8
3938	+7906559	2	8
3939	+7906560	2	8
3940	+7906561	2	8
3941	+7906562	2	8
3942	+7906563	2	8
3943	+7906564	2	8
3944	+7906565	2	8
3945	+7906566	2	8
3946	+7906567	2	8
3947	+7906568	2	8
3948	+7906569	2	8
3949	+7906570	2	8
3950	+7906571	2	8
3951	+7906572	2	8
3952	+7906573	2	8
3953	+7906574	2	8
3954	+7906575	2	8
3955	+7906576	2	8
3956	+7906577	2	8
3957	+7906578	2	8
3958	+7906579	2	8
3959	+790658	2	7
3960	+790659	2	7
3961	+7906591	2	8
3962	+7906592	2	8
3963	+7906593	2	8
3964	+7906594	2	8
3965	+7906595	2	8
3966	+7906596	2	8
3967	+7906597	2	8
3968	+7906598	2	8
3969	+7906599	2	8
3970	+7906600	2	8
3971	+7906601	2	8
3972	+7906602	2	8
3973	+7906603	2	8
3974	+7906604	2	8
3975	+7906605	2	8
3976	+7906606	2	8
3977	+7906607	2	8
3978	+7906608	2	8
3979	+7906609	2	8
3980	+7906610	2	8
3981	+7906611	2	8
3982	+7906612	2	8
3983	+7906613	2	8
3984	+7906614	2	8
3985	+7906615	2	8
3986	+7906616	2	8
3987	+7906617	2	8
3988	+7906618	2	8
3989	+7906619	2	8
3990	+790662	2	7
3991	+790663	2	7
3992	+7906631	2	8
3993	+7906632	2	8
3994	+7906633	2	8
3995	+7906634	2	8
3996	+7906635	2	8
3997	+7906636	2	8
3998	+7906637	2	8
3999	+7906638	2	8
4000	+7906639	2	8
4001	+7906640	2	8
4002	+7906641	2	8
4003	+7906642	2	8
4004	+7906643	2	8
4005	+7906644	2	8
4006	+7906645	2	8
4007	+7906646	2	8
4008	+7906647	2	8
4009	+7906648	2	8
4010	+7906649	2	8
4011	+7906650	2	8
4012	+7906651	2	8
4013	+7906652	2	8
4014	+7906653	2	8
4015	+7906654	2	8
4016	+7906655	2	8
4017	+7906656	2	8
4018	+7906657	2	8
4019	+7906658	2	8
4020	+7906659	2	8
4021	+7906660	2	8
4022	+7906661	2	8
4023	+7906662	2	8
4024	+7906663	2	8
4025	+7906664	2	8
4026	+7906665	2	8
4027	+7906666	2	8
4028	+7906667	2	8
4029	+7906668	2	8
4030	+7906669	2	8
4031	+790667	2	7
4032	+7906680	2	8
4033	+7906681	2	8
4034	+7906682	2	8
4035	+7906683	2	8
4036	+7906684	2	8
4037	+7906685	2	8
4038	+7906686	2	8
4039	+7906687	2	8
4040	+7906688	2	8
4041	+7906689	2	8
4042	+7906690	2	8
4043	+7906691	2	8
4044	+7906692	2	8
4045	+7906693	2	8
4046	+7906694	2	8
4047	+7906695	2	8
4048	+7906696	2	8
4049	+7906697	2	8
4050	+7906698	2	8
4051	+7906699	2	8
4052	+79067	2	6
4053	+7906800	2	8
4054	+7906801	2	8
4055	+7906802	2	8
4056	+7906803	2	8
4057	+7906804	2	8
4058	+7906805	2	8
4059	+7906806	2	8
4060	+7906807	2	8
4061	+7906808	2	8
4062	+7906809	2	8
4063	+7906810	2	8
4064	+7906811	2	8
4065	+7906812	2	8
4066	+7906813	2	8
4067	+7906814	2	8
4068	+7906815	2	8
4069	+7906816	2	8
4070	+7906817	2	8
4071	+7906818	2	8
4072	+7906819	2	8
4073	+7906820	2	8
4074	+7906821	2	8
4075	+7906822	2	8
4076	+7906823	2	8
4077	+7906824	2	8
4078	+7906825	2	8
4079	+7906826	2	8
4080	+7906827	2	8
4081	+7906828	2	8
4082	+7906829	2	8
4083	+790683	2	7
4084	+790684	2	7
4085	+7906850	2	8
4086	+7906851	2	8
4087	+7906852	2	8
4088	+7906853	2	8
4089	+7906854	2	8
4090	+7906855	2	8
4091	+7906856	2	8
4092	+7906857	2	8
4093	+7906858	2	8
4094	+7906859	2	8
4095	+7906860	2	8
4096	+7906861	2	8
4097	+7906862	2	8
4098	+7906863	2	8
4099	+7906864	2	8
4100	+7906865	2	8
4101	+7906866	2	8
4102	+7906867	2	8
4103	+7906868	2	8
4104	+7906869	2	8
4105	+7906870	2	8
4106	+7906871	2	8
4107	+7906872	2	8
4108	+7906873	2	8
4109	+7906874	2	8
4110	+7906875	2	8
4111	+7906876	2	8
4112	+7906877	2	8
4113	+7906878	2	8
4114	+7906879	2	8
4115	+7906880	2	8
4116	+7906881	2	8
4117	+7906882	2	8
4118	+7906883	2	8
4119	+7906884	2	8
4120	+7906885	2	8
4121	+7906886	2	8
4122	+7906887	2	8
4123	+7906888	2	8
4124	+7906889	2	8
4125	+7906890	2	8
4126	+7906891	2	8
4127	+7906892	2	8
4128	+7906893	2	8
4129	+7906894	2	8
4130	+7906895	2	8
4131	+7906896	2	8
4132	+7906897	2	8
4133	+7906898	2	8
4134	+7906899	2	8
4135	+7906900	2	8
4136	+7906901	2	8
4137	+7906902	2	8
4138	+7906903	2	8
4139	+7906904	2	8
4140	+7906905	2	8
4141	+7906906	2	8
4142	+7906907	2	8
4143	+7906908	2	8
4144	+7906909	2	8
4145	+7906910	2	8
4146	+7906911	2	8
4147	+7906912	2	8
4148	+7906913	2	8
4149	+7906914	2	8
4150	+7906915	2	8
4151	+7906916	2	8
4152	+7906917	2	8
4153	+7906918	2	8
4154	+7906919	2	8
4155	+7906920	2	8
4156	+7906921	2	8
4157	+7906922	2	8
4158	+7906923	2	8
4159	+7906924	2	8
4160	+7906925	2	8
4161	+7906926	2	8
4162	+7906927	2	8
4163	+7906928	2	8
4164	+7906929	2	8
4165	+7906930	2	8
4166	+7906931	2	8
4167	+7906932	2	8
4168	+7906933	2	8
4169	+7906934	2	8
4170	+7906935	2	8
4171	+7906936	2	8
4172	+7906937	2	8
4173	+7906938	2	8
4174	+7906939	2	8
4175	+7906940	2	8
4176	+7906941	2	8
4177	+7906942	2	8
4178	+7906943	2	8
4179	+7906944	2	8
4180	+7906945	2	8
4181	+7906946	2	8
4182	+7906947	2	8
4183	+7906948	2	8
4184	+7906949	2	8
4185	+7906950	2	8
4186	+7906951	2	8
4187	+7906952	2	8
4188	+7906953	2	8
4189	+7906954	2	8
4190	+7906955	2	8
4191	+7906956	2	8
4192	+7906957	2	8
4193	+7906958	2	8
4194	+7906959	2	8
4195	+790696	2	7
4196	+7906970	2	8
4197	+7906971	2	8
4198	+7906972	2	8
4199	+7906973	2	8
4200	+7906974	2	8
4201	+7906975	2	8
4202	+7906976	2	8
4203	+7906977	2	8
4204	+7906978	2	8
4205	+7906979	2	8
4206	+7906980	2	8
4207	+7906981	2	8
4208	+7906982	2	8
4209	+7906983	2	8
4210	+7906984	2	8
4211	+7906985	2	8
4212	+7906986	2	8
4213	+7906987	2	8
4214	+7906988	2	8
4215	+7906989	2	8
4216	+7906990	2	8
4217	+7906991	2	8
4218	+7906992	2	8
4219	+7906993	2	8
4220	+7906994	2	8
4221	+7906995	2	8
4222	+7906996	2	8
4223	+7906997	2	8
4224	+7906998	2	8
4225	+7906999	2	8
4226	+7909000	2	8
4227	+7909001	2	8
4228	+7909002	2	8
4229	+7909003	2	8
4230	+7909004	2	8
4231	+7909005	2	8
4232	+7909006	2	8
4233	+7909007	2	8
4234	+7909008	2	8
4235	+7909009	2	8
4236	+7909010	2	8
4237	+7909011	2	8
4238	+7909012	2	8
4239	+7909013	2	8
4240	+7909014	2	8
4241	+7909015	2	8
4242	+7909016	2	8
4243	+7909017	2	8
4244	+7909018	2	8
4245	+7909019	2	8
4246	+7909020	2	8
4247	+7909021	2	8
4248	+7909022	2	8
4249	+7909023	2	8
4250	+7909024	2	8
4251	+7909025	2	8
4252	+7909026	2	8
4253	+7909027	2	8
4254	+7909028	2	8
4255	+7909029	2	8
4256	+7909030	2	8
4257	+7909031	2	8
4258	+7909032	2	8
4259	+7909033	2	8
4260	+7909034	2	8
4261	+7909035	2	8
4262	+7909036	2	8
4263	+7909037	2	8
4264	+7909038	2	8
4265	+7909039	2	8
4266	+7909040	2	8
4267	+7909041	2	8
4268	+7909042	2	8
4269	+7909043	2	8
4270	+7909044	2	8
4271	+7909045	2	8
4272	+7909046	2	8
4273	+7909047	2	8
4274	+7909048	2	8
4275	+7909049	2	8
4276	+7909050	2	8
4277	+7909051	2	8
4278	+7909052	2	8
4279	+7909053	2	8
4280	+7909054	2	8
4281	+7909055	2	8
4282	+7909056	2	8
4283	+7909057	2	8
4284	+7909058	2	8
4285	+7909059	2	8
4286	+7909060	2	8
4287	+7909061	2	8
4288	+7909062	2	8
4289	+7909063	2	8
4290	+7909064	2	8
4291	+7909065	2	8
4292	+7909066	2	8
4293	+7909067	2	8
4294	+7909068	2	8
4295	+7909069	2	8
4296	+7909070	2	8
4297	+7909071	2	8
4298	+7909072	2	8
4299	+7909073	2	8
4300	+7909074	2	8
4301	+7909075	2	8
4302	+7909076	2	8
4303	+7909077	2	8
4304	+7909078	2	8
4305	+7909079	2	8
4306	+7909080	2	8
4307	+7909081	2	8
4308	+7909082	2	8
4309	+7909083	2	8
4310	+7909084	2	8
4311	+7909085	2	8
4312	+7909086	2	8
4313	+7909087	2	8
4314	+7909088	2	8
4315	+7909089	2	8
4316	+7909090	2	8
4317	+7909091	2	8
4318	+7909092	2	8
4319	+7909093	2	8
4320	+7909094	2	8
4321	+7909095	2	8
4322	+7909096	2	8
4323	+7909097	2	8
4324	+7909098	2	8
4325	+7909099	2	8
4326	+790910	2	7
4327	+790911	2	7
4328	+790912	2	7
4329	+7909130	2	8
4330	+7909131	2	8
4331	+7909132	2	8
4332	+7909133	2	8
4333	+7909134	2	8
4334	+7909135	2	8
4335	+7909136	2	8
4336	+7909137	2	8
4337	+7909138	2	8
4338	+7909139	2	8
4339	+7909140	2	8
4340	+7909141	2	8
4341	+7909142	2	8
4342	+7909143	2	8
4343	+7909144	2	8
4344	+7909145	2	8
4345	+7909146	2	8
4346	+7909147	2	8
4347	+7909148	2	8
4348	+7909149	2	8
4349	+790915	2	7
4350	+790916	2	7
4351	+790917	2	7
4352	+7909180	2	8
4353	+7909181	2	8
4354	+7909182	2	8
4355	+7909183	2	8
4356	+7909184	2	8
4357	+7909185	2	8
4358	+7909186	2	8
4359	+7909187	2	8
4360	+7909188	2	8
4361	+7909189	2	8
4362	+7909190	2	8
4363	+7909191	2	8
4364	+7909192	2	8
4365	+7909193	2	8
4366	+7909194	2	8
4367	+7909195	2	8
4368	+7909196	2	8
4369	+7909197	2	8
4370	+7909198	2	8
4371	+7909199	2	8
4372	+790920	2	7
4373	+7909210	2	8
4374	+7909211	2	8
4375	+7909212	2	8
4376	+7909213	2	8
4377	+7909214	2	8
4378	+7909215	2	8
4379	+7909216	2	8
4380	+7909217	2	8
4381	+7909218	2	8
4382	+7909219	2	8
4383	+7909220	2	8
4384	+7909221	2	8
4385	+7909222	2	8
4386	+7909223	2	8
4387	+7909224	2	8
4388	+7909225	2	8
4389	+7909226	2	8
4390	+7909227	2	8
4391	+7909228	2	8
4392	+7909229	2	8
4393	+7909230	2	8
4394	+7909231	2	8
4395	+7909232	2	8
4396	+7909233	2	8
4397	+7909234	2	8
4398	+7909235	2	8
4399	+7909236	2	8
4400	+7909237	2	8
4401	+7909238	2	8
4402	+7909239	2	8
4403	+7909240	2	8
4404	+7909241	2	8
4405	+7909242	2	8
4406	+7909243	2	8
4407	+7909244	2	8
4408	+7909245	2	8
4409	+7909246	2	8
4410	+7909247	2	8
4411	+7909248	2	8
4412	+7909249	2	8
4413	+7909250	2	8
4414	+7909251	2	8
4415	+7909252	2	8
4416	+7909253	2	8
4417	+7909254	2	8
4418	+7909255	2	8
4419	+7909256	2	8
4420	+7909257	2	8
4421	+7909258	2	8
4422	+7909259	2	8
4423	+7909260	2	8
4424	+7909261	2	8
4425	+7909262	2	8
4426	+7909263	2	8
4427	+7909264	2	8
4428	+7909265	2	8
4429	+7909266	2	8
4430	+7909267	2	8
4431	+7909268	2	8
4432	+7909269	2	8
4433	+7909270	2	8
4434	+7909271	2	8
4435	+7909272	2	8
4436	+7909273	2	8
4437	+7909274	2	8
4438	+7909275	2	8
4439	+7909276	2	8
4440	+7909277	2	8
4441	+7909278	2	8
4442	+7909279	2	8
4443	+7909280	2	8
4444	+7909281	2	8
4445	+7909282	2	8
4446	+7909283	2	8
4447	+7909284	2	8
4448	+7909285	2	8
4449	+7909286	2	8
4450	+7909287	2	8
4451	+7909288	2	8
4452	+7909289	2	8
4453	+7909290	2	8
4454	+7909291	2	8
4455	+7909292	2	8
4456	+7909293	2	8
4457	+7909294	2	8
4458	+7909295	2	8
4459	+7909296	2	8
4460	+7909297	2	8
4461	+7909298	2	8
4462	+7909299	2	8
4463	+7909300	2	8
4464	+7909301	2	8
4465	+7909302	2	8
4466	+7909303	2	8
4467	+7909304	2	8
4468	+7909305	2	8
4469	+7909306	2	8
4470	+7909307	2	8
4471	+7909308	2	8
4472	+7909309	2	8
4473	+7909310	2	8
4474	+7909311	2	8
4475	+7909312	2	8
4476	+7909313	2	8
4477	+7909314	2	8
4478	+7909315	2	8
4479	+7909316	2	8
4480	+7909317	2	8
4481	+7909318	2	8
4482	+7909319	2	8
4483	+7909320	2	8
4484	+7909321	2	8
4485	+7909322	2	8
4486	+7909323	2	8
4487	+7909324	2	8
4488	+7909325	2	8
4489	+7909326	2	8
4490	+7909327	2	8
4491	+7909328	2	8
4492	+7909329	2	8
4493	+7909330	2	8
4494	+7909331	2	8
4495	+7909332	2	8
4496	+7909333	2	8
4497	+7909334	2	8
4498	+7909335	2	8
4499	+7909336	2	8
4500	+7909337	2	8
4501	+7909338	2	8
4502	+7909339	2	8
4503	+7909340	2	8
4504	+7909341	2	8
4505	+7909342	2	8
4506	+7909343	2	8
4507	+7909344	2	8
4508	+7909345	2	8
4509	+7909346	2	8
4510	+7909347	2	8
4511	+7909348	2	8
4512	+7909349	2	8
4513	+7909350	2	8
4514	+7909351	2	8
4515	+7909352	2	8
4516	+7909353	2	8
4517	+7909354	2	8
4518	+7909355	2	8
4519	+7909356	2	8
4520	+7909357	2	8
4521	+7909358	2	8
4522	+7909359	2	8
4523	+7909360	2	8
4524	+7909361	2	8
4525	+7909362	2	8
4526	+7909363	2	8
4527	+7909364	2	8
4528	+7909365	2	8
4529	+7909366	2	8
4530	+7909367	2	8
4531	+7909368	2	8
4532	+7909369	2	8
4533	+7909370	2	8
4534	+7909371	2	8
4535	+7909372	2	8
4536	+7909373	2	8
4537	+7909374	2	8
4538	+7909375	2	8
4539	+7909376	2	8
4540	+7909377	2	8
4541	+7909378	2	8
4542	+7909379	2	8
4543	+7909380	2	8
4544	+7909381	2	8
4545	+7909382	2	8
4546	+7909383	2	8
4547	+7909384	2	8
4548	+7909385	2	8
4549	+7909386	2	8
4550	+7909387	2	8
4551	+7909388	2	8
4552	+7909389	2	8
4553	+7909390	2	8
4554	+7909391	2	8
4555	+7909392	2	8
4556	+7909393	2	8
4557	+7909394	2	8
4558	+7909395	2	8
4559	+7909396	2	8
4560	+7909397	2	8
4561	+7909398	2	8
4562	+7909399	2	8
4563	+7909400	2	8
4564	+7909401	2	8
4565	+7909402	2	8
4566	+7909403	2	8
4567	+7909404	2	8
4568	+7909405	2	8
4569	+7909406	2	8
4570	+7909407	2	8
4571	+7909408	2	8
4572	+7909409	2	8
4573	+7909410	2	8
4574	+7909411	2	8
4575	+7909412	2	8
4576	+7909413	2	8
4577	+7909414	2	8
4578	+7909415	2	8
4579	+7909416	2	8
4580	+7909417	2	8
4581	+7909418	2	8
4582	+7909419	2	8
4583	+7909420	2	8
4584	+7909421	2	8
4585	+7909422	2	8
4586	+7909423	2	8
4587	+7909424	2	8
4588	+7909425	2	8
4589	+7909426	2	8
4590	+7909427	2	8
4591	+7909428	2	8
4592	+7909429	2	8
4593	+7909430	2	8
4594	+7909431	2	8
4595	+7909432	2	8
4596	+7909433	2	8
4597	+7909434	2	8
4598	+7909435	2	8
4599	+7909436	2	8
4600	+7909437	2	8
4601	+7909438	2	8
4602	+7909439	2	8
4603	+7909440	2	8
4604	+7909441	2	8
4605	+7909442	2	8
4606	+7909443	2	8
4607	+7909444	2	8
4608	+7909445	2	8
4609	+7909446	2	8
4610	+7909447	2	8
4611	+7909448	2	8
4612	+7909449	2	8
4613	+7909450	2	8
4614	+7909451	2	8
4615	+7909452	2	8
4616	+7909453	2	8
4617	+7909454	2	8
4618	+7909455	2	8
4619	+7909456	2	8
4620	+7909457	2	8
4621	+7909458	2	8
4622	+7909459	2	8
4623	+7909460	2	8
4624	+7909461	2	8
4625	+7909462	2	8
4626	+7909463	2	8
4627	+7909464	2	8
4628	+7909465	2	8
4629	+7909466	2	8
4630	+7909467	2	8
4631	+7909468	2	8
4632	+7909469	2	8
4633	+7909470	2	8
4634	+7909471	2	8
4635	+7909472	2	8
4636	+7909473	2	8
4637	+7909474	2	8
4638	+7909475	2	8
4639	+7909476	2	8
4640	+7909477	2	8
4641	+7909478	2	8
4642	+7909479	2	8
4643	+7909480	2	8
4644	+7909481	2	8
4645	+7909482	2	8
4646	+7909483	2	8
4647	+7909484	2	8
4648	+7909485	2	8
4649	+7909486	2	8
4650	+7909487	2	8
4651	+7909488	2	8
4652	+7909489	2	8
4653	+7909490	2	8
4654	+7909491	2	8
4655	+7909492	2	8
4656	+7909493	2	8
4657	+7909494	2	8
4658	+7909495	2	8
4659	+7909496	2	8
4660	+7909497	2	8
4661	+7909498	2	8
4662	+7909499	2	8
4663	+7909500	2	8
4664	+7909501	2	8
4665	+7909502	2	8
4666	+7909503	2	8
4667	+7909504	2	8
4668	+7909505	2	8
4669	+7909506	2	8
4670	+7909507	2	8
4671	+7909508	2	8
4672	+7909509	2	8
4673	+7909510	2	8
4674	+7909511	2	8
4675	+7909512	2	8
4676	+7909513	2	8
4677	+7909514	2	8
4678	+7909515	2	8
4679	+7909516	2	8
4680	+7909517	2	8
4681	+7909518	2	8
4682	+7909519	2	8
4683	+7909520	2	8
4684	+7909521	2	8
4685	+7909522	2	8
4686	+7909523	2	8
4687	+7909524	2	8
4688	+7909525	2	8
4689	+7909526	2	8
4690	+7909527	2	8
4691	+7909528	2	8
4692	+7909529	2	8
4693	+7909530	2	8
4694	+7909531	2	8
4695	+7909532	2	8
4696	+7909533	2	8
4697	+7909534	2	8
4698	+7909535	2	8
4699	+7909536	2	8
4700	+7909537	2	8
4701	+7909538	2	8
4702	+7909539	2	8
4703	+7909540	2	8
4704	+7909541	2	8
4705	+7909542	2	8
4706	+7909543	2	8
4707	+7909544	2	8
4708	+7909545	2	8
4709	+7909546	2	8
4710	+7909547	2	8
4711	+7909548	2	8
4712	+7909549	2	8
4713	+7909550	2	8
4714	+7909551	2	8
4715	+7909552	2	8
4716	+7909553	2	8
4717	+7909554	2	8
4718	+7909555	2	8
4719	+7909556	2	8
4720	+7909557	2	8
4721	+7909558	2	8
4722	+7909559	2	8
4723	+7909560	2	8
4724	+7909561	2	8
4725	+7909562	2	8
4726	+7909563	2	8
4727	+7909564	2	8
4728	+7909565	2	8
4729	+7909566	2	8
4730	+7909567	2	8
4731	+7909568	2	8
4732	+7909569	2	8
4733	+7909570	2	8
4734	+7909571	2	8
4735	+7909572	2	8
4736	+7909573	2	8
4737	+7909574	2	8
4738	+7909575	2	8
4739	+7909576	2	8
4740	+7909577	2	8
4741	+7909578	2	8
4742	+7909579	2	8
4743	+7909580	2	8
4744	+7909581	2	8
4745	+7909582	2	8
4746	+7909583	2	8
4747	+7909584	2	8
4748	+7909585	2	8
4749	+7909586	2	8
4750	+7909587	2	8
4751	+7909588	2	8
4752	+7909589	2	8
4753	+7909590	2	8
4754	+7909591	2	8
4755	+7909592	2	8
4756	+7909593	2	8
4757	+7909594	2	8
4758	+7909595	2	8
4759	+7909596	2	8
4760	+7909597	2	8
4761	+7909598	2	8
4762	+7909599	2	8
4763	+790960	2	7
4764	+790961	2	7
4765	+790962	2	7
4766	+790963	2	7
4767	+790964	2	7
4768	+790965	2	7
4769	+790966	2	7
4770	+790967	2	7
4771	+790968	2	7
4772	+790969	2	7
4773	+7909700	2	8
4774	+7909701	2	8
4775	+7909702	2	8
4776	+7909703	2	8
4777	+7909704	2	8
4778	+7909705	2	8
4779	+7909706	2	8
4780	+7909707	2	8
4781	+7909708	2	8
4782	+7909709	2	8
4783	+7909710	2	8
4784	+7909711	2	8
4785	+7909712	2	8
4786	+7909713	2	8
4787	+7909714	2	8
4788	+7909715	2	8
4789	+7909716	2	8
4790	+7909717	2	8
4791	+7909718	2	8
4792	+7909719	2	8
4793	+7909720	2	8
4794	+7909721	2	8
4795	+7909722	2	8
4796	+7909723	2	8
4797	+7909724	2	8
4798	+7909725	2	8
4799	+7909726	2	8
4800	+7909727	2	8
4801	+7909728	2	8
4802	+7909729	2	8
4803	+7909730	2	8
4804	+7909731	2	8
4805	+7909732	2	8
4806	+7909733	2	8
4807	+7909734	2	8
4808	+7909735	2	8
4809	+7909736	2	8
4810	+7909737	2	8
4811	+7909738	2	8
4812	+7909739	2	8
4813	+7909740	2	8
4814	+7909741	2	8
4815	+7909742	2	8
4816	+7909743	2	8
4817	+7909744	2	8
4818	+7909745	2	8
4819	+7909746	2	8
4820	+7909747	2	8
4821	+7909748	2	8
4822	+7909749	2	8
4823	+7909750	2	8
4824	+7909751	2	8
4825	+7909752	2	8
4826	+7909753	2	8
4827	+7909754	2	8
4828	+7909755	2	8
4829	+7909756	2	8
4830	+7909757	2	8
4831	+7909758	2	8
4832	+7909759	2	8
4833	+7909760	2	8
4834	+7909761	2	8
4835	+7909762	2	8
4836	+7909763	2	8
4837	+7909764	2	8
4838	+7909765	2	8
4839	+7909766	2	8
4840	+7909767	2	8
4841	+7909768	2	8
4842	+7909769	2	8
4843	+7909770	2	8
4844	+7909771	2	8
4845	+7909772	2	8
4846	+7909773	2	8
4847	+7909774	2	8
4848	+7909775	2	8
4849	+7909776	2	8
4850	+7909777	2	8
4851	+7909778	2	8
4852	+7909779	2	8
4853	+7909780	2	8
4854	+7909781	2	8
4855	+7909782	2	8
4856	+7909783	2	8
4857	+7909784	2	8
4858	+7909785	2	8
4859	+7909786	2	8
4860	+7909787	2	8
4861	+7909788	2	8
4862	+7909789	2	8
4863	+7909790	2	8
4864	+7909791	2	8
4865	+7909792	2	8
4866	+7909793	2	8
4867	+7909794	2	8
4868	+7909795	2	8
4869	+7909796	2	8
4870	+7909797	2	8
4871	+7909798	2	8
4872	+7909799	2	8
4873	+790980	2	7
4874	+790981	2	7
4875	+790982	2	7
4876	+790983	2	7
4877	+790984	2	7
4878	+790985	2	7
4879	+790986	2	7
4880	+790987	2	7
4881	+7909880	2	8
4882	+7909881	2	8
4883	+7909882	2	8
4884	+7909883	2	8
4885	+7909884	2	8
4886	+7909885	2	8
4887	+7909886	2	8
4888	+7909887	2	8
4889	+7909888	2	8
4890	+7909889	2	8
4891	+7909890	2	8
4892	+7909891	2	8
4893	+7909892	2	8
4894	+7909893	2	8
4895	+7909894	2	8
4896	+7909895	2	8
4897	+7909896	2	8
4898	+7909897	2	8
4899	+7909898	2	8
4900	+7909899	2	8
4901	+79099	2	6
4902	+7960000	2	8
4903	+7960001	2	8
4904	+7960002	2	8
4905	+7960003	2	8
4906	+7960004	2	8
4907	+7960005	2	8
4908	+7960006	2	8
4909	+7960007	2	8
4910	+7960008	2	8
4911	+7960009	2	8
4912	+7960010	2	8
4913	+7960011	2	8
4914	+7960012	2	8
4915	+7960013	2	8
4916	+7960014	2	8
4917	+7960015	2	8
4918	+7960016	2	8
4919	+7960017	2	8
4920	+7960018	2	8
4921	+7960019	2	8
4922	+796002	2	7
4923	+796003	2	7
4924	+796004	2	7
4925	+796005	2	7
4926	+796006	2	7
4927	+796007	2	7
4928	+796008	2	7
4929	+796009	2	7
4930	+796010	2	7
4931	+796011	2	7
4932	+796012	2	7
4933	+796013	2	7
4934	+796014	2	7
4935	+796015	2	7
4936	+796016	2	7
4937	+796017	2	7
4938	+796018	2	7
4939	+796019	2	7
4940	+796020	2	7
4941	+796021	2	7
4942	+796022	2	7
4943	+796023	2	7
4944	+796024	2	7
4945	+796025	2	7
4946	+796026	2	7
4947	+796027	2	7
4948	+796028	2	7
4949	+796029	2	7
4950	+7960300	2	8
4951	+7960301	2	8
4952	+7960302	2	8
4953	+7960303	2	8
4954	+7960304	2	8
4955	+7960305	2	8
4956	+7960306	2	8
4957	+7960307	2	8
4958	+7960308	2	8
4959	+7960309	2	8
4960	+7960310	2	8
4961	+7960311	2	8
4962	+7960312	2	8
4963	+7960313	2	8
4964	+7960314	2	8
4965	+7960315	2	8
4966	+7960316	2	8
4967	+7960317	2	8
4968	+7960318	2	8
4969	+7960319	2	8
4970	+7960320	2	8
4971	+7960321	2	8
4972	+7960322	2	8
4973	+7960323	2	8
4974	+7960324	2	8
4975	+7960325	2	8
4976	+7960326	2	8
4977	+7960327	2	8
4978	+7960328	2	8
4979	+7960329	2	8
4980	+796033	2	7
4981	+796034	2	7
4982	+796035	2	7
4983	+796036	2	7
4984	+796037	2	7
4985	+796038	2	7
4986	+796039	2	7
4987	+7960400	2	8
4988	+7960401	2	8
4989	+7960402	2	8
4990	+7960403	2	8
4991	+7960404	2	8
4992	+7960405	2	8
4993	+7960406	2	8
4994	+7960407	2	8
4995	+7960408	2	8
4996	+7960409	2	8
4997	+7960410	2	8
4998	+7960411	2	8
4999	+7960412	2	8
5000	+7960413	2	8
5001	+7960414	2	8
5002	+7960415	2	8
5003	+7960416	2	8
5004	+7960417	2	8
5005	+7960418	2	8
5006	+7960419	2	8
5007	+7960420	2	8
5008	+7960421	2	8
5009	+7960422	2	8
5010	+7960423	2	8
5011	+7960424	2	8
5012	+7960425	2	8
5013	+7960426	2	8
5014	+7960427	2	8
5015	+7960428	2	8
5016	+7960429	2	8
5017	+7960430	2	8
5018	+7960431	2	8
5019	+7960432	2	8
5020	+7960433	2	8
5021	+7960434	2	8
5022	+7960435	2	8
5023	+7960436	2	8
5024	+7960437	2	8
5025	+7960438	2	8
5026	+7960439	2	8
5027	+7960440	2	8
5028	+7960441	2	8
5029	+7960442	2	8
5030	+7960443	2	8
5031	+7960444	2	8
5032	+7960445	2	8
5033	+7960446	2	8
5034	+7960447	2	8
5035	+7960448	2	8
5036	+7960449	2	8
5037	+7960450	2	8
5038	+7960451	2	8
5039	+7960452	2	8
5040	+7960453	2	8
5041	+7960454	2	8
5042	+7960455	2	8
5043	+7960456	2	8
5044	+7960457	2	8
5045	+7960458	2	8
5046	+7960459	2	8
5047	+7960460	2	8
5048	+7960461	2	8
5049	+7960462	2	8
5050	+7960463	2	8
5051	+7960464	2	8
5052	+7960465	2	8
5053	+7960466	2	8
5054	+7960467	2	8
5055	+7960468	2	8
5056	+7960469	2	8
5057	+7960470	2	8
5058	+7960471	2	8
5059	+7960472	2	8
5060	+7960473	2	8
5061	+7960474	2	8
5062	+7960475	2	8
5063	+7960476	2	8
5064	+7960477	2	8
5065	+7960478	2	8
5066	+7960479	2	8
5067	+7960480	2	8
5068	+7960481	2	8
5069	+7960482	2	8
5070	+7960483	2	8
5071	+7960484	2	8
5072	+7960485	2	8
5073	+7960486	2	8
5074	+7960487	2	8
5075	+7960488	2	8
5076	+7960489	2	8
5077	+7960490	2	8
5078	+7960491	2	8
5079	+7960492	2	8
5080	+7960493	2	8
5081	+7960494	2	8
5082	+7960495	2	8
5083	+7960496	2	8
5084	+7960497	2	8
5085	+7960498	2	8
5086	+7960499	2	8
5087	+7960500	2	8
5088	+7960501	2	8
5089	+7960502	2	8
5090	+7960503	2	8
5091	+7960504	2	8
5092	+7960505	2	8
5093	+7960506	2	8
5094	+7960507	2	8
5095	+7960508	2	8
5096	+7960509	2	8
5097	+7960510	2	8
5098	+7960511	2	8
5099	+7960512	2	8
5100	+7960513	2	8
5101	+7960514	2	8
5102	+7960515	2	8
5103	+7960516	2	8
5104	+7960517	2	8
5105	+7960518	2	8
5106	+7960519	2	8
5107	+7960520	2	8
5108	+7960521	2	8
5109	+7960522	2	8
5110	+7960523	2	8
5111	+7960524	2	8
5112	+7960525	2	8
5113	+7960526	2	8
5114	+7960527	2	8
5115	+7960528	2	8
5116	+7960529	2	8
5117	+7960530	2	8
5118	+7960531	2	8
5119	+7960532	2	8
5120	+7960533	2	8
5121	+7960534	2	8
5122	+7960535	2	8
5123	+7960536	2	8
5124	+7960537	2	8
5125	+7960538	2	8
5126	+7960539	2	8
5127	+7960540	2	8
5128	+7960541	2	8
5129	+7960542	2	8
5130	+7960543	2	8
5131	+7960544	2	8
5132	+7960545	2	8
5133	+7960546	2	8
5134	+7960547	2	8
5135	+7960548	2	8
5136	+7960549	2	8
5137	+7960550	2	8
5138	+7960551	2	8
5139	+7960552	2	8
5140	+7960553	2	8
5141	+7960554	2	8
5142	+7960555	2	8
5143	+7960556	2	8
5144	+7960557	2	8
5145	+7960558	2	8
5146	+7960559	2	8
5147	+7960560	2	8
5148	+7960561	2	8
5149	+7960562	2	8
5150	+7960563	2	8
5151	+7960564	2	8
5152	+7960565	2	8
5153	+7960566	2	8
5154	+7960567	2	8
5155	+7960568	2	8
5156	+7960569	2	8
5157	+7960570	2	8
5158	+7960571	2	8
5159	+7960572	2	8
5160	+7960573	2	8
5161	+7960574	2	8
5162	+7960575	2	8
5163	+7960576	2	8
5164	+7960577	2	8
5165	+7960578	2	8
5166	+7960579	2	8
5167	+7960580	2	8
5168	+7960581	2	8
5169	+7960582	2	8
5170	+7960583	2	8
5171	+7960584	2	8
5172	+7960585	2	8
5173	+7960586	2	8
5174	+7960587	2	8
5175	+7960588	2	8
5176	+7960589	2	8
5177	+7960590	2	8
5178	+7960591	2	8
5179	+7960592	2	8
5180	+7960593	2	8
5181	+7960594	2	8
5182	+7960595	2	8
5183	+7960596	2	8
5184	+7960597	2	8
5185	+7960598	2	8
5186	+7960599	2	8
5187	+7960600	2	8
5188	+7960601	2	8
5189	+7960602	2	8
5190	+7960603	2	8
5191	+7960604	2	8
5192	+7960605	2	8
5193	+7960606	2	8
5194	+7960607	2	8
5195	+7960608	2	8
5196	+7960609	2	8
5197	+7960610	2	8
5198	+7960611	2	8
5199	+7960612	2	8
5200	+7960613	2	8
5201	+7960614	2	8
5202	+7960615	2	8
5203	+7960616	2	8
5204	+7960617	2	8
5205	+7960618	2	8
5206	+7960619	2	8
5207	+796062	2	7
5208	+796063	2	7
5209	+796064	2	7
5210	+7960641	2	8
5211	+7960642	2	8
5212	+7960643	2	8
5213	+7960644	2	8
5214	+7960645	2	8
5215	+7960646	2	8
5216	+7960647	2	8
5217	+7960648	2	8
5218	+7960649	2	8
5219	+7960650	2	8
5220	+7960651	2	8
5221	+7960652	2	8
5222	+7960653	2	8
5223	+7960654	2	8
5224	+7960655	2	8
5225	+7960656	2	8
5226	+7960657	2	8
5227	+7960658	2	8
5228	+7960659	2	8
5229	+7960660	2	8
5230	+7960661	2	8
5231	+7960662	2	8
5232	+7960663	2	8
5233	+7960664	2	8
5234	+7960665	2	8
5235	+7960666	2	8
5236	+7960667	2	8
5237	+7960668	2	8
5238	+7960669	2	8
5239	+7960670	2	8
5240	+7960671	2	8
5241	+7960672	2	8
5242	+7960673	2	8
5243	+7960674	2	8
5244	+7960675	2	8
5245	+7960676	2	8
5246	+7960677	2	8
5247	+7960678	2	8
5248	+7960679	2	8
5249	+7960680	2	8
5250	+7960681	2	8
5251	+7960682	2	8
5252	+7960683	2	8
5253	+7960684	2	8
5254	+7960685	2	8
5255	+7960686	2	8
5256	+7960687	2	8
5257	+7960688	2	8
5258	+7960689	2	8
5259	+7960690	2	8
5260	+7960691	2	8
5261	+7960692	2	8
5262	+7960693	2	8
5263	+7960694	2	8
5264	+7960695	2	8
5265	+7960696	2	8
5266	+7960697	2	8
5267	+7960698	2	8
5268	+7960699	2	8
5269	+7960700	2	8
5270	+7960701	2	8
5271	+7960702	2	8
5272	+7960703	2	8
5273	+7960704	2	8
5274	+7960705	2	8
5275	+7960706	2	8
5276	+7960707	2	8
5277	+7960708	2	8
5278	+7960709	2	8
5279	+7960710	2	8
5280	+7960711	2	8
5281	+7960712	2	8
5282	+7960713	2	8
5283	+7960714	2	8
5284	+7960715	2	8
5285	+7960716	2	8
5286	+7960717	2	8
5287	+7960718	2	8
5288	+7960719	2	8
5289	+7960720	2	8
5290	+7960721	2	8
5291	+7960722	2	8
5292	+7960723	2	8
5293	+7960724	2	8
5294	+7960725	2	8
5295	+7960726	2	8
5296	+7960727	2	8
5297	+7960728	2	8
5298	+7960729	2	8
5299	+7960730	2	8
5300	+7960731	2	8
5301	+7960732	2	8
5302	+7960733	2	8
5303	+7960734	2	8
5304	+7960735	2	8
5305	+7960736	2	8
5306	+7960737	2	8
5307	+7960738	2	8
5308	+7960739	2	8
5309	+7960740	2	8
5310	+7960741	2	8
5311	+7960742	2	8
5312	+7960743	2	8
5313	+7960744	2	8
5314	+7960745	2	8
5315	+7960746	2	8
5316	+7960747	2	8
5317	+7960748	2	8
5318	+7960749	2	8
5319	+7960750	2	8
5320	+7960751	2	8
5321	+7960752	2	8
5322	+7960753	2	8
5323	+7960754	2	8
5324	+7960755	2	8
5325	+7960756	2	8
5326	+7960757	2	8
5327	+7960758	2	8
5328	+7960759	2	8
5329	+7960760	2	8
5330	+7960761	2	8
5331	+7960762	2	8
5332	+7960763	2	8
5333	+7960764	2	8
5334	+7960765	2	8
5335	+7960766	2	8
5336	+7960767	2	8
5337	+7960768	2	8
5338	+7960769	2	8
5339	+7960770	2	8
5340	+7960771	2	8
5341	+7960772	2	8
5342	+7960773	2	8
5343	+7960774	2	8
5344	+7960775	2	8
5345	+7960776	2	8
5346	+7960777	2	8
5347	+7960778	2	8
5348	+796077	2	7
5349	+796078	2	7
5350	+796079	2	7
5351	+7960800	2	8
5352	+7960801	2	8
5353	+7960802	2	8
5354	+7960803	2	8
5355	+7960804	2	8
5356	+7960805	2	8
5357	+7960806	2	8
5358	+7960807	2	8
5359	+7960808	2	8
5360	+7960809	2	8
5361	+7960810	2	8
5362	+7960811	2	8
5363	+7960812	2	8
5364	+7960813	2	8
5365	+7960814	2	8
5366	+7960815	2	8
5367	+7960816	2	8
5368	+7960817	2	8
5369	+7960818	2	8
5370	+7960819	2	8
5371	+7960820	2	8
5372	+7960821	2	8
5373	+7960822	2	8
5374	+7960823	2	8
5375	+7960824	2	8
5376	+7960825	2	8
5377	+7960826	2	8
5378	+7960827	2	8
5379	+7960828	2	8
5380	+7960829	2	8
5381	+7960830	2	8
5382	+7960831	2	8
5383	+7960832	2	8
5384	+7960833	2	8
5385	+7960834	2	8
5386	+7960835	2	8
5387	+7960836	2	8
5388	+7960837	2	8
5389	+7960838	2	8
5390	+7960839	2	8
5391	+7960840	2	8
5392	+7960841	2	8
5393	+7960842	2	8
5394	+7960843	2	8
5395	+7960844	2	8
5396	+7960845	2	8
5397	+7960846	2	8
5398	+7960847	2	8
5399	+7960848	2	8
5400	+7960849	2	8
5401	+7960850	2	8
5402	+7960851	2	8
5403	+7960852	2	8
5404	+7960853	2	8
5405	+7960854	2	8
5406	+7960855	2	8
5407	+7960856	2	8
5408	+7960857	2	8
5409	+7960858	2	8
5410	+7960859	2	8
5411	+7960860	2	8
5412	+7960861	2	8
5413	+7960862	2	8
5414	+7960863	2	8
5415	+7960864	2	8
5416	+7960865	2	8
5417	+7960866	2	8
5418	+7960867	2	8
5419	+7960868	2	8
5420	+7960869	2	8
5421	+7960870	2	8
5422	+7960871	2	8
5423	+7960872	2	8
5424	+7960873	2	8
5425	+7960874	2	8
5426	+7960875	2	8
5427	+7960876	2	8
5428	+7960877	2	8
5429	+7960878	2	8
5430	+7960879	2	8
5431	+7960880	2	8
5432	+7960881	2	8
5433	+7960882	2	8
5434	+7960883	2	8
5435	+7960884	2	8
5436	+7960885	2	8
5437	+7960886	2	8
5438	+7960887	2	8
5439	+7960888	2	8
5440	+7960889	2	8
5441	+7960890	2	8
5442	+7960891	2	8
5443	+7960892	2	8
5444	+7960893	2	8
5445	+7960894	2	8
5446	+7960895	2	8
5447	+7960896	2	8
5448	+7960897	2	8
5449	+7960898	2	8
5450	+7960899	2	8
5451	+7960900	2	8
5452	+7960901	2	8
5453	+7960902	2	8
5454	+7960903	2	8
5455	+7960904	2	8
5456	+7960905	2	8
5457	+7960906	2	8
5458	+7960907	2	8
5459	+7960908	2	8
5460	+7960909	2	8
5461	+7960910	2	8
5462	+7960911	2	8
5463	+7960912	2	8
5464	+7960913	2	8
5465	+7960914	2	8
5466	+7960915	2	8
5467	+7960916	2	8
5468	+7960917	2	8
5469	+7960918	2	8
5470	+7960919	2	8
5471	+7960920	2	8
5472	+7960921	2	8
5473	+7960922	2	8
5474	+7960923	2	8
5475	+7960924	2	8
5476	+7960925	2	8
5477	+7960926	2	8
5478	+7960927	2	8
5479	+7960928	2	8
5480	+7960929	2	8
5481	+7960930	2	8
5482	+7960931	2	8
5483	+7960932	2	8
5484	+7960933	2	8
5485	+7960934	2	8
5486	+7960935	2	8
5487	+796093	2	7
5488	+796094	2	7
5489	+796095	2	7
5490	+796096	2	7
5491	+7960967	2	8
5492	+7960968	2	8
5494	+796097	2	7
5495	+796098	2	7
5496	+796099	2	7
5497	+7961000	2	8
5498	+7961001	2	8
5499	+7961002	2	8
5500	+7961003	2	8
5501	+7961004	2	8
5502	+7961005	2	8
5503	+7961006	2	8
5504	+7961007	2	8
5505	+7961008	2	8
5506	+7961009	2	8
5507	+7961010	2	8
5508	+7961011	2	8
5509	+7961012	2	8
5510	+7961013	2	8
5511	+7961014	2	8
5512	+7961015	2	8
5513	+7961016	2	8
5514	+7961017	2	8
5515	+7961018	2	8
5516	+7961019	2	8
5517	+7961020	2	8
5518	+7961021	2	8
5519	+7961022	2	8
5520	+7961023	2	8
5521	+7961024	2	8
5522	+7961025	2	8
5523	+7961026	2	8
5524	+7961027	2	8
5525	+7961028	2	8
5526	+7961029	2	8
5527	+7961030	2	8
5528	+7961031	2	8
5529	+7961032	2	8
5530	+7961033	2	8
5531	+7961034	2	8
5532	+7961035	2	8
5533	+7961036	2	8
5534	+7961037	2	8
5535	+7961038	2	8
5536	+7961039	2	8
5537	+7961040	2	8
5538	+7961041	2	8
5539	+7961042	2	8
5540	+7961043	2	8
5541	+7961044	2	8
5542	+7961045	2	8
5543	+7961046	2	8
5544	+7961047	2	8
5545	+7961048	2	8
5546	+7961049	2	8
5547	+7961050	2	8
5548	+7961051	2	8
5549	+7961052	2	8
5550	+7961053	2	8
5551	+7961054	2	8
5552	+7961055	2	8
5553	+7961056	2	8
5554	+7961057	2	8
5555	+7961058	2	8
5556	+7961059	2	8
5557	+7961060	2	8
5558	+7961061	2	8
5559	+7961062	2	8
5560	+7961063	2	8
5561	+7961064	2	8
5562	+7961065	2	8
5563	+7961066	2	8
5564	+7961067	2	8
5565	+7961068	2	8
5566	+7961069	2	8
5567	+7961070	2	8
5568	+7961071	2	8
5569	+7961072	2	8
5570	+7961073	2	8
5571	+7961074	2	8
5572	+7961075	2	8
5573	+7961076	2	8
5574	+7961077	2	8
5575	+7961078	2	8
5576	+7961079	2	8
5577	+7961080	2	8
5578	+7961081	2	8
5579	+7961082	2	8
5580	+7961083	2	8
5581	+7961084	2	8
5582	+7961085	2	8
5583	+7961086	2	8
5584	+7961087	2	8
5585	+7961088	2	8
5586	+7961089	2	8
5587	+7961090	2	8
5588	+7961091	2	8
5589	+7961092	2	8
5590	+7961093	2	8
5591	+7961094	2	8
5592	+7961095	2	8
5593	+7961096	2	8
5594	+7961097	2	8
5595	+7961098	2	8
5596	+7961099	2	8
5597	+7961100	2	8
5598	+7961101	2	8
5599	+7961102	2	8
5600	+7961103	2	8
5601	+7961104	2	8
5602	+7961105	2	8
5603	+7961106	2	8
5604	+7961107	2	8
5605	+7961108	2	8
5606	+7961109	2	8
5607	+7961110	2	8
5608	+7961111	2	8
5609	+7961112	2	8
5610	+7961113	2	8
5611	+7961114	2	8
5612	+7961115	2	8
5613	+7961116	2	8
5614	+7961117	2	8
5615	+7961118	2	8
5616	+7961119	2	8
5617	+7961120	2	8
5618	+7961121	2	8
5619	+7961122	2	8
5620	+7961123	2	8
5621	+7961124	2	8
5622	+7961125	2	8
5623	+7961126	2	8
5624	+7961127	2	8
5625	+7961128	2	8
5626	+7961129	2	8
5627	+7961130	2	8
5628	+7961131	2	8
5629	+7961132	2	8
5630	+7961133	2	8
5631	+7961134	2	8
5632	+7961135	2	8
5633	+7961136	2	8
5634	+7961137	2	8
5635	+7961138	2	8
5636	+7961139	2	8
5637	+7961140	2	8
5638	+7961141	2	8
5639	+7961142	2	8
5640	+7961143	2	8
5641	+7961144	2	8
5642	+7961145	2	8
5643	+7961146	2	8
5644	+7961147	2	8
5645	+7961148	2	8
5646	+7961149	2	8
5647	+7961150	2	8
5648	+7961151	2	8
5649	+7961152	2	8
5650	+7961153	2	8
5651	+7961154	2	8
5652	+7961155	2	8
5653	+7961156	2	8
5654	+7961157	2	8
5655	+7961158	2	8
5656	+7961159	2	8
5657	+7961160	2	8
5658	+7961161	2	8
5659	+7961162	2	8
5660	+7961163	2	8
5661	+7961164	2	8
5662	+7961165	2	8
5663	+7961166	2	8
5664	+7961167	2	8
5665	+7961168	2	8
5666	+7961169	2	8
5667	+796117	2	7
5668	+796118	2	7
5669	+796119	2	7
5670	+7961200	2	8
5671	+7961201	2	8
5672	+7961202	2	8
5673	+7961203	2	8
5674	+7961204	2	8
5675	+7961205	2	8
5676	+7961206	2	8
5677	+7961207	2	8
5678	+7961208	2	8
5679	+7961209	2	8
5680	+7961210	2	8
5681	+7961211	2	8
5682	+7961212	2	8
5683	+7961213	2	8
5684	+7961214	2	8
5685	+7961215	2	8
5686	+7961216	2	8
5687	+7961217	2	8
5688	+7961218	2	8
5689	+7961219	2	8
5690	+7961220	2	8
5691	+7961221	2	8
5692	+7961222	2	8
5693	+7961223	2	8
5694	+7961224	2	8
5695	+7961225	2	8
5696	+7961226	2	8
5697	+7961227	2	8
5698	+7961228	2	8
5699	+7961229	2	8
5700	+7961230	2	8
5701	+7961231	2	8
5702	+7961232	2	8
5703	+7961233	2	8
5704	+7961234	2	8
5705	+7961235	2	8
5706	+7961236	2	8
5707	+7961237	2	8
5708	+7961238	2	8
5709	+7961239	2	8
5710	+7961240	2	8
5711	+7961241	2	8
5712	+7961242	2	8
5713	+7961243	2	8
5714	+7961244	2	8
5715	+7961245	2	8
5716	+7961246	2	8
5717	+7961247	2	8
5718	+7961248	2	8
5719	+7961249	2	8
5720	+796125	2	7
5721	+7961260	2	8
5722	+7961261	2	8
5723	+7961262	2	8
5724	+7961263	2	8
5725	+7961264	2	8
5726	+7961265	2	8
5727	+7961266	2	8
5728	+7961267	2	8
5729	+7961268	2	8
5730	+7961269	2	8
5731	+7961270	2	8
5732	+7961271	2	8
5733	+7961272	2	8
5734	+7961273	2	8
5735	+7961274	2	8
5736	+7961275	2	8
5737	+7961276	2	8
5738	+7961277	2	8
5739	+7961278	2	8
5740	+7961279	2	8
5741	+7961280	2	8
5742	+7961281	2	8
5743	+7961282	2	8
5744	+7961283	2	8
5745	+7961284	2	8
5746	+7961285	2	8
5747	+7961286	2	8
5748	+7961287	2	8
5749	+7961288	2	8
5750	+7961289	2	8
5751	+7961290	2	8
5752	+7961291	2	8
5753	+7961292	2	8
5754	+7961293	2	8
5755	+7961294	2	8
5756	+7961295	2	8
5757	+7961296	2	8
5758	+7961297	2	8
5759	+7961298	2	8
5760	+7961299	2	8
5761	+7961300	2	8
5762	+7961301	2	8
5763	+7961302	2	8
5764	+7961303	2	8
5765	+7961304	2	8
5766	+7961305	2	8
5767	+7961306	2	8
5768	+7961307	2	8
5769	+7961308	2	8
5770	+7961309	2	8
5771	+7961310	2	8
5772	+7961311	2	8
5773	+7961312	2	8
5774	+7961313	2	8
5775	+7961314	2	8
5776	+7961315	2	8
5777	+7961316	2	8
5778	+7961317	2	8
5779	+7961318	2	8
5780	+7961319	2	8
5781	+7961320	2	8
5782	+7961321	2	8
5783	+7961322	2	8
5784	+7961323	2	8
5785	+7961324	2	8
5786	+7961325	2	8
5787	+7961326	2	8
5788	+7961327	2	8
5789	+7961328	2	8
5790	+7961329	2	8
5791	+7961330	2	8
5792	+7961331	2	8
5793	+7961332	2	8
5794	+7961333	2	8
5795	+7961334	2	8
5796	+7961335	2	8
5797	+7961336	2	8
5798	+7961337	2	8
5799	+796133	2	7
5800	+796134	2	7
5801	+7961349	2	8
5802	+7961350	2	8
5803	+7961351	2	8
5804	+7961352	2	8
5805	+7961353	2	8
5806	+7961354	2	8
5807	+7961355	2	8
5808	+7961356	2	8
5809	+7961357	2	8
5810	+7961358	2	8
5811	+7961359	2	8
5812	+7961360	2	8
5813	+7961361	2	8
5814	+7961362	2	8
5815	+7961363	2	8
5816	+7961364	2	8
5817	+7961365	2	8
5818	+7961366	2	8
5819	+7961367	2	8
5820	+7961368	2	8
5821	+7961369	2	8
5822	+7961370	2	8
5823	+7961371	2	8
5824	+7961372	2	8
5825	+7961373	2	8
5826	+7961374	2	8
5827	+7961375	2	8
5828	+7961376	2	8
5829	+7961377	2	8
5830	+7961378	2	8
5831	+7961379	2	8
5832	+7961380	2	8
5833	+7961381	2	8
5834	+7961382	2	8
5835	+7961383	2	8
5836	+7961384	2	8
5837	+7961385	2	8
5838	+7961386	2	8
5839	+7961387	2	8
5840	+7961388	2	8
5841	+7961389	2	8
5842	+7961390	2	8
5843	+7961391	2	8
5844	+7961392	2	8
5845	+7961393	2	8
5846	+7961394	2	8
5847	+7961395	2	8
5848	+7961396	2	8
5849	+7961397	2	8
5850	+7961398	2	8
5851	+7961399	2	8
5852	+796140	2	7
5853	+796141	2	7
5854	+796142	2	7
5855	+796143	2	7
5856	+796144	2	7
5857	+796145	2	7
5858	+796146	2	7
5859	+796147	2	7
5860	+796148	2	7
5861	+796149	2	7
5862	+796150	2	7
5863	+796151	2	7
5864	+796152	2	7
5865	+796153	2	7
5866	+796154	2	7
5867	+7961550	2	8
5868	+7961551	2	8
5869	+7961552	2	8
5870	+7961553	2	8
5871	+7961554	2	8
5872	+7961555	2	8
5873	+7961556	2	8
5874	+7961557	2	8
5875	+7961558	2	8
5876	+7961559	2	8
5877	+7961560	2	8
5878	+7961561	2	8
5879	+7961562	2	8
5880	+7961563	2	8
5881	+7961564	2	8
5882	+7961565	2	8
5883	+7961566	2	8
5884	+7961567	2	8
5885	+7961568	2	8
5886	+7961569	2	8
5887	+7961570	2	8
5888	+7961571	2	8
5889	+7961572	2	8
5890	+7961573	2	8
5891	+7961574	2	8
5892	+7961575	2	8
5893	+7961576	2	8
5894	+7961577	2	8
5895	+7961578	2	8
5896	+7961579	2	8
5897	+796158	2	7
5898	+796159	2	7
5899	+7961600	2	8
5900	+7961601	2	8
5901	+7961602	2	8
5902	+7961603	2	8
5903	+7961604	2	8
5904	+7961605	2	8
5905	+7961606	2	8
5906	+7961607	2	8
5907	+7961608	2	8
5908	+7961609	2	8
5909	+7961610	2	8
5910	+7961611	2	8
5911	+7961612	2	8
5912	+7961613	2	8
5913	+7961614	2	8
5914	+7961615	2	8
5915	+7961616	2	8
5916	+7961617	2	8
5917	+7961618	2	8
5918	+7961619	2	8
5919	+7961620	2	8
5920	+7961621	2	8
5921	+7961622	2	8
5922	+7961623	2	8
5923	+7961624	2	8
5924	+7961625	2	8
5925	+7961626	2	8
5926	+7961627	2	8
5927	+7961628	2	8
5928	+7961629	2	8
5929	+796163	2	7
5930	+7961640	2	8
5931	+7961641	2	8
5932	+7961642	2	8
5933	+7961643	2	8
5934	+7961644	2	8
5935	+7961645	2	8
5936	+7961646	2	8
5937	+7961647	2	8
5938	+7961648	2	8
5939	+7961649	2	8
5940	+7961650	2	8
5941	+7961651	2	8
5942	+7961652	2	8
5943	+7961653	2	8
5944	+7961654	2	8
5945	+7961655	2	8
5946	+7961656	2	8
5947	+7961657	2	8
5948	+7961658	2	8
5949	+7961659	2	8
5950	+7961660	2	8
5951	+7961661	2	8
5952	+7961662	2	8
5953	+7961663	2	8
5954	+7961664	2	8
5955	+7961665	2	8
5956	+7961666	2	8
5957	+7961667	2	8
5958	+7961668	2	8
5959	+7961669	2	8
5960	+7961670	2	8
5961	+7961671	2	8
5962	+7961672	2	8
5963	+7961673	2	8
5964	+7961674	2	8
5965	+7961675	2	8
5966	+7961676	2	8
5967	+7961677	2	8
5968	+7961678	2	8
5969	+7961679	2	8
5970	+7961680	2	8
5971	+7961681	2	8
5972	+7961682	2	8
5973	+7961683	2	8
5974	+7961684	2	8
5975	+7961685	2	8
5976	+7961686	2	8
5977	+7961687	2	8
5978	+7961688	2	8
5979	+7961689	2	8
5980	+7961690	2	8
5981	+7961691	2	8
5982	+7961692	2	8
5983	+7961693	2	8
5984	+7961694	2	8
5985	+7961695	2	8
5986	+7961696	2	8
5987	+7961697	2	8
5988	+7961698	2	8
5989	+7961699	2	8
5990	+796170	2	7
5991	+796171	2	7
5992	+796172	2	7
5993	+7961730	2	8
5994	+7961731	2	8
5995	+7961732	2	8
5996	+7961733	2	8
5997	+7961734	2	8
5998	+7961735	2	8
5999	+7961736	2	8
6000	+7961737	2	8
6001	+7961738	2	8
6002	+7961739	2	8
6003	+7961740	2	8
6004	+7961741	2	8
6005	+7961742	2	8
6006	+7961743	2	8
6007	+7961744	2	8
6008	+7961745	2	8
6009	+7961746	2	8
6010	+7961747	2	8
6011	+7961748	2	8
6012	+7961749	2	8
6013	+7961750	2	8
6014	+7961751	2	8
6015	+7961752	2	8
6016	+7961753	2	8
6017	+7961754	2	8
6018	+7961755	2	8
6019	+7961756	2	8
6020	+7961757	2	8
6021	+7961758	2	8
6022	+7961759	2	8
6023	+7961760	2	8
6024	+7961761	2	8
6025	+7961762	2	8
6026	+7961763	2	8
6027	+7961764	2	8
6028	+7961765	2	8
6029	+7961766	2	8
6030	+7961767	2	8
6031	+7961768	2	8
6032	+7961769	2	8
6033	+7961770	2	8
6034	+7961771	2	8
6035	+7961772	2	8
6036	+7961773	2	8
6037	+7961774	2	8
6038	+7961775	2	8
6039	+7961776	2	8
6040	+7961777	2	8
6041	+7961778	2	8
6042	+7961779	2	8
6043	+7961780	2	8
6044	+7961781	2	8
6045	+7961782	2	8
6046	+7961783	2	8
6047	+7961784	2	8
6048	+7961785	2	8
6049	+7961786	2	8
6050	+7961787	2	8
6051	+7961788	2	8
6052	+7961789	2	8
6053	+7961790	2	8
6054	+7961791	2	8
6055	+7961792	2	8
6056	+7961793	2	8
6057	+7961794	2	8
6058	+7961795	2	8
6059	+7961796	2	8
6060	+7961797	2	8
6061	+7961798	2	8
6062	+7961799	2	8
6063	+7961800	2	8
6064	+7961801	2	8
6065	+7961802	2	8
6066	+7961803	2	8
6067	+7961804	2	8
6068	+7961805	2	8
6069	+7961806	2	8
6070	+7961807	2	8
6071	+7961808	2	8
6072	+7961809	2	8
6073	+7961810	2	8
6074	+7961811	2	8
6075	+7961812	2	8
6076	+7961813	2	8
6077	+7961814	2	8
6078	+7961815	2	8
6079	+7961816	2	8
6080	+7961817	2	8
6081	+7961818	2	8
6082	+7961819	2	8
6083	+7961820	2	8
6084	+7961821	2	8
6085	+7961822	2	8
6086	+7961823	2	8
6087	+7961824	2	8
6088	+7961825	2	8
6089	+7961826	2	8
6090	+7961827	2	8
6091	+7961828	2	8
6092	+7961829	2	8
6093	+7961830	2	8
6094	+7961831	2	8
6095	+7961832	2	8
6096	+7961833	2	8
6097	+7961834	2	8
6098	+7961835	2	8
6099	+7961836	2	8
6100	+7961837	2	8
6101	+7961838	2	8
6102	+7961840	2	8
6103	+7961841	2	8
6104	+7961842	2	8
6105	+7961843	2	8
6106	+7961844	2	8
6107	+7961845	2	8
6108	+7961846	2	8
6109	+7961847	2	8
6110	+7961848	2	8
6111	+7961849	2	8
6112	+796185	2	7
6113	+796186	2	7
6114	+796187	2	7
6115	+7961880	2	8
6116	+7961881	2	8
6117	+7961882	2	8
6118	+7961883	2	8
6119	+7961884	2	8
6120	+7961885	2	8
6121	+7961886	2	8
6122	+7961887	2	8
6123	+7961888	2	8
6124	+7961889	2	8
6125	+7961890	2	8
6126	+7961891	2	8
6127	+7961892	2	8
6128	+7961893	2	8
6129	+7961894	2	8
6130	+7961895	2	8
6131	+7961896	2	8
6132	+7961897	2	8
6133	+7961898	2	8
6134	+7961899	2	8
6135	+796190	2	7
6136	+796191	2	7
6137	+796192	2	7
6138	+796193	2	7
6139	+796194	2	7
6140	+796195	2	7
6141	+796196	2	7
6142	+7961970	2	8
6143	+7961971	2	8
6144	+7961972	2	8
6145	+7961973	2	8
6146	+7961974	2	8
6147	+7961975	2	8
6148	+7961976	2	8
6149	+7961977	2	8
6150	+7961978	2	8
6151	+7961979	2	8
6152	+7961980	2	8
6153	+7961981	2	8
6154	+7961982	2	8
6155	+7961983	2	8
6156	+7961984	2	8
6157	+7961985	2	8
6158	+7961986	2	8
6159	+7961987	2	8
6160	+7961988	2	8
6161	+7961989	2	8
6162	+7961990	2	8
6163	+7961991	2	8
6164	+7961992	2	8
6165	+7961993	2	8
6166	+7961994	2	8
6167	+7961995	2	8
6168	+7961996	2	8
6169	+7961997	2	8
6170	+7961998	2	8
6171	+7961999	2	8
6172	+796200	2	7
6173	+796201	2	7
6174	+796202	2	7
6175	+796203	2	7
6176	+796204	2	7
6177	+796205	2	7
6178	+7962060	2	8
6179	+7962061	2	8
6180	+7962062	2	8
6181	+7962063	2	8
6182	+7962064	2	8
6183	+7962065	2	8
6184	+7962066	2	8
6185	+7962067	2	8
6186	+7962068	2	8
6187	+7962069	2	8
6188	+7962070	2	8
6189	+7962071	2	8
6190	+7962072	2	8
6191	+7962073	2	8
6192	+7962074	2	8
6193	+7962075	2	8
6194	+7962076	2	8
6195	+7962077	2	8
6196	+7962078	2	8
6197	+7962079	2	8
6198	+7962080	2	8
6199	+7962081	2	8
6200	+7962082	2	8
6201	+7962083	2	8
6202	+7962084	2	8
6203	+7962085	2	8
6204	+7962086	2	8
6205	+7962087	2	8
6206	+7962088	2	8
6207	+7962089	2	8
6208	+7962090	2	8
6209	+7962091	2	8
6210	+7962092	2	8
6211	+7962093	2	8
6212	+7962094	2	8
6213	+7962095	2	8
6214	+7962096	2	8
6215	+7962097	2	8
6216	+7962098	2	8
6217	+7962099	2	8
6218	+796213	2	7
6219	+796214	2	7
6220	+7962150	2	8
6221	+7962151	2	8
6222	+7962155	2	8
6223	+7962156	2	8
6224	+7962157	2	8
6225	+7962158	2	8
6226	+7962159	2	8
6227	+7962160	2	8
6228	+7962161	2	8
6229	+7962162	2	8
6230	+7962163	2	8
6231	+7962164	2	8
6232	+7962165	2	8
6233	+7962166	2	8
6234	+7962167	2	8
6235	+7962168	2	8
6236	+7962169	2	8
6237	+796217	2	7
6238	+796218	2	7
6239	+796219	2	7
6240	+7962200	2	8
6241	+7962201	2	8
6242	+7962202	2	8
6243	+7962203	2	8
6244	+7962204	2	8
6245	+7962205	2	8
6246	+7962206	2	8
6247	+7962207	2	8
6248	+7962208	2	8
6249	+7962209	2	8
6250	+7962210	2	8
6251	+7962211	2	8
6252	+7962212	2	8
6253	+7962213	2	8
6254	+7962214	2	8
6255	+7962215	2	8
6256	+7962216	2	8
6257	+7962217	2	8
6258	+7962218	2	8
6259	+7962219	2	8
6260	+796222	2	7
6261	+796223	2	7
6262	+796224	2	7
6263	+796225	2	7
6264	+796226	2	7
6265	+796227	2	7
6266	+7962280	2	8
6267	+7962281	2	8
6268	+7962282	2	8
6269	+7962283	2	8
6270	+7962284	2	8
6271	+7962285	2	8
6272	+7962286	2	8
6273	+7962287	2	8
6274	+7962288	2	8
6275	+7962289	2	8
6276	+7962290	2	8
6277	+7962291	2	8
6278	+7962292	2	8
6279	+7962293	2	8
6280	+7962294	2	8
6281	+7962295	2	8
6282	+7962296	2	8
6283	+7962297	2	8
6284	+7962298	2	8
6285	+7962299	2	8
6286	+796230	2	7
6287	+796231	2	7
6288	+7962320	2	8
6289	+7962321	2	8
6290	+7962322	2	8
6291	+7962323	2	8
6292	+7962324	2	8
6293	+7962325	2	8
6294	+7962326	2	8
6295	+7962327	2	8
6296	+7962328	2	8
6297	+7962329	2	8
6298	+7962330	2	8
6299	+7962331	2	8
6300	+7962332	2	8
6301	+7962333	2	8
6302	+7962334	2	8
6303	+7962335	2	8
6304	+7962336	2	8
6305	+7962337	2	8
6306	+7962338	2	8
6307	+7962339	2	8
6308	+796234	2	7
6309	+7962350	2	8
6310	+7962351	2	8
6311	+7962352	2	8
6312	+7962353	2	8
6313	+7962354	2	8
6314	+7962355	2	8
6315	+7962356	2	8
6316	+7962357	2	8
6317	+7962358	2	8
6318	+7962359	2	8
6319	+796236	2	7
6320	+7962370	2	8
6321	+7962371	2	8
6322	+7962372	2	8
6323	+7962373	2	8
6324	+7962374	2	8
6325	+7962375	2	8
6326	+7962376	2	8
6327	+7962377	2	8
6328	+7962378	2	8
6329	+7962379	2	8
6330	+7962380	2	8
6331	+7962381	2	8
6332	+7962382	2	8
6333	+7962383	2	8
6334	+7962384	2	8
6335	+7962385	2	8
6336	+7962386	2	8
6337	+7962387	2	8
6338	+7962388	2	8
6339	+7962389	2	8
6340	+7962390	2	8
6341	+7962391	2	8
6342	+7962392	2	8
6343	+7962393	2	8
6344	+7962394	2	8
6345	+7962395	2	8
6346	+7962396	2	8
6347	+7962397	2	8
6348	+7962398	2	8
6349	+7962399	2	8
6350	+7962400	2	8
6351	+7962401	2	8
6352	+7962402	2	8
6353	+7962403	2	8
6354	+7962404	2	8
6355	+7962405	2	8
6356	+7962406	2	8
6357	+7962407	2	8
6358	+7962408	2	8
6359	+7962409	2	8
6360	+7962410	2	8
6361	+7962411	2	8
6362	+7962412	2	8
6363	+7962413	2	8
6364	+796242	2	7
6365	+796243	2	7
6366	+796244	2	7
6367	+796245	2	7
6368	+796246	2	7
6369	+7962470	2	8
6370	+7962471	2	8
6371	+7962472	2	8
6372	+7962473	2	8
6373	+7962474	2	8
6374	+7962475	2	8
6375	+7962476	2	8
6376	+7962477	2	8
6377	+7962478	2	8
6378	+7962479	2	8
6379	+7962480	2	8
6380	+7962481	2	8
6381	+7962482	2	8
6382	+7962483	2	8
6383	+7962484	2	8
6384	+7962485	2	8
6385	+7962486	2	8
6386	+7962487	2	8
6387	+7962488	2	8
6388	+7962489	2	8
6389	+7962490	2	8
6390	+7962491	2	8
6391	+7962492	2	8
6392	+7962493	2	8
6393	+7962494	2	8
6394	+7962495	2	8
6395	+7962496	2	8
6396	+7962497	2	8
6397	+7962498	2	8
6398	+7962499	2	8
6399	+7962500	2	8
6400	+7962501	2	8
6401	+7962502	2	8
6402	+7962503	2	8
6403	+7962504	2	8
6404	+7962505	2	8
6405	+7962506	2	8
6406	+7962507	2	8
6407	+7962508	2	8
6408	+7962509	2	8
6409	+7962510	2	8
6410	+7962511	2	8
6411	+7962512	2	8
6412	+7962513	2	8
6413	+7962514	2	8
6414	+7962515	2	8
6415	+7962516	2	8
6416	+7962517	2	8
6417	+7962518	2	8
6418	+7962519	2	8
6419	+7962520	2	8
6420	+7962521	2	8
6421	+7962522	2	8
6422	+7962523	2	8
6423	+7962524	2	8
6424	+7962525	2	8
6425	+7962526	2	8
6426	+7962527	2	8
6427	+7962528	2	8
6428	+7962529	2	8
6429	+7962530	2	8
6430	+7962531	2	8
6431	+7962532	2	8
6432	+7962533	2	8
6433	+7962534	2	8
6434	+7962535	2	8
6435	+7962536	2	8
6436	+7962537	2	8
6437	+7962538	2	8
6438	+7962539	2	8
6439	+7962540	2	8
6440	+7962541	2	8
6441	+7962542	2	8
6442	+7962543	2	8
6443	+7962544	2	8
6444	+7962545	2	8
6445	+7962546	2	8
6446	+7962547	2	8
6447	+7962548	2	8
6448	+7962549	2	8
6449	+7962550	2	8
6450	+7962551	2	8
6451	+7962552	2	8
6452	+7962553	2	8
6453	+7962554	2	8
6454	+7962555	2	8
6455	+7962556	2	8
6456	+7962557	2	8
6457	+7962558	2	8
6458	+7962559	2	8
6459	+7962560	2	8
6460	+7962561	2	8
6461	+7962562	2	8
6462	+7962563	2	8
6463	+7962564	2	8
6464	+7962565	2	8
6465	+7962566	2	8
6466	+7962567	2	8
6467	+7962568	2	8
6468	+7962569	2	8
6469	+7962570	2	8
6470	+7962571	2	8
6471	+7962572	2	8
6472	+7962573	2	8
6473	+7962574	2	8
6474	+7962575	2	8
6475	+7962576	2	8
6476	+7962577	2	8
6477	+7962578	2	8
6478	+7962579	2	8
6479	+7962582	2	8
6480	+7962583	2	8
6481	+7962584	2	8
6482	+7962585	2	8
6483	+7962586	2	8
6484	+7962587	2	8
6485	+7962588	2	8
6486	+7962589	2	8
6487	+7962590	2	8
6488	+7962591	2	8
6489	+7962592	2	8
6490	+7962593	2	8
6491	+7962594	2	8
6492	+7962595	2	8
6493	+7962596	2	8
6494	+7962597	2	8
6495	+7962598	2	8
6496	+7962599	2	8
6497	+7962600	2	8
6498	+7962601	2	8
6499	+7962602	2	8
6500	+7962603	2	8
6501	+7962604	2	8
6502	+7962605	2	8
6503	+7962606	2	8
6504	+7962607	2	8
6505	+7962608	2	8
6506	+7962609	2	8
6507	+7962610	2	8
6508	+7962611	2	8
6509	+7962612	2	8
6510	+7962613	2	8
6511	+7962614	2	8
6512	+7962615	2	8
6513	+7962616	2	8
6514	+7962617	2	8
6515	+7962618	2	8
6516	+7962619	2	8
6517	+7962620	2	8
6518	+7962621	2	8
6519	+7962622	2	8
6520	+7962623	2	8
6521	+7962624	2	8
6522	+7962625	2	8
6523	+7962626	2	8
6524	+7962627	2	8
6525	+7962628	2	8
6526	+7962629	2	8
6527	+7962630	2	8
6528	+7962631	2	8
6529	+7962632	2	8
6530	+7962633	2	8
6531	+7962634	2	8
6532	+7962635	2	8
6533	+7962636	2	8
6534	+7962637	2	8
6535	+7962638	2	8
6536	+7962639	2	8
6537	+7962640	2	8
6538	+7962641	2	8
6539	+7962642	2	8
6540	+7962643	2	8
6541	+7962644	2	8
6542	+7962645	2	8
6543	+7962646	2	8
6544	+7962647	2	8
6545	+7962648	2	8
6546	+7962649	2	8
6547	+7962650	2	8
6548	+7962651	2	8
6549	+7962652	2	8
6550	+7962653	2	8
6551	+7962654	2	8
6552	+7962655	2	8
6553	+7962656	2	8
6554	+7962657	2	8
6555	+7962658	2	8
6556	+7962659	2	8
6557	+7962660	2	8
6558	+7962661	2	8
6559	+7962662	2	8
6560	+7962663	2	8
6561	+7962664	2	8
6562	+7962665	2	8
6563	+7962666	2	8
6564	+7962667	2	8
6565	+7962668	2	8
6566	+7962669	2	8
6567	+7962670	2	8
6568	+7962671	2	8
6569	+7962672	2	8
6570	+7962673	2	8
6571	+7962674	2	8
6572	+7962675	2	8
6573	+7962676	2	8
6574	+7962677	2	8
6575	+7962678	2	8
6576	+7962679	2	8
6577	+796268	2	7
6578	+796269	2	7
6579	+796270	2	7
6580	+796271	2	7
6581	+796272	2	7
6582	+7962730	2	8
6583	+7962731	2	8
6584	+7962732	2	8
6585	+7962733	2	8
6586	+7962734	2	8
6587	+7962735	2	8
6588	+7962736	2	8
6589	+7962737	2	8
6590	+7962738	2	8
6591	+7962739	2	8
6592	+7962740	2	8
6593	+7962741	2	8
6594	+7962742	2	8
6595	+7962743	2	8
6596	+7962744	2	8
6597	+7962745	2	8
6598	+7962746	2	8
6599	+7962747	2	8
6600	+7962748	2	8
6601	+7962749	2	8
6602	+7962750	2	8
6603	+7962751	2	8
6604	+7962752	2	8
6605	+7962753	2	8
6606	+7962754	2	8
6607	+7962755	2	8
6608	+7962756	2	8
6609	+7962757	2	8
6610	+7962758	2	8
6611	+7962759	2	8
6612	+7962760	2	8
6613	+7962761	2	8
6614	+7962762	2	8
6615	+7962763	2	8
6616	+7962764	2	8
6617	+7962765	2	8
6618	+7962766	2	8
6619	+7962767	2	8
6620	+7962768	2	8
6621	+7962769	2	8
6622	+7962770	2	8
6623	+7962771	2	8
6624	+7962772	2	8
6625	+7962773	2	8
6626	+7962774	2	8
6627	+7962775	2	8
6628	+7962776	2	8
6629	+7962777	2	8
6630	+7962778	2	8
6631	+7962779	2	8
6632	+7962780	2	8
6633	+7962781	2	8
6634	+7962782	2	8
6635	+7962783	2	8
6636	+7962784	2	8
6637	+7962785	2	8
6638	+7962786	2	8
6639	+7962787	2	8
6640	+7962788	2	8
6641	+7962789	2	8
6642	+796279	2	7
6643	+7962800	2	8
6644	+7962801	2	8
6645	+7962802	2	8
6646	+7962803	2	8
6647	+7962804	2	8
6648	+7962805	2	8
6649	+7962806	2	8
6650	+7962807	2	8
6651	+7962808	2	8
6652	+7962809	2	8
6653	+7962810	2	8
6654	+7962811	2	8
6655	+7962812	2	8
6656	+7962813	2	8
6657	+7962814	2	8
6658	+7962815	2	8
6659	+7962816	2	8
6660	+7962817	2	8
6661	+7962818	2	8
6662	+7962819	2	8
6663	+7962820	2	8
6664	+7962821	2	8
6665	+7962822	2	8
6666	+7962823	2	8
6667	+7962824	2	8
6668	+7962825	2	8
6669	+7962826	2	8
6670	+7962827	2	8
6671	+7962828	2	8
6672	+7962829	2	8
6673	+7962830	2	8
6674	+7962831	2	8
6675	+7962832	2	8
6676	+7962833	2	8
6677	+7962834	2	8
6678	+7962835	2	8
6679	+7962836	2	8
6680	+7962837	2	8
6681	+7962838	2	8
6682	+7962839	2	8
6683	+7962840	2	8
6684	+7962841	2	8
6685	+7962842	2	8
6686	+7962843	2	8
6687	+7962844	2	8
6688	+7962845	2	8
6689	+7962846	2	8
6690	+7962847	2	8
6691	+7962848	2	8
6692	+7962849	2	8
6693	+7962850	2	8
6694	+7962851	2	8
6695	+7962852	2	8
6696	+7962853	2	8
6697	+7962854	2	8
6698	+7962855	2	8
6699	+7962856	2	8
6700	+7962857	2	8
6701	+7962858	2	8
6702	+7962859	2	8
6703	+7962860	2	8
6704	+7962861	2	8
6705	+7962862	2	8
6706	+7962863	2	8
6707	+7962864	2	8
6708	+7962865	2	8
6709	+7962866	2	8
6710	+7962867	2	8
6711	+7962868	2	8
6712	+7962869	2	8
6713	+7962870	2	8
6714	+7962871	2	8
6715	+7962872	2	8
6716	+7962873	2	8
6717	+7962874	2	8
6718	+7962875	2	8
6719	+7962876	2	8
6720	+7962877	2	8
6721	+7962878	2	8
6722	+7962879	2	8
6723	+7962880	2	8
6724	+7962881	2	8
6725	+7962882	2	8
6726	+7962883	2	8
6727	+7962884	2	8
6728	+7962885	2	8
6729	+7962886	2	8
6730	+7962887	2	8
6731	+7962888	2	8
6732	+7962889	2	8
6733	+7962890	2	8
6734	+7962891	2	8
6735	+7962892	2	8
6736	+7962893	2	8
6737	+7962894	2	8
6738	+7962895	2	8
6739	+7962896	2	8
6740	+7962897	2	8
6741	+7962898	2	8
6742	+7962899	2	8
6743	+79629	2	6
6744	+7963000	2	8
6745	+7963001	2	8
6746	+7963002	2	8
6747	+7963003	2	8
6748	+7963004	2	8
6749	+7963005	2	8
6750	+7963006	2	8
6751	+7963007	2	8
6752	+7963008	2	8
6753	+7963009	2	8
6754	+7963010	2	8
6755	+7963011	2	8
6756	+7963012	2	8
6757	+7963013	2	8
6758	+7963014	2	8
6759	+7963015	2	8
6760	+7963016	2	8
6761	+7963017	2	8
6762	+7963018	2	8
6763	+7963019	2	8
6764	+7963020	2	8
6765	+7963021	2	8
6766	+7963022	2	8
6767	+7963023	2	8
6768	+7963024	2	8
6769	+7963025	2	8
6770	+7963026	2	8
6771	+7963027	2	8
6772	+7963028	2	8
6773	+7963029	2	8
6774	+7963030	2	8
6775	+7963031	2	8
6776	+7963032	2	8
6777	+7963033	2	8
6778	+7963034	2	8
6779	+7963035	2	8
6780	+7963036	2	8
6781	+7963037	2	8
6782	+7963038	2	8
6783	+7963039	2	8
6784	+7963040	2	8
6785	+7963041	2	8
6786	+7963042	2	8
6787	+7963043	2	8
6788	+7963044	2	8
6789	+7963045	2	8
6790	+7963046	2	8
6791	+7963047	2	8
6792	+7963048	2	8
6793	+7963049	2	8
6794	+7963050	2	8
6795	+7963051	2	8
6796	+7963052	2	8
6797	+7963053	2	8
6798	+7963054	2	8
6799	+7963055	2	8
6800	+7963056	2	8
6801	+7963057	2	8
6802	+7963058	2	8
6803	+7963059	2	8
6804	+7963060	2	8
6805	+7963061	2	8
6806	+7963062	2	8
6807	+7963063	2	8
6808	+7963064	2	8
6809	+7963065	2	8
6810	+7963066	2	8
6811	+7963067	2	8
6812	+7963068	2	8
6813	+7963069	2	8
6814	+7963070	2	8
6815	+7963071	2	8
6816	+7963072	2	8
6817	+7963073	2	8
6818	+7963074	2	8
6819	+7963075	2	8
6820	+7963076	2	8
6821	+7963077	2	8
6822	+7963078	2	8
6823	+7963079	2	8
6824	+7963080	2	8
6825	+7963081	2	8
6826	+7963082	2	8
6827	+7963083	2	8
6828	+7963084	2	8
6829	+7963085	2	8
6830	+7963086	2	8
6831	+7963087	2	8
6832	+7963088	2	8
6833	+7963089	2	8
6834	+7963090	2	8
6835	+7963091	2	8
6836	+7963092	2	8
6837	+7963093	2	8
6838	+7963094	2	8
6839	+7963095	2	8
6840	+7963096	2	8
6841	+7963097	2	8
6842	+7963098	2	8
6843	+7963099	2	8
6844	+7963100	2	8
6845	+7963101	2	8
6846	+7963102	2	8
6847	+7963103	2	8
6848	+7963104	2	8
6849	+7963105	2	8
6850	+7963106	2	8
6851	+7963107	2	8
6852	+7963108	2	8
6853	+7963109	2	8
6854	+7963110	2	8
6855	+7963111	2	8
6856	+7963112	2	8
6857	+7963113	2	8
6858	+7963114	2	8
6859	+7963115	2	8
6860	+7963116	2	8
6861	+7963117	2	8
6862	+7963118	2	8
6863	+7963119	2	8
6864	+7963120	2	8
6865	+7963121	2	8
6866	+7963122	2	8
6867	+7963123	2	8
6868	+7963124	2	8
6869	+7963125	2	8
6870	+7963126	2	8
6871	+7963127	2	8
6872	+7963128	2	8
6873	+7963129	2	8
6874	+7963130	2	8
6875	+7963131	2	8
6876	+7963132	2	8
6877	+7963133	2	8
6878	+7963134	2	8
6879	+7963135	2	8
6880	+7963136	2	8
6881	+7963137	2	8
6882	+7963138	2	8
6883	+7963139	2	8
6884	+7963140	2	8
6885	+7963141	2	8
6886	+7963142	2	8
6887	+7963143	2	8
6888	+7963144	2	8
6889	+7963145	2	8
6890	+7963146	2	8
6891	+7963147	2	8
6892	+7963148	2	8
6893	+7963149	2	8
6894	+7963150	2	8
6895	+7963151	2	8
6896	+7963152	2	8
6897	+7963153	2	8
6898	+7963154	2	8
6899	+7963155	2	8
6900	+7963156	2	8
6901	+7963157	2	8
6902	+7963158	2	8
6903	+7963159	2	8
6904	+7963160	2	8
6905	+7963161	2	8
6906	+7963162	2	8
6907	+7963163	2	8
6908	+7963164	2	8
6909	+7963165	2	8
6910	+7963166	2	8
6911	+7963167	2	8
6912	+7963168	2	8
6913	+7963169	2	8
6914	+7963170	2	8
6915	+7963171	2	8
6916	+7963172	2	8
6917	+7963173	2	8
6918	+7963174	2	8
6919	+7963175	2	8
6920	+7963176	2	8
6921	+7963177	2	8
6922	+7963178	2	8
6923	+7963179	2	8
6924	+7963180	2	8
6925	+7963181	2	8
6926	+7963182	2	8
6927	+7963183	2	8
6928	+7963184	2	8
6929	+7963185	2	8
6930	+7963186	2	8
6931	+7963187	2	8
6932	+7963188	2	8
6933	+7963189	2	8
6934	+7963190	2	8
6935	+7963191	2	8
6936	+7963192	2	8
6937	+7963193	2	8
6938	+7963194	2	8
6939	+7963195	2	8
6940	+7963196	2	8
6941	+7963197	2	8
6942	+7963198	2	8
6943	+7963199	2	8
6944	+7963201	2	8
6945	+7963202	2	8
6946	+7963203	2	8
6947	+7963204	2	8
6948	+7963205	2	8
6949	+7963206	2	8
6950	+7963207	2	8
6951	+7963208	2	8
6952	+7963209	2	8
6953	+7963210	2	8
6954	+7963211	2	8
6955	+7963212	2	8
6956	+7963213	2	8
6957	+7963214	2	8
6958	+7963215	2	8
6959	+7963216	2	8
6960	+7963217	2	8
6961	+7963218	2	8
6962	+7963219	2	8
6963	+7963220	2	8
6964	+7963221	2	8
6965	+7963222	2	8
6966	+7963223	2	8
6967	+7963224	2	8
6968	+7963225	2	8
6969	+7963226	2	8
6970	+7963227	2	8
6971	+7963228	2	8
6972	+7963229	2	8
6973	+7963230	2	8
6974	+7963231	2	8
6975	+7963232	2	8
6976	+7963233	2	8
6977	+7963234	2	8
6978	+7963235	2	8
6979	+7963236	2	8
6980	+7963237	2	8
6981	+7963238	2	8
6982	+7963239	2	8
6983	+7963240	2	8
6984	+7963241	2	8
6985	+7963242	2	8
6986	+7963243	2	8
6987	+7963244	2	8
6988	+7963245	2	8
6989	+7963246	2	8
6990	+7963247	2	8
6991	+7963248	2	8
6992	+7963249	2	8
6993	+7963250	2	8
6994	+7963251	2	8
6995	+7963252	2	8
6996	+7963253	2	8
6997	+7963254	2	8
6998	+7963255	2	8
6999	+7963256	2	8
7000	+7963257	2	8
7001	+7963258	2	8
7002	+7963259	2	8
7003	+7963260	2	8
7004	+7963261	2	8
7005	+7963262	2	8
7006	+7963263	2	8
7007	+7963264	2	8
7008	+7963265	2	8
7009	+7963266	2	8
7010	+7963267	2	8
7011	+7963268	2	8
7012	+7963269	2	8
7013	+7963270	2	8
7014	+7963271	2	8
7015	+7963272	2	8
7016	+7963273	2	8
7017	+7963274	2	8
7018	+7963275	2	8
7019	+7963276	2	8
7020	+7963277	2	8
7021	+7963278	2	8
7022	+7963279	2	8
7023	+7963280	2	8
7024	+7963281	2	8
7025	+7963282	2	8
7026	+7963283	2	8
7027	+7963284	2	8
7028	+7963285	2	8
7029	+7963286	2	8
7030	+7963287	2	8
7031	+7963288	2	8
7032	+796329	2	7
7033	+7963300	2	8
7034	+7963301	2	8
7035	+7963302	2	8
7036	+7963303	2	8
7037	+7963304	2	8
7038	+7963305	2	8
7039	+7963306	2	8
7040	+7963307	2	8
7041	+7963308	2	8
7042	+7963309	2	8
7043	+7963310	2	8
7044	+7963311	2	8
7045	+7963312	2	8
7046	+7963313	2	8
7047	+7963314	2	8
7048	+7963315	2	8
7049	+7963316	2	8
7050	+7963317	2	8
7051	+7963318	2	8
7052	+7963319	2	8
7053	+7963320	2	8
7054	+7963321	2	8
7055	+7963322	2	8
7056	+7963323	2	8
7057	+7963324	2	8
7058	+7963325	2	8
7059	+7963326	2	8
7060	+7963327	2	8
7061	+7963328	2	8
7062	+7963329	2	8
7063	+7963330	2	8
7064	+7963331	2	8
7065	+7963332	2	8
7066	+7963333	2	8
7067	+7963334	2	8
7068	+7963335	2	8
7069	+7963336	2	8
7070	+7963337	2	8
7071	+7963338	2	8
7072	+7963339	2	8
7073	+796334	2	7
7074	+7963350	2	8
7075	+7963351	2	8
7076	+7963352	2	8
7077	+7963353	2	8
7078	+7963354	2	8
7079	+7963355	2	8
7080	+7963356	2	8
7081	+7963357	2	8
7082	+7963358	2	8
7083	+7963359	2	8
7084	+7963360	2	8
7085	+7963361	2	8
7086	+7963362	2	8
7087	+7963363	2	8
7088	+7963364	2	8
7089	+7963365	2	8
7090	+7963366	2	8
7091	+7963367	2	8
7092	+7963368	2	8
7093	+7963369	2	8
7094	+7963370	2	8
7095	+7963371	2	8
7096	+7963372	2	8
7097	+7963373	2	8
7098	+7963374	2	8
7099	+7963375	2	8
7100	+7963376	2	8
7101	+7963377	2	8
7102	+7963378	2	8
7103	+7963379	2	8
7104	+796338	2	7
7105	+7963390	2	8
7106	+7963391	2	8
7107	+7963392	2	8
7108	+7963393	2	8
7109	+7963394	2	8
7110	+7963395	2	8
7111	+7963396	2	8
7112	+7963397	2	8
7113	+7963398	2	8
7114	+7963399	2	8
7115	+796340	2	7
7116	+796341	2	7
7117	+796342	2	7
7118	+7963430	2	8
7119	+7963431	2	8
7120	+7963432	2	8
7121	+7963433	2	8
7122	+7963434	2	8
7123	+7963435	2	8
7124	+7963436	2	8
7125	+7963437	2	8
7126	+7963438	2	8
7127	+7963439	2	8
7128	+796344	2	7
7129	+796345	2	7
7130	+796346	2	7
7131	+796347	2	7
7132	+7963480	2	8
7133	+7963481	2	8
7134	+7963482	2	8
7135	+7963483	2	8
7136	+7963484	2	8
7137	+7963485	2	8
7138	+7963486	2	8
7139	+7963487	2	8
7140	+7963488	2	8
7141	+7963489	2	8
7142	+7963490	2	8
7143	+7963491	2	8
7144	+7963492	2	8
7145	+7963493	2	8
7146	+7963494	2	8
7147	+7963495	2	8
7148	+7963496	2	8
7149	+7963497	2	8
7150	+7963498	2	8
7151	+7963499	2	8
7152	+7963500	2	8
7153	+7963501	2	8
7154	+7963502	2	8
7155	+7963503	2	8
7156	+7963504	2	8
7157	+7963505	2	8
7158	+7963506	2	8
7159	+7963507	2	8
7160	+7963508	2	8
7161	+7963509	2	8
7162	+7963510	2	8
7163	+7963511	2	8
7164	+7963512	2	8
7165	+7963513	2	8
7166	+7963514	2	8
7167	+7963515	2	8
7168	+7963516	2	8
7169	+7963517	2	8
7170	+7963518	2	8
7171	+7963519	2	8
7172	+796352	2	7
7173	+796353	2	7
7174	+796354	2	7
7175	+7963550	2	8
7176	+7963551	2	8
7177	+7963552	2	8
7178	+7963553	2	8
7179	+7963554	2	8
7180	+7963555	2	8
7181	+7963556	2	8
7182	+7963557	2	8
7183	+7963558	2	8
7184	+7963559	2	8
7185	+7963562	2	8
7186	+7963563	2	8
7187	+7963564	2	8
7188	+7963565	2	8
7189	+7963566	2	8
7190	+7963567	2	8
7191	+7963568	2	8
7192	+796357	2	7
7193	+796358	2	7
7194	+796359	2	7
7195	+79636	2	6
7196	+796370	2	7
7197	+7963710	2	8
7198	+7963711	2	8
7199	+7963712	2	8
7200	+7963713	2	8
7201	+7963714	2	8
7202	+7963715	2	8
7203	+7963716	2	8
7204	+7963717	2	8
7205	+7963718	2	8
7206	+7963719	2	8
7207	+796372	2	7
7208	+7963730	2	8
7209	+7963731	2	8
7210	+7963732	2	8
7211	+7963733	2	8
7212	+7963734	2	8
7213	+7963735	2	8
7214	+7963736	2	8
7215	+7963737	2	8
7216	+7963738	2	8
7217	+796374	2	7
7218	+7963750	2	8
7219	+7963751	2	8
7220	+7963752	2	8
7221	+7963753	2	8
7222	+7963754	2	8
7223	+7963755	2	8
7224	+7963756	2	8
7225	+7963757	2	8
7226	+7963758	2	8
7227	+7963759	2	8
7228	+796376	2	7
7229	+796377	2	7
7230	+796378	2	7
7231	+796379	2	7
7232	+796380	2	7
7233	+796381	2	7
7234	+796382	2	7
7235	+7963830	2	8
7236	+7963831	2	8
7237	+7963832	2	8
7238	+7963833	2	8
7239	+7963834	2	8
7240	+7963835	2	8
7241	+7963836	2	8
7242	+7963837	2	8
7243	+7963838	2	8
7244	+7963839	2	8
7245	+7963840	2	8
7246	+7963841	2	8
7247	+7963842	2	8
7248	+7963843	2	8
7249	+7963844	2	8
7250	+7963845	2	8
7251	+7963846	2	8
7252	+7963847	2	8
7253	+7963848	2	8
7254	+7963849	2	8
7255	+7963850	2	8
7256	+7963851	2	8
7257	+7963852	2	8
7258	+7963853	2	8
7259	+7963854	2	8
7260	+7963855	2	8
7261	+7963856	2	8
7262	+7963857	2	8
7263	+7963858	2	8
7264	+7963859	2	8
7265	+7963860	2	8
7266	+7963861	2	8
7267	+7963862	2	8
7268	+7963863	2	8
7269	+7963864	2	8
7270	+7963865	2	8
7271	+7963866	2	8
7272	+7963867	2	8
7273	+7963868	2	8
7274	+7963869	2	8
7275	+796387	2	7
7276	+7963880	2	8
7277	+7963881	2	8
7278	+7963882	2	8
7279	+7963883	2	8
7280	+7963884	2	8
7281	+7963885	2	8
7282	+7963886	2	8
7283	+7963887	2	8
7284	+7963888	2	8
7285	+7963889	2	8
7286	+7963890	2	8
7287	+7963891	2	8
7288	+7963892	2	8
7289	+7963893	2	8
7290	+7963894	2	8
7291	+7963895	2	8
7292	+7963896	2	8
7293	+7963897	2	8
7294	+7963898	2	8
7295	+796389	2	7
7296	+796390	2	7
7297	+796391	2	7
7298	+796392	2	7
7299	+7963930	2	8
7300	+7963931	2	8
7301	+7963932	2	8
7302	+7963933	2	8
7303	+7963934	2	8
7304	+7963935	2	8
7305	+7963936	2	8
7306	+7963937	2	8
7307	+7963938	2	8
7308	+7963939	2	8
7309	+7963940	2	8
7310	+7963941	2	8
7311	+7963942	2	8
7312	+7963943	2	8
7313	+7963944	2	8
7314	+7963945	2	8
7315	+7963946	2	8
7316	+7963947	2	8
7317	+7963948	2	8
7318	+7963949	2	8
7319	+7963950	2	8
7320	+7963951	2	8
7321	+7963952	2	8
7322	+7963953	2	8
7323	+7963954	2	8
7324	+7963955	2	8
7325	+7963956	2	8
7326	+7963957	2	8
7327	+7963958	2	8
7328	+7963959	2	8
7329	+796396	2	7
7330	+796397	2	7
7331	+796398	2	7
7332	+796399	2	7
7333	+7964000	2	8
7334	+7964001	2	8
7335	+7964002	2	8
7336	+7964003	2	8
7337	+7964004	2	8
7338	+7964005	2	8
7339	+7964006	2	8
7340	+7964007	2	8
7341	+7964008	2	8
7342	+7964009	2	8
7343	+7964010	2	8
7344	+7964011	2	8
7345	+7964012	2	8
7346	+7964013	2	8
7347	+7964014	2	8
7348	+7964015	2	8
7349	+7964016	2	8
7350	+7964017	2	8
7351	+7964018	2	8
7352	+7964019	2	8
7353	+7964020	2	8
7354	+7964021	2	8
7355	+7964022	2	8
7356	+7964023	2	8
7357	+7964024	2	8
7358	+7964025	2	8
7359	+7964026	2	8
7360	+7964027	2	8
7361	+7964028	2	8
7362	+7964029	2	8
7363	+7964030	2	8
7364	+7964031	2	8
7365	+7964032	2	8
7366	+7964033	2	8
7367	+7964034	2	8
7368	+7964035	2	8
7369	+7964036	2	8
7370	+7964037	2	8
7371	+7964038	2	8
7372	+7964039	2	8
7373	+7964040	2	8
7374	+7964041	2	8
7375	+7964042	2	8
7376	+7964043	2	8
7377	+7964044	2	8
7378	+7964045	2	8
7379	+7964046	2	8
7380	+7964047	2	8
7381	+7964048	2	8
7382	+7964049	2	8
7383	+7964050	2	8
7384	+7964051	2	8
7385	+7964052	2	8
7386	+7964053	2	8
7387	+7964054	2	8
7388	+7964055	2	8
7389	+7964056	2	8
7390	+7964057	2	8
7391	+7964058	2	8
7392	+7964059	2	8
7393	+7964060	2	8
7394	+7964061	2	8
7395	+7964062	2	8
7396	+7964063	2	8
7397	+7964064	2	8
7398	+7964065	2	8
7399	+7964066	2	8
7400	+7964067	2	8
7401	+7964068	2	8
7402	+7964069	2	8
7403	+7964070	2	8
7404	+7964071	2	8
7405	+7964072	2	8
7406	+7964073	2	8
7407	+7964074	2	8
7408	+7964075	2	8
7409	+7964076	2	8
7410	+7964077	2	8
7411	+7964078	2	8
7412	+7964079	2	8
7413	+796408	2	7
7414	+7964090	2	8
7415	+7964091	2	8
7416	+7964092	2	8
7417	+7964093	2	8
7418	+7964094	2	8
7419	+7964095	2	8
7420	+7964096	2	8
7421	+7964097	2	8
7422	+7964098	2	8
7423	+796410	2	7
7424	+796411	2	7
7425	+796412	2	7
7426	+7964130	2	8
7427	+7964131	2	8
7428	+7964132	2	8
7429	+7964133	2	8
7430	+7964134	2	8
7431	+7964135	2	8
7432	+7964136	2	8
7433	+7964137	2	8
7434	+796414	2	7
7435	+7964150	2	8
7436	+7964151	2	8
7437	+7964152	2	8
7438	+7964153	2	8
7439	+7964154	2	8
7440	+7964155	2	8
7441	+7964156	2	8
7442	+7964157	2	8
7443	+7964158	2	8
7444	+7964159	2	8
7445	+7964160	2	8
7446	+7964161	2	8
7447	+7964162	2	8
7448	+7964163	2	8
7449	+7964164	2	8
7450	+7964165	2	8
7451	+7964166	2	8
7452	+7964167	2	8
7453	+7964168	2	8
7454	+7964169	2	8
7455	+796417	2	7
7456	+7964180	2	8
7457	+7964181	2	8
7458	+7964182	2	8
7459	+7964183	2	8
7460	+7964184	2	8
7461	+7964185	2	8
7462	+7964186	2	8
7463	+7964187	2	8
7464	+7964188	2	8
7465	+7964189	2	8
7466	+7964190	2	8
7467	+7964191	2	8
7468	+7964192	2	8
7469	+7964193	2	8
7470	+7964194	2	8
7471	+7964195	2	8
7472	+7964196	2	8
7473	+7964197	2	8
7474	+7964198	2	8
7475	+7964199	2	8
7476	+796420	2	7
7477	+7964210	2	8
7478	+7964211	2	8
7479	+7964212	2	8
7480	+7964213	2	8
7481	+7964214	2	8
7482	+7964215	2	8
7483	+7964216	2	8
7484	+7964217	2	8
7485	+7964218	2	8
7486	+7964219	2	8
7487	+7964220	2	8
7488	+7964221	2	8
7489	+7964222	2	8
7490	+7964223	2	8
7491	+7964224	2	8
7492	+7964225	2	8
7493	+7964226	2	8
7494	+7964227	2	8
7495	+7964228	2	8
7496	+7964229	2	8
7497	+7964230	2	8
7498	+7964231	2	8
7499	+7964232	2	8
7500	+7964233	2	8
7501	+7964234	2	8
7502	+7964235	2	8
7503	+7964236	2	8
7504	+7964237	2	8
7505	+7964238	2	8
7506	+7964239	2	8
7507	+796424	2	7
7508	+796425	2	7
7509	+796426	2	7
7510	+796427	2	7
7511	+796428	2	7
7512	+796429	2	7
7513	+7964300	2	8
7514	+7964301	2	8
7515	+7964302	2	8
7516	+7964303	2	8
7517	+7964304	2	8
7518	+7964305	2	8
7519	+7964306	2	8
7520	+7964307	2	8
7521	+7964308	2	8
7522	+7964309	2	8
7523	+7964310	2	8
7524	+7964311	2	8
7525	+7964312	2	8
7526	+7964313	2	8
7527	+7964314	2	8
7528	+7964315	2	8
7529	+7964316	2	8
7530	+7964317	2	8
7531	+7964318	2	8
7532	+7964319	2	8
7533	+796432	2	7
7534	+796433	2	7
7535	+796434	2	7
7536	+796435	2	7
7537	+796436	2	7
7538	+796437	2	7
7539	+796438	2	7
7540	+796439	2	7
7541	+7964400	2	8
7542	+7964401	2	8
7543	+7964402	2	8
7544	+7964403	2	8
7545	+7964404	2	8
7546	+7964405	2	8
7547	+7964406	2	8
7548	+7964407	2	8
7549	+7964408	2	8
7550	+7964409	2	8
7551	+7964410	2	8
7552	+7964411	2	8
7553	+7964412	2	8
7554	+7964413	2	8
7555	+7964414	2	8
7556	+7964415	2	8
7557	+7964416	2	8
7558	+7964417	2	8
7559	+7964418	2	8
7560	+7964419	2	8
7561	+7964420	2	8
7562	+7964421	2	8
7563	+7964422	2	8
7564	+7964423	2	8
7565	+7964424	2	8
7566	+7964425	2	8
7567	+7964426	2	8
7568	+7964427	2	8
7569	+7964428	2	8
7570	+7964429	2	8
7571	+7964430	2	8
7572	+7964431	2	8
7573	+7964432	2	8
7574	+7964433	2	8
7575	+7964434	2	8
7576	+7964435	2	8
7577	+7964436	2	8
7578	+7964437	2	8
7579	+7964438	2	8
7580	+7964439	2	8
7581	+7964440	2	8
7582	+7964441	2	8
7583	+7964442	2	8
7584	+7964443	2	8
7585	+7964444	2	8
7586	+7964445	2	8
7587	+7964446	2	8
7588	+7964447	2	8
7589	+7964448	2	8
7590	+7964449	2	8
7591	+7964450	2	8
7592	+7964451	2	8
7593	+7964452	2	8
7594	+7964453	2	8
7595	+7964454	2	8
7596	+7964455	2	8
7597	+7964456	2	8
7598	+7964457	2	8
7599	+7964458	2	8
7600	+7964459	2	8
7601	+7964460	2	8
7602	+7964461	2	8
7603	+7964462	2	8
7604	+7964463	2	8
7605	+7964464	2	8
7606	+7964465	2	8
7607	+7964466	2	8
7608	+7964467	2	8
7609	+7964468	2	8
7610	+7964469	2	8
7611	+7964470	2	8
7612	+7964471	2	8
7613	+7964472	2	8
7614	+7964473	2	8
7615	+7964474	2	8
7616	+7964475	2	8
7617	+7964476	2	8
7618	+7964477	2	8
7619	+7964478	2	8
7620	+7964479	2	8
7621	+7964480	2	8
7622	+7964481	2	8
7623	+7964482	2	8
7624	+7964483	2	8
7625	+7964484	2	8
7626	+7964485	2	8
7627	+7964486	2	8
7628	+7964487	2	8
7629	+7964488	2	8
7630	+7964489	2	8
7631	+796449	2	7
7632	+796450	2	7
7633	+796451	2	7
7634	+796452	2	7
7635	+796453	2	7
7636	+796454	2	7
7637	+796455	2	7
7638	+796456	2	7
7639	+796457	2	7
7640	+796458	2	7
7641	+796459	2	7
7642	+796460	2	7
7643	+7964610	2	8
7644	+7964611	2	8
7645	+7964612	2	8
7646	+7964613	2	8
7647	+7964614	2	8
7648	+7964615	2	8
7649	+7964616	2	8
7650	+7964617	2	8
7651	+7964618	2	8
7652	+7964619	2	8
7653	+796462	2	7
7654	+796463	2	7
7655	+796464	2	7
7656	+796465	2	7
7657	+7964660	2	8
7658	+7964661	2	8
7659	+7964662	2	8
7660	+7964663	2	8
7661	+7964664	2	8
7662	+7964665	2	8
7663	+7964666	2	8
7664	+7964667	2	8
7665	+7964668	2	8
7666	+7964669	2	8
7667	+7964670	2	8
7668	+7964671	2	8
7669	+7964672	2	8
7670	+7964673	2	8
7671	+7964674	2	8
7672	+7964675	2	8
7673	+7964676	2	8
7674	+7964677	2	8
7675	+7964678	2	8
7676	+7964679	2	8
7677	+7964680	2	8
7678	+7964681	2	8
7679	+7964682	2	8
7680	+7964683	2	8
7681	+7964684	2	8
7682	+7964685	2	8
7683	+7964686	2	8
7684	+7964687	2	8
7685	+7964688	2	8
7686	+7964689	2	8
7687	+7964690	2	8
7688	+7964691	2	8
7689	+7964692	2	8
7690	+7964693	2	8
7691	+7964694	2	8
7692	+7964695	2	8
7693	+7964696	2	8
7694	+7964697	2	8
7695	+7964698	2	8
7696	+7964699	2	8
7697	+796470	2	7
7698	+796471	2	7
7699	+796472	2	7
7700	+796473	2	7
7701	+796474	2	7
7702	+796475	2	7
7703	+796476	2	7
7704	+796477	2	7
7705	+796478	2	7
7706	+796479	2	7
7707	+7964800	2	8
7708	+7964801	2	8
7709	+7964802	2	8
7710	+7964803	2	8
7711	+7964804	2	8
7712	+7964805	2	8
7713	+7964806	2	8
7714	+7964807	2	8
7715	+7964808	2	8
7716	+7964809	2	8
7717	+7964810	2	8
7718	+7964811	2	8
7719	+7964812	2	8
7720	+7964813	2	8
7721	+7964814	2	8
7722	+7964815	2	8
7723	+7964816	2	8
7724	+7964817	2	8
7725	+7964818	2	8
7726	+7964819	2	8
7727	+7964820	2	8
7728	+7964821	2	8
7729	+7964822	2	8
7730	+7964823	2	8
7731	+7964824	2	8
7732	+7964825	2	8
7733	+7964826	2	8
7734	+7964827	2	8
7735	+7964828	2	8
7736	+7964829	2	8
7737	+796483	2	7
7738	+7964840	2	8
7739	+7964841	2	8
7740	+7964842	2	8
7741	+7964843	2	8
7742	+7964844	2	8
7743	+7964845	2	8
7744	+7964846	2	8
7745	+7964847	2	8
7746	+7964848	2	8
7747	+7964849	2	8
7748	+7964850	2	8
7749	+7964851	2	8
7750	+7964852	2	8
7751	+7964853	2	8
7752	+7964854	2	8
7753	+7964855	2	8
7754	+7964856	2	8
7755	+7964857	2	8
7756	+7964858	2	8
7757	+7964859	2	8
7758	+7964860	2	8
7759	+7964861	2	8
7760	+7964862	2	8
7761	+7964863	2	8
7762	+7964864	2	8
7763	+7964865	2	8
7764	+7964866	2	8
7765	+7964867	2	8
7766	+7964868	2	8
7767	+7964869	2	8
7768	+7964870	2	8
7769	+7964871	2	8
7770	+7964872	2	8
7771	+7964873	2	8
7772	+7964874	2	8
7773	+7964875	2	8
7774	+7964876	2	8
7775	+7964877	2	8
7776	+7964878	2	8
7777	+7964879	2	8
7778	+796488	2	7
7779	+796489	2	7
7780	+796490	2	7
7781	+796491	2	7
7782	+796492	2	7
7783	+796493	2	7
7784	+796494	2	7
7785	+7964950	2	8
7786	+7964951	2	8
7787	+7964952	2	8
7788	+7964953	2	8
7789	+7964954	2	8
7790	+7964955	2	8
7791	+7964956	2	8
7792	+7964957	2	8
7793	+7964958	2	8
7794	+7964959	2	8
7795	+7964960	2	8
7796	+7964961	2	8
7797	+7964962	2	8
7798	+7964963	2	8
7799	+7964964	2	8
7800	+7964965	2	8
7801	+7964966	2	8
7802	+7964967	2	8
7803	+7964968	2	8
7804	+7964969	2	8
7805	+7964970	2	8
7806	+7964971	2	8
7807	+7964972	2	8
7808	+7964973	2	8
7809	+7964974	2	8
7810	+7964975	2	8
7811	+7964976	2	8
7812	+7964977	2	8
7813	+7964978	2	8
7814	+7964979	2	8
7815	+7964980	2	8
7816	+7964981	2	8
7817	+7964982	2	8
7818	+7964983	2	8
7819	+7964984	2	8
7820	+7964985	2	8
7821	+7964986	2	8
7822	+7964987	2	8
7823	+7964988	2	8
7824	+7964989	2	8
7825	+7964990	2	8
7826	+7964991	2	8
7827	+7964992	2	8
7828	+7964993	2	8
7829	+7964994	2	8
7830	+7964995	2	8
7831	+7964996	2	8
7832	+7964997	2	8
7833	+7964998	2	8
7834	+7964999	2	8
7835	+79650	2	6
7836	+79651	2	6
7837	+796520	2	7
7838	+796521	2	7
7839	+796522	2	7
7840	+796523	2	7
7841	+796524	2	7
7842	+796525	2	7
7843	+796526	2	7
7844	+796527	2	7
7845	+796528	2	7
7846	+796529	2	7
7847	+796530	2	7
7848	+796531	2	7
7849	+796532	2	7
7850	+796533	2	7
7851	+796534	2	7
7852	+796535	2	7
7853	+796536	2	7
7854	+796537	2	7
7855	+796538	2	7
7856	+796539	2	7
7857	+796540	2	7
7858	+796541	2	7
7859	+796542	2	7
7860	+796543	2	7
7861	+796544	2	7
7862	+7965450	2	8
7863	+7965451	2	8
7864	+7965452	2	8
7865	+7965453	2	8
7866	+7965454	2	8
7867	+7965455	2	8
7868	+7965456	2	8
7869	+7965457	2	8
7870	+7965458	2	8
7871	+7965459	2	8
7872	+7965460	2	8
7873	+7965461	2	8
7874	+7965462	2	8
7875	+7965463	2	8
7876	+7965464	2	8
7877	+7965465	2	8
7878	+7965466	2	8
7879	+7965467	2	8
7880	+7965468	2	8
7881	+7965469	2	8
7882	+7965470	2	8
7883	+7965471	2	8
7884	+7965472	2	8
7885	+7965473	2	8
7886	+7965474	2	8
7887	+7965475	2	8
7888	+7965476	2	8
7889	+7965477	2	8
7890	+7965478	2	8
7891	+7965479	2	8
7892	+7965480	2	8
7893	+7965481	2	8
7894	+7965482	2	8
7895	+7965483	2	8
7896	+7965484	2	8
7897	+7965485	2	8
7898	+7965486	2	8
7899	+7965487	2	8
7900	+7965488	2	8
7901	+7965489	2	8
7902	+7965490	2	8
7903	+7965491	2	8
7904	+7965492	2	8
7905	+7965493	2	8
7906	+7965494	2	8
7907	+7965495	2	8
7908	+7965496	2	8
7909	+7965497	2	8
7910	+7965498	2	8
7911	+7965499	2	8
7912	+796550	2	7
7913	+796551	2	7
7914	+796552	2	7
7915	+796553	2	7
7916	+796554	2	7
7917	+796555	2	7
7918	+796556	2	7
7919	+796557	2	7
7920	+796558	2	7
7921	+796559	2	7
7922	+7965600	2	8
7923	+7965601	2	8
7924	+7965602	2	8
7925	+7965603	2	8
7926	+7965604	2	8
7927	+7965605	2	8
7928	+7965606	2	8
7929	+7965607	2	8
7930	+7965608	2	8
7931	+7965609	2	8
7932	+7965610	2	8
7933	+7965611	2	8
7934	+7965612	2	8
7935	+7965613	2	8
7936	+7965614	2	8
7937	+7965615	2	8
7938	+7965616	2	8
7939	+7965617	2	8
7940	+7965618	2	8
7941	+7965619	2	8
7942	+7965620	2	8
7943	+7965621	2	8
7944	+7965622	2	8
7945	+7965623	2	8
7946	+7965624	2	8
7947	+7965625	2	8
7948	+7965626	2	8
7949	+7965627	2	8
7950	+7965628	2	8
7951	+7965629	2	8
7952	+796563	2	7
7953	+796564	2	7
7954	+796565	2	7
7955	+796566	2	7
7956	+7965670	2	8
7957	+7965671	2	8
7958	+7965672	2	8
7959	+7965673	2	8
7960	+7965674	2	8
7961	+7965675	2	8
7962	+7965676	2	8
7963	+7965677	2	8
7964	+7965678	2	8
7965	+7965679	2	8
7966	+796568	2	7
7967	+7965690	2	8
7968	+7965691	2	8
7969	+7965692	2	8
7970	+7965693	2	8
7971	+7965694	2	8
7972	+7965695	2	8
7973	+7965696	2	8
7974	+7965697	2	8
7975	+7965698	2	8
7976	+7965699	2	8
7977	+796570	2	7
7978	+7965710	2	8
7979	+7965711	2	8
7980	+7965712	2	8
7981	+7965713	2	8
7982	+7965714	2	8
7983	+7965715	2	8
7984	+7965716	2	8
7985	+7965717	2	8
7986	+7965718	2	8
7987	+7965719	2	8
7988	+7965720	2	8
7989	+7965721	2	8
7990	+7965722	2	8
7991	+7965723	2	8
7992	+7965724	2	8
7993	+7965725	2	8
7994	+7965726	2	8
7995	+7965727	2	8
7996	+7965728	2	8
7997	+7965729	2	8
7998	+7965730	2	8
7999	+7965731	2	8
8000	+7965732	2	8
8001	+7965733	2	8
8002	+7965734	2	8
8003	+7965735	2	8
8004	+7965736	2	8
8005	+7965737	2	8
8006	+7965738	2	8
8007	+7965739	2	8
8008	+7965740	2	8
8009	+7965741	2	8
8010	+7965742	2	8
8011	+7965743	2	8
8012	+7965744	2	8
8013	+7965745	2	8
8014	+7965746	2	8
8015	+7965747	2	8
8016	+7965748	2	8
8017	+7965749	2	8
8018	+796575	2	7
8019	+796576	2	7
8020	+796577	2	7
8021	+796578	2	7
8022	+796579	2	7
8023	+7965800	2	8
8024	+7965801	2	8
8025	+7965802	2	8
8026	+7965803	2	8
8027	+7965804	2	8
8028	+7965805	2	8
8029	+7965806	2	8
8030	+7965807	2	8
8031	+7965808	2	8
8032	+7965809	2	8
8033	+7965810	2	8
8034	+7965811	2	8
8035	+7965812	2	8
8036	+7965813	2	8
8037	+7965814	2	8
8038	+7965815	2	8
8039	+7965816	2	8
8040	+7965817	2	8
8041	+7965818	2	8
8042	+7965819	2	8
8043	+796582	2	7
8044	+7965830	2	8
8045	+7965831	2	8
8046	+7965832	2	8
8047	+7965833	2	8
8048	+7965834	2	8
8049	+7965835	2	8
8050	+7965836	2	8
8051	+7965837	2	8
8052	+7965838	2	8
8053	+7965839	2	8
8054	+7965840	2	8
8055	+7965841	2	8
8056	+7965842	2	8
8057	+7965843	2	8
8058	+7965844	2	8
8059	+7965845	2	8
8060	+7965846	2	8
8061	+7965847	2	8
8062	+7965848	2	8
8063	+7965849	2	8
8064	+7965850	2	8
8065	+7965851	2	8
8066	+7965852	2	8
8067	+7965853	2	8
8068	+7965854	2	8
8069	+7965855	2	8
8070	+7965856	2	8
8071	+7965857	2	8
8072	+7965858	2	8
8073	+7965859	2	8
8074	+7965860	2	8
8075	+7965861	2	8
8076	+7965862	2	8
8077	+7965863	2	8
8078	+7965864	2	8
8079	+7965865	2	8
8080	+7965866	2	8
8081	+7965867	2	8
8082	+7965868	2	8
8083	+7965869	2	8
8084	+7965870	2	8
8085	+7965871	2	8
8086	+7965872	2	8
8087	+7965873	2	8
8088	+7965874	2	8
8089	+7965875	2	8
8090	+7965876	2	8
8091	+7965877	2	8
8092	+7965878	2	8
8093	+7965879	2	8
8094	+796588	2	7
8095	+796589	2	7
8096	+796590	2	7
8097	+796591	2	7
8098	+796592	2	7
8099	+796593	2	7
8100	+796594	2	7
8101	+796595	2	7
8102	+796596	2	7
8103	+7965970	2	8
8104	+7965971	2	8
8105	+7965972	2	8
8106	+7965973	2	8
8107	+7965974	2	8
8108	+7965975	2	8
8109	+7965976	2	8
8110	+7965977	2	8
8111	+7965978	2	8
8112	+7965979	2	8
8113	+7965980	2	8
8114	+7965981	2	8
8115	+7965982	2	8
8116	+7965983	2	8
8117	+7965984	2	8
8118	+7965985	2	8
8119	+7965986	2	8
8120	+7965987	2	8
8121	+7965988	2	8
8122	+7965989	2	8
8123	+796599	2	7
8124	+7966206	2	8
8125	+7966240	2	8
8126	+7966250	2	8
8127	+7966260	2	8
8128	+796674	2	7
8129	+796675	2	7
8130	+7966760	2	8
8131	+7966761	2	8
8132	+7966762	2	8
8133	+7966763	2	8
8134	+7966764	2	8
8135	+7966765	2	8
8136	+7966766	2	8
8137	+7966767	2	8
8138	+7966768	2	8
8139	+7966769	2	8
8140	+7966770	2	8
8141	+7966771	2	8
8142	+7966772	2	8
8143	+7966773	2	8
8144	+7966774	2	8
8145	+7966775	2	8
8146	+7966776	2	8
8147	+7966777	2	8
8148	+7966779	2	8
8149	+7966780	2	8
8150	+7966781	2	8
8151	+7966782	2	8
8152	+7966783	2	8
8153	+7966784	2	8
8154	+7966785	2	8
8155	+7966786	2	8
8156	+7966787	2	8
8157	+7966788	2	8
8158	+7966789	2	8
8159	+79670	2	6
8160	+7967300	2	8
8161	+7967301	2	8
8162	+7967302	2	8
8163	+7967303	2	8
8164	+7967304	2	8
8165	+7967305	2	8
8166	+7967306	2	8
8167	+7967307	2	8
8168	+7967308	2	8
8169	+7967309	2	8
8170	+7967310	2	8
8171	+7967311	2	8
8172	+7967312	2	8
8173	+7967313	2	8
8174	+7967314	2	8
8175	+7967315	2	8
8176	+7967316	2	8
8177	+7967317	2	8
8178	+7967318	2	8
8179	+7967319	2	8
8180	+7967320	2	8
8181	+7967321	2	8
8182	+7967322	2	8
8183	+7967323	2	8
8184	+7967324	2	8
8185	+7967325	2	8
8186	+7967326	2	8
8187	+7967327	2	8
8188	+7967328	2	8
8189	+7967329	2	8
8190	+7967330	2	8
8191	+7967331	2	8
8192	+7967332	2	8
8193	+7967333	2	8
8194	+7967334	2	8
8195	+7967335	2	8
8196	+7967336	2	8
8197	+7967337	2	8
8198	+7967338	2	8
8199	+7967339	2	8
8200	+7967340	2	8
8201	+7967341	2	8
8202	+7967342	2	8
8203	+7967343	2	8
8204	+7967344	2	8
8205	+7967345	2	8
8206	+7967346	2	8
8207	+7967347	2	8
8208	+7967348	2	8
8209	+7967349	2	8
8210	+7967350	2	8
8211	+7967351	2	8
8212	+7967352	2	8
8213	+7967353	2	8
8214	+7967354	2	8
8215	+7967355	2	8
8216	+7967356	2	8
8217	+7967357	2	8
8218	+7967358	2	8
8219	+7967359	2	8
8220	+7967360	2	8
8221	+7967361	2	8
8222	+7967362	2	8
8223	+7967363	2	8
8224	+7967364	2	8
8225	+7967365	2	8
8226	+7967366	2	8
8227	+7967367	2	8
8228	+7967368	2	8
8229	+7967369	2	8
8230	+7967370	2	8
8231	+7967371	2	8
8232	+7967372	2	8
8233	+7967373	2	8
8234	+7967374	2	8
8235	+7967375	2	8
8236	+7967376	2	8
8237	+7967377	2	8
8238	+7967378	2	8
8239	+7967379	2	8
8240	+796738	2	7
8241	+796739	2	7
8242	+796740	2	7
8243	+7967410	2	8
8244	+7967411	2	8
8245	+7967412	2	8
8246	+7967413	2	8
8247	+7967414	2	8
8248	+7967415	2	8
8249	+7967416	2	8
8250	+7967417	2	8
8251	+7967418	2	8
8252	+7967419	2	8
8253	+7967420	2	8
8254	+7967421	2	8
8255	+7967422	2	8
8256	+7967423	2	8
8257	+7967424	2	8
8258	+7967425	2	8
8259	+7967426	2	8
8260	+7967427	2	8
8261	+7967428	2	8
8262	+7967429	2	8
8263	+7967430	2	8
8264	+7967431	2	8
8265	+7967432	2	8
8266	+7967433	2	8
8267	+7967434	2	8
8268	+7967440	2	8
8269	+7967441	2	8
8270	+7967442	2	8
8271	+7967443	2	8
8272	+7967444	2	8
8273	+7967445	2	8
8274	+7967446	2	8
8275	+7967447	2	8
8276	+7967448	2	8
8277	+7967449	2	8
8278	+7967450	2	8
8279	+7967451	2	8
8280	+7967452	2	8
8281	+7967453	2	8
8282	+7967454	2	8
8283	+7967455	2	8
8284	+7967456	2	8
8285	+7967457	2	8
8286	+7967458	2	8
8287	+7967459	2	8
8288	+796746	2	7
8289	+7967470	2	8
8290	+7967471	2	8
8291	+7967472	2	8
8292	+7967473	2	8
8293	+7967474	2	8
8294	+7967475	2	8
8295	+7967476	2	8
8296	+7967477	2	8
8297	+7967478	2	8
8298	+7967479	2	8
8299	+7967480	2	8
8300	+7967481	2	8
8301	+7967482	2	8
8302	+7967483	2	8
8303	+7967484	2	8
8304	+7967485	2	8
8305	+7967486	2	8
8306	+7967487	2	8
8307	+7967488	2	8
8308	+7967489	2	8
8309	+7967490	2	8
8310	+7967491	2	8
8311	+7967492	2	8
8312	+796750	2	7
8313	+7967510	2	8
8314	+7967511	2	8
8315	+7967512	2	8
8316	+7967513	2	8
8317	+7967514	2	8
8318	+7967520	2	8
8319	+7967521	2	8
8320	+7967522	2	8
8321	+7967523	2	8
8322	+796753	2	7
8323	+7967550	2	8
8324	+7967551	2	8
8325	+7967552	2	8
8326	+7967553	2	8
8327	+7967560	2	8
8328	+7967561	2	8
8329	+7967562	2	8
8330	+7967563	2	8
8331	+7967564	2	8
8332	+7967570	2	8
8333	+7967571	2	8
8334	+7967572	2	8
8335	+7967573	2	8
8336	+7967574	2	8
8337	+7967580	2	8
8338	+7967581	2	8
8339	+7967582	2	8
8340	+796759	2	7
8341	+796760	2	7
8342	+796761	2	7
8343	+7967620	2	8
8344	+7967621	2	8
8345	+7967622	2	8
8346	+7967623	2	8
8347	+7967624	2	8
8348	+7967625	2	8
8349	+796763	2	7
8350	+7967640	2	8
8351	+7967641	2	8
8352	+7967642	2	8
8353	+7967643	2	8
8354	+7967644	2	8
8355	+7967645	2	8
8356	+7967646	2	8
8357	+7967647	2	8
8358	+7967648	2	8
8359	+7967649	2	8
8360	+7967650	2	8
8361	+7967651	2	8
8362	+7967652	2	8
8363	+7967653	2	8
8364	+7967654	2	8
8365	+7967655	2	8
8366	+7967656	2	8
8367	+7967657	2	8
8368	+7967658	2	8
8369	+7967659	2	8
8370	+7967660	2	8
8371	+7967661	2	8
8372	+7967662	2	8
8373	+7967663	2	8
8374	+7967664	2	8
8375	+7967665	2	8
8376	+7967666	2	8
8377	+7967667	2	8
8378	+7967668	2	8
8379	+7967669	2	8
8380	+7967670	2	8
8381	+7967671	2	8
8382	+7967672	2	8
8383	+7967673	2	8
8384	+7967674	2	8
8385	+7967680	2	8
8386	+7967681	2	8
8387	+7967682	2	8
8388	+7967683	2	8
8389	+7967684	2	8
8390	+7967696	2	8
8391	+7967700	2	8
8392	+7967701	2	8
8393	+7967702	2	8
8394	+7967703	2	8
8395	+7967704	2	8
8396	+7967705	2	8
8397	+7967706	2	8
8398	+796771	2	7
8399	+796772	2	7
8400	+7967730	2	8
8401	+796774	2	7
8402	+7967750	2	8
8403	+7967751	2	8
8404	+7967752	2	8
8405	+7967753	2	8
8406	+7967754	2	8
8407	+7967755	2	8
8408	+7967756	2	8
8409	+7967757	2	8
8410	+7967758	2	8
8411	+7967759	2	8
8412	+796776	2	7
8413	+7967770	2	8
8414	+7967771	2	8
8415	+7967772	2	8
8416	+7967773	2	8
8417	+7967774	2	8
8418	+7967775	2	8
8419	+7967776	2	8
8420	+7967777	2	8
8421	+7967778	2	8
8422	+7967779	2	8
8423	+7967780	2	8
8424	+796779	2	7
8425	+7967800	2	8
8426	+7967801	2	8
8427	+7967802	2	8
8428	+7967803	2	8
8429	+7967804	2	8
8430	+7967805	2	8
8431	+7967806	2	8
8432	+7967807	2	8
8433	+7967808	2	8
8434	+7967809	2	8
8435	+7967810	2	8
8436	+7967811	2	8
8437	+7967812	2	8
8438	+7967820	2	8
8439	+7967821	2	8
8440	+7967822	2	8
8441	+7967823	2	8
8442	+7967824	2	8
8443	+7967825	2	8
8444	+7967826	2	8
8445	+7967827	2	8
8446	+7967828	2	8
8447	+7967829	2	8
8448	+7967830	2	8
8449	+7967831	2	8
8450	+7967832	2	8
8451	+7967833	2	8
8452	+7967834	2	8
8453	+7967835	2	8
8454	+7967836	2	8
8455	+7967837	2	8
8456	+7967838	2	8
8457	+7967839	2	8
8458	+7967840	2	8
8459	+7967841	2	8
8460	+7967842	2	8
8461	+796785	2	7
8462	+796786	2	7
8463	+7967870	2	8
8464	+7967871	2	8
8465	+7967872	2	8
8466	+7967873	2	8
8467	+7967874	2	8
8468	+7967875	2	8
8469	+7967876	2	8
8470	+7967877	2	8
8471	+7967878	2	8
8472	+7967879	2	8
8473	+796788	2	7
8474	+796789	2	7
8475	+7967900	2	8
8476	+7967901	2	8
8477	+7967902	2	8
8478	+7967903	2	8
8479	+7967904	2	8
8480	+7967905	2	8
8481	+7967906	2	8
8482	+7967907	2	8
8483	+7967908	2	8
8484	+7967909	2	8
8485	+7967910	2	8
8486	+7967911	2	8
8487	+7967912	2	8
8488	+7967913	2	8
8489	+7967914	2	8
8490	+7967918	2	8
8491	+7967919	2	8
8492	+796792	2	7
8493	+796793	2	7
8494	+7967940	2	8
8495	+7967941	2	8
8496	+7967942	2	8
8497	+7967948	2	8
8498	+7967949	2	8
8499	+7967950	2	8
8500	+7967951	2	8
8501	+7967952	2	8
8502	+7967953	2	8
8503	+7967954	2	8
8504	+7967955	2	8
8505	+7967956	2	8
8506	+7967957	2	8
8507	+7967958	2	8
8508	+7967959	2	8
8509	+796796	2	7
8510	+7967970	2	8
8511	+7967971	2	8
8512	+7967972	2	8
8513	+7967973	2	8
8514	+7967974	2	8
8515	+7967975	2	8
8516	+7967976	2	8
8517	+7967977	2	8
8518	+7967978	2	8
8519	+7967979	2	8
8520	+7967980	2	8
8521	+7967981	2	8
8522	+7967982	2	8
8523	+7967983	2	8
8524	+7967984	2	8
8525	+7967987	2	8
8526	+7967988	2	8
8527	+7967989	2	8
8528	+7967990	2	8
8529	+7967991	2	8
8530	+7967992	2	8
8531	+7967993	2	8
8532	+7967994	2	8
8533	+7967995	2	8
8534	+7967996	2	8
8535	+7967997	2	8
8536	+7967998	2	8
8537	+7967999	2	8
8538	+7968100	2	8
8539	+7968101	2	8
8540	+7968102	2	8
8541	+7968103	2	8
8542	+7968104	2	8
8543	+7968105	2	8
8544	+7968106	2	8
8545	+7968107	2	8
8546	+7968108	2	8
8547	+7968109	2	8
8548	+796811	2	7
8549	+796812	2	7
8550	+7968130	2	8
8551	+7968131	2	8
8552	+7968132	2	8
8553	+7968133	2	8
8554	+7968134	2	8
8555	+7968135	2	8
8556	+7968136	2	8
8557	+7968137	2	8
8558	+7968138	2	8
8559	+7968139	2	8
8560	+7968140	2	8
8561	+7968141	2	8
8562	+7968142	2	8
8563	+7968143	2	8
8564	+7968148	2	8
8565	+7968149	2	8
8566	+7968150	2	8
8567	+7968151	2	8
8568	+7968152	2	8
8569	+7968160	2	8
8570	+7968161	2	8
8571	+7968162	2	8
8572	+7968165	2	8
8573	+7968166	2	8
8574	+7968167	2	8
8575	+7968168	2	8
8576	+7968170	2	8
8577	+7968171	2	8
8578	+7968172	2	8
8579	+796818	2	7
8580	+7968190	2	8
8581	+7968191	2	8
8582	+7968192	2	8
8583	+7968193	2	8
8584	+7968194	2	8
8585	+7968200	2	8
8586	+7968201	2	8
8587	+7968202	2	8
8588	+7968203	2	8
8589	+7968204	2	8
8590	+7968205	2	8
8591	+7968210	2	8
8592	+796826	2	7
8593	+796827	2	7
8594	+7968280	2	8
8595	+7968281	2	8
8596	+7968282	2	8
8597	+7968283	2	8
8598	+7968284	2	8
8599	+7968285	2	8
8600	+7968286	2	8
8601	+7968287	2	8
8602	+7968300	2	8
8603	+796834	2	7
8604	+796835	2	7
8605	+796836	2	7
8606	+796837	2	7
8607	+796838	2	7
8608	+796839	2	7
8609	+796840	2	7
8610	+796841	2	7
8611	+796842	2	7
8612	+796843	2	7
8613	+796844	2	7
8614	+796845	2	7
8615	+796846	2	7
8616	+796847	2	7
8617	+796848	2	7
8618	+796849	2	7
8619	+796850	2	7
8620	+796851	2	7
8621	+796852	2	7
8622	+796853	2	7
8623	+796854	2	7
8624	+796855	2	7
8625	+796856	2	7
8626	+796857	2	7
8627	+796858	2	7
8628	+796859	2	7
8629	+796860	2	7
8630	+796861	2	7
8631	+796862	2	7
8632	+796863	2	7
8633	+796864	2	7
8634	+796865	2	7
8635	+796866	2	7
8636	+796867	2	7
8637	+796868	2	7
8638	+796869	2	7
8639	+796870	2	7
8640	+796871	2	7
8641	+796872	2	7
8642	+796873	2	7
8643	+796874	2	7
8644	+796875	2	7
8645	+796876	2	7
8646	+796877	2	7
8647	+796878	2	7
8648	+796879	2	7
8649	+79688	2	6
8650	+792000	4	7
8651	+792001	4	7
8652	+792002	4	7
8653	+792003	4	7
8654	+792004	4	7
8655	+792005	4	7
8656	+792006	4	7
8657	+792007	4	7
8658	+792008	4	7
8659	+792009	4	7
8660	+792010	4	7
8661	+792011	4	7
8662	+7920111	4	8
8663	+7920112	4	8
8664	+7920113	4	8
8665	+7920114	4	8
8666	+7920115	4	8
8667	+7920116	4	8
8668	+7920117	4	8
8669	+7920118	4	8
8670	+7920119	4	8
8671	+7920120	4	8
8672	+7920121	4	8
8673	+7920122	4	8
8674	+7920123	4	8
8675	+7920124	4	8
8676	+7920125	4	8
8677	+7920126	4	8
8678	+7920127	4	8
8679	+7920128	4	8
8680	+7920129	4	8
8681	+7920130	4	8
8682	+7920131	4	8
8683	+7920132	4	8
8684	+7920133	4	8
8685	+7920134	4	8
8686	+7920135	4	8
8687	+7920136	4	8
8688	+7920137	4	8
8689	+7920138	4	8
8690	+7920139	4	8
8691	+7920140	4	8
8692	+7920141	4	8
8693	+7920142	4	8
8694	+7920143	4	8
8695	+7920144	4	8
8696	+7920145	4	8
8697	+7920146	4	8
8698	+7920147	4	8
8699	+7920148	4	8
8700	+7920149	4	8
8701	+792015	4	7
8702	+792016	4	7
8703	+792017	4	7
8704	+792018	4	7
8705	+792019	4	7
8706	+792020	4	7
8707	+792021	4	7
8708	+792022	4	7
8709	+792023	4	7
8710	+792024	4	7
8711	+792025	4	7
8712	+792026	4	7
8713	+792027	4	7
8714	+792028	4	7
8715	+792029	4	7
8716	+792030	4	7
8717	+792031	4	7
8718	+792032	4	7
8719	+792033	4	7
8720	+792034	4	7
8721	+792035	4	7
8722	+792036	4	7
8723	+792037	4	7
8724	+792038	4	7
8725	+792039	4	7
8726	+792040	4	7
8727	+792041	4	7
8728	+792042	4	7
8729	+792043	4	7
8730	+792044	4	7
8731	+792045	4	7
8732	+792046	4	7
8733	+792047	4	7
8734	+792048	4	7
8735	+792049	4	7
8736	+792050	4	7
8737	+792051	4	7
8738	+792052	4	7
8739	+792053	4	7
8740	+792054	4	7
8741	+792055	4	7
8742	+792056	4	7
8743	+792057	4	7
8744	+792058	4	7
8745	+792059	4	7
8746	+792060	4	7
8747	+792061	4	7
8748	+792062	4	7
8749	+792063	4	7
8750	+792064	4	7
8751	+792065	4	7
8752	+792066	4	7
8753	+792067	4	7
8754	+792068	4	7
8755	+792069	4	7
8756	+792070	4	7
8757	+792071	4	7
8758	+792072	4	7
8759	+792073	4	7
8760	+792074	4	7
8761	+792075	4	7
8762	+792076	4	7
8763	+792077	4	7
8764	+792078	4	7
8765	+792079	4	7
8766	+792080	4	7
8767	+792081	4	7
8768	+792082	4	7
8769	+792083	4	7
8770	+792084	4	7
8771	+792085	4	7
8772	+792086	4	7
8773	+792087	4	7
8774	+792088	4	7
8775	+792089	4	7
8776	+792090	4	7
8777	+792091	4	7
8778	+792092	4	7
8779	+792093	4	7
8780	+792094	4	7
8781	+792095	4	7
8782	+792096	4	7
8783	+792097	4	7
8784	+792098	4	7
8785	+792099	4	7
8786	+7921000	4	8
8787	+7921001	4	8
8788	+7921002	4	8
8789	+7921003	4	8
8790	+7921004	4	8
8791	+7921005	4	8
8792	+7921006	4	8
8793	+7921007	4	8
8794	+7921008	4	8
8795	+7921009	4	8
8796	+792101	4	7
8797	+792102	4	7
8798	+792103	4	7
8799	+792104	4	7
8800	+792105	4	7
8801	+792106	4	7
8802	+792107	4	7
8803	+792108	4	7
8804	+792109	4	7
8805	+792110	4	7
8806	+7921110	4	8
8807	+7921111	4	8
8808	+7921112	4	8
8809	+7921113	4	8
8810	+7921114	4	8
8811	+7921115	4	8
8812	+7921116	4	8
8813	+7921117	4	8
8814	+7921118	4	8
8815	+7921119	4	8
8816	+792112	4	7
8817	+792113	4	7
8818	+792114	4	7
8819	+792115	4	7
8820	+792116	4	7
8821	+792117	4	7
8822	+792118	4	7
8823	+792119	4	7
8824	+792120	4	7
8825	+792121	4	7
8826	+792122	4	7
8827	+792123	4	7
8828	+792124	4	7
8829	+792125	4	7
8830	+792126	4	7
8831	+792127	4	7
8832	+792128	4	7
8833	+792129	4	7
8834	+792130	4	7
8835	+792131	4	7
8836	+792132	4	7
8837	+792133	4	7
8838	+792134	4	7
8839	+792135	4	7
8840	+792136	4	7
8841	+792137	4	7
8842	+792138	4	7
8843	+792139	4	7
8844	+792140	4	7
8845	+792141	4	7
8846	+792142	4	7
8847	+792143	4	7
8848	+792144	4	7
8849	+792145	4	7
8850	+792146	4	7
8851	+792147	4	7
8852	+792148	4	7
8853	+792149	4	7
8854	+792150	4	7
8855	+792151	4	7
8856	+792152	4	7
8857	+792153	4	7
8858	+792154	4	7
8859	+792155	4	7
8860	+792156	4	7
8861	+792157	4	7
8862	+792158	4	7
8863	+792159	4	7
8864	+7921600	4	8
8865	+7921601	4	8
8866	+7921602	4	8
8867	+7921603	4	8
8868	+7921604	4	8
8869	+7921605	4	8
8870	+7921606	4	8
8871	+7921607	4	8
8872	+7921608	4	8
8873	+7921609	4	8
8874	+792161	4	7
8875	+792162	4	7
8876	+792163	4	7
8877	+792164	4	7
8878	+792165	4	7
8879	+792166	4	7
8880	+792167	4	7
8881	+792168	4	7
8882	+792169	4	7
8883	+7921700	4	8
8884	+7921701	4	8
8885	+7921702	4	8
8886	+7921703	4	8
8887	+7921704	4	8
8888	+7921705	4	8
8889	+7921706	4	8
8890	+7921707	4	8
8891	+7921708	4	8
8892	+7921709	4	8
8893	+7921710	4	8
8894	+7921711	4	8
8895	+7921712	4	8
8896	+7921713	4	8
8897	+7921714	4	8
8898	+7921715	4	8
8899	+7921716	4	8
8900	+7921717	4	8
8901	+7921718	4	8
8902	+7921719	4	8
8903	+7921720	4	8
8904	+7921721	4	8
8905	+7921722	4	8
8906	+7921723	4	8
8907	+7921724	4	8
8908	+7921725	4	8
8909	+7921726	4	8
8910	+7921727	4	8
8911	+7921728	4	8
8912	+7921729	4	8
8913	+7921730	4	8
8914	+7921731	4	8
8915	+7921732	4	8
8916	+7921733	4	8
8917	+7921734	4	8
8918	+7921735	4	8
8919	+7921736	4	8
8920	+7921737	4	8
8921	+7921738	4	8
8922	+7921739	4	8
8923	+792174	4	7
8924	+792175	4	7
8925	+792176	4	7
8926	+792177	4	7
8927	+792178	4	7
8928	+792179	4	7
8929	+792180	4	7
8930	+792181	4	7
8931	+792182	4	7
8932	+792183	4	7
8933	+7921840	4	8
8934	+7921841	4	8
8935	+7921842	4	8
8936	+7921843	4	8
8937	+7921844	4	8
8938	+7921845	4	8
8939	+7921846	4	8
8940	+7921847	4	8
8941	+7921848	4	8
8942	+7921849	4	8
8943	+7921850	4	8
8944	+7921851	4	8
8945	+7921852	4	8
8946	+7921853	4	8
8947	+7921854	4	8
8948	+7921855	4	8
8949	+7921856	4	8
8950	+7921857	4	8
8951	+7921858	4	8
8952	+7921859	4	8
8953	+7921860	4	8
8954	+7921861	4	8
8955	+7921862	4	8
8956	+7921863	4	8
8957	+7921864	4	8
8958	+7921865	4	8
8959	+7921866	4	8
8960	+7921867	4	8
8961	+7921868	4	8
8962	+7921869	4	8
8963	+7921870	4	8
8964	+7921871	4	8
8965	+7921872	4	8
8966	+7921873	4	8
8967	+7921874	4	8
8968	+7921875	4	8
8969	+7921876	4	8
8970	+7921877	4	8
8971	+7921878	4	8
8972	+7921879	4	8
8973	+7921880	4	8
8974	+7921881	4	8
8975	+7921882	4	8
8976	+7921883	4	8
8977	+7921884	4	8
8978	+7921885	4	8
8979	+7921886	4	8
8980	+7921887	4	8
8981	+7921888	4	8
8982	+7921889	4	8
8983	+7921890	4	8
8984	+7921891	4	8
8985	+7921892	4	8
8986	+7921893	4	8
8987	+7921894	4	8
8988	+7921895	4	8
8989	+7921896	4	8
8990	+7921897	4	8
8991	+7921898	4	8
8992	+7921899	4	8
8993	+7921900	4	8
8994	+7921901	4	8
8995	+7921902	4	8
8996	+7921903	4	8
8997	+7921904	4	8
8998	+7921905	4	8
8999	+7921906	4	8
9000	+7921907	4	8
9001	+7921908	4	8
9002	+7921909	4	8
9003	+7921910	4	8
9004	+7921911	4	8
9005	+7921912	4	8
9006	+7921913	4	8
9007	+7921914	4	8
9008	+7921915	4	8
9009	+7921916	4	8
9010	+7921917	4	8
9011	+7921918	4	8
9012	+7921919	4	8
9013	+7921920	4	8
9014	+7921921	4	8
9015	+7921922	4	8
9016	+7921923	4	8
9017	+7921924	4	8
9018	+7921925	4	8
9019	+7921926	4	8
9020	+7921927	4	8
9021	+7921928	4	8
9022	+7921929	4	8
9023	+7921930	4	8
9024	+7921931	4	8
9025	+7921932	4	8
9026	+7921933	4	8
9027	+7921934	4	8
9028	+7921935	4	8
9029	+7921936	4	8
9030	+7921937	4	8
9031	+7921938	4	8
9032	+7921939	4	8
9033	+7921940	4	8
9034	+7921941	4	8
9035	+7921942	4	8
9036	+7921943	4	8
9037	+7921944	4	8
9038	+7921945	4	8
9039	+7921946	4	8
9040	+7921947	4	8
9041	+7921948	4	8
9042	+7921949	4	8
9043	+7921950	4	8
9044	+7921951	4	8
9045	+7921952	4	8
9046	+7921953	4	8
9047	+7921954	4	8
9048	+7921955	4	8
9049	+7921956	4	8
9050	+7921957	4	8
9051	+7921958	4	8
9052	+7921959	4	8
9053	+7921960	4	8
9054	+7921961	4	8
9055	+7921962	4	8
9056	+7921963	4	8
9057	+7921964	4	8
9058	+7921965	4	8
9059	+7921966	4	8
9060	+7921967	4	8
9061	+7921968	4	8
9062	+7921969	4	8
9063	+7921970	4	8
9064	+7921971	4	8
9065	+7921972	4	8
9066	+7921973	4	8
9067	+7921974	4	8
9068	+7921975	4	8
9069	+7921976	4	8
9070	+7921977	4	8
9071	+7921978	4	8
9072	+7921979	4	8
9073	+7921980	4	8
9074	+7921981	4	8
9075	+7921982	4	8
9076	+7921983	4	8
9077	+7921984	4	8
9078	+7921985	4	8
9079	+7921986	4	8
9080	+7921987	4	8
9081	+7921988	4	8
9082	+7921989	4	8
9083	+7921990	4	8
9084	+7921991	4	8
9085	+7921992	4	8
9086	+7921993	4	8
9087	+7921994	4	8
9088	+7921995	4	8
9089	+7921996	4	8
9090	+7921997	4	8
9091	+7921998	4	8
9092	+7921999	4	8
9093	+792200	4	7
9094	+792201	4	7
9095	+792202	4	7
9096	+792203	4	7
9097	+792204	4	7
9098	+792205	4	7
9099	+792206	4	7
9100	+792207	4	7
9101	+792208	4	7
9102	+792209	4	7
9103	+792210	4	7
9104	+792211	4	7
9105	+792212	4	7
9106	+792213	4	7
9107	+792214	4	7
9108	+792215	4	7
9109	+792216	4	7
9110	+792217	4	7
9111	+792218	4	7
9112	+792219	4	7
9113	+792220	4	7
9114	+792221	4	7
9115	+792222	4	7
9116	+792223	4	7
9117	+7922240	4	8
9118	+7922241	4	8
9119	+7922242	4	8
9120	+7922243	4	8
9121	+7922244	4	8
9122	+7922245	4	8
9123	+7922246	4	8
9124	+7922247	4	8
9125	+7922248	4	8
9126	+7922249	4	8
9127	+7922250	4	8
9128	+7922251	4	8
9129	+7922252	4	8
9130	+7922253	4	8
9131	+7922254	4	8
9132	+7922255	4	8
9133	+7922256	4	8
9134	+7922257	4	8
9135	+7922258	4	8
9136	+7922259	4	8
9137	+792226	4	7
9138	+792227	4	7
9139	+792228	4	7
9140	+792229	4	7
9141	+792230	4	7
9142	+792231	4	7
9143	+792232	4	7
9144	+792233	4	7
9145	+792234	4	7
9146	+792235	4	7
9147	+792236	4	7
9148	+792237	4	7
9149	+792238	4	7
9150	+7922390	4	8
9151	+7922391	4	8
9152	+7922392	4	8
9153	+7922393	4	8
9154	+7922394	4	8
9155	+7922395	4	8
9156	+7922396	4	8
9157	+7922397	4	8
9158	+7922398	4	8
9159	+7922399	4	8
9160	+7922400	4	8
9161	+7922401	4	8
9162	+7922402	4	8
9163	+7922403	4	8
9164	+7922404	4	8
9165	+7922405	4	8
9166	+7922406	4	8
9167	+7922407	4	8
9168	+7922408	4	8
9169	+7922409	4	8
9170	+7922410	4	8
9171	+7922411	4	8
9172	+7922412	4	8
9173	+7922413	4	8
9174	+7922414	4	8
9175	+7922415	4	8
9176	+7922416	4	8
9177	+7922417	4	8
9178	+7922418	4	8
9179	+7922419	4	8
9180	+7922420	4	8
9181	+7922421	4	8
9182	+7922422	4	8
9183	+7922423	4	8
9184	+7922424	4	8
9185	+7922425	4	8
9186	+7922426	4	8
9187	+7922427	4	8
9188	+7922428	4	8
9189	+7922429	4	8
9190	+7922430	4	8
9191	+7922431	4	8
9192	+7922432	4	8
9193	+7922433	4	8
9194	+7922434	4	8
9195	+7922435	4	8
9196	+7922436	4	8
9197	+7922437	4	8
9198	+7922438	4	8
9199	+7922439	4	8
9200	+7922440	4	8
9201	+7922441	4	8
9202	+7922442	4	8
9203	+7922443	4	8
9204	+7922444	4	8
9205	+7922445	4	8
9206	+7922446	4	8
9207	+7922447	4	8
9208	+7922448	4	8
9209	+7922449	4	8
9210	+792245	4	7
9211	+792246	4	7
9212	+792247	4	7
9213	+792248	4	7
9214	+792249	4	7
9215	+792250	4	7
9216	+792251	4	7
9217	+792252	4	7
9218	+792253	4	7
9219	+792254	4	7
9220	+792255	4	7
9221	+792256	4	7
9222	+792257	4	7
9223	+792258	4	7
9224	+792259	4	7
9225	+792260	4	7
9226	+792261	4	7
9227	+792262	4	7
9228	+792263	4	7
9229	+792264	4	7
9230	+792265	4	7
9231	+792266	4	7
9232	+792267	4	7
9233	+7922680	4	8
9234	+7922681	4	8
9235	+7922682	4	8
9236	+7922683	4	8
9237	+7922684	4	8
9238	+7922685	4	8
9239	+7922686	4	8
9240	+7922687	4	8
9241	+7922688	4	8
9242	+7922689	4	8
9243	+7922690	4	8
9244	+7922691	4	8
9245	+7922692	4	8
9246	+7922693	4	8
9247	+7922694	4	8
9248	+7922695	4	8
9249	+7922696	4	8
9250	+7922697	4	8
9251	+7922698	4	8
9252	+7922699	4	8
9253	+7922700	4	8
9254	+7922701	4	8
9255	+7922702	4	8
9256	+7922703	4	8
9257	+7922704	4	8
9258	+7922705	4	8
9259	+7922706	4	8
9260	+7922707	4	8
9261	+7922708	4	8
9262	+7922709	4	8
9263	+7922710	4	8
9264	+7922711	4	8
9265	+7922712	4	8
9266	+7922713	4	8
9267	+7922714	4	8
9268	+7922715	4	8
9269	+7922716	4	8
9270	+7922717	4	8
9271	+7922718	4	8
9272	+7922719	4	8
9273	+7922720	4	8
9274	+7922721	4	8
9275	+7922722	4	8
9276	+7922723	4	8
9277	+7922724	4	8
9278	+7922725	4	8
9279	+7922726	4	8
9280	+7922727	4	8
9281	+7922728	4	8
9282	+7922729	4	8
9283	+7922730	4	8
9284	+7922731	4	8
9285	+7922732	4	8
9286	+7922733	4	8
9287	+7922734	4	8
9288	+7922735	4	8
9289	+7922736	4	8
9290	+7922737	4	8
9291	+7922738	4	8
9292	+7922739	4	8
9293	+7922740	4	8
9294	+7922741	4	8
9295	+7922742	4	8
9296	+7922743	4	8
9297	+7922744	4	8
9298	+7922745	4	8
9299	+7922746	4	8
9300	+7922747	4	8
9301	+7922748	4	8
9302	+7922749	4	8
9303	+7922750	4	8
9304	+7922751	4	8
9305	+7922752	4	8
9306	+7922753	4	8
9307	+7922754	4	8
9308	+7922755	4	8
9309	+7922756	4	8
9310	+7922757	4	8
9311	+7922758	4	8
9312	+7922759	4	8
9313	+792276	4	7
9314	+792277	4	7
9315	+792278	4	7
9316	+792279	4	7
9317	+79228	4	6
9318	+79229	4	6
9319	+792300	4	7
9320	+7923010	4	8
9321	+7923011	4	8
9322	+7923012	4	8
9323	+7923013	4	8
9324	+7923014	4	8
9325	+7923015	4	8
9326	+7923016	4	8
9327	+7923017	4	8
9328	+7923018	4	8
9329	+7923019	4	8
9330	+792302	4	7
9331	+7923030	4	8
9332	+7923031	4	8
9333	+7923032	4	8
9334	+7923033	4	8
9335	+7923034	4	8
9336	+7923035	4	8
9337	+7923036	4	8
9338	+7923037	4	8
9339	+7923038	4	8
9340	+7923039	4	8
9341	+792310	4	7
9342	+792311	4	7
9343	+792312	4	7
9344	+792313	4	7
9345	+792314	4	7
9346	+792315	4	7
9347	+792316	4	7
9348	+792317	4	7
9349	+792318	4	7
9350	+792319	4	7
9351	+792320	4	7
9352	+7923210	4	8
9353	+7923211	4	8
9354	+7923212	4	8
9355	+7923213	4	8
9356	+7923214	4	8
9357	+7923215	4	8
9358	+7923216	4	8
9359	+7923217	4	8
9360	+7923218	4	8
9361	+7923219	4	8
9362	+792322	4	7
9363	+792323	4	7
9364	+792324	4	7
9365	+792325	4	7
9366	+792326	4	7
9367	+792327	4	7
9368	+792328	4	7
9369	+792329	4	7
9370	+7923300	4	8
9371	+7923301	4	8
9372	+7923302	4	8
9373	+7923303	4	8
9374	+7923304	4	8
9375	+7923305	4	8
9376	+7923306	4	8
9377	+7923307	4	8
9378	+7923308	4	8
9379	+7923309	4	8
9380	+7923310	4	8
9381	+7923311	4	8
9382	+7923312	4	8
9383	+7923313	4	8
9384	+7923314	4	8
9385	+7923315	4	8
9386	+7923316	4	8
9387	+7923317	4	8
9388	+7923318	4	8
9389	+7923319	4	8
9390	+7923320	4	8
9391	+7923321	4	8
9392	+7923322	4	8
9393	+7923323	4	8
9394	+7923324	4	8
9395	+7923325	4	8
9396	+7923326	4	8
9397	+7923327	4	8
9398	+7923328	4	8
9399	+7923329	4	8
9400	+7923330	4	8
9401	+7923331	4	8
9402	+7923332	4	8
9403	+7923333	4	8
9404	+7923334	4	8
9405	+7923335	4	8
9406	+7923336	4	8
9407	+7923337	4	8
9408	+7923338	4	8
9409	+7923339	4	8
9410	+7923340	4	8
9411	+7923341	4	8
9412	+7923342	4	8
9413	+7923343	4	8
9414	+7923344	4	8
9415	+7923345	4	8
9416	+7923346	4	8
9417	+7923347	4	8
9418	+7923348	4	8
9419	+7923349	4	8
9420	+7923350	4	8
9421	+7923351	4	8
9422	+7923352	4	8
9423	+7923353	4	8
9424	+7923354	4	8
9425	+7923355	4	8
9426	+7923356	4	8
9427	+7923357	4	8
9428	+7923358	4	8
9429	+7923359	4	8
9430	+7923360	4	8
9431	+7923361	4	8
9432	+7923362	4	8
9433	+7923363	4	8
9434	+7923364	4	8
9435	+7923365	4	8
9436	+7923366	4	8
9437	+7923367	4	8
9438	+7923368	4	8
9439	+7923369	4	8
9440	+7923370	4	8
9441	+7923371	4	8
9442	+7923372	4	8
9443	+7923373	4	8
9444	+7923374	4	8
9445	+7923375	4	8
9446	+7923376	4	8
9447	+7923377	4	8
9448	+7923378	4	8
9449	+7923379	4	8
9450	+792338	4	7
9451	+792339	4	7
9452	+792340	4	7
9453	+792341	4	7
9454	+792342	4	7
9455	+792343	4	7
9456	+792344	4	7
9457	+7923450	4	8
9458	+7923451	4	8
9459	+7923452	4	8
9460	+7923453	4	8
9461	+7923454	4	8
9462	+7923455	4	8
9463	+7923456	4	8
9464	+7923457	4	8
9465	+7923458	4	8
9466	+7923459	4	8
9467	+792346	4	7
9468	+792347	4	7
9469	+792348	4	7
9470	+792349	4	7
9471	+792350	4	7
9472	+792351	4	7
9473	+792352	4	7
9474	+792353	4	7
9475	+7923540	4	8
9476	+7923541	4	8
9477	+7923542	4	8
9478	+7923543	4	8
9479	+7923544	4	8
9480	+7923545	4	8
9481	+7923546	4	8
9482	+7923547	4	8
9483	+7923548	4	8
9484	+7923549	4	8
9485	+7923550	4	8
9486	+7923551	4	8
9487	+7923552	4	8
9488	+7923553	4	8
9489	+7923554	4	8
9490	+7923555	4	8
9491	+7923556	4	8
9492	+7923557	4	8
9493	+7923558	4	8
9494	+7923559	4	8
9495	+7923560	4	8
9496	+7923561	4	8
9497	+7923562	4	8
9498	+7923563	4	8
9499	+7923564	4	8
9500	+7923565	4	8
9501	+7923566	4	8
9502	+7923567	4	8
9503	+7923568	4	8
9504	+7923569	4	8
9505	+792357	4	7
9506	+792358	4	7
9507	+792359	4	7
9508	+792360	4	7
9509	+792361	4	7
9510	+792362	4	7
9511	+792363	4	7
9512	+792364	4	7
9513	+792365	4	7
9514	+7923660	4	8
9515	+7923661	4	8
9516	+7923662	4	8
9517	+7923663	4	8
9518	+7923664	4	8
9519	+7923665	4	8
9520	+7923666	4	8
9521	+7923667	4	8
9522	+7923668	4	8
9523	+7923669	4	8
9524	+792367	4	7
9525	+792368	4	7
9526	+792369	4	7
9527	+792370	4	7
9528	+792371	4	7
9529	+792372	4	7
9530	+7923730	4	8
9531	+7923731	4	8
9532	+7923732	4	8
9533	+7923733	4	8
9534	+7923734	4	8
9535	+7923735	4	8
9536	+7923736	4	8
9537	+7923737	4	8
9538	+7923738	4	8
9539	+7923739	4	8
9540	+7923740	4	8
9541	+7923741	4	8
9542	+7923742	4	8
9543	+7923743	4	8
9544	+7923744	4	8
9545	+7923745	4	8
9546	+7923746	4	8
9547	+7923747	4	8
9548	+7923748	4	8
9549	+7923749	4	8
9550	+7923750	4	8
9551	+7923751	4	8
9552	+7923752	4	8
9553	+7923753	4	8
9554	+7923754	4	8
9555	+7923755	4	8
9556	+7923756	4	8
9557	+7923757	4	8
9558	+7923758	4	8
9559	+7923759	4	8
9560	+792376	4	7
9561	+7923770	4	8
9562	+7923771	4	8
9563	+7923772	4	8
9564	+7923773	4	8
9565	+7923774	4	8
9566	+7923775	4	8
9567	+7923776	4	8
9568	+79237770	4	9
9569	+79237771	4	9
9570	+79237772	4	9
9571	+79237773	4	9
9572	+79237774	4	9
9573	+79237775	4	9
9574	+79237776	4	9
9575	+79237777	4	9
9576	+79237778	4	9
9577	+79237779	4	9
9578	+79237780	4	9
9579	+79237781	4	9
9580	+79237782	4	9
9581	+79237783	4	9
9582	+79237784	4	9
9583	+79237785	4	9
9584	+79237786	4	9
9585	+79237787	4	9
9586	+79237788	4	9
9587	+79237789	4	9
9588	+79237790	4	9
9589	+79237791	4	9
9590	+79237792	4	9
9591	+79237793	4	9
9592	+79237794	4	9
9593	+79237795	4	9
9594	+79237796	4	9
9595	+79237797	4	9
9596	+79237798	4	9
9597	+79237799	4	9
9598	+79237800	4	9
9599	+79237801	4	9
9600	+79237802	4	9
9601	+79237803	4	9
9602	+79237804	4	9
9603	+79237805	4	9
9604	+79237806	4	9
9605	+79237807	4	9
9606	+79237808	4	9
9607	+79237809	4	9
9608	+79237810	4	9
9609	+79237811	4	9
9610	+79237812	4	9
9611	+79237813	4	9
9612	+79237814	4	9
9613	+79237815	4	9
9614	+79237816	4	9
9615	+79237817	4	9
9616	+79237818	4	9
9617	+79237819	4	9
9618	+7923782	4	8
9619	+7923783	4	8
9620	+7923784	4	8
9621	+7923785	4	8
9622	+7923786	4	8
9623	+7923787	4	8
9624	+7923788	4	8
9625	+7923789	4	8
9626	+792379	4	7
9627	+792410	4	7
9628	+792411	4	7
9629	+792412	4	7
9630	+792413	4	7
9631	+792414	4	7
9632	+792415	4	7
9633	+792416	4	7
9634	+792417	4	7
9635	+792418	4	7
9636	+792419	4	7
9637	+792420	4	7
9638	+792421	4	7
9639	+792422	4	7
9640	+792423	4	7
9641	+792424	4	7
9642	+792425	4	7
9643	+792426	4	7
9644	+792427	4	7
9645	+792428	4	7
9646	+7924290	4	8
9647	+7924291	4	8
9648	+7924292	4	8
9649	+7924293	4	8
9650	+7924294	4	8
9651	+7924295	4	8
9652	+7924296	4	8
9653	+7924297	4	8
9654	+7924298	4	8
9655	+7924299	4	8
9656	+792430	4	7
9657	+792431	4	7
9658	+792432	4	7
9659	+792433	4	7
9660	+792434	4	7
9661	+792435	4	7
9662	+792436	4	7
9663	+792437	4	7
9664	+792438	4	7
9665	+792439	4	7
9666	+792440	4	7
9667	+792441	4	7
9668	+792442	4	7
9669	+792443	4	7
9670	+792444	4	7
9671	+792445	4	7
9672	+792446	4	7
9673	+792447	4	7
9674	+792448	4	7
9675	+792449	4	7
9676	+792450	4	7
9677	+792451	4	7
9678	+792452	4	7
9679	+792453	4	7
9680	+792454	4	7
9681	+792455	4	7
9682	+792456	4	7
9683	+792457	4	7
9684	+7924580	4	8
9685	+7924581	4	8
9686	+7924582	4	8
9687	+7924583	4	8
9688	+7924584	4	8
9689	+7924585	4	8
9690	+7924586	4	8
9691	+7924587	4	8
9692	+7924588	4	8
9693	+7924589	4	8
9694	+792459	4	7
9695	+792460	4	7
9696	+792461	4	7
9697	+792462	4	7
9698	+792463	4	7
9699	+792464	4	7
9700	+792465	4	7
9701	+7924660	4	8
9702	+7924661	4	8
9703	+7924662	4	8
9704	+7924663	4	8
9705	+7924664	4	8
9706	+7924665	4	8
9707	+7924666	4	8
9708	+7924667	4	8
9709	+7924668	4	8
9710	+7924669	4	8
9711	+7924670	4	8
9712	+7924671	4	8
9713	+7924672	4	8
9714	+7924673	4	8
9715	+7924674	4	8
9716	+7924675	4	8
9717	+7924676	4	8
9718	+7924677	4	8
9719	+7924678	4	8
9720	+7924679	4	8
9721	+7924680	4	8
9722	+7924681	4	8
9723	+7924682	4	8
9724	+7924683	4	8
9725	+7924684	4	8
9726	+7924685	4	8
9727	+7924686	4	8
9728	+7924687	4	8
9729	+7924688	4	8
9730	+7924689	4	8
9731	+7924690	4	8
9732	+7924691	4	8
9733	+7924692	4	8
9734	+7924693	4	8
9735	+7924694	4	8
9736	+7924695	4	8
9737	+7924696	4	8
9738	+7924697	4	8
9739	+7924698	4	8
9740	+7924699	4	8
9741	+792470	4	7
9742	+792471	4	7
9743	+792472	4	7
9744	+792473	4	7
9745	+792474	4	7
9746	+792475	4	7
9747	+792476	4	7
9748	+792477	4	7
9749	+7924780	4	8
9750	+7924781	4	8
9751	+7924782	4	8
9752	+7924783	4	8
9753	+7924784	4	8
9754	+7924785	4	8
9755	+7924786	4	8
9756	+7924787	4	8
9757	+7924788	4	8
9758	+7924789	4	8
9759	+7924790	4	8
9760	+7924791	4	8
9761	+7924792	4	8
9762	+7924793	4	8
9763	+7924794	4	8
9764	+7924795	4	8
9765	+7924796	4	8
9766	+7924797	4	8
9767	+7924798	4	8
9768	+7924799	4	8
9769	+792480	4	7
9770	+792481	4	7
9771	+792482	4	7
9772	+792483	4	7
9773	+792484	4	7
9774	+792485	4	7
9775	+792486	4	7
9776	+792487	4	7
9777	+792488	4	7
9778	+7924890	4	8
9779	+7924891	4	8
9780	+7924892	4	8
9781	+7924893	4	8
9782	+7924894	4	8
9783	+7924895	4	8
9784	+7924896	4	8
9785	+7924897	4	8
9786	+7924898	4	8
9787	+7924899	4	8
9788	+7924916	4	8
9789	+7924917	4	8
9790	+7924918	4	8
9791	+7924919	4	8
9792	+7924920	4	8
9793	+7924921	4	8
9794	+7924922	4	8
9795	+7924923	4	8
9796	+7924924	4	8
9797	+7924925	4	8
9798	+7924926	4	8
9799	+7924927	4	8
9800	+7924928	4	8
9801	+7924929	4	8
9802	+7924930	4	8
9803	+7924931	4	8
9804	+7924932	4	8
9805	+7924933	4	8
9806	+7924934	4	8
9807	+7924935	4	8
9808	+7924936	4	8
9809	+7924937	4	8
9810	+7924938	4	8
9811	+7924939	4	8
9812	+7924940	4	8
9813	+7924941	4	8
9814	+7924942	4	8
9815	+7924943	4	8
9816	+7924944	4	8
9817	+7924945	4	8
9818	+79250	4	6
9819	+7925100	4	8
9820	+7925101	4	8
9821	+7925102	4	8
9822	+7925103	4	8
9823	+7925104	4	8
9824	+7925105	4	8
9825	+7925106	4	8
9826	+7925107	4	8
9827	+7925108	4	8
9828	+7925109	4	8
9829	+792511	4	7
9830	+792512	4	7
9831	+7925130	4	8
9832	+7925131	4	8
9833	+7925132	4	8
9834	+7925133	4	8
9835	+7925134	4	8
9836	+7925135	4	8
9837	+7925136	4	8
9838	+7925137	4	8
9839	+7925138	4	8
9840	+7925139	4	8
9841	+792514	4	7
9842	+792515	4	7
9843	+792516	4	7
9844	+792517	4	7
9845	+792518	4	7
9846	+792519	4	7
9847	+792520	4	7
9848	+792521	4	7
9849	+7925220	4	8
9850	+7925221	4	8
9851	+7925222	4	8
9852	+7925223	4	8
9853	+7925224	4	8
9854	+7925225	4	8
9855	+7925226	4	8
9856	+7925227	4	8
9857	+7925228	4	8
9858	+7925229	4	8
9859	+7925230	4	8
9860	+7925231	4	8
9861	+7925232	4	8
9862	+7925233	4	8
9863	+7925234	4	8
9864	+7925235	4	8
9865	+7925236	4	8
9866	+7925237	4	8
9867	+7925238	4	8
9868	+7925239	4	8
9869	+7925240	4	8
9870	+7925241	4	8
9871	+7925242	4	8
9872	+7925243	4	8
9873	+7925244	4	8
9874	+7925245	4	8
9875	+7925246	4	8
9876	+7925247	4	8
9877	+7925248	4	8
9878	+7925249	4	8
9879	+7925250	4	8
9880	+7925251	4	8
9881	+7925252	4	8
9882	+7925253	4	8
9883	+7925254	4	8
9884	+7925255	4	8
9885	+7925256	4	8
9886	+7925257	4	8
9887	+7925258	4	8
9888	+7925259	4	8
9889	+7925260	4	8
9890	+7925261	4	8
9891	+7925262	4	8
9892	+7925263	4	8
9893	+7925264	4	8
9894	+7925265	4	8
9895	+7925266	4	8
9896	+7925267	4	8
9897	+7925268	4	8
9898	+7925269	4	8
9899	+7925270	4	8
9900	+7925271	4	8
9901	+7925272	4	8
9902	+7925273	4	8
9903	+7925274	4	8
9904	+7925275	4	8
9905	+7925276	4	8
9906	+7925277	4	8
9907	+7925278	4	8
9908	+7925279	4	8
9909	+7925280	4	8
9910	+7925281	4	8
9911	+7925282	4	8
9912	+7925283	4	8
9913	+7925284	4	8
9914	+7925285	4	8
9915	+7925286	4	8
9916	+7925287	4	8
9917	+7925288	4	8
9918	+7925289	4	8
9919	+792529	4	7
9920	+7925300	4	8
9921	+7925301	4	8
9922	+7925302	4	8
9923	+7925303	4	8
9924	+7925304	4	8
9925	+7925305	4	8
9926	+7925306	4	8
9927	+7925307	4	8
9928	+7925308	4	8
9929	+7925309	4	8
9930	+7925310	4	8
9931	+7925311	4	8
9932	+7925312	4	8
9933	+7925313	4	8
9934	+7925314	4	8
9935	+7925315	4	8
9936	+7925316	4	8
9937	+7925317	4	8
9938	+7925318	4	8
9939	+7925319	4	8
9940	+7925320	4	8
9941	+7925321	4	8
9942	+7925322	4	8
9943	+7925323	4	8
9944	+7925324	4	8
9945	+7925325	4	8
9946	+7925326	4	8
9947	+7925327	4	8
9948	+7925328	4	8
9949	+7925329	4	8
9950	+7925330	4	8
9951	+7925331	4	8
9952	+7925332	4	8
9953	+7925333	4	8
9954	+7925334	4	8
9955	+7925335	4	8
9956	+7925336	4	8
9957	+7925337	4	8
9958	+7925338	4	8
9959	+7925339	4	8
9960	+7925340	4	8
9961	+7925341	4	8
9962	+7925342	4	8
9963	+7925343	4	8
9964	+7925344	4	8
9965	+7925345	4	8
9966	+7925346	4	8
9967	+7925347	4	8
9968	+7925348	4	8
9969	+7925349	4	8
9970	+7925350	4	8
9971	+7925351	4	8
9972	+7925352	4	8
9973	+7925353	4	8
9974	+7925354	4	8
9975	+7925355	4	8
9976	+7925356	4	8
9977	+7925357	4	8
9978	+7925358	4	8
9979	+7925359	4	8
9980	+7925360	4	8
9981	+7925361	4	8
9982	+7925362	4	8
9983	+7925363	4	8
9984	+7925364	4	8
9985	+7925365	4	8
9986	+7925366	4	8
9987	+7925367	4	8
9988	+7925368	4	8
9989	+7925369	4	8
9990	+7925370	4	8
9991	+7925371	4	8
9992	+7925372	4	8
9993	+7925373	4	8
9994	+7925374	4	8
9995	+7925375	4	8
9996	+7925376	4	8
9997	+7925377	4	8
9998	+7925378	4	8
9999	+7925379	4	8
10000	+7925380	4	8
10001	+7925381	4	8
10002	+7925382	4	8
10003	+7925383	4	8
10004	+7925384	4	8
10005	+7925385	4	8
10006	+7925386	4	8
10007	+7925387	4	8
10008	+7925388	4	8
10009	+7925389	4	8
10010	+792539	4	7
10011	+792540	4	7
10012	+7925410	4	8
10013	+7925411	4	8
10014	+7925412	4	8
10015	+7925413	4	8
10016	+7925414	4	8
10017	+7925415	4	8
10018	+7925416	4	8
10019	+7925417	4	8
10020	+7925418	4	8
10021	+7925419	4	8
10022	+7925420	4	8
10023	+7925421	4	8
10024	+7925422	4	8
10025	+7925423	4	8
10026	+7925424	4	8
10027	+7925425	4	8
10028	+7925426	4	8
10029	+7925427	4	8
10030	+7925428	4	8
10031	+7925429	4	8
10032	+7925430	4	8
10033	+7925431	4	8
10034	+7925432	4	8
10035	+7925433	4	8
10036	+7925434	4	8
10037	+7925435	4	8
10038	+7925436	4	8
10039	+7925437	4	8
10040	+7925438	4	8
10041	+7925439	4	8
10042	+7925440	4	8
10043	+7925441	4	8
10044	+7925442	4	8
10045	+7925443	4	8
10046	+7925444	4	8
10047	+7925445	4	8
10048	+7925446	4	8
10049	+7925447	4	8
10050	+7925448	4	8
10051	+7925449	4	8
10052	+7925450	4	8
10053	+7925451	4	8
10054	+7925452	4	8
10055	+7925453	4	8
10056	+7925454	4	8
10057	+7925455	4	8
10058	+7925456	4	8
10059	+7925457	4	8
10060	+7925458	4	8
10061	+7925459	4	8
10062	+7925460	4	8
10063	+7925461	4	8
10064	+7925462	4	8
10065	+7925463	4	8
10066	+7925464	4	8
10067	+7925465	4	8
10068	+7925466	4	8
10069	+7925467	4	8
10070	+7925468	4	8
10071	+7925469	4	8
10072	+7925470	4	8
10073	+7925471	4	8
10074	+7925472	4	8
10075	+7925473	4	8
10076	+7925474	4	8
10077	+7925475	4	8
10078	+7925476	4	8
10079	+7925477	4	8
10080	+7925478	4	8
10081	+7925479	4	8
10082	+7925480	4	8
10083	+7925481	4	8
10084	+7925482	4	8
10085	+7925483	4	8
10086	+7925484	4	8
10087	+7925485	4	8
10088	+7925486	4	8
10089	+7925487	4	8
10090	+7925488	4	8
10091	+7925489	4	8
10092	+7925500	4	8
10093	+7925501	4	8
10094	+7925502	4	8
10095	+7925503	4	8
10096	+7925504	4	8
10097	+7925505	4	8
10098	+7925506	4	8
10099	+7925507	4	8
10100	+7925508	4	8
10101	+7925509	4	8
10102	+7925510	4	8
10103	+7925511	4	8
10104	+7925512	4	8
10105	+7925513	4	8
10106	+7925514	4	8
10107	+7925515	4	8
10108	+7925516	4	8
10109	+7925517	4	8
10110	+7925518	4	8
10111	+7925519	4	8
10112	+7925520	4	8
10113	+7925521	4	8
10114	+7925522	4	8
10115	+7925523	4	8
10116	+7925524	4	8
10117	+7925525	4	8
10118	+7925526	4	8
10119	+7925527	4	8
10120	+7925528	4	8
10121	+7925529	4	8
10122	+7925530	4	8
10123	+7925531	4	8
10124	+7925532	4	8
10125	+7925533	4	8
10126	+7925534	4	8
10127	+7925535	4	8
10128	+7925536	4	8
10129	+7925537	4	8
10130	+7925538	4	8
10131	+7925539	4	8
10132	+7925540	4	8
10133	+7925541	4	8
10134	+7925542	4	8
10135	+7925543	4	8
10136	+7925544	4	8
10137	+7925545	4	8
10138	+7925580	4	8
10139	+7925585	4	8
10140	+7925589	4	8
10141	+7925642	4	8
10142	+7925646	4	8
10143	+7925663	4	8
10144	+7925664	4	8
10145	+7925665	4	8
10146	+792570	4	7
10147	+792571	4	7
10148	+792572	4	7
10149	+792573	4	7
10150	+7925740	4	8
10151	+7925741	4	8
10152	+7925742	4	8
10153	+7925743	4	8
10154	+7925744	4	8
10155	+7925745	4	8
10156	+7925746	4	8
10157	+7925747	4	8
10158	+7925748	4	8
10159	+7925749	4	8
10160	+7925750	4	8
10161	+7925751	4	8
10162	+7925752	4	8
10163	+7925753	4	8
10164	+7925754	4	8
10165	+7925755	4	8
10166	+7925756	4	8
10167	+7925757	4	8
10168	+7925758	4	8
10169	+7925759	4	8
10170	+7925760	4	8
10171	+7925761	4	8
10172	+7925762	4	8
10173	+7925763	4	8
10174	+7925764	4	8
10175	+7925765	4	8
10176	+7925766	4	8
10177	+7925767	4	8
10178	+7925768	4	8
10179	+7925769	4	8
10180	+7925770	4	8
10181	+7925771	4	8
10182	+7925772	4	8
10183	+7925773	4	8
10184	+7925774	4	8
10185	+7925775	4	8
10186	+7925776	4	8
10187	+7925777	4	8
10188	+7925778	4	8
10189	+7925779	4	8
10190	+7925780	4	8
10191	+7925781	4	8
10192	+7925782	4	8
10193	+7925783	4	8
10194	+7925784	4	8
10195	+7925785	4	8
10196	+7925786	4	8
10197	+7925787	4	8
10198	+7925788	4	8
10199	+7925789	4	8
10200	+7925790	4	8
10201	+7925791	4	8
10202	+7925792	4	8
10203	+7925793	4	8
10204	+7925794	4	8
10205	+7925795	4	8
10206	+7925796	4	8
10207	+7925797	4	8
10208	+7925798	4	8
10209	+7925799	4	8
10210	+79258	4	6
10211	+7925920	4	8
10212	+7925922	4	8
10213	+7925960	4	8
10214	+7925961	4	8
10215	+7925967	4	8
10216	+7925968	4	8
10217	+7925969	4	8
10218	+7925970	4	8
10219	+7925974	4	8
10220	+7925985	4	8
10221	+7925991	4	8
10222	+7925997	4	8
10223	+7925998	4	8
10224	+7925999	4	8
10225	+79260	4	6
10226	+79261	4	6
10227	+79262	4	6
10228	+79263	4	6
10229	+79264	4	6
10230	+79265	4	6
10231	+79266	4	6
10232	+79267	4	6
10233	+79268	4	6
10234	+79269	4	6
10235	+792700	4	7
10236	+792701	4	7
10237	+792702	4	7
10238	+792703	4	7
10239	+792704	4	7
10240	+792705	4	7
10241	+792706	4	7
10242	+792707	4	7
10243	+792708	4	7
10244	+792709	4	7
10245	+792710	4	7
10246	+792711	4	7
10247	+7927111	4	8
10248	+7927112	4	8
10249	+7927113	4	8
10250	+7927114	4	8
10251	+7927115	4	8
10252	+7927116	4	8
10253	+7927117	4	8
10254	+7927118	4	8
10255	+7927119	4	8
10256	+7927120	4	8
10257	+7927121	4	8
10258	+7927122	4	8
10259	+7927123	4	8
10260	+7927124	4	8
10261	+7927125	4	8
10262	+7927126	4	8
10263	+7927127	4	8
10264	+7927128	4	8
10265	+7927129	4	8
10266	+7927130	4	8
10267	+7927131	4	8
10268	+7927132	4	8
10269	+7927133	4	8
10270	+7927134	4	8
10271	+7927135	4	8
10272	+7927136	4	8
10273	+7927137	4	8
10274	+7927138	4	8
10275	+7927139	4	8
10276	+7927140	4	8
10277	+7927141	4	8
10278	+7927142	4	8
10279	+7927143	4	8
10280	+7927144	4	8
10281	+7927145	4	8
10282	+7927146	4	8
10283	+7927147	4	8
10284	+7927148	4	8
10285	+7927149	4	8
10286	+7927150	4	8
10287	+7927151	4	8
10288	+7927152	4	8
10289	+7927153	4	8
10290	+7927154	4	8
10291	+7927155	4	8
10292	+7927156	4	8
10293	+7927157	4	8
10294	+7927158	4	8
10295	+7927159	4	8
10296	+7927160	4	8
10297	+7927161	4	8
10298	+7927162	4	8
10299	+7927163	4	8
10300	+7927164	4	8
10301	+7927165	4	8
10302	+7927166	4	8
10303	+7927167	4	8
10304	+7927168	4	8
10305	+7927169	4	8
10306	+792717	4	7
10307	+792718	4	7
10308	+792719	4	7
10309	+792720	4	7
10310	+792721	4	7
10311	+792722	4	7
10312	+792723	4	7
10313	+792724	4	7
10314	+792725	4	7
10315	+7927260	4	8
10316	+7927261	4	8
10317	+7927262	4	8
10318	+7927263	4	8
10319	+7927264	4	8
10320	+7927265	4	8
10321	+7927266	4	8
10322	+7927267	4	8
10323	+7927268	4	8
10324	+7927269	4	8
10325	+7927270	4	8
10326	+7927271	4	8
10327	+7927272	4	8
10328	+7927273	4	8
10329	+7927274	4	8
10330	+7927275	4	8
10331	+7927276	4	8
10332	+7927277	4	8
10333	+7927278	4	8
10334	+7927279	4	8
10335	+7927280	4	8
10336	+7927281	4	8
10337	+7927282	4	8
10338	+7927283	4	8
10339	+7927284	4	8
10340	+7927285	4	8
10341	+7927286	4	8
10342	+7927287	4	8
10343	+7927288	4	8
10344	+7927289	4	8
10345	+792729	4	7
10346	+792730	4	7
10347	+792731	4	7
10348	+792732	4	7
10349	+792733	4	7
10350	+792734	4	7
10351	+792735	4	7
10352	+792736	4	7
10353	+792737	4	7
10354	+792738	4	7
10355	+792739	4	7
10356	+792740	4	7
10357	+792741	4	7
10358	+792742	4	7
10359	+792743	4	7
10360	+792744	4	7
10361	+792745	4	7
10362	+792746	4	7
10363	+792747	4	7
10364	+792748	4	7
10365	+792749	4	7
10366	+792750	4	7
10367	+792751	4	7
10368	+792752	4	7
10369	+792753	4	7
10370	+792754	4	7
10371	+792755	4	7
10372	+792756	4	7
10373	+792757	4	7
10374	+792758	4	7
10375	+792759	4	7
10376	+792760	4	7
10377	+792761	4	7
10378	+792762	4	7
10379	+7927630	4	8
10380	+7927631	4	8
10381	+7927632	4	8
10382	+7927633	4	8
10383	+7927634	4	8
10384	+7927635	4	8
10385	+7927636	4	8
10386	+7927637	4	8
10387	+7927638	4	8
10388	+7927639	4	8
10389	+7927640	4	8
10390	+7927641	4	8
10391	+7927642	4	8
10392	+7927643	4	8
10393	+7927644	4	8
10394	+7927645	4	8
10395	+7927646	4	8
10396	+7927647	4	8
10397	+7927648	4	8
10398	+7927649	4	8
10399	+792765	4	7
10400	+7927660	4	8
10401	+7927661	4	8
10402	+7927662	4	8
10403	+7927663	4	8
10404	+7927664	4	8
10405	+7927665	4	8
10406	+7927666	4	8
10407	+7927667	4	8
10408	+7927668	4	8
10409	+7927669	4	8
10410	+792767	4	7
10411	+7927680	4	8
10412	+7927681	4	8
10413	+7927682	4	8
10414	+7927683	4	8
10415	+7927684	4	8
10416	+7927685	4	8
10417	+7927686	4	8
10418	+7927687	4	8
10419	+7927688	4	8
10420	+7927689	4	8
10421	+7927690	4	8
10422	+7927691	4	8
10423	+7927692	4	8
10424	+7927693	4	8
10425	+7927694	4	8
10426	+7927695	4	8
10427	+7927696	4	8
10428	+7927697	4	8
10429	+7927698	4	8
10430	+7927699	4	8
10431	+7927700	4	8
10432	+7927701	4	8
10433	+7927702	4	8
10434	+7927703	4	8
10435	+7927704	4	8
10436	+7927705	4	8
10437	+7927706	4	8
10438	+7927707	4	8
10439	+7927708	4	8
10440	+7927709	4	8
10441	+7927710	4	8
10442	+7927711	4	8
10443	+7927712	4	8
10444	+7927713	4	8
10445	+7927714	4	8
10446	+7927715	4	8
10447	+7927716	4	8
10448	+7927717	4	8
10449	+7927718	4	8
10450	+7927719	4	8
10451	+7927720	4	8
10452	+7927721	4	8
10453	+7927722	4	8
10454	+7927723	4	8
10455	+7927724	4	8
10456	+7927725	4	8
10457	+7927726	4	8
10458	+7927727	4	8
10459	+7927728	4	8
10460	+7927729	4	8
10461	+7927730	4	8
10462	+7927731	4	8
10463	+7927732	4	8
10464	+7927733	4	8
10465	+7927734	4	8
10466	+7927735	4	8
10467	+7927736	4	8
10468	+7927737	4	8
10469	+7927738	4	8
10470	+7927739	4	8
10471	+7927740	4	8
10472	+7927741	4	8
10473	+7927742	4	8
10474	+7927743	4	8
10475	+7927744	4	8
10476	+7927745	4	8
10477	+7927746	4	8
10478	+7927747	4	8
10479	+7927748	4	8
10480	+7927749	4	8
10481	+7927750	4	8
10482	+7927751	4	8
10483	+7927752	4	8
10484	+7927753	4	8
10485	+7927754	4	8
10486	+7927755	4	8
10487	+7927756	4	8
10488	+7927757	4	8
10489	+7927758	4	8
10490	+7927759	4	8
10491	+7927760	4	8
10492	+7927761	4	8
10493	+7927762	4	8
10494	+7927763	4	8
10495	+7927764	4	8
10496	+7927765	4	8
10497	+7927766	4	8
10498	+7927767	4	8
10499	+7927768	4	8
10500	+7927769	4	8
10501	+792777	4	7
10502	+792778	4	7
10503	+792779	4	7
10504	+792780	4	7
10505	+792781	4	7
10506	+792782	4	7
10507	+792783	4	7
10508	+792784	4	7
10509	+792785	4	7
10510	+792786	4	7
10511	+792787	4	7
10512	+792788	4	7
10513	+792789	4	7
10514	+792790	4	7
10515	+792791	4	7
10516	+792792	4	7
10517	+792793	4	7
10518	+792794	4	7
10519	+792795	4	7
10520	+792796	4	7
10521	+792797	4	7
10522	+792798	4	7
10523	+792799	4	7
10524	+7928000	4	8
10525	+7928001	4	8
10526	+7928002	4	8
10527	+7928003	4	8
10528	+7928004	4	8
10529	+7928005	4	8
10530	+7928006	4	8
10531	+7928007	4	8
10532	+7928008	4	8
10533	+7928009	4	8
10534	+7928010	4	8
10535	+7928011	4	8
10536	+7928012	4	8
10537	+7928013	4	8
10538	+7928014	4	8
10539	+7928015	4	8
10540	+7928016	4	8
10541	+7928017	4	8
10542	+7928018	4	8
10543	+7928019	4	8
10544	+7928020	4	8
10545	+7928021	4	8
10546	+7928022	4	8
10547	+7928023	4	8
10548	+7928024	4	8
10549	+7928025	4	8
10550	+7928026	4	8
10551	+7928027	4	8
10552	+7928028	4	8
10553	+7928029	4	8
10554	+7928030	4	8
10555	+7928031	4	8
10556	+7928032	4	8
10557	+7928033	4	8
10558	+7928034	4	8
10559	+7928035	4	8
10560	+7928036	4	8
10561	+7928037	4	8
10562	+7928038	4	8
10563	+7928039	4	8
10564	+7928040	4	8
10565	+7928041	4	8
10566	+7928042	4	8
10567	+7928043	4	8
10568	+7928044	4	8
10569	+7928045	4	8
10570	+7928046	4	8
10571	+7928047	4	8
10572	+7928048	4	8
10573	+7928049	4	8
10574	+7928050	4	8
10575	+7928051	4	8
10576	+7928052	4	8
10577	+7928053	4	8
10578	+7928054	4	8
10579	+7928055	4	8
10580	+7928056	4	8
10581	+7928057	4	8
10582	+7928058	4	8
10583	+7928059	4	8
10584	+7928060	4	8
10585	+7928061	4	8
10586	+7928062	4	8
10587	+7928063	4	8
10588	+7928064	4	8
10589	+7928065	4	8
10590	+7928066	4	8
10591	+7928067	4	8
10592	+7928068	4	8
10593	+7928069	4	8
10594	+7928070	4	8
10595	+7928071	4	8
10596	+7928072	4	8
10597	+7928073	4	8
10598	+7928074	4	8
10599	+7928075	4	8
10600	+7928076	4	8
10601	+7928077	4	8
10602	+7928078	4	8
10603	+7928079	4	8
10604	+7928080	4	8
10605	+7928081	4	8
10606	+7928082	4	8
10607	+7928083	4	8
10608	+7928084	4	8
10609	+7928085	4	8
10610	+7928086	4	8
10611	+7928087	4	8
10612	+7928088	4	8
10613	+7928089	4	8
10614	+792809	4	7
10615	+79281	4	6
10616	+792820	4	7
10617	+792821	4	7
10618	+7928211	4	8
10619	+7928212	4	8
10620	+7928213	4	8
10621	+7928214	4	8
10622	+7928215	4	8
10623	+7928216	4	8
10624	+7928217	4	8
10625	+7928218	4	8
10626	+7928219	4	8
10627	+7928220	4	8
10628	+7928221	4	8
10629	+7928222	4	8
10630	+7928223	4	8
10631	+7928224	4	8
10632	+7928225	4	8
10633	+7928226	4	8
10634	+7928227	4	8
10635	+7928228	4	8
10636	+7928229	4	8
10637	+7928230	4	8
10638	+7928231	4	8
10639	+7928232	4	8
10640	+7928233	4	8
10641	+7928234	4	8
10642	+7928235	4	8
10643	+7928236	4	8
10644	+7928237	4	8
10645	+7928238	4	8
10646	+7928239	4	8
10647	+7928240	4	8
10648	+7928241	4	8
10649	+7928242	4	8
10650	+7928243	4	8
10651	+7928244	4	8
10652	+7928245	4	8
10653	+7928246	4	8
10654	+7928247	4	8
10655	+7928248	4	8
10656	+7928249	4	8
10657	+7928250	4	8
10658	+7928251	4	8
10659	+7928252	4	8
10660	+7928253	4	8
10661	+7928254	4	8
10662	+7928255	4	8
10663	+7928256	4	8
10664	+7928257	4	8
10665	+7928258	4	8
10666	+7928259	4	8
10667	+7928260	4	8
10668	+7928261	4	8
10669	+7928262	4	8
10670	+7928263	4	8
10671	+7928264	4	8
10672	+7928265	4	8
10673	+7928266	4	8
10674	+7928267	4	8
10675	+7928268	4	8
10676	+7928269	4	8
10677	+7928270	4	8
10678	+7928271	4	8
10679	+7928272	4	8
10680	+7928273	4	8
10681	+7928274	4	8
10682	+7928275	4	8
10683	+7928276	4	8
10684	+7928277	4	8
10685	+7928278	4	8
10686	+7928279	4	8
10687	+7928280	4	8
10688	+7928281	4	8
10689	+7928282	4	8
10690	+7928283	4	8
10691	+7928284	4	8
10692	+7928285	4	8
10693	+7928286	4	8
10694	+7928287	4	8
10695	+7928288	4	8
10696	+7928289	4	8
10697	+7928290	4	8
10698	+7928291	4	8
10699	+7928292	4	8
10700	+7928293	4	8
10701	+7928294	4	8
10702	+7928295	4	8
10703	+7928296	4	8
10704	+7928297	4	8
10705	+7928298	4	8
10706	+7928299	4	8
10707	+792830	4	7
10708	+792831	4	7
10709	+792832	4	7
10710	+7928330	4	8
10711	+7928331	4	8
10712	+7928332	4	8
10713	+7928333	4	8
10714	+7928334	4	8
10715	+7928335	4	8
10716	+7928336	4	8
10717	+7928337	4	8
10718	+7928338	4	8
10719	+7928339	4	8
10720	+792834	4	7
10721	+792835	4	7
10722	+792836	4	7
10723	+792837	4	7
10724	+792838	4	7
10725	+792839	4	7
10726	+7928400	4	8
10727	+7928401	4	8
10728	+7928402	4	8
10729	+7928403	4	8
10730	+7928404	4	8
10731	+7928405	4	8
10732	+7928406	4	8
10733	+7928407	4	8
10734	+7928408	4	8
10735	+7928409	4	8
10736	+7928410	4	8
10737	+7928411	4	8
10738	+7928412	4	8
10739	+7928413	4	8
10740	+7928414	4	8
10741	+7928415	4	8
10742	+7928416	4	8
10743	+7928417	4	8
10744	+7928418	4	8
10745	+7928419	4	8
10746	+7928420	4	8
10747	+7928421	4	8
10748	+7928422	4	8
10749	+7928423	4	8
10750	+7928424	4	8
10751	+7928425	4	8
10752	+7928426	4	8
10753	+7928427	4	8
10754	+7928428	4	8
10755	+7928429	4	8
10756	+7928430	4	8
10757	+7928431	4	8
10758	+7928432	4	8
10759	+7928433	4	8
10760	+7928434	4	8
10761	+7928435	4	8
10762	+7928436	4	8
10763	+7928437	4	8
10764	+7928438	4	8
10765	+7928439	4	8
10766	+7928440	4	8
10767	+7928441	4	8
10768	+7928442	4	8
10769	+7928443	4	8
10770	+7928444	4	8
10771	+7928445	4	8
10772	+7928446	4	8
10773	+7928447	4	8
10774	+7928448	4	8
10775	+7928449	4	8
10776	+7928450	4	8
10777	+7928451	4	8
10778	+7928452	4	8
10779	+7928453	4	8
10780	+7928454	4	8
10781	+7928455	4	8
10782	+7928456	4	8
10783	+7928457	4	8
10784	+7928458	4	8
10785	+7928459	4	8
10786	+7928460	4	8
10787	+7928461	4	8
10788	+7928462	4	8
10789	+7928463	4	8
10790	+7928464	4	8
10791	+7928465	4	8
10792	+7928466	4	8
10793	+7928467	4	8
10794	+7928468	4	8
10795	+7928469	4	8
10796	+7928470	4	8
10797	+7928471	4	8
10798	+7928472	4	8
10799	+7928473	4	8
10800	+7928474	4	8
10801	+7928475	4	8
10802	+7928476	4	8
10803	+7928477	4	8
10804	+7928478	4	8
10805	+7928479	4	8
10806	+792848	4	7
10807	+792849	4	7
10808	+79285	4	6
10809	+792860	4	7
10810	+792861	4	7
10811	+792862	4	7
10812	+792863	4	7
10813	+792864	4	7
10814	+7928650	4	8
10815	+7928651	4	8
10816	+7928652	4	8
10817	+7928653	4	8
10818	+7928654	4	8
10819	+7928655	4	8
10820	+7928656	4	8
10821	+7928657	4	8
10822	+7928658	4	8
10823	+7928659	4	8
10824	+7928660	4	8
10825	+7928661	4	8
10826	+7928662	4	8
10827	+7928663	4	8
10828	+7928664	4	8
10829	+7928665	4	8
10830	+7928666	4	8
10831	+7928667	4	8
10832	+7928668	4	8
10833	+7928669	4	8
10834	+7928670	4	8
10835	+7928671	4	8
10836	+7928672	4	8
10837	+7928673	4	8
10838	+7928674	4	8
10839	+7928675	4	8
10840	+7928676	4	8
10841	+7928677	4	8
10842	+7928678	4	8
10843	+7928679	4	8
10844	+7928680	4	8
10845	+7928681	4	8
10846	+7928682	4	8
10847	+7928683	4	8
10848	+7928684	4	8
10849	+7928685	4	8
10850	+7928686	4	8
10851	+7928687	4	8
10852	+7928688	4	8
10853	+7928689	4	8
10854	+7928690	4	8
10855	+7928691	4	8
10856	+7928692	4	8
10857	+7928693	4	8
10858	+7928694	4	8
10859	+7928695	4	8
10860	+7928696	4	8
10861	+7928697	4	8
10862	+7928698	4	8
10863	+7928699	4	8
10864	+7928700	4	8
10865	+7928701	4	8
10866	+7928702	4	8
10867	+7928703	4	8
10868	+7928704	4	8
10869	+7928705	4	8
10870	+7928706	4	8
10871	+7928707	4	8
10872	+7928708	4	8
10873	+7928709	4	8
10874	+7928710	4	8
10875	+7928711	4	8
10876	+7928712	4	8
10877	+7928713	4	8
10878	+7928714	4	8
10879	+7928715	4	8
10880	+7928716	4	8
10881	+7928717	4	8
10882	+7928718	4	8
10883	+7928719	4	8
10884	+7928720	4	8
10885	+7928721	4	8
10886	+7928722	4	8
10887	+7928723	4	8
10888	+7928724	4	8
10889	+7928725	4	8
10890	+7928726	4	8
10891	+7928727	4	8
10892	+7928728	4	8
10893	+7928729	4	8
10894	+7928730	4	8
10895	+7928731	4	8
10896	+7928732	4	8
10897	+7928733	4	8
10898	+7928734	4	8
10899	+7928735	4	8
10900	+7928736	4	8
10901	+7928737	4	8
10902	+7928738	4	8
10903	+7928739	4	8
10904	+7928740	4	8
10905	+7928741	4	8
10906	+7928742	4	8
10907	+7928743	4	8
10908	+7928744	4	8
10909	+7928745	4	8
10910	+7928746	4	8
10911	+7928747	4	8
10912	+7928748	4	8
10913	+7928749	4	8
10914	+792875	4	7
10915	+792876	4	7
10916	+792877	4	7
10917	+792878	4	7
10918	+792879	4	7
10919	+792880	4	7
10920	+792881	4	7
10921	+792882	4	7
10922	+792883	4	7
10923	+792884	4	7
10924	+7928850	4	8
10925	+7928851	4	8
10926	+7928852	4	8
10927	+7928853	4	8
10928	+7928854	4	8
10929	+7928855	4	8
10930	+7928856	4	8
10931	+7928857	4	8
10932	+7928858	4	8
10933	+7928859	4	8
10934	+7928860	4	8
10935	+7928861	4	8
10936	+7928862	4	8
10937	+7928863	4	8
10938	+7928864	4	8
10939	+7928865	4	8
10940	+7928866	4	8
10941	+7928867	4	8
10942	+7928868	4	8
10943	+7928869	4	8
10944	+7928870	4	8
10945	+7928871	4	8
10946	+7928872	4	8
10947	+7928873	4	8
10948	+7928874	4	8
10949	+7928875	4	8
10950	+7928876	4	8
10951	+7928877	4	8
10952	+7928878	4	8
10953	+7928879	4	8
10954	+7928880	4	8
10955	+7928881	4	8
10956	+7928882	4	8
10957	+7928883	4	8
10958	+7928884	4	8
10959	+7928885	4	8
10960	+7928886	4	8
10961	+7928887	4	8
10962	+7928888	4	8
10963	+7928889	4	8
10964	+7928890	4	8
10965	+7928891	4	8
10966	+7928892	4	8
10967	+7928893	4	8
10968	+7928894	4	8
10969	+7928895	4	8
10970	+7928896	4	8
10971	+7928897	4	8
10972	+7928898	4	8
10973	+7928899	4	8
10974	+792890	4	7
10975	+7928910	4	8
10976	+7928911	4	8
10977	+7928912	4	8
10978	+7928913	4	8
10979	+7928914	4	8
10980	+7928915	4	8
10981	+7928916	4	8
10982	+7928917	4	8
10983	+7928918	4	8
10984	+7928919	4	8
10985	+7928920	4	8
10986	+7928921	4	8
10987	+7928922	4	8
10988	+7928923	4	8
10989	+7928924	4	8
10990	+7928925	4	8
10991	+7928926	4	8
10992	+7928927	4	8
10993	+7928928	4	8
10994	+7928929	4	8
10995	+7928930	4	8
10996	+7928931	4	8
10997	+7928932	4	8
10998	+7928933	4	8
10999	+7928934	4	8
11000	+7928935	4	8
11001	+7928936	4	8
11002	+7928937	4	8
11003	+7928938	4	8
11004	+7928939	4	8
11005	+7928940	4	8
11006	+7928941	4	8
11007	+7928942	4	8
11008	+7928943	4	8
11009	+7928944	4	8
11010	+7928945	4	8
11011	+7928946	4	8
11012	+7928947	4	8
11013	+7928948	4	8
11014	+7928949	4	8
11015	+7928950	4	8
11016	+7928951	4	8
11017	+7928952	4	8
11018	+7928953	4	8
11019	+7928954	4	8
11020	+7928955	4	8
11021	+7928956	4	8
11022	+7928957	4	8
11023	+7928958	4	8
11024	+7928959	4	8
11025	+7928960	4	8
11026	+7928961	4	8
11027	+7928962	4	8
11028	+7928963	4	8
11029	+7928964	4	8
11030	+7928965	4	8
11031	+7928966	4	8
11032	+7928967	4	8
11033	+7928968	4	8
11034	+7928969	4	8
11035	+7928970	4	8
11036	+7928971	4	8
11037	+7928972	4	8
11038	+7928973	4	8
11039	+7928974	4	8
11040	+7928975	4	8
11041	+7928976	4	8
11042	+7928977	4	8
11043	+7928978	4	8
11044	+7928979	4	8
11045	+7928980	4	8
11046	+7928981	4	8
11047	+7928982	4	8
11048	+7928983	4	8
11049	+7928984	4	8
11050	+7928985	4	8
11051	+7928986	4	8
11052	+7928987	4	8
11053	+7928988	4	8
11054	+7928989	4	8
11055	+7928990	4	8
11056	+7928991	4	8
11057	+7928992	4	8
11058	+7928993	4	8
11059	+7928994	4	8
11060	+7928995	4	8
11061	+7928996	4	8
11062	+7928997	4	8
11063	+7928998	4	8
11064	+7928999	4	8
11065	+7929000	4	8
11066	+7929001	4	8
11067	+7929002	4	8
11068	+7929003	4	8
11069	+7929004	4	8
11070	+7929005	4	8
11071	+7929006	4	8
11072	+7929007	4	8
11073	+7929008	4	8
11074	+7929009	4	8
11075	+7929010	4	8
11076	+7929011	4	8
11077	+7929012	4	8
11078	+7929013	4	8
11079	+7929014	4	8
11080	+7929015	4	8
11081	+7929016	4	8
11082	+7929017	4	8
11083	+7929018	4	8
11084	+7929019	4	8
11085	+7929020	4	8
11086	+7929021	4	8
11087	+7929022	4	8
11088	+7929023	4	8
11089	+7929024	4	8
11090	+7929025	4	8
11091	+7929026	4	8
11092	+7929027	4	8
11093	+7929028	4	8
11094	+7929029	4	8
11095	+7929030	4	8
11096	+7929031	4	8
11097	+7929032	4	8
11098	+7929033	4	8
11099	+7929034	4	8
11100	+7929035	4	8
11101	+7929036	4	8
11102	+7929037	4	8
11103	+792903	4	7
11104	+792904	4	7
11105	+792905	4	7
11106	+7929059	4	8
11107	+7929060	4	8
11108	+7929061	4	8
11109	+7929062	4	8
11110	+7929063	4	8
11111	+7929064	4	8
11112	+7929065	4	8
11113	+7929066	4	8
11114	+7929067	4	8
11115	+7929068	4	8
11116	+7929069	4	8
11117	+7929070	4	8
11118	+7929071	4	8
11119	+7929072	4	8
11120	+7929073	4	8
11121	+7929074	4	8
11122	+7929075	4	8
11123	+7929076	4	8
11124	+7929077	4	8
11125	+7929078	4	8
11126	+7929079	4	8
11127	+7929080	4	8
11128	+7929081	4	8
11129	+7929082	4	8
11130	+7929083	4	8
11131	+7929084	4	8
11132	+7929085	4	8
11133	+7929086	4	8
11134	+7929087	4	8
11135	+7929088	4	8
11136	+7929089	4	8
11137	+7929090	4	8
11138	+7929091	4	8
11139	+7929092	4	8
11140	+7929093	4	8
11141	+7929094	4	8
11142	+7929095	4	8
11143	+7929096	4	8
11144	+7929097	4	8
11145	+7929098	4	8
11146	+7929099	4	8
11147	+792910	4	7
11148	+792911	4	7
11149	+792912	4	7
11150	+792913	4	7
11151	+792914	4	7
11152	+792915	4	7
11153	+792916	4	7
11154	+792917	4	7
11155	+792918	4	7
11156	+792919	4	7
11157	+7929200	4	8
11158	+7929201	4	8
11159	+7929202	4	8
11160	+7929203	4	8
11161	+7929204	4	8
11162	+7929205	4	8
11163	+7929206	4	8
11164	+7929207	4	8
11165	+7929208	4	8
11166	+7929209	4	8
11167	+7929210	4	8
11168	+7929211	4	8
11169	+7929212	4	8
11170	+7929213	4	8
11171	+7929214	4	8
11172	+7929215	4	8
11173	+7929216	4	8
11174	+7929217	4	8
11175	+7929218	4	8
11176	+7929219	4	8
11177	+7929220	4	8
11178	+7929221	4	8
11179	+7929222	4	8
11180	+7929223	4	8
11181	+7929224	4	8
11182	+7929225	4	8
11183	+7929226	4	8
11184	+7929227	4	8
11185	+7929228	4	8
11186	+7929229	4	8
11187	+7929230	4	8
11188	+7929231	4	8
11189	+7929232	4	8
11190	+7929233	4	8
11191	+7929234	4	8
11192	+7929235	4	8
11193	+7929236	4	8
11194	+7929237	4	8
11195	+7929238	4	8
11196	+7929239	4	8
11197	+792924	4	7
11198	+792925	4	7
11199	+792926	4	7
11200	+7929270	4	8
11201	+7929271	4	8
11202	+7929272	4	8
11203	+7929273	4	8
11204	+7929274	4	8
11205	+7929275	4	8
11206	+7929276	4	8
11207	+7929277	4	8
11208	+7929278	4	8
11209	+7929279	4	8
11210	+7929280	4	8
11211	+7929281	4	8
11212	+7929282	4	8
11213	+7929283	4	8
11214	+7929284	4	8
11215	+7929285	4	8
11216	+7929286	4	8
11217	+7929287	4	8
11218	+7929288	4	8
11219	+7929289	4	8
11220	+7929290	4	8
11221	+7929291	4	8
11222	+7929292	4	8
11223	+7929293	4	8
11224	+7929294	4	8
11225	+7929295	4	8
11226	+7929296	4	8
11227	+7929297	4	8
11228	+7929298	4	8
11229	+7929299	4	8
11230	+79293000	4	9
11231	+79293001	4	9
11232	+79293002	4	9
11233	+79293003	4	9
11234	+79293004	4	9
11235	+79293005	4	9
11236	+79293006	4	9
11237	+79293007	4	9
11238	+79293008	4	9
11239	+79293009	4	9
11240	+79293010	4	9
11241	+79293011	4	9
11242	+79293012	4	9
11243	+79293013	4	9
11244	+79293014	4	9
11245	+79293015	4	9
11246	+79293016	4	9
11247	+79293017	4	9
11248	+79293018	4	9
11249	+79293019	4	9
11250	+7929302	4	8
11251	+7929303	4	8
11252	+7929304	4	8
11253	+7929305	4	8
11254	+7929306	4	8
11255	+7929307	4	8
11256	+7929308	4	8
11257	+7929309	4	8
11258	+7929310	4	8
11259	+7929311	4	8
11260	+7929312	4	8
11261	+7929313	4	8
11262	+7929314	4	8
11263	+7929315	4	8
11264	+7929316	4	8
11265	+7929317	4	8
11266	+7929318	4	8
11267	+7929319	4	8
11268	+7929320	4	8
11269	+7929321	4	8
11270	+7929322	4	8
11271	+7929323	4	8
11272	+7929324	4	8
11273	+7929325	4	8
11274	+7929326	4	8
11275	+7929327	4	8
11276	+7929328	4	8
11277	+7929329	4	8
11278	+7929330	4	8
11279	+7929331	4	8
11280	+7929332	4	8
11281	+7929333	4	8
11282	+7929334	4	8
11283	+7929335	4	8
11284	+7929336	4	8
11285	+7929337	4	8
11286	+7929338	4	8
11287	+7929339	4	8
11288	+79293400	4	9
11289	+79293401	4	9
11290	+79293402	4	9
11291	+79293403	4	9
11292	+79293404	4	9
11293	+79293405	4	9
11294	+79293406	4	9
11295	+79293407	4	9
11296	+79293408	4	9
11297	+79293409	4	9
11298	+79293410	4	9
11299	+79293411	4	9
11300	+79293412	4	9
11301	+79293413	4	9
11302	+79293414	4	9
11303	+79293415	4	9
11304	+79293416	4	9
11305	+79293417	4	9
11306	+79293418	4	9
11307	+79293419	4	9
11308	+79293420	4	9
11309	+79293421	4	9
11310	+79293422	4	9
11311	+79293423	4	9
11312	+79293424	4	9
11313	+79293425	4	9
11314	+79293426	4	9
11315	+79293427	4	9
11316	+79293428	4	9
11317	+79293429	4	9
11318	+7929343	4	8
11319	+79293440	4	9
11320	+79293441	4	9
11321	+79293442	4	9
11322	+79293443	4	9
11323	+79293444	4	9
11324	+79293445	4	9
11325	+79293446	4	9
11326	+79293447	4	9
11327	+79293448	4	9
11328	+79293449	4	9
11329	+7929345	4	8
11330	+7929346	4	8
11331	+7929347	4	8
11332	+7929348	4	8
11333	+7929349	4	8
11334	+7929350	4	8
11335	+7929351	4	8
11336	+7929352	4	8
11337	+7929353	4	8
11338	+7929354	4	8
11339	+7929355	4	8
11340	+7929356	4	8
11341	+7929357	4	8
11342	+7929358	4	8
11343	+7929359	4	8
11344	+792936	4	7
11345	+7929370	4	8
11346	+7929371	4	8
11347	+7929372	4	8
11348	+7929373	4	8
11349	+7929374	4	8
11350	+7929375	4	8
11351	+7929376	4	8
11352	+7929377	4	8
11353	+7929378	4	8
11354	+7929379	4	8
11355	+792938	4	7
11356	+792939	4	7
11357	+792940	4	7
11358	+792941	4	7
11359	+792942	4	7
11360	+792943	4	7
11361	+792944	4	7
11362	+7929450	4	8
11363	+7929451	4	8
11364	+7929452	4	8
11365	+7929453	4	8
11366	+7929454	4	8
11367	+7929455	4	8
11368	+7929456	4	8
11369	+7929457	4	8
11370	+7929458	4	8
11371	+7929459	4	8
11372	+792946	4	7
11373	+7929470	4	8
11374	+7929471	4	8
11375	+7929472	4	8
11376	+7929473	4	8
11377	+7929474	4	8
11378	+7929475	4	8
11379	+7929476	4	8
11380	+7929477	4	8
11381	+7929478	4	8
11382	+7929479	4	8
11383	+792948	4	7
11384	+7929490	4	8
11385	+7929491	4	8
11386	+7929492	4	8
11387	+7929493	4	8
11388	+7929494	4	8
11389	+7929495	4	8
11390	+7929496	4	8
11391	+7929497	4	8
11392	+7929498	4	8
11393	+7929499	4	8
11394	+79295	4	6
11395	+792970	4	7
11396	+792971	4	7
11397	+792972	4	7
11398	+7929730	4	8
11399	+7929731	4	8
11400	+7929732	4	8
11401	+7929733	4	8
11402	+7929734	4	8
11403	+7929735	4	8
11404	+7929736	4	8
11405	+7929737	4	8
11406	+7929738	4	8
11407	+7929739	4	8
11408	+7929740	4	8
11409	+7929741	4	8
11410	+7929742	4	8
11411	+7929743	4	8
11412	+7929744	4	8
11413	+7929745	4	8
11414	+7929746	4	8
11415	+7929747	4	8
11416	+7929748	4	8
11417	+7929749	4	8
11418	+792975	4	7
11419	+7929760	4	8
11420	+7929761	4	8
11421	+7929762	4	8
11422	+7929763	4	8
11423	+7929764	4	8
11424	+7929765	4	8
11425	+7929766	4	8
11426	+7929767	4	8
11427	+7929768	4	8
11428	+7929769	4	8
11429	+792977	4	7
11430	+792978	4	7
11431	+792979	4	7
11432	+7929800	4	8
11433	+7929801	4	8
11434	+7929802	4	8
11435	+7929813	4	8
11436	+7929814	4	8
11437	+7929815	4	8
11438	+7929816	4	8
11439	+7929817	4	8
11440	+7929818	4	8
11441	+7929819	4	8
11442	+7929820	4	8
11443	+7929821	4	8
11444	+792982	4	7
11445	+792983	4	7
11446	+792984	4	7
11447	+792985	4	7
11448	+7929853	4	8
11449	+7929854	4	8
11450	+7929855	4	8
11451	+7929856	4	8
11452	+7929857	4	8
11453	+7929858	4	8
11454	+7929859	4	8
11455	+7929860	4	8
11456	+7929861	4	8
11457	+7929862	4	8
11458	+7929863	4	8
11459	+7929864	4	8
11460	+7929865	4	8
11461	+7929866	4	8
11462	+7929867	4	8
11463	+7929868	4	8
11464	+7929869	4	8
11465	+7929870	4	8
11466	+7929871	4	8
11467	+7929872	4	8
11468	+7929873	4	8
11469	+7929874	4	8
11470	+7929875	4	8
11471	+7929876	4	8
11472	+7929877	4	8
11473	+7929878	4	8
11474	+7929879	4	8
11475	+7929880	4	8
11476	+7929881	4	8
11477	+7929882	4	8
11478	+7929883	4	8
11479	+7929884	4	8
11480	+7929885	4	8
11481	+7929886	4	8
11482	+7929887	4	8
11483	+7929888	4	8
11484	+7929889	4	8
11485	+7929890	4	8
11486	+7929891	4	8
11487	+7929892	4	8
11488	+7929893	4	8
11489	+7929894	4	8
11490	+7929895	4	8
11491	+7929896	4	8
11492	+7929897	4	8
11493	+7929898	4	8
11494	+7929899	4	8
11495	+79299	4	6
11496	+7930005	4	8
11497	+7930011	4	8
11498	+7930014	4	8
11499	+7930031	4	8
11500	+7930034	4	8
11501	+7930037	4	8
11502	+7930056	4	8
11503	+7930063	4	8
11504	+7930069	4	8
11505	+7930074	4	8
11506	+7930076	4	8
11507	+7930086	4	8
11508	+7930091	4	8
11509	+7930096	4	8
11510	+7930100	4	8
11511	+7930101	4	8
11512	+7930102	4	8
11513	+7930103	4	8
11514	+7930104	4	8
11515	+7930105	4	8
11516	+7930106	4	8
11517	+7930107	4	8
11518	+7930108	4	8
11519	+7930109	4	8
11520	+7930110	4	8
11521	+7930111	4	8
11522	+7930112	4	8
11523	+7930113	4	8
11524	+7930114	4	8
11525	+7930115	4	8
11526	+7930116	4	8
11527	+7930117	4	8
11528	+7930118	4	8
11529	+7930119	4	8
11530	+7930120	4	8
11531	+7930121	4	8
11532	+7930122	4	8
11533	+7930123	4	8
11534	+7930124	4	8
11535	+7930125	4	8
11536	+7930126	4	8
11537	+7930127	4	8
11538	+7930128	4	8
11539	+7930129	4	8
11540	+7930130	4	8
11541	+7930131	4	8
11542	+7930132	4	8
11543	+7930133	4	8
11544	+7930134	4	8
11545	+7930135	4	8
11546	+7930136	4	8
11547	+7930137	4	8
11548	+793015	4	7
11549	+793016	4	7
11550	+793017	4	7
11551	+793018	4	7
11552	+793019	4	7
11553	+7930300	4	8
11554	+7930301	4	8
11555	+7930302	4	8
11556	+7930303	4	8
11557	+7930304	4	8
11558	+7930305	4	8
11559	+7930306	4	8
11560	+7930320	4	8
11561	+7930321	4	8
11562	+7930330	4	8
11563	+793034	4	7
11564	+793035	4	7
11565	+793036	4	7
11566	+7930370	4	8
11567	+793038	4	7
11568	+793039	4	7
11569	+793040	4	7
11570	+7930470	4	8
11571	+793070	4	7
11572	+793071	4	7
11573	+793072	4	7
11574	+793073	4	7
11575	+793074	4	7
11576	+793075	4	7
11577	+793076	4	7
11578	+793077	4	7
11579	+793078	4	7
11580	+793079	4	7
11581	+793080	4	7
11582	+793081	4	7
11583	+793082	4	7
11584	+793083	4	7
11585	+793084	4	7
11586	+793085	4	7
11587	+793086	4	7
11588	+793087	4	7
11589	+793088	4	7
11590	+793089	4	7
11591	+7931000	4	8
11592	+7931001	4	8
11593	+7931002	4	8
11594	+7931003	4	8
11595	+7931004	4	8
11596	+7931005	4	8
11597	+7931006	4	8
11598	+7931007	4	8
11599	+7931008	4	8
11600	+7931200	4	8
11601	+7931201	4	8
11602	+7931202	4	8
11603	+7931203	4	8
11604	+7931204	4	8
11605	+7931205	4	8
11606	+7931206	4	8
11607	+7931207	4	8
11608	+7931208	4	8
11609	+7931209	4	8
11610	+7931210	4	8
11611	+7931211	4	8
11612	+7931212	4	8
11613	+7931213	4	8
11614	+7931214	4	8
11615	+7931215	4	8
11616	+7931216	4	8
11617	+7931217	4	8
11618	+7931218	4	8
11619	+7931219	4	8
11620	+7931220	4	8
11621	+7931221	4	8
11622	+7931222	4	8
11623	+7931223	4	8
11624	+7931224	4	8
11625	+7931225	4	8
11626	+7931226	4	8
11627	+7931227	4	8
11628	+7931228	4	8
11629	+7931229	4	8
11630	+7931230	4	8
11631	+7931231	4	8
11632	+7931232	4	8
11633	+7931233	4	8
11634	+7931234	4	8
11635	+7931235	4	8
11636	+7931236	4	8
11637	+7931237	4	8
11638	+7931238	4	8
11639	+7931239	4	8
11640	+7931240	4	8
11641	+7931241	4	8
11642	+7931242	4	8
11643	+7931243	4	8
11644	+7931244	4	8
11645	+7931245	4	8
11646	+7931246	4	8
11647	+7931247	4	8
11648	+7931248	4	8
11649	+7931249	4	8
11650	+7931250	4	8
11651	+7931251	4	8
11652	+7931252	4	8
11653	+7931253	4	8
11654	+7931254	4	8
11655	+7931255	4	8
11656	+7931256	4	8
11657	+7931257	4	8
11658	+7931258	4	8
11659	+7931259	4	8
11660	+7931260	4	8
11661	+7931261	4	8
11662	+7931262	4	8
11663	+7931263	4	8
11664	+7931264	4	8
11665	+7931265	4	8
11666	+7931266	4	8
11667	+7931267	4	8
11668	+7931268	4	8
11669	+7931269	4	8
11670	+7931270	4	8
11671	+7931271	4	8
11672	+7931272	4	8
11673	+7931273	4	8
11674	+7931274	4	8
11675	+7931275	4	8
11676	+7931276	4	8
11677	+7931277	4	8
11678	+7931278	4	8
11679	+7931279	4	8
11680	+7931280	4	8
11681	+7931281	4	8
11682	+7931282	4	8
11683	+7931283	4	8
11684	+7931284	4	8
11685	+7931285	4	8
11686	+7931286	4	8
11687	+7931287	4	8
11688	+7931288	4	8
11689	+7931289	4	8
11690	+7931290	4	8
11691	+7931291	4	8
11692	+7931292	4	8
11693	+7931293	4	8
11694	+7931294	4	8
11695	+7931295	4	8
11696	+7931296	4	8
11697	+7931297	4	8
11698	+7931298	4	8
11699	+7931299	4	8
11700	+7931300	4	8
11701	+7931301	4	8
11702	+7931302	4	8
11703	+7931303	4	8
11704	+7931304	4	8
11705	+7931305	4	8
11706	+7931306	4	8
11707	+7931307	4	8
11708	+7931308	4	8
11709	+7931309	4	8
11710	+7931310	4	8
11711	+7931311	4	8
11712	+7931312	4	8
11713	+7931313	4	8
11714	+7931314	4	8
11715	+7931315	4	8
11716	+7931316	4	8
11717	+7931317	4	8
11718	+7931318	4	8
11719	+7931319	4	8
11720	+7931320	4	8
11721	+7931321	4	8
11722	+7931322	4	8
11723	+7931323	4	8
11724	+7931324	4	8
11725	+7931325	4	8
11726	+7931326	4	8
11727	+7931327	4	8
11728	+7931328	4	8
11729	+7931329	4	8
11730	+7931330	4	8
11731	+7931331	4	8
11732	+7931332	4	8
11733	+7931333	4	8
11734	+7931334	4	8
11735	+7931335	4	8
11736	+7931336	4	8
11737	+7931337	4	8
11738	+7931338	4	8
11739	+7931339	4	8
11740	+7931340	4	8
11741	+7931341	4	8
11742	+7931342	4	8
11743	+7931343	4	8
11744	+7931344	4	8
11745	+7931345	4	8
11746	+7931346	4	8
11747	+7931347	4	8
11748	+7931348	4	8
11749	+7931349	4	8
11750	+7931350	4	8
11751	+7931351	4	8
11752	+7931352	4	8
11753	+7931353	4	8
11754	+7931354	4	8
11755	+7931355	4	8
11756	+7931356	4	8
11757	+7931357	4	8
11758	+7931358	4	8
11759	+7931359	4	8
11760	+7931360	4	8
11761	+7931361	4	8
11762	+7931362	4	8
11763	+7931363	4	8
11764	+7931364	4	8
11765	+7931365	4	8
11766	+7931366	4	8
11767	+7931367	4	8
11768	+7931368	4	8
11769	+7931369	4	8
11770	+7931370	4	8
11771	+7931371	4	8
11772	+7931372	4	8
11773	+7931373	4	8
11774	+7931374	4	8
11775	+7931375	4	8
11776	+7931376	4	8
11777	+7931377	4	8
11778	+7931378	4	8
11779	+7931379	4	8
11780	+7931380	4	8
11781	+7931381	4	8
11782	+7931382	4	8
11783	+7931383	4	8
11784	+793140	4	7
11785	+793141	4	7
11786	+793150	4	7
11787	+793151	4	7
11788	+793152	4	7
11789	+7931530	4	8
11790	+7931531	4	8
11791	+7931532	4	8
11792	+7931533	4	8
11793	+7931534	4	8
11794	+7931535	4	8
11795	+7931536	4	8
11796	+7931537	4	8
11797	+7931538	4	8
11798	+7931539	4	8
11799	+7931540	4	8
11800	+7931541	4	8
11801	+7931542	4	8
11802	+7931543	4	8
11803	+7931576	4	8
11804	+7931600	4	8
11805	+7931601	4	8
11806	+7931602	4	8
11807	+7931603	4	8
11808	+7931604	4	8
11809	+7931605	4	8
11810	+7931606	4	8
11811	+7931607	4	8
11812	+7931608	4	8
11813	+7931609	4	8
11814	+7931610	4	8
11815	+7931611	4	8
11816	+7931612	4	8
11817	+7931613	4	8
11818	+7931614	4	8
11819	+7931615	4	8
11820	+7931616	4	8
11821	+793170	4	7
11822	+793180	4	7
11823	+793185	4	7
11824	+7931900	4	8
11825	+7931901	4	8
11826	+7931902	4	8
11827	+7931903	4	8
11828	+7931904	4	8
11829	+7931905	4	8
11830	+7931906	4	8
11831	+7931907	4	8
11832	+7931908	4	8
11833	+7931909	4	8
11834	+7931910	4	8
11835	+7931911	4	8
11836	+793201	4	7
11837	+793205	4	7
11838	+7932060	4	8
11839	+793209	4	7
11840	+7932100	4	8
11841	+793211	4	7
11842	+793212	4	7
11843	+7932200	4	8
11844	+7932201	4	8
11845	+7932203	4	8
11846	+7932207	4	8
11847	+7932209	4	8
11848	+793223	4	7
11849	+793224	4	7
11850	+793225	4	7
11851	+793230	4	7
11852	+793231	4	7
11853	+793232	4	7
11854	+793233	4	7
11855	+7932400	4	8
11856	+7932401	4	8
11857	+7932402	4	8
11858	+7932403	4	8
11859	+7932404	4	8
11860	+7932405	4	8
11861	+7932406	4	8
11862	+7932407	4	8
11863	+7932408	4	8
11864	+7932409	4	8
11865	+7932410	4	8
11866	+7932411	4	8
11867	+7932412	4	8
11868	+7932413	4	8
11869	+7932414	4	8
11870	+7932415	4	8
11871	+7932416	4	8
11872	+7932417	4	8
11873	+7932418	4	8
11874	+7932419	4	8
11875	+7932420	4	8
11876	+7932421	4	8
11877	+7932422	4	8
11878	+7932423	4	8
11879	+7932424	4	8
11880	+7932425	4	8
11881	+7932426	4	8
11882	+7932427	4	8
11883	+7932428	4	8
11884	+7932429	4	8
11885	+7932430	4	8
11886	+7932431	4	8
11887	+7932432	4	8
11888	+7932433	4	8
11889	+7932434	4	8
11890	+7932435	4	8
11891	+7932436	4	8
11892	+7932437	4	8
11893	+7932438	4	8
11894	+7932439	4	8
11895	+7932440	4	8
11896	+793247	4	7
11897	+793248	4	7
11898	+793253	4	7
11899	+793254	4	7
11900	+793255	4	7
11901	+7932560	4	8
11902	+793260	4	7
11903	+793261	4	7
11904	+7932680	4	8
11905	+793284	4	7
11906	+793285	4	7
11907	+793286	4	7
11908	+7933100	4	8
11909	+7933200	4	8
11910	+7933300	4	8
11911	+79333010	4	9
11912	+79333011	4	9
11913	+79333012	4	9
11914	+79333013	4	9
11915	+79333014	4	9
11916	+79333015	4	9
11917	+79333016	4	9
11918	+79333017	4	9
11919	+79333018	4	9
11920	+79333019	4	9
11921	+7933302	4	8
11922	+7933310	4	8
11923	+7933311	4	8
11924	+7933312	4	8
11925	+7933314	4	8
11926	+793333	4	7
11927	+7934100	4	8
11928	+7934401	4	8
11929	+7934431	4	8
11930	+7934441	4	8
11931	+7934461	4	8
11932	+7934471	4	8
11933	+7934476	4	8
11934	+7934481	4	8
11935	+7934491	4	8
11936	+7936600	4	8
11937	+793700	4	7
11938	+793701	4	7
11939	+793702	4	7
11940	+793703	4	7
11941	+793704	4	7
11942	+793705	4	7
11943	+793706	4	7
11944	+793707	4	7
11945	+793708	4	7
11946	+793709	4	7
11947	+7937100	4	8
11948	+7937101	4	8
11949	+7937102	4	8
11950	+7937103	4	8
11951	+7937104	4	8
11952	+7937105	4	8
11953	+7937106	4	8
11954	+7937107	4	8
11955	+7937108	4	8
11956	+7937109	4	8
11957	+793711	4	7
11958	+793712	4	7
11959	+793713	4	7
11960	+793714	4	7
11961	+793715	4	7
11962	+793716	4	7
11963	+793717	4	7
11964	+793718	4	7
11965	+793719	4	7
11966	+793720	4	7
11967	+793721	4	7
11968	+793722	4	7
11969	+793723	4	7
11970	+793724	4	7
11971	+793725	4	7
11972	+793726	4	7
11973	+793727	4	7
11974	+793728	4	7
11975	+793729	4	7
11976	+793730	4	7
11977	+793731	4	7
11978	+793732	4	7
11979	+793733	4	7
11980	+793734	4	7
11981	+793735	4	7
11982	+793736	4	7
11983	+793737	4	7
11984	+793738	4	7
11985	+793739	4	7
11986	+793740	4	7
11987	+793741	4	7
11988	+793742	4	7
11989	+793743	4	7
11990	+793744	4	7
11991	+793745	4	7
11992	+793746	4	7
11993	+793747	4	7
11994	+793748	4	7
11995	+793749	4	7
11996	+7937500	4	8
11997	+7937501	4	8
11998	+7937502	4	8
11999	+7937503	4	8
12000	+7937504	4	8
12001	+7937505	4	8
12002	+7937506	4	8
12003	+7937507	4	8
12004	+7937508	4	8
12005	+7937509	4	8
12006	+793751	4	7
12007	+793752	4	7
12008	+793753	4	7
12009	+793754	4	7
12010	+793755	4	7
12011	+793756	4	7
12012	+793757	4	7
12013	+793758	4	7
12014	+793759	4	7
12015	+7937600	4	8
12016	+7937601	4	8
12017	+7937602	4	8
12018	+7937603	4	8
12019	+7937604	4	8
12020	+7937605	4	8
12021	+7937606	4	8
12022	+7937607	4	8
12023	+7937608	4	8
12024	+7937609	4	8
12025	+793761	4	7
12026	+793762	4	7
12027	+793763	4	7
12028	+793764	4	7
12029	+793765	4	7
12030	+793766	4	7
12031	+793767	4	7
12032	+793768	4	7
12033	+793769	4	7
12034	+7937700	4	8
12035	+7937701	4	8
12036	+7937702	4	8
12037	+7937703	4	8
12038	+7937704	4	8
12039	+7937705	4	8
12040	+7937706	4	8
12041	+7937707	4	8
12042	+7937708	4	8
12043	+7937709	4	8
12044	+7937710	4	8
12045	+7937711	4	8
12046	+7937712	4	8
12047	+7937713	4	8
12048	+7937714	4	8
12049	+7937715	4	8
12050	+7937716	4	8
12051	+7937717	4	8
12052	+7937718	4	8
12053	+7937719	4	8
12054	+7937720	4	8
12055	+7937721	4	8
12056	+7937722	4	8
12057	+7937723	4	8
12058	+7937724	4	8
12059	+7937725	4	8
12060	+7937726	4	8
12061	+7937727	4	8
12062	+7937728	4	8
12063	+7937729	4	8
12064	+7937730	4	8
12065	+7937731	4	8
12066	+7937732	4	8
12067	+7937733	4	8
12068	+7937734	4	8
12069	+7937735	4	8
12070	+7937736	4	8
12071	+7937737	4	8
12072	+7937738	4	8
12073	+7937739	4	8
12074	+7937740	4	8
12075	+7937741	4	8
12076	+7937742	4	8
12077	+7937743	4	8
12078	+7937744	4	8
12079	+7937745	4	8
12080	+7937746	4	8
12081	+7937747	4	8
12082	+7937748	4	8
12083	+7937749	4	8
12084	+7937750	4	8
12085	+7937751	4	8
12086	+7937752	4	8
12087	+7937753	4	8
12088	+7937754	4	8
12089	+7937755	4	8
12090	+7937756	4	8
12091	+7937757	4	8
12092	+7937758	4	8
12093	+7937759	4	8
12094	+7937760	4	8
12095	+7937761	4	8
12096	+7937762	4	8
12097	+7937763	4	8
12098	+7937764	4	8
12099	+7937765	4	8
12100	+7937766	4	8
12101	+7937767	4	8
12102	+7937768	4	8
12103	+7937769	4	8
12104	+793777	4	7
12105	+793778	4	7
12106	+793779	4	7
12107	+793780	4	7
12108	+793781	4	7
12109	+793782	4	7
12110	+793783	4	7
12111	+793784	4	7
12112	+793785	4	7
12113	+793786	4	7
12114	+793787	4	7
12115	+793788	4	7
12116	+793789	4	7
12117	+793790	4	7
12118	+793791	4	7
12119	+793792	4	7
12120	+793793	4	7
12121	+793794	4	7
12122	+793795	4	7
12123	+793796	4	7
12124	+793797	4	7
12125	+793798	4	7
12126	+793799	4	7
12127	+7938000	4	8
12128	+7938001	4	8
12129	+7938002	4	8
12130	+7938003	4	8
12131	+7938004	4	8
12132	+7938025	4	8
12133	+7938026	4	8
12134	+7938027	4	8
12135	+7938028	4	8
12136	+7938075	4	8
12137	+7938076	4	8
12138	+7938077	4	8
12139	+7938078	4	8
12140	+7938079	4	8
12141	+7938080	4	8
12142	+7938081	4	8
12143	+7938082	4	8
12144	+7938100	4	8
12145	+7938101	4	8
12146	+7938102	4	8
12147	+7938103	4	8
12148	+7938104	4	8
12149	+7938105	4	8
12150	+7938106	4	8
12151	+7938107	4	8
12152	+7938108	4	8
12153	+7938109	4	8
12154	+7938110	4	8
12155	+7938111	4	8
12156	+7938112	4	8
12157	+7938113	4	8
12158	+7938114	4	8
12159	+7938115	4	8
12160	+7938116	4	8
12161	+7938117	4	8
12162	+7938118	4	8
12163	+7938119	4	8
12164	+7938120	4	8
12165	+7938121	4	8
12166	+793820	4	7
12167	+7938294	4	8
12168	+7938300	4	8
12169	+7938301	4	8
12170	+7938302	4	8
12171	+7938303	4	8
12172	+7938304	4	8
12173	+7938305	4	8
12174	+7938306	4	8
12175	+7938307	4	8
12176	+7938308	4	8
12177	+7938309	4	8
12178	+7938310	4	8
12179	+7938311	4	8
12180	+7938312	4	8
12181	+7938313	4	8
12182	+7938314	4	8
12183	+7938315	4	8
12184	+7938316	4	8
12185	+7938400	4	8
12186	+7938401	4	8
12187	+7938402	4	8
12188	+7938403	4	8
12189	+7938404	4	8
12190	+7938405	4	8
12191	+7938406	4	8
12192	+7938407	4	8
12193	+7938408	4	8
12194	+7938409	4	8
12195	+7938410	4	8
12196	+7938411	4	8
12197	+7938412	4	8
12198	+7938413	4	8
12199	+7938414	4	8
12200	+7938415	4	8
12201	+7938416	4	8
12202	+7938417	4	8
12203	+7938418	4	8
12204	+7938419	4	8
12205	+7938420	4	8
12206	+7938421	4	8
12207	+7938422	4	8
12208	+7938423	4	8
12209	+7938424	4	8
12210	+7938425	4	8
12211	+7938426	4	8
12212	+7938427	4	8
12213	+7938428	4	8
12214	+7938429	4	8
12215	+7938430	4	8
12216	+7938431	4	8
12217	+7938432	4	8
12218	+7938433	4	8
12219	+7938434	4	8
12220	+7938435	4	8
12221	+7938436	4	8
12222	+7938437	4	8
12223	+7938438	4	8
12224	+7938439	4	8
12225	+7938440	4	8
12226	+7938441	4	8
12227	+7938442	4	8
12228	+7938443	4	8
12229	+7938444	4	8
12230	+7938445	4	8
12231	+7938446	4	8
12232	+7938447	4	8
12233	+7938448	4	8
12234	+7938449	4	8
12235	+7938450	4	8
12236	+7938451	4	8
12237	+7938452	4	8
12238	+7938453	4	8
12239	+7938454	4	8
12240	+7938455	4	8
12241	+7938456	4	8
12242	+7938457	4	8
12243	+7938458	4	8
12244	+7938459	4	8
12245	+7938650	4	8
12246	+7938651	4	8
12247	+7938652	4	8
12248	+7938653	4	8
12249	+7938654	4	8
12250	+7938690	4	8
12251	+7938691	4	8
12252	+7938692	4	8
12253	+7938693	4	8
12254	+7938694	4	8
12255	+7938864	4	8
12256	+7938887	4	8
12257	+7938888	4	8
12258	+7938889	4	8
12259	+7938890	4	8
12260	+7938891	4	8
12261	+7938892	4	8
12262	+7938893	4	8
12263	+7938894	4	8
12264	+7938895	4	8
12265	+7938896	4	8
12266	+7938897	4	8
12267	+7938898	4	8
12268	+7938899	4	8
12269	+7938900	4	8
12270	+7938901	4	8
12271	+7938902	4	8
12272	+7938903	4	8
12273	+7938904	4	8
12274	+7938905	4	8
12275	+7938906	4	8
12276	+7938907	4	8
12277	+7938908	4	8
12278	+7938909	4	8
12279	+7938910	4	8
12280	+7938911	4	8
12281	+7938912	4	8
12282	+7938913	4	8
12283	+7938914	4	8
12284	+7938915	4	8
12285	+79389840	4	9
12286	+79389841	4	9
12287	+79389842	4	9
12288	+79389843	4	9
12289	+79389844	4	9
12290	+79389845	4	9
12291	+79389846	4	9
12292	+79389847	4	9
12293	+79389848	4	9
12294	+79389849	4	9
12295	+79389850	4	9
12296	+79389851	4	9
12297	+79389852	4	9
12298	+79389853	4	9
12299	+79389854	4	9
12300	+79389855	4	9
12301	+79389856	4	9
12302	+79389857	4	9
12303	+79389858	4	9
12304	+79389859	4	9
12305	+79389860	4	9
12306	+79389861	4	9
12307	+79389862	4	9
12308	+79389863	4	9
12309	+79389864	4	9
12310	+79389865	4	9
12311	+79389866	4	9
12312	+79389867	4	9
12313	+79389868	4	9
12314	+79389869	4	9
12315	+79389870	4	9
12316	+79389871	4	9
12317	+793970	4	7
12318	+793971	4	7
12319	+793972	4	7
12320	+793973	4	7
12321	+793974	4	7
12322	+793975	4	7
12323	+79974450	4	9
12324	+79974451	4	9
12325	+79974452	4	9
12326	+79974453	4	9
12327	+79974454	4	9
12328	+79974455	4	9
12329	+79974456	4	9
\.


--
-- Data for Name: template; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY template (id, name, exten) FROM stdin;
3	t3	003
4	t4	001
5	t5	001
6	t6	001
7	t7	001
8	t8	001
9	t9	001
10	t10	001
1	Первый шаблон	001
2	Второй шаблон	002
\.


--
-- Data for Name: template_actions; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY template_actions (id, template_id, result_id, continue, pause, info, warning, npause) FROM stdin;
33	3	5	t	01:00:00	t	f	01:00:00
34	3	6	t	01:00:00	t	f	01:00:00
35	3	7	t	01:00:00	t	f	01:00:00
36	3	8	t	01:00:00	t	f	01:00:00
37	3	9	t	01:00:00	t	f	01:00:00
38	3	10	t	01:00:00	t	f	01:00:00
39	3	11	t	01:00:00	t	f	01:00:00
40	3	12	t	01:00:00	t	f	01:00:00
41	3	13	t	01:00:00	t	f	01:00:00
42	3	14	t	01:00:00	t	f	01:00:00
43	3	15	t	01:00:00	t	f	01:00:00
44	3	16	t	01:00:00	t	f	01:00:00
45	3	17	t	01:00:00	t	f	01:00:00
46	3	18	t	01:00:00	t	f	01:00:00
47	3	1	t	01:00:00	t	f	01:00:00
48	3	2	t	01:00:00	t	f	01:00:00
49	4	5	t	01:00:00	t	f	01:00:00
50	4	6	t	01:00:00	t	f	01:00:00
51	4	7	t	01:00:00	t	f	01:00:00
52	4	8	t	01:00:00	t	f	01:00:00
53	4	9	t	01:00:00	t	f	01:00:00
54	4	10	t	01:00:00	t	f	01:00:00
55	4	11	t	01:00:00	t	f	01:00:00
56	4	12	t	01:00:00	t	f	01:00:00
57	4	13	t	01:00:00	t	f	01:00:00
58	4	14	t	01:00:00	t	f	01:00:00
59	4	15	t	01:00:00	t	f	01:00:00
60	4	16	t	01:00:00	t	f	01:00:00
61	4	17	t	01:00:00	t	f	01:00:00
62	4	18	t	01:00:00	t	f	01:00:00
63	4	1	t	01:00:00	t	f	01:00:00
64	4	2	t	01:00:00	t	f	01:00:00
65	5	5	t	01:00:00	t	f	01:00:00
66	5	6	t	01:00:00	t	f	01:00:00
67	5	7	t	01:00:00	t	f	01:00:00
68	5	8	t	01:00:00	t	f	01:00:00
69	5	9	t	01:00:00	t	f	01:00:00
70	5	10	t	01:00:00	t	f	01:00:00
71	5	11	t	01:00:00	t	f	01:00:00
72	5	12	t	01:00:00	t	f	01:00:00
73	5	13	t	01:00:00	t	f	01:00:00
74	5	14	t	01:00:00	t	f	01:00:00
75	5	15	t	01:00:00	t	f	01:00:00
76	5	16	t	01:00:00	t	f	01:00:00
77	5	17	t	01:00:00	t	f	01:00:00
78	5	18	t	01:00:00	t	f	01:00:00
79	5	1	t	01:00:00	t	f	01:00:00
80	5	2	t	01:00:00	t	f	01:00:00
81	6	5	t	01:00:00	t	f	01:00:00
82	6	6	t	01:00:00	t	f	01:00:00
83	6	7	t	01:00:00	t	f	01:00:00
84	6	8	t	01:00:00	t	f	01:00:00
85	6	9	t	01:00:00	t	f	01:00:00
86	6	10	t	01:00:00	t	f	01:00:00
87	6	11	t	01:00:00	t	f	01:00:00
88	6	12	t	01:00:00	t	f	01:00:00
89	6	13	t	01:00:00	t	f	01:00:00
90	6	14	t	01:00:00	t	f	01:00:00
91	6	15	t	01:00:00	t	f	01:00:00
92	6	16	t	01:00:00	t	f	01:00:00
93	6	17	t	01:00:00	t	f	01:00:00
94	6	18	t	01:00:00	t	f	01:00:00
95	6	1	t	01:00:00	t	f	01:00:00
96	6	2	t	01:00:00	t	f	01:00:00
97	7	5	t	01:00:00	t	f	01:00:00
1	1	5	t	01:00:00	t	f	01:00:00
2	1	6	t	01:00:00	t	f	01:00:00
19	2	7	t	1 day	t	f	01:00:00
20	2	8	t	01:00:01	t	t	01:00:02
21	2	9	t	3 days	t	t	01:00:00
22	2	10	t	7 days	t	t	01:00:00
24	2	12	t	1 day	t	f	01:00:00
25	2	13	t	1 day	t	f	01:00:00
26	2	14	t	1 day	t	f	01:00:00
28	2	16	t	1 day	t	f	01:00:00
29	2	17	t	1 day	t	f	01:00:00
30	2	18	t	1 day	t	f	01:00:00
31	2	1	t	00:01:00	t	f	00:01:00
32	2	2	t	00:01:00	f	f	00:30:00
18	2	6	t	01:00:00	f	f	01:00:00
3	1	7	t	01:00:00	t	f	01:00:00
4	1	8	t	01:00:00	t	f	01:00:00
5	1	9	t	01:00:00	t	f	01:00:00
6	1	10	t	01:00:00	t	f	01:00:00
7	1	11	t	01:00:00	t	f	01:00:00
8	1	12	t	01:00:00	t	f	01:00:00
9	1	13	t	01:00:00	t	f	01:00:00
10	1	14	t	01:00:00	t	f	01:00:00
11	1	15	t	01:00:00	t	f	01:00:00
13	1	17	t	01:00:00	t	f	01:00:00
14	1	18	t	01:00:00	t	f	01:00:00
15	1	1	t	01:00:00	t	f	01:00:00
16	1	2	t	01:00:00	t	f	01:00:00
98	7	6	t	01:00:00	t	f	01:00:00
99	7	7	t	01:00:00	t	f	01:00:00
100	7	8	t	01:00:00	t	f	01:00:00
101	7	9	t	01:00:00	t	f	01:00:00
102	7	10	t	01:00:00	t	f	01:00:00
103	7	11	t	01:00:00	t	f	01:00:00
104	7	12	t	01:00:00	t	f	01:00:00
105	7	13	t	01:00:00	t	f	01:00:00
106	7	14	t	01:00:00	t	f	01:00:00
107	7	15	t	01:00:00	t	f	01:00:00
108	7	16	t	01:00:00	t	f	01:00:00
109	7	17	t	01:00:00	t	f	01:00:00
110	7	18	t	01:00:00	t	f	01:00:00
111	7	1	t	01:00:00	t	f	01:00:00
112	7	2	t	01:00:00	t	f	01:00:00
113	8	5	t	01:00:00	t	f	01:00:00
114	8	6	t	01:00:00	t	f	01:00:00
115	8	7	t	01:00:00	t	f	01:00:00
116	8	8	t	01:00:00	t	f	01:00:00
117	8	9	t	01:00:00	t	f	01:00:00
118	8	10	t	01:00:00	t	f	01:00:00
119	8	11	t	01:00:00	t	f	01:00:00
120	8	12	t	01:00:00	t	f	01:00:00
121	8	13	t	01:00:00	t	f	01:00:00
122	8	14	t	01:00:00	t	f	01:00:00
123	8	15	t	01:00:00	t	f	01:00:00
124	8	16	t	01:00:00	t	f	01:00:00
125	8	17	t	01:00:00	t	f	01:00:00
126	8	18	t	01:00:00	t	f	01:00:00
127	8	1	t	01:00:00	t	f	01:00:00
128	8	2	t	01:00:00	t	f	01:00:00
129	9	5	t	01:00:00	t	f	01:00:00
130	9	6	t	01:00:00	t	f	01:00:00
131	9	7	t	01:00:00	t	f	01:00:00
132	9	8	t	01:00:00	t	f	01:00:00
133	9	9	t	01:00:00	t	f	01:00:00
134	9	10	t	01:00:00	t	f	01:00:00
135	9	11	t	01:00:00	t	f	01:00:00
136	9	12	t	01:00:00	t	f	01:00:00
137	9	13	t	01:00:00	t	f	01:00:00
138	9	14	t	01:00:00	t	f	01:00:00
139	9	15	t	01:00:00	t	f	01:00:00
140	9	16	t	01:00:00	t	f	01:00:00
141	9	17	t	01:00:00	t	f	01:00:00
142	9	18	t	01:00:00	t	f	01:00:00
143	9	1	t	01:00:00	t	f	01:00:00
144	9	2	t	01:00:00	t	f	01:00:00
145	10	5	t	01:00:00	t	f	01:00:00
146	10	6	t	01:00:00	t	f	01:00:00
147	10	7	t	01:00:00	t	f	01:00:00
148	10	8	t	01:00:00	t	f	01:00:00
149	10	9	t	01:00:00	t	f	01:00:00
150	10	10	t	01:00:00	t	f	01:00:00
151	10	11	t	01:00:00	t	f	01:00:00
152	10	12	t	01:00:00	t	f	01:00:00
153	10	13	t	01:00:00	t	f	01:00:00
154	10	14	t	01:00:00	t	f	01:00:00
155	10	15	t	01:00:00	t	f	01:00:00
156	10	16	t	01:00:00	t	f	01:00:00
157	10	17	t	01:00:00	t	f	01:00:00
158	10	18	t	01:00:00	t	f	01:00:00
159	10	1	t	01:00:00	t	f	01:00:00
160	10	2	t	01:00:00	t	f	01:00:00
12	1	16	t	01:00:00	t	f	01:00:00
17	2	5	t	1 day	t	f	01:00:00
23	2	11	t	1 day	t	f	01:00:00
161	3	19	t	00:05:00	\N	\N	00:05:00
162	4	19	t	00:05:00	\N	\N	00:05:00
163	5	19	t	00:05:00	\N	\N	00:05:00
164	6	19	t	00:05:00	\N	\N	00:05:00
165	7	19	t	00:05:00	\N	\N	00:05:00
166	8	19	t	00:05:00	\N	\N	00:05:00
167	9	19	t	00:05:00	\N	\N	00:05:00
168	10	19	t	00:05:00	\N	\N	00:05:00
170	1	19	t	00:05:00	\N	\N	00:05:00
171	3	20	t	\N	\N	\N	01:00:00
172	4	20	t	\N	\N	\N	01:00:00
173	5	20	t	\N	\N	\N	01:00:00
174	6	20	t	\N	\N	\N	01:00:00
175	7	20	t	\N	\N	\N	01:00:00
176	8	20	t	\N	\N	\N	01:00:00
177	9	20	t	\N	\N	\N	01:00:00
178	10	20	t	\N	\N	\N	01:00:00
179	1	20	t	\N	\N	\N	01:00:00
27	2	15	t	1 day	t	f	01:00:00
169	2	19	t	00:01:00	f	f	00:05:00
180	2	20	t	00:01:00	f	f	01:00:00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY users (id, username, password, email, fname, lname, mname, secq, seca, smsnumber, allowadvert, enabled, comments, sex, birthday, longid, sms) FROM stdin;
3	odminzz	321	test4444@yandex.net	Владимир	Goncharov		\N	\N		t	t	\N	t	\N	\N	
4	test	test		test	test		\N	\N	\N	t	t	\N	t	\N	\N	
\.


--
-- Name: call_result_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY call_result
    ADD CONSTRAINT call_result_pkey PRIMARY KEY (id);


--
-- Name: group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (id);


--
-- Name: job_log_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY job_log
    ADD CONSTRAINT job_log_pkey PRIMARY KEY (id);


--
-- Name: job_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY job_numbers
    ADD CONSTRAINT job_numbers_pkey PRIMARY KEY (id);


--
-- Name: job_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id);


--
-- Name: modem_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY modem_groups
    ADD CONSTRAINT modem_groups_pkey PRIMARY KEY (id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: route_pattern_key; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_pattern_key UNIQUE (pattern);


--
-- Name: route_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_pkey PRIMARY KEY (id);


--
-- Name: template_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY template_actions
    ADD CONSTRAINT template_actions_pkey PRIMARY KEY (id);


--
-- Name: template_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY template
    ADD CONSTRAINT template_pkey PRIMARY KEY (id);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_longid_key; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_longid_key UNIQUE (longid);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_username_key; Type: CONSTRAINT; Schema: public; Owner: pgsql; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: fki_group_member_fk_grpid; Type: INDEX; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE INDEX fki_group_member_fk_grpid ON group_members USING btree (group_id);


--
-- Name: fki_route_fk_group_id; Type: INDEX; Schema: public; Owner: pgsql; Tablespace: 
--

CREATE INDEX fki_route_fk_group_id ON route USING btree (group_id);


--
-- Name: group_member_fk_grpid; Type: FK CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_member_fk_grpid FOREIGN KEY (group_id) REFERENCES modem_groups(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: job_log_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY job_log
    ADD CONSTRAINT job_log_job_id_fkey FOREIGN KEY (job_id) REFERENCES job(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: job_log_number_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY job_log
    ADD CONSTRAINT job_log_number_id_fkey FOREIGN KEY (number_id) REFERENCES job_numbers(id);


--
-- Name: job_numbers_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY job_numbers
    ADD CONSTRAINT job_numbers_job_id_fkey FOREIGN KEY (job_id) REFERENCES job(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: job_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY job
    ADD CONSTRAINT job_template_id_fkey FOREIGN KEY (template_id) REFERENCES template(id);


--
-- Name: route_fk_group_id; Type: FK CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY route
    ADD CONSTRAINT route_fk_group_id FOREIGN KEY (group_id) REFERENCES modem_groups(id);


--
-- Name: template_actions_result_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY template_actions
    ADD CONSTRAINT template_actions_result_id_fkey FOREIGN KEY (result_id) REFERENCES call_result(id);


--
-- Name: template_actions_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pgsql
--

ALTER TABLE ONLY template_actions
    ADD CONSTRAINT template_actions_template_id_fkey FOREIGN KEY (template_id) REFERENCES template(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: pgsql
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM pgsql;
GRANT ALL ON SCHEMA public TO pgsql;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

