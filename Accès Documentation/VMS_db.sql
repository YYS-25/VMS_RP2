--
-- PostgreSQL database dump
--

-- Table Name: yesh_solo

\restrict 0IfqT25tUIRXAb56T5AAmzMRopAuW1dvqwCASYeZSOs1RhLaXC46jrtM8IqPrfM

-- Dumped from database version 16.13
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: yesh
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO yesh;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: branch; Type: TABLE; Schema: public; Owner: yesh_one
--

CREATE TABLE public.branch (
    branch_id integer NOT NULL,
    location character varying(255) NOT NULL,
    responsible_user character varying(50) NOT NULL,
    ref_company integer,
    address_branch character varying(255),
    phone_branch character varying(50)
);


ALTER TABLE public.branch OWNER TO yesh_one;

--
-- Name: branch_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: yesh_one
--

CREATE SEQUENCE public.branch_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.branch_branch_id_seq OWNER TO yesh_one;

--
-- Name: branch_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yesh_one
--

ALTER SEQUENCE public.branch_branch_id_seq OWNED BY public.branch.branch_id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: yesh_one
--

CREATE TABLE public.clients (
    ref_client integer NOT NULL,
    nom_client character varying(100) NOT NULL,
    email_client character varying(100) NOT NULL,
    address_client character varying(255),
    phone_client character varying(30),
    active boolean
);


ALTER TABLE public.clients OWNER TO yesh_one;

--
-- Name: clients_ref_client_seq; Type: SEQUENCE; Schema: public; Owner: yesh_one
--

CREATE SEQUENCE public.clients_ref_client_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_ref_client_seq OWNER TO yesh_one;

--
-- Name: clients_ref_client_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yesh_one
--

ALTER SEQUENCE public.clients_ref_client_seq OWNED BY public.clients.ref_client;


--
-- Name: company; Type: TABLE; Schema: public; Owner: yesh_one
--

CREATE TABLE public.company (
    company_id integer NOT NULL,
    name_company character varying(255) NOT NULL,
    email_company character varying(255),
    industry_type character varying(100)
);


ALTER TABLE public.company OWNER TO yesh_one;

--
-- Name: company_company_id_seq; Type: SEQUENCE; Schema: public; Owner: yesh_one
--

CREATE SEQUENCE public.company_company_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.company_company_id_seq OWNER TO yesh_one;

--
-- Name: company_company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yesh_one
--

ALTER SEQUENCE public.company_company_id_seq OWNED BY public.company.company_id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: yesh_one
--

CREATE TABLE public.requests (
    ref_request integer NOT NULL,
    creation_date date NOT NULL,
    num_voucher integer,
    status character varying(50),
    payment character varying(50),
    date_payment date,
    ref_payment integer,
    date_approval date,
    duration_voucher integer,
    ref_client integer NOT NULL,
    processed_by character varying(50),
    approved_by character varying(50),
    validated_by character varying(50),
    proof_path character varying(500),
    unit_value character varying(50)
);


ALTER TABLE public.requests OWNER TO yesh_one;

--
-- Name: requests_ref_request_seq; Type: SEQUENCE; Schema: public; Owner: yesh_one
--

CREATE SEQUENCE public.requests_ref_request_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requests_ref_request_seq OWNER TO yesh_one;

--
-- Name: requests_ref_request_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yesh_one
--

ALTER SEQUENCE public.requests_ref_request_seq OWNED BY public.requests.ref_request;


--
-- Name: users; Type: TABLE; Schema: public; Owner: yesh_one
--

CREATE TABLE public.users (
    username character varying(50) NOT NULL,
    first_name_user character varying(50) NOT NULL,
    last_name_user character varying(50) NOT NULL,
    email_user character varying(100) NOT NULL,
    role character varying(50),
    password character varying(255) NOT NULL,
    ddl character varying(100),
    titre character varying(100),
    status character varying(50)
);


ALTER TABLE public.users OWNER TO yesh_one;

--
-- Name: vouchers; Type: TABLE; Schema: public; Owner: yesh_one
--

