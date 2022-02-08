# Choose a vm that has hyper-threading and is capable of running nested virtualization
- For Azure VM: 
    https://docs.microsoft.com/en-us/azure/virtual-machines/acu


# Install WSL
- Run the command to install wsl:
    wsl --install -d Debian

- Check distro version with:
    vi /etc/issue


# Remove existing distro
- To remove an installed distro, first get the full name by running:
    wsl -l -v

- Then unregister the distro with:
    wsl --unregister <distro name>


# Remove distro Appx package
- List the installed appx packages with:
    Get-AppxPackage | Select Name, PackageFullName

- Remove package
    Remove-AppxPackage <package full name>


# Download and install a custom distro
- Openn Microsoft Store in the browser and search fo Debian image:
    https://www.microsoft.com/en-us/p/debian/9msvkqc78pk6?activetab=pivot:overviewtab

- Open the following url:
    https://store.rg-adguard.net/

- Paste the link to the image in Microsoft Store and click on the checkmark to get all downloadable links.

- Copy the link to the image Paste the link into the url bar to download

- Note: the appx for Debian 10 Buster is named: TheDebianProject.DebianGNULinux_1.1.8.0_x64__76v4gfsz19hv4

- Open powershell, navigate to the download location, and run the command to add the aspx to wsl:
    Add-AppxPackage [path-to-package]


# Disable sudo password
- Open visudo:
    sudo EDITOR=vi visudo

- Append to end of file:
    [username] ALL=(ALL) NOPASSWD:ALL

- Save and quit. If asked for a filename (because visudo doesn’t exist), leave the same



# Enable ssh to wsl

## Install openssh-server
- Install openssh-server
    sudo apt update
    sudo apt upgrade
    sudo apt install openssh-server

- Open sshd_config:
    sudo vi /etc/ssh/sshd_config

- Edit / add the following lines:
	Port 22			# Change to any if windows is already using port 22
	#AddressFamily any
	ListenAddress 0.0.0.0
	#ListenAddress ::

## Disable password authentication
- Open sshd_config:
	sudo vi /etc/ssh/sshd_config
- Edit / add the following lines:
	PubkeyAuthentication yes
	PermitRootLogin no
	PermitRootLogin prohibit-password
	PasswordAuthentication no
	PermitEmptyPasswords no
	ChallengeResponseAuthentication no
	UsePAM no

## Restart ssh service
	sudo service ssh stop
	sudo service ssh start

## Add authorized_keys
- Create .ssh dir and files
	mkdir ~/.ssh
	vi ~/.ssh/authorized_keys
- Add authorized keys (use right click to paste in powershell)
- Change file permissions so it can be used by ssh service
	chmod 400 ~/.ssh/authorized_keys

## Enable script execution in powershell
	set-executionpolicy remotesigned

## Download enable-ssh-in-wsl.ps1 from infra folder and save to Desktop

## Create task scheduler job to execute script on startup
Create new task
General:
	Name: any
	Run:  whether the user is logged on or not
Trigger:
	At startup
Action:
	Program / script: powershell
	Argument:         -File C:\Users\van\Desktop\enable-ssh-to-wsl.ps1

## SSH in to test

## Done
