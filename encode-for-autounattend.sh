#!/usr/bin/env bash

# TODO: Generate an appropriate portion for use in autounattend.xml also.

# Get the password, also hide it from stdout since it's, well, a password.
read -p "Enter password to encode for autounattend.xml: " -s string_to_encode
echo -ne "\n"

# Ask if we're dealing with a password made for the Administrator account.
read -p "Is this password for the account \"Administrator\" (y/N)? " -s admin_account
echo -ne "\n"

# Convert it to lowercase.
admin_account=$(echo "$admin_account" | tr '[:upper:]' '[:lower:]')

# If we're dealing with an administrator account...
if [[ "$admin_account" == y* ]]; then
  echo "Dealing with the Administrator account - Prepending \"Admin\"..."
  string_to_encode+="Admin"
else
  echo "Not dealing with the Administrator account."
fi

# Concatenate the password with the word "Password".
string_to_encode+="Password"

# Concatenate each of the character with a null character and encode to base64. The result will be printed out automatically.
echo "$string_to_encode" | tr -d '\n' | sed 's/./&\x00/g' | base64
