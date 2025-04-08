#!/bin/sh
# set -e
# set -o pipefail
cd /usr/local/src/site
if [ -f .buildlock ]; then
  echo "Build is already in progress. Exiting."
  exit 0
fi
trap "rm -f .buildlock" EXIT
touch .buildlock
git submodule init && git submodule update --progress && /usr/bin/hugo build --destination /srv
