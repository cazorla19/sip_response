# !/usr/bin/env python
#  -*- coding: utf-8 -*-

"""
Main module of sip_response Asterisk add-on.
Responsible for dialplan data exchange and submodules call.
"""

import sys
import os
import re
# import submodules
from asterisk.agi import *
from mods import recognition, control

reload(sys)
sys.setdefaultencoding('utf8')


def check_extension(request_file, request_extension):
    # check is it wav or not
    if request_extension != 'wav':
        # call converter if it's not wav
        request_file = recognition.converter(
            request_file, request_extension, 'wav'
        )
    return request_file

# initialize AGI instance
agi = AGI()

# print some stuff to ensure we connected
agi.verbose("python agi started")
callerId = agi.env['agi_callerid']
agi.verbose("call from %s" % callerId)

keyword_flag = int(agi.get_variable('keyword_flag'))
request_flag = int(agi.get_variable('request_flag'))
reform_flag = int(agi.get_variable('reform_flag'))
status = agi.get_variable('module_call')
request_file_key = agi.get_variable('request_id')
request_extension = agi.get_variable('file_extension')

agi.verbose(status)
agi.verbose('request_flag: %s' % request_flag)
agi.verbose('keyword_flag: %s' % keyword_flag)

request_dir = '/var/lib/asterisk/sounds/sip_response'


if status == 'request':
    request_subdir = 'workflow/requests'
    # build full file name
    request_file = (request_dir + '/' + request_subdir + '/' +
                    request_file_key + '.' + request_extension)
    request_file = check_extension(request_file, request_extension)

    # filesystem cleanup
    tmp_dirs = [
        'answers_tmp', 'auth', 'guesses', 'responses',
        'shelves', 'statements', 'text'
    ]
    for directory in tmp_dirs:
        full_path = request_dir + '/workflow/' + directory
        for root, dirs, files in os.walk(full_path, topdown=False):
            for name in files:
                full_name = os.path.join(root, name)
                # if full name is not related to request
                if request_file_key not in full_name:
                    os.remove(full_name)

    if keyword_flag > 0 or request_flag > 0:
        # if it's not first iteration - get the processed text file
        # cause we don't need to recognize the same request we did before
        text_request = agi.get_variable('response_text')
        keyword_scan = False
    else:
        # convert request to text
        text_request = recognition.speech_to_text(
            request_file, request_dir, request_file_key
        )
        keyword_scan = True
    # get possible request
    (audio_response, request_list_len,
     keyword_list_len, user_request_id) = control.response(
         text_request, keyword_flag,
         request_flag, request_dir, keyword_scan
    )
    # if no one keyword found in user request
    if not audio_response:
        if reform_flag == 0:
            # give the user one more attempt before redirect
            response = 'reform'
            agi.set_variable('reform_flag', 1)
        # if attempte was used - redirect to call-center
        else:
            response = 'redirect'
        agi.set_variable('response', response)
        agi.verbose('response: %s' % response)
        sys.exit(0)

    # set length of keywords and requests globally
    agi.set_variable('request_list_len', request_list_len)
    agi.set_variable('keyword_list_len', keyword_list_len)
    # request id will be used in answer
    agi.set_variable('user_request_id', user_request_id)

    agi.verbose('request_list_len: %s' % request_list_len)
    agi.verbose('keyword_list_len: %s' % keyword_list_len)
    agi.verbose('user_request_id: %s' % user_request_id)

    # check if request requires authentication
    auth_status = control.check_auth_status(user_request_id)
    agi.set_variable('auth_status', auth_status)
    wav_file = audio_response

    # convert response to GSM format for Asterisk playback
    audio_response = recognition.converter(audio_response, 'wav', 'gsm')
    agi.verbose('audio_response %s' % audio_response)
    response = 'ok'
    agi.set_variable('response', response)
    agi.verbose('response: %s' % response)


