
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
    curl \
    vim


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

RUN apt -y install openssl libssl-dev

RUN cd julia-$JULIA_VER \
	&& make -j"$(nproc --all)" julia-deps

RUN cd julia-$JULIA_VER \
	&& make -j"$(nproc --all)"

RUN cd julia-$JULIA_VER \
	&& echo "prefix=/usr/local/julia" >> Make.user \
	&& make -j"$(nproc --all)" install \
	&& ln -s /usr/local/julia/bin/julia /usr/local/bin/julia 

RUN rm -rf julia-$JULIA_VER && rm -f julia-$JULIA_VER-full.tar.gz

ENV JULIA_PKGDIR /usr/local/julia/share/julia/site

# Init package folder on root's home folder
RUN julia -e 'Pkg.init()'

# pip
RUN apt -y install python-pip python3-pip

RUN pip2 install -U pip

RUN pip3 install -U pip

RUN apt -y install python-dev python3-dev libzmq3 libzmq3-dev

# Jupyter
RUN pip2 install \
	IPython \
	notebook \
	ipykernel \
	ipyparallel \
	enum34 \
	&& python2 -m ipykernel install

RUN pip3 install \
	IPython \
	jupyterhub \
	notebook \
	ipykernel \
	ipyparallel \
	enum34 \
	&& python3 -m ipykernel install

RUN npm install -g configurable-http-proxy
