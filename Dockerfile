FROM ubuntu:22.04

RUN sed -i 's@/archive.ubuntu.com/@/mirrors.aliyun.com/@g' /etc/apt/sources.list
RUN apt-get -y update && apt-get install -y  \
	build-essential   \
	cmake             \
	git               \
	curl              \
	libcurl4-openssl-dev \
	libgmp-dev        \
	libssl-dev        \
	llvm-11-dev       \
	python3-numpy     \
	file              \
	gdb               \
	zlib1g-dev        \
	clang             \
	clang-tidy        \
	libxml2-dev       \
	opam ocaml-interp \
	python3           \
	python3-pip       \
	vim               \
	time              \
	jq            &&  \
	apt-get clean &&  \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN python3 -m pip install pygments
RUN mkdir -p /local/eosnetworkfoundation
RUN mkdir -p /bigata1/log
RUN mkdir -p /bigata1/savanna/nodeos-one
RUN mkdir -p /bigata1/savanna/nodeos-two
RUN mkdir -p /bigata1/savanna/nodeos-three
RUN chmod 777 /local/eosnetworkfoundation
RUN chmod 777 /bigata1/log
RUN chmod 777 /bigata1/savanna
RUN chmod 777 /bigata1/savanna/nodeos-one
RUN chmod 777 /bigata1/savanna/nodeos-two
RUN chmod 777 /bigata1/savanna/nodeos-three

RUN echo 'root:Docker!' | chpasswd
RUN useradd -ms /bin/bash enfuser

USER enfuser
WORKDIR /local/eosnetworkfoundation
RUN mkdir /local/eosnetworkfoundation/software
WORKDIR /local/eosnetworkfoundation/software
COPY --from=kongkong10/savanna-antelope-final:v1.0.1 /local/eosnetworkfoundation/software/spring/*.deb .
COPY --from=kongkong10/savanna-antelope-final:v1.0.1 /local/eosnetworkfoundation/software/cdt/*.deb .

USER root
RUN dpkg -i /local/eosnetworkfoundation/software/*.deb
EXPOSE 8888

USER enfuser
WORKDIR /local/eosnetworkfoundation
RUN mkdir /local/eosnetworkfoundation/repos
WORKDIR /local/eosnetworkfoundation/repos
COPY --from=kongkong10/savanna-antelope-final:v1.0.1 /local/eosnetworkfoundation/repos/reference-contracts .
COPY --from=kongkong10/savanna-antelope-final:v1.0.1 /local/eosnetworkfoundation/repos/eos-system-contracts .
COPY --from=kongkong10/savanna-antelope-final:v1.0.1 /local/eosnetworkfoundation/repos/bootstrap-private-network .
COPY --from=kongkong10/savanna-antelope-final:v1.0.1 /local/eosnetworkfoundation/repos/eosio.time .
