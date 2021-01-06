__author__ = 'Prerna Chikersal'

import os
from subprocess import call
dataPath = "/some/path"

sessionNames = ['cx044', 'cx055'] % This is just an example

print len(sessionNames)
inFolder = "skype_trim"
outFolder = "skype_audio"

for session in sessionNames:
    print session
    path_a = dataPath+session+"a/"
    vid_path_a = path_a+inFolder+"/"
    aud_path_a = path_a+outFolder+"/"
    path_b = dataPath+session+"b/"
    vid_path_b = path_b+inFolder+"/"
    aud_path_b = path_b+outFolder+"/"
    if not os.path.exists(aud_path_a):
        # os.chmod(path_a, 777)
        os.makedirs(aud_path_a)
        # os.chmod(aud_path_a, 777)
    if not os.path.exists(aud_path_b):
        # os.chmod(path_b, 777)
        os.makedirs(aud_path_b)
        # os.chmod(aud_path_b, 777)
    a_vids = []
    b_vids = []
    a_auds = []
    b_auds = []
    for file in os.listdir(vid_path_a):
        if file.endswith(".mp4"):
            a_vids.append(vid_path_a+file)
            a_auds.append(aud_path_a+file[0:-4]+".wav")
    for file in os.listdir(vid_path_b):
        if file.endswith(".mp4"):
            b_vids.append(vid_path_b+file)
            b_auds.append(aud_path_b+file[0:-4]+".wav")
    for i in range(0, len(a_vids)):
        vid = a_vids[i]
        aud = a_auds[i]
        print (aud)
        call(["ffmpeg", "-i", vid, "-vn", aud, "-y", "-loglevel", "panic"])
        #call(["ffmpeg", "-i", vid, "-vn", "-c:a", "copy" , "-strict", "-2",  aud, "-y", "-loglevel", "panic"])

    for i in range(0, len(b_vids)):
        vid = b_vids[i]
        aud = b_auds[i]
        print (aud)
        call(["ffmpeg", "-i", vid, "-vn", aud, "-y", "-loglevel", "panic"])
        #call(["ffmpeg", "-i", vid, "-vn", "-c:a", "copy" , "-strict", "-2", aud, "-y", "-loglevel", "panic"])






#ffmpeg -i input-video.avi -vn -acodec copy output-audio.aac
