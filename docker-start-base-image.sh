NAME="base-image"

sudo docker start -i $NAME || sudo docker run -it --name $NAME base-image:latest
