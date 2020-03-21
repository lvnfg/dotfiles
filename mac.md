# !/bin/zsh

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# Run **brew doctor** to make sure that installation was successfull and that brew is working properly
# Update to the latest version:
brew update && brew upgrade

# Install BetterTouchTool
brew cask install bettertouchtool 

# Install Git
brew install git

# Pull repos from git hub
cd /Users/van/Documents/repo

## Install Python 3.x
brew install python

# Install VS Code
brew cask install visual-studio-code

# Remove VS Code setting files and snippets
rm ~/Library/Application\ Support/Code/User/settings.json
rm ~/Library/Application\ Support/Code/User/keybindings.json
rm -r ~/Library/Application\ Support/Code/User/snippets/

# Create symlinks to VS Code setting files in repos
ln -s /Users/van/Documents/Repos/dot/code/settings.json /Users/van/Library/Application\ Support/Code/User/settings.json
ln -s /Users/van/Documents/Repos/dot/code/keybindings.json /Users/van/Library/Application\ Support/Code/User/keybindings.json
ln -s /Users/van/Documents/Repos/dot/code/snippets/ /Users/van/Library/Application\ Support/Code/User/snippets

# create PATH command for code:
# Open the Command Palette via (⇧⌘P) and type shell command to find the Shell Command:
# see if a terminal command can be found for this

# Install vs code extension
cd /Users/van/Documents/Repos/dot/code
cat ext.txt | xargs -n 1 code --install-extension
# To Write list of installed extensions to a file use:
# code --list-extensions >> ext.txt

# Install Mac App Store apps without cask
# iStatsMenu
# Amphetamine



# Import BetterTouchToolSetting
# See if a terminal command can be found

# Install other apps 
brew cask install 1password 
brew cask install the-unarchiver

## Install XCode
xcode-select --install

# Install python dependency
pip3 install matplotlib
pip3 install scipy
pip3 install pandas
pip3 install pyodbc

#install odbc driver for sql server
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew install msodbcsql mssql-tools


# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable transparency in the menu bar and elsewhere on Yosemite
defaults write com.apple.universalaccess reduceTransparency -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable the crash reporter
#defaults write com.apple.CrashReporter DialogType -string "none"

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Set highlight and accent colors to green
defaults write NSGlobalDomain AppleHighlightColor -string "0.752941 0.964706 0.678431 Green"
defaults write NSGlobalDomain AppleAccentColor -int 3

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable spelling correction as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en-US" "fr-US" "vi-US"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleICUDateFormatStrings -array "1 = \"d-MMM-yy\";2 = \"dMMM, y\";3 = \"dMMMM, y\";"
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celcius"
defaults write NSGlobalDomain AppleFirstWeekday -array "gregorian = 2"


# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

------------

