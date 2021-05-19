#!/usr/bin/env bash

express_vpn_on() {
  scutil -t 1 -w State:/Network/ExpressVPN
  local result=$?
  case $result in
    0)
      export ExpressVPN="🔐"
      echo "$ExpressVPN"
      return $result
      ;;
    1)
      unset ExpressVPN
      return $result
      ;;
    *)
      # echo -n "No idea what's up"
      return $result
      ;;
  esac
}
express_vpn_on
