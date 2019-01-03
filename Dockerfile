FROM ubuntu:18.10
MAINTAINER Hugo Josefson <hugo@josefson.org> (https://www.hugojosefson.com/)

RUN echo "Ubuntu packages last updated 2019-01-03."
RUN apt-get update \
  && apt-get dist-upgrade --purge -y \
  && apt-get autoremove --purge -y \
  && apt-get install -y \
    curl \
    wget \
    jq \
    gosu \
    libxtst6 \
    libxi6 \
    x11-apps \
    vim \
    git \
  && apt-get clean

RUN echo "WebStorm last updated 2019-01-03."
RUN mkdir /tmp/install-webstorm
COPY install-webstorm latest-download-url url-to-version /tmp/install-webstorm/
ARG DOWNLOAD_URL
RUN /tmp/install-webstorm/install-webstorm "${DOWNLOAD_URL}" \
  && rm -rf /tmp/install-webstorm

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
