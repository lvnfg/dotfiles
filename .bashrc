source /etc/bash_completion.d/azure-cli
#ADDED_HIST_APPEND_CHECK
shopt -s histappend
#ADDED_HIST_CONTROL_CHECK
HISTCONTROL=ignoreboth
#ADDED_HIST_PROMPT_COMMAND_CHECK
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
PS1=${PS1//\\h/Azure}
source /usr/bin/cloudshellhelp

alias start-dev="az vm start -n vmDev -g rgLVF"
alias deallocate-dev="az vm deallocate -n vmDev -g rgLVF"
alias getip="curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
alias open-dev="az network nsg rule update -g rgLVF --nsg-name vmDev-nsg -n cloudshell --access Allow --source-address-prefixes "
alias close-dev="az network nsg rule update -g rgLVF --nsg-name vmDev-nsg -n cloudshell --access Deny"
alias ssh-dev="ssh van@13.76.218.54"

