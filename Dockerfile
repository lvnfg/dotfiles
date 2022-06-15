FROM debian:bullseye-backports

# https://docs.docker.com/engine/reference/builder/#run
RUN    apt-get update && apt-get upgrade -y \
    && apt-get install -y wget \
    && apt-get install -y unzip \
    && apt-get install -y tar \
    && apt-get install -y curl \
    && apt-get install -y fzf \
    && apt-get install -y ripgrep \
    && apt-get install -y build-essential \
    && apt-get install -y git \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p ~/repos \
    && cd ~/repos && git clone https://github.com/lvnfg/dotfiles && cd dotfiles \
    && bash "install-python.sh" \
    && bash "install-bash.sh" \
    && bash "install-git.sh" \
    && bash "install-ranger.sh" \
    && bash "install-tmux.sh" \
    && bash "install-top.sh" \
    && bash "install-msodbcsql.sh" \
    && bash "install-pyodbc.sh" \
    && bash "install-mssql-cli.sh" \
    && bash "install-bat.sh" \
    && bash "install-nvim.sh" \
    && bash "install-nvim-core-plugins.sh" \
    && bash "install-nvim-lsp-plugins.sh" \
    && bash "install-nvim-lsp-pyright.sh" \
    && rm -rf ~/repos/dotfiles \
    && echo "dev dockerfile ✅"


# https://docs.docker.com/engine/reference/builder/#cmd
CMD ["tmux", "new-session", "-A", "-s", "0"]
