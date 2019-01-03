FROM ubuntu:18.10
MAINTAINER Hugo Josefson <hugo@josefson.org> (https://www.hugojosefson.com/)

RUN apt-get update && apt-get install -y curl wget jq && apt-get clean

ENTRYPOINT /opt/webstorm/bin/webstorm.sh

RUN mkdir /tmp/install-webstorm
WORKDIR /tmp/install-webstorm
COPY latest-download-url .
COPY url-to-version .
COPY install-webstorm .
RUN ./install-webstorm

WORKDIR /

ARG DOWNLOAD_URL


