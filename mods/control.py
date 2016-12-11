# !/usr/bin/env python
#  -*- coding: utf-8 -*-

"""
Submodule for requests processing
"""

import db_interface
import recognition
import sys
import shelve
import os
import ConfigParser
from asterisk.agi import *

reload(sys)
sys.setdefaultencoding('utf8')

# getting credentials from log file
config = ConfigParser.ConfigParser()
config.read("/var/lib/asterisk/agi-bin/sip_response/myresponse.conf")
native_db_host = config.get('native_database', 'db_host')
native_db_port = config.get('native_database', 'db_port')
native_db_name = config.get('native_database', 'db_name')
native_db_user = config.get('native_database', 'db_user')
native_db_password = config.get('native_database', 'db_password')
customer_db_host = config.get('customer_database', 'db_host')
customer_db_port = config.get('customer_database', 'db_port')
customer_db_name = config.get('customer_database', 'db_name')
customer_db_user = config.get('customer_database', 'db_user')
customer_db_password = config.get('customer_database', 'db_password')


def response(text_file, keyword_flag, request_flag, directory, keyword_scan):
    # get request text
    for line in open(text_file, 'r'):
        request = line
    request = request.decode('utf-8').lower()
    request_id = text_file.split('/')[-1]

    shelve_file = directory + '/workflow/shelves/' + request_id
    connect, cursor = db_interface.connect(
        host=native_db_host, port=native_db_port, db=native_db_name,
        user=native_db_user, password=native_db_password
    )

    if keyword_scan:
        keyword_file = shelve.open(shelve_file)
        statement = 'SELECT phrase FROM keywords'
        # make query to look for a possible keywords
        result = db_interface.query(statement, connect, cursor)
        options = []
        for i in range(len(result)):
            keyword = result[i][0]
            if keyword in request:
                options.append(keyword)
        keyword_file['keyword_list'] = options
    else:
        keyword_file = shelve.open(shelve_file)
        options = keyword_file['keyword_list']
    key_len = len(options)
    # if no one keyword found - return empty values
    if key_len == 0:
        return 0, 0, 0

    # get one keyword in order to flag
    word = options[keyword_flag]
    request_statement = (
        """SELECT id, phrase, sound_path FROM requests WHERE id IN
        (SELECT request_id FROM requests_keywords WHERE keyword_id =
        (SELECT id FROM keywords WHERE phrase = \'%s\'))"""
        % (word)
    )
    # find out list of appropriate requests and these sounds
    result = db_interface.query(request_statement, connect, cursor)
    req_len = len(result)
    user_request_id = result[request_flag][0]
    request = result[request_flag][1]
    phrase_audio_file = result[request_flag][2]

    templates_statement = (
        """SELECT sound_path FROM templates WHERE id IN
        (SELECT template_id FROM requests_templates
        WHERE request_id = %d);"""
        % (user_request_id)
    )
    # find out templates
    templates = db_interface.query(templates_statement, connect, cursor)
    # generate list of files to merge
    merge_list = [templates[0][0], phrase_audio_file]
    if len(templates) > 1:
        for template in templates[1:]:
            merge_list.append(template[0])

    # generate response file name
    out_file = (
        directory + '/workflow/responses/' + request_id + '_response' + '.wav'
    )
    # merge parts of response
    merged_file = recognition.merge_files(merge_list, out_file, directory)
    return merged_file, req_len, key_len, user_request_id


def check_auth_status(user_request_id):
    connect, cursor = db_interface.connect(
        host=native_db_host, port=native_db_port,
        db=native_db_name, user=native_db_user,
        password=native_db_password
    )
    # look at the database
    status_statement = (
        'SELECT status FROM requests WHERE id = %d;' % (user_request_id)
    )
    result = db_interface.query(status_statement, connect, cursor)
    request_status = result[0][0]
    # return authentication status
    if request_status == 'noauth':
        return 'noauth'
    else:
        return 'auth'


def auth_name(text_file, user_request_id):
    connect, cursor = db_interface.connect(
        host=customers_db_host, port=customers_db_port,
        db=customers_db_name, user=customers_db_user,
        password=customers_db_password
    )
    # get request text
    for line in open(text_file, 'r'):
        request = line
    # syntax requires correct names and years order
    surname, name, middle_name, year = request.split()[0:4]

    # get the fact customer exists, pull his id
    statement = (
        """SELECT id, CONCAT(surname, \' \', name, \' \', middle_name, \' \', year)
        FROM customers WHERE surname = \'%s\' AND name = \'%s\'
        AND middle_name = \'%s\' AND year = \'%s\';"""
        % (surname, name, middle_name, year)
    )
    result = db_interface.query(statement, connect, cursor)
    # don't know what to do if many customers with the same credentials
    if len(result) > 1:
        status = 'redirect'
        return status, 0
    # failed authentication if no one customer has been found
    elif len(result) == 0:
        status = 'failed'
        return status, 0
    # set the customer id if we found one
    else:
        status = 'success'
        customer_id = result[0][0]
        return status, customer_id


