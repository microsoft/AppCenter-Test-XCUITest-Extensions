#!/usr/bin/env bash

source bin/log.sh
source bin/simctl.sh
ensure_valid_core_sim_service

hash xcpretty 2>/dev/null
if [ $? -eq 0 ] && [ "${XCPRETTY}" != "0" ]; then
  XC_PIPE='xcpretty -c'
else
  XC_PIPE='cat'
fi

set -e -o pipefail

xcrun xcodebuild -configuration Release -sdk iphoneos | $XC_PIPE
