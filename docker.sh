path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $path
# repo_path=$(readlink -f "../../")
repo_path=$path

action="$1"

NAME="dotfiles"
IMAGE_NAME="$NAME:latest"
DETACH_KEYS="ctrl-x,x"

run() {
    sudo docker run \
        -it -d \
        --rm \
	    --detach-keys=$DETACH_KEYS \
        --name $NAME \
        --hostname $NAME \
        --mount type=bind,source="$repo_path",target=/root/repos/dotfiles \
        $NAME:latest
}

killc () {
    sudo docker container kill $NAME
}

remove () {
    sudo docker container rm $NAME
}

attach () {
    sudo docker container attach --detach-keys=$DETACH_KEYS $NAME || run && sudo docker container attach $NAME
}

restart () {
    killc
    remove
    attach
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
    cd "$path/build"
    # Build new image
    # sudo docker image build --no-cache --tag $IMAGE_NAME .
    sudo docker image build --tag $IMAGE_NAME .
}

# Allow calling script with function name as argument
"$@"
