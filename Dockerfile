
FROM sdhibit/rpi-raspbian

MAINTAINER felipenoris <felipenoris@users.noreply.github.com>

WORKDIR /root

RUN apt update \
    && apt -y upgrade \
    && apt -y install \
    	cmake \
    	curl \
    	g++ \
    	gcc \
    	gfortran \
    	git \
    	libsqlite3-dev \
    	libssl-dev \
    	libzmq3 \
    	libzmq3-dev \
    	m4 \
    	openssl \
    	python \
    	python-dev \
    	python-pip \
    	python3 \
    	python3-dev \
    	python3-pip \
    	sqlite3 \
    	vim \
    	wget

ENV PATH /usr/local/sbin:/usr/local/bin:$PATH

# Update pip
RUN pip2 install -U pip

RUN pip3 install -U pip

# Makes git use https by default
RUN git config --global url."https://".insteadOf git://

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

# R
RUN apt -y install r-base r-base-core r-base-dev

# Julia
ENV JULIA_VER_MAJ 0.5
ENV JULIA_VER_MIN .0
ENV JULIA_VER $JULIA_VER_MAJ$JULIA_VER_MIN

RUN wget https://github.com/JuliaLang/julia/releases/download/v$JULIA_VER/julia-$JULIA_VER-full.tar.gz \
		&& tar xf julia-$JULIA_VER-full.tar.gz

RUN cd julia-$JULIA_VER \
	&& echo "prefix=/usr/local/julia" >> Make.user \
	&& make -j"$(nproc --all)" \
	&& make -j"$(nproc --all)" install \
	&& ln -s /usr/local/julia/bin/julia /usr/local/bin/julia \
	&& rm -rf julia-$JULIA_VER && rm -f julia-$JULIA_VER-full.tar.gz

ENV JULIA_PKGDIR /usr/local/julia/share/julia/site

# Init package folder on root's home folder
RUN julia -e 'Pkg.init()'

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

# TeX
ADD texlive.profile texlive.profile

# non-interactive http://www.tug.org/pipermail/tex-live/2008-June/016323.html
# Official link: http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN wget http://mirrors.rit.edu/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz \
	&& mkdir install-tl \
	&& tar xf install-tl-unx.tar.gz -C install-tl --strip-components=1 \
	&& ./install-tl/install-tl -profile ./texlive.profile --location http://mirrors.rit.edu/CTAN/systems/texlive/tlnet \
	&& rm -rf install-tl && rm -f install-tl-unx.tar.gz

ENV PATH /usr/local/texlive/distribution/bin/x86_64-linux:$PATH
