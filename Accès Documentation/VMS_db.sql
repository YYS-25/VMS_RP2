--
-- PostgreSQL database dump
--

\restrict 5kD0MZcxB4xbgJ8iICpMAayHQpOa1ngjn86oejcpm8kzU01Z3WLW0X0oDbSq4q2

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

--
-- Name: deactivate_client(integer); Type: PROCEDURE; Schema: public; Owner: yesh_one
--

CREATE PROCEDURE public.deactivate_client(IN p_ref_client integer)
    LANGUAGE plpgsql
    AS $$

DECLARE

    v_count INTEGER;

BEGIN

    -- Check client exists and is active

    SELECT COUNT(*) INTO v_count

    FROM public.clients

    WHERE ref_client = p_ref_client AND active = true;

    IF v_count = 0 THEN

        RAISE EXCEPTION 'Client % does not exist or is already inactive.', p_ref_client;

    END IF;

    -- Deactivate the client

    UPDATE public.clients

    SET active = false

    WHERE ref_client = p_ref_client;

    RAISE NOTICE 'Client % has been deactivated.', p_ref_client;

END;

$$;


ALTER PROCEDURE public.deactivate_client(IN p_ref_client integer) OWNER TO yesh_one;

--
-- Name: set_voucher_expiry(); Type: FUNCTION; Schema: public; Owner: yesh_one
--

CREATE FUNCTION public.set_voucher_expiry() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

    v_duration INTEGER;

BEGIN

    SELECT duration_voucher

    INTO v_duration

    FROM public.requests

    WHERE ref_request = NEW.ref_request;

    IF v_duration IS NOT NULL AND NEW.init_date IS NOT NULL THEN

        NEW.expiry_date := NEW.init_date + v_duration;

    END IF;

    RETURN NEW;

END;

$$;


ALTER FUNCTION public.set_voucher_expiry() OWNER TO yesh_one;

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

INSERT INTO public.branch VALUES (1, 'Home Office', 'Test_Admin', 1, NULL, NULL);
INSERT INTO public.branch VALUES (2, 'Quicksilver Caudan', 'Edith.D', 2, 'Caudan, Port Louis', '620 6041');
INSERT INTO public.branch VALUES (3, 'Artisan Solferino', 'Matt.O', 1, 'Solferino', '760 4026');
INSERT INTO public.branch VALUES (5, 'Maurishop Vacoas', 'Raj.P', 4, '42 Rue de la Paix, Vacoas', '+230 696 5151');
INSERT INTO public.branch VALUES (6, 'Logistique Ocean Port-Louis', 'Sophie.L', 5, '15 Rue Labourdonais, Port-Louis', '+230 212 5050');
INSERT INTO public.branch VALUES (7, 'Banque Maurice Quatre-Bornes', 'Amir.K', 6, '88 Rue Royal, Quatre-Bornes', '+230 464 5252');
INSERT INTO public.branch VALUES (8, 'Sante Plus Curepipe', 'Yasmine.M', 7, '12 Rue Sir William Newton, Curepipe', '+230 675 5353');
INSERT INTO public.branch VALUES (9, 'Energie Verte Beau-Bassin', 'Jean.D', 8, 'Zone Industrielle Côte d''Or, Beau-Bassin', '+230 696 5454');
INSERT INTO public.branch VALUES (10, 'Digital Studio Rose-Hill', 'Priya.S', 9, '33 Rue Desforges, Rose-Hill', '+230 465 5555');
INSERT INTO public.branch VALUES (11, 'Prime Manufacturing Moka', 'Luc.B', 10, '99 Chemin Grenier, Moka', '+230 696 5656');
INSERT INTO public.branch VALUES (12, 'Akademi Education Quatre-Bornes', 'Nina.C', 11, '7 Rue Dr Bunch, Quatre-Bornes', '+230 212 5757');
INSERT INTO public.branch VALUES (4, 'TechWorld', 'Test_Superuser', 3, 'Trianon', '456 9765');


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

