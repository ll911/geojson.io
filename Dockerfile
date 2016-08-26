FROM rhscl/nodejs-4-rhel7
MAINTAINER leo.lou@gov.bc.ca


ADD . /opt/app-root
RUN npm install
RUN make
RUN useradd -ms /bin/bash geojsonio \
  && chown -R geojsonio:0 /opt/app-root \
  && chmod -R 770 /opt/app-root

USER geojsonio
WORKDIR /opt/app-root
EXPOSE 8080
CMD serve -C -D -p 8080 --compress
