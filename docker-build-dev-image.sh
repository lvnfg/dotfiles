set -euo pipefail
echo 🚸 $0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$path"

IMAGE_NAME="dev:latest"

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

echo "✅ $0"
