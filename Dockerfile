FROM node:onbuild
MAINTAINER leo.lou@gov.bc.ca

RUN \
  DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
  && git config --global url.https://github.com/.insteadOf git://github.com/ \
  && npm install -g serve browserify \
  && DEBIAN_FRONTEND=noninteractive apt-get purge -y \
  && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
  && DEBIAN_FRONTEND=noninteractive apt-get clean \  
  && rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /usr/src/app
RUN npm install
RUN make
RUN useradd -ms /bin/bash geojsonio \
  && chown -R geojsonio:0 /usr/src/app \
  && chmod -R 770 /usr/src/app

USER geojsonio
WORKDIR /usr/src/app
EXPOSE 8080
CMD serve -p 8080
