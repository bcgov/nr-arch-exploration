FROM docker.io/openjdk:17-slim
WORKDIR /app
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
ARG DEPENDENCY=/workspace/app
# Configure the JAVA_OPTIONS, you can add -XshowSettings:vm to also display the heap size.
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"

COPY target/quarkus-app/lib/ /deployments/lib/
COPY target/quarkus-app/*.jar /deployments/
COPY target/quarkus-app/app/ /deployments/app/
COPY target/quarkus-app/quarkus/ /deployments/quarkus/
COPY startup.sh .
COPY InstallCert.class .
COPY "InstallCert\$SavingTrustManager.class" .
EXPOSE 8000

ENTRYPOINT ["sh", "startup.sh"]
