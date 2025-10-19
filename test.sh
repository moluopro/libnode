#!/bin/bash

if [ -d "test/build" ]; then
    rm -rf test/build
fi

mkdir test/build
cd test/build

cmake ..
cmake --build .

./Debug/simple "console.log(require('http').STATUS_CODES[418])"
./Debug/simple "process.exit(12)"
./Debug/simple "invalid javascript"
./Debug/process_argv

cd =
