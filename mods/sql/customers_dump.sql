--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE auth (
    customer_id integer,
    cc_numbers integer NOT NULL,
    cvv integer NOT NULL,
    card_code integer NOT NULL
);


ALTER TABLE auth OWNER TO postgres;

--
-- Name: credits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE credits (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    rate numeric(5,2) NOT NULL,
    term integer NOT NULL,
    description text
);


ALTER TABLE credits OWNER TO postgres;

--
-- Name: credits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE credits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE credits_id_seq OWNER TO postgres;

--
-- Name: credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE credits_id_seq OWNED BY credits.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE customers (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    middle_name character varying(30),
    surname character varying(30) NOT NULL,
    age integer NOT NULL
);


ALTER TABLE customers OWNER TO postgres;

--
-- Name: customers_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE customers_accounts (
    account_id numeric(20,0) NOT NULL,
    customer_id integer,
    balance numeric(30,2) NOT NULL
);


ALTER TABLE customers_accounts OWNER TO postgres;

--
-- Name: customers_accounts_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE customers_accounts_account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customers_accounts_account_id_seq OWNER TO postgres;

--
-- Name: customers_accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE customers_accounts_account_id_seq OWNED BY customers_accounts.account_id;


--
-- Name: customers_credits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE customers_credits (
    id integer NOT NULL,
    customer_id integer,
    credit_id integer,
    expires date NOT NULL,
    cash_left numeric(30,2) NOT NULL
);


ALTER TABLE customers_credits OWNER TO postgres;

--
-- Name: customers_credits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE customers_credits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customers_credits_id_seq OWNER TO postgres;

--
-- Name: customers_credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE customers_credits_id_seq OWNED BY customers_credits.id;


--
-- Name: customers_deposits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE customers_deposits (
    id integer NOT NULL,
    customer_id integer,
    deposit_id integer,
    expires date NOT NULL,
    cash_left numeric(30,2) NOT NULL
);


ALTER TABLE customers_deposits OWNER TO postgres;

--
-- Name: customers_deposits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE customers_deposits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customers_deposits_id_seq OWNER TO postgres;

--
-- Name: customers_deposits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE customers_deposits_id_seq OWNED BY customers_deposits.id;


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customers_id_seq OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- Name: customers_pensions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE customers_pensions (
    id integer NOT NULL,
    customer_id integer,
    program_id integer,
    cash_left numeric(30,2) NOT NULL
);


ALTER TABLE customers_pensions OWNER TO postgres;

--
-- Name: customers_pensions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE customers_pensions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customers_pensions_id_seq OWNER TO postgres;

--
-- Name: customers_pensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE customers_pensions_id_seq OWNED BY customers_pensions.id;


--
-- Name: deposits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE deposits (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    rate numeric(5,2) NOT NULL,
    term integer NOT NULL,
    description text
);


ALTER TABLE deposits OWNER TO postgres;

--
-- Name: deposits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE deposits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE deposits_id_seq OWNER TO postgres;

--
-- Name: deposits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE deposits_id_seq OWNED BY deposits.id;


--
-- Name: exchange_rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE exchange_rate (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    buy numeric(10,2) NOT NULL,
    sell numeric(10,2) NOT NULL
);


ALTER TABLE exchange_rate OWNER TO postgres;

--
-- Name: exchange_rate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE exchange_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE exchange_rate_id_seq OWNER TO postgres;

--
-- Name: exchange_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE exchange_rate_id_seq OWNED BY exchange_rate.id;


--
-- Name: news; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE news (
    id integer NOT NULL,
    news_date timestamp without time zone NOT NULL,
    news text NOT NULL
);


ALTER TABLE news OWNER TO postgres;

--
-- Name: news_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE news_id_seq OWNER TO postgres;

--
-- Name: news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE news_id_seq OWNED BY news.id;


--
-- Name: pension_programs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE pension_programs (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    rate numeric(5,2) NOT NULL,
    description text
);


ALTER TABLE pension_programs OWNER TO postgres;

--
-- Name: pension_programs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pension_programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pension_programs_id_seq OWNER TO postgres;

--
-- Name: pension_programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pension_programs_id_seq OWNED BY pension_programs.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE transactions (
    id integer NOT NULL,
    customer_id integer,
    partner character varying(50),
    operation character varying(10) NOT NULL,
    amount numeric(20,2) NOT NULL
);