INSERT INTO public.clients VALUES (22, 'Ernst & Young Mauritius', 'site-supercar@alwaysdata.net', 'Level 9, Tower 1, NeXTeracom, Ebene, Mauritius', '+230 200 0004', true);
INSERT INTO public.clients VALUES (2, 'Jimmy', 'jim@mail.com', 'Vacoas', '+230 6507919', true);
INSERT INTO public.clients VALUES (3, 'Sam', 'sam@mail.com', 'Washington DC', '+1 979 5465 2100', false);
INSERT INTO public.clients VALUES (19, 'Deloitte Mauritius', 'deloitte.mauritius@test.com', '7th Floor, One Cathedral Square, Port Louis, Mauritius', '+230 200 0001', true);
INSERT INTO public.clients VALUES (20, 'PwC Mauritius', 'pwc.mauritius@test.com', '18 CyberCity, Ebene, Mauritius', '+230 200 0002', true);
INSERT INTO public.clients VALUES (23, 'BDO Mauritius', 'bdo.mauritius@test.com', '10 Frere Felix de Valois Street, Port Louis, Mauritius', '+230 200 0005', true);
INSERT INTO public.clients VALUES (24, 'Grant Thornton Mauritius', 'grant.thornton.mauritius@test.com', 'The Axis, 26 Cybercity, Ebene, Mauritius', '+230 200 0006', true);
INSERT INTO public.clients VALUES (25, 'Deloitte UK', 'deloitte.uk@test.com', '1 New Street Square, London, UK', '+44 200 000 0007', true);
INSERT INTO public.clients VALUES (26, 'PwC UK', 'pwc.uk@test.com', '1 Embankment Place, London, UK', '+44 200 000 0008', true);
INSERT INTO public.clients VALUES (27, 'KPMG UK', 'kpmg.uk@test.com', '15 Canada Square, Canary Wharf, London, UK', '+44 200 000 0009', true);
INSERT INTO public.clients VALUES (28, 'McKinsey & Company UK', 'mckinsey.uk@test.com', '1 Jermyn Street, London, UK', '+44 200 000 0010', true);
INSERT INTO public.clients VALUES (29, 'Boston Consulting Group UK', 'bcg.uk@test.com', '1 Curzon Street, London, UK', '+44 200 000 0011', true);
INSERT INTO public.clients VALUES (31, 'McKinsey & Company USA', 'mckinsey.usa@test.com', '711 3rd Avenue, New York, NY, USA', '+1 200 000 0013', true);
INSERT INTO public.clients VALUES (32, 'Boston Consulting Group USA', 'bcg.usa@test.com', '200 Pier 4 Blvd, Boston, MA, USA', '+1 200 000 0014', true);
INSERT INTO public.clients VALUES (33, 'Accenture USA', 'accenture.usa@test.com', '161 N Clark Street, Chicago, IL, USA', '+1 200 000 0015', true);
INSERT INTO public.clients VALUES (34, 'Deloitte USA', 'deloitte.usa@test.com', '30 Rockefeller Plaza, New York, NY, USA', '+1 200 000 0016', true);
INSERT INTO public.clients VALUES (35, 'Oliver Wyman USA', 'oliver.wyman.usa@test.com', '1166 Avenue of the Americas, New York, NY, USA', '+1 200 000 0017', true);
INSERT INTO public.clients VALUES (36, 'Alteo Advisory Mauritius', 'alteo.advisory@mail.local', 'Beau Plan, Pamplemousses, Mauritius', '+230 200 0018', false);
INSERT INTO public.clients VALUES (37, 'Axis Fiduciary Mauritius', 'axis.fiduciary@mail.local', 'Ebene Skies, Ebene, Mauritius', '+230 200 0019', true);
INSERT INTO public.clients VALUES (40, 'Trident Trust Mauritius', 'trident.trust@mail.local', 'Ebene Cybercity, Mauritius', '+230 200 0022', false);
INSERT INTO public.clients VALUES (38, 'Vistra Mauritius', 'vistra.mauritius@mail.local', 'IFS Court, Bank Street, CyberCity, Ebene, Mauritius', '+230 200 0020', true);
INSERT INTO public.clients VALUES (39, 'Intertrust Mauritius', 'intertrust.mauritius@mail.local', 'Level 3, Alexander House, Ebene, Mauritius', '+230 200 0021', true);
INSERT INTO public.clients VALUES (41, 'Apex Group Mauritius', 'apex.group.mauritius@mail.local', 'Level 2, Dias Pier Building, Le Caudan, Port Louis', '+230 200 0023', true);
INSERT INTO public.clients VALUES (42, 'Mazars Mauritius', 'mazars.mauritius@mail.local', 'Les Cascades Building, Edith Cavell Street, Port Louis', '+230 200 0024', true);
INSERT INTO public.clients VALUES (21, 'KPMG Mauritius', 'kpmg.mauritius@test.com', 'Mill Street, Port Louis, Mauritius', '+230 200 0003', false);
INSERT INTO public.clients VALUES (30, 'Bain & Company London', 'bain.london@test.com', '40 Strand, London, UK', '+44 200 000 0012', false);


