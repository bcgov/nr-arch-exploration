#This script will help setup Metabase on openshift namespace wihout any installation.

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
$global:ARTIFACTORY_CREDS_PRESENT=""
$global:METABASE_APP_PREFIX=""
$global:BASE_URL="https://raw.githubusercontent.com/bcgov/iit-arch/main/Metabase/openshift"
$global:DB_HOST=""
$global:DB_PORT=""
$global:OC_ALIAS_REQUIRED="false"
$global:BACK_UP_CONTAINER_BASE_URL="https://raw.githubusercontent.com/BCDevOps/backup-container/master/openshift/templates/backup"

#This is our main function , which is the entry point of the script.
function main
{
  Clear-Host
  Write-Host -ForegroundColor red "BE CAREFUL. This script will remove all the Metabase related resources from the namespace."
  timeout /t -1
  checkAndAddOCClientForWindows
  if($global:OC_ALIAS_REQUIRED -eq "true")
  {
    Set-Alias -Name oc -Value $global:OC_BASE_PATH\oc.exe
    Write-Host "$( oc version )"
  }
  getInputsFromUser
  loginToOpenshift
  removeMetabaseDeployment
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
      Write-Host -ForegroundColor yellow "OC client is not present, it will downloaded and unzipped to $( $OC_BASE_PATH )"
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
}

function getEnvironment
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the environment where Metabase installation will be removed, for example(dev,test,prod)."
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
function getNamespace
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the Namespace where Metabase will be removed, it will be a 6 character alphanumeric string."
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
function loginToOpenshift
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Logging into openshift."
  oc login --token=$OPENSHIFT_TOKEN --server=$OPENSHIFT_SERVER
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Logged in to openshift."
}
function removeMetabaseDeployment
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Removing Metabase deployment."
  oc delete -n "$NAMESPACE-$ENVIRONMENT" all,template,secret,pvc,configmap,dc,bc -l app=backup-container
  oc delete -n "$NAMESPACE-$ENVIRONMENT" all,template,secret,pvc,dc,bc,configmap -l app=metabase
  oc delete -n "$NAMESPACE-$ENVIRONMENT" all,template,secret,pvc,configmap,dc,bc -l app=metabase-postgres
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Metabase deployment removed."
}
main

