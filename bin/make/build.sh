#!/usr/bin/env bash

if [ "`which xcpretty`" != '' ]; then
  xcodebuild | xcpretty
else
  xcodebuild
fi
