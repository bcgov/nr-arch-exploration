#!/bin/sh
APP_NAME=$1
OIDC_AUTH_SERVER_URL=$2
OPENSHIFT_NAMESPACE=$3
DB_HOST=$4
DB_PORT=$5
FILE_LOG_LEVEL=$6
QUARKUS_DATASOURCE_JDBC_PASSWORD=$7
QUARKUS_DATASOURCE_JDBC_USERNAME=$8
SERVICE_NAME=$9
TZVALUE="America/Vancouver"


#Create the config map which will be injected as env variables into the application.
echo
echo Creating config map "$APP_NAME"-config-map
oc create -n "$OPENSHIFT_NAMESPACE" configmap "$APP_NAME"-config-map --from-literal=TZ="$TZVALUE" --from-literal=OIDC_AUTH_SERVER_URL="$OIDC_AUTH_SERVER_URL" --from-literal=DB_HOST="$DB_HOST" --from-literal=DB_PORT="$DB_PORT" --from-literal=SERVICE_NAME="$SERVICE_NAME" --from-literal=FILE_LOG_LEVEL="$FILE_LOG_LEVEL" --from-literal=QUARKUS_DATASOURCE_JDBC_PASSWORD="$QUARKUS_DATASOURCE_JDBC_PASSWORD" --from-literal=QUARKUS_DATASOURCE_JDBC_USERNAME="$QUARKUS_DATASOURCE_JDBC_USERNAME" --dry-run -o yaml | oc apply -f -
echo

echo Setting environment variables for "$APP_NAME" application
oc -n "$OPENSHIFT_NAMESPACE" set env --from=configmap/"$APP_NAME"-config-map dc/"$APP_NAME"
