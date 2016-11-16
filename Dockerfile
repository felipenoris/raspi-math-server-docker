
FROM sdhibit/rpi-raspbian

MAINTAINER felipenoris <felipenoris@users.noreply.github.com>

WORKDIR /root

RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    wget \
    gcc \
    g++ \
    gfortran \
    m4 \
    cmake

