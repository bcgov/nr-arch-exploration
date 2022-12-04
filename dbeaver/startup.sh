#!/bin/bash
echo " DB_HOST_PORT_LIST is ${DB_HOST_PORT_LIST}"
if [ -z "${DB_HOST_PORT_LIST}" ]; then
  echo no DB_HOST_PORT_LIST provided starting dbeaver
  ./run-server.sh
else
  echo "Adding certs"
  IFS=','
  read -ra DB_HOST_PORT_ARRAY <<< "${DB_HOST_PORT_LIST}"
  for DB_HOST_PORT in "${DB_HOST_PORT_ARRAY[@]}"; do
    IFS=':'
    read -ra strarr <<<"${DB_HOST_PORT}"
    DB_HOST="${strarr[0]}"
    echo "DB_HOST is $DB_HOST"
    DB_PORT="${strarr[1]}"
    echo "DB_PORT is $DB_PORT"
    echo adding certificates for "${DB_HOST}:${DB_PORT}"
    java InstallCert --quiet "${DB_HOST}:${DB_PORT}"
    keytool -exportcert -alias "$DB_HOST-1" -keystore jssecacerts -storepass changeit -file /opt/"$DB_HOST-1.cer"
    keytool -importcert -alias orakey -noprompt -keystore "${JAVA_HOME}"/lib/security/cacerts -storepass changeit -file /opt/"$DB_HOST-1.cer"
  done
  ./run-server.sh
fi
