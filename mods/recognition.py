# !/usr/bin/env python
#  -*- coding: utf-8 -*-

"""
Submodule for audiofile conversion and speech recognition
"""


def converter(con_file, in_extension, out_extension):
    import os
    # get file name with no extension
    input_file_key = con_file.split('.')[0]
    # generate new file name
    output_file = input_file_key + '.' + out_extension

    # i'm not sure ffmpeg fully supports gsm
    if out_extension == 'gsm':
        # so, let's try sox
        os.system('sox %s -r 8000 %s' % (con_file, output_file))
    # but usually go with ffmpeg and pydub
    else:
        from pydub import AudioSegment
        # create new special BLOB object
        input_segment = AudioSegment.from_file(
            con_file, in_extension
        )
        # convert BLOB object to wav file
        input_segment.export(output_file, format=out_extension)
    os.remove(con_file)
    return output_file


def speech_to_text(myfile, directory, key, flag=None):
    import speech_recognition as sr
    import ConfigParser

    r = sr.Recognizer()
    r.energy_threshold = 300
    r.pause_threshold = 2

    # getting credentials from log file
    config = ConfigParser.ConfigParser()
    config.read("/var/lib/asterisk/agi-bin/sip_response/myresponse.conf")
    google_key = config.get('recognition', 'google_api_key')
    wit_key = config.get('recognition', 'wit_api_key')

    with sr.AudioFile(myfile) as source:
        audio = r.listen(source)            # create audio BLOB to recognize

    # Google in priority but they have 50 API calls limit
    # if Google was broken - go to the next
    try:
        text = r.recognize_google(audio, key=google_key, language='ru-RU')
    except(sr.UnknownValueError, sr.RequestError):
        text = r.recognize_wit(audio, key=wit_key)

    # generate text file name
    text_file = directory + '/workflow/text/' + key
    # assign special suffix to skip original request overwrite
    if flag:
        text_file = text_file + '_' + flag
    # write result to file
    with open(text_file, 'w') as text_store:
        text_store.write(text.encode('utf-8'))
    # return path to file
    return text_file


# merge some audio files into one
def merge_files(merge_list, out_file, directory):
    from pydub import AudioSegment

    full_path_list = []
    for f in merge_list:
        full_path_file = directory + '/' + f
        full_path_list.append(full_path_file)

    # record first sound
    out_sound = AudioSegment.from_file(full_path_list[0])

    # append others
    for audio_file in full_path_list[1:]:
        sound = AudioSegment.from_file(audio_file)
        out_sound += sound

    # export sound we've got
    out_sound.export(out_file, format='wav')
    return out_file


def text_to_speech(text, language, out_file):
    # import google Text-to-speech
    from gtts import gTTS
    tts = gTTS(text=text, lang=language)
    tts.save(out_file)
    return out_file


# test the function
if __name__ == '__main__':
    func = speech_to_text(
        '/var/lib/asterisk/sounds/sip_response/workflow/requests/request_1365506225.wav',
        '/var/lib/asterisk/sounds/sip_response', 'request_1365506225'
    )
    for line in open(func, 'r'):
        print(line)