ALTER TABLE transactions OWNER TO postgres;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transactions_id_seq OWNER TO postgres;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY credits ALTER COLUMN id SET DEFAULT nextval('credits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- Name: account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_accounts ALTER COLUMN account_id SET DEFAULT nextval('customers_accounts_account_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_credits ALTER COLUMN id SET DEFAULT nextval('customers_credits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_deposits ALTER COLUMN id SET DEFAULT nextval('customers_deposits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_pensions ALTER COLUMN id SET DEFAULT nextval('customers_pensions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY deposits ALTER COLUMN id SET DEFAULT nextval('deposits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY exchange_rate ALTER COLUMN id SET DEFAULT nextval('exchange_rate_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY news ALTER COLUMN id SET DEFAULT nextval('news_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pension_programs ALTER COLUMN id SET DEFAULT nextval('pension_programs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Data for Name: auth; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth (customer_id, cc_numbers, cvv, card_code) FROM stdin;
\N	5432	357	9162
\.


--
-- Data for Name: credits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY credits (id, name, rate, term, description) FROM stdin;
1	Берегись автомобиля	10.00	120	Льготные условия на получение кредита на покупку автомобилей отечественных производителей.
\.


--
-- Name: credits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('credits_id_seq', 1, true);


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customers (id, name, middle_name, surname, age) FROM stdin;
1	Петр	Иванович	Сидоров	29
\.


--
-- Data for Name: customers_accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customers_accounts (account_id, customer_id, balance) FROM stdin;
12345678901234567890	1	5431.00
\.


--
-- Name: customers_accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('customers_accounts_account_id_seq', 1, false);


--
-- Data for Name: customers_credits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customers_credits (id, customer_id, credit_id, expires, cash_left) FROM stdin;
1	1	1	2017-12-01	23000.00
\.


--
-- Name: customers_credits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('customers_credits_id_seq', 1, true);


--
-- Data for Name: customers_deposits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customers_deposits (id, customer_id, deposit_id, expires, cash_left) FROM stdin;
1	1	1	2017-01-01	132567.00
\.


--
-- Name: customers_deposits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('customers_deposits_id_seq', 1, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('customers_id_seq', 1, true);


--
-- Data for Name: customers_pensions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customers_pensions (id, customer_id, program_id, cash_left) FROM stdin;
1	1	1	342567.00
\.


--
-- Name: customers_pensions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('customers_pensions_id_seq', 1, true);


--
-- Data for Name: deposits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY deposits (id, name, rate, term, description) FROM stdin;
1	Растущий капитал	9.00	12	Возможность пополнения вклада в любой момент времени с гибким начислением процентов
\.


--
-- Name: deposits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('deposits_id_seq', 1, true);


--
-- Data for Name: exchange_rate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY exchange_rate (id, name, buy, sell) FROM stdin;
1	Доллар	65.00	66.00
\.


--
-- Name: exchange_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('exchange_rate_id_seq', 1, true);


--
-- Data for Name: news; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY news (id, news_date, news) FROM stdin;
1	2016-08-01 00:00:00	Приветбанк успешно прошел ежегодную аккредитацию Центрабанка
\.


--
-- Name: news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('news_id_seq', 1, true);


--
-- Data for Name: pension_programs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pension_programs (id, name, rate, description) FROM stdin;
1	Физкульт-привет	5.00	Возможность получить дополнительные баллы в накопительную пенсию за участие в спортивных мероприятиях.
\.


--
-- Name: pension_programs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pension_programs_id_seq', 1, true);


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY transactions (id, customer_id, partner, operation, amount) FROM stdin;
1	1	Мегафон	cash_out	100.00
\.


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('transactions_id_seq', 1, true);


--
-- Name: auth_customer_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth
    ADD CONSTRAINT auth_customer_id_idx UNIQUE (customer_id);


--
-- Name: credits_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY credits
    ADD CONSTRAINT credits_id_idx PRIMARY KEY (id);


--
-- Name: customers_accounts_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_accounts
    ADD CONSTRAINT customers_accounts_id_idx PRIMARY KEY (account_id);


--
-- Name: customers_credits_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_credits
    ADD CONSTRAINT customers_credits_id_idx PRIMARY KEY (id);


--
-- Name: customers_deposits_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_deposits
    ADD CONSTRAINT customers_deposits_id_idx PRIMARY KEY (id);


--
-- Name: customers_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_id_idx PRIMARY KEY (id);


--
-- Name: customers_pensions_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_pensions
    ADD CONSTRAINT customers_pensions_id_idx PRIMARY KEY (id);


--
-- Name: deposits_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY deposits
    ADD CONSTRAINT deposits_id_idx PRIMARY KEY (id);


--
-- Name: exchange_rate_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY exchange_rate
    ADD CONSTRAINT exchange_rate_id_idx PRIMARY KEY (id);


--
-- Name: news_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY news
    ADD CONSTRAINT news_id_idx PRIMARY KEY (id);


--
-- Name: pension_programs_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pension_programs
    ADD CONSTRAINT pension_programs_id_idx PRIMARY KEY (id);


--
-- Name: transactions_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_id_idx PRIMARY KEY (id);


--
-- Name: auth_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth
    ADD CONSTRAINT auth_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: customers_accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_accounts
    ADD CONSTRAINT customers_accounts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: customers_credits_credit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_credits
    ADD CONSTRAINT customers_credits_credit_id_fkey FOREIGN KEY (credit_id) REFERENCES credits(id);


--
-- Name: customers_credits_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_credits
    ADD CONSTRAINT customers_credits_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: customers_deposits_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_deposits
    ADD CONSTRAINT customers_deposits_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: customers_deposits_deposit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_deposits
    ADD CONSTRAINT customers_deposits_deposit_id_fkey FOREIGN KEY (deposit_id) REFERENCES deposits(id);


--
-- Name: customers_pensions_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_pensions
    ADD CONSTRAINT customers_pensions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: customers_pensions_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers_pensions
    ADD CONSTRAINT customers_pensions_program_id_fkey FOREIGN KEY (program_id) REFERENCES pension_programs(id);


--
-- Name: transactions_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

