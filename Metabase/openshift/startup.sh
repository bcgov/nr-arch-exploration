#!/bin/sh
java -Djavax.net.ssl.keyStore=/opt/truststore/metabasestore.jks -Djavax.net.ssl.keyStoreType=JKS -Djavax.net.ssl.keyStorePassword="$TRUST_STORE_PASSWORD"  -jar metabase.jar
