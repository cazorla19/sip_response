--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.4

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

--
-- Name: idx(anyarray, anyelement); Type: FUNCTION; Schema: public; Owner: cazorla19
--

CREATE FUNCTION idx(anyarray, anyelement) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$
  SELECT i FROM (
     SELECT generate_series(array_lower($1,1),array_upper($1,1))
  ) g(i)
  WHERE $1[i] = $2
  LIMIT 1;
$_$;


ALTER FUNCTION public.idx(anyarray, anyelement) OWNER TO cazorla19;

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
    call_number character varying(50),
    call_status character varying(10),
    request_id integer,
    customer_id integer,
    answer_path character varying(100),
    call_agi_id bigint NOT NULL
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
1	Номер вашего счета:	builtin/answers/account_num.wav
2	Ваш баланс составляет	builtin/answers/balance_state.wav
4	Номер операции	builtin/answers/transaction_id.wav
5	Партнер	builtin/answers/transaction_partner.wav
6	Формат операции	builtin/answers/transaction_format.wav
7	Сумма операции	builtin/answers/transaction_format.wav
9	Название кредита	builtin/answers/credit_name.wav
10	Срок погашения	builtin/answers/credit_deadline.wav
11	Оставшаяся сумма для погашения	builtin/answers/credit_left.wav
13	Название вклада	builtin/answers/deposit_name.wav
14	Срок окончания	builtin/answers/deposit_deadline.wav
15	Текущая сумма на вкладе	builtin/answers/deposit_left.wav
17	Название программы	builtin/answers/pension_name.wav
18	Текущая сумма в рамках программы	builtin/answers/pension_balance.wav
19	Новость от	builtin/answers/news_date.wav
20	Содержание новости	builtin/answers/news_description.wav
21	Валюта	builtin/answers/currency_name.wav
22	Сумма покупки	builtin/answers/currency_buy.wav
23	Сумма продажи	builtin/answers/currency_sell.wav
25	Процент ставки кредита	builtin/answers/credit_rate.wav
26	Срок действия кредита в месяцах	builtin/answers/credit_term.wav
27	Описание кредита	builtin/answers/credit_description.wav
29	Процент ставки вклада	builtin/answers/deposit_rate.wav
30	Срок действия вклада в месяцах	builtin/answers/deposit_term.wav
31	Описание вклада	builtin/answers/deposit_description.wav
33	Процент ставки программы	builtin/answers/pension_rate.wav
34	Описание программы	builtin/answers/pension_description.wav
\.


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('answers_id_seq', 34, true);


--
-- Data for Name: call_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY call_history (call_id, call_timestamp, call_number, call_status, request_id, customer_id, answer_path, call_agi_id) FROM stdin;
\.


--
-- Name: call_history_call_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('call_history_call_id_seq', 9, true);


--
-- Data for Name: keywords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY keywords (id, phrase) FROM stdin;
1	баланс
2	счёт
3	счет
4	денег
7	транзакция
8	операция
9	транзакций
10	операций
11	пополнение
12	доход
13	расход
14	история
15	историю
16	снял
17	положил
18	пенсия
19	пенсий
20	пенсии
21	банке
22	банк
23	программ
24	программа
25	кредит
26	депозит
27	вклад
28	вас
29	есть
30	состояние
31	личных
32	срок
33	погашения
34	оканчивается
35	заканчивается
36	завершается
37	осталось
38	новости
39	ново
40	последние
41	курс
42	валют
43	рубл
44	доллар
45	евро
46	покупаете
47	продаете
\.


--
-- Name: keywords_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('keywords_id_seq', 47, true);


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests (id, phrase, status, sound_path) FROM stdin;
1	Прослушать информацию о балансе	auth	builtin/requests/balance.wav
2	Прослушать историю операций на банковском счете	auth	builtin/requests/transactions.wav
3	Получить информацию о действующих пенсионных программах	noauth	builtin/requests/pensions_info.wav
4	Получить информацию о действующих кредитах	noauth	builtin/requests/credits_info.wav
5	Получить информацию о действующих вкладах	noauth	builtin/requests/deposits_info.wav
6	Получить состояние пенсионной программы на банковском счете	auth	builtin/requests/pensions.wav
7	Получить состояние кредитов на банковском счете	auth	builtin/requests/credits.wav
8	Получить состояние депозитов на банковском счете	auth	builtin/requests/deposits.wav
9	Получить последние новости нашего банка	noauth	builtin/requests/news.wav
10	Получить информацию о текущем курсе валют нашего банка	noauth	builtin/requests/currency.wav
\.


--
-- Data for Name: requests_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests_answers (request_id, answer_id, seq_order) FROM stdin;
1	1	0
1	2	1
2	1	0
2	4	1
2	5	2
2	6	3
2	7	4
3	17	0
3	33	1
3	34	2
4	9	0
4	25	1
4	26	2
4	27	3
5	13	0
5	29	1
5	30	2
5	31	3
6	1	0
6	17	1
6	18	2
7	1	0
7	9	1
7	10	2
7	11	3
8	1	0
8	13	1
8	14	2
8	15	3
9	19	0
9	20	1
10	21	0
10	22	1
10	23	2
\.


--
-- Name: requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('requests_id_seq', 10, true);


