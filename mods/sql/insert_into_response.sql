-- INSERT INTO requests(phrase,status,sound_path) VALUES ('Прослушать информацию о балансе', 'auth','sounds/builtin/requests/balance.wav');

-- INSERT INTO keywords(phrase) VALUES ('баланс'), ('счёт'), ('счет'), ('денег');

-- INSERT INTO answers(phrase,sound_path) VALUES ('Номер вашего счета:', 'sounds/builtin/answers/account_num.wav'), ('Ваш баланс составляет', 'sounds/builtin/answers/balance_state.wav');

-- INSERT INTO templates(phrase,sound_path) VALUES ('Ваш запрос', 'sounds/builtin/templates/request_guess.wav'), ('Это так?', 'sounds/builtin/templates/request_question.wav');

-- INSERT INTO statements(statement) VALUES('SELECT account_id FROM customers_accounts WHERE customer_id = ''VAR'''), ('SELECT balance FROM customers_accounts WHERE customer_id = ''VAR''');

-- INSERT INTO requests_keywords VALUES(1, 1, 0), (1, 2, 1), (1, 3, 2), (1, 4, 3);

-- INSERT INTO requests_answers VALUES(1, 1, 0), (1, 2, 1);

-- INSERT INTO requests_templates VALUES(1, 5, 0), (1, 6, 1);

-- INSERT INTO requests_statements VALUES(1, 1, 0), (1, 2, 1);

-- INSERT INTO requests(phrase,status,sound_path) VALUES
-- ('Прослушать историю операций на банковском счете', 'auth', 'sounds/builtin/requests/transactions.wav'),
-- ('Получить информацию о действующих пенсионных программах', 'noauth', 'sounds/builtin/requests/pensions_info.wav'),
-- ('Получить информацию о действующих кредитах', 'noauth', 'sounds/builtin/requests/credits_info.wav'),
-- ('Получить информацию о действующих вкладах', 'noauth', 'sounds/builtin/requests/deposits_info.wav'),
-- ('Получить состояние пенсионной программы на банковском счете', 'auth', 'sounds/builtin/requests/pensions.wav'),
-- ('Получить состояние кредитов на банковском счете', 'auth', 'sounds/builtin/requests/credits.wav'),
-- ('Получить состояние депозитов на банковском счете', 'auth', 'sounds/builtin/requests/deposits.wav'),
-- ('Получить последние новости нашего банка', 'noauth', 'sounds/builtin/requests/news.wav'),
-- ('Получить информацию о текущем курсе валют нашего банка', 'noauth', 'sounds/builtin/requests/currency.wav');

-- INSERT INTO keywords(phrase) VALUES
-- ('транзакция'),('операция'),('транзакций'),('операций'), ('пополнение'), ('доход'), ('расход'), ('история'), ('историю'), ('снял'), ('положил'), ('пенсия'), ('пенсий'), ('пенсии'),
-- ('банке'), ('банк'), ('программ'), ('программа'), ('кредит'), ('депозит'), ('вклад'), ('вас'), ('есть'), ('состояние'), ('личных'), ('срок'), ('погашения'),
-- ('оканчивается'), ('заканчивается'), ('завершается'), ('осталось'), ('новости'), ('ново'), ('последние'), ('курс'), ('валют'), ('рубл'), ('доллар'), ('евро'),('покупаете'), ('продаете');

-- INSERT INTO answers(phrase,sound_path) VALUES 
-- ('История ваших операций', 'sounds/builtin/answers/transactions.wav'),('Номер операции', 'sounds/builtin/answers/transaction_id.wav'),
-- ('Партнер', 'sounds/builtin/answers/transaction_partner.wav'),('Формат операции', 'sounds/builtin/answers/transaction_format.wav'),
-- ('Сумма операции', 'sounds/builtin/answers/transaction_format.wav'),

-- ('История ваших кредитов', 'sounds/builtin/answers/credits.wav'),('Название кредита', 'sounds/builtin/answers/credit_name.wav'),
-- ('Срок погашения', 'sounds/builtin/answers/credit_deadline.wav'),('Оставшаяся сумма для погашения', 'sounds/builtin/answers/credit_left.wav'),

-- ('История ваших вкладов', 'sounds/builtin/answers/deposits.wav'),('Название вклада', 'sounds/builtin/answers/deposit_name.wav'),
-- ('Срок окончания', 'sounds/builtin/answers/deposit_deadline.wav'),('Текущая сумма на вкладе', 'sounds/builtin/answers/deposit_left.wav'),

