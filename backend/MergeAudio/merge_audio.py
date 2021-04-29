from pydub import AudioSegment
import os

#if we're only using wav, make sure files are wav
def check_wav(file):
    return (file[-3:] == 'wav')

def merge_audio_files(files, export_location):
    #minute long canvas segment to overlay sounds on (so that tracks shorter than 1 minute aren't truncated)
    result_sound = AudioSegment.silent(duration=60000)
    for f in files:
        #AudioSegment.from_file("ex1.wav", format="wav") - if we're only using wav
        # overlay_sound = AudioSegment.from_file(f, format='wav')
        overlay_sound = AudioSegment.from_file(f)
        result_sound = result_sound.overlay(overlay_sound, position=0)

    #remove file if it exists at this location
    if os.path.isfile(export_location):
        os.remove(export_location)

    #exp = result_sound.export(export_location, format="wav") - if we're only using wav
    exp = result_sound.export(export_location, format='wav')

def write_to_wav(aac_file):
    name, file_type = aac_file.split('.')
    assert file_type == 'aac'

    new_name = name + '.wav'
    sound = AudioSegment.from_file(aac_file)
    sound.export(new_name, format='wav', bitrate='128k')
    return new_name

def write_to_aac(wav_file):
    name, file_type = wav_file.split('.')
    assert file_type == 'wav'

    new_name = name + '.aac'
    sound = AudioSegment.from_file(wav_file)
    sound.export(new_name, format='adts', bitrate='128k')
    return new_name


if __name__ == "__main__":
    files = ['ex1.wav', 'ex2.wav']
    merge_audio_files(files, 'test_output.wav')
    # write_to_wav('test.aac')
