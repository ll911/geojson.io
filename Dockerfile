FROM node:onbuild
MAINTAINER leo.lou@gov.bc.ca

RUN \
  DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
    ruby \
    ruby-dev \
  && git config --global url.https://github.com/.insteadOf git://github.com/ \
  && gem install --no-ri --no-rdoc \
    jekyll bundle \
  && npm install -g serve \
  && DEBIAN_FRONTEND=noninteractive apt-get purge -y \
  && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
  && DEBIAN_FRONTEND=noninteractive apt-get clean \  
  && rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/ll911/geojson.io.git /tmp/repo1 && cp -r /tmp/repo1/* /usr/src/app && rm -Rf /tmp/repo1
RUN npm install
RUN make


RUN useradd -ms /bin/bash jekyll \
  && chown -R jekyll:0 /usr/src/app \
  && chmod -R 770 /usr/src/app

USER jekyll
WORKDIR /usr/src/app
EXPOSE 8080
CMD serve -p 8080
