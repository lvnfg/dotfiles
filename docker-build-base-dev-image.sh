set -euo pipefail

path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$path"

IMAGE_NAME="base-dev:latest"

# Create tarball
echo "Creating dotfiles tarball"
DIRNAME="dotfiles"
TARBALL="dotfiles.tar.gz"
rm -f $TARBALL
tar -cf $TARBALL $DIRNAME

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
sudo docker image build --tag $IMAGE_NAME .

# Cleanup
echo "Cleaning up"
rm $TARBALL

echo "base-dev image build ✅"
