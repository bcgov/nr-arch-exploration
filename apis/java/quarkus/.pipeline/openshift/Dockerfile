FROM docker.io/openjdk:17-alpine
WORKDIR /app
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
RUN addgroup -S 185 && adduser -S 185 -G 185
COPY apis/java/quarkus/target/quarkus-app/lib/ /deployments/lib/
COPY apis/java/quarkus/target/quarkus-app/*.jar /deployments/
COPY apis/java/quarkus/target/quarkus-app/app/ /deployments/app/
COPY apis/java/quarkus/target/quarkus-app/quarkus/ /deployments/quarkus/
EXPOSE 8000
ENTRYPOINT ["java", "-jar", "/deployments/quarkus-run.jar"]
