# Install docker for Debian
# https://docs.docker.com/engine/install/debian/

# Install docker in WSL 2 without Docker Desktop
# https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9

# Uninstall docker
# Uninstall the Docker Engine, CLI, Containerd, and Docker Compose packages:
# sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin
# Images, containers, volumes, or customized configuration files on your host are not automatically removed. To delete all images, containers, and volumes:
# sudo rm -rf /var/lib/docker && sudo rm -rf /var/lib/containerd

set -euo pipefail
echo 🚸 $0

# Stop the docker service if running
sudo systemctl restart docker

# Remove previously installed docker verions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Setup docker repository dependencies
sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Setup the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install docker engine
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
# To instal la specific version of Docker engine
    # List the versions available in your repo:
    # apt-cache madison docker-ce
    #   docker-ce | 5:18.09.1~3-0~debian-stretch | https://download.docker.com/linux/debian stretch/stable amd64 Packages
    #   docker-ce | 5:18.09.0~3-0~debian-stretch | https://download.docker.com/linux/debian stretch/stable amd64 Packages
    #   docker-ce | 18.06.1~ce~3-0~debian        | https://download.docker.com/linux/debian stretch/stable amd64 Packages
    #   docker-ce | 18.06.0~ce~3-0~debian        | https://download.docker.com/linux/debian stretch/stable amd64 Packages
    # Install a specific version using the version string from the second column, for example, 5:18.09.1~3-0~debian-stretch
    # sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io docker-compose-plugin
    # Verify that Docker Engine is installed correctly by running the hello-world image.
    # sudo docker run hello-world

# Run the hello-world image to verify
sudo docker run hello-world

# Run docker without sudo
# sudo groupadd -f docker         # Create docker user group
# sudo usermod -aG docker $USER   # Add current user to docker group
# newgrp docker                   # Activate changes to groups
# docker run hello-world          # Verify docker can run without sudo

echo "✅ $0"
