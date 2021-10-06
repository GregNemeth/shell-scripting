#!/bin/bash

# This script creates a new user on the local system
# Provide username and comment through command line argument.
# The username, password, and host for the account will be displayed.
# Optionally , you can also porvide a comment for the account as an argument
# A password will be automatically generated

# Make sure script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
  echo "Please execute this script with sudo or  superuser privileges"
  exit 1
fi

# Make sure they at least supply one argument.
if [[ "${#}" -lt 1 ]]
then
  echo "Usage: ${0} USER_NAME [COMMENT]..."
  exit 1
fi

# Get the username (login)
USER_NAME="${1}"

# The rest of the parameters are for the account comments.
shift
COMMENT="${@}"

# Generate the password
PASSWORD=$(date +%s%N | sha256sum | head -c24)

# Create the account
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if the useradd command succeeded
# We don't want to tell the user an account was created when it wasn't
if [[ "${?}" -ne 0 ]]
then
  echo 'The account could not be created'
  exit 1
fi

# Set the password for the account
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
  echo 'The password for the account could not be set'
  exit 1
fi

# Force password change on first login
passwd -e ${USER_NAME}

# Display the username the password and the host where the user was created
echo
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
echo
exit 0

