CREATE TABLE call_history (
	call_id SERIAL PRIMARY KEY,
	call_agi_id BIGINT NOT NULL,
	call_timestamp TIMESTAMP NOT NULL,
	call_number VARCHAR(50),
	call_status VARCHAR(10),
	request_id INT,
	customer_id INT,
	answer_path VARCHAR(50),
);

CREATE TABLE requests (
	id SERIAL PRIMARY KEY,
	phrase VARCHAR(150),
	status VARCHAR(10),
	sound_path VARCHAR(50),
	CONSTRAINT requests_id_idx UNIQUE(id)
);

CREATE TABLE keywords (
	id SERIAL PRIMARY KEY,
	phrase VARCHAR(150),
	sound_path VARCHAR(50),
	CONSTRAINT keywords_id_idx UNIQUE(id)
);

CREATE TABLE answers (
	id SERIAL PRIMARY KEY,
	phrase VARCHAR(150),
	sound_path VARCHAR(50),
	CONSTRAINT answers_id_idx UNIQUE(id)
);

CREATE TABLE templates (
	id SERIAL PRIMARY KEY,
	phrase VARCHAR(150),
	sound_path VARCHAR(50),
	CONSTRAINT templates_id_idx UNIQUE(id)
);

CREATE TABLE statements (
	id SERIAL PRIMARY KEY,
	statement VARCHAR(150),
	CONSTRAINT statements_id_idx UNIQUE(id)
);

CREATE TABLE requests_keywords(
	request_id INT REFERENCES requests(id),
	keyword_id INT REFERENCES keywords(id),
	CONSTRAINT requests_keywords_idx UNIQUE(request_id, keyword_id)
);

CREATE TABLE requests_answers(
	request_id INT REFERENCES requests(id),
	answer_id INT REFERENCES answers(id),
	CONSTRAINT requests_answers_idx UNIQUE(request_id, answer_id)
);

CREATE TABLE requests_templates(
	request_id INT REFERENCES requests(id),
	template_id INT REFERENCES templates(id),
	CONSTRAINT requests_templates_idx UNIQUE(request_id, template_id)
);

CREATE TABLE requests_statements(
	request_id INT REFERENCES requests(id),
	statement_id INT REFERENCES statements(id),
	CONSTRAINT requests_statements_idx UNIQUE(request_id, statement_id)
);

CREATE OR REPLACE FUNCTION idx(anyarray, anyelement)
  RETURNS INT AS 
$$
  SELECT i FROM (
     SELECT generate_series(array_lower($1,1),array_upper($1,1))
  ) g(i)
  WHERE $1[i] = $2
  LIMIT 1;
$$ LANGUAGE SQL IMMUTABLE;