path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $path

action="$1"

NAME="dotfiles"
IMAGE_NAME="$NAME:latest"
DETACH_KEYS="ctrl-x,ctrl-x"

build() {
    # Quick build with cache reuse if possible
    # Removing running image and container
    sudo docker container kill $NAME 2> /dev/null
    sudo docker container rm $NAME   2> /dev/null
    sudo docker image rm $IMAGE_NAME 2> /dev/null
    set -euox pipefail
    cd $path
    sudo docker image build --no-cache --tag $IMAGE_NAME .
}

run() {
    repo_path=$path
    sudo docker run \
        -it -d \
        --rm \
	    --detach-keys=$DETACH_KEYS \
        --name $NAME \
        --hostname $NAME \
        --publish="3389:3389/tcp" \
        --publish="7071:7071/tcp" \
        --publish="8080:8080/tcp" \
        --mount type=bind,source="$repo_path",target=/root/repos/dotfiles \
        $NAME:latest
}

attach () {
    acm="sudo docker container attach --detach-keys=$DETACH_KEYS $NAME"
    $acm || run && $acm
}


# Allow calling script with function name as argument
"$@"
