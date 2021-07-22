#!/bin/bash

# Install a desktop environment and configure remote desktop access. 
# https://docs.microsoft.com/en-us/azure/virtual-machines/linux/use-remote-desktop

sudo apt install -y xfce4                                          # Install XFCE desktop environment
sudo apt-get -y install xrdp                                       # Install Remote desktop server
sudo systemctl enable xrdp                                         # Enable xrdp for use
echo xfce4-session >~/.xsession                                    # Use XFCE for remote desktop session
sudo passwd van                                                    # Create a password for the current user to login to xrdp
sudo apt install firefox-esr                                       # Install firefox ESR (Extended Support Release)
xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s false # Disable compositing for rdp performance. Must be run in desktop env. True to activate again.
