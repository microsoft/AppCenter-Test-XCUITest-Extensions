#!/usr/bin/env bash

set -e

if [ ! -z "${VERBOSE}" ]; then
  set -x
fi

if [ "`which xcpretty`" != '' ]; then
  xcodebuild -configuration Release | xcpretty
else
  xcodebuild -configuration Release
fi

