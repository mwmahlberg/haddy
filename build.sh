#!/bin/sh
# set -e
# set -o pipefail
cd /usr/local/src/site
if [ -f /tmp/.buildlock ]; then
  echo "Build is already in progress. Exiting."
  exit 0
fi
trap "rm -f /tmp/.buildlock" EXIT
touch /tmp/.buildlock
git submodule init && git submodule update --progress && /usr/bin/hugo build --destination /srv
