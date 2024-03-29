#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ipython profile create
ln -s -f $path/ipython/ipython_config.py $HOME/.ipython/profile_default/ipython_config.py

# Fix prompt toolkit when mssql-cli is installed in same system
# pip3 install prompt_toolkit==3.0.29   # Removed 2023-01-31. Seems this step isn't needed anymore.

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
