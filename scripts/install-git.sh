#!/bin/bash

sudo apt update && sudo apt update -y
sudo apt install git -y

git config --global core.editor     "nvim"
git config --global user.name       "van"
git config --global user.email      "-"
git config --global format.graph
gitFormatFull="%C(auto)%h %d%Creset %s - %Cgreen%ad%Creset %aN <%aE>"
gitFormatShort="%C(auto)%h %d%Creset %s>"
gitFormatString="$gitFormatShort"
git config --global format.pretty format:"$gitFormatString"
