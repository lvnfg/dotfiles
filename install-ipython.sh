#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pip3 install ipython
ipython profile create
ln -s -f $path/ipython/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py

# ipython somehow doesn't work with python 3.10
pyver="$(python3 --version | grep 3.10)"
if [[ "$pyver" != "" ]]; then
    echo "Fixing prompt-toolkit"
    pip3 install prompt_toolkit==3.0.29     # Must be at this specific version
fi

# To enable vim mode
# Then open $HOME/.ipython/profile_default/ipython_config.py and set
#   c.TerminalInteractiveShell.editing_mode = 'vi'  <-- Set to vi
# To enable case-insensitive tab completion in ipython shell,
# open IPython/core/completer.py:
# try:
#    import jedi
#    jedi.settings.case_insensitive_completion = True <-- Set to True
#    import jedi.api.helpers
#    import jedi.api.classes
#    JEDI_INSTALLED = True
