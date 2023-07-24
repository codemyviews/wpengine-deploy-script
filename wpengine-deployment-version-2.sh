#!/bin/bash -e
#
# Deploy your code on WPEngine.
# This is Version 2 of this script.
# Version 2 utilizes rsync to sync files to the server on WPEngine.
#

set -ex


echo "Syncing plugin directory"
# Deploying theme folder changes
rsync --progress -avzh --delete "${RELEASE_DIR}"/wp-content/themes   "${SITE_NAME}"@"${SITE_NAME}".ssh.wpengine.net:/home/wpe-user/sites/"${SITE_NAME}"/wp-content/ --exclude "lsvp/node_modules"


echo "Syncing plugin directory"
# Deploying plugin folder changes
rsync --progress -avzh --delete "${RELEASE_DIR}"/wp-content/plugins   "${SITE_NAME}"@"${SITE_NAME}".ssh.wpengine.net:/home/wpe-user/sites/"${SITE_NAME}"/wp-content/ --exclude "lsvp/node_modules"

echo "Flushing WPEngine cache"
# Flush WPEngine cache
ssh "${SITE_NAME}"@"${SITE_NAME}".ssh.wpengine.net "wp --path=/home/wpe-user/sites/"${SITE_NAME}" page-cache flush && wp --path=/home/wpe-user/sites/"${SITE_NAME}" cdn-cache flush"