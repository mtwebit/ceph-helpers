#!/bin/sh

cmoncaps=$(ceph auth get client.${1} 2>/dev/null | grep "caps mon =" | cut -d ' '  -f 4- | tr '"' '\0')
cosdcaps=$(ceph auth get client.${1} 2>/dev/null | grep "caps osd =" | cut -d ' '  -f 4- | tr '"' '\0')
if [ "${cmoncaps}${cosdcaps}" == "" ]; then
  echo "${1}: no caps found (invalid client name?)"
else
  echo "mon '$cmoncaps' osd '$cosdcaps'"
fi
