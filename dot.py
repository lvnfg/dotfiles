import logging
import os
import sys
import argparse
import subprocess
from dataclasses import dataclass

parser = argparse.ArgumentParser(description = 'Provide core functionlities to aid administrative tasks',)
parser.add_argument('task', type=str, help='The task to be done, e.g. close, open, start, stop...')
parser.add_argument('resource', type=str, help='The target resource of the task, e.g. vmdev, sqldev')
parser.add_argument('-i', '--ip-address', dest='ipAddress', type=str, help='Specify the ip address to use (default: current public ip)')
args = parser.parse_args()

def getPublicIP():
    url='https://ipinfo.io/ip'
    ip = subprocess.run(['curl', url], stdout=subprocess.PIPE).stdout.decode('utf8')
    print(ip)
    return ip 

class NSG():
    def __init__(self, prefix: str, name: str = None, resourceGroup: str = None):
        self.prefix:        str = prefix
        self.nsgName:       str = f'{prefix}-nsg-sea' if not name else name
        self.resourceGroup: str = f'{prefix}-rg' if not resourceGroup else resourceGroup

    def update(self, task: str, sourceIP: str, destinationIP: str = '*', ruleName: str = 'van'):
        if not sourceIP:
            if args.task == 'close':
                sourceIP = '*'
            else:
                sourceIP = getPublicIP()
        
        accessDict = {'open': 'allow', 'close': 'deny'}
        accessType = accessDict[args.task]
        
        ruleName = 'van'
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

def main():
    NSG(prefix=args.resource).update(task=args.task, sourceIP=args.ipAddress)


if __name__ == "__main__":
    main()
