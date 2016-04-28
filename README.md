# phpredmine-docker
Alpine based image for PHPRedmine redist web frontend

Usage: 
Start redis container: 

`docker run --rm --name myredis redis`

Start PHPRedmine: 

`docker run -it -p 8888:80 --link myredis:redis gregq/phpredmine-docker`

You can now access PHPRedmine panel at: `http://<your-docker-machine-ip>:8888/`
