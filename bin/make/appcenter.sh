#!/usr/bin/env bash

source "bin/log.sh"
source "bin/xcode.sh"

if [ -z ${1} ]; then
  echo "Usage: ${0} device-set"
  exit 1
fi

hash appcenter 2>/dev/null
if [ $? -eq 0 ]; then
  info "Using $(appcenter --version)"
else
  error "appcenter cli is not installed"
  error ""
  error "$ brew update; brew install npm"
  error "$ npm install -g appcenter-cli"
  error ""
  error "Then try again"
fi

CREDS=.appcenter-credentials
if [ ! -e "${CREDS}" ]; then
  error "This script requires a ${CREDS} file"
  error "Generating a template now:"
  cat >${CREDS} <<EOF
export APPCENTER_TOKEN=
export APP=
EOF
  cat ${CREDS}
  error "Create a token by running:"
  error ""
  error "$ mobile-center login"
  error ""
  error "and following the instructions."
  error ""
  error "The APP will be something like josmoo/Flowers."
  error "That is <username>/<app name> as they appear in AppCenter."
  error ""
  error "Update the file with your credentials and run again."
  exit 1
fi

source "${CREDS}"

WORKSPACE="Products/Flowers/arm/$(xcode_version)/UITests"

set -e

if [ ! -e "${WORKSPACE}" ]; then
  bin/make/build-for-testing.sh arm
else
  info "Using existing workspace: ${WORKSPACE}"
fi

if [ "${SERIES}" = "" ]; then
  SERIES=master
fi

appcenter test run xcuitest \
  --app "${APP}" \
  --devices "${1}" \
  --build-dir "${WORKSPACE}" \
  --test-series "${SERIES}" \
  --token "${APPCENTER_TOKEN}" \
  --disable-telemetry
