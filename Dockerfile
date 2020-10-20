FROM    debian:buster
LABEL   maintainer="van@fagaceae.com"
COPY    . /root/repos/dotfiles
WORKDIR /root/repos/dotfiles
RUN     bash setup.sh vm dot vim dev
