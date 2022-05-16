#!/bin/sh

echo "install tree2dotx..."
sudo cp tree2dotx.sh /usr/bin/tree2dotx.sh
chmod +x /usr/bin/tree2dotx.sh
sudo ln -s /usr/bin/tree2dotx.sh /usr/bin/tree2dotx

echo "install cflow..."
sudo apt updata
sudo apt install cflow
sudo apt install gawk

echo "install graphviz..."
sudo apt install graphviz

echo "install cgraph..."
sudo cp cgraph.sh /usr/bin/cgraph.sh
chmod +x /usr/bin/cgraph.sh
sudo ln -s /usr/bin/cgraph.sh /usr/bin/cgraph

echo "finish install"
echo "enjoy :-)"
exit 1