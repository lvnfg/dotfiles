import os
import sys
import subprocess

try:
    arg1 = sys.argv[1]
    arg2 = sys.argv[2]
    arg3 = sys.argv[3]
except:
    pass

def getPublicIP():
    ip = subprocess.run(['curl', url], stdout=subprocess.PIPE).stdout.decode('utf8')
    print(ip)
    return ip 

# Azure
azResourceGroup = "rgDev"
if arg2[:2] == 'vm':
    nsgName        = sys.argv[2] + '-nsg'
    ruleName       = 'van'
    destinationIP  = '*'
    if arg1       == 'open':
        accessType = 'allow'
        sourceIP   = '*' if arg3 == 'allIPs' else getPublicIP()
    else:
        sourceIP   = '*' 
        accessType = 'deny'
    command = f"""
        az network nsg rule update  \
        --resource-group {azResourceGroup}  \
        --nsg-name {nsgName}  \
        --name {ruleName}  \
        --access {accessType}  \
        --source-address-prefixes "{sourceIP}"  \
        --destination-address-prefix "{destinationIP}"
    """
    os.system(command)

if arg2[:3] == 'sql':
    ruleName = 'van'
    if arg2[-2:] == 'pp':
        azResourceGroup = 'rgHQ'
        serverName = 'phuongphatgroup'
    if arg2 == 'open':
        startIP = getPublicIP()
    else:
        startIP = '0.0.0.0'
    endIP = startIP
    command = f"""
        az sql server firewall-rule update \
        --resource-group {azResourceGroup} \
        --server {serverName} \
        --name {ruleName} \
        --start-ip-address {startIP} \
        --end-ip-address {endIP}
    """
    os.system(command)

# create vm
#        az vm create                        \
#            --resource-group    $azRG       \
#            --name $vmName                  \
#            --location southeastasia        \
#            --accelerated-networking true   \
#            --vnet-name dev-vnet            \
#            --nsg dev-nsg                   \
#            --subnet default                \
#            --public-ip-address dev-vm-ip   \
#            --storage-sku Premium_LRS       \
#            --size Standard_F8s_v2          \
#            --admin-username van            \
#            --ssh-key-values $HOME/.ssh/id_rsa.pub  \
#            --image debian:debian-10:10-gen2:latest                          
