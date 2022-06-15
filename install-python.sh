#!/bin/bash
set -euo pipefail

version="3.10.4"

echo "Installing Python $version"
dir="Python-$version"
tarball="$dir.tar.xz"
url="https://www.python.org/ftp/python/$version/$tarball"
apt-get update
apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
curl -O $url
tar -xf $tarball
rm $tarball
cd $dir
./configure --enable-optimizations --enable-loadable-sqlite-extensions

# Required to fix error when importing pandas after building Python from source
apt-get install -y lzma
apt-get install -y liblzma-dev
configure

# Build python
make -j 4
make install    # will overwrite system's python3. To install side by side: sudo make altinstall
cd ..
rm -rf $dir
apt-get install -y python3-pip

ln -s -f /usr/local/bin/python3 /usr/bin/python

echo "PYTHON $version ✅"
