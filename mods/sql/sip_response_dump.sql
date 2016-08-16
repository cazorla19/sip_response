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
-- Name: answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE answers (
    id integer NOT NULL,
    phrase character varying(150),
    sound_path character varying(50)
);


ALTER TABLE answers OWNER TO postgres;

--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE answers_id_seq OWNER TO postgres;

--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: call_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE call_history (
    call_id integer NOT NULL,
    call_timestamp timestamp without time zone NOT NULL,
    call_number integer,
    call_status character varying(10),
    call_mark integer DEFAULT 0
);


ALTER TABLE call_history OWNER TO postgres;

--
-- Name: call_history_call_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE call_history_call_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE call_history_call_id_seq OWNER TO postgres;

--
-- Name: call_history_call_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE call_history_call_id_seq OWNED BY call_history.call_id;


--
-- Name: keywords; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE keywords (
    id integer NOT NULL,
    phrase character varying(150)
);


ALTER TABLE keywords OWNER TO postgres;

--
-- Name: keywords_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE keywords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE keywords_id_seq OWNER TO postgres;

--
-- Name: keywords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE keywords_id_seq OWNED BY keywords.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE requests (
    id integer NOT NULL,
    phrase character varying(150),
    status character varying(10),
    sound_path character varying(50)
);


ALTER TABLE requests OWNER TO postgres;

--
-- Name: requests_answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE requests_answers (
    request_id integer,
    answer_id integer,
    seq_order integer NOT NULL
);


ALTER TABLE requests_answers OWNER TO postgres;

--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE requests_id_seq OWNER TO postgres;

--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE requests_id_seq OWNED BY requests.id;


--
-- Name: requests_keywords; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE requests_keywords (
    request_id integer,
    keyword_id integer,
    seq_order integer NOT NULL
);


ALTER TABLE requests_keywords OWNER TO postgres;

--
-- Name: requests_statements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE requests_statements (
    request_id integer,
    statement_id integer,
    seq_order integer NOT NULL
);


ALTER TABLE requests_statements OWNER TO postgres;

--
-- Name: requests_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE requests_templates (
    request_id integer,
    template_id integer,
    seq_order integer NOT NULL
);


ALTER TABLE requests_templates OWNER TO postgres;

--
-- Name: statements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE statements (
    id integer NOT NULL,
    statement character varying(150)
);


ALTER TABLE statements OWNER TO postgres;

--
-- Name: statements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE statements_id_seq OWNER TO postgres;

--
-- Name: statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE statements_id_seq OWNED BY statements.id;


--
-- Name: templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE templates (
    id integer NOT NULL,
    phrase character varying(150),
    sound_path character varying(50)
);


ALTER TABLE templates OWNER TO postgres;

--
-- Name: templates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE templates_id_seq OWNER TO postgres;

