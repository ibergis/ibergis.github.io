#!/bin/bash
# sync_translations_from_i18n.sh
# Syncs the approved translations from the i18n repository to the main repository.
# Does not delete any existing local files.
# Usage: ./sync_translations_from_i18n.sh <release_version>
#
# Requires the environment variable I18N_TOKEN to authenticate with the i18n repository.
# Requires the environment variable I18N_REPO_URL to be defined (base URL without token).
# The script constructs the full repository URL using these variables.

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <release_version>"
    exit 1
fi

# Ensure I18N_TOKEN is defined
if [ -z "$I18N_TOKEN" ]; then
    echo "Error: The environment variable I18N_TOKEN is not defined."
    exit 1
fi

# Ensure I18N_REPO_URL is defined
if [ -z "$I18N_REPO_URL" ]; then
    echo "Error: The environment variable I18N_REPO_URL is not defined."
    exit 1
fi

VERSION=$1
LANGUAGES=("en")

# Directories (adjust these paths if needed)
MAIN_REPO_PATH=$(pwd)  # Main repository (current directory)
LOCALE_DIR="$MAIN_REPO_PATH/locale"
# Local path for the i18n repository; assumed to be a sibling directory
I18N_REPO_PATH="../IberGIS-Documentation-i18n"
# Construct the full URL including the token for HTTPS authentication
I18N_REPO_FULL_URL="https://${I18N_TOKEN}@${I18N_REPO_URL}"

# Clone or update the i18n repository
if [ ! -d "$I18N_REPO_PATH" ]; then
    echo "Cloning i18n repository from $I18N_REPO_FULL_URL..."
    git clone "$I18N_REPO_FULL_URL" "$I18N_REPO_PATH"
else
    echo "Updating i18n repository..."
    cd "$I18N_REPO_PATH"
    git pull origin master
    cd "$MAIN_REPO_PATH"
fi

# Ensure that the specified version folder exists in the i18n repository.
if [ ! -d "$I18N_REPO_PATH/$VERSION" ]; then
    echo "Error: Version folder '$VERSION' does not exist in the i18n repository."
    exit 1
fi

echo "Syncing translations from the i18n repository for version $VERSION..."

for lang in "${LANGUAGES[@]}"; do
    SOURCE_DIR="$I18N_REPO_PATH/$VERSION/locale/$lang/LC_MESSAGES"
    TARGET_DIR="$LOCALE_DIR/$lang/LC_MESSAGES"
    if [ -d "$SOURCE_DIR" ]; then
        mkdir -p "$TARGET_DIR"
        rsync -av --checksum --delete "$SOURCE_DIR"/ "$TARGET_DIR"/
        echo "Copied files for language '$lang' to $TARGET_DIR"
    else
        echo "Warning: Source directory for language '$lang' does not exist in version '$VERSION'."
    fi
done

echo "Sync completed for version $VERSION."
