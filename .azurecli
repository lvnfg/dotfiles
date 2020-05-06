# create os disk from snapshot
az disk create -n vmDev-os --source vmDev-os-snapshot --sku Premium_LRS --size-gb 32 -g rgLVF

# deallocate vm
az vm deallocate -n vmDev -g rgLVF
