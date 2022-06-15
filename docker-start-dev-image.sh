NAME="dev"

sudo docker start -i $NAME || sudo docker run \
    --rm -it \
    -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    --name $NAME $NAME:latest
