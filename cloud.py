import os
import sys
import subprocess

try:
    arg1 = sys.argv[1]
    arg2 = sys.argv[2]
    arg3 = sys.argv[3]
except:
    pass

publicIP = ''
if arg1 == 'open':
    url='ipecho.net/plain'
    publicIP = subprocess.run(['curl', url], stdout=subprocess.PIPE).stdout.decode('utf8')
    print(f'{publicIP}')
    
# Azure
azResourceGroup = "rgDev"
if arg2[:2] == 'vm':
    aznsgName = sys.argv[2] + '-nsg'
    aznsgRuleName = 'van'
    aznsgAccessType = 'allow' if arg1 == 'open' else 'deny'
    aznsgSource = publicIP if arg1 == 'open' else '*'
    aznsgDestination = '*'
    command = f"""
        az network nsg rule update  \
        --resource-group {azResourceGroup}  \
        --nsg-name {aznsgName}  \
        --name {aznsgRuleName}  \
        --access {aznsgAccessType}  \
        --source-address-prefixes "{aznsgSource}"  \
        --destination-address-prefix "{aznsgDestination}"
    """
    os.system(command)

if arg2[:3] == 'sql':
    if arg2[-2:] == 'pp':
        azResourceGroup = 'rgHQ'
        azsqlServer = 'phuongphatgroup'
    azsqlSeverFirewallRuleName = 'van'
    azsqlServerStartIP = publicIP if arg1 == 'open' else '0.0.0.0'
    azsqlServerEndIP = publicIP if arg1 == 'open' else '0.0.0.0'
    command = f"""
        az sql server firewall-rule update \
        --resource-group {azResourceGroup} \
        --server {azsqlServer} \
        --name {azsqlSeverFirewallRuleName} \
        --start-ip-address {azsqlServerStartIP} \
        --end-ip-address {azsqlServerEndIP}
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
