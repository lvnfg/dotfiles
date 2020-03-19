## create PATH command for code
Open the Command Palette via (⇧⌘P) and type shell command to find the Shell Command:

## backup settings & snippets:

- Where are they
    - ~/Library/Application Support/Code/User/          for macos
    - C:\Users\username\AppData\Roaming\Code\User       for windows 10
    - ~/.config/Code/User                               for linux

- Move setting files to repo
mv ~/Library/Application\ Support/Code/User/settings.json /Users/vanle/Documents/Repos/dot/vscode
mv ~/Library/Application\ Support/Code/User/keybindings.json /Users/vanle/Documents/Repos/dot/vscode
mv ~/Library/Application\ Support/Code/User/snippets/ /Users/vanle/Documents/Repos/dot/vscode

- Create symlinks to settings files
ln -s /Users/vanle/Documents/Repos/dot/code/settings.json /Users/vanle/Library/Application\ Support/Code/User/settings.json
ln -s /Users/vanle/Documents/Repos/dot/code/keybindings.json /Users/vanle/Library/Application\ Support/Code/User/keybindings.json
ln -s /Users/vanle/Documents/Repos/dot/code/snippets/ /Users/vanle/Library/Application\ Support/Code/User/

## backup extensions

- Write list of installed extensions to a file:
    code --list-extensions >> ext.txt

- Loop install extensions on new machine
    cat ext.txt | xargs -n 1 code --install-extension