#!/usr/bin/env bash

source bin/log.sh
source bin/simctl.sh
ensure_valid_core_sim_service

hash pod 2>/dev/null
if [ $? -eq 1 ]; then
  error "Please install cocoapods and re-run"
  error "$ gem install cocoapods"
  exit 1
fi

set -e
pod lib lint --verbose
