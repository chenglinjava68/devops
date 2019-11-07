#!/bin/sh

export APP_JAR=$(ls /app/*.jar | head -n 1)
echo $APP_JAR
echo '---------'
java ${JAVA_OPTS:--XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -Xmx1024m -Xms1024m} -jar $APP_JAR