--
-- Data for Name: requests_keywords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests_keywords (request_id, keyword_id, seq_order) FROM stdin;
1	1	0
1	2	1
1	3	2
1	4	3
2	3	0
2	4	1
2	7	2
2	8	3
2	9	4
2	10	5
2	11	6
2	12	7
2	13	8
2	14	9
2	15	10
2	16	11
2	17	12
2	30	13
2	31	14
2	32	15
3	18	0
3	19	1
3	20	2
3	21	3
3	22	4
3	23	5
3	24	6
3	28	7
3	29	8
3	12	9
4	25	0
4	21	1
4	22	2
4	23	3
4	24	4
4	4	5
4	31	6
4	32	7
4	40	8
4	28	9
4	29	10
4	13	11
5	27	0
5	21	1
5	22	2
5	23	3
5	24	4
5	4	5
5	31	6
5	32	7
5	40	8
5	28	9
5	29	10
5	12	11
5	26	12
6	18	0
6	2	1
6	4	2
6	11	3
6	12	4
6	17	5
6	1	6
6	19	7
6	22	8
6	30	9
6	31	10
6	37	11
7	25	0
7	2	1
7	4	2
7	13	3
7	14	4
7	15	5
7	20	6
7	21	7
7	1	8
7	30	9
7	31	10
7	37	11
7	32	12
7	33	13
7	34	14
7	35	15
7	36	16
8	26	0
8	2	1
8	4	2
8	12	3
8	14	4
8	15	5
8	20	6
8	21	7
8	1	8
8	30	9
8	31	10
8	37	11
8	32	12
8	33	13
8	34	14
8	35	15
8	36	16
8	11	17
9	38	0
9	39	1
9	40	2
9	21	3
9	22	4
10	40	0
10	41	1
10	42	2
10	43	3
10	44	4
10	45	5
10	46	6
10	47	7
10	21	8
10	22	9
10	38	10
10	39	11
\.


--
-- Data for Name: requests_statements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests_statements (request_id, statement_id, seq_order) FROM stdin;
1	1	0
1	2	1
2	1	0
2	3	1
2	4	2
2	5	3
2	6	4
3	28	0
3	29	1
3	30	2
4	20	0
4	21	1
4	22	2
4	23	3
5	24	0
5	25	1
5	26	2
5	27	3
6	1	0
6	13	1
6	14	2
7	1	0
7	7	1
7	8	2
7	9	3
8	1	0
8	10	1
8	11	2
8	12	3
9	15	0
9	16	1
10	17	0
10	18	1
10	19	2
\.


--
-- Data for Name: requests_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY requests_templates (request_id, template_id, seq_order) FROM stdin;
1	5	0
1	6	1
2	5	0
2	6	1
3	5	0
3	6	1
4	5	0
4	6	1
5	5	0
5	6	1
6	5	0
6	6	1
7	5	0
7	6	1
8	5	0
8	6	1
9	5	0
9	6	1
10	5	0
10	6	1
\.


--
-- Data for Name: statements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY statements (id, statement) FROM stdin;
1	SELECT account_id FROM customers_accounts WHERE customer_id = 'VAR'
2	SELECT balance FROM customers_accounts WHERE customer_id = 'VAR'
3	SELECT id FROM transactions WHERE customer_id = 'VAR'
4	SELECT partner FROM transactions WHERE customer_id = 'VAR'
5	SELECT operation FROM transactions WHERE customer_id = 'VAR'
6	SELECT amount FROM transactions WHERE customer_id = 'VAR'
7	SELECT name FROM credits WHERE id IN (SELECT credit_id FROM customers_credits WHERE customer_id = 'VAR')
8	SELECT expires FROM customers_credits WHERE customer_id = 'VAR'
9	SELECT cash_left FROM customers_credits WHERE customer_id = 'VAR'
10	SELECT name FROM deposits WHERE id IN (SELECT deposit_id FROM customers_deposits WHERE customer_id = 'VAR')
11	SELECT expires FROM customers_deposits WHERE customer_id = 'VAR'
12	SELECT cash_left FROM customers_deposits WHERE customer_id = 'VAR'
13	SELECT name FROM pension_programs WHERE id IN (SELECT pension_id FROM customers_pensions WHERE customer_id = 'VAR')
14	SELECT cash_left FROM customers_pensions WHERE customer_id = 'VAR'
15	SELECT news_date FROM news
16	SELECT news FROM news
17	SELECT name FROM exchange_rate
18	SELECT buy FROM exchange_rate
19	SELECT sell FROM exchange_rate
20	SELECT name FROM credits
21	SELECT rate FROM credits
22	SELECT term FROM credits
23	SELECT description FROM credits
24	SELECT name FROM deposits
25	SELECT rate FROM deposits
26	SELECT term FROM deposits
27	SELECT description FROM deposits
28	SELECT name FROM pension_programs
29	SELECT rate FROM pension_programs
30	SELECT description FROM pension_programs
\.


--
-- Name: statements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('statements_id_seq', 30, true);


--
-- Data for Name: templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY templates (id, phrase, sound_path) FROM stdin;
5	Ваш запрос	builtin/templates/request_guess.wav
6	Это так?	builtin/templates/request_question.wav
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

