FROM openshift/base-centos7
MAINTAINER leo.lou@gov.bc.ca

RUN rm -rf /usr/local/{lib/node{,/.npm,_modules},bin,share/man}/{npm*,node*,man1/node*}
RUN ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon
RUN curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
RUN yum -y install centos-release-scl-rh nodejs npm --enablerepo=epel && yum -y install gcc-c++ make git

ADD . /opt/app
RUN git config --global url.https://github.com/.insteadOf git://github.com/ \
  && npm install -g serve browserify \
RUN npm install
RUN make
RUN useradd -ms /bin/bash geojsonio \
  && chown -R geojsonio:0 /opt/app \
  && chmod -R 770 /opt/app

USER geojsonio
WORKDIR /opt/app
EXPOSE 8080
CMD serve -C -D -p 8080 --compress