--
-- Name: templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE templates_id_seq OWNED BY templates.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: call_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY call_history ALTER COLUMN call_id SET DEFAULT nextval('call_history_call_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY keywords ALTER COLUMN id SET DEFAULT nextval('keywords_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests ALTER COLUMN id SET DEFAULT nextval('requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY statements ALTER COLUMN id SET DEFAULT nextval('statements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY templates ALTER COLUMN id SET DEFAULT nextval('templates_id_seq'::regclass);


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY answers (id, phrase, sound_path) FROM stdin;
1	Номер вашего счета:	sounds/builtin/answers/account_num.wav
2	Ваш баланс составляет	sounds/builtin/answers/balance_state.wav
\.


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('answers_id_seq', 2, true);


--
-- Data for Name: call_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY call_history (call_id, call_timestamp, call_number, call_status, call_mark) FROM stdin;
1	2016-01-01 23:12:45	856743	success	4
\.


--
-- Name: call_history_call_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('call_history_call_id_seq', 1, true);


--
-- Data for Name: keywords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY keywords (id, phrase) FROM stdin;
1	баланс
2	счёт
3	счет
4	денег
\.


--
-- Name: keywords_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('keywords_id_seq', 6, true);


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests (id, phrase, status, sound_path) FROM stdin;
1	Прослушать информацию о балансе	auth	sounds/builtin/requests/balance.wav
\.


--
-- Data for Name: requests_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests_answers (request_id, answer_id, seq_order) FROM stdin;
1	1	1
1	2	2
\.


--
-- Name: requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('requests_id_seq', 1, true);


--
-- Data for Name: requests_keywords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests_keywords (request_id, keyword_id, seq_order) FROM stdin;
1	1	1
1	2	2
1	3	3
1	4	4
\.


--
-- Data for Name: requests_statements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests_statements (request_id, statement_id, seq_order) FROM stdin;
1	1	1
1	2	2
\.


--
-- Data for Name: requests_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests_templates (request_id, template_id, seq_order) FROM stdin;
1	5	1
1	6	2
\.


--
-- Data for Name: statements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY statements (id, statement) FROM stdin;
1	SELECT account_id FROM customers_accounts WHERE customer_id = 'VAR'
2	SELECT balance FROM customers_accounts WHERE customer_id = 'VAR'
\.


--
-- Name: statements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('statements_id_seq', 2, true);


--
-- Data for Name: templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY templates (id, phrase, sound_path) FROM stdin;
5	Ваш запрос	sounds/builtin/templates/request_guess.wav
6	Это так?	sounds/builtin/templates/request_question.wav
\.


--
-- Name: templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('templates_id_seq', 6, true);


--
-- Name: answers_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_id_idx PRIMARY KEY (id);


--
-- Name: call_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY call_history
    ADD CONSTRAINT call_history_pkey PRIMARY KEY (call_id);


--
-- Name: keywords_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY keywords
    ADD CONSTRAINT keywords_id_idx PRIMARY KEY (id);


--
-- Name: requests_answers_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_answers
    ADD CONSTRAINT requests_answers_idx UNIQUE (request_id, answer_id);


--
-- Name: requests_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT requests_id_idx PRIMARY KEY (id);


--
-- Name: requests_keywords_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_keywords
    ADD CONSTRAINT requests_keywords_idx UNIQUE (request_id, keyword_id);


--
-- Name: requests_statements_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_statements
    ADD CONSTRAINT requests_statements_idx UNIQUE (request_id, statement_id);


--
-- Name: requests_templates_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_templates
    ADD CONSTRAINT requests_templates_idx UNIQUE (request_id, template_id);


--
-- Name: statements_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY statements
    ADD CONSTRAINT statements_id_idx PRIMARY KEY (id);


--
-- Name: templates_id_idx; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY templates
    ADD CONSTRAINT templates_id_idx PRIMARY KEY (id);


--
-- Name: call_history_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX call_history_id_idx ON call_history USING btree (call_id);


--
-- Name: requests_answers_answer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_answers
    ADD CONSTRAINT requests_answers_answer_id_fkey FOREIGN KEY (answer_id) REFERENCES answers(id);


--
-- Name: requests_answers_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_answers
    ADD CONSTRAINT requests_answers_request_id_fkey FOREIGN KEY (request_id) REFERENCES requests(id);


--
-- Name: requests_keywords_keyword_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_keywords
    ADD CONSTRAINT requests_keywords_keyword_id_fkey FOREIGN KEY (keyword_id) REFERENCES keywords(id);


--
-- Name: requests_keywords_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_keywords
    ADD CONSTRAINT requests_keywords_request_id_fkey FOREIGN KEY (request_id) REFERENCES requests(id);


--
-- Name: requests_statements_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_statements
    ADD CONSTRAINT requests_statements_request_id_fkey FOREIGN KEY (request_id) REFERENCES requests(id);


--
-- Name: requests_statements_statement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_statements
    ADD CONSTRAINT requests_statements_statement_id_fkey FOREIGN KEY (statement_id) REFERENCES statements(id);


--
-- Name: requests_templates_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_templates
    ADD CONSTRAINT requests_templates_request_id_fkey FOREIGN KEY (request_id) REFERENCES requests(id);


--
-- Name: requests_templates_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY requests_templates
    ADD CONSTRAINT requests_templates_template_id_fkey FOREIGN KEY (template_id) REFERENCES templates(id);


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

