
source bin/log.sh
source bin/xcode.sh

function default_sim_udid {
  if [ $(xcode_gte_9) = "true" ]; then
    local version=$(xcode_version)
    local major=$(echo $version | cut -d. -f1)
    local minor=$(echo $version | cut -d. -f2)

    # This branch can be removed when Apple releases an Xcode
    # with iPhone 9
    if (( $major == 10 )); then
      local model_mod=2
    else
      local model_mod=1
    fi

    # For example: iPhone 8 (11.4)
    local name="iPhone $(( ${major} - ${model_mod} )) ($(( ${major} + 2 )).${minor})"
  else
    local name="iPhone 7 (10.3.1)"
  fi

  local udid=$(
  xcrun instruments -s devices | \
    grep "${name} \[.*\]" | \
    perl -lne 'print $& if /[A-F0-9]{8}-([A-F0-9]{4}-){3}[A-F0-9]{12}/'
  )
  echo -n $udid
}

function default_device_udid {
  local devices=$(xcrun instruments -s devices | grep -E "[a-f0-9]{40}")
  if [ "${devices}" = "" ]; then
    echo ""
  fi

  # Instruments reports incompatible devices - for example, an iOS 11
  # device can appear when the active Xcode is 8.3.3.  Targeting an
  # an incompatible will cause xcodebuild to fail immediately or hang
  # indefinitely.  Filtering devices by compatible version is tedious
  # in any language and doublely so in bash.  Will choose the first
  # device in the list for now.
  echo $devices | head -1 | grep -E -o "[a-f0-9]{40}" | tr -d "\n"
}
