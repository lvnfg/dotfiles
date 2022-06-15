#!/bin/bash
set -euo pipefail

NAME="nodejs & npm"
echo $NAME 🚸

apt-get install nodejs -y
apt-get install npm -y

echo $NAME ✅
