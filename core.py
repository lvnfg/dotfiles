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
    '-i', '--ip-address', 
    dest='ipAddress',
    type=str, 
    help='Specify the ip address to use (default: current public ip)'
)
parser.add_argument(
    '-I', '--ip-address-all', 
    dest='ipAddressAll',
    action='store_const',
    const=True,
    default=False,
    help='use the widest IP range possible (normally *)'
)
args = parser.parse_args()

def main():
    resourceType = ''
    if args.resource[:2] == 'vm':
        resourceType = 'vm'
    elif args.resource[:3] == 'sql':
        resourceType = 'sql'
    if resourceType == 'vm':
        vm(args.resource).parse()
    else:
        print(f'Unknown resource type: {args.Resource}')

def getPublicIP():
    url='https://ipinfo.io/ip'
    ip = subprocess.run(['curl', url], stdout=subprocess.PIPE).stdout.decode('utf8')
    print(ip)
    return ip 

class vm():
    def __init__(self, vmName):
        self.vmName        = vmName
        self.nsgName       = vmName + '-nsg'
        if args.resource == 'vmdev':
            self.resourceGroup = 'rgDev'
        elif args.resource == 'vmwin':
            self.resourceGroup = 'rgIntegration'

    def parse(self):
        if args.task in ['start', 'stop']:
            self.powerVM()
        elif args.task in ['open', 'close']:
            self.updateNSG()

    def powerVM(self):
        powerTask = None
        if args.task == 'stop':
            powerTask = 'deallocate'
        else:
            powerTask = args.task
        print(f'preparing to {powerTask} {self.vmName}')
        command = f"""
            az vm {powerTask} \
            --resource-group {self.resourceGroup} \
            --name {self.vmName}
        """
        os.system(command)
        
    def updateNSG(self):
        sourceIP = None
        if args.ipAddressAll == True or args.task == 'close':
            sourceIP = '*'
        elif args.ipAddress != None:
            sourceIP = args.ipAddress
        else:
            sourceIP = getPublicIP()
        
        accessDict = {'open': 'allow', 'close': 'deny'}
        accessType = accessDict[args.task]
        
        ruleName = 'van'
        destinationIP = '*'
        info = f'{accessType} access from {sourceIP} to {destinationIP} for {self.nsgName}'
        print(f'updating: {info}')
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
