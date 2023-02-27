path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $path
# repo_path=$(readlink -f "../../")
repo_path=$path

action="$1"

NAME="dotfiles"
IMAGE_NAME="$NAME:latest"
DETACH_KEYS="ctrl-x,x"
TEMP_BUILD_DIR_PATH="$path/.tmpbuild"

build () {
    # Removing running image and container
    sudo docker container kill $NAME 2> /dev/null
    sudo docker container rm $NAME   2> /dev/null
    sudo docker image rm $IMAGE_NAME 2> /dev/null
    # ----------------------------------------------------------------
    # Gather build resources. External and downladed files should
    # first be downloaded and put here, then copy over to docker
    # during build script to take advantage of caching.
    # ----------------------------------------------------------------
    set -euox pipefail
    cd $path
    mkdir -p $TEMP_BUILD_DIR_PATH
    cd $TEMP_BUILD_DIR_PATH
    # Trap cleanup
    trap "rm -rf $TEMP_BUILD_DIR_PATH" EXIT
    # Dev tool scripts
    rm -rf dotfiles
    git clone https://github.com/lvnfg/dotfiles --depth 1
    # ----------------------------------------------------------------
    # Build image
    # ----------------------------------------------------------------
    cd $path
    # sudo docker image build --no-cache --tag $IMAGE_NAME .
    sudo docker image build --tag $IMAGE_NAME .
}

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

attach () {
    acm="sudo docker container attach --detach-keys=$DETACH_KEYS $NAME"
    $acm || run && $acm
}


# Allow calling script with function name as argument
"$@"