CREATE TABLE public.vouchers (
    ref_voucher integer NOT NULL,
    val_voucher character varying NOT NULL,
    init_date date,
    expiry_date date,
    status_voucher character varying(50),
    date_redeemed date,
    bearer character varying(100),
    ref_request integer NOT NULL,
    redeemed_by character varying(50),
    redeemed_branch integer
);


ALTER TABLE public.vouchers OWNER TO yesh_one;

--
-- Name: vouchers_ref_voucher_seq; Type: SEQUENCE; Schema: public; Owner: yesh_one
--

CREATE SEQUENCE public.vouchers_ref_voucher_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vouchers_ref_voucher_seq OWNER TO yesh_one;

--
-- Name: vouchers_ref_voucher_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yesh_one
--

ALTER SEQUENCE public.vouchers_ref_voucher_seq OWNED BY public.vouchers.ref_voucher;


--
-- Name: branch branch_id; Type: DEFAULT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.branch ALTER COLUMN branch_id SET DEFAULT nextval('public.branch_branch_id_seq'::regclass);


--
-- Name: clients ref_client; Type: DEFAULT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.clients ALTER COLUMN ref_client SET DEFAULT nextval('public.clients_ref_client_seq'::regclass);


--
-- Name: company company_id; Type: DEFAULT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.company ALTER COLUMN company_id SET DEFAULT nextval('public.company_company_id_seq'::regclass);


--
-- Name: requests ref_request; Type: DEFAULT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.requests ALTER COLUMN ref_request SET DEFAULT nextval('public.requests_ref_request_seq'::regclass);


--
-- Name: vouchers ref_voucher; Type: DEFAULT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.vouchers ALTER COLUMN ref_voucher SET DEFAULT nextval('public.vouchers_ref_voucher_seq'::regclass);


--
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

COPY public.branch (branch_id, location, responsible_user, ref_company, address_branch, phone_branch) FROM stdin;
1	Home Office	Test_Admin	1	\N	\N
2	Quicksilver Caudan	Edith.D	2	Caudan, Port Louis	620 6041
3	Artisan Solferino	Matt.O	1	Solferino	760 4026
5	Maurishop Vacoas	Raj.P	4	42 Rue de la Paix, Vacoas	+230 696 5151
6	Logistique Ocean Port-Louis	Sophie.L	5	15 Rue Labourdonais, Port-Louis	+230 212 5050
7	Banque Maurice Quatre-Bornes	Amir.K	6	88 Rue Royal, Quatre-Bornes	+230 464 5252
8	Sante Plus Curepipe	Yasmine.M	7	12 Rue Sir William Newton, Curepipe	+230 675 5353
9	Energie Verte Beau-Bassin	Jean.D	8	Zone Industrielle Côte d'Or, Beau-Bassin	+230 696 5454
10	Digital Studio Rose-Hill	Priya.S	9	33 Rue Desforges, Rose-Hill	+230 465 5555
11	Prime Manufacturing Moka	Luc.B	10	99 Chemin Grenier, Moka	+230 696 5656
12	Akademi Education Quatre-Bornes	Nina.C	11	7 Rue Dr Bunch, Quatre-Bornes	+230 212 5757
4	TechWorld	Test_Superuser	3	Trianon	456 9765
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

