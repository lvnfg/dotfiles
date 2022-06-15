#!/bin/bash
set -euo pipefail
echo 🚸 $0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p $HOME/.config/procps
ln -s -f $path/top/toprc $HOME/.config/procps/toprc

echo "✅ $0"
