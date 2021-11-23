# Symlink dotfiles
ln -s -f $DOTFILES/.bashrc           ~/.bashrc
ln -s -f $DOTFILES/.bashrc           ~/.profile
ln -s -f $DOTFILES/.inputrc          ~/.inputrc
ln -s -f $DOTFILES/.tmux.conf        ~/.tmux.conf
ln -s -f $DOTFILES/.vimrc            ~/.vimrc
ln -s -f $DOTFILES/litecli/config    ~/.config/litecli/config
ln -s -f $DOTFILES/ipython_config.py ~/.ipython/profile_default/ipython_config.py
