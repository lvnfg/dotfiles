import os
import sys
import argparse
import subprocess
from dataclasses import dataclass

parser = argparse.ArgumentParser(description = 'Provide core functionlities to aid administrative tasks',)
parser.add_argument('task', type=str, help='The task to be done, e.g. close, open, start, stop...')
parser.add_argument('resource', type=str, help='The target resource of the task, e.g. vmdev, sqldev')
parser.add_argument('-i', '--ip-address', dest='ipAddress', type=str, help='Specify the ip address to use (default: current public ip)')
parser.add_argument('-I', '--ip-address-all', dest='ipAddressAll', action='store_const', const=True, default=False, help='use the widest IP range possible (normally *)')
args = parser.parse_args()

def getPublicIP():
    url='https://ipinfo.io/ip'
    ip = subprocess.run(['curl', url], stdout=subprocess.PIPE).stdout.decode('utf8')
    print(ip)
    return ip 

@dataclass
class Resource():
    name:          str
    resourceType:  str
    resourceGroup: str
    nsgName:       str = ''
    nsgRuleName:   str = 'van'
    
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
    
resourceList = [
    Resource('vmdev',    'vm', 'rgDev',         'vmdev-nsg',                     'van'),
    Resource('vmwin',    'vm', 'rgIntegration', 'vmwin-nsg',                     'van'),
    Resource('opsbuild', 'vm', 'opsbuild',      'opsbuild-networksecuritygroup', 'van'),
    Resource('opsdev01', 'vm', 'opsdev01',      'opsdev01-networksecuritygroup', 'van'),
    Resource('opsdev02', 'vm', 'opsdev02',      'opsdev02-networksecuritygroup', 'van'),
]

def main():
    for r in resourceList:
        if r.name == args.resource:
            r.parse()
            return 

if __name__ == "__main__":
    main()
