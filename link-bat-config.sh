#!/bin/bash
set -euox pipefail
if [ "$EUID" -ne 0 ]; then issudo="sudo"; else issudo=""; fi

mkdir -p $HOME/.local/bin
$issudo ln -s -f /usr/bin/batcat $HOME/.local/bin/bat
