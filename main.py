#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Main module of sip_response Asterisk add-on.
Responsible for dialplan data exchange and submodules call.
"""

import sys
import os
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
keyword_flag = agi.get_variable('keyword_flag')						#set keyword number
request_flag = agi.get_variable('request_flag')						#set request number
status = agi.get_variable('module_call')									#get status from asterisk
request_file_key = agi.get_variable('request_id')							#get file name
request_extension = agi.get_variable('file_extension')						#get file extension
# agi.verbose(status)
request_dir = '/var/lib/asterisk/sounds/sip_response'
if status == 'request':
	request_subdir = 'workflow/requests'
	request_file_key = 'request_685517063'
	request_file = request_dir + '/' + request_subdir + '/' + request_file_key + '.' + request_extension	#build full file name
	request_file = check_extension(request_file, request_extension)
	agi.verbose('request file: %s' % request_file)
	text_request = recognition.speech_to_text(request_file, request_dir, request_file_key)					#convert request to text
	agi.verbose('text request: %s' % text_request)
	audio_response, request_list_len, keyword_list_len = control.response(text_request, keyword_flag, request_flag, request_dir)								#get possible request
	agi.set_variable('request_list_len', request_list_len)
	agi.set_variable('keyword_list_len', keyword_list_len)
	agi.verbose('request_list_len: %s' % request_list_len)
	agi.verbose('keyword_list_len: %s' % keyword_list_len)
	wav_file = audio_response
	audio_response = recognition.converter(audio_response, 'wav', 'gsm')
	os.remove(wav_file)																						#convert to GSM for Asterisk playback
	agi.verbose('converted file: %s' % wav_file)
	key_length = agi.get_variable('keyword_list_len')
	req_len = agi.get_variable('request_list_len')
	agi.verbose('Keywords: %s' % key_length)
	agi.verbose('Requests: %s' % req_len)
if status == 'guess':
	positive = ['да', 'ага', 'согласен', 'разумеется', 'верно', 'так точно', \
				'несомненно', 'безусловно', 'истинно', 'угу', 'йес', 'действительно']
	negative = ['нет', 'ни хрена', 'неправда', 'да нет', 'ни в коем случае', \
				'ни фига', 'ни за что', 'никак', 'ничуть' ]
	request_subdir = 'workflow/guesses'
	request_file = request_dir + '/' + request_subdir + '/' + request_file_key + '.' + request_extension	#build full file name
	request_file = check_extension(request_file, request_extension)											#convert if it's not wav
	agi.verbose('full file path: %s' % request_file)
	request_text_file = recognition.speech_to_text(request_file, request_dir, request_file_key)					#convert request to text
	agi.verbose('full text file path: %s' % request_text_file)
	for line in open(request_text_file, 'r'):	#get request text
		request = line
	request = request.decode('utf-8').lower()
	guess = None
	for word in negative:
		if word in request:
			guess = 'no'
	if not guess:
		for word in positive:
			if word in request:
				guess = 'yes'
	if not guess:	guess = 'unrecognized'
	if guess == 'no':
		keyword_len = agi.get_variable('keyword_list_len')
		request_len = agi.get_variable('request_list_len')
		if request_flag + 1 < requests_len:
			agi.set_variable('request_flag', request_flag + 1)
		else:
			agi.set_variable('request_flag', 0)
			if keyword_flag + 1 < keywords_len:
				agi.set_variable('keyword_flag', keyword_flag + 1)
			else:
				agi.set_variable('keyword_flag', 0)
				guess = 'redirect'
	agi.set_variable('guess', guess)

	keyword_flag = agi.get_variable('keyword_flag')
	request_flag = agi.get_variable('request_flag')
	agi.verbose('request_flag: %s' % request_flag)
	agi.verbose('keyword_flag: %s' % keyword_flag)
	
	agi.verbose ('guess %s' % guess)
if status == 'auth':
	pass
if status == 'answer':
	pass