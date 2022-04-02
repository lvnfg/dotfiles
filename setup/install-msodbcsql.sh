# NOT WORKING IN DEBIAN 11!

set -euo pipefail

# Install mssodbcsql17 driver for SQL Server
sh -c "#curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -"
sh -c "#curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list"
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql17 -y

echo ""
echo "If installation failed, follow the original install steps here:"
echo "https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15"
