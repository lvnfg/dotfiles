# set color prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# for non-color prompt
# PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

alias t0='tmux attach -d -t 0'
