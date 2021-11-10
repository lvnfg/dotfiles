# NOT WORKING IN DEBIAN 11!

set -euo pipefail

# Install mssodbcsql17 driver for SQL Server
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
sudo sh -c "#curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list"
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql17 -y
