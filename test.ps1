Push-Location
if (Test-Path 'test/build') {
    rm -Recurse -Force 'test/build'
}
mkdir test/build
cd test/build

cmake ..
cmake --build .

./Debug/simple "console.log(require('http').STATUS_CODES[418])"
./Debug/simple "process.exit(12)"
./Debug/simple "invalid javascript"
./Debug/process_argv

Pop-Location
