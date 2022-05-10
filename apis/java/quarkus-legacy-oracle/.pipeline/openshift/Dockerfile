FROM docker.io/openjdk:17-alpine
WORKDIR /app
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
ARG DEPENDENCY=/workspace/app
# Configure the JAVA_OPTIONS, you can add -XshowSettings:vm to also display the heap size.
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"

COPY apis/java/quarkus-legacy-oracle/target/quarkus-app/lib/ /deployments/lib/
COPY apis/java/quarkus-legacy-oracle/target/quarkus-app/*.jar /deployments/
COPY apis/java/quarkus-legacy-oracle/target/quarkus-app/app/ /deployments/app/
COPY apis/java/quarkus-legacy-oracle/target/quarkus-app/quarkus/ /deployments/quarkus/
COPY apis/java/quarkus-legacy-oracle/startup.sh .
COPY apis/java/quarkus-legacy-oracle/InstallCert.class .
COPY "apis/java/quarkus-legacy-oracle/InstallCert\$SavingTrustManager.class" .
EXPOSE 8000

ENTRYPOINT ["sh", "startup.sh"]
