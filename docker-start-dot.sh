NAME="dot"

sudo docker start -i $NAME || sudo docker run \
    -it \
    --hostname dot \
    -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    --name $NAME $NAME:latest
