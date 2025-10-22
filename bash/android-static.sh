#!/bin/bash

[ -z "$GITHUB_WORKSPACE" ] && GITHUB_WORKSPACE="$( cd "$( dirname "$0" )"/.. && pwd )"

WORKSPACE=$GITHUB_WORKSPACE
HOMEPATH=~
VERSION=$1
ARCH="$2"

case $ARCH in
    arm)
        OUTPUT="arm"
        ;;
    x86)
        OUTPUT="x86"
        ;;
    x86_64)
        OUTPUT="x64"
        ;;
    arm64|aarch64)
        OUTPUT="arm64"
        ;;
    *)
        echo "Unsupported architecture provided: $ARCH"
        exit 1
        ;;
esac

cd $HOMEPATH
git clone https://github.com/nodejs/node

cd node
git checkout $VERSION

echo "=====[Building Node.js]====="

ls $HOME/android-ndk-r27d/toolchains/llvm/prebuilt/linux-x86_64/bin/clang

git apply $WORKSPACE/patch/node22.patch --ignore-whitespace --unidiff-zero

bash ./android-configure "$HOME/android-ndk-r27d" 24 arm64

make -j8

mkdir -p ../libnode-Android/$OUTPUT/

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
tree -P '*.a' out/Release/obj.target/
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

cp \
  out/Release/obj.target/deps/histogram/libhistogram.a \
  out/Release/obj.target/deps/uvwasi/libuvwasi.a \
  out/Release/obj.target/libnode.a \
  out/Release/obj.target/libnode_stub.a \
  out/Release/obj.target/tools/v8_gypfiles/libv8_snapshot.a \
  out/Release/obj.target/tools/v8_gypfiles/libv8_libplatform.a \
  out/Release/obj.target/deps/zlib/libzlib.a \
  out/Release/obj.target/deps/llhttp/libllhttp.a \
  out/Release/obj.target/deps/cares/libcares.a \
  out/Release/obj.target/deps/uv/libuv.a \
  out/Release/obj.target/deps/nghttp2/libnghttp2.a \
  out/Release/obj.target/deps/brotli/libbrotli.a \
  out/Release/obj.target/deps/openssl/libopenssl.a \
  out/Release/obj.target/tools/v8_gypfiles/libv8_base_without_compiler.a \
  out/Release/obj.target/tools/v8_gypfiles/libv8_libbase.a \
  out/Release/obj.target/tools/v8_gypfiles/libv8_zlib.a \
  out/Release/obj.target/tools/v8_gypfiles/libv8_compiler.a \
  out/Release/obj.target/tools/v8_gypfiles/libv8_initializers.a \
  ../libnode-Android/$OUTPUT/

cd ~/libnode-Android/$OUTPUT

zip -r ./libnode-$VERSION-android-arm64.zip ./*
