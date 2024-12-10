#!/usr/bin/env bash

# TODO: Generate an appropriate portion for use in autounattend.xml also.

# Get the password, also hide it from stdout since it's, well, a password.
read -p "Enter password to encode for autounattend.xml:" -s string_to_encode
echo -ne "\n"

# Concatenate the password with the word "Password".
# TODO: Ask for the account type and change the phrase to concatenate to "AdminPassword" if it's for the account Administrator.
string_to_encode+="Password"

echo "$string_to_encode" | sed 's/./&\x00/g' > test_var.txt

# Concatenate each of the character with a null character and encode to base64. The result will be printed out automatically.
echo "$string_to_encode" | tr -d '\n' | sed 's/./&\x00/g' | base64