def auth_credentials(field, text_file, customer_id):
    connect, cursor = db_interface.connect(
        host=customers_db_host, port=customers_db_port,
        db=customers_db_name, user=customers_db_user,
        password=customers_db_password
    )
    # get request text
    for line in open(text_file, 'r'):
        request = line

    # field is a DB table column, customer id is a primary key
    statement = (
        'SELECT %s FROM auth WHERE customer_id = %d;' % (field, customer_id)
    )
    result = db_interface.query(statement, connect, cursor)
    # get first value as a customer credential
    credential = result[0][0]
    # if we found creential in request; it's alright
    if str(credential) in request:
        status = 'success'
    # otherwise request failed
    else:
        status = 'failed'
    return status


def answer(user_request_id, customer_id, call_id, directory):

    def get_values(cursor, table, column, user_request_id):
        # get all items id with appropriate request
        statement = (
            """SELECT %s_id FROM requests_%ss
            WHERE request_id = %d ORDER BY seq_order;"""
            % (table, table, user_request_id)
        )
        result = db_interface.query(statement, connect, cursor)
        custom_list = []
        # convert each tuple to string and append to list
        for custom_tuple in result:
            custom_list.append(custom_tuple[0])
        custom_tuple = tuple(custom_list)
        final_statement = (
            'SELECT %s FROM %ss WHERE id IN %s ORDER BY idx(array%s, id)'
            % (column, table, custom_tuple, custom_list)
        )
        # get all items by ID
        final_statement_result = db_interface.query(
            final_statement, connect, cursor
        )
        return final_statement_result

    connect, cursor = db_interface.connect(
        host=native_db_host, port=native_db_port,
        db=native_db_name, user=native_db_user,
        password=native_db_password
    )
    sql_statements_result = get_values(
        cursor, 'statement', 'statement', user_request_id
    )
    answers_result = get_values(
        cursor, 'answer', 'sound_path', user_request_id
    )

    connect, customers_cursor = db_interface.connect(
        host=customer_db_host, port=customer_db_port, db=customer_db_name,
        user=customer_db_user, password=customer_db_password
    )
    init_audio_format = 'mp3'
    prepared_statements = []

    # convert the text statements result to answer
    for i in range(len(sql_statements_result)):
        # insert request ID to SQL statement
        command = sql_statements_result[i][0].replace(
            '\'VAR\'', str(customer_id)
        )
        command_result = db_interface.query(command, connect, customers_cursor)
        # get the query result
        value = str(command_result[0][0])
        audio_file = (
            directory + '/workflow/answers_tmp/' + str(call_id)
            + '[' + str(i) + '].' + init_audio_format
        )
        # make a voice value
        audio_file = recognition.text_to_speech(value, 'ru', audio_file)
        # convert to wav
        recognition.converter(audio_file, init_audio_format, 'wav')
        # point a relative path
        audio_file_rel_path = (
            'workflow/answers_tmp/' + str(call_id) + '[' + str(i) + '].wav'
        )
        # append the fibal result
        prepared_statements.append(audio_file_rel_path)

    merge_list = []
    # insert to merge list answers and templates one-by-one
    for j in range(len(answers_result)):
        try:
            answer_file = answers_result[j][0]
            merge_list.append(answer_file)
            merge_list.append(prepared_statements[j])
        except IndexError:
            pass
    # set the path to complete result
    out_file = (
        directory + '/workflow/answers/' + str(call_id) + '_answer' + '.wav'
    )
    # merge parts of response
    merged_file = recognition.merge_files(merge_list, out_file, directory)
    # success status if we have the file of full answer
    if os.path.exists(merged_file):
        status = 'success'
        return merged_file, status
    else:
        status = 'failed'
        return None, status


def record_log(call_agi_id, call_number, customer_id, request_id, call_status, answer_file):
    connect, cursor = db_interface.connect(
        host=native_db_host, port=native_db_port,
        db=native_db_name, user=native_db_user,
        password=native_db_password
    )
    # formatting INSERT query
    log_statement = (
        """INSERT INTO call_history
        (call_agi_id, call_timestamp, call_number, customer_id,
        request_id, call_status, answer_path)
        VALUES(%d, now(), \'%s\', %d, %d, \'%s\', \'%s\')"""
        % (call_agi_id, call_number, customer_id,
           request_id, call_status, answer_file)
    )
    db_interface.query(log_statement, connect, cursor, flag='insert')


if __name__ == '__main__':
    func = response(
        '/var/lib/asterisk/sounds/sip_response/workflow/text/request_1365506225',
        0, 0, '/var/lib/asterisk/sounds/sip_response', 1
    )
    print(func)
