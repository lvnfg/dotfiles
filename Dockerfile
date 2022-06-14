FROM debian:bullseye-backports

# https://docs.docker.com/engine/reference/builder/#run
RUN    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y tar \
    && apt-get install -y git \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ~/repos \\
    && git clone https://github.com/lvnfg/dotfiles

COPY dotfiles.tar.gz .

RUN    tar -xf dotfiles.tar.gz \
    && rm dotfiles.tar.gz \
    && mv dotfiles ~/ \
    && cd ~/dotfiles \
    && ls -al \
    && bash setup-docker-base-image.sh

# https://docs.docker.com/engine/reference/builder/#cmd
CMD ["tmux", "new-session", "-A", "-s", "0"]
