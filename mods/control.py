#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Submodule for requests processing
"""

import db_interface			#for DB connections
import recognition
import sys
import shelve
from asterisk.agi import *

"""
TO DO!
Set length of requests results and pass to AGI
"""

reload(sys)
sys.setdefaultencoding('utf8')

def response(text_file, keyword_flag, request_flag, directory, keyword_scan):	#function to response initial user request
	for line in open(text_file, 'r'):	#get request text
		request = line
	request = request.decode('utf-8').lower()
	request_id = text_file.split('/')[-1]
	shelve_file = directory + '/workflow/shelves/' + request_id
	cursor = db_interface.connect(db='sip_response', user='cazorla19', password='123456')
	if keyword_scan:
		keyword_file = shelve.open(shelve_file)
		statement = 'SELECT phrase FROM keywords'
		result = db_interface.query(statement, cursor)											#make query to look for a possible keywords
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
	if key_len == 0:																		#if no one keyword found - return empty values
		return 0, 0, 0
	word = options[keyword_flag]															#get one keyword in order to flag
	request_statement = 'SELECT phrase, sound_path FROM requests WHERE id IN (SELECT request_id FROM requests_keywords WHERE keyword_id = (SELECT id FROM keywords WHERE phrase = \'%s\'))' % (word)
	result = db_interface.query(request_statement, cursor)									#find out list of appropriate requests and these sounds
	req_len = len(result)
	request = result[request_flag][0]
	phrase_audio_file = result[request_flag][1]
	templates_statement = 'SELECT sound_path FROM templates WHERE id IN (SELECT template_id FROM requests_templates WHERE request_id = (SELECT id FROM requests WHERE phrase = \'%s\'));' % (request)
	templates = db_interface.query(templates_statement, cursor)	#find out templates
	merge_list = [templates[0][0], phrase_audio_file]			#generate list of files to merge
	if len(templates) > 1:
		for template in templates[1:]:
			merge_list.append(template[0])
	out_file = directory + '/workflow/responses/' + request_id + '_response' + '.wav'	#generate response file name
	merged_file = recognition.merge_files(merge_list, out_file, directory)									#merge parts of response
	return merged_file, req_len, key_len

if __name__ == '__main__':																			#test the function
	func = response('/var/lib/asterisk/sounds/sip_response/workflow/text/request_977564821', 0, 0, '/var/lib/asterisk/sounds/sip_response')
	print(func)
