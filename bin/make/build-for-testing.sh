#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh
source bin/simctl.sh
source bin/xcode.sh

banner "Preparing"

ensure_valid_core_sim_service

hash xcpretty 2>/dev/null
if [ $? -eq 0 ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

info "Piping xcodebuild to ${XC_PIPE}"

set -e -o pipefail

if [ "${1}" = "arm" ]; then
  PLATFORM="iphoneos"
  ARCHES="armv7 armv7s arm64"
  export VALID_ARCHS="armv7 armv7s arm64"
elif [ "${1}" = "x86" ]; then
  PLATFORM="iphonesimulator"
  ARCHES="i386 x86_64"
else
  error "Usage: ${0} { arm | x86 }"
  exit 1
fi

info "Building for ${PLATFORM}: $ARCHS"
BUILD_DIR="build/Flowers/UITests"

INSTALL_DIR="Products/Flowers/${1}/$(xcode_version)"
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"

banner "Build For Testing"

xcrun xcodebuild \
  -derivedDataPath "${BUILD_DIR}" \
  -SYMROOT="${BUILD_DIR}" \
  -scheme Flowers \
  -configuration Debug \
  ARCH="${ARCHES}" \
  VALID_ARCHS="${ARCHES}" \
  -sdk "${PLATFORM}" \
  build-for-testing | $XC_PIPE

install_with_ditto \
  "${BUILD_DIR}/Build/Products/Debug-${PLATFORM}" \
  "${INSTALL_DIR}/UITests"

info "Done!"
