#This script will help setup Metabase on openshift namespace wihout any installation.

#Declare global Variables here.

$OC_BASE_PATH = "C:\softwares\oc"
#This is our main function , which is the entry point of the script.
function main
{
  Write-Output "This script will guid you through the installation of Metabase on Openshift namespace."
  timeout /t 5
  checkAndAddOCClientForWindows
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
    if (Test-Path $OC_BASE_PATH)
    {
      Write-Output "$( $OC_BASE_PATH ) path already exists."
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

main

