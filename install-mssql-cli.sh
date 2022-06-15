#!/bin/bash
set -euo pipefail

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pip3 install mssql-cli
mkdir -pv $HOME/.config/mssqlcli
ln -s -f $path/config   $HOME/.config/mssqlcli/config

echo "mssql-cli ✅"
