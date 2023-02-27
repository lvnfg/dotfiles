FROM debian:bullseye-backports

# --------------------------------------------------
# General update
# --------------------------------------------------
SHELL ["/bin/bash", "-euox", "pipefail", "-c"]
RUN apt-get update && apt-get upgrade -y

# --------------------------------------------------
# Configure locales to display emojis
# --------------------------------------------------
SHELL ["/bin/bash", "-euox", "pipefail", "-c"]
RUN apt-get install -y locales  && locale-gen C.UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# --------------------------------------------------
# Core utilities
# procps is required to run ps in tmux's if_shell
# --------------------------------------------------
SHELL ["/bin/bash", "-euox", "pipefail", "-c"]
RUN    apt-get install -y procps          \
    && apt-get install -y wget            \
    && apt-get install -y unzip           \
    && apt-get install -y tar             \
    && apt-get install -y curl            \
    && apt-get install -y fzf             \
    && apt-get install -y ripgrep         \
    && echo ""

# --------------------------------------------------
# Install git
# Someimtes in 2022 H2 git started emitting safe.directory warnings when directories are not owned by same users and
# can be safely silenced when we are the only users in the machine.
# https://stackoverflow.com/questions/72978485/git-submodule-update-failed-with-fatal-detected-dubious-ownership-in-repositor
# --------------------------------------------------
SHELL ["/bin/bash", "-euox", "pipefail", "-c"]
RUN    apt-get install -y git \
    && git config --global --add safe.directory '*'

# --------------------------------------------------
# Install python
# Doesn't need to be put into tmpbuild since download url should return same file for same link
# lzma & liblzma-dev are required to fix importing pandas after buidling python from source
# "make install" overwrite system's python3.
# --------------------------------------------------
SHELL ["/bin/bash", "-euox", "pipefail", "-c"]
RUN    PYTHON_VERSION="3.10.4"   \
    && dir="Python-$PYTHON_VERSION" \
    && apt-get install -y build-essential \
    && tarball="$dir.tar.xz" \
    && url="https://www.python.org/ftp/python/$PYTHON_VERSION/$tarball"   \
    && apt-get update  \
    && apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev \
    && curl -O $url     \
    && tar -xf $tarball \
    && rm $tarball      \
    && cd $dir          \
    && ./configure --enable-optimizations --enable-loadable-sqlite-extensions   \
    && apt-get install -y lzma          \
    && apt-get install -y liblzma-dev   \
    && ./configure \
    && make -j 4 \
    && make install \
    && cd ..        \
    && rm -rf $dir  \
    && apt-get install -y python3-pip \
    && ln -s -f /usr/local/bin/python3 /usr/bin/python

# --------------------------------------------------
# Languages & LSP servers
# --------------------------------------------------
SHELL ["/bin/bash", "-euox", "pipefail", "-c"]
RUN    apt-get install -y nodejs  \
    && apt-get install -y npm     \
    && npm install -g pyright

# --------------------------------------------------
# Dotfiles dev tools
# Must be copied over instead of cloning directly in build script to detect script
# content changes and take advantage of caching.
# ipython must be installed after mssql-cli to override prompt-toolkit.
# nvim treesitter: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
# Treesitter requires "sudo apt instlal -y build-essential" which is installed in python steps above.
# --------------------------------------------------
SHELL ["/bin/bash", "-euox", "pipefail", "-c"]
RUN    mkdir -p ~/repos                                                            \
    && cd ~/repos && git clone https://github.com/lvnfg/dotfiles && cd dotfiles    \
    && bash "install-bash.sh"                                                      \
    && bash "install-git.sh"                                                       \
    && bash "install-ranger.sh"                                                    \
    && bash "install-tmux.sh"                                                      \
    && bash "install-top.sh"                                                       \
    && bash "install-bat.sh"                                                       \
    && bash "install-mssql-cli.sh"                                                 \
    && bash "install-ipython.sh"                                                   \
    && bash "install-nvim-core.sh"                                                      \
    && bash "install-nvim-lsp.sh"                                                  \
    && bash "install-nvim-treesitter.sh"                                           \
    && nvim --headless +"TSInstall bash vim lua python" +'sleep 20' +'qa'          \
    && echo ""

# --------------------------------------------------
# FOR DOTFILES ONLY
# Remove clone dotfiles folder to mount in later
# --------------------------------------------------
SHELL ["/bin/bash", "-euox", "pipefail", "-c"]
RUN rm -rf ~/repos/dotfiles

# https://docs.docker.com/engine/reference/builder/#cmd
CMD ["/bin/bash"]