-- ('Информация о вашей пенсионной программе', 'sounds/builtin/answers/pensions.wav'),('Название программы', 'sounds/builtin/answers/pension_name.wav'),
-- ('Текущая сумма в рамках программы', 'sounds/builtin/answers/pension_balance.wav'),

-- ('Новость от', 'sounds/builtin/answers/news_date.wav'),('Содержание новости', 'sounds/builtin/answers/news_description.wav'),

-- ('Валюта', 'sounds/builtin/answers/currency_name.wav'),('Сумма покупки', 'sounds/builtin/answers/currency_buy.wav'),('Сумма продажи', 'sounds/builtin/answers/currency_sell.wav'),

-- ('Название кредита', 'sounds/builtin/answers/credit_name.wav'),('Процент ставки кредита', 'sounds/builtin/answers/credit_rate.wav'),
-- ('Срок действия кредита в месяцах', 'sounds/builtin/answers/credit_term.wav'),('Описание кредита', 'sounds/builtin/answers/credit_description.wav'),

-- ('Название вклада', 'sounds/builtin/answers/deposit_name.wav'),('Процент ставки вклада', 'sounds/builtin/answers/deposit_rate.wav'),
-- ('Срок действия вклада в месяцах', 'sounds/builtin/answers/deposit_term.wav'),('Описание вклада', 'sounds/builtin/answers/deposit_description.wav'),

-- ('Название пенсионной программы', 'sounds/builtin/answers/pension_name.wav'),('Процент ставки программы', 'sounds/builtin/answers/pension_rate.wav'),
-- ('Описание программы', 'sounds/builtin/answers/pension_description.wav');

-- INSERT INTO templates(phrase,sound_path) VALUES ('Ваш запрос', 'sounds/builtin/templates/request_guess.wav'), ('Это так?', 'sounds/builtin/templates/request_question.wav');

-- INSERT INTO statements(statement) VALUES ('SELECT id FROM transactions WHERE customer_id = ''VAR'''),
-- ('SELECT partner FROM transactions WHERE customer_id = ''VAR'''),('SELECT operation FROM transactions WHERE customer_id = ''VAR'''),
-- ('SELECT amount FROM transactions WHERE customer_id = ''VAR'''),

-- ('SELECT name FROM credits WHERE id IN (SELECT credit_id FROM customers_credits WHERE customer_id = ''VAR'')'),
-- ('SELECT expires FROM customers_credits WHERE customer_id = ''VAR'''),('SELECT cash_left FROM customers_credits WHERE customer_id = ''VAR'''),

-- ('SELECT name FROM deposits WHERE id IN (SELECT deposit_id FROM customers_deposits WHERE customer_id = ''VAR'')'),
-- ('SELECT expires FROM customers_deposits WHERE customer_id = ''VAR'''),('SELECT cash_left FROM customers_deposits WHERE customer_id = ''VAR'''),

-- ('SELECT name FROM pension_programs WHERE id IN (SELECT pension_id FROM customers_pensions WHERE customer_id = ''VAR'')'),
-- ('SELECT cash_left FROM customers_pensions WHERE customer_id = ''VAR'''),

-- ('SELECT news_date FROM news'),('SELECT news FROM news'),

-- ('SELECT name FROM exchange_rate'),('SELECT buy FROM exchange_rate'),('SELECT sell FROM exchange_rate'),

-- ('SELECT name FROM credits'),('SELECT rate FROM credits'),('SELECT term FROM credits'),('SELECT description FROM credits'),

-- ('SELECT name FROM deposits'),('SELECT rate FROM deposits'),('SELECT term FROM deposits'),('SELECT description FROM deposits'),

-- ('SELECT name FROM pension_programs'),('SELECT rate FROM pension_programs'),('SELECT description FROM pension_programs');

