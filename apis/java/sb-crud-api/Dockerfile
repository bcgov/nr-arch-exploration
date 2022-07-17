FROM openjdk:17

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
ARG DEPENDENCY=target
COPY  ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY  ${DEPENDENCY}/META-INF /app/META-INF
COPY  ${DEPENDENCY}/BOOT-INF/classes /app

EXPOSE 8080
USER 185

ENTRYPOINT ["java","-Duser.name=SB_CRUD_API","-Xms150m","-Xmx150m","-noverify","-XX:TieredStopAtLevel=1","-XX:+UseParallelGC","-XX:MinHeapFreeRatio=20","-XX:MaxHeapFreeRatio=40","-XX:GCTimeRatio=4","-XX:AdaptiveSizePolicyWeight=90","-XX:MaxMetaspaceSize=120m","-XX:ParallelGCThreads=1","-Djava.util.concurrent.ForkJoinPool.common.parallelism=4","-XX:CICompilerCount=2","-XX:+ExitOnOutOfMemoryError","-Djava.security.egd=file:/dev/./urandom","-Dspring.backgroundpreinitializer.ignore=true","-cp","app:app/lib/*","ca.bc.gov.nrs.api.sbcrudapi.SbCrudApiApplication"]

