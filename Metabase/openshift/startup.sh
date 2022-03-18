#!/bin/sh
java -Djavax.net.ssl.trustStore=/opt/truststore/metabasestore.jks -Djavax.net.ssl.trustStoreType=JKS -Djavax.net.ssl.trustStorePassword="$TRUST_STORE_PASSWORD"  -jar metabase.jar
