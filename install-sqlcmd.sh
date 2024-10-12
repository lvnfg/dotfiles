#!/bin/bash
set -euox pipefail

wget https://github.com/microsoft/go-sqlcmd/releases/download/v1.8.0/sqlcmd-linux-amd64.tar.bz2
mkdir sqlcmd-temp
tar -xf sqlcmd-linux-amd64.tar.bz2 -C sqlcmd-temp
mv sqlcmd-temp/sqlcmd /usr/local/bin/
rm -rf sqlcmd-temp