COPY public.clients (ref_client, nom_client, email_client, address_client, phone_client, active) FROM stdin;
22	Ernst & Young Mauritius	site-supercar@alwaysdata.net	Level 9, Tower 1, NeXTeracom, Ebene, Mauritius	+230 200 0004	t
2	Jimmy	jim@mail.com	Vacoas	+230 6507919	t
3	Sam	sam@mail.com	Washington DC	+1 979 5465 2100	f
19	Deloitte Mauritius	deloitte.mauritius@test.com	7th Floor, One Cathedral Square, Port Louis, Mauritius	+230 200 0001	t
20	PwC Mauritius	pwc.mauritius@test.com	18 CyberCity, Ebene, Mauritius	+230 200 0002	t
23	BDO Mauritius	bdo.mauritius@test.com	10 Frere Felix de Valois Street, Port Louis, Mauritius	+230 200 0005	t
24	Grant Thornton Mauritius	grant.thornton.mauritius@test.com	The Axis, 26 Cybercity, Ebene, Mauritius	+230 200 0006	t
25	Deloitte UK	deloitte.uk@test.com	1 New Street Square, London, UK	+44 200 000 0007	t
26	PwC UK	pwc.uk@test.com	1 Embankment Place, London, UK	+44 200 000 0008	t
27	KPMG UK	kpmg.uk@test.com	15 Canada Square, Canary Wharf, London, UK	+44 200 000 0009	t
28	McKinsey & Company UK	mckinsey.uk@test.com	1 Jermyn Street, London, UK	+44 200 000 0010	t
29	Boston Consulting Group UK	bcg.uk@test.com	1 Curzon Street, London, UK	+44 200 000 0011	t
30	Bain & Company London	bain.london@test.com	40 Strand, London, UK	+44 200 000 0012	t
31	McKinsey & Company USA	mckinsey.usa@test.com	711 3rd Avenue, New York, NY, USA	+1 200 000 0013	t
32	Boston Consulting Group USA	bcg.usa@test.com	200 Pier 4 Blvd, Boston, MA, USA	+1 200 000 0014	t
33	Accenture USA	accenture.usa@test.com	161 N Clark Street, Chicago, IL, USA	+1 200 000 0015	t
34	Deloitte USA	deloitte.usa@test.com	30 Rockefeller Plaza, New York, NY, USA	+1 200 000 0016	t
35	Oliver Wyman USA	oliver.wyman.usa@test.com	1166 Avenue of the Americas, New York, NY, USA	+1 200 000 0017	t
36	Alteo Advisory Mauritius	alteo.advisory@mail.local	Beau Plan, Pamplemousses, Mauritius	+230 200 0018	f
37	Axis Fiduciary Mauritius	axis.fiduciary@mail.local	Ebene Skies, Ebene, Mauritius	+230 200 0019	t
40	Trident Trust Mauritius	trident.trust@mail.local	Ebene Cybercity, Mauritius	+230 200 0022	f
38	Vistra Mauritius	vistra.mauritius@mail.local	IFS Court, Bank Street, CyberCity, Ebene, Mauritius	+230 200 0020	t
39	Intertrust Mauritius	intertrust.mauritius@mail.local	Level 3, Alexander House, Ebene, Mauritius	+230 200 0021	t
41	Apex Group Mauritius	apex.group.mauritius@mail.local	Level 2, Dias Pier Building, Le Caudan, Port Louis	+230 200 0023	t
42	Mazars Mauritius	mazars.mauritius@mail.local	Les Cascades Building, Edith Cavell Street, Port Louis	+230 200 0024	t
21	KPMG Mauritius	kpmg.mauritius@test.com	Mill Street, Port Louis, Mauritius	+230 200 0003	f
\.


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

COPY public.company (company_id, name_company, email_company, industry_type) FROM stdin;
1	Artisans & Co	artisan@mail.com	Foods & Drinks
2	Apparels Corp	apparel@mail.com	Clothing
3	Technopholia	techpholia@mail.com	Technology
4	Maurishop	contact@maurishop.mu	Retail
5	Logistique Ocean	info@logistiqueocean.mu	Logistics
6	Banque Maurice	support@banquemaurice.mu	Banking
7	Sante Plus	hello@santeplus.mu	Healthcare
8	Energie Verte	sales@energieverte.mu	Energy
9	Digital Studio	team@digitalstudio.mu	Marketing
10	Prime Manufacturing	contact@primemfg.mu	Manufacturing
11	Akademi Education	info@akademi.mu	Education
\.


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

