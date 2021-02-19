import os
import sys
import argparse
import subprocess

parser = argparse.ArgumentParser(
    description = 'Provide core functionlities to aid administrative tasks',
)
parser.add_argument(
    'task', 
    type=str, 
    help='The task to be done, e.g. close, open, start, stop...'
)
parser.add_argument(
    'resource', 
    type=str, 
    help='The target resource of the task, e.g. vmdev, sqldev'
)
parser.add_argument(
    '-s', '--source-ip', 
    dest='sourceIP',
    type=str, 
    help='Override default source ip address'
)
args = parser.parse_args()

def main():
    resourceType = ''
    if args.resource[:2] == 'vm':
        resourceType = 'vm'
    elif args.resource[:3] == 'sql':
        resourceType = 'sql'
    if resourceType == 'vm':
        vm(args.resource).parse(args.task)
    else:
        print(f'Unknown resource type: {args.Resource}')

def getPublicIP():
    url='ipecho.net/plain'
    ip = subprocess.run(['curl', url], stdout=subprocess.PIPE).stdout.decode('utf8')
    print(ip)
    return ip 

class vm():
    def __init__(self, vmName):
        self.vmName        = vmName
        self.nsgName       = vmName + '-nsg'
        self.resourceGroup = 'rgDev'

    def parse(self, task, sourceIP = None):
        if task in ['start', 'stop']:
            self.powerVM(task)
        elif task in ['open', 'close']:
            self.updateNSG(task, sourceIP)

    def powerVM(self, powerType):
        if powerType == 'stop':
            powerType = 'deallocate'
        print(f'preparing to {powerType} {self.vmName}')
        command = f"""
            az vm {powerType} \
            --resource-group {self.resourceGroup} \
            --name {self.vmName}
        """
        os.system(command)
        
    def updateNSG(self, accessType, sourceIP = None):
        accessDict = {'open': 'allow', 'close': 'deny'}
        accessType = accessDict[accessType]
        if sourceIP == None:
            sourceIP = getPublicIP()
        ruleName = 'van'
        destinationIP = '*'
        print(f'updating nsg rule {self.nsgName}: {accessType} access to {destinationIP} from {sourceIP}')
        command = f"""
            az network nsg rule update  \
            --resource-group {self.resourceGroup}  \
            --nsg-name {self.nsgName}  \
            --name {ruleName}  \
            --access {accessType}  \
            --source-address-prefixes "{sourceIP}"  \
            --destination-address-prefix "{destinationIP}"
        """
        os.system(command)

    
        
#-------------------------------------------------------------------------------- 

# AZ SQL SERVER
#-------------------- 
class azSQL(object):
    def __init__(
        self,
        resourceGroup = 'rgDev',
        serverName    = 'sqldev',
        ruleName      = 'van',
        startIP       = '0.0.0.0',
        endIP         = '0.0.0.0',
    ):
        pass

    def updateFirewallRule(self):
        command = f"""
            az sql server firewall-rule update \
            --resource-group {self.resourceGroup} \
            --server {self.serverName} \
            --name {self.ruleName} \
            --start-ip-address {self.startIP} \
            --end-ip-address {self.endIP}
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

if __name__ == "__main__":
    main()