--
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

INSERT INTO public.company VALUES (1, 'Artisans & Co', 'artisan@mail.com', 'Foods & Drinks');
INSERT INTO public.company VALUES (2, 'Apparels Corp', 'apparel@mail.com', 'Clothing');
INSERT INTO public.company VALUES (3, 'Technopholia', 'techpholia@mail.com', 'Technology');
INSERT INTO public.company VALUES (4, 'Maurishop', 'contact@maurishop.mu', 'Retail');
INSERT INTO public.company VALUES (5, 'Logistique Ocean', 'info@logistiqueocean.mu', 'Logistics');
INSERT INTO public.company VALUES (6, 'Banque Maurice', 'support@banquemaurice.mu', 'Banking');
INSERT INTO public.company VALUES (7, 'Sante Plus', 'hello@santeplus.mu', 'Healthcare');
INSERT INTO public.company VALUES (8, 'Energie Verte', 'sales@energieverte.mu', 'Energy');
INSERT INTO public.company VALUES (9, 'Digital Studio', 'team@digitalstudio.mu', 'Marketing');
INSERT INTO public.company VALUES (10, 'Prime Manufacturing', 'contact@primemfg.mu', 'Manufacturing');
INSERT INTO public.company VALUES (11, 'Akademi Education', 'info@akademi.mu', 'Education');


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