COPY public.requests (ref_request, creation_date, num_voucher, status, payment, date_payment, ref_payment, date_approval, duration_voucher, ref_client, processed_by, approved_by, validated_by, proof_path, unit_value) FROM stdin;
1	2025-12-07	5	CREATED	\N	\N	\N	\N	0	2	\N	\N	\N	\N	\N
12	2026-04-06	20	CREATED	\N	\N	\N	\N	180	19	Test_Superuser	\N	\N	\N	500
3	2026-04-05	100	APPROVED	validated	2026-04-05	\N	2026-04-05	180	22	Test_Superuser	Test_Superuser	\N	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\Culture_Managériale_BTS_1ere_année_complet.pdf	\N
11	2026-04-06	10	VALIDATED	validated	2026-04-06	\N	2026-04-06	180	19	Test_Superuser	Test_Superuser	Test_Superuser	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\EXO_1.pdf	5000
18	2026-04-06	10	VALIDATED	validated	2026-04-06	\N	2026-04-06	365	27	Test_Superuser	Ajay.V	Ajay.V	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	500
13	2026-04-06	20	VALIDATED	validated	2026-04-06	\N	2026-04-06	60	23	Test_Superuser	Test_Superuser	Test_Superuser	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\EXO_1.pdf	2000
5	2026-04-05	75	VALIDATED	validated	2026-04-05	\N	2026-04-05	365	22	Test_Superuser	Test_Approver	Test_Approver	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	990
6	2026-04-05	10	VALIDATED	validated	2026-04-05	\N	2026-04-05	365	22	Test_Accountant	Test_Approver	Test_Approver	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	1000
14	2026-04-06	10	VALIDATED	validated	2026-04-06	\N	2026-04-06	90	23	Test_Superuser	Test_Superuser	Test_Superuser	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	500
7	2026-04-05	5	VALIDATED	validated	2026-04-05	\N	2026-04-05	30	22	Test_Superuser	Test_Superuser	Test_Superuser	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	2500
8	2026-04-06	10	VALIDATED	validated	2026-04-06	\N	2026-04-06	60	22	Test_Accountant	Test_Approver	Test_Approver	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	1000
4	2026-04-05	200	VALIDATED	validated	2026-04-05	\N	2026-04-06	30	22	Test_Superuser	Test_Superuser	Test_Superuser	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	500
15	2026-04-06	5	APPROVED	validated	2026-04-06	\N	2026-04-06	365	24	Test_Superuser	Test_Superuser	Test_Superuser	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	1000
9	2026-04-06	25	VALIDATED	validated	2026-04-06	\N	2026-04-06	90	33	Test_Superuser	Test_Superuser	Test_Superuser	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\EXO_1.pdf	2000
10	2026-04-06	10	VALIDATED	validated	2026-04-06	\N	2026-04-06	30	23	Test_Superuser	Test_Superuser	Test_Superuser	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\EXO_1.pdf	500
16	2026-04-06	5	VALIDATED	validated	2026-04-06	\N	2026-04-06	365	24	Test_Superuser	Test_Superuser	Test_Superuser	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	5000
17	2026-04-06	5	VALIDATED	validated	2026-04-06	\N	2026-04-06	270	27	Test_Superuser	Ajay.V	Ajay.V	C:\\Users\\yeshn\\OneDrive - MCCI Business School Ltd\\Documents\\php.pdf	1000
19	2026-04-20	50	VALIDATED	validated	2026-04-20	\N	2026-04-20	180	19	Test_Accountant	Test_Approver	Test_Approver	C:\\Users\\yeshn\\Downloads\\PreuvePayment.pdf	500
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

COPY public.users (username, first_name_user, last_name_user, email_user, role, password, ddl, titre, status) FROM stdin;
Matt.O	Mathieu	Opman	matt@mail.com	Supervisor	12345		Supervisor	Active
Edith.D	Edith	Dave	edith@mail.com	Supervisor	12345		Supervisor_Quicksilver	Active
Test_Accountant	Bruno	Accountant_Surname	v.managery+accountant@gmail.com	Accountant	12345		Accountant	Active
Test_Admin	Admin	Admin_Surname	v.managery+admin@gmail.com	Admin	12345		Admin	Active
Test_Approver	Apparadu	Approver_Surname	v.managery+approver@gmail.com	Approver	14235		Approver	Active
Test_Superuser	Supergo	Test_Surname	v.managery+superuser@gmail.com	Superuser	123789		Superuser	Active
Raj.P	Raj	Patel	raj.patel@mail.com	Supervisor	12345		Supervisor_Maurishop	Active
Sophie.L	Sophie	Laurent	sophie.laurent@mail.com	Supervisor	12345		Supervisor_Logistique	Active
Amir.K	Amir	Koonjul	amir.koonjul@mail.com	Supervisor	12345		Supervisor_Banque	Active
Yasmine.M	Yasmine	Mohamed	yasmine.mohamed@mail.com	Supervisor	12345		Supervisor_Sante	Active
Jean.D	Jean	Durand	jean.durand@mail.com	Supervisor	12345		Supervisor_Energie	Active
Priya.S	Priya	Sharma	priya.sharma@mail.com	Supervisor	12345		Supervisor_Digital	Active
Luc.B	Luc	Benoit	luc.benoit@mail.com	Supervisor	12345		Supervisor_Prime	Active
Nina.C	Nina	Cools	nina.cools@mail.com	Supervisor	12345		Supervisor_Akademi	Active
Gigs.B	Gigsby	Butcher	gigs@mail.com	Supervisor	12345		Supervisor_Techworld	Active
Ajay.V	Ajay	Valingum	v.managery+app.ajay@gmail.com	Approver	12345		Approver	Active
\.


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

