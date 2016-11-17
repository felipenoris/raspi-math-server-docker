
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
    cmake \
    sqlite3 \
    libsqlite3-dev \
    git \
    python \
    python3 \
    curl


ENV PATH /usr/local/sbin:/usr/local/bin:$PATH

# Makes git use https by default
RUN git config --global url."https://".insteadOf git://

#RUN echo "deb http://archive.raspbian.org/raspbian/ stretch main" >> /etc/apt/source.list

RUN apt -y install r-base r-base-core r-base-dev

# node
ENV NODE_VER 7.1.0

RUN wget https://github.com/nodejs/node/archive/v$NODE_VER.tar.gz \
	&& tar xf v$NODE_VER.tar.gz && cd node-$NODE_VER \
	&& ./configure \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& cd .. && rm -f v$NODE_VER.tar.gz && rm -rf node-$NODE_VER

# reinstall npm with the lastest version
RUN npm cache clean \
	&& curl -L https://npmjs.org/install.sh | sh

# Julia
ENV JULIA_VER_MAJ 0.5
ENV JULIA_VER_MIN .0
ENV JULIA_VER $JULIA_VER_MAJ$JULIA_VER_MIN

RUN wget https://github.com/JuliaLang/julia/releases/download/v$JULIA_VER/julia-$JULIA_VER-full.tar.gz \
		&& tar xf julia-$JULIA_VER-full.tar.gz

ADD julia-Make.user julia-$JULIA_VER/Make.user

RUN cd julia-$JULIA_VER \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& ln -s /usr/local/julia/bin/julia /usr/local/bin/julia \
	&& cd .. \
	&& rm -rf julia-$JULIA_VER && rm -f julia-$JULIA_VER-full.tar.gz && rm -rf cpuid

ENV JULIA_PKGDIR /usr/local/julia/share/julia/site

# Init package folder on root's home folder
RUN julia -e 'Pkg.init()'
