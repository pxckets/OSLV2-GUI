#!/bin/bash

# OpenSSL for iOS Build
git clone https://github.com/x2on/OpenSSL-for-iPhone.git && cd OpenSSL-for-iPhone \
  && ./build-libssl.sh --archs="arm64" --targets="ios64-cross-arm64" \
  && cd ..

# BOOST
cd iOS_Boost \
  && ./boost.sh -ios \
  && cd ..

# Building zxcvbn realistic password strength estimation
#cd src/zxcvbn-c \
#  && make & cd ..
