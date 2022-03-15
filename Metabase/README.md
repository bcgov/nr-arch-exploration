# Metabase

This folder contains the OpenShift templates required in order to build and deploy an instance of Metabase onto OpenShift with Oracle support.

## Build Metabase

While Metabase does provide a Docker image [here](https://hub.docker.com/r/metabase/metabase), it is not compatible with OpenShift due to the image assuming it has root privileges. Instead, we build a simple Java image based off of OpenJDK 11 where the metabase application can execute without needing privilege escalation. In order to build a Metabase image in your project, process and create the build config template using the following command (replace anything in angle brackets with the correct value):

``` sh
export BASE_URL="https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/openshift"
export NAMESPACE=<YOURNAMESPACE>
export METABASE_VERSION=v0.41.5

oc process -n $NAMESPACE -f $BASE_URL/metabase.bc.yaml -p METABASE_VERSION=$METABASE_VERSION -o yaml | oc apply -n $NAMESPACE -f -
```

This will create an ImageStream called `metabase`. This image is built on top of Alpine OpenJDK 11, and will have Metabase installed on it.

## Deploy Metabase

Once your metabase image has been successfully built, you can then deploy it in your project by using the following commands (replace anything in angle brackets with the correct value):

*Note: We recommend the prefix have a dash at the end so that you get something like "app-metabase" instead of "appmetabase" as the domain.*

``` sh
export ADMIN_EMAIL=<ADMINEMAIL>
export NAMESPACE=<YOURNAMESPACE>
export PREFIX=<YOURCUSTOMPREFIX>

oc process -n $NAMESPACE -f $BASE_URL/metabase.secret.yaml -p ADMIN_EMAIL=$ADMIN_EMAIL -o yaml | oc create -n $NAMESPACE -f -

oc process -n $NAMESPACE -f $BASE_URL/metabase.dc.yaml -p NAMESPACE=$NAMESPACE -p PREFIX=$PREFIX -o yaml | oc apply -n $NAMESPACE -f -
```

This will create a new Secret, and create or patch a Service, Route, Persistent Volume Claim, and Deployment Configuration. This Deployment Config has health checks built in, and handles image updates via Recreation strategy. A rolling update cannot work because the H2 database is locked by the old running pod and prevents the newer instance of Metabase from starting up. Also note that due to the H2 database constraint, this Metabase deployment cannot be highly available (aka have a replica count larger than 1).

## Network Policy Setup

On OCP4, you must have Network Policies defined to allow specific pods to connect to other resources within the cluster. In our case, we will generally want the ability for metabase to establish database connections to databases potentially on different namespaces. Run the following template to allow Metabase to reach a target database.

``` sh
export NAMESPACE=<YOURDBNAMESPACE>
export NS_PREFIX=<YOURMETABASENAMESPACEPREFIX>
export NS_ENV=<YOURMETABASENAMESPACEENV>

oc process -n $NAMESPACE -f $BASE_URL/metabase.np.yaml -p NS_PREFIX=$NS_PREFIX -p NS_ENV=$NS_ENV -o yaml | oc apply -n $NAMESPACE -f -
```

In the event your Metabase instance needs to connect to multiple databases, you may repeat this command for each different database.

## Initial Setup

Once Metabase is up and functional (this will take between 3 to 5 minutes), you will have to do initial setup manually. We suggest you populate the email account and password as whatever the `metabase-secret` secret contains in the `admin-email` and `admin-password` fields respectively. You may be asked to connect to your existing Postgres (or equivalent) database during this time, so you will need to refer to your other secrets or other deployment secrets in order to ensure Metabase can properly connect to it via JDBC connection.

## Notes

In general, Metabase should take up very little CPU (<0.01 cores) and float between 700 to 800mb of memory usage during operation. The template has some reasonable requests and limits set for both CPU and Memory, but you may change it should your needs be different. For some more documentation referencees, you may refer [here](https://github.com/loneil/domo-metabase-viewer/tree/master/docs) for historical templates and tutorials, or inspect the official Metabase documentation [here](https://www.metabase.com/docs/latest/).

## Cleanup

```sh
export NAMESPACE=<YOURNAMESPACE>

oc delete -n $NAMESPACE all,template,networkpolicy,secret,pvc -l app=metabase
```

_Note: If you had network policies in different namespaces to permit cross-namespace DB access, you will need to run the following on those namespaces._

```sh
export NAMESPACE=<YOURNAMESPACE>

oc delete -n $NAMESPACE networkpolicy -l app=metabase
```
