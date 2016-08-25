INSERT INTO requests(phrase,status,sound_path) VALUES ('Прослушать информацию о балансе', 'auth','sounds/builtin/requests/balance.wav');

INSERT INTO keywords(phrase) VALUES ('баланс'), ('счёт'), ('счет'), ('денег');

INSERT INTO answers(phrase,sound_path) VALUES ('Номер вашего счета:', 'sounds/builtin/answers/account_num.wav'), ('Ваш баланс составляет', 'sounds/builtin/answers/balance_state.wav');

INSERT INTO templates(phrase,sound_path) VALUES ('Ваш запрос', 'sounds/builtin/templates/request_guess.wav'), ('Это так?', 'sounds/builtin/templates/request_question.wav');

INSERT INTO statements(statement) VALUES('SELECT account_id FROM customers_accounts WHERE customer_id = ''VAR'''), ('SELECT balance FROM customers_accounts WHERE customer_id = ''VAR''');

INSERT INTO requests_keywords VALUES(1, 1, 0), (1, 2, 1), (1, 3, 2), (1, 4, 3);

INSERT INTO requests_answers VALUES(1, 1, 0), (1, 2, 1);

INSERT INTO requests_templates VALUES(1, 5, 0), (1, 6, 1);

INSERT INTO requests_statements VALUES(1, 1, 0), (1, 2, 1);