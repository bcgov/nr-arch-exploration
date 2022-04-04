# Metabase Version Upgrade

This folder contains the powershell script required in order to update Metabase version.
Please make sure you have the host name and port number of the Oracle DB you are trying to connect to over encrypted listener. The script will prompt you for the required information.

#For Windows users, please make you have access to OpenShift namespace.

Please execute the below command in powershell.
```markdown
Invoke-Expression $( $(Invoke-WebRequest https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/update-metabase-version/update-metabase-version.ps1).Content)
```

