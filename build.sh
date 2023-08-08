#!/bin/bash
set -e
rm -rf ./build ./dist ./.pyarmor ./test.spec
cwd=$(pwd)
python3 -m venv ~/pyarmortesting/
cd ~/pyarmortesting/
source ./bin/activate
cd $cwd
pip install pyarmor==8.3.0 pyinstaller==5.11.0
python -m pyarmor.cli gen -O obfdist src/
cp -r ./obfdist/pyarmor_runtime_000000 ./obfdist/src
cp -r ./obfdist/pyarmor_runtime_000000 ./src
python ./obfdist/src/test.py
pyi-makespec --hidden-import pyarmor_runtime_000000 src/test.py
insert_file="PyarmorPatch.txt"
line_marker="pyz"
sed -i "/^${line_marker}/r ${insert_file}" test.spec
sed -i "s|SRCHERE|$(pwd)/src|g" test.spec
sed -i "s|OBFHERE|$(pwd)/obfdist/src|g" test.spec
pyinstaller test.spec
./dist/test/test