#!/usr/bin/env python2
sourcedir = 'D:/Music/'
targetdir = 'D:/ogg/'
convertExts = ('.flac', '.m4a', '.wav')
noCopyExts = ('.zip', '.sh', '.part', '.gif', '.log', '.cue', '.CUE', '.m3u', '.avi', '.mp4', '.txt', '.nsf', '.it', '.sfv', '.pdf', '.swp', '.mov')
bitrate = '128k'
import os, subprocess, shutil
for root, dirs, files in os.walk(ur""+sourcedir, topdown=True):
    newroot = root.replace(sourcedir, targetdir)
    if '.no-oggify' in files:
        dirs[:] = []
        if os.path.exists(newroot): shutil.rmtree(newroot)
    else:
        if not os.path.exists(newroot): os.makedirs(newroot);
        for file in [a for a in files if a.lower().endswith(convertExts)]:
            if not os.path.exists(newroot+'/'+file+'.ogg'):
                subprocess.call(['ffmpeg', '-i', root+'/'+file, '-c:a', 'libvorbis', '-b:1', bitrate, '-vn', newroot+'/'+file+'.ogg'],
                        stdout=open(os.devnull, 'wb'), stderr=open(os.devnull, 'wb'));
                print newroot+'/'+file+'.ogg'
        for file in [a for a in files if not a.lower().endswith(convertExts) and not a.lower().endswith(noCopyExts)]:
            if not os.path.exists(newroot+'/'+file):
                shutil.copyfile(root+'/'+file, newroot+'/'+file)
                print newroot+'/'+file
for root, dirs, files in os.walk(ur""+targetdir, topdown=True):
    oldroot = root.replace(targetdir, sourcedir)
    if not os.path.exists(oldroot) or os.path.isfile(oldroot + '/.no-oggify'):
        dirs[:] = []
        shutil.rmtree(root)
    else:
        for file in [a for a in files if a.endswith('.ogg') and a[:-4].lower().endswith(convertExts)]:
            if not os.path.isfile(oldroot+'/'+file[:-4]): os.remove(root+'/'+file)
        for file in [a for a in files if not a.lower().endswith('.ogg')]:
            if not os.path.exists(oldroot) or not os.path.isfile(oldroot+'/'+file): os.remove(root+'/'+file)
