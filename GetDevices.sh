#!/bin/sh

if [ "$1" == "" ]; then
  echo "Usage: $0 <pool_name>"
  exit
fi
echo Current devices in pool "${1}":
rbd ls $1
