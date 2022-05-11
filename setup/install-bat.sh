#!/bin/bash
set -euo pipefail

sudo apt install -y bat
mkdir -p ~/.local/bin
ln -s -f /usr/bin/batcat ~/.local/bin/bat
