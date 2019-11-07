FROM maven:3.5.4-jdk-8-alpine
MAINTAINER John Huang <john.h.cn@gmail.com>
COPY settings.xml /usr/share/maven/ref/
RUN apk add docker
RUN apk add --no-cache \
        ca-certificates \
        curl \
        openssl