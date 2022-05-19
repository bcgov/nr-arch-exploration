#!/bin/sh
#This script will help setup Metabase on openshift namespace without any installation.
#find the directory where the shell script and the compile java class is present.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

#different color codes for display to user.
COLOUR_NONE="\033[0m"
COLOUR_ERROR="\033[1;31m"
COLOUR_OK="\033[1;32m"
COLOUR_FILE="\033[1;35m"
COLOUR_PROMPT="\033[1;36m"
COLOUR_WARNING="\033[1;33m"
COLOUR_SELECTION="\033[1;34m"
COLOUR_DEFAULT="\033[1;37m"
main() {
  usage
}
usage() {
  echo "----------------------------------------------------------------------"
  echo "This script will guide you through the installation of Metabase on Openshift namespace With Specific To Oracle DB connection Over Encrypted Listeners. This process will download OC CLI on your desktop if it is not already on Path. Please enter a key to continue.."
  echo
  echo "Press ^C at any time to quit."
  echo "----------------------------------------------------------------------"
  echo
  # shellcheck disable=SC2162
  # shellcheck disable=SC2039
  read -p "Press any key to continue... "
}

#
# Display a colourful OK, WARNING, or ERROR message to the user.
#
# @param $1 A colour constant
# @param $2 The error level (OK, WARNING, ERROR)
# @param $3 The message to display
#
message() {
  printf "["
  coloured_text "$1" "$2"
  printf "] %s\n" "$3"
}

error() {
  message "$COLOUR_ERROR" "ERROR" "$1"
  exit
}
# Display an ok message to the user.
#
ok() {
  message "$COLOUR_OK" "OK" "$1"
}
#
# Display colourful text.
#
# @param $1 A colour constant
# @param $2 The text to display
#
coloured_text() {
  printf "%s%s%s" "$1" "$2" "${COLOUR_NONE}"
}
#
# Display a warning to the user.
#
warning() {
  message "$COLOUR_WARNING" "WARNING" "$1"
}
input() {
  result=""
  colour_prompt=$(coloured_text "$COLOUR_PROMPT" "SET")
  colour_default=$(coloured_text "$COLOUR_DEFAULT" "$2")

  if [ -n "$3" ]; then
    colour_default=$(coloured_text "$COLOUR_DEFAULT" "$PASSWORD_MASK")
  fi

  read -r "$3" -p "[$colour_prompt] $1 [$colour_default]: " result

  # Assign the default value if the user didn't provide a value.
  if [ -z "$result" ]; then
    result="$2"
  fi

  echo "$result"
}
main "$@"