COPY public.vouchers (ref_voucher, val_voucher, init_date, expiry_date, status_voucher, date_redeemed, bearer, ref_request, redeemed_by, redeemed_branch) FROM stdin;
1	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
2	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
3	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
4	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
5	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
6	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
7	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
8	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
9	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
10	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
11	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
12	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
13	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
14	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
15	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
16	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
17	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
18	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
19	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
20	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
21	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
22	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
23	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
24	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
25	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
26	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
27	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
28	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
29	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
30	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
31	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
32	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
33	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
34	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
35	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
36	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
37	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
38	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
39	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
40	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
41	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
42	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
43	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
44	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
45	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
46	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
47	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
48	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
49	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
50	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
51	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
52	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
53	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
54	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
55	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
56	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
57	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
58	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
59	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
60	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
61	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
62	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
63	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
64	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
65	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
66	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
67	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
68	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
69	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
70	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
71	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
72	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
73	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
74	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
75	990	2026-04-05	2027-04-05	active	\N	\N	5	\N	\N
76	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
77	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
78	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
79	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
80	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
81	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
82	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
83	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
84	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
85	1000	2026-04-05	2027-04-05	active	\N	\N	6	\N	\N
86	2500	2026-04-05	2026-05-05	active	\N	\N	7	\N	\N
87	2500	2026-04-05	2026-05-05	active	\N	\N	7	\N	\N
88	2500	2026-04-05	2026-05-05	active	\N	\N	7	\N	\N
89	2500	2026-04-05	2026-05-05	active	\N	\N	7	\N	\N
90	2500	2026-04-05	2026-05-05	active	\N	\N	7	\N	\N
91	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
92	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
93	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
94	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
95	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
96	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
97	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
98	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
99	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
100	1000	2026-04-06	2026-06-05	active	\N	\N	8	\N	\N
101	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
102	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
103	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
104	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
105	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
106	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
107	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
108	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
109	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
110	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
111	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
112	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
113	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
114	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
115	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
116	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
117	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
118	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
119	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
120	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
121	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
122	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
123	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
124	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
125	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
126	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
127	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
128	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
129	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
130	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
131	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
132	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
133	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
134	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
135	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
136	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
137	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
138	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
139	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
141	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
142	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
143	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
144	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
145	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
146	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
147	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
148	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
149	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
151	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
152	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
153	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
154	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
155	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
156	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
157	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
158	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
159	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
160	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
161	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
162	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
163	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
164	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
165	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
166	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
167	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
168	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
169	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
170	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
171	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
172	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
173	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
174	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
175	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
176	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
177	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
178	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
179	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
180	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
181	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
182	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
183	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
184	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
185	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
186	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
187	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
188	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
189	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
190	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
191	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
192	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
193	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
194	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
195	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
196	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
197	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
198	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
199	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
200	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
201	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
202	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
203	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
204	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
205	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
206	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
207	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
208	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
209	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
210	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
211	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
212	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
213	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
214	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
215	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
216	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
217	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
218	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
219	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
220	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
221	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
222	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
223	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
224	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
225	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
226	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
227	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
228	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
229	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
230	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
231	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
232	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
233	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
234	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
235	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
236	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
237	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
238	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
239	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
240	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
241	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
242	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
243	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
244	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
245	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
246	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
247	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
248	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
249	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
250	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
251	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
252	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
253	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
254	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
255	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
256	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
257	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
258	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
259	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
260	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
261	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
262	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
263	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
264	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
265	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
266	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
267	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
268	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
269	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
270	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
271	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
272	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
273	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
274	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
275	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
276	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
277	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
278	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
279	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
280	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
281	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
282	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
283	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
284	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
285	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
286	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
287	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
288	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
289	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
290	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
291	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
292	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
293	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
294	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
295	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
296	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
297	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
298	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
299	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
300	500	2026-04-06	2026-05-06	active	\N	\N	4	\N	\N
301	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
302	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
303	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
304	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
305	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
306	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
307	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
308	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
309	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
310	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
311	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
312	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
313	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
314	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
315	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
316	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
317	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
318	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
319	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
320	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
321	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
322	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
323	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
324	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
325	2000	2026-04-06	2026-07-05	active	\N	\N	9	\N	\N
326	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
327	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
328	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
329	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
330	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
331	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
332	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
333	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
334	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
335	500	2026-04-06	2026-05-06	active	\N	\N	10	\N	\N
336	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
337	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
338	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
339	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
340	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
341	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
342	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
343	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
344	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
345	5000	2026-04-06	2026-10-03	active	\N	\N	11	\N	\N
346	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
347	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
348	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
349	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
350	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
351	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
352	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
353	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
354	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
355	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
356	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
357	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
358	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
359	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
360	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
361	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
362	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
363	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
364	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
365	2000	2026-04-06	2026-06-05	active	\N	\N	13	\N	\N
366	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
367	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
368	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
369	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
370	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
371	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
372	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
373	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
374	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
375	500	2026-04-06	2026-07-05	active	\N	\N	14	\N	\N
376	1000	2026-04-06	2027-04-06	active	\N	\N	15	\N	\N
377	1000	2026-04-06	2027-04-06	active	\N	\N	15	\N	\N
378	1000	2026-04-06	2027-04-06	active	\N	\N	15	\N	\N
379	1000	2026-04-06	2027-04-06	active	\N	\N	15	\N	\N
380	1000	2026-04-06	2027-04-06	active	\N	\N	15	\N	\N
381	5000	2026-04-06	2027-04-06	active	\N	\N	16	\N	\N
382	5000	2026-04-06	2027-04-06	active	\N	\N	16	\N	\N
383	5000	2026-04-06	2027-04-06	active	\N	\N	16	\N	\N
384	5000	2026-04-06	2027-04-06	active	\N	\N	16	\N	\N
385	5000	2026-04-06	2027-04-06	active	\N	\N	16	\N	\N
386	1000	2026-04-06	2027-01-01	active	\N	\N	17	\N	\N
387	1000	2026-04-06	2027-01-01	active	\N	\N	17	\N	\N
388	1000	2026-04-06	2027-01-01	active	\N	\N	17	\N	\N
389	1000	2026-04-06	2027-01-01	active	\N	\N	17	\N	\N
390	1000	2026-04-06	2027-01-01	active	\N	\N	17	\N	\N
392	500	2026-04-06	2027-04-06	active	\N	\N	18	\N	\N
393	500	2026-04-06	2027-04-06	active	\N	\N	18	\N	\N
394	500	2026-04-06	2027-04-06	active	\N	\N	18	\N	\N
395	500	2026-04-06	2027-04-06	active	\N	\N	18	\N	\N
396	500	2026-04-06	2027-04-06	active	\N	\N	18	\N	\N
397	500	2026-04-06	2027-04-06	active	\N	\N	18	\N	\N
398	500	2026-04-06	2027-04-06	active	\N	\N	18	\N	\N
400	500	2026-04-06	2027-04-06	active	\N	\N	18	\N	\N
140	500	2026-04-06	2026-05-06	redeemed	2026-04-19	\N	4	Test_Superuser	\N
391	500	2026-04-06	2027-04-06	redeemed	2026-04-19	\N	18	Edith.D	2
150	500	2026-04-06	2026-05-06	redeemed	2026-04-20	\N	4	Test_Superuser	\N
399	500	2026-04-06	2027-04-06	redeemed	2026-04-20	\N	18	Test_Superuser	\N
401	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
402	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
403	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
404	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
405	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
406	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
407	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
408	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
409	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
410	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
411	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
412	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
413	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
414	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
415	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
416	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
417	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
418	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
419	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
420	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
421	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
422	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
423	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
424	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
425	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
426	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
427	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
428	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
429	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
430	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
431	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
432	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
433	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
434	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
435	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
436	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
437	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
438	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
439	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
440	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
441	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
442	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
443	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
444	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
445	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
446	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
447	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
448	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
449	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
450	500	2026-04-20	2026-10-17	active	\N	\N	19	\N	\N
\.


