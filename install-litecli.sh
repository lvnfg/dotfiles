#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pip3 install litecli
mkdir -p $HOME/.config/litecli
ln -s -f $path/litecli/config $HOME/.config/litecli/config
