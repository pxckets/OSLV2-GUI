Copyright (c) 2018, The Oscillate Network
Copyright (c) 2014-2018, The Monero Project


## Current status : ALPHA

 - Minimum Android 5.0 (api level 21)
 - Modal dialogs can appear in background giving the feeling that the application is frozen (Work around : turn screen off/on or switch to another app and back)

## Build using Docker

# Base environnement

        git clone https://github.com/osl-coin/OSLV2.git -b release-v0.2.2 --recursive
        cd oscillate
        docker build -f utils/build_scripts/android32.Dockerfile -t oscillate-android .
        cd ..

# Build GUI

        docker build -t android/docker/oscillate-gui-android .
        docker create -it --name oscillate-gui-android oscillate-gui-android bash

# Get the apk

        docker cp oscillate-gui-android:/opt/android/oscillate-gui/build/release/bin/bin/QtApp-debug.apk .

## Deployment

- Using ADB (Android debugger bridge) :

  First, see section [Enable adb debugging on your device](https://developer.android.com/studio/command-line/adb.html#Enabling)
  The only place where we are allowed to play is `/data/local/tmp`. So :

        adb  push /opt/android/oscillate-gui/build/release/bin/bin/QtApp-debug.apk /data/local/tmp
        adb  shell pm install -r /data/local/tmp/QtApp-debug.apk
   
  - Troubleshooting:

        adb devices -l
        adb logcat

    if using adb inside docker, make sure you did "docker run -v /dev/bus/usb:/dev/bus/usb --privileged"

- Using a web server

        mkdir /usr/tmp
        cp QtApp-debug.apk /usr/tmp
        docker run -d -v /usr/tmp:/usr/share/nginx/html:ro -p 8080:80 nginx

  Now it should be accessible through a web browser at

        http://<your.local.ip>:8080/QtApp-debug.apk
