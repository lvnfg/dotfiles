path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $path

action="$1"

NAME="dot"
IMAGE_NAME="$NAME:latest"

run() {
    sudo docker run \
        -it -d \
        --hostname atm \
        --env-file ./.secrets \
        --mount type=bind,source="$path",target=/root/repos/atm \
        -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
        --name $NAME \
        $NAME:latest
}

attach () {
    sudo docker container attach $NAME
}

killc () {
    sudo docker container kill $NAME
}

remove () {
    sudo docker container rm $NAME
}

restart () {
    killc
    remove
    start
}

build () {
    killc
    remove
    # Make atm executable if not already
    chmod +x "./atm/atm.py"
    # Create image
    echo "Building container image"
    # Remove previous version
    if [[ "$(sudo docker image instpect &IMAGE_NAME 2> /dev/null)" == "" ]]; then
        echo "$IMAGE_NAME doesn't exists"
    else
        echo "Removing $IMAGE_NAME"
        sudo docker image rm $IMAGE_NAME
    fi
    # Build new image
    sudo docker image build --no-cache --tag $IMAGE_NAME .
}

# Allow calling script with function name as argument
"$@"
