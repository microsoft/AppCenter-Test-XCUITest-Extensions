#!/usr/bin/env bash

source bin/log.sh
source bin/ditto.sh

banner "Preparing"

source bin/simctl.sh
ensure_valid_core_sim_service

hash xcpretty 2>/dev/null
if [ $? -eq 0 ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

info "Will pipe xcodebuild to: ${XC_PIPE}"

set -e -o pipefail

SCHEME="Framework"
PRODUCT_NAME="AppCenterXCUITestExtensions"
FRAMEWORK="${PRODUCT_NAME}.framework"
CONFIG=Release

BUILD_DIR=build/framework
rm -rf "${BUILD_DIR}"
BUILT_PRODUCTS="${BUILD_DIR}/Build/Products"
BUILT_ARM="${BUILT_PRODUCTS}/${CONFIG}-iphoneos/${FRAMEWORK}"
BUILT_X86="${BUILT_PRODUCTS}/${CONFIG}-iphonesimulator/${FRAMEWORK}"

INSTALL_DIR=Products/framework
rm -rf "${INSTALL_DIR}"
mkdir -p "${INSTALL_DIR}"
INSTALLED_ARM=${INSTALL_DIR}/arm/${FRAMEWORK}
INSTALLED_X86=${INSTALL_DIR}/x86/${FRAMEWORK}
INSTALLED_FAT=${INSTALL_DIR}/${FRAMEWORK}

banner "Building ARM Framework"

xcrun xcodebuild \
  -derivedDataPath "${BUILD_DIR}" \
  -SYMROOT="${BUILD_DIR}" \
  -configuration ${CONFIG} \
  -scheme "${SCHEME}" \
  ARCHES="armv7 armv7s arm64" \
  VALID_ARCHS="armv7 armv7s arm64" \
  -sdk iphoneos \
  build | $XC_PIPE

banner "Building i386/x86 Framework"

xcrun xcodebuild \
  -derivedDataPath "${BUILD_DIR}" \
  -SYMROOT="${BUILD_DIR}" \
  -configuration ${CONFIG} \
  -scheme "${SCHEME}" \
  ARCHES="i386 x86_64" \
  VALLID_ARCHS="i386 x86_64" \
  -sdk iphonesimulator \
  build | $XC_PIPE

banner "Installing FAT Framework"

install_with_ditto ${BUILT_ARM} ${INSTALLED_ARM}
install_with_ditto ${BUILT_X86} ${INSTALLED_X86}
install_with_ditto ${INSTALLED_ARM} ${INSTALLED_FAT}

ARM="${INSTALLED_ARM}/${PRODUCT_NAME}"
X86="${INSTALLED_X86}/${PRODUCT_NAME}"
FAT="${INSTALLED_FAT}/${PRODUCT_NAME}"

rm "${FAT}"

xcrun lipo -create "${ARM}" "${X86}" -output "${FAT}"

FATARCHES=$(xcrun lipo -info ${FAT})

function expect_arch {
  if [[ "${FATARCHES}" = *"${1}"* ]]; then
    info "${FAT} contains slice for ${1}"
  else
    error "${FAT} does not contain a slice for ${1}"
    exit 1
  fi
}

expect_arch i386
expect_arch x86
expect_arch arm64
expect_arch armv7
expect_arch armv7s

# This framework should contain _no_ bitcode or _space_ for bitcode
function expect_no_bitcode {
  OUT=$(xcrun otool -arch $1 -l "${FAT}")
  if [[ "${OUT}" != *"__LLVM"* ]]; then
    info "${FAT} does not contains bitcode for ${1}"
  else
    error "${FAT} does contain bitcode for ${1} which is not allowed"
    exit 1
  fi
}

expect_no_bitcode arm64
expect_no_bitcode armv7
expect_no_bitcode armv7s

info "Your framework is here:"
info "${INSTALLED_FAT}"
