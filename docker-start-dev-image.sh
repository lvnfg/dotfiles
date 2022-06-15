NAME="dev"

sudo docker start -i $NAME || sudo docker run -it --name $NAME $NAME:latest
