#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Main module of sip_response Asterisk add-on.
Responsible for dialplan data exchange and submodules call.
"""

import sys
import os
import re
from mods import recognition, control	#import submodules
from asterisk.agi import *				#pyst2

reload(sys)
sys.setdefaultencoding('utf8')

def check_extension(request_file, request_extension):	#check is it wav or not
	if request_extension != 'wav':
		request_file = recognition.converter(request_file, request_extension, 'wav')	#call converter if it's not wav
	return request_file

agi = AGI()							#initialize AGI instance
agi.verbose("python agi started")		#print some stuff to ensure we connected
callerId = agi.env['agi_callerid']
agi.verbose("call from %s" % callerId)
#in case of repetitive request guess operation
keyword_flag = int(agi.get_variable('keyword_flag'))						#set keyword number
request_flag = int(agi.get_variable('request_flag'))						#set request number
reform_flag = int(agi.get_variable('reform_flag'))							#set the reform trigger
status = agi.get_variable('module_call')									#get status from asterisk
request_file_key = agi.get_variable('request_id')							#get file name
request_extension = agi.get_variable('file_extension')						#get file extension
agi.verbose(status)
agi.verbose('request_flag: %s' % request_flag)
agi.verbose('keyword_flag: %s' % keyword_flag)
request_dir = '/var/lib/asterisk/sounds/sip_response'
if status == 'request':
	request_subdir = 'workflow/requests'
	request_file = request_dir + '/' + request_subdir + '/' + request_file_key + '.' + request_extension	#build full file name
	request_file = check_extension(request_file, request_extension)
	if keyword_flag > 0 or request_flag > 0:																
		#if it's not first iteration - get the processed text file
		#cause we don't need to recognize the same request we did before
		text_request = agi.get_variable('response_text')
		keyword_scan = False									
	else:
		text_request = recognition.speech_to_text(request_file, request_dir, request_file_key)					#convert request to text
		keyword_scan = True
	audio_response, request_list_len, keyword_list_len, user_request_id = control.response(text_request, keyword_flag, request_flag, request_dir, keyword_scan)			#get possible request
	if not audio_response:														#if no one keyword found in user request
		if reform_flag == 0:
			response = 'reform'													#give the user one more attempt to send request before redirect
			agi.set_variable('reform_flag', 1)
		else:
			response = 'redirect'												#if attempte was used - redirect to call-center
		agi.set_variable('response', response)
		agi.verbose('response: %s' % response)
		sys.exit(0)
	agi.set_variable('request_list_len', request_list_len)						#set length of keywords and requests globally
	agi.set_variable('keyword_list_len', keyword_list_len)
	agi.set_variable('user_request_id', user_request_id)						#request id will be used in answer
	agi.verbose('request_list_len: %s' % request_list_len)
	agi.verbose('keyword_list_len: %s' % keyword_list_len)
	agi.verbose('user_request_id: %s' % user_request_id)
	wav_file = audio_response
	audio_response = recognition.converter(audio_response, 'wav', 'gsm')		#convert response to GSM format for Asterisk playback
	agi.verbose('audio_response %s' % audio_response)
	response = 'ok'
	agi.set_variable('response', response)										#set response is OK
	agi.verbose('response: %s' % response)
if status == 'guess':
	positive = ['да', 'ага', 'согласен', 'разумеется', 'верно', 'так точно', \
				'несомненно', 'безусловно', 'истинно', 'угу', 'йес', 'действительно']
	negative = ['нет', 'ни хрена', 'неправда', 'да нет', 'ни в коем случае', \
				'ни фига', 'ни за что', 'никак', 'ничуть' ]
	request_subdir = 'workflow/guesses'
	request_file = request_dir + '/' + request_subdir + '/' + request_file_key + '.' + request_extension	#build full file name
	request_file = check_extension(request_file, request_extension)											#convert if it's not wav
	request_text_file = recognition.speech_to_text(request_file, request_dir, request_file_key, flag='guess')				#convert request to text
	response_text_file = re.sub('_guess$', '', request_text_file)											#remove guess suffix to determine original request path
	agi.set_variable('response_text', response_text_file)													#set request path in case of next request iteration
	for line in open(request_text_file, 'r'):																#get request text
		request = line
	request = request.decode('utf-8').lower()																#decode Russian cyrrilic
	guess = None																							#start to guess was response true or not
	for word in negative:
		if word in request:																					#response wasn't true if we found negative in text
			guess = 'no'
	if not guess:
		for word in positive:
			if word in request:																				#if we found positive word - response was true
				guess = 'yes'
	if not guess:	guess = 'unrecognized'
	if guess == 'no':
		keyword_len = int(agi.get_variable('keyword_list_len'))
		request_len = int(agi.get_variable('request_list_len'))
		keyword_next = keyword_flag + 1
		request_next = request_flag + 1
		if request_next < request_len:																		#if next request index exists in overall array - switch the request flag
			agi.set_variable('request_flag', request_next)
		else:
			agi.set_variable('request_flag', 0)																#otherwise go to the next keyword
			if keyword_next < keyword_len:																	#flip keyword flag if we have more keywords
				agi.set_variable('keyword_flag', keyword_next)
			else:
				agi.set_variable('keyword_flag', 0)															#otherwise there is no option to guess; reform call
				if reform_flag == 0:	guess = 'reform'													#give the user one more attempt to send request before redirect
				else:					guess = 'redirect'

	agi.set_variable('guess', guess)																		#tell dialplan result
	agi.verbose ('guess %s' % guess)
	if guess == 'reform':
		agi.set_variable('reform_flag', 1)
if status == 'auth':																						#verify user identity
	field = agi.get_variable('auth_subrequest')																#get request field (name/cvv-code/credit card numbers/card code)
	agi.verbose('auth_subrequest %s' % field)
	request_subdir = 'workflow/auth'
	request_file = request_dir + '/' + request_subdir + '/' + request_file_key + '.' + request_extension					#build full file name
	request_file = check_extension(request_file, request_extension)															#convert if it's not wav
	request_text_file = recognition.speech_to_text(request_file, request_dir, request_file_key, flag='auth')				#convert request to text
	agi.verbose('request_text_file %s' % request_text_file)
	if field == 'name':																						#call control module function depending on the subrequest
		auth_result, customer_id = control.auth_name(request_text_file)
		agi.set_variable('customer_id', customer_id)														#get customer id after name authentication
		agi.verbose('customer_id: %s' % customer_id)
	else:
		customer_id = int(agi.get_variable('customer_id'))
		auth_result = control.auth_credentials(field, request_text_file, customer_id)
	auth_failed_flag = int(agi.get_variable('auth_failed_flag'))											#failed flag records the fact of repetitive authentication
	if auth_result == 'success':								agi.set_variable('auth_failed_flag', 0)		#switch flag back if request succeeded
	elif auth_result == 'failed' and auth_failed_flag == 0:		agi.set_variable('auth_failed_flag', 1)		#set the label one attempt is left
	elif auth_result == 'failed' and auth_failed_flag == 1:		auth_result = 'redirect'					#redirect if all attempts are gone
	agi.set_variable('auth_result', auth_result)															#tell dialplan what's the final result
	agi.verbose('auth_result: %s' % auth_result)	
if status == 'answer':
	user_request_id = int(agi.get_variable('user_request_id'))												#2 items to generate answer: request id and call id
	customer_id = int(agi.get_variable('customer_id'))
	agi.verbose('user_request_id: %s' % user_request_id)
	agi.verbose('customer_id: %s' % customer_id)
	answer_file, answer_status = control.answer(user_request_id, customer_id, request_file_key, request_dir)	#send arguments to the function
	agi.verbose('answer_status: %s' % answer_status)
	audio_response = recognition.converter(answer_file, 'wav', 'gsm')										#convert response to GSM format for Asterisk playback
	agi.set_variable('answer', answer_status)