# Metabase

This folder contains the OpenShift templates required in order to  deploy an instance of Metabase onto OpenShift with _**Specific Intention to Connection to Oracle DB**_.
It also supports connection to oracle over encrypted listeners and secured port.

**_Currently, only one host of oracle is supported, Connecting to multiple oracle hosts over encrypted listeners is not supported._**

## Currently, there are 2 ways teams can deploy the metabase instance with postgres and backup to openshift namespace.
1. GitHub Actions.
2. Powershell Script.
3. Shell Script will be added in near future.


### GitHub Actions.
1. Please see file `.github/workflows/openshift-metabase-dev.yaml` to deploy to openshift.
2. The images of metabase are already build and are available at `docker pull ghcr.io/bcgov/nr-arch-templates/metabase:v0.43.1`
3. The `latest` version will always point at latest version of metabase, but you can specify specific version for deployment if you would like to.
4. If the intention is to connect to oracle db over encrypted listeners, please provide the env variables, DB_HOST and DB_PORT(generally 1543), the app during start-up will find these values and connect to the server and grab the certificates, while adding the oracle DB in Metabase UI, please select the SSL checkbox to true. you can leave these two fields blank if connecting to oracle over non-secure port.

### Powershell Script.
Please execute the below command in powershell and follow the prompts, it will set up metabase in your OS namespace.
```markdown
Invoke-Expression $( $(Invoke-WebRequest https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/setup-metabase.ps1).Content)
```

## Deploying locally through docker
1. `ghcr.io/bcgov/nr-arch-templates/metabase:latest` can be used in local system with Docker.
2. Please pass the DB_HOST and DB_PORT(generally 1543) as environment variables.

## Cleanup
Please be careful as these will delete postgres DB, metabase and Backup container.

#For Windows users
Please execute the below command in powershell.
```markdown
Invoke-Expression $( $(Invoke-WebRequest https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/clean-up-metabase.ps1).Content)
```
#For other OS users
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

