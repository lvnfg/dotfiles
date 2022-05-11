#!/bin/bash
set -euo pipefail

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.config/procps
ln -s -f $path/toprc ~/.config/procps/toprc
