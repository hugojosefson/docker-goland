FROM hugojosefson/ubuntu-gnome:18.10
MAINTAINER Hugo Josefson <hugo@josefson.org> (https://www.hugojosefson.com/)

RUN apt-get update && apt-get install -y curl wget jq x11-apps && apt-get clean

CMD /opt/webstorm/bin/webstorm.sh

RUN mkdir /tmp/install-webstorm
WORKDIR /tmp/install-webstorm
COPY latest-download-url .
COPY url-to-version .
COPY install-webstorm .
ARG DOWNLOAD_URL
RUN ./install-webstorm "${DOWNLOAD_URL}"

WORKDIR /


