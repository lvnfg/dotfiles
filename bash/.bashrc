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

# --------------------------------------------------------------------------
# COLORSCHEME
# -------------------------------------------------------------------------
# There are 3 options when working with colors in terminal.
#
#   - 16 colors. Named and numbered colors:
#                  Normal  Bright
#           Black	   00	   08
#           Red	       01	   09
#           Green	   02	   10
#           Yellow     03	   11
#           Blue	   04	   12
#           Purple     05	   13
#           Cyan       06	   14
#           White	   07	   15
#       Supported by most hardware terminal. $TERM = xterm-16color
#       These are actually color labels, since programs only print color codes
#       (i.e. [color=red]text[/endcolor] to stdout, and actually color output
#       to monitor is handled by terminal. Palette can be freely overridden,
#       there's nothing preventing the terminal to show [color=red] text in
#       blue, for example.
#
#   - 256 colors. Also named and numbered. $TERM = xterm-256color
#       Supported by most terminal eumlators. The 256 color palette is
#       essentially fixed as it'll be impractical to manage overriding all 256
#       colors. Each terminal decide how to display each named colors, so the
#       same theme will not look the same in different terminals.
#
#   - True colors. Assign color using hex code, i.e. #00AFFF. No $TERM value.
#       - Not yet widely supported by either apps for terminal. For terminals
#       that support it, setting $TERM=xterm-256color is usually enough to
#       enable true colors. Some terminal only partially support this, and
#       work by approximating output color codes to the closest 256color values
#       (i.e. tmux)
#
# To determine how to output colors, apps typically first look for the $TERM
# environment varible. If the variable is not set, well designed apps will
# the ask the terminal (hardware or simulator) for this information. Setting
# the $TERM value here should force all apps to use the same color settings,
# reglardless of what terminal is being used.
#
# Many modern (2023) apps consider 16color mode obsolete and only output color
# codes for 256 or true colors, regardless of $TERM value. Terminals that only
# support 256color but receives true color outputs typically work around the
# limitations by approximating to closest lower values.
#
# Tmux don't support approximating to 16color, and will not refuse to run if
# $TERM=xterm-16color is set.
#
# The best course of action seems to be $TERM settings everywhere to true colors,
# but only use base16 color codes in colorscheme settings.
#
export TERM=xterm-256color

# ANSI escape codes for shell prompt and other apps that support (fzf...)

# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\[\033[0;103m\]"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White

# Various variables you might want for your PS1 prompt instead
Time12h="\T"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"


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
    fzf --height 50% --min-height 20 --border --bind 'alt-p:execute-silent(tmux set-buffer "{}" && tmux paste-buffer)+abort' "$@"
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
