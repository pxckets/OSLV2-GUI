#!/bin/bash

SOURCE_DIR=`pwd`
EXTERNAL_DIR_PATH="$SOURCE_DIR/../External"
BOOST_URL="https://github.com/malbit/ofxiOSBoost.git"
BOOST_DIR_PATH="$EXTERNAL_DIR_PATH/ofxiOSBoost"
OPEN_SSL_URL="https://github.com/x2on/OpenSSL-for-iPhone.git"
OPEN_SSL_DIR_PATH="$EXTERNAL_DIR_PATH/OpenSSL"
OSCILLATE_GUI_URL="https://github.com/malbit/oscillate-gui.git"
OSCILLATE_GUI_DIR_PATH="$SOURCE_DIR"
#OSCILLATE_URL="https://github.com/osl-coin/OSLV2.git"
OSCILLATE_DIR_PATH="$OSCILLATE_GUI_DIR_PATH/oscillate"

echo "Init external libs."
mkdir -p $EXTERNAL_DIR_PATH

echo "============================ Boost ============================"

echo "Cloning ofxiOSBoost from - $BOOST_URL"
git clone -b build $BOOST_URL $BOOST_DIR_PATH
cd $BOOST_DIR_PATH/scripts/
export BOOST_LIBS="random regex graph random chrono thread signals filesystem system date_time locale serialization program_options"
./build-libc++
cd $SOURCE_DIR

echo "============================ OpenSSL ============================"

echo "Cloning Open SSL from - $OPEN_SSL_URL"
git clone $OPEN_SSL_URL $OPEN_SSL_DIR_PATH
cd $OPEN_SSL_DIR_PATH
./build-libssl.sh --version=1.0.2j
cd $SOURCE_DIR

echo "============================ Oscillate-gui ============================"

#echo "Cloning oscillate-gui from - $OSCILLATE_GUI_URL"
#git clone $OSCILLATE_GUI_URL $OSCILLATE_GUI_DIR_PATH
#cd $OSCILLATE_GUI_DIR_PATH
#echo "Cloning Oscillate from - $OSCILLATE_URL to - $OSCILLATE_DIR_PATH"
#git clone -b build $OSCILLATE_URL $OSCILLATE_DIR_PATH
echo "Export Boost vars"
export BOOST_LIBRARYDIR="`pwd`/../ofxiOSBoost/build/ios/prefix/lib"
export BOOST_INCLUDEDIR="`pwd`/../ofxiOSBoost/build/ios/prefix/include"
echo "Export OpenSSL vars"
export OPENSSL_INCLUDE_DIR="`pwd`/../OpenSSL/include"
export OPENSSL_ROOT_DIR="`pwd`/../OpenSSL/lib"
mkdir -p oscillate/build
./ios_get_libwallet.api.sh
