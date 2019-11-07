FROM openjdk:8-jdk-alpine

ENV TZ Asia/Shanghai

COPY /entrypoint.sh /entrypoint.sh

RUN apk add --no-cache tzdata && \
     mkdir /app && \
     chmod a+x /entrypoint.sh

COPY target/*.jar /app

ENTRYPOINT ["/entrypoint.sh"]