--
-- Name: branch_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yesh_one
--

SELECT pg_catalog.setval('public.branch_branch_id_seq', 12, true);


--
-- Name: clients_ref_client_seq; Type: SEQUENCE SET; Schema: public; Owner: yesh_one
--

SELECT pg_catalog.setval('public.clients_ref_client_seq', 42, true);


--
-- Name: company_company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yesh_one
--

SELECT pg_catalog.setval('public.company_company_id_seq', 11, true);


--
-- Name: requests_ref_request_seq; Type: SEQUENCE SET; Schema: public; Owner: yesh_one
--

SELECT pg_catalog.setval('public.requests_ref_request_seq', 19, true);


--
-- Name: vouchers_ref_voucher_seq; Type: SEQUENCE SET; Schema: public; Owner: yesh_one
--

SELECT pg_catalog.setval('public.vouchers_ref_voucher_seq', 450, true);


--
-- Name: branch branch_pkey; Type: CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pkey PRIMARY KEY (branch_id);


--
-- Name: clients clients_email_client_key; Type: CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_email_client_key UNIQUE (email_client);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (ref_client);


--
-- Name: company company_email_company_key; Type: CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_email_company_key UNIQUE (email_company);


--
-- Name: company company_pkey; Type: CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pkey PRIMARY KEY (company_id);


