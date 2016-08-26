FROM openshift/base-centos7
MAINTAINER leo.lou@gov.bc.ca

ENV NODEJS_VERSION=4 \
    NPM_RUN=start \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

LABEL summary="Platform for building and running Node.js 4 applications" \
      io.k8s.description="Platform for building and running Node.js 4 applications" \
      io.k8s.display-name="Node.js 4" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs,nodejs4" \
      com.redhat.dev-mode="DEV_MODE:false" \
      com.redhat.deployments-dir="/opt/app-root/src" \
      com.redhat.dev-mode.port="DEBUG_PORT:5858"

RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs4 rh-nodejs4-npm rh-nodejs4-nodejs-nodemon nss_wrapper" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

ADD . /opt/app-root
RUN git config --global url.https://github.com/.insteadOf git://github.com/ \
  && npm install -g serve browserify \
RUN npm install
RUN make
RUN useradd -ms /bin/bash geojsonio \
  && chown -R geojsonio:0 /opt/app-root \
  && chmod -R 770 /opt/app-root

USER geojsonio
WORKDIR /opt/app-root
EXPOSE 8080
CMD serve -C -D -p 8080 --compress
