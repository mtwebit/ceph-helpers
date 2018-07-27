#!/bin/sh

source `dirname $0`/_ceph-functions.sh

if [ "$1" == "" ]; then
  echo "Usage: $0 <pool_name>"
  echo Current Ceph pools:
  get_pools
  exit
fi
echo Current pool quota "${1}":
ceph osd pool get-quota ${1}
