#This script will help setup Metabase on openshift namespace without any installation.

#Declare global Variables here.

$global:OC_BASE_PATH="C:\softwares\oc"
$global:NAMESPACE=""
$global:ENVIRONMENT=""
$global:DOCKER_USER=""
$global:DOCKER_PWD=""
$global:OPENSHIFT_TOKEN=""
$global:OPENSHIFT_SERVER=""
$global:METABASE_ADMIN_EMAIL=""
$global:FOREGROUND_COLOR="DarkGreen"
$global:METABASE_APP_PREFIX=""
$global:BASE_URL="https://raw.githubusercontent.com/bcgov/nr-arch-templates/main/Metabase/openshift"
$global:DB_HOST=""
$global:DB_PORT=""
$global:OC_ALIAS_REQUIRED="false"

#This is our main function , which is the entry point of the script.
function main
{
  Clear-Host
  Write-Host -ForegroundColor $FOREGROUND_COLOR "This script will guide you through the installation of Metabase on Openshift namespace With Specific To Oracle DB connection Over Encrypted Listeners. This process will download OC CLI on your desktop if it is not already on Path. Please enter a key to continue."
  timeout /t -1
  checkAndAddOCClientForWindows
  if($global:OC_ALIAS_REQUIRED -eq "true")
  {
    Set-Alias -Name oc -Value $global:OC_BASE_PATH\oc.exe
    Write-Host "$( oc version )"
  }
  getInputsFromUser
  loginToOpenshift
  addNetworkPolicy
  deployPostgres
  deployMetabase
  setupBackupContainer
  Write-Host -ForegroundColor $FOREGROUND_COLOR "The deployment has completed. Please enter a key to exit."
  timeout /t -1
  exit 0
}

#This function will check if the OC client is installed on the windows machine. If not it will install it.
function checkAndAddOCClientForWindows
{
  try
  {
    if (oc)
    {
      Write-Host -ForegroundColor $FOREGROUND_COLOR "OC client is installed already."
    }
  }
  catch
  {

    if (Test-Path $OC_BASE_PATH\oc.exe)
    {
      Write-Host -ForegroundColor $FOREGROUND_COLOR "$( $OC_BASE_PATH )\oc.exe path already exists."
    }
    else
    {
      Write-Host -ForegroundColor yellow "$( $OC_BASE_PATH ) path does not exist, it will be created."
      New-Item -Path $OC_BASE_PATH -ItemType Directory -Force
      Write-Host -ForegroundColor yellow "OC client is not present, it will be downloaded and unzipped to $( $OC_BASE_PATH )"
      Write-Host -ForegroundColor $FOREGROUND_COLOR "Downloading OC CLI.... "
      Invoke-WebRequest -Uri https://downloads-openshift-console.apps.silver.devops.gov.bc.ca/amd64/windows/oc.zip -OutFile $OC_BASE_PATH\oc.zip
      Write-Host -ForegroundColor $FOREGROUND_COLOR "OC CLI Downloaded, now unzipping.... "
      Expand-Archive $OC_BASE_PATH\oc.zip -DestinationPath $OC_BASE_PATH
      Write-Host -ForegroundColor $FOREGROUND_COLOR "oc.exe extracted to $( $OC_BASE_PATH )"
    }
    $global:OC_ALIAS_REQUIRED="true"
  }


}
function getInputsFromUser
{
  getNamespace
  getEnvironment
  getOpenShiftToken
  getOpenShiftServer
  getMetabaseAdminEmail
  getMetabaseAppPrefix
  getOracleDBHost
  getOracleDBPort
}

