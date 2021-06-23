# Get hosttype and define base locations
hosttype=""
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     hosttype=linux;;
    Darwin*)    hosttype=mac;;
    CYGWIN*)    hosttype=cygwin;;
    MINGW*)     hosttype=MinGw;;
    *)          hosttype="UNKNOWN:${unameOut}"
esac
repos="$HOME/repos"
dotfiles="$repos/dotfiles"

# Set default terminal editor = vim for mac
defaultEditor="$(which nvim)"
if [ -z "$defaultEditor" ]; then
    defaultEditor="vim"
fi
export VISUAL="$defaultEditor"
export EDITOR="$defaultEditor"

# -----------------------------------------------
# Core aliases
# -----------------------------------------------
alias dot="python3 $repos/dotfiles/dot.py"
alias atm="python3 $repos/atm/main.py"

# -----------------------------------------------
# Cloud work
# -----------------------------------------------
function getPublicIP() {
    publicIP="$(curl ipecho.net/plain)"
    echo $publicIP
}

# -----------------------------------------------
# bash-completion
# -----------------------------------------------
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# -----------------------------------------------
# Git
# -----------------------------------------------
# Get current git branch name to display in prompt
getGitBranchStatus() {
    git status --short --branch 2> /dev/null | head -n 1
}
getGitFileStatus() {
    git -c color.status=always status --short 2> /dev/null | tr '\n' " "
}
# Enable git autocomple in bash
if [ -f ~/repos/dotfiles/.git-completion.bash ]; then
  . ~/repos/dotfiles/.git-completion.bash
fi
# Aliases
alias gitppush="git pull && git push"
gitFindParams="-maxdepth 1 -mindepth 1 -type d -regex '[^.]*$'"
alias gitStatusAll="echo && find -L $repos $gitFindParams    -exec sh -c '(cd {} && if [ -d .git ]; then echo {} && git status --short --branch  && echo; fi)' \;"
alias gitPushAll="echo && find -L $repos $gitFindParams      -exec sh -c '(cd {} && if [ -d .git ]; then echo {} && git push --all               && echo; fi)' \;"
alias gitPullAll="echo && find -L $repos $gitFindParams      -exec sh -c '(cd {} && if [ -d .git ]; then echo {} && git pull                     && echo; fi)' \;"

# -----------------------------------------------
# Tmux 
# -----------------------------------------------
alias t0="tmux attach-session -t 0"
alias t1="tmux attach-session -t 1"
alias t2="tmux attach-session -t 2"
alias t3="tmux attach-session -t 3"
alias t4="tmux attach-session -t 4"

# -----------------------------------------------
# Vim & fzf
# -----------------------------------------------
# Find all including hiddens but ignore .git
if [[ "$hosttype" = mac ]]; then
    export FZF_DEFAULT_COMMAND="find $repos | grep -v -e '\.git' -e '\.swp'"
else
    export FZF_DEFAULT_COMMAND="find ~ | grep -v -e '\.git' -e '\.swp'"
fi
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
# Fzf search and action functions
searchDirectory() {
    if [[ "$hosttype" = mac ]]; then
	    result=$(find $repos -type d 2> /dev/null | grep -v -e ".git" | fzf)
	else
	    result=$(find ~ -type d 2> /dev/null | grep -v -e ".git" | fzf)
	fi
	if [[ ! -z "$result" ]]; then
		echo $result
	fi
}
changeDirectory() {
	result=$(searchDirectory)
	if [[ ! -z "$result" ]]; then
		cd "$result"
		echo -e "--> $result \c" && getGitFileStatus
		echo
    fi
} 
searchFile() {
    if [[ "$hosttype" = mac ]]; then
	    result=$(find $repos -type f 2> /dev/null | grep -v -e ".git" | fzf)
	else
	    result=$(find ~ -type f 2> /dev/null | grep -v -e ".git" | fzf)
	fi
	if [[ ! -z "$result" ]]; then
        echo $result
    fi
}
openFileInCode() {
	result=$(searchFile)
	hasCode=$(which code)
	if [[ ! -z "$result" ]]; then
        code "$result"
    fi
}
openFileInVim() {
	result=$(searchFile)
	if [[ ! -z "$result" ]]; then
        $defaultEditor "$result"
    fi
}
# Aliases
bind -x '"ç":changeDirectory'   # Opt-c
bind -x '"√":openFileInVim'     # Opt-v
bind -x '"∂":openFileInCode'    # Opt-d

# Prompt & terminal
# -----------------------------------------------
# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# Set default prompt info & colors
PS1='${debian_chroot:+($debian_chroot)}\[\033[00;90m\]\u@\h\[\033[00m\] \[\033[00;32m\]\w\[\033[00m\] \[\033[00;90m\]`getGitBranchStatus`\[\033[00m\] `getGitFileStatus`
\[\033[00;90m\]\$\[\033[00m\] '
# Use vim keybindings in bash prompts
set -o vi    
# Let vim & tmux terminals use colors
# export TERM=xterm-256color
export TERM=screen-256color

# ------------------------------------------------
# ls
# ------------------------------------------------
# Set ls color schemes
LS_COLORS='rs=0:di=01;92:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
# Make ls color persistent across sessions
export LS_COLORS
# Set default ls behavior
if [ "$hosttype" == linux ]; then
    alias ls="ls -al -h --color=auto --group-directories-first"
elif [ "$hosttype" == mac ]; then
    alias ls="gls -al -h --color=auto --group-directories-first"
fi
