FROM ubuntu:18.10
MAINTAINER Hugo Josefson <hugo@josefson.org> (https://www.hugojosefson.com/)

RUN echo "Ubuntu packages last updated 2019-01-03."
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
    libxtst6            $(: 'required by webstorm') \
    libxi6              $(: 'required by webstorm') \
    openjfx             $(: 'required by webstorm') \
    libopenjfx-java     $(: 'required by webstorm') \
    matchbox            $(: 'required by webstorm') \
    libxslt1.1          $(: 'required by webstorm') \
    libgl1-mesa-dri     $(: 'required by webstorm') \
    libgl1-mesa-glx     $(: 'required by webstorm') \
    firefox             $(: '~required by webstorm' ) \
    git                 $(: '~required by webstorm' ) \
    libnss3             $(: 'required by jetbrains-toolkit, for logging in' ) \
    vim                 $(: 'useful') \
  && apt-get clean

RUN echo "WebStorm last updated 2019-01-03."
ARG WEBSTORM_URL
ARG TOOLBOX_URL
RUN mkdir /tmp/install-jetbrains
COPY \
  jetbrains-url-to-version \
  /tmp/install-jetbrains/
COPY \
  install-webstorm \
  latest-webstorm-url \
  /tmp/install-jetbrains/
RUN /tmp/install-jetbrains/install-webstorm "${WEBSTORM_URL}"
COPY \
  install-toolbox \
  latest-toolbox-url \
  /tmp/install-jetbrains/
RUN /tmp/install-jetbrains/install-toolbox "${TOOLBOX_URL}" 
RUN rm -rf /tmp/install-webstorm

RUN echo "NVM and Node.js versions last updated 2019-01-03."
ARG NVM_VERSION
RUN (test ! -z "${NVM_VERSION}" && exit 0 || echo "--build-arg NVM_VERSION must be supplied to docker build." >&2 && exit 1)
ENV NVM_DIR="/opt/nvm"
COPY etc-profile.d-nvm /etc/profile.d/nvm
RUN groupadd --system nvm \
  && usermod --append --groups nvm root
RUN mkdir -p "${NVM_DIR}/{.cache,versions,alias}" \
  && chown -R :nvm "${NVM_DIR}" \
  && chmod -R g+ws "${NVM_DIR}"
RUN curl https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | PROFILE=/etc/bash.bashrc bash
RUN . "${NVM_DIR}/nvm.sh" \
  && nvm install --lts \
  && nvm exec --lts npm install -g npm@latest \
  && nvm exec --lts npm install -g yarn@latest \
  && nvm install stable \
  && nvm exec stable npm install -g npm@latest \
  && nvm exec stable npm install -g yarn@latest \
  && nvm alias default stable \
  && nvm use default

WORKDIR /
COPY entrypoint /
ENTRYPOINT ["/entrypoint"]
CMD ["/usr/local/bin/webstorm"]
