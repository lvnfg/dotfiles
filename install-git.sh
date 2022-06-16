#!/bin/bash
echo 🚸 $0
set -euo pipefail
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

echo "issudo: $issudo"

$issudo apt-get install git -y

git config --global core.editor     "nvim"
git config --global user.name       "van"
git config --global user.email      "-"
# git config --global format.graph
# gitFormatFull="%C(auto)%h %d%Creset %s - %Cgreen%ad%Creset %aN <%aE>"
# gitFormatShort="%C(auto)%h %d%Creset %s>"
# gitFormatString="$gitFormatShort"
# git config format.pretty format:"$gitFormatString"

# Merge tool
git config --global diff.tool "nvimdiff"
git config --global difftool.prompt false
git config --global difftool.nvimdiff.cmd "nvim -d \"\$LOCAL\" \"\$REMOTE\""
git config --global alias.d difftool

# Pull
git config --global pull.ff only

echo "✅ $0"
