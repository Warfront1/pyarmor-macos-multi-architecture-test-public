#!/bin/zsh
#set -e
rm -rf ./build ./dist ./.pyarmor
pip install pyarmor==8.3.1 pyarmor.cli.core.darwin==4.3.1
sed -i '' '248a\
        if not os.path.exists(rtpath):
'  /Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -i '' '249a\
            print("We are inside of the patch ", ctx.repack_path, ctx.runtime_package_name)
'  /Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -i '' '250a\
            rtpath = os.path.join(ctx.repack_path, ctx.runtime_package_name)
'  /Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -i '' '251a\
        print("We are right after the patch")
'  /Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -i '' '273a\
print("Patching sed commands are working")
'  /Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/pyarmor/cli/plugin.py
sed -n '235,255p' /Library/Frameworks/Python.framework/Versions/3.11/lib/python3.11/site-packages/pyarmor/cli/plugin.py
#find / -type d -name "cli" -exec find {} -type f -name "plugin.py" \;
python -m pyarmor.cli gen --platform darwin.x86_64,darwin.arm64 test.py
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
ls -a dist/pyarmor_runtime_000000
pyarmor cfg plugins