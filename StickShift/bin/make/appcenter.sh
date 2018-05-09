#!/usr/bin/env bash

set -e

source "bin/log.sh"
source "bin/xcode.sh"

WORKSPACE="Products/StickShift/arm/$(xcode_version)/UITests"

set -e

if [ ! -e "${WORKSPACE}" ]; then
  bin/make/build-for-testing.sh arm
else
  info "Using existing workspace: ${WORKSPACE}"
fi

CAL_CODESIGN="${HOME}/.calabash/calabash-codesign"
if [ -e "${CAL_CODESIGN}" ]; then
  AC_TOKEN=$("${CAL_CODESIGN}/apple/find-appcenter-credential.sh" api-token)
else
  if [ "${AC_TOKEN}" = "" ]; then
    error "Expected calabash-codesign to be installed to:"
    error "  ${CAL_CODESIGN}"
    error "or AC_TOKEN environment variable to be defined."
    error ""
    error "Need an AppCenter API Token to proceed"
    exit 1
  fi
fi

info "Will use token: ${AC_TOKEN}"

if [ "${SERIES}" = "" ]; then
  SERIES=master
fi

appcenter test run xcuitest \
  --app "App-Center-Test-Cloud/BarefootRunner" \
  --devices "App-Center-Test-Cloud/barefoot-runner" \
  --build-dir "${WORKSPACE}" \
  --test-series "${SERIES}" \
  --token "${APPCENTER_TOKEN}" \
  --disable-telemetry
