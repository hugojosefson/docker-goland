FROM ubuntu:18.10
MAINTAINER Hugo Josefson <hugo@josefson.org> (https://www.hugojosefson.com/)

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y apt-utils \
  && apt-get dist-upgrade --purge -y \
  && apt-get autoremove --purge -y \
  && apt-get install -y \
    curl                $(: 'required by these setup scripts') \
    wget                $(: 'required by these setup scripts') \
    jq                  $(: 'required by these setup scripts') \
    gosu                $(: 'for better process signalling in docker') \
    x11-apps            $(: 'basic X11 support') \
    libxtst6            $(: 'required by goland') \
    libxi6              $(: 'required by goland') \
    openjfx             $(: 'required by goland') \
    libopenjfx-java     $(: 'required by goland') \
    matchbox            $(: 'required by goland') \
    libxslt1.1          $(: 'required by goland') \
    libgl1-mesa-dri     $(: 'required by goland') \
    libgl1-mesa-glx     $(: 'required by goland') \
    golang              $(: 'required by goland') \
    firefox             $(: '~required by goland' ) \
    git                 $(: '~required by goland' ) \
    libnss3             $(: 'required by jetbrains-toolkit, for logging in' ) \
    vim                 $(: 'useful') \
  && apt-get clean

ARG GOLAND_URL
ARG TOOLBOX_URL
RUN mkdir /tmp/install-jetbrains
COPY \
  jetbrains-url-to-version \
  /tmp/install-jetbrains/
COPY \
  install-goland \
  latest-goland-url \
  /tmp/install-jetbrains/
RUN /tmp/install-jetbrains/install-goland "${GOLAND_URL}"
COPY \
  install-toolbox \
  latest-toolbox-url \
  /tmp/install-jetbrains/
RUN /tmp/install-jetbrains/install-toolbox "${TOOLBOX_URL}" 
RUN rm -rf /tmp/install-goland

WORKDIR /
COPY entrypoint /
ENTRYPOINT ["/entrypoint"]
CMD ["/usr/local/bin/goland"]
