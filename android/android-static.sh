#!/bin/bash

[ -z "$GITHUB_WORKSPACE" ] && GITHUB_WORKSPACE="$( cd "$( dirname "$0" )"/.. && pwd )"

WORKSPACE=$GITHUB_WORKSPACE
HOMEPATH=~
VERSION=$1
ARCH="$2"


cd $HOMEPATH
git clone https://github.com/nodejs/node

cd node
git checkout $VERSION

echo "=====[Building Node.js]====="

cp $WORKSPACE/android/android_configure.py .
cp $WORKSPACE/android/trap-handler.h.patch ./android-patches/

bash ./android-configure patch
bash ./android-configure "$HOME/android-ndk-r27d" 24 arm64

make -j8

mkdir -p ../libnode

rm -f out/Release/obj.target/deps/googletest/*.a

cp $(find out/Release/obj.target -type f -name "*.a") ../libnode/

cd ~/libnode/

zip -r ./libnode-$VERSION-android-arm64.zip ./*
