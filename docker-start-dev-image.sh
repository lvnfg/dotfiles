NAME="dev"

sudo docker start -i $NAME || sudo docker run --rm -it --name $NAME $NAME:latest
