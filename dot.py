import logging
import os
import sys
import argparse
import subprocess
from dataclasses import dataclass

parser = argparse.ArgumentParser(description = 'Provide core functionlities to aid administrative tasks',)
parser.add_argument('task', type=str, help='The task to be done, e.g. close, open, start, stop...')
parser.add_argument('prefix', type=str, help='Provide just the prefix of the resouce group to open access to all resources within that group at once')
parser.add_argument('region', nargs='?', type=str, default='sea', help='Option region code for the resource, e.g. sea, usw, usn...')
parser.add_argument('-i', '--ip-address', dest='ipAddress', type=str, help='Specify the ip address to use (default: current public ip).')
args = parser.parse_args()

def getPublicIP():
    url='https://ipinfo.io/ip'
    ip = subprocess.run(['curl', url], stdout=subprocess.PIPE).stdout.decode('utf8')
    print(ip)
    return ip 

def updateNSG(
    task:          str,
    name:          str = None,
    resourceGroup: str = None,  # Required if exact name is provided. Constructed from prefix otherwise
    prefix:        str = None,
    region:        str = None,
    sourceIP:      str = None,
    destinationIP: str = '*',
    ruleName:      str = 'van',
) -> None:
    if not name:
        name          = f'{prefix}-nsg-{region}'
        resourceGroup = f'{prefix}-rg'
    if not sourceIP:
        if task == 'close':
            sourceIP = '*'
        else:
            sourceIP = getPublicIP()
    accessDict = {'open': 'allow', 'close': 'deny'}
    accessType = accessDict[args.task]
    
    info = f'[{name}] {sourceIP} -> {destinationIP} {accessType.upper()}'
    print(f'updating: {info}')
    command = f"""
        az network nsg rule update  \
        --resource-group {resourceGroup}  \
        --nsg-name {name}  \
        --name {ruleName}  \
        --access {accessType}  \
        --source-address-prefixes "{sourceIP}"  \
        --destination-address-prefix "{destinationIP}"
    """
    os.system(command)


def main():
    task = args.task
    if task in ('open', 'close'):
        sourceIP = '*' if args.ipAddress in ('a', 'all') else args.ipAddress
        updateNSG(task=args.task, prefix=args.prefix, region=args.region, sourceIP=sourceIP)
    elif task in ('start', 'stop'):
        pass

if __name__ == "__main__":
    main()
