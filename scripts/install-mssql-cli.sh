#!/bin/bash

# The official doc is outdated and installing with apt doesn't work
# https://docs.microsoft.com/en-us/sql/tools/mssql-cli?view=sql-server-ver15

pip3 install mssql-cli
sudo ln -s -f ~/.local/bin/mssql-cli  /usr/local/bin/mssql-cli
