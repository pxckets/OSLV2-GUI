#!/bin/bash

SOURCE_DIR=`pwd`
EXTERNAL_DIR_PATH="$SOURCE_DIR/External"
BOOST_URL="https://github.com/malbit/ofxiOSBoost.git"
BOOST_DIR_PATH="$EXTERNAL_DIR_PATH/ofxiOSBoost"
OPEN_SSL_URL="https://github.com/x2on/OpenSSL-for-iPhone.git"
OPEN_SSL_DIR_PATH="$EXTERNAL_DIR_PATH/OpenSSL"
ARQMA_GUI_URL="https://github.com/malbit/arqma-gui.git"
ARQMA_GUI_DIR_PATH="$EXTERNAL_DIR_PATH/arqma-gui"
ARQMA_URL="https://github.com/arqma/arqma.git"
ARQMA_DIR_PATH="$ARQMA_GUI_DIR_PATH/arqma"

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

echo "============================ Monero-gui ============================"

echo "Cloning arqma-gui from - $ARQMA_GUI_URL"
git clone -b build $ARQMA_GUI_URL $ARQMA_GUI_DIR_PATH
cd $ARQMA_GUI_DIR_PATH
echo "Cloning Arqma from - $ARQMA_URL to - $ARQMA_DIR_PATH"
git clone -b build $ARQMA_URL $ARQMA_DIR_PATH
echo "Export Boost vars"
export BOOST_LIBRARYDIR="`pwd`/../ofxiOSBoost/build/ios/prefix/lib"
export BOOST_INCLUDEDIR="`pwd`/../ofxiOSBoost/build/ios/prefix/include"
echo "Export OpenSSL vars"
export OPENSSL_INCLUDE_DIR="`pwd`/../OpenSSL/include"
export OPENSSL_ROOT_DIR="`pwd`/../OpenSSL/lib"
mkdir -p arqma/build
./ios_get_libwallet.api.sh