-- INSERT INTO requests_keywords VALUES
-- (2, 3, 0), (2, 4, 1), (2, 7, 2), (2, 8, 3), (2, 9, 4), (2, 10, 5), (2, 11, 6), (2, 12, 7), (2, 13, 8), (2, 14, 9), (2, 15, 10), (2, 16, 11), (2, 17, 12), (2, 30, 13), (2, 31, 14), (2, 32, 15),
-- (3, 18, 0), (3, 19, 1), (3, 20, 2), (3, 21, 3), (3, 22, 4), (3, 23, 5), (3, 24, 6), (3, 28, 7), (3, 29, 8), (3, 12, 9),
-- (4, 25, 0), (4, 21, 1), (4, 22, 2), (4, 23, 3), (4, 24, 4), (4, 4, 5), (4, 31, 6), (4, 32, 7), (4, 40, 8), (4, 28, 9), (4, 29, 10), (4, 13, 11),
-- (5, 27, 0), (5, 21, 1), (5, 22, 2), (5, 23, 3), (5, 24, 4), (5, 4, 5), (5, 31, 6), (5, 32, 7), (5, 40, 8), (5, 28, 9), (5, 29, 10), (5, 12, 11),(5, 26, 12),
-- (6, 18, 0), (6, 2, 1), (6, 4, 2), (6, 11, 3), (6, 12, 4), (6, 17, 5), (6, 1, 6), (6, 19, 7), (6, 22, 8), (6, 30, 9), (6, 31, 10), (6, 37, 11),
-- (7, 25, 0), (7, 2, 1), (7, 4, 2), (7, 13, 3), (7, 14, 4), (7, 15, 5), (7, 20, 6), (7, 21, 7), (7, 1, 8), (7, 30, 9), (7, 31, 10), (7, 37, 11),(7, 32, 12), (7, 33, 13), (7, 34, 14), (7, 35, 15), (7, 36, 16),
-- (8, 26, 0), (8, 2, 1), (8, 4, 2), (8, 12, 3), (8, 14, 4), (8, 15, 5), (8, 20, 6), (8, 21, 7), (8, 1, 8), (8, 30, 9), (8, 31, 10), (8, 37, 11),(8, 32, 12), (8, 33, 13), (8, 34, 14), (8, 35, 15), (8, 36, 16),(8, 11, 17),
-- (9, 38, 0), (9, 39, 1), (9, 40, 2), (9, 21, 3), (9, 22, 4),
-- (10, 40, 0), (10, 41, 1), (10, 42, 2), (10, 43, 3), (10, 44, 4), (10, 45, 5), (10, 46, 6), (10, 47, 7), (10, 21, 8), (10, 22, 9), (10, 38, 10), (10, 39, 11);

-- INSERT INTO requests_answers VALUES
-- (2, 1, 0), (2, 4, 1), (2, 5, 2), (2, 6, 3), (2, 7, 4),
-- (3, 17, 0), (3, 33, 1), (3, 34, 2),
-- (4, 9, 0), (4, 25, 1), (4, 26, 2), (4, 27, 3),
-- (5, 13, 0), (5, 29, 1), (5, 30, 2), (5, 31, 3),
-- (6, 1, 0), (6, 17, 1), (6, 18, 2),
-- (7, 1, 0), (7, 9, 1), (7, 10, 2), (7, 11, 3),
-- (8, 1, 0), (8, 13, 1), (8, 14, 2), (8, 15, 3),
-- (9, 19, 0), (9, 20, 1),
-- (10, 21, 0), (10, 22, 1), (10, 23, 2);

-- INSERT INTO requests_templates VALUES(2, 5, 0), (2, 6, 1),(3, 5, 0), (3, 6, 1),(4, 5, 0), (4, 6, 1),(5, 5, 0), (5, 6, 1),(6, 5, 0), (6, 6, 1),(7, 5, 0), (7, 6, 1),(8, 5, 0), (8, 6, 1),(9, 5, 0), (9, 6, 1),(10, 5, 0), (10, 6, 1);

-- INSERT INTO requests_statements VALUES
-- (2, 1, 0), (2, 3, 1), (2, 4, 2), (2, 5, 3), (2, 6, 4),
-- (3, 28, 0), (3, 29, 1), (3, 30, 2),
-- (4, 20, 0), (4, 21, 1), (4, 22, 2), (4, 23, 3),
-- (5, 24, 0), (5, 25, 1), (5, 26, 2), (5, 27, 3),
-- (6, 1, 0), (6, 13, 1), (6, 14, 2),
-- (7, 1, 0), (7, 7, 1), (7, 8, 2), (7, 9, 3),
-- (8, 1, 0), (8, 10, 1), (8, 11, 2), (8, 12, 3),
-- (9, 15, 0), (9, 16, 1),
-- (10, 17, 0), (10, 18, 1), (10, 19, 2);