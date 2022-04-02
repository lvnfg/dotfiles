#!/bin/bash

url="https://github.com/sharkdp/bat/releases/download/v0.18.2/bat_0.18.2_amd64.deb"
filename="bat.deb"
wget "$url" -O "$filename"
sudo dpkg -i "$filename"
rm "$filename"