INSERT INTO public.requests VALUES (1, '2025-12-07', 5, 'CREATED', NULL, NULL, NULL, NULL, 0, 2, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.requests VALUES (12, '2026-04-06', 20, 'CREATED', NULL, NULL, NULL, NULL, 180, 19, 'Test_Superuser', NULL, NULL, NULL, '500');
INSERT INTO public.requests VALUES (3, '2026-04-05', 100, 'APPROVED', 'validated', '2026-04-05', NULL, '2026-04-05', 180, 22, 'Test_Superuser', 'Test_Superuser', NULL, 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\Culture_Managériale_BTS_1ere_année_complet.pdf', NULL);
INSERT INTO public.requests VALUES (11, '2026-04-06', 10, 'VALIDATED', 'validated', '2026-04-06', NULL, '2026-04-06', 180, 19, 'Test_Superuser', 'Test_Superuser', 'Test_Superuser', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\EXO_1.pdf', '5000');
INSERT INTO public.requests VALUES (18, '2026-04-06', 10, 'VALIDATED', 'validated', '2026-04-06', NULL, '2026-04-06', 365, 27, 'Test_Superuser', 'Ajay.V', 'Ajay.V', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '500');
INSERT INTO public.requests VALUES (13, '2026-04-06', 20, 'VALIDATED', 'validated', '2026-04-06', NULL, '2026-04-06', 60, 23, 'Test_Superuser', 'Test_Superuser', 'Test_Superuser', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\EXO_1.pdf', '2000');
INSERT INTO public.requests VALUES (5, '2026-04-05', 75, 'VALIDATED', 'validated', '2026-04-05', NULL, '2026-04-05', 365, 22, 'Test_Superuser', 'Test_Approver', 'Test_Approver', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '990');
INSERT INTO public.requests VALUES (6, '2026-04-05', 10, 'VALIDATED', 'validated', '2026-04-05', NULL, '2026-04-05', 365, 22, 'Test_Accountant', 'Test_Approver', 'Test_Approver', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '1000');
INSERT INTO public.requests VALUES (14, '2026-04-06', 10, 'VALIDATED', 'validated', '2026-04-06', NULL, '2026-04-06', 90, 23, 'Test_Superuser', 'Test_Superuser', 'Test_Superuser', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '500');
INSERT INTO public.requests VALUES (7, '2026-04-05', 5, 'VALIDATED', 'validated', '2026-04-05', NULL, '2026-04-05', 30, 22, 'Test_Superuser', 'Test_Superuser', 'Test_Superuser', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '2500');
INSERT INTO public.requests VALUES (8, '2026-04-06', 10, 'VALIDATED', 'validated', '2026-04-06', NULL, '2026-04-06', 60, 22, 'Test_Accountant', 'Test_Approver', 'Test_Approver', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '1000');
INSERT INTO public.requests VALUES (4, '2026-04-05', 200, 'VALIDATED', 'validated', '2026-04-05', NULL, '2026-04-06', 30, 22, 'Test_Superuser', 'Test_Superuser', 'Test_Superuser', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '500');
INSERT INTO public.requests VALUES (15, '2026-04-06', 5, 'APPROVED', 'validated', '2026-04-06', NULL, '2026-04-06', 365, 24, 'Test_Superuser', 'Test_Superuser', 'Test_Superuser', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '1000');
INSERT INTO public.requests VALUES (9, '2026-04-06', 25, 'VALIDATED', 'validated', '2026-04-06', NULL, '2026-04-06', 90, 33, 'Test_Superuser', 'Test_Superuser', 'Test_Superuser', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\EXO_1.pdf', '2000');
INSERT INTO public.requests VALUES (10, '2026-04-06', 10, 'VALIDATED', 'validated', '2026-04-06', NULL, '2026-04-06', 30, 23, 'Test_Superuser', 'Test_Superuser', 'Test_Superuser', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\EXO_1.pdf', '500');
INSERT INTO public.requests VALUES (16, '2026-04-06', 5, 'VALIDATED', 'validated', '2026-04-06', NULL, '2026-04-06', 365, 24, 'Test_Superuser', 'Test_Superuser', 'Test_Superuser', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '5000');
INSERT INTO public.requests VALUES (17, '2026-04-06', 5, 'VALIDATED', 'validated', '2026-04-06', NULL, '2026-04-06', 270, 27, 'Test_Superuser', 'Ajay.V', 'Ajay.V', 'C:\Users\yeshn\OneDrive - MCCI Business School Ltd\Documents\php.pdf', '1000');
INSERT INTO public.requests VALUES (19, '2026-04-20', 50, 'VALIDATED', 'validated', '2026-04-20', NULL, '2026-04-20', 180, 19, 'Test_Accountant', 'Test_Approver', 'Test_Approver', 'C:\Users\yeshn\Downloads\PreuvePayment.pdf', '500');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

INSERT INTO public.users VALUES ('Matt.O', 'Mathieu', 'Opman', 'matt@mail.com', 'Supervisor', '12345', '', 'Supervisor', 'Active');
INSERT INTO public.users VALUES ('Edith.D', 'Edith', 'Dave', 'edith@mail.com', 'Supervisor', '12345', '', 'Supervisor_Quicksilver', 'Active');
INSERT INTO public.users VALUES ('Test_Accountant', 'Bruno', 'Accountant_Surname', 'v.managery+accountant@gmail.com', 'Accountant', '12345', '', 'Accountant', 'Active');
INSERT INTO public.users VALUES ('Test_Admin', 'Admin', 'Admin_Surname', 'v.managery+admin@gmail.com', 'Admin', '12345', '', 'Admin', 'Active');
INSERT INTO public.users VALUES ('Test_Approver', 'Apparadu', 'Approver_Surname', 'v.managery+approver@gmail.com', 'Approver', '14235', '', 'Approver', 'Active');
INSERT INTO public.users VALUES ('Test_Superuser', 'Supergo', 'Test_Surname', 'v.managery+superuser@gmail.com', 'Superuser', '123789', '', 'Superuser', 'Active');
INSERT INTO public.users VALUES ('Raj.P', 'Raj', 'Patel', 'raj.patel@mail.com', 'Supervisor', '12345', '', 'Supervisor_Maurishop', 'Active');
INSERT INTO public.users VALUES ('Sophie.L', 'Sophie', 'Laurent', 'sophie.laurent@mail.com', 'Supervisor', '12345', '', 'Supervisor_Logistique', 'Active');
INSERT INTO public.users VALUES ('Amir.K', 'Amir', 'Koonjul', 'amir.koonjul@mail.com', 'Supervisor', '12345', '', 'Supervisor_Banque', 'Active');
INSERT INTO public.users VALUES ('Yasmine.M', 'Yasmine', 'Mohamed', 'yasmine.mohamed@mail.com', 'Supervisor', '12345', '', 'Supervisor_Sante', 'Active');
INSERT INTO public.users VALUES ('Jean.D', 'Jean', 'Durand', 'jean.durand@mail.com', 'Supervisor', '12345', '', 'Supervisor_Energie', 'Active');
INSERT INTO public.users VALUES ('Priya.S', 'Priya', 'Sharma', 'priya.sharma@mail.com', 'Supervisor', '12345', '', 'Supervisor_Digital', 'Active');
INSERT INTO public.users VALUES ('Luc.B', 'Luc', 'Benoit', 'luc.benoit@mail.com', 'Supervisor', '12345', '', 'Supervisor_Prime', 'Active');
INSERT INTO public.users VALUES ('Nina.C', 'Nina', 'Cools', 'nina.cools@mail.com', 'Supervisor', '12345', '', 'Supervisor_Akademi', 'Active');
INSERT INTO public.users VALUES ('Gigs.B', 'Gigsby', 'Butcher', 'gigs@mail.com', 'Supervisor', '12345', '', 'Supervisor_Techworld', 'Active');
INSERT INTO public.users VALUES ('Ajay.V', 'Ajay', 'Valingum', 'v.managery+app.ajay@gmail.com', 'Approver', '12345', '', 'Approver', 'Active');
INSERT INTO public.users VALUES ('Test_Supervisor', 'Vistor', 'Visor_Surname', 'v.managery+supervisor@gmail.com', 'Supervisor', '12345', '', 'Supervisor', 'Active');


--
-- Data for Name: vouchers; Type: TABLE DATA; Schema: public; Owner: yesh_one
--

INSERT INTO public.vouchers VALUES (1, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (2, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (3, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (4, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (5, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (6, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (7, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (8, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (9, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (10, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (11, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (12, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (13, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (14, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (15, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (16, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (17, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (18, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (19, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (20, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (21, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (22, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (23, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (24, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (25, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (26, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (27, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (28, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (29, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (30, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (31, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (32, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (33, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (34, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (35, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (36, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (37, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (38, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (39, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (40, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (41, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (42, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (43, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (44, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (45, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (46, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (47, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (48, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (49, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (50, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (51, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (52, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (53, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (54, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (55, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (56, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (57, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (58, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (59, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (60, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (61, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (62, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (63, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (64, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (65, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (66, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (67, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (68, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (69, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (70, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (71, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (72, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (73, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (74, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (75, '990', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 5, NULL, NULL);
INSERT INTO public.vouchers VALUES (76, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (77, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (78, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (79, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (80, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (81, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (82, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (83, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (84, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (85, '1000', '2026-04-05', '2027-04-05', 'active', NULL, NULL, 6, NULL, NULL);
INSERT INTO public.vouchers VALUES (86, '2500', '2026-04-05', '2026-05-05', 'active', NULL, NULL, 7, NULL, NULL);
INSERT INTO public.vouchers VALUES (87, '2500', '2026-04-05', '2026-05-05', 'active', NULL, NULL, 7, NULL, NULL);
INSERT INTO public.vouchers VALUES (88, '2500', '2026-04-05', '2026-05-05', 'active', NULL, NULL, 7, NULL, NULL);
INSERT INTO public.vouchers VALUES (89, '2500', '2026-04-05', '2026-05-05', 'active', NULL, NULL, 7, NULL, NULL);
INSERT INTO public.vouchers VALUES (90, '2500', '2026-04-05', '2026-05-05', 'active', NULL, NULL, 7, NULL, NULL);
INSERT INTO public.vouchers VALUES (91, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (92, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (93, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (94, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (95, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (96, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (97, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (98, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (99, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (100, '1000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 8, NULL, NULL);
INSERT INTO public.vouchers VALUES (101, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (102, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (103, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (104, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (105, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (106, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (107, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (108, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (109, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (110, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (111, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (112, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (113, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (114, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (115, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (116, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (117, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (118, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (119, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (120, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (121, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (122, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (123, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (124, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (125, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (126, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (127, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (128, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (129, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (130, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (131, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (132, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (133, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (134, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (135, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (136, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (137, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (138, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (139, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (141, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (142, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (143, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (144, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (145, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (146, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (147, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (148, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (149, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (151, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (152, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (153, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (154, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (155, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (156, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (157, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (158, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (159, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (160, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (161, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (162, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (163, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (164, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (165, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (166, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (167, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (168, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (169, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (170, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (171, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (172, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (173, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (174, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (175, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (176, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (177, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (178, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (179, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (180, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (181, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (182, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (183, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (184, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (185, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (186, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (187, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (188, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (189, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (190, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (191, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (192, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (193, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (194, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (195, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (196, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (197, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (198, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (199, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (200, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (201, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (202, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (203, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (204, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (205, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (206, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (207, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (208, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (209, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (210, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (211, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (212, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (213, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (214, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (215, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (216, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (217, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (218, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (219, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (220, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (221, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (222, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (223, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (224, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (225, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (226, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (227, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (228, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (229, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (230, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (231, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (232, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (233, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (234, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (235, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (236, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (237, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (238, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (239, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (240, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (241, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (242, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (243, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (244, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (245, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (246, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (247, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (248, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (249, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (250, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (251, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (252, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (253, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (254, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (255, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (256, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (257, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (258, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (259, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (260, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (261, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (262, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (263, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (264, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (265, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (266, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (267, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (268, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (269, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (270, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (271, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (272, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (273, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (274, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (275, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (276, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (277, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (278, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (279, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (280, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (281, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (282, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (283, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (284, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (285, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (286, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (287, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (288, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (289, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (290, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (291, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (292, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (293, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (294, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (295, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (296, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (297, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (298, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (299, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (300, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 4, NULL, NULL);
INSERT INTO public.vouchers VALUES (301, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (302, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (303, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (304, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (305, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (306, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (307, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (308, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (309, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (310, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (311, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (312, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (313, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (314, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (315, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (316, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (317, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (318, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (319, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (320, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (321, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (322, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (323, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (324, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (325, '2000', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 9, NULL, NULL);
INSERT INTO public.vouchers VALUES (326, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (327, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (328, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (329, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (330, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (331, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (332, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (333, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (334, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (335, '500', '2026-04-06', '2026-05-06', 'active', NULL, NULL, 10, NULL, NULL);
INSERT INTO public.vouchers VALUES (336, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (337, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (338, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (339, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (340, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (341, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (342, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (343, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (344, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (345, '5000', '2026-04-06', '2026-10-03', 'active', NULL, NULL, 11, NULL, NULL);
INSERT INTO public.vouchers VALUES (346, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (347, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (348, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (349, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (350, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (351, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (352, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (353, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (354, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (355, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (356, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (357, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (358, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (359, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (360, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (361, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (362, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (363, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (364, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (365, '2000', '2026-04-06', '2026-06-05', 'active', NULL, NULL, 13, NULL, NULL);
INSERT INTO public.vouchers VALUES (366, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (367, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (368, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (369, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (370, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (371, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (372, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (373, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (374, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (375, '500', '2026-04-06', '2026-07-05', 'active', NULL, NULL, 14, NULL, NULL);
INSERT INTO public.vouchers VALUES (376, '1000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 15, NULL, NULL);
INSERT INTO public.vouchers VALUES (377, '1000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 15, NULL, NULL);
INSERT INTO public.vouchers VALUES (378, '1000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 15, NULL, NULL);
INSERT INTO public.vouchers VALUES (379, '1000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 15, NULL, NULL);
INSERT INTO public.vouchers VALUES (380, '1000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 15, NULL, NULL);
INSERT INTO public.vouchers VALUES (381, '5000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 16, NULL, NULL);
INSERT INTO public.vouchers VALUES (382, '5000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 16, NULL, NULL);
INSERT INTO public.vouchers VALUES (383, '5000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 16, NULL, NULL);
INSERT INTO public.vouchers VALUES (384, '5000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 16, NULL, NULL);
INSERT INTO public.vouchers VALUES (385, '5000', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 16, NULL, NULL);
INSERT INTO public.vouchers VALUES (386, '1000', '2026-04-06', '2027-01-01', 'active', NULL, NULL, 17, NULL, NULL);
INSERT INTO public.vouchers VALUES (387, '1000', '2026-04-06', '2027-01-01', 'active', NULL, NULL, 17, NULL, NULL);
INSERT INTO public.vouchers VALUES (388, '1000', '2026-04-06', '2027-01-01', 'active', NULL, NULL, 17, NULL, NULL);
INSERT INTO public.vouchers VALUES (389, '1000', '2026-04-06', '2027-01-01', 'active', NULL, NULL, 17, NULL, NULL);
INSERT INTO public.vouchers VALUES (390, '1000', '2026-04-06', '2027-01-01', 'active', NULL, NULL, 17, NULL, NULL);
INSERT INTO public.vouchers VALUES (392, '500', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 18, NULL, NULL);
INSERT INTO public.vouchers VALUES (393, '500', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 18, NULL, NULL);
INSERT INTO public.vouchers VALUES (394, '500', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 18, NULL, NULL);
INSERT INTO public.vouchers VALUES (395, '500', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 18, NULL, NULL);
INSERT INTO public.vouchers VALUES (396, '500', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 18, NULL, NULL);
INSERT INTO public.vouchers VALUES (397, '500', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 18, NULL, NULL);
INSERT INTO public.vouchers VALUES (398, '500', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 18, NULL, NULL);
INSERT INTO public.vouchers VALUES (400, '500', '2026-04-06', '2027-04-06', 'active', NULL, NULL, 18, NULL, NULL);
INSERT INTO public.vouchers VALUES (140, '500', '2026-04-06', '2026-05-06', 'redeemed', '2026-04-19', NULL, 4, 'Test_Superuser', NULL);
INSERT INTO public.vouchers VALUES (391, '500', '2026-04-06', '2027-04-06', 'redeemed', '2026-04-19', NULL, 18, 'Edith.D', 2);
INSERT INTO public.vouchers VALUES (150, '500', '2026-04-06', '2026-05-06', 'redeemed', '2026-04-20', NULL, 4, 'Test_Superuser', NULL);
INSERT INTO public.vouchers VALUES (399, '500', '2026-04-06', '2027-04-06', 'redeemed', '2026-04-20', NULL, 18, 'Test_Superuser', NULL);
INSERT INTO public.vouchers VALUES (401, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (402, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (403, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (404, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (405, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (406, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (407, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (408, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (409, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (410, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (411, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (412, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (413, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (414, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (415, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (416, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (417, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (418, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (419, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (420, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (421, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (422, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (423, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (424, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (425, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (426, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (427, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (428, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (429, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (430, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (431, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (432, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (433, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (434, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (435, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (436, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (437, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (438, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (439, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (440, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (441, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (442, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (443, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (444, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (445, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (446, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (447, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (448, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (449, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);
INSERT INTO public.vouchers VALUES (450, '500', '2026-04-20', '2026-10-17', 'active', NULL, NULL, 19, NULL, NULL);


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
-- Name: vouchers trg_set_voucher_expiry; Type: TRIGGER; Schema: public; Owner: yesh_one
--

CREATE TRIGGER trg_set_voucher_expiry BEFORE INSERT ON public.vouchers FOR EACH ROW EXECUTE FUNCTION public.set_voucher_expiry();


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

\unrestrict 5kD0MZcxB4xbgJ8iICpMAayHQpOa1ngjn86oejcpm8kzU01Z3WLW0X0oDbSq4q2
