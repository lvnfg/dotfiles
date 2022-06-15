set -euo pipefail

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$path"

apt-get update && apt-get upgrade -y
apt-get install -y wget
apt-get install -y unzip
apt-get install -y tar
apt-get install -y curl
apt-get install -y fzf
apt-get install -y ripgrep          # Required for fzf.vim search all files
apt-get install -y build-essential  # Required for treesitter

bash "$path/install-top.sh"
bash "$path/install-bash.sh"
bash "$path/install-tmux.sh"
bash "$path/install-git.sh"
bash "$path/install-bat.sh"
bash "$path/install-neovim.sh"
bash "$path/install-ranger.sh"

echo "base-dev image setup ✅"
