#!/bin/bash
set -ex && mkdir -p ./build/release/bin
set -ex && docker create --name arqma-gui-container arqma-gui-image
set -ex && docker cp arqma-gui-container:/src/build/release/bin/ ./build/release/
set -ex && docker cp arqma-gui-container:/usr/local/lib/libzbar.a ./build/release/bin/libs
set -ex && docker rm arqma-gui-container
