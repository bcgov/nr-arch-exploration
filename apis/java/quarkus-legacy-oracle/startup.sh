#!/bin/sh
java InstallCert --quiet "${DB_HOST}:${DB_PORT}"
keytool -exportcert -alias "$DB_HOST-1" -keystore jssecacerts -storepass changeit -file /opt/oracle.cer
keytool -importcert -alias orakey -noprompt -keystore "${JAVA_HOME}"/lib/security/cacerts -storepass changeit -file /opt/oracle.cer
java -jar /deployments/quarkus-run.jar
