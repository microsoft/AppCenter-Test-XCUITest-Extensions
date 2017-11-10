#!/usr/bin/env bash

source bin/log.sh
source bin/simctl.sh
source bin/xcode.sh
source bin/instruments.sh

banner "Preparing"

ensure_valid_core_sim_service

if [ "${1}" = "arm" ]; then
  PLATFORM="iphoneos"
  UDID=$(default_device_udid)
  if [ "${UDID}" = "" ]; then
    error "There are no connected physical devices"
    exit 1
  fi
elif [ "${1}" = "x86" ]; then
  PLATFORM="iphonesimulator"
  UDID=$(default_sim_udid)
else
  error "Usage:"
  error "  ${0} {arm | x86}"
  exit 1
fi

hash xcpretty 2>/dev/null
if [ $? -eq 0 ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

info "Will pipe xcodebuild to ${XC_PIPE}"

if [ "${1}" = "x86" ]; then
  osascript -e 'quit app "Simulator"'
  info "Quitting the Simulator.app"
  open -g -a "$(simulator_app_path)" --args -CurrentDeviceUDID $UDID
  info "Launching the target simulator"
  sleep 5
fi

BUILD_DIR=build/Flowers-UITests
TEST_DIR="${BUILD_DIR}/Logs/Test"

if [ -d "${TEST_DIR}/Attachments" ]; then
  find "${TEST_DIR}/Attachments" -type f -name "*.png" -print0 | xargs -0 rm
  find "${TEST_DIR}/Attachments" -type f -name "*.jpg" -print0 | xargs -0 rm
  info "Deleted existing screenshots"
fi

banner "Testing"

set -e -o pipefail

xcrun xcodebuild \
  -derivedDataPath "${BUILD_DIR}" \
  -configuration Release \
  -sdk "${PLATFORM}" \
  -scheme "UI Tests" \
  -destination id=${UDID}\
  test | $XC_PIPE

SCREENSHOTS=$(
find "${TEST_DIR}/Attachments" -type f -name "*.png" -o -name "*.jpg" | \
  wc -l | tr -d '[:space:]'
)

if [ "$(xcode_gte_9)" = "true" ]; then
  EXPECTED="67"
else
  EXPECTED="60"
fi

if [ "${SCREENSHOTS}" != "${EXPECTED}" ]; then
  error "Tests did not generated the correct number of screenshots"
  error "Expected: ${EXPECTED}"
  error "   Found: ${SCREENSHOTS}"
  exit 1
else
  info "Found the correct number of screenshots: ${SCREENSHOTS}"
fi

LOG=$(find "${TEST_DIR}" -type f -name "*_TestSummaries.plist" -print0 | \
  xargs -0 stat -f "%m %N" | sort -rn | head -1 | \
  cut -f2- -d" ")

EXPECTED_LOG_TEXT_FAILED="0"
function expect_log_text {
  if grep -Fq "[MobileCenterTest]: $1" "${LOG}"; then
    info "Found log message: ${1}"
  else
    error "Test did not generate the correct log output"
    error "Expected to find:"
    error "  '${1}'"
    error "In log file:"
    error "  ${LOG}"
    EXPECTED_LOG_TEXT_FAILED="1"
  fi
}

info "Checking log file for expected text"

# Label methods
expect_log_text "label class method can be called without arguments"
expect_log_text "label class method can be called with arguments - ARG0, 1, 2.3"
expect_log_text "act_label macro can be called without arguments"
expect_log_text "act_label macro can be called with arguments - ARG0, 1, 2.3"
expect_log_text "Given the app has launched"
expect_log_text "Then I touch the red button 3 times"

# Launch methods
expect_log_text "Given the app launched using ACTLaunch.launch from Swift"
expect_log_text "Given app launched using ACTLaunch.launch(app) from Swift"
expect_log_text "Given the app launched using act_launch_app macro"
expect_log_text "Given the app launched using act_launch macro"
expect_log_text "Given the app launched using ACTLabel.launchApplication from ObjC"
expect_log_text "Given the app launched using ACTLabel.launch from ObjC"

if [ "${EXPECTED_LOG_TEXT_FAILED}" = "0" ]; then
  info "Done!"
else
  echo ""
  error "At least one test failed"
  exit 1
fi

