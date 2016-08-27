FROM mhart/alpine-node:6.4
MAINTAINER leo.lou@gov.bc.ca

RUN mkdir /app
WORKDIR /app
ADD . /app
RUN git config --global url.https://github.com/.insteadOf git://github.com/ \
  && npm install -g serve browserify
RUN npm install
RUN make

RUN adduser -S geojsonio
RUN chown -R geojsonio:0 /app && chmod -R 770 /app
USER geojsonio

EXPOSE 8080
CMD serve -C -D -p 8080 --compress /app
