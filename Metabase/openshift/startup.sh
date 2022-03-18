#!/bin/sh
java -Djavax.net.ssl.trustStore=/opt/truststore/metabasestore.p12 -Djavax.net.ssl.trustStoreType=PKCS12 -Djavax.net.ssl.trustStorePassword="$TRUST_STORE_PASSWORD"  -jar metabase.jar
