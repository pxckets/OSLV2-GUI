#!/bin/bash
OSCILLATE_URL=https://github.com/osl-coin/OSLV2.git
OSCILLATE_BRANCH=master

pushd $(pwd)
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $ROOT_DIR/utils.sh

INSTALL_DIR=$ROOT_DIR/wallet
OSCILLATE_DIR=$ROOT_DIR/oscillate
BUILD_LIBWALLET=false

if [ ! ${GIT_STRATEGY} == "none" ]; then
    # init and update Oscillate submodule
	if [ ! -d $OSCILLATE_DIR/src ]; then
	    git submodule init oscillate
	fi
	git submodule update --remote
	git -C $OSCILLATE_DIR fetch
	git -C $OSCILLATE_DIR checkout origin/master

# get Oscillate core tag
	get_tag
	# create local Oscillate branch
	git -C $OSCILLATE_DIR checkout -B $VERSIONTAG
	
	git -C $OSCILLATE_DIR submodule init
	git -C $OSCILLATE_DIR submodule update
	
	# Merge Oscillate PR dependencies
	
	# Workaround for git username requirements
	# Save current user settings and revert back when we are done with merging PR's
	OLD_GIT_USER=$(git -C $OSCILLATE_DIR config --local user.name)
	OLD_GIT_EMAIL=$(git -C $OSCILLATE_DIR config --local user.email)
	git -C $OSCILLATE_DIR config user.name "Oscillate GUI"
	git -C $OSCILLATE_DIR config user.email "gui@oscillate.local"
	# check for PR requirements in most recent commit message (i.e requires #xxxx)
	for PR in $(git log --format=%B -n 1 | grep -io "requires #[0-9]*" | sed 's/[^0-9]*//g'); do
	    echo "Merging Oscillate push request #$PR"
	    # fetch pull request and merge
	    git -C $OSCILLATE_DIR fetch origin pull/$PR/head:PR-$PR
	    git -C $OSCILLATE_DIR merge --quiet PR-$PR  -m "Merge Oscillate PR #$PR"
	    BUILD_LIBWALLET=true
	done
	
# revert back to old git config
	$(git -C $OSCILLATE_DIR config user.name "$OLD_GIT_USER")
	$(git -C $OSCILLATE_DIR config user.email "$OLD_GIT_EMAIL")
fi

# Build libwallet if it doesnt exist
if [ ! -f $OSCILLATE_DIR/lib/libwallet_merged.a ]; then
    echo "libwallet_merged.a not found - Building libwallet"
    BUILD_LIBWALLET=true
# Build libwallet if no previous version file exists
elif [ ! -f $OSCILLATE_DIR/version.sh ]; then
    echo "oscillate/version.h not found - Building libwallet"
    BUILD_LIBWALLET=true
## Compare previously built version with submodule + merged PR's version.
else
    source $OSCILLATE_DIR/version.sh
    # compare submodule version with latest build
    pushd "$OSCILLATE_DIR"
    get_tag
    popd
    echo "latest libwallet version: $GUI_OSCILLATE_VERSION"
    echo "Installed libwallet version: $VERSIONTAG"
    # check if recent
    if [ "$VERSIONTAG" != "$GUI_OSCILLATE_VERSION" ]; then
        echo "Building new libwallet version $GUI_OSCILLATE_VERSION"
        BUILD_LIBWALLET=true
    else
        echo "latest libwallet ($GUI_OSCILLATE_VERSION) is already built. Remove oscillate/lib/libwallet_merged.a to force rebuild"
    fi
fi

if [ "$BUILD_LIBWALLET" != true ]; then
    exit 0
fi

echo "GUI_OSCILLATE_VERSION=\"$VERSIONTAG\"" > $OSCILLATE_DIR/version.sh

## Continue building libwallet

# default build type
BUILD_TYPE=$1
if [ -z $BUILD_TYPE ]; then
    BUILD_TYPE=release
fi

STATIC=false
ANDROID=false
if [ "$BUILD_TYPE" == "release" ]; then
    echo "Building libwallet release"
    CMAKE_BUILD_TYPE=Release
elif [ "$BUILD_TYPE" == "release-static" ]; then
    echo "Building libwallet release-static"
    CMAKE_BUILD_TYPE=Release
    STATIC=true
elif [ "$BUILD_TYPE" == "release-android" ]; then
    echo "Building libwallet release-static for ANDROID"
    CMAKE_BUILD_TYPE=Release
    STATIC=true
    ANDROID=true
elif [ "$BUILD_TYPE" == "debug-android" ]; then
    echo "Building libwallet debug-static for ANDROID"
    CMAKE_BUILD_TYPE=Debug
    STATIC=true
    ANDROID=true
elif [ "$BUILD_TYPE" == "debug" ]; then
    echo "Building libwallet debug"
    CMAKE_BUILD_TYPE=Debug
    STATIC=true
else
    echo "Valid build types are release, release-static, release-android, debug-android and debug"
    exit 1;
fi


echo "cleaning up existing oscillate build dir, libs and includes"
rm -fr $OSCILLATE_DIR/build
rm -fr $OSCILLATE_DIR/lib
rm -fr $OSCILLATE_DIR/include
rm -fr $OSCILLATE_DIR/bin


