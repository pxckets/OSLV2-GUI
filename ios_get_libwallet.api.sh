#!/bin/bash -e

# 3 header files required by monero are missing from the IOS SDK. I copied them from iphoneSimulator SDK
# cd /Applications/XCode.app
# sudo cp ./Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/usr/include/sys/vmmeter.h ./Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include/sys/
# sudo cp ./Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/usr/include/netinet/udp_var.h ./Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include/netinet/
# sudo cp ./Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/usr/include/netinet/ip_var.h ./Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include/netinet/


if [ -z $BUILD_TYPE ]; then
    BUILD_TYPE=release
fi

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z $BOOST_LIBRARYDIR ]; then
    BOOST_LIBRARYDIR=${ROOT_DIR}/iOS_Boost/build/boost/1.68.0/ios/prefix/lib
fi
if [ -z $BOOST_INCLUDEDIR ]; then
    BOOST_INCLUDEDIR=${ROOT_DIR}/iOS_Boost/build/boost/1.68.0/ios/prefix/include
fi
if [ -z $OPENSSL_INCLUDE_DIR ]; then
    OPENSSL_INCLUDE_DIR=${ROOT_DIR}/OpenSSL-for-iPhone/include
fi
if [ -z $OPENSSL_ROOT_DIR ]; then
    OPENSSL_ROOT_DIR=${ROOT_DIR}/OpenSSL-for-iPhone
fi

#echo "Building IOS armv7"
#rm -r arqma/build > /dev/null
#mkdir -p arqma/build/release
#pushd arqma/build/release
#cmake -D IOS=ON -D ARCH=armv7 -D BOOST_LIBRARYDIR=${BOOST_INCLUDEDIR} -D BOOST_INCLUDEDIR=${BOOST_INCLUDEDIR} -D OPENSSL_INCLUDE_DIR=${OPENSSL_INCLUDE_DIR} -D OPENSSL_ROOT_DIR=${OPENSSL_ROOT_DIR} -D CMAKE_BUILD_TYPE=release -D STATIC=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="${ROOT_DIR}/arqma"  ../..
#make -j4 && make install
#popd
echo "Building IOS arm64"
#rm -r arqma/build > /dev/null
mkdir -p arqma/build/release
pushd arqma/build/release
cmake -D IOS=ON -D ARCH=arm64 -D BOOST_LIBRARYDIR=${BOOST_INCLUDEDIR} -D BOOST_INCLUDEDIR=${BOOST_INCLUDEDIR} -D OPENSSL_INCLUDE_DIR=${OPENSSL_INCLUDE_DIR} -D OPENSSL_ROOT_DIR=${OPENSSL_ROOT_DIR} -D CMAKE_BUILD_TYPE=Release -D STATIC=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="${ROOT_DIR}/arqma"  ../..
make -j4 && make install
popd

#echo "Creating fat library for armv7 and arm64"
#pushd arqma
#mkdir -p lib-ios
#lipo -create lib-arm64/libwallet_merged.a -output lib-ios/libwallet_merged.a
#lipo -create lib-arm64/libunbound.a -output lib-ios/libunbound.a
#lipo -create lib-arm64/libepee.a -output lib-ios/libepee.a
#popd
