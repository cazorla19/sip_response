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
keyword_flag = 0						#set keywword number
request_flag = 0						#set request number
status = agi.get_variable('module_call')			#get status from asterisk
request_file_key = agi.get_variable('request_id')				#get file name
request_extension = agi.get_variable('file_extension')			#get file extension
agi.verbose(status)
request_dir = '/var/lib/asterisk/sounds/sip_response'
if status == 'request':
	request_subdir = 'workflow/requests'
	request_file = request_dir + '/' + request_subdir + '/' + request_file_key + '.' + request_extension	#build full file name
	request_file = check_extension(request_file, request_extension)
	text_request = recognition.speech_to_text(request_file, request_dir, request_file_key)					#convert request to text
	audio_response = control.response(text_request, keyword_flag, request_flag, request_dir)								#get possible request
	wav_file = audio_response
	audio_response = recognition.converter(audio_response, 'wav', 'gsm')
	os.remove(wav_file)																						#convert to GSM for Asterisk playback
	agi.verbose('audio_response %s' % audio_response)
	agi.set_variable('response', audio_response)															#set path to file
if status == 'guess':
	positive = ['да', 'ага', 'согласен', 'разумеется', 'верно', 'так точно', \
				'несомненно', 'безусловно', 'истинно', 'угу', 'йес', 'действительно']
	negative = ['нет', 'ни хрена', 'неправда', 'да нет', 'ни в коем случае', \
				'ни фига', 'ни за что', 'никак', 'ничуть' ]
	request_subdir = 'workflow/guesses'
	request_file = request_dir + '/' + request_subdir + '/' + request_file_key + '.' + request_extension	#build full file name
	request_file = check_extension(request_file, request_extension)											#convert if it's not wav
	request_text_file = recognition.speech_to_text(request_file, request_dir, request_file_key)					#convert request to text
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
	agi.verbose ('guess %s' % guess)
	agi.set_variable('guess', guess)
