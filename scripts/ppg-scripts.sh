#!/bin/bash

# Azure Functions
# -----------------------------
function func-deploy-ppg-int-pro-sea-func-api() {
    cd $REPOS/ppg-int-func-api && func azure functionapp publish ppg-int-pro-sea-func-api --python
}
function func-deploy-ppg-int-pro-sea-func-scheduler() {
    cd $REPOS/ppg-int-func-scheduler && func azure functionapp publish ppg-int-pro-sea-func-scheduler --python
}

# Azure SQL, dbHQ
# -----------------------------
function search-file-sql() {
    result=$(find ~ -type f 2> /dev/null | grep ".sql$" | fzf)
    if [[ ! -z "$result" ]]; then echo $result ; fi
}
function dbHQ-retrieve-password() {
    pw="$DBHQPASSWORD"
    if [[ -z "$pw" ]]; then pw="$(az keyvault secret show --vault-name dev-atm-pro-sea-keyvault --name dbhq-byod-password | jq -r '.value')"; fi
    export DBHQPASSWORD="$pw"
}
# add \ prefix to expand variable at alias use time
function dbHQ-login() {
    dbHQ-retrieve-password 
    mssql-cli -S phuongphatgroup.database.windows.net -d dbHQ -U byod -P "$DBHQPASSWORD" -i "$1"
}
function dbHQ-execute() { 
    result=$(search-file-sql) 
    if [[ ! -z "$result" ]]; then dbHQ-login "$result" ; fi ; 
}
