FROM    debian:buster
LABEL   maintainer="van@fagaceae.com"
COPY    . /root
WORKDIR /root
RUN     bash setup.sh vm dev dot vim
