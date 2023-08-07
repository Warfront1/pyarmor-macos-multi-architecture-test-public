#!/bin/zsh
#set -e
rm -rf ./build ./dist ./.pyarmor ./test.spec ~/pyarmortesting
cwd=$(pwd)
python3 -m venv ~/pyarmortesting/
cd ~/pyarmortesting/
source ./bin/activate
cd $cwd
pip install pyarmor==8.3.1 pyinstaller==5.11.0 pyarmor.cli.core.darwin==4.3.1
pyinstaller --target-architecture universal2 test.py
sed -i '' '248a\
        if not os.path.exists(rtpath):
'  ~/pyarmortesting/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -i '' '249a\
            print("We are inside of the patch ", ctx.repack_path, ctx.runtime_package_name)
'  ~/pyarmortesting/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -i '' '250a\
            rtpath = os.path.join(ctx.repack_path, ctx.runtime_package_name)
'  ~/pyarmortesting/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -i '' '251a\
        print("We are right after the patch")
'  ~/pyarmortesting/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -i '' '273a\
print("Patching sed commands are working")
'  ~/pyarmortesting/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -n '235,255p' ~/pyarmortesting/lib/python3.11/site-packages/pyarmor/cli/plugin.py
pyarmor gen --platform darwin.x86_64,darwin.arm64 --pack dist/test/test test.py
if [ $? -ne 0 ]; then
  echo "Command failed with non-zero exit code."
  if [ -f .pyarmor/pack/dist/pyarmor_runtime_000000/darwin_arm64/pyarmor_runtime.so ]; then
        echo "darwin_arm64 pyarmor_runtime.so exists!"
  else
        echo "darwin_arm64 pyarmor_runtime.so does not exist."
  fi
  if [ -f .pyarmor/pack/dist/pyarmor_runtime_000000/darwin_x86_64/pyarmor_runtime.so ]; then
        echo "darwin_x86_64pyarmor_runtime.so exists!"
  else
        echo "darwin_x86_64 pyarmor_runtime.so does not exist."
  fi
else
  dist/test/test
fi
pyarmor cfg plugins