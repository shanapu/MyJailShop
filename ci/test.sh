#!/bin/bash

set -ev

echo "Download und extract sourcemod"
wget -q "http://www.sourcemod.net/latest.php?version=$1&os=linux" -O sourcemod.tar.gz
# wget "http://www.sourcemod.net/latest.php?version=$1&os=linux" -O sourcemod.tar.gz
tar -xzf sourcemod.tar.gz

echo "Give compiler rights for compile"
chmod +x addons/sourcemod/scripting/spcomp

echo "Set plugins version"
for file in addons/sourcemod/scripting/myjailshop.sp
do
  sed -i "s/<COMMIT>/$BID/g" $file > output.txt
  rm output.txt
done

echo "Compile MyJailShop plugins"
addons/sourcemod/scripting/spcomp -E -v0 addons/sourcemod/scripting/myjailshop.sp
addons/sourcemod/scripting/spcomp -E -v0 addons/sourcemod/scripting/myjailshop-frozdark-shop.sp
addons/sourcemod/scripting/spcomp -E -v0 addons/sourcemod/scripting/myjailshop-sm-store.sp
addons/sourcemod/scripting/spcomp -E -v0 addons/sourcemod/scripting/myjailshop-zephyrus-store.sp
