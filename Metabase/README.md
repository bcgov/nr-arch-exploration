# Metabase

This folder contains the OpenShift templates required in order to build and deploy an instance of Metabase onto OpenShift with _**Specific Intention to Connection to Legacy Oracle DB**_ Over Encrypted Listeners support.

**_Currently, only one host of oracle is supported, Connecting to multiple oracle hosts over encrypted listeners is not supported._**

#For Windows users, please make you have access to OpenShift namespace.

Please execute the below command in powershell.
```markdown
Invoke-Expression $( $(Invoke-WebRequest https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/setup-metabase.ps1).Content)
```

#For Other OS users,
Please perform the following steps
1. Check if OC CLI is installed. If not install it for your specific OS.
2. Check if artifactory-creds is present in secrets of the tools environment of your openshift namespace. if not create it.
      1. Go to 'tools' Environment of the openshift namespace, make sure you are an admin, on the left-hand menu, expand workloads and click on secrets. click on the secret 'artifacts-default-****' once it opens , click on reveal values at the bottom right. That will give the username and password which needs to be entered
      ```markdown
       oc -n $NAMESPACE-tools create secret docker-registry artifactory-creds --docker-server=artifacts.developer.gov.bc.ca --docker-username=$DOCKER_USER --docker-password=$DOCKER_PWD --docker-email="admin@$NAMESPACE-$ENVIRONMENT.local"
    ```
3. execute the command after replacing variables with $ sign. DB_HOST is the host name of oracle db to connect to over encrypted listeners. DB_PORT is the port number of oracle db to connect to over encrypted listeners. ENVIRONMENT is the environment in openshift where metabase will be deployed(dev,test,prod) 
    ```markdown
     oc process -n $NAMESPACE-tools -f "https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/openshift/metabase.bc.yaml" -p METABASE_VERSION=v0.41.5 -p VERSION=$ENVIRONMENT -p DB_HOST=$DB_HOST -p DB_PORT=$DB_PORT -o yaml | oc apply -n $NAMESPACE-tools -f -
    ```
4. once build is completed in tools environment you will be able to see metabase image in imageStreams section. Click on that and go to history to verify Image is there.
   1. Once image is built, tag it for the environment by issuing below command after replacing variables with $ sign
    ```markdown
       oc tag "$NAMESPACE-tools/metabase:$ENVIRONMENT" "$NAMESPACE-$ENVIRONMENT/metabase:$ENVIRONMENT"
    ```
5. Create the secret for the deployment by issuing below command after replacing variables with $ sign
   ```markdown
      oc process -n "$NAMESPACE-$ENVIRONMENT" -f "https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/openshift/metabase.secret.yaml" -p ADMIN_EMAIL=$METABASE_ADMIN_EMAIL -o yaml | oc create -n "$NAMESPACE-$ENVIRONMENT" -f -
   ```
6. run the deployment template by issuing below command after replacing variables with $ sign
   ```markdown
      oc process -n "$NAMESPACE-$ENVIRONMENT" -f "https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/openshift/metabase.dc.yaml" -p NAMESPACE="$NAMESPACE-$ENVIRONMENT" -p VERSION=$ENVIRONMENT -p PREFIX=$METABASE_APP_PREFIX -o yaml | oc apply -n "$NAMESPACE-$ENVIRONMENT" -f -
   ```
## Initial Setup

Once Metabase is up and functional (this will take between 3 and 5 minutes), you will have to do initial setup manually. We suggest you populate the email account and password as whatever the `metabase-secret` secret contains in the `admin-email` and `admin-password` fields respectively. You may be asked to connect to your existing Postgres (or equivalent) database during this time, so you will need to refer to your other secrets or other deployment secrets in order to ensure Metabase can properly connect to it via JDBC connection.

## Notes

In general, Metabase should take up very little CPU (<0.01 cores) and float between 700 to 800mb of memory usage during operation. The template has some reasonable requests and limits set for both CPU and Memory, but you may change it should your needs be different. For some more documentation referencees, you may refer [here](https://github.com/loneil/domo-metabase-viewer/tree/master/docs) for historical templates and tutorials, or inspect the official Metabase documentation [here](https://www.metabase.com/docs/latest/).

## Cleanup
Please be careful as these will delete postgres DB, metabase and Backup container.
run these below commands after connecting to OC CLI and replacing the variables with $ sign
```markdown
    oc delete -n $NAMESPACE all,template,secret,pvc,configmap,dc,bc -l app=backup-container
```
```markdown
    oc delete -n $NAMESPACE all,template,networkpolicy,secret,pvc -l app=metabase
```
```markdown
    oc delete -n $NAMESPACE all,template,secret,pvc,configmap,dc,bc -l app=metabase-postgres
```

