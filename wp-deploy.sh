#!/bin/bash -e
#
# Deploy your branch on WPEngine.
#

set -ex

BRANCH="master"
SRC_DIR="/home/forge/bolt-production"
RELEASE_DIR="/home/forge/bolt-production/releases/20190820123046"
BUILD_DIR="${SRC_DIR}/.wpengine-deployment-$(date +%s)"
REPO_SSH_URL="git@git.wpengine.com:production/boltfinancial.git"
COMMIT_SHA="6c0a8e8133eb1a500bd489b09bc9bcaaa8acb72d"
DEPLOY_BRANCH="${BRANCH}"
THEME_NAME="bolt"


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

rsync -av --delete --exclude "themes/${THEME_NAME}/.gitignore" "${SRC_DIR}/wp-content/" "${BUILD_DIR}/wp-content/"


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