--
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (ref_request);


--
-- Name: users users_email_user_key; Type: CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_user_key UNIQUE (email_user);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (username);


--
-- Name: vouchers vouchers_pkey; Type: CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_pkey PRIMARY KEY (ref_voucher);


--
-- Name: idx_client_email; Type: INDEX; Schema: public; Owner: yesh_one
--

CREATE INDEX idx_client_email ON public.clients USING btree (email_client);


--
-- Name: idx_request_client; Type: INDEX; Schema: public; Owner: yesh_one
--

CREATE INDEX idx_request_client ON public.requests USING btree (ref_client);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: yesh_one
--

CREATE INDEX idx_user_email ON public.users USING btree (email_user);


--
-- Name: idx_voucher_request; Type: INDEX; Schema: public; Owner: yesh_one
--

CREATE INDEX idx_voucher_request ON public.vouchers USING btree (ref_request);


--
-- Name: branch branch_ref_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_ref_company_fkey FOREIGN KEY (ref_company) REFERENCES public.company(company_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: branch branch_responsible_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_responsible_user_fkey FOREIGN KEY (responsible_user) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: requests requests_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: requests requests_processed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: requests requests_ref_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_ref_client_fkey FOREIGN KEY (ref_client) REFERENCES public.clients(ref_client) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: requests requests_validated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_validated_by_fkey FOREIGN KEY (validated_by) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vouchers vouchers_redeemed_branch_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_redeemed_branch_fkey FOREIGN KEY (redeemed_branch) REFERENCES public.branch(branch_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vouchers vouchers_redeemed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_redeemed_by_fkey FOREIGN KEY (redeemed_by) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: vouchers vouchers_ref_request_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yesh_one
--

ALTER TABLE ONLY public.vouchers
    ADD CONSTRAINT vouchers_ref_request_fkey FOREIGN KEY (ref_request) REFERENCES public.requests(ref_request) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: yesh
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO yesh_one;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: yesh
--

ALTER DEFAULT PRIVILEGES FOR ROLE yesh GRANT ALL ON SEQUENCES TO yesh_one;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: yesh
--

ALTER DEFAULT PRIVILEGES FOR ROLE yesh GRANT ALL ON FUNCTIONS TO yesh_one;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: yesh
--

ALTER DEFAULT PRIVILEGES FOR ROLE yesh GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO yesh_one;


--
-- PostgreSQL database dump complete
--

\unrestrict 0IfqT25tUIRXAb56T5AAmzMRopAuW1dvqwCASYeZSOs1RhLaXC46jrtM8IqPrfM