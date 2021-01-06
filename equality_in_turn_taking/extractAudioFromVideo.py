__author__ = 'Prerna Chikersal'

import os
from subprocess import call
dataPath = "/some/path"

sessionNames = ['cx066'] % This is just an example

print len(sessionNames)
inFolder = "skype_trim"
outFolder = "skype_audio"

for session in sessionNames:
    print session
    vid_path_a = dataPath+session+"a/"+inFolder+"/"
    aud_path_a = dataPath+session+"a/"+outFolder+"/"
    vid_path_b = dataPath+session+"b/"+inFolder+"/"
    aud_path_b = dataPath+session+"b/"+outFolder+"/"
    if not os.path.exists(aud_path_a):
        os.makedirs(aud_path_a)
        os.chmod(aud_path_a, 777)

    if not os.path.exists(aud_path_b):
        os.makedirs(aud_path_b)
        os.chmod(aud_path_b, 777)

    a_vids = []
    b_vids = []
    a_auds = []
    b_auds = []
    for file in os.listdir(vid_path_a):
        if file.endswith(".mp4"):
            a_vids.append(vid_path_a+file)
            a_auds.append(aud_path_a+file[0:-4]+".m4a")
    for file in os.listdir(vid_path_b):
        if file.endswith(".mp4"):
            b_vids.append(vid_path_b+file)
            b_auds.append(aud_path_b+file[0:-4]+".m4a")
    for i in range(0, len(a_vids)):
        vid = a_vids[i]
        aud = a_auds[i]
        call(["ffmpeg", "-i", vid, "-vn", "-c:a", "copy" , "-strict", "-2",  aud, "-y", "-loglevel", "panic"])

    for i in range(0, len(b_vids)):
        vid = b_vids[i]
        aud = b_auds[i]
        call(["ffmpeg", "-i", vid, "-vn", "-c:a", "copy" , "-strict", "-2", aud, "-y", "-loglevel", "panic"])






# ffmpeg -i input-video.avi -vn -acodec copy output-audio.aac
