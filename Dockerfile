
FROM sdhibit/rpi-raspbian

MAINTAINER felipenoris <felipenoris@users.noreply.github.com>

WORKDIR /root

RUN apt update \
	&& apt -y upgrade
