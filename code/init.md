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

3. Move the above to dot folder:
mv ~/Library/Application\ Support/Code/User/settings.json /Users/vanle/Documents/Repos/dot/vscode
mv ~/Library/Application\ Support/Code/User/keybindings.json /Users/vanle/Documents/Repos/dot/vscode
mv ~/Library/Application\ Support/Code/User/snippets/ /Users/vanle/Documents/Repos/dot/vscode

4. Create symlinks to settings files
ln -s /Users/vanle/Documents/Repos/dot/vscode/settings.json /Users/vanle/Library/Application\ Support/Code/User/settings.json
ln -s /Users/vanle/Documents/Repos/dot/vscode/keybindings.json /Users/vanle/Library/Application\ Support/Code/User/keybindings.json
ln -s /Users/vanle/Documents/Repos/dot/vscode/snippets/ /Users/vanle/Library/Application\ Support/Code/User/

5. Create symlink in new machines and enjoy


## backup extensions

1. Write list of installed extensions to a file:
    code --list-extensions >> ext.txt

2. Loop install extensions on new machine
    cat ext.txt | xargs -n 1 code --install-extension