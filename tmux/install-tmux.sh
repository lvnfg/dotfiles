# The needed version is 3.2 for floating window.
# Current tmux version in Debian 11 is 3.1.c.

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s -f "$path/.tmux.conf" ~/.tmux.conf

# Use this when the apt package is 3.2
# sudo apt install tmux -y

# Install script for tmux
sudo apt install tmux/bullseye-backports -y
