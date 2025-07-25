#!/bin/bash

# Read the current version from the VERSION file and create the header
VERSION=$(sed 's/^v//' VERSION)
VERSION_HEADER="Version $VERSION"

# Define the path to the CHANGELOG.md file
CHANGELOG_FILE="CHANGELOG.mkdn"

# Get the remote origin URL from git
REMOTE_URL=$(gh repo view -q '.url' --json url)

# Parse the website, owner, and repo from the remote URL
website=$(echo "$REMOTE_URL" | sed -n 's|.*\(https://[^/]*\).*|\1|p')
owner=$(gh repo view -q '.owner.login' --json owner)
repo=$(gh repo view -q '.name' --json name)

# Find the previous version by looking for the first version header that comes before the current version header
#
# NO you do NOT have to do it this way while GitHub-CLI is at your disposal, Diana. - Spring
#PREV_VERSION=$(awk -v header="$VERSION_HEADER" '
#  BEGIN {found=0}
#  $0 == header {found=1; next}
#  /^Version/ && found {print; exit}
#' "$CHANGELOG_FILE" | sed 's/^Version //')

# Much cleaner and oneliner, you only need to set GH_TOKEN in Actions environment, which I did for you.
PREV_VERSION=$(gh release view -q '.tagName' --json tagName | sed 's/^V//')

# Extract the content between the specified version and the next version, excluding the release URL and dashes
if [ -z "$PREV_VERSION" ]; then
  awk -v header="$VERSION_HEADER" -v website="$website" -v owner="$owner" -v repo="$repo" '
    $0 == header {next}
    !($0 ~ website "/" owner "/" repo "/releases/tag/v.*" && $0 ~ /[0-9]+\.[0-9]+/) && !/^-----.*/ {print}
  ' "$CHANGELOG_FILE"
else
  awk -v header="$VERSION_HEADER" -v website="$website" -v owner="$owner" -v repo="$repo" '
    BEGIN {found=0}
    $0 == header {found=1; next}
    /^Version/ && found {exit}
    found && !($0 ~ website "/" owner "/" repo "/releases/tag/v.*" && $0 ~ /[0-9]+\.[0-9]+/) && !/^-----.*/ {print}
  ' "$CHANGELOG_FILE"
fi

# Add the "Full Changelog" line comparing the previous version with the current one only if a previous version exists
if [[ -n "$PREV_VERSION" ]]; then
  echo "**Full Changelog**: $REMOTE_URL/compare/$PREV_VERSION...v$VERSION"
else
  echo -e "\n**Full Changelog**: $REMOTE_URL/commits/v$VERSION"
fi
