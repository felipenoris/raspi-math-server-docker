#!/bin/bash

docker create -v /home/pi:/pi -p 8787:8787 -p 8000:8000 --name ms1 math-server:latest
docker start ms1
docker exec ms1 useradd myuser -d /pi -m -u 1000 -s /bin/bash
docker exec -it ms1 passwd myuser
