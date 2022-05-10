#!/bin/bash

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pip3 install mssql-cli
mkdir -pv ~/.config/mssqlcli
ln -s -f $path/config   ~/.config/mssqlcli/config
