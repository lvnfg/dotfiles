#!/bin/bash

version="3.9.5"

echo "Installing Python $version"
dir="Python-$version"
tarball="$dir.tar.xz"
url="https://www.python.org/ftp/python/$version/$tarball"
sudo apt update
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
curl -O $url
tar -xf $tarball
rm $tarball
cd $dir
./configure --enable-optimizations --enable-loadable-sqlite-extensions

# Required to fix error when importing pandas after building Python from source
sudo apt-get install -y lzma
sudo apt-get install -y liblzma-dev
sudo configure

# Build python
sudo make -j 4
sudo make install    # will overwrite system's python3. To install side by side: sudo make altinstall
cd ..
sudo rm -rf $dir
sudo apt install -y python3-pip

sudo ln -s -f /usr/local/bin/python3 /usr/bin/python
