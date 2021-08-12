#!/bin/bash

# Core directories
export REPOS="$HOME/repos" 
export DOTFILES="$REPOS/dotfiles" 

# Let vim & tmux terminals use colors
export TERM=screen-256color 
alias ls="ls -al -h --color=auto --group-directories-first"

# Enable bash completion
[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion 

# nvim
set -o vi   # Use vim keybindings in bash prompts
alias vim="nvim"
export VISUAL="nvim" 
export EDITOR="nvim"

# Enable git autocomplion in bash
if [ -f $DOTFILES/.git-completion.bash ]; then 
    source $DOTFILES/.git-completion.bash 
fi 
gitFindParams="-maxdepth 1 -mindepth 1 -type d -regex '[^.]*$'"
gitCDInto="-exec sh -c '(cd {} && if [ -d .git ]; then echo {}"
alias gitStatusAll="echo && find -L $REPOS $gitFindParams $gitCDInto && git status --short --branch  && echo; fi)' \;"
alias gitPushAll="  echo && find -L $REPOS $gitFindParams $gitCDInto && git push --all               && echo; fi)' \;"
alias gitPullAll="  echo && find -L $REPOS $gitFindParams $gitCDInto && git pull                     && echo; fi)' \;"

# Tmux
alias tmux="tmux -u"
alias t0="tmux attach-session -t 0"
alias t1="tmux attach-session -t 1"
alias t2="tmux attach-session -t 2"
alias t3="tmux attach-session -t 3"
alias t4="tmux attach-session -t 4"

# fzf
export FZF_DEFAULT_COMMAND="find ~ | grep -v -e '\.git' -e '\.swp'"     # Find all including hiddens but ignore .git
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
function search-directory() {
	result=$(find ~ -type d 2> /dev/null | grep -v -e ".git" | fzf)
	if [[ ! -z "$result" ]]; then echo $result ; fi
}
function change-directory() {
	result=$(search-directory)
	if [[ ! -z "$result" ]]; then cd "$result" && echo -e "pwd changed to: $result \c" && getGitFileStatus && echo ; fi
} 
function search-all-files() {
	result=$(find ~ -type f 2> /dev/null | grep -v -e ".git" | fzf)
	if [[ ! -z "$result" ]]; then echo $result ; fi
}
function open-file-in-vim() { 
    result=$(search-all-files) 
    if [[ ! -z "$result" ]]; then nvim "$result" ; fi
}
function search-sh-scripts() {
    result=$(find ~ -type f 2> /dev/null | grep ".sh$" | fzf)
    if [[ ! -z "$result" ]]; then echo $result ; fi
}
function execute-sh-scripts() {
    result=$(search-sh-scripts) 
    if [[ ! -z "$result" ]]; then bash "$result" ; fi
}
# Key bindings
bind -x '"\ed": "change-directory"'
bind -x '"\ef": "open-file-in-vim"'
bind -x '"\eg": "execute-sh-scripts"' 
bind -x '"\er": "ranger"' 

# Prompt
getGitBranchStatus() { git status --short --branch 2> /dev/null | head -n 1 ; }
getGitFileStatus() { git -c color.status=always status --short 2> /dev/null | tr '\n' " " ; }
# Set variable identifying the chroot for use in promt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then debian_chroot=$(cat /etc/debian_chroot) ; fi
# Set default prompt info & colors
PS1='${debian_chroot:+($debian_chroot)}\[\033[00;90m\]\u@\h\[\033[00m\] \[\033[00;32m\]\w\[\033[00m\] \[\033[00;90m\]`getGitBranchStatus`\[\033[00m\] `getGitFileStatus`
\[\033[00;90m\]\$\[\033[00m\] '
