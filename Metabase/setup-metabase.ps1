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
#This is our main function , which is the entry point of the script.
function main
{
  Clear-Host
  Write-Host -ForegroundColor $FOREGROUND_COLOR "This script will guide you through the installation of Metabase on Openshift namespace."
  #Wait for 5 seconds
  timeout /t 5
  checkAndAddOCClientForWindows
  getInputsFromUser
  loginToOpenshift
  checkArtifactoryCreds
  if($ARTIFACTORY_CREDS_PRESENT -eq "false")
  {
    Write-Host -ForegroundColor yellow "Artifactory Creds are not present. Lets set it up."
    setupArtifactoryCreds
  }
  buildMetabase

 deployMetabase
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
    Set-Item -Path alias:oc  -Value $OC_BASE_PATH\oc.exe
    Write-Host "$( oc version )"
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
function getDockerUser
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the docker user name."
  $DOCKER_USER = Read-Host
  if (-not([string]::IsNullOrEmpty($DOCKER_USER)))
  {
    $global:DOCKER_USER = $DOCKER_USER.Trim()
  }
  else
  {
    Write-Host -ForegroundColor red "Docker user name is required."
    getDockerUser
  }
}
function getDockerPwd
{
  Write-Host -ForegroundColor $FOREGROUND_COLOR  "Enter the docker password."
  $DOCKER_PWD = Read-Host
  if (-not([string]::IsNullOrEmpty($DOCKER_PWD)))
  {
    $global:DOCKER_PWD = $DOCKER_PWD.Trim()
  }
  else
  {
    Write-Host -ForegroundColor red "Docker password is required."
    getDockerPwd
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
  Write-Host -ForegroundColor cyan "From the same place in your browser copy the server name where it is like '--server=****' and paste it here."
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
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Enter the prefix of the Metabase application name. A valid prefix is required."
  $METABASE_APP_PREFIX = Read-Host
  if (-not([string]::IsNullOrEmpty($METABASE_APP_PREFIX)))
  {
    $global:METABASE_APP_PREFIX = $METABASE_APP_PREFIX.Trim()
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
function setupArtifactoryCreds
{

  Write-Host -ForegroundColor cyan "Go to 'tools' Environment of the openshift namespace, make sure you are an admin, on the left hand menu, expand workloads and click on secrets. click on the secret 'artifacts-default-****' once it opens , click on reveal values at the bottom right. That will give the user name and password which needs to be entered."
  getDockerUser
  getDockerPwd
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Setting up artifactory creds."
  try
  {
    oc -n $NAMESPACE-tools create secret docker-registry artifactory-creds --docker-server=artifacts.developer.gov.bc.ca --docker-username=$DOCKER_USER --docker-password=$DOCKER_PWD --docker-email="admin@$NAMESPACE-$ENVIRONMENT.local"
  }
  catch
  {
    Write-Host -ForegroundColor red "Error setting up artifactory creds. exiting."
    exit 1
  }

  Write-Host -ForegroundColor $FOREGROUND_COLOR "Artifactory creds created."
}
function checkArtifactoryCreds
{
  $data = oc -n $NAMESPACE-tools get secret artifactory-creds -o json
  if([string]::IsNullOrEmpty($data))
  {
    $global:ARTIFACTORY_CREDS_PRESENT = "false"
  }
  else
  {
    $global:ARTIFACTORY_CREDS_PRESENT="true"
  }

}
function buildMetabase
{
  $data =  oc -n $NAMESPACE-tools get imagestream/metabase -o json
  if([string]::IsNullOrEmpty($data))
  {
    oc process -n $NAMESPACE-tools -f "$BASE_URL/metabase.bc.yaml" -p METABASE_VERSION=v0.41.5 -o yaml | oc apply -n $NAMESPACE-tools -f -
    Write-Host -ForegroundColor cyan "Metabase Image is being created, grab a cup of coffee as this might take 3-4 minutes."
    oc -n $NAMESPACE-tools start-build metabase --wait
    Write-Host -ForegroundColor $FOREGROUND_COLOR "Metabase Image build is completed."
    oc tag "$NAMESPACE-tools/metabase:latest" "$NAMESPACE-$ENVIRONMENT/metabase:latest"
    Write-Host -ForegroundColor $FOREGROUND_COLOR "Metabase Image is tagged in $($NAMESPACE)-$($ENVIRONMENT)."
    Write-Host -ForegroundColor cyan "Metabase secret is being created."
  }
}
function deployMetabase
{
  oc process -n "$NAMESPACE-$ENVIRONMENT" -f "$BASE_URL/metabase.secret.yaml" -p ADMIN_EMAIL=$METABASE_ADMIN_EMAIL -o yaml | oc create -n "$NAMESPACE-$ENVIRONMENT" -f -
  Write-Host -ForegroundColor $FOREGROUND_COLOR "Metabase secret created."
  oc process -n "$NAMESPACE-$ENVIRONMENT" -f "$BASE_URL/metabase.dc.yaml" -p NAMESPACE="$NAMESPACE-$ENVIRONMENT" -p PREFIX=$METABASE_APP_PREFIX -o yaml | oc apply -n "$NAMESPACE-$ENVIRONMENT" -f -
}

main

