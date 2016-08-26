FROM openshift/base-centos7
MAINTAINER leo.lou@gov.bc.ca

#RUN rm -rf /usr/local/{lib/node{,/.npm,_modules},bin,share/man}/{npm*,node*,man1/node*}
#RUN rm -rf /usr/lib/node_modules
#RUN curl -sL https://rpm.nodesource.com/setup_4.x | bash -
#RUN yum -y install centos-release-scl-rh nodejs npm --enablerepo=epel && yum -y install gcc-c++ make git
ENV NODEJS_VERSION=4
#    NPM_RUN=start \
#    NPM_CONFIG_PREFIX=$HOME/.npm-global \
#    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

LABEL summary="Platform for building and running Node.js 4 applications" \
      io.k8s.description="Platform for building and running Node.js 4 applications" \
      io.k8s.display-name="Node.js 4" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs,nodejs4" \
      com.redhat.dev-mode="DEV_MODE:false" \
      com.redhat.deployments-dir="/opt/app-root/src" \
      com.redhat.dev-mode.port="DEBUG_PORT:5858"

RUN yum install -y centos-release-scl-rh && \
#    INSTALL_PKGS="rh-nodejs4 rh-nodejs4-npm rh-nodejs4-nodejs-nodemon nss_wrapper" && \
    INSTALL_PKGS="nodejs npm" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --enablerepo=epel && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

ADD . /opt/app-root
RUN git config --global url.https://github.com/.insteadOf git://github.com/ \
  && npm install -g serve browserify
RUN npm install
RUN make

RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
USER 1001
EXPOSE 8080
CMD serve -C -D -p 8080 --compress
