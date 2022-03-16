# Metabase

This folder contains the OpenShift templates required in order to build and deploy an instance of Metabase onto OpenShift with Oracle support.

#For Windows users

Please execute the below command in powershell.
```markdown
Invoke-Expression $( $(Invoke-WebRequest https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/setup-metabase.ps1).Content)
```


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
