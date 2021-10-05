#!/bin/bash

# This script creates a new user on the local system
# You will be prompted to enter the username (login), the person name , and a password .
# The username, password, and host for the account will be displayed.

# Make sure script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
  echo "Please execute this script with sudo or  superuser privileges"
  exit 1
fi

# Get the username (login)
read -p 'Enter the username to create: ' USER_NAME

# Get the name of the person (comment/content for the description field)
read -p 'Enter the full name: ' COMMENT

# Get the password
read -p 'Enter the password for the account: ' PASSWORD

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

