#This script will help setup Metabase on openshift namespace wihout any installation.

#Declare global Variables here.

$OC_BASE_PATH = "C:\softwares\oc"
$NAMESPACE = ""
$ENVIRONMENT = ""
$DOCKER_USER = ""
$DOCKER_PWD = ""
$OPENSHIFT_TOKEN = ""
$OPENSHIFT_SERVER = ""
$METABASE_ADMIN_EMAIL = ""
#This is our main function , which is the entry point of the script.
function main
{
  Write-Output "This script will guide you through the installation of Metabase on Openshift namespace."
  #Wait for 5 seconds
  timeout /t 5
  checkAndAddOCClientForWindows
  getInputsFromUser
  loginToOpenshift
  setupArtifactoryCreds
  exit 0
}

#This function will check if the OC client is installed on the windows machine. If not it will install it.
function checkAndAddOCClientForWindows
{
  if (oc)
  {
    Write-Output "OC client is installed already."
  }
  else
  {
    Write-Output "OC client is not present, it will downloaded and unzipped to $( $OC_BASE_PATH )"
    if (Test-Path $OC_BASE_PATH\oc.exe)
    {
      Write-Output "$( $OC_BASE_PATH )\oc.exe path already exists."
    }
    else
    {
      Write-Output "$( $OC_BASE_PATH ) path does not exist, it will be created."
      New-Item -Path $OC_BASE_PATH -ItemType Directory -Force
    }
    # Destination to save the file
    Write-Output "Downloading OC CLI.... "
    Invoke-WebRequest -Uri https://downloads-openshift-console.apps.silver.devops.gov.bc.ca/amd64/windows/oc.zip -OutFile $OC_BASE_PATH\oc.zip
    Write-Output "OC CLI Downloaded, now unzipping.... "
    Expand-Archive $OC_BASE_PATH\oc.zip -DestinationPath $OC_BASE_PATH
    Write-Output "oc.exe extracted to $( $OC_BASE_PATH )"
    Set-Item -Path alias:oc  -Value $OC_BASE_PATH\oc.exe
    Write-Output "$( oc version )"
  }
}
function getInputsFromUser
{
  getNamespace
  getEnvironment
  getDockerUser
  getDockerPwd
  getOpenShiftToken
  getOpenShiftServer
  getMetabaseAdminEmail
}

function getEnvironment
{
  Write-Output "Enter the environment where Metabase will be installed, for example(dev,test,prod)."
  $ENVIRONMENT = Read-Host
  if ($ENVIRONMENT -ne "dev" -and $ENVIRONMENT -ne "test" -and $ENVIRONMENT -ne "prod")
  {
    Write-Output "Invalid environment, please enter dev, test or prod."
    getEnvironment
  }
  else
  {
    $ENVIRONMENT = $ENVIRONMENT.Trim()
  }
}
function getNamespace
{
  Write-Output "Enter the Namespace of  where Metabase will be installed, it will be a 5 character alphanumeric string."
  $NAMESPACE = Read-Host
  if (-not([string]::IsNullOrEmpty($version)))
  {
    $NAMESPACE = $NAMESPACE.Trim()
  }
  else
  {
    Write-Output "Namespace is required."
    getNamespace
  }
}
function getDockerUser
{
  Write-Output "Enter the docker user name."
  $DOCKER_USER = Read-Host
  if (-not([string]::IsNullOrEmpty($version)))
  {
    $DOCKER_USER = $DOCKER_USER.Trim()
  }
  else
  {
    Write-Output "Docker user name is required."
    getDockerUser
  }
}
function getDockerPwd
{
  Write-Output "Enter the docker password."
  $DOCKER_PWD = Read-Host
  if (-not([string]::IsNullOrEmpty($version)))
  {
    $DOCKER_PWD = $DOCKER_PWD.Trim()
  }
  else
  {
    Write-Output "Docker password is required."
    getDockerPwd
  }
}
function getOpenShiftToken
{
  Write-Output "Enter the openshift token. Go to openshift namespace in your browser and click on your name in the top right corner, click on Copy Login Command button.A new tab will open and after series of steps, you will see a display token link, click on that. Copy the token from where it says 'Your API token is' and paste it here."
  $OPENSHIFT_TOKEN = Read-Host
  if (-not([string]::IsNullOrEmpty($version)))
  {
    $OPENSHIFT_TOKEN = $OPENSHIFT_TOKEN.Trim()
  }
  else
  {
    Write-Output "OpenShift token is required."
    getOpenShiftToken
  }
}
function getOpenShiftServer
{
  Write-Output "From the same place in your browser copy the server name where it is like '--server=****' and paste it here."
  $OPENSHIFT_SERVER = Read-Host
  if (-not([string]::IsNullOrEmpty($version)))
  {
    $OPENSHIFT_SERVER = $OPENSHIFT_SERVER.Trim()
  }
  else
  {
    Write-Output "OpenShift server is required."
    getOpenShiftServer
  }
}
function getMetabaseAdminEmail
{
  Write-Output "Enter the email address of the Metabase admin user."
  $METABASE_ADMIN_EMAIL = Read-Host
  if (-not([string]::IsNullOrEmpty($version)))
  {
    $METABASE_ADMIN_EMAIL = $METABASE_ADMIN_EMAIL.Trim()
  }
  else
  {
    Write-Output "Metabase admin email is required."
    getMetabaseAdminEmail
  }
}
function loginToOpenshift
{
  Write-Output "Logging into openshift."
  oc login --token=$OPENSHIFT_TOKEN --server=$OPENSHIFT_SERVER
  Write-Output "Logged in to openshift."
}

main

