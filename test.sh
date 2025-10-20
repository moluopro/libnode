#!/bin/bash

if [ -d "test/build" ]; then
    rm -rf test/build
fi

mkdir test/build
cd test/build

cmake ..
cmake --build . --config Release

./Release/simple "console.log(require('http').STATUS_CODES[418])"
./Release/simple "process.exit(12)"
./Release/simple "invalid javascript"
./Release/process_argv

cd -
