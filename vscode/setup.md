## create PATH command for vscode
Open the Command Palette via (⇧⌘P) and type shell command to find the Shell Command:


## backup settings & snippets:

1. What's backed up
- settings.json
- keybindings.json
- snippet folder

2. Where are they
- macos:        ~/Library/Application Support/Code/User/
- windows 10:   C:\Users\username\AppData\Roaming\Code\User
- linux:        ~/.config/Code/User

3. Move the above to dotfiles folder:
mv ~/Library/Application\ Support/Code/User/settings.json /Users/vanle/Documents/Repos/dotfiles/vscode
mv ~/Library/Application\ Support/Code/User/keybindings.json /Users/vanle/Documents/Repos/dotfiles/vscode
mv ~/Library/Application\ Support/Code/User/snippets/ /Users/vanle/Documents/Repos/dotfiles/vscode

4. Create symlinks to settings files
ln -s /Users/vanle/Documents/Repos/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s /Users/vanle/Documents/Repos/dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s /Users/vanle/Documents/Repos/dotfiles/vscode/snippets/ ~/Library/Application\ Support/Code/User/

5. Create symlink in new machines and enjoy


## backup extensions

to get a list of extension in vscode:
    code --list-extensions
locations:
- macosx & linux:   ~/.vscode/extensions
- windows 10:       C:\Users\username\.vscode\extensions

