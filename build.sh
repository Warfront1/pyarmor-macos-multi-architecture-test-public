#!/bin/zsh
set -e
rm -rf ./build ./dist ./.pyarmor ./test.spec
cwd=$(pwd)
python3 -m venv ~/pyarmortesting/
cd ~/pyarmortesting/
source ./bin/activate
cd $cwd
pip install pyarmor==8.3.0 pyinstaller==5.11.0
pyinstaller --target-architecture universal2 test.py
pyarmor gen --platform darwin.x86_64,darwin.arm64 --pack dist/test/test test.py
dist/test/test