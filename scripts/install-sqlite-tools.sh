#!/bin/bash

pip3 install litecli
mkdir -p $DOTFILES/litecli/config
ln -s -f $DOTFILES/litecli/config ~/.config/litecli/config
