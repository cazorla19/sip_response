#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Submodule for audiofile conversion and speech recognition
"""


def converter(con_file, in_extension, out_extension):
	import os
	input_file_key = con_file.split('.')[0]			#get file name with no extension
	output_file = input_file_key + '.' + out_extension			#generate new file name

	if out_extension == 'gsm':									#i'm not sure ffmpeg fully supports gsm
		import os 												#so, let's try sox
		os.system('sox %s -r 8000 %s' % (con_file, output_file))
	else:														#but usually go with ffmpeg and pydub
		from pydub import AudioSegment
		input_segment = AudioSegment.from_file(con_file, in_extension)			#create new special BLOB object
		output_segment = input_segment.export(output_file, format=out_extension)	#convert BLOB object to wav file
	os.remove(con_file)
	return output_file

def speech_to_text(myfile, directory, key, flag=None):
	import speech_recognition as sr
	import ConfigParser

	r = sr.Recognizer()						#create new object
	r.energy_threshold = 300				#set energy threshold
	r.pause_threshold = 2					#set appropriate pause threshold

	config = ConfigParser.ConfigParser()										#getting credentials from log file
	config.read("/var/lib/asterisk/agi-bin/sip_response/myresponse.conf")
	google_key = config.get('recognition', 'google_api_key')
	wit_key = config.get('recognition', 'wit_api_key')

	with sr.AudioFile(myfile) as source:
		audio = r.listen(source)			#create audio BLOB to recognize

	try:																
		text = r.recognize_google(audio, key=google_key, language='ru-RU') #Google in priority but they have 50 API calls limit
	except sr.UnknownValueError, sr.RequestError:														#if Google was broken - go to the next
		text = r.recognize_wit(audio, key=wit_key)

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

def text_to_speech(text, language, out_file):
	from gtts import gTTS 								#import google Text-to-speech
	tts = gTTS(text=text, lang=language)				#set the text and language
	tts.save(out_file)									#save result to file
	return out_file

if __name__ == '__main__':																			#test the function
	func = speech_to_text('/var/lib/asterisk/sounds/sip_response/workflow/requests/request_1365506225.wav', '/var/lib/asterisk/sounds/sip_response', 'request_1365506225')
	for line in open(func, 'r'):
		print(line)