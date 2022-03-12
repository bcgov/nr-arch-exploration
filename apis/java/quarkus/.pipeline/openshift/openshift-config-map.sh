#!/bin/sh
APP_NAME=$1
OIDC_AUTH_SERVER_URL=$2
OPENSHIFT_NAMESPACE=$3
TZVALUE="America/Vancouver"


#Create the config map which will be injected as env variables into the application.
echo
echo Creating config map "$APP_NAME"-config-map
oc create -n "$OPENSHIFT_NAMESPACE" configmap "$APP_NAME"-config-map --from-literal=TZ=$TZVALUE --from-literal=OIDC_AUTH_SERVER_URL="$OIDC_AUTH_SERVER_URL" --from-literal=FILE_LOG_LEVEL="INFO" --dry-run -o yaml | oc apply -f -
echo

echo Setting environment variables for "$APP_NAME" application
oc -n "$OPENSHIFT_NAMESPACE" set env --from=configmap/"$APP_NAME"-config-map dc/"$APP_NAME"
