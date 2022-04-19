#!/bin/bash

# --------------------------------------------------------------------------
# Bash shell
# --------------------------------------------------------------------------
# Core directories
export REPOS="$HOME/repos"
# Use vim keybindings in bash prompts
set -o vi
# Set default editor
alias vim="nvim"
export VISUAL="nvim"
export EDITOR="vim"
# Always run ls -al
alias ls="ls -al -h --color=auto --group-directories-first"
# Add ~/.local/bin to path for mssql-cli, ptpython, and other pip executatbles.
# Add at beginning since often local packages are meant to replace system defaults.
PATH="$HOME/.local/bin":$PATH

# --------------------------------------------------------------------------
# Less pager
# --------------------------------------------------------------------------
# litecli uses this
# S = Disable line wrap
# R = Allow colors through (fix git diff)
export LESS="RS"


# --------------------------------------------------------------------------
# Tmux
# --------------------------------------------------------------------------
export TERM=screen-256color             # Let vim & tmux terminals use colors
alias tmux="tmux -u"                    # Force UTF-8 output
alias ta="tmux attach-session -t"

# --------------------------------------------------------------------------
# Bat syntax highlighting
# --------------------------------------------------------------------------
# Turn off paging
alias bat='bat --paging=never'
# Replace cat with bat
# alias cat='bat --paging=never'
# FZF preview option
bat_fzf_preview="bat --style=numbers --colors=always --line-range :500 {}"
# Use bat as colorizing pageer for man
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# --------------------------------------------------------------------------
# Git
# --------------------------------------------------------------------------
# Convenience git alias
gitFindParams="-maxdepth 1 -mindepth 1 -type d -regex '[^.]*$'"
gitCDInto="-exec sh -c '(cd {} && if [ -d .git ]; then echo {}"
alias gitStatusAll="echo && find -L $REPOS $gitFindParams $gitCDInto && git status --short --branch  && echo; fi)' \;"
alias gitPushAll="  echo && find -L $REPOS $gitFindParams $gitCDInto && git push --all               && echo; fi)' \;"
alias gitPullAll="  echo && find -L $REPOS $gitFindParams $gitCDInto && git pull                     && echo; fi)' \;"

# --------------------------------------------------------------------------
# FZF
# --------------------------------------------------------------------------
export FZF_DEFAULT_COMMAND="find ~ -type f 2> /dev/null | grep -v -e '\.git' -e '\.swp'"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
function fzf-change-directory() {
	result=$(find ~ -type d 2> /dev/null | grep -v -e "\.git" | fzf)
	if [[ ! -z "$result" ]]; then cd "$result" && echo -e "pwd changed to: $result \c" && getGitFileStatus && echo ; fi
}
function fzf-open-file-in-vim() {
	result=$(find ~ -type f 2> /dev/null | grep -v -e "\.git" -e "\.swp" | fzf --preview 'bat --color=always {}')
    if [[ ! -z "$result" ]]; then nvim "$result" ; fi
}
function fzf-git-diff-file-in-vim() {
	result=$(find ~ -type f 2> /dev/null | grep -v -e "\.git" -e "\.swp" | fzf --preview 'bat --color=always {}')
    if [[ ! -z "$result" ]]; then git difftool "$result" ; fi
}
function fzf-execute-script() {
    result=$(find ~ -type f 2> /dev/null | grep -E ".*\.(sh$|py$)" | fzf --preview 'bat --color=always {}')
    if [[ -z "$result" ]]; then return ; fi
    extension="${result##*.}"
    if [[ "$extension" = "sh" ]]; then
        bash "$result"
    elif [[ "$extension" = "py" ]]; then
        python3 "$result"
    fi
}
function fzf-search-all-files-and-paste-to-prompt() {
	result=$(find ~ -type f 2> /dev/null | grep -v -e ".git" | fzf --preview 'bat --color=always {}')
	if [[ ! -z "$result" ]]; then
	    tmux set-buffer "$result"
	    tmux paste-buffer &
    fi
}
function fzf-compare-2-files-in-vim() {
	file1=$(find ~ -type f 2> /dev/null | grep -v -e ".git" | fzf --preview 'bat --color=always {}')
	if [[ ! -z "$file1" ]]; then
	    file2=$(find ~ -type f 2> /dev/null | grep -v -e ".git" | fzf --preview 'bat --color=always {}')
	fi
	if [[ ! -z "$file1" && ! -z "$file2" ]]; then
	    nvim -d "$file1" "$file2"
    fi
}
# Key bindings
bind -x '"\ed": "fzf-change-directory"'
bind -x '"\eD": "fzf-git-diff-file-in-vim"'
bind -x '"\eC": "fzf-compare-2-files-in-vim"'
bind -x '"\ef": "fzf-open-file-in-vim"'
bind -x '"\ee": "fzf-execute-script"'
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
