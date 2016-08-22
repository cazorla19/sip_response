#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Submodule for audiofile conversion and speech recognition
"""


def converter(con_file, in_extension, out_extension):
	input_file_key = con_file.split('.')[0]			#get file name with no extension
	output_file = input_file_key + '.' + out_extension			#generate new file name

	if out_extension == 'gsm':									#i'm not sure ffmpeg fully supports gsm
		import os 												#so, let's try sox
		os.system('sox %s -r 8000 %s' % (con_file, output_file))
	else:														#but usually go with ffmpeg and pydub
		from pydub import AudioSegment
		input_segment = AudioSegment.from_file(con_file, in_extension)			#create new special BLOB object
		output_segment = input_segment.export(output_file, format=out_extension)	#convert BLOB object to wav file
	return output_file

def speech_to_text(myfile, directory, key, flag=None):
	import speech_recognition as sr

	r = sr.Recognizer()						#create new object
	r.energy_threshold = 1000				#set big energy threshold
	r.pause_threshold = 2					#set appropriate pause threshold

	with sr.AudioFile(myfile) as source:
		audio = r.listen(source)			#create audio BLOB to recognize

	engines = ['google', 'wit.ai', 'microsoft', 'api.ai']		#set list of supported engines
	for engine in engines:
		try:		#Google in priority but they have 50 API calls limit
			if engine == 'google':			text = r.recognize_google(audio, key='AIzaSyD__ovqKNa7PSf0Xabf0CPtBbbWeckD_EI', language='ru-RU')
			elif engine == 'wit.ai':		text = r.recognize_wit(audio, key='EZWIEEGQQT5CELKOZS7HT3L6LEY6NJXK')
			elif engine == 'microsoft':		text = r.recognize_bing(audio, key='338eb14c85b54534b8e66bd51ecc0ef8', language='ru-RU')
			elif engine == 'api.ai':		text = r.recognize_api(audio, client_access_token = 'd56167192e114d2f99389ecaa97c4164', language='ru')
			if text:											#close the loop if we've got a text
				break
		except sr.UnknownValueError, sr.RequestError:			#if any engine was broken - go to the next
			continue

	text_file = directory + '/workflow/text/' + key 			#generate text file name
	if flag:		text_file = text_file + '_' + flag			#if it`s guess - assign special suffix to skip original request overwrite
	with open(text_file, 'w') as text_store:
		text_store.write(text.encode('utf-8'))					#write result to file
	return text_file											#return path to file

def merge_files(merge_list, out_file, directory):				#merge some audio files into one
	from pydub import AudioSegment
	
	full_path_list = []
	for f in merge_list:
		full_path_file = directory + '/' + f
		full_path_list.append(full_path_file)

	out_sound = AudioSegment.from_file(full_path_list[0])	#record first sound

	for audio_file in full_path_list[1:]:					#append others		sound = AudioSegment.from_file(audio_file)
		sound = AudioSegment.from_file(audio_file)
		out_sound += sound

	out_sound.export(out_file, format='wav')			#export sound we've got
	return out_file
