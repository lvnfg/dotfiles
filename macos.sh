#!/bin/zsh

# Enable bash commenting style for zsh
set -k					        # ignore newline starting with #
setopt interactivecomments 		# enable inline comment

# ------------------------------------------
# Install Homebrew & Git
# ------------------------------------------
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update && brew upgrade
brew install git
git config --global user.name "van@macbook"
git config --global user.email "-"
cd ~/Documents
git clone https://github.com/lvnfg/dot

# ------------------------------------------
# Install VS Code
# ------------------------------------------
brew cask install visual-studio-code
# Remove VS Code setting files and snippets
rm ~/Library/Application\ Support/Code/User/settings.json
rm ~/Library/Application\ Support/Code/User/keybindings.json
rm -r ~/Library/Application\ Support/Code/User/snippets
# Create symlinks to VS Code setting files in repos
ln -s ~/Desktop/dot/code/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/Desktop/dot/code/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s ~/Desktop/dot/code/snippets ~/Library/Application\ Support/Code/User/snippets