function getEnvironment
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the environment where Metabase will be installed, for example(dev,test,prod)."
  $ENVIRONMENT = Read-Host
  if ($ENVIRONMENT -ne "dev" -and $ENVIRONMENT -ne "test" -and $ENVIRONMENT -ne "prod")
  {
    Write-Host -ForegroundColor red "Invalid environment, please enter dev, test or prod."
    getEnvironment
  }
  else
  {
    $global:ENVIRONMENT = $ENVIRONMENT.Trim()
  }
}
function getOracleDBHost
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the oracle db host name, this is the DB Host which will be connected from the metabase instance. If you are connecting to oracle DB over encrypted listeners, This is required."
  $data = Read-Host
  if (-not([string]::IsNullOrEmpty($data)))
  {
    $global:DB_HOST = $data.Trim()
  }
}
function getOracleDBPort
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the oracle db port number,this is the DB Port which will be connected from the metabase instance. If you are connecting to oracle DB over encrypted listeners, This is required."
  $port = Read-Host
  if (-not([string]::IsNullOrEmpty($port)))
  {
    $global:DB_PORT = $port.Trim()
  }
}
function getNamespace
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the Namespace of  where Metabase will be installed, it will be a 6 character alphanumeric string."
  $NAMESPACE = Read-Host
  if (-not([string]::IsNullOrEmpty($NAMESPACE)))
  {
    $global:NAMESPACE = $NAMESPACE.Trim()
  }
  else
  {
    Write-Host -ForegroundColor red "Namespace is required."
    getNamespace
  }
}
function getOpenShiftToken
{
  Write-Host -ForegroundColor cyan  "Go to openshift namespace in your browser and click on your name in the top right corner, click on Copy Login Command button.A new tab will open and after series of steps, you will see a display token link, click on that. Copy the token from where it says 'Your API token is' and paste it here."
  Write-Host -ForegroundColor $FOREGROUND_COLOR  "Enter the openshift token."
  $OPENSHIFT_TOKEN = Read-Host
  if (-not([string]::IsNullOrEmpty($OPENSHIFT_TOKEN)))
  {
    $global:OPENSHIFT_TOKEN = $OPENSHIFT_TOKEN.Trim()
  }
  else
  {
    Write-Host -ForegroundColor red  "OpenShift token is required."
    getOpenShiftToken
  }
}
function getOpenShiftServer
{
  Write-Host -ForegroundColor cyan "From the same place in your browser copy the server name where it is like '--server=****' and paste it here. Copy the value portion which is after '--server='"
  Write-Host -ForegroundColor $FOREGROUND_COLOR  "Enter the openshift server."
  $OPENSHIFT_SERVER = Read-Host
  if (-not([string]::IsNullOrEmpty($OPENSHIFT_SERVER)))
  {
    $global:OPENSHIFT_SERVER = $OPENSHIFT_SERVER.Trim()
  }
  else
  {
    Write-Host -ForegroundColor red "OpenShift server is required."
    getOpenShiftServer
  }
}
function getMetabaseAdminEmail
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the email address of the Metabase admin user. A valid email address is required."
  $METABASE_ADMIN_EMAIL = Read-Host
  if (-not([string]::IsNullOrEmpty($METABASE_ADMIN_EMAIL)))
  {
    $global:METABASE_ADMIN_EMAIL = $METABASE_ADMIN_EMAIL.Trim()
  }
  else
  {
    Write-Host -ForegroundColor red "Metabase admin email is required."
    getMetabaseAdminEmail
  }
}
function getMetabaseAppPrefix
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the prefix of the Metabase application name. A valid prefix is required. Make sure the prefix is all small characters(alphabets and -) ends with a '-'."
  $METABASE_APP_PREFIX = Read-Host
  if (-not([string]::IsNullOrEmpty($METABASE_APP_PREFIX)))
  {
    $global:METABASE_APP_PREFIX = $METABASE_APP_PREFIX.Trim().ToLower()
  }
  else
  {
    Write-Host -ForegroundColor red "Metabase app prefix is required."
    getMetabaseAppPrefix
  }
}
function loginToOpenshift
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Logging into openshift."
  oc login --token=$OPENSHIFT_TOKEN --server=$OPENSHIFT_SERVER
  oc project $NAMESPACE-tools
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Logged in to openshift."
}


function deployPostgres{
  try{
    oc process -f "https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/openshift/postgres/postgres.yml"  -p NAMESPACE="$NAMESPACE-$ENVIRONMENT" -p DB_PVC_SIZE=250Mi | oc -n "$NAMESPACE-$ENVIRONMENT" create -f -
  }catch{
    Write-Host -ForegroundColor red "Error deploying patroni. exiting."
    exit 1
  }
}
function addNetworkPolicy{
  try{
    Write-Host -ForegroundColor $FOREGROUND_COLOR "Adding network policy for metabase to talk to postgres."
    oc process -f "$BASE_URL/metabase.np.yaml" | oc create -n "$NAMESPACE-$ENVIRONMENT" -f -
  }catch{
    Write-Host -ForegroundColor red "Error adding network policy, exiting."
    exit 1
  }
}
function deployMetabase
{
  oc process -n "$NAMESPACE-$ENVIRONMENT" -f "$BASE_URL/metabase.secret.yaml" -p DB_HOST=$DB_HOST -p DB_PORT=$DB_PORT -p ADMIN_EMAIL=$METABASE_ADMIN_EMAIL -o yaml | oc create -n "$NAMESPACE-$ENVIRONMENT" -f -
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Metabase secret created."
  oc process -n "$NAMESPACE-$ENVIRONMENT" -f "$BASE_URL/metabase.dc.yaml" -p NAMESPACE="$NAMESPACE-$ENVIRONMENT" -p PREFIX=$METABASE_APP_PREFIX -o yaml | oc apply -n "$NAMESPACE-$ENVIRONMENT" -f -
}

function setupBackupContainer
{
  oc -n "$NAMESPACE-$ENVIRONMENT" create configmap backup-conf --from-literal=backup.conf=$(Invoke-WebRequest https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/openshift/postgres/backup/backup.conf)
  oc -n "$NAMESPACE-$ENVIRONMENT" label configmap backup-conf app=backup-container
  oc -n "$NAMESPACE-$ENVIRONMENT" process -f https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/openshift/postgres/backup/backup-deploy.yaml NAME=backup-postgres IMAGE_NAMESPACE="$NAMESPACE-$ENVIRONMENT" SOURCE_IMAGE_NAME=backup-postgres TAG_NAME=v1 BACKUP_VOLUME_NAME=backup-postgres-pvc -p BACKUP_VOLUME_SIZE=200Mi -p VERIFICATION_VOLUME_SIZE=200Mi -p ENVIRONMENT_NAME="$ENVIRONMENT" -p ENVIRONMENT_FRIENDLY_NAME='Metabase postgres DB Backups' | oc -n "$NAMESPACE-$ENVIRONMENT" create -f -

}

main

