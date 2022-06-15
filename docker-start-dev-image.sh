NAME="dev"

sudo docker start -i $NAME || sudo docker run --mount type=bind,source="$HOME"/repos/dotfiles,target=/root/repos/dotfiles -it --name $NAME $NAME:latest
