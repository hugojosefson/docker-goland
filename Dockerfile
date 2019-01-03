FROM hugojosefson/ubuntu-gnome:18.10
MAINTAINER Hugo Josefson <hugo@josefson.org> (https://www.hugojosefson.com/)

RUN apt-get update && apt-get install -y curl wget jq gosu x11-apps && apt-get clean

RUN mkdir /tmp/install-webstorm
WORKDIR /tmp/install-webstorm
COPY latest-download-url .
COPY url-to-version .
COPY install-webstorm .
ARG DOWNLOAD_URL
RUN ./install-webstorm "${DOWNLOAD_URL}"
CMD ["/usr/local/bin/webstorm"]

WORKDIR /
COPY entrypoint /
ENTRYPOINT ["/entrypoint"]
