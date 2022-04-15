# Symlink dotfiles
ln -s -f $DOTFILES/.bash_profile     ~/.bash_profile
ln -s -f $DOTFILES/.bashrc           ~/.bashrc
# ln -s -f $DOTFILES/.bashrc           ~/.profile       # .profile is reserved for env var, do not use
ln -s -f $DOTFILES/.inputrc          ~/.inputrc
ln -s -f $DOTFILES/.tmux.conf        ~/.tmux.conf
ln -s -f $DOTFILES/vim/.vimrc        ~/.vimrc
