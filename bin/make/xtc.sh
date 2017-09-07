#!/usr/bin/env bash

source "bin/log.sh"
source "bin/xcode.sh"

if [ -z ${1} ]; then
  echo "Usage: ${0} device-set"
  exit 1
fi

CREDS=.xtc-credentials
if [ ! -e "${CREDS}" ]; then
  error "This script requires a ${CREDS} file"
  error "Generating a template now:"
  cat >${CREDS} <<EOF
export XTC_PRODUCTION_API_TOKEN=
export XTC_STAGING_API_TOKEN=
export XTC_USER=
EOF
  cat ${CREDS}
  error "Update the file with your credentials and run again."
  error "Bye."
  exit 1
fi

source "${CREDS}"

if [ "${XTC_UPLOADER}" != "" ]; then
  info "Using ${XTC_UPLOADER}"
elif [ -e bin/xtc/xtc ]; then
  info "Found bin/xtc/xtc; will use it for uploading"
  XTC_UPLOADER=bin/xtc/xtc
else
  XTC_UPLOADER=bin/xtc/xtc
  info "Downloading the latest xtc binary"
  rm -rf bin/xtc
  rm -rf bin/xtc.tar.gz
  curl -o bin/xtc.tar.gz \
    http://calabash-ci.macminicolo.net:8080/view/Uploader/job/Uploader%20master/lastSuccessfulBuild/artifact/publish/Release/xtc.osx.10.10-x64.tar.gz
  $(cd bin; tar -xzf xtc.tar.gz)
  rm -rf bin/xtc.tar.gz
  info "Installed bin/xtc/xtc"
fi

WORKSPACE="Products/Flowers/arm/$(xcode_version)/UITests"

set -e

if [ ! -e "${WORKSPACE}" ]; then
  bin/make/build-for-testing.sh arm
else
  info "Using existing workspace: ${WORKSPACE}"
fi

if [ -z $XTC_ENDPOINT ]; then
  API_TOKEN="${XTC_PRODUCTION_API_TOKEN}"
  info "Uploading to Production"
else
  API_TOKEN="${XTC_STAGING_API_TOKEN}"
  info "Uploading to Staging"
fi

if [ "${SERIES}" = "" ]; then
  SERIES=master
fi

${XTC_UPLOADER} xcuitest \
  "${API_TOKEN}" \
  --devices "${1}" \
  --app-name "Flowers" \
  --series "${SERIES}" \
  --user "${XTC_USER}" \
  --workspace "${WORKSPACE}"
