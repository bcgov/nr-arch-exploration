FROM docker.io/openjdk:17-alpine
WORKDIR /app
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
ARG DEPENDENCY=/workspace/app
# Configure the JAVA_OPTIONS, you can add -XshowSettings:vm to also display the heap size.
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"

COPY --chown=185 apis/java/quarkus-legacy-oracle/target/quarkus-app/lib/ /deployments/lib/
COPY --chown=185 apis/java/quarkus-legacy-oracle/target/quarkus-app/*.jar /deployments/
COPY --chown=185 apis/java/quarkus-legacy-oracle/target/quarkus-app/app/ /deployments/app/
COPY --chown=185 apis/java/quarkus-legacy-oracle/target/quarkus-app/quarkus/ /deployments/quarkus/
COPY --chown=185 apis/java/quarkus-legacy-oracle/startup.sh .
COPY --chown=185 apis/java/quarkus-legacy-oracle/InstallCert.class .
COPY --chown=185 "apis/java/quarkus-legacy-oracle/InstallCert\$SavingTrustManager.class" .
RUN chown -R 185:185 /deployments && chown -R 185:185 /app && chown -R 185:185 ${JAVA_HOME} && chown -R 185:185 /etc && chown -R 185:185 /opt
EXPOSE 8000
USER 185
ENTRYPOINT ["sh", "startup.sh"]
