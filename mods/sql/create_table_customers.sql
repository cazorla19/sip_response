CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	middle_name VARCHAR(30),
	surname VARCHAR(30) NOT NULL,
	year INT NOT NULL,
	CONSTRAINT customers_id_idx UNIQUE(id)
);

CREATE TABLE transactions (
	id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(id),
	partner VARCHAR(50),
	operation VARCHAR(10) NOT NULL,
	amount NUMERIC(20, 2) NOT NULL,
	CONSTRAINT transactions_id_idx UNIQUE(id)
);

CREATE TABLE pension_programs (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	rate NUMERIC (5,2) NOT NULL,
	description TEXT,
	CONSTRAINT pension_programs_id_idx UNIQUE(id)
);

CREATE TABLE credits (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	rate NUMERIC (5,2) NOT NULL,
	term INT NOT NULL,
	description TEXT,
	CONSTRAINT credits_id_idx UNIQUE(id)
);

CREATE TABLE deposits (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	rate NUMERIC (5,2) NOT NULL,
	term INT NOT NULL,
	description TEXT,
	CONSTRAINT deposits_id_idx UNIQUE(id)
);

CREATE TABLE auth (
	customer_id INT REFERENCES customers(id),
	cc_numbers INT NOT NULL,
	cvv INT NOT NULL,
	card_code INT NOT NULL,
	CONSTRAINT auth_customer_id_idx UNIQUE(customer_id)
);

CREATE TABLE exchange_rate (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	buy NUMERIC(10,2) NOT NULL,
	sell NUMERIC(10,2) NOT NULL,
	CONSTRAINT exchange_rate_id_idx UNIQUE(id)
);

CREATE TABLE news (
	id SERIAL PRIMARY KEY,
	news_date TIMESTAMP NOT NULL,
	news TEXT NOT NULL,
	CONSTRAINT news_id_idx UNIQUE(id)
);

CREATE TABLE customers_accounts (
	account_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(id),
	balance NUMERIC(30,2) NOT NULL,
	CONSTRAINT customers_accounts_id_idx UNIQUE(account_id)
);

CREATE TABLE customers_credits (
	id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(id),
	credit_id INT REFERENCES credits(id),
	expires DATE NOT NULL,
	cash_left NUMERIC(30,2) NOT NULL,
	CONSTRAINT customers_credits_id_idx UNIQUE(id)
);

CREATE TABLE customers_deposits (
	id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(id),
	deposit_id INT REFERENCES deposits(id),
	expires DATE NOT NULL,
	cash_left NUMERIC(30,2) NOT NULL,
	CONSTRAINT customers_deposits_id_idx UNIQUE(id)
);

CREATE TABLE customers_pensions (
	id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(id),
	program_id INT REFERENCES pension_programs(id),
	cash_left NUMERIC(30,2) NOT NULL,
	CONSTRAINT customers_pensions_id_idx UNIQUE(id)
);