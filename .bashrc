#!/bin/bash

# --------------------------------------------------------------------------
# Bash shell
# --------------------------------------------------------------------------
# Core directories
export REPOS="$HOME/repos" 
export DOTFILES="$REPOS/dotfiles" 
# Use vim keybindings in bash prompts
set -o vi
# Set default editor
alias vim="nvim"
export VISUAL="nvim" 
export EDITOR="nvim"
# Always run ls -al
alias ls="ls -al -h --color=auto --group-directories-first"
# Enable bash completion
[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion 
# Add ~/.local/bin to path for mssql-cli, ptpython, and other pip executatbles.
# Add at beginning since often local packages are meant to replace system defaults.
PATH="$HOME/.local/bin":$PATH

# --------------------------------------------------------------------------
# Tmux
# --------------------------------------------------------------------------
export TERM=screen-256color             # Let vim & tmux terminals use colors
alias tmux="tmux -u"
alias t0="tmux attach-session -t 0"
alias t1="tmux attach-session -t 1"
alias t2="tmux attach-session -t 2"
alias t3="tmux attach-session -t 3"
alias t4="tmux attach-session -t 4"

# --------------------------------------------------------------------------
# Bat syntax highlighting
# --------------------------------------------------------------------------
# Turn off paging
alias bat='bat --paging=never'
# Replace cat with bat (make highlighting available to fzf in vim, don't know why)
alias cat='bat --paging=never'
# FZF preview option
bat_fzf_preview="bat --style=numbers --colors=always --line-range :500 {}"
# Use bat as colorizing pageer for man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# --------------------------------------------------------------------------
# Git
# --------------------------------------------------------------------------
# Enable git autocomplion in bash
if [ -f $DOTFILES/.git-completion.bash ]; then 
    source $DOTFILES/.git-completion.bash 
fi 
# Convenience git alias
gitFindParams="-maxdepth 1 -mindepth 1 -type d -regex '[^.]*$'"
gitCDInto="-exec sh -c '(cd {} && if [ -d .git ]; then echo {}"
alias gitStatusAll="echo && find -L $REPOS $gitFindParams $gitCDInto && git status --short --branch  && echo; fi)' \;"
alias gitPushAll="  echo && find -L $REPOS $gitFindParams $gitCDInto && git push --all               && echo; fi)' \;"
alias gitPullAll="  echo && find -L $REPOS $gitFindParams $gitCDInto && git pull                     && echo; fi)' \;"

# --------------------------------------------------------------------------
# FZF
# --------------------------------------------------------------------------
export FZF_DEFAULT_COMMAND="find ~ | grep -v -e '\.git' -e '\.swp'"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
function fzf-change-directory() {
	result=$(find ~ -type d 2> /dev/null | grep -v -e ".git" | fzf)
	if [[ ! -z "$result" ]]; then cd "$result" && echo -e "pwd changed to: $result \c" && getGitFileStatus && echo ; fi
} 
function fzf-open-file-in-vim() { 
	result=$(find ~ -type f 2> /dev/null | grep -v -e ".git" | fzf --preview 'bat --color=always {}')
    if [[ ! -z "$result" ]]; then nvim "$result" ; fi
}
function fzf-execute-sh-scripts() {
    result=$(find ~ -type f 2> /dev/null | grep ".sh$" | fzf --preview 'bat --color=always {}')
    if [[ ! -z "$result" ]]; then bash "$result" ; fi
}
function fzf-search-all-files-and-paste-to-prompt() {
	result=$(find ~ -type f 2> /dev/null | grep -v -e ".git" | fzf --preview 'bat --color=always {}')
	if [[ ! -z "$result" ]]; then 
	    tmux set-buffer "$result"
	    tmux paste-buffer & 
    fi
}
# Key bindings
bind -x '"\ed": "fzf-change-directory"'
bind -x '"\ef": "fzf-open-file-in-vim"'
bind -x '"\ee": "fzf-execute-sh-scripts"' 
bind -x '"\eg": "fzf-search-all-files-and-paste-to-prompt"' 

# --------------------------------------------------------------------------
# Ranger
# --------------------------------------------------------------------------
bind -x '"\er": "ranger"' 

# --------------------------------------------------------------------------
# Prompt
# --------------------------------------------------------------------------
getGitBranchStatus() { git status --short --branch 2> /dev/null | head -n 1 ; }
getGitFileStatus() { git -c color.status=always status --short 2> /dev/null | tr '\n' " " ; }
# Set variable identifying the chroot for use in promt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then debian_chroot=$(cat /etc/debian_chroot) ; fi
# Set default prompt info & colors
PS1='${debian_chroot:+($debian_chroot)}\[\033[00;90m\]\u@\h\[\033[00m\] \[\033[00;32m\]\w\[\033[00m\] \[\033[00;90m\]`getGitBranchStatus`\[\033[00m\] `getGitFileStatus`
\[\033[00;90m\]\$\[\033[00m\] '
