INSERT INTO customers (name, middle_name, surname, age) VALUES ('Петр', 'Иванович', 'Сидоров', 29);

INSERT INTO transactions (customer_id,partner,operation,amount) VALUES (1, 'Мегафон', 'cash_out', 100);

INSERT INTO pension_programs (name, rate, description) VALUES ('Физкульт-привет', 5, 'Возможность получить дополнительные баллы в накопительную пенсию за участие в спортивных мероприятиях.');

INSERT INTO credits (name, rate, term, description) VALUES ('Берегись автомобиля', 10, 120, 'Льготные условия на получение кредита на покупку автомобилей отечественных производителей.');

INSERT INTO deposits (name, rate, term, description) VALUES ('Растущий капитал', 9, 12, 'Возможность пополнения вклада в любой момент времени с гибким начислением процентов');

INSERT INTO auth (cc_numbers, cvv, card_code) VALUES (5432, 357, 9162);

INSERT INTO exchange_rate (name, buy, sell) VALUES ('Доллар', 65, 66);

INSERT INTO news (news_date, news) VALUES ('2016-08-01', 'Приветбанк успешно прошел ежегодную аккредитацию Центрабанка');

INSERT INTO customers_accounts(account_id, customer_id, balance) VALUES (12345678901234567890, 1, 5431);

INSERT INTO customers_credits (customer_id, credit_id, expires, cash_left) VALUES (1, 1, '2017-12-01', 23000);

INSERT INTO customers_deposits (customer_id, deposit_id, expires, cash_left) VALUES (1, 1, '2017-01-01', 132567);

INSERT INTO customers_pensions (customer_id, program_id, cash_left) VALUES (1, 1, 342567);