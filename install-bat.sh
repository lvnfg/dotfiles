#!/bin/bash
echo 🚸 $0
set -euo pipefail
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

$issudo apt-get install -y bat
mkdir -p $HOME/.local/bin
$issudo ln -s -f /usr/bin/batcat $HOME/.local/bin/bat

echo "✅ $0"
