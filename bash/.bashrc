#!/bin/bash

# --------------------------------------------------------------------------
# BASH SHELL
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
# Enable true colors for terminals that support it
export TERM=xterm-256color

# --------------------------------------------------------------------------
# LESS PAGER
# --------------------------------------------------------------------------
# litecli uses this
# S = Disable line wrap
# R = Allow colors through (fix git diff)
export LESS="RS"

# --------------------------------------------------------------------------
# TMUX
# --------------------------------------------------------------------------
alias tmux="tmux -u"                    # Force UTF-8 output
alias ta="tmux attach-session -t"

# --------------------------------------------------------------------------
# BAT (SYNTAX HIGHLIGHTING PREVIEW FOR FZF)
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
# GIT
# --------------------------------------------------------------------------
# Convenience git alias
gitFindParams="-maxdepth 1 -mindepth 1 -type d -regex '[^.]*$'"
gitCDInto="-exec sh -c '(cd {} && if [ -d .git ]; then echo {}"
alias gitStatusAll="echo && find -L $REPOS $gitFindParams $gitCDInto && git status --short --branch  && echo; fi)' \;"
alias gitPushAll="  echo && find -L $REPOS $gitFindParams $gitCDInto && git push --all               && echo; fi)' \;"
alias gitPullAll="  echo && find -L $REPOS $gitFindParams $gitCDInto && git pull                     && echo; fi)' \;"

function is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

# --------------------------------------------------------------------------
# FZF
# --------------------------------------------------------------------------
export FZF_DEFAULT_COMMAND="find ~ -type f 2> /dev/null | grep -v -e '\.git' -e '\.swp'"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

function fzf-down() {
    # Default command for keybindings-invokded fzf
    fzf --height 50% --min-height 20 --border \
        --bind 'alt-f:abort' \
        --bind 'alt-d:abort' \
        --bind 'alt-s:abort' \
        --bind 'alt-D:abort' \
        --bind 'alt-g:abort' \
        --bind 'alt-c:abort' \
        --bind 'alt-C:abort' \
        --bind 'alt-p:execute-silent(tmux set-buffer "{}" && tmux paste-buffer)+abort' \
        "$@"
}

function fzf-change-directory() {
    result=$(find ~ -type d 2> /dev/null | grep -v -e "\.git" | fzf-down)
	if [[ ! -z "$result" ]]; then cd "$result" && echo -e "pwd changed to: $result \c" && getGitFileStatus && echo ; fi
}

function fzf-file-open-in-vim() {
    result=$(find ~ -type f 2> /dev/null | grep -v -e "\.git" -e "\.swp" | fzf-down --preview 'bat --color=always {}')
    if [[ ! -z "$result" ]]; then nvim "$result" ; fi
}

function fzf-script-run() {
    result=$(find ~ -type f 2> /dev/null | grep -E ".*\.(sh$|py$)" | fzf-down --preview 'bat --color=always {}')
    if [[ -z "$result" ]]; then return ; fi
    extension="${result##*.}"
    if [[ "$extension" = "sh" ]]; then
        time bash "$result"
    elif [[ "$extension" = "py" ]]; then
        python3 "$result"
    fi
}

function fzf-difftool() {
# Compare any 2 files. To compare a single file with its most recent commit, cancel (press ESC) the 2nd file
	file1=$(find ~ -type f 2> /dev/null | grep -v -e ".git" | fzf-down --preview 'bat --color=always {}')
	if [[ ! -z "$file1" ]]; then
	    file2=$(find ~ -type f 2> /dev/null | grep -v -e ".git" | fzf-down --preview 'bat --color=always {}')
	    if [[ ! -z "$file1" && ! -z "$file2" ]]; then
	        nvim -d "$file1" "$file2"
	    elif [[ ! -z "$file1" && -z "$file2" ]]; then
            path="$(cd "$(dirname "$file1")" && pwd)"
            cd "$path"
            git difftool "$file1"
        fi
	fi
}


# Ffz git functions:
# https://junegunn.kr/2016/07/fzf-git/
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
function fzf-git-file-status() {
    # git status -s | fzf --preview 'git diff --color=always {+2}'
    # Note: since git status ouput [M {filename}], the {+2} option is needed to tell fzf
    # to split the filename into 2 parts, then use the 2nd part to use with git diff
    is_in_git_repo || return
    git -c color.status=always status --short |
    fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
    cut -c4- | sed 's/.* -> //'
}

function fzf-git-branch() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

function fzf-git-commit() {
    is_in_git_repo || return
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
    fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
    grep -o "[a-f0-9]\{7,\}"
}

function fzf-git-remote() {
    is_in_git_repo || return
    git remote -v | awk '{print $1 "\t" $2}' | uniq |
    fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
    cut -d$'\t' -f1
}

function fzf-git-stash() {
    is_in_git_repo || return
    git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
    cut -d: -f1
}

# Key bindings
bind '"\er": redraw-current-line'           # required to clear up the prompt when not on tmux.
# File & directories
bind -x '"\ed": "fzf-change-directory"'
bind -x '"\es": "fzf-script-run"'
bind -x '"\ef": "fzf-file-open-in-vim"'
# Diffing
bind -x '"\eD": "fzf-difftool"'
# Git specific
bind -x '"\eg": "fzf-git-file-status"'
bind -x '"\eb": "fzf-git-branch"'
bind -x '"\ec": "fzf-git-commit"'
# bind -x '"\es": "fzf-git-stash"'


# --------------------------------------------------------------------------
# BASH PROMPT
# --------------------------------------------------------------------------
getGitBranchStatus() { git status --short --branch 2> /dev/null | head -n 1 ; }
getGitFileStatus() { git -c color.status=always status --short 2> /dev/null | tr '\n' " " ; }
# Set variable identifying the chroot for use in promt
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then debian_chroot=$(cat /etc/debian_chroot) ; fi
# Set default prompt info & colors
PS1='${debian_chroot:+($debian_chroot)}\[\033[00;96m\]\u\[\033[00;90m\]@\[\033[00;31m\]\h\[\033[00m\] \[\033[00;32m\]\w\[\033[00m\] \[\033[00;90m\]`getGitBranchStatus`\[\033[00m\] `getGitFileStatus`
\[\033[00;90m\]\$\[\033[00m\] '
