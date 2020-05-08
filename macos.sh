#!/bin/zsh

# Enable bash commenting style for zsh
set -k							# ignore newline starting with #
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
ln -s ~/Documents/dot/code/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/Documents/dot/code/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s ~/Documents/dot/code/snippets ~/Library/Application\ Support/Code/User/snippets
# create PATH command for code:
# Open the Command Palette via (⇧⌘P) and type shell command to find the Shell Command:
# see if a terminal command can be found for this
# Install vs code extension
cd /Users/van/Documents/repo/dot/code
cat ext.txt | xargs -n 1 code --install-extension
# To Write list of installed extensions to a file use:
# code --list-extensions >> ext.txt

# ------------------------------------------
# Install Homebrew, Git, Python, other apps
# ------------------------------------------
brew install python
# pip3 install --user pipenv	
pip3 install matplotlib
pip3 install scipy
pip3 install pandas
pip3 install pyodbc
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release	# odbc driver for sql server
brew install msodbcsql mssql-tools