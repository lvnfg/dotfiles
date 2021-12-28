#!/bin/bash

# Install pyodbc
bash "$path/install-pyodbc.sh"

# Install msodbcsql driver for SQL server
bash "$path/install-msodbcsql.sh"

# MSSQL-CLI. Require /usr/bin/python symlinked as python3
pip3 install mssql-cli
