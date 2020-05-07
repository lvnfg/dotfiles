#!/bin/sh

echo 'deallocating vmDev'
az vm deallocate -g rgLVF -n vmDev
echo 'closing port'
az network nsg rule update -g rgLVF --nsg-name vmDev-nsg -n cloudshell --access Deny
echo 'port closed'
