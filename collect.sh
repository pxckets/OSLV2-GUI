#!/bin/bash
set -ex && mkdir -p ./build/release/bin
set -ex && docker create --name oscillate-gui-container oscillate-gui-image
set -ex && docker cp oscillate-gui-container:/src/build/release/bin/ ./build/release/
set -ex && docker cp oscillate-gui-container:/usr/local/lib/libzbar.a ./build/release/bin/libs
set -ex && docker rm oscillate-gui-container
