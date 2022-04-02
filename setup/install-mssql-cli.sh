#!/bin/bash

pip3 install mssql-cli
mkdir -pv ~/.config/mssqlcli
ln -s -f $DOTFILES/mssqlcli/config   ~/.config/mssqlcli/config
