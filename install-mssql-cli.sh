#!/bin/bash
set -euo pipefail
echo 🚸 $0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pip3 install mssql-cli
mkdir -pv $HOME/.config/mssqlcli
ln -s -f $path/mssqlcli/config   $HOME/.config/mssqlcli/config

echo "✅ $0"
