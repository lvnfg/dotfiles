NAME="dot"
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $path

bash docker-kill-$NAME.sh
sudo docker container rm $NAME
bash docker-start-$NAME.sh
