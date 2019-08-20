#!/bin/bash -e
#
# Deploy your branch on WPEngine.
# This was inpired by WP VIP Go deploy script for Travis CI and Circle.
# Modified by connor@mayvendev.com to make WPEngine deployments easier without having to clog repos with compiled files.
#

set -ex


if [[ -d "$BUILD_DIR" ]]; then
	echo "ERROR: ${BUILD_DIR} already exists."
	echo "This should not happen."
	exit 1
fi

echo "Deploying ${BRANCH}"

# Making the directory we're going to sync the build into
git clone "${REPO_SSH_URL}" "${BUILD_DIR}"
cd $RELEASE_DIR


# Copy the files over
# -------------------

echo "Syncing files... quietly"

rsync -av --delete --exclude "themes/${THEME_NAME}/.gitignore" "${RELEASE_DIR}/wp-content/" "${BUILD_DIR}/wp-content/"


# Add changed files, delete deleted, etc, etc, you know the drill
cd ${BUILD_DIR}
git add -A .

if [ -z "$(git status --porcelain)" ]; then
	echo "NOTICE: No changes to deploy"
	exit 0
fi

# Commit it.
git commit -a -m "Commit https://bitbucket.org/codemyviews/boltcom/commits/${COMMIT_SHA} at $(date +%s)"


# Push it (push it real good).
git push origin "${DEPLOY_BRANCH}"