if status == 'guess':
    positive = [
        'да', 'ага', 'согласен', 'разумеется', 'верно',
        'так точно', 'несомненно', 'безусловно',
        'истинно', 'угу', 'йес', 'действительно'
    ]
    negative = [
        'нет', 'ни хрена', 'неправда',
        'да нет', 'ни в коем случае',
        'ни фига', 'ни за что', 'никак', 'ничуть'
    ]
    request_subdir = 'workflow/guesses'

    # build full file name
    request_file = (request_dir + '/' + request_subdir + '/'
                    + request_file_key + '.' + request_extension)
    # convert if it's not wav
    request_file = check_extension(request_file, request_extension)
    # convert request to text
    request_text_file = recognition.speech_to_text(
        request_file, request_dir, request_file_key, flag='guess'
    )

    # remove guess suffix to determine original request path
    response_text_file = re.sub('_guess$', '', request_text_file)
    # set request path in case of next request iteration
    agi.set_variable('response_text', response_text_file)
    # get request text
    for line in open(request_text_file, 'r'):
        request = line
    # decode Russian cyrrilic

    request = request.decode('utf-8').lower()
    # start to guess was response true or not
    guess = None
    for word in negative:
        # response wasn't true if we found negative in text
        if word in request:
            guess = 'no'
    if not guess:
        for word in positive:
            # if we found positive word - response was true
            if word in request:
                guess = 'yes'
    if not guess:
        guess = 'unrecognized'

    if guess == 'no':
        keyword_len = int(agi.get_variable('keyword_list_len'))
        request_len = int(agi.get_variable('request_list_len'))
        keyword_next = keyword_flag + 1
        request_next = request_flag + 1
        # if next request index exists - switch the request flag
        if request_next < request_len:
            agi.set_variable('request_flag', request_next)
        # otherwise go to the next keyword
        else:
            agi.set_variable('request_flag', 0)
            # flip keyword flag if we have more keywords
            if keyword_next < keyword_len:
                agi.set_variable('keyword_flag', keyword_next)
            else:
                # otherwise there is no option to guess; reform call
                agi.set_variable('keyword_flag', 0)
                # give the user one more attempt before redirect
                if reform_flag == 0:
                    guess = 'reform'
                else:
                    guess = 'redirect'

    # tell dialplan result
    agi.set_variable('guess', guess)
    agi.verbose('guess %s' % guess)

    if guess == 'reform':
        agi.set_variable('reform_flag', 1)


# verify user identity
if status == 'auth':
    # get request field (name/cvv-code/credit card numbers/card code)
    field = agi.get_variable('auth_subrequest')
    user_request_id = int(agi.get_variable('user_request_id'))
    agi.verbose('auth_subrequest %s' % field)
    request_subdir = 'workflow/auth'
    # build full file name
    request_file = (
        request_dir + '/' + request_subdir + '/'
        + request_file_key + '.' + request_extension
    )
    # convert if it's not wav
    request_file = check_extension(request_file, request_extension)
    # convert request to text
    request_text_file = recognition.speech_to_text(
        request_file, request_dir, request_file_key, flag='auth'
    )
    agi.verbose('request_text_file %s' % request_text_file)

    # call control module function depending on the subrequest
    if field == 'name':
        auth_result, customer_id = control.auth_name(
            request_text_file, user_request_id
        )
    # get customer id after name authentication
        agi.set_variable('customer_id', customer_id)
        agi.verbose('customer_id: %s' % customer_id)
    else:
        customer_id = int(agi.get_variable('customer_id'))
        auth_result = control.auth_credentials(
            field, request_text_file, customer_id
        )
    # failed flag records the fact of repetitive authentication
    auth_failed_flag = int(agi.get_variable('auth_failed_flag'))

    # switch flag back if request succeeded
    if auth_result == 'success':
        agi.set_variable('auth_failed_flag', 0)
    # set the label one attempt is left
    elif auth_result == 'failed' and auth_failed_flag == 0:
        agi.set_variable('auth_failed_flag', 1)
    # redirect if all attempts are gone
    elif auth_result == 'failed' and auth_failed_flag == 1:
        auth_result = 'redirect'

    # tell dialplan what's the final result
    agi.set_variable('auth_result', auth_result)
    agi.verbose('auth_result: %s' % auth_result)


if status == 'answer':
    # 2 items to generate answer: request id and call id
    user_request_id = int(agi.get_variable('user_request_id'))
    customer_id = int(agi.get_variable('customer_id'))
    agi.verbose('user_request_id: %s' % user_request_id)
    agi.verbose('customer_id: %s' % customer_id)

    # send arguments to the function
    answer_file, answer_status = control.answer(
        user_request_id, customer_id, request_file_key, request_dir
    )
    agi.verbose('answer_status: %s' % answer_status)

    # convert response to GSM format for Asterisk playback
    audio_response = recognition.converter(answer_file, 'wav', 'gsm')
    agi.set_variable('call_status', answer_status)
    agi.set_variable('answer_file', audio_response)


# logging each call
if status == 'log':
    # get all parameters we need
    user_request_id = int(agi.get_variable('user_request_id'))
    customer_id = int(agi.get_variable('customer_id'))
    answer_file = agi.get_variable('answer_file')
    call_status = agi.get_variable('call_status')
    agi_call_id = int(request_file_key.split('_')[1])

    agi.verbose(
        'arguments: %d %s %d %d %s %s'
        % (agi_call_id, callerId, customer_id,
           user_request_id, call_status, answer_file)
    )
    # call control module to record logs
    logging = control.record_log(
        agi_call_id, callerId, customer_id,
        user_request_id, call_status, answer_file
    )
    agi.verbose('logging succeeded')
