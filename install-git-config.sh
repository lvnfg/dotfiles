#!/bin/bash
set -euox pipefail
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

$issudo git config --global core.editor     "nvim"
$issudo git config --global user.name       "van"
$issudo git config --global user.email      "van@van"
# git config --global format.graph
# gitFormatFull="%C(auto)%h %d%Creset %s - %Cgreen%ad%Creset %aN <%aE>"
# gitFormatShort="%C(auto)%h %d%Creset %s>"
# gitFormatString="$gitFormatShort"
# git config format.pretty format:"$gitFormatString"

# Merge tool
$issudo git config --global diff.tool "nvimdiff"
$issudo git config --global difftool.prompt false
$issudo git config --global difftool.nvimdiff.cmd "nvim -d \"\$LOCAL\" \"\$REMOTE\""
$issudo git config --global alias.d difftool

# Pull
$issudo git config --global pull.ff only
