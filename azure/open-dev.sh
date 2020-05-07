#!/bin/bash

echo 'getting ip'
ip=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
echo $ip
echo 'opening port'
az network nsg rule update -g rgLVF --nsg-name vmDev-nsg -n cloudshell --access Allow --source-address-prefixes $ip
echo 'port opened'
echo 'starting vmDev'
az vm start -g rgLVF -n vmDev
echo 'vmDev started'