mkdir -p $OSCILLATE_DIR/build/$BUILD_TYPE
pushd $OSCILLATE_DIR/build/$BUILD_TYPE

# reusing function from "utils.sh"
platform=$(get_platform)
# default make executable
make_exec="make"

## OS X
if [ "$platform" == "darwin" ]; then
    echo "Configuring build for MacOS.."
    if [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D ARCH="x86-64" -D BUILD_64=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE  -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    fi

## LINUX 64
elif [ "$platform" == "linux64" ]; then
    echo "Configuring build for Linux x64"
    if [ "$ANDROID" == true ]; then
        echo "Configuring build for Android on Linux host"
        mkdir -p translations
	    cd translations && cmake ../../../translations && make && cd ..
	    cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D ARCH="armv7-a" -D ANDROID=true -D BUILD_GUI_DEPS=ON -D USE_LTO=OFF -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR" -D CMAKE_SYSTEM_NAME="Android" -D CMAKE_ANDROID_STANDALONE_TOOLCHAIN="${ANDROID_STANDALONE_TOOLCHAIN_PATH}" -D CMAKE_ANDROID_ARM_MODE=ON -D CMAKE_ANDROID_ARCH_ABI="armeabi-v7a" ../..
    elif [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D ARCH="x86-64" -D BUILD_64=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    fi

## LINUX 32
elif [ "$platform" == "linux32" ]; then
    echo "Configuring build for Linux i686"
    if [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D ARCH="i686" -D BUILD_64=OFF -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    fi

## LINUX ARMv7
elif [ "$platform" == "linuxarmv7" ]; then
    echo "Configuring build for Linux armv7"
    if [ "$STATIC" == true ]; then
        cmake -D BUILD_TESTS=OFF -D ARCH="armv7-a" -D STATIC=ON -D BUILD_64=OFF  -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    else
        cmake -D BUILD_TESTS=OFF -D ARCH="armv7-a" -D -D BUILD_64=OFF  -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    fi

## LINUX other
elif [ "$platform" == "linux" ]; then
    echo "Configuring build for Linux general"
    if [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    fi

## Windows 64
## Windows is always static to work outside msys2
elif [ "$platform" == "mingw64" ]; then
    # Do something under Windows NT platform
    echo "Configuring build for MINGW64.."
    BOOST_ROOT=/mingw64/boost
    cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D BOOST_ROOT="$BOOST_ROOT" -D ARCH="x86-64" -D BUILD_64=ON -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR" -G "MSYS Makefiles" ../..

## Windows 32
elif [ "$platform" == "mingw32" ]; then
    # Do something under Windows NT platform
    echo "Configuring build for MINGW32.."
    BOOST_ROOT=/mingw32/boost
    cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D Boost_DEBUG=ON -D BOOST_ROOT="$BOOST_ROOT" -D ARCH="i686" -D BUILD_64=OFF -D BUILD_GUI_DEPS=ON -D INSTALL_VENDORED_LIBUNBOUND=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR" -G "MSYS Makefiles" ../..
    make_exec="mingw32-make"
else
    echo "Unknown platform, configuring general build"
    if [ "$STATIC" == true ]; then
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D STATIC=ON -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    else
        cmake -D CMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -D BUILD_GUI_DEPS=ON -D CMAKE_INSTALL_PREFIX="$OSCILLATE_DIR"  ../..
    fi
fi

# set CPU core count
# thanks to SO: http://stackoverflow.com/a/20283965/4118915
if test -z "$CPU_CORE_COUNT"; then
  CPU_CORE_COUNT=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
fi

# Build libwallet_merged
pushd $OSCILLATE_DIR/build/$BUILD_TYPE/src/wallet
eval $make_exec version -C ../..
eval $make_exec  -j$CPU_CORE_COUNT
eval $make_exec  install -j$CPU_CORE_COUNT
popd

# Build oscillated
# win32 need to build daemon manually with msys2 toolchain
if [ "$platform" != "mingw32" ] && [ "$ANDROID" != true ]; then
    pushd $OSCILLATE_DIR/build/$BUILD_TYPE/src/daemon
    eval make  -j$CPU_CORE_COUNT
    eval make install -j$CPU_CORE_COUNT
    popd
fi

# build install epee
eval make -C $OSCILLATE_DIR/build/$BUILD_TYPE/contrib/epee all install

# install easylogging
eval make -C $OSCILLATE_DIR/build/$BUILD_TYPE/external/easylogging++ all install

# install lmdb
eval make -C $OSCILLATE_DIR/build/$BUILD_TYPE/external/db_drivers/liblmdb all install

# Install libunbound
if [ -d $OSCILLATE_DIR/build/$BUILD_TYPE/external/unbound ]; then
    echo "Installing libunbound..."
    pushd $OSCILLATE_DIR/build/$BUILD_TYPE/external/unbound
    # no need to make, it was already built as dependency for libwallet
    # make -j$CPU_CORE_COUNT
    $make_exec install -j$CPU_CORE_COUNT
    popd
fi

popd
