#!/bin/sh
java -Djavax.net.ssl.keyStore=/opt/truststore/metabasestore.p12 -Djavax.net.ssl.keyStoreType=PKCS12 -Djavax.net.ssl.keyStorePassword="$TRUST_STORE_PASSWORD"  -jar metabase.jar
