source /etc/bash_completion.d/azure-cli
#ADDED_HIST_APPEND_CHECK
shopt -s histappend
#ADDED_HIST_CONTROL_CHECK
HISTCONTROL=ignoreboth
#ADDED_HIST_PROMPT_COMMAND_CHECK
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
PS1=${PS1//\\h/Azure}
source /usr/bin/cloudshellhelp

alias open-dev="bash ~/dot/azure/open-dev.sh"
alias ssh-dev="bash ~/dot/azure/ssh-dev.sh"
alias close-dev="bash ~/dot/azure/close-dev.sh"
