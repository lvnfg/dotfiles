#!/bin/bash

pip3 install ipython
ipython profile create
ln -s -f $DOTFILES/ipython_config.py ~/.ipython/profile_default/ipython_config.py
# To enable vim mode
# Then open ~/.ipython/profile_default/ipython_config.py and set
#   c.TerminalInteractiveShell.editing_mode = 'vi'  <-- Set to vi
# To enable case-insensitive tab completion in ipython shell,
# open IPython/core/completer.py:
# try:
#    import jedi
#    jedi.settings.case_insensitive_completion = True <-- Set to True
#    import jedi.api.helpers
#    import jedi.api.classes
#    JEDI_INSTALLED = True
