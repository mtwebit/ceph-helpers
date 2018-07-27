#!/bin/sh

echo "--- CEPH ADMIN: updating pool quota -------------------------------------------"

if [ "$pname" == "" ]; then
  source `dirname $0`/GetPools.sh
  echo -n "Pool name (name or bme.mit.uname-or-groupname): [$1] "
  read pname
  if [ "$pname" == "" ]; then
    pname=$1
  fi
  if [ "$pname" == "" ]; then
    echo "ERROR: Empty pool name."
    exit
  fi
fi

ceph osd pool get-quota $pname

echo -n "Pool quota (valid units: k,M,G,T): [$2] "
read pquota
if [ "$pquota" == "" ]; then
  pquota=$2
fi
if [ "$pquota" == "" ]; then
  echo "Notice: No quota set."
else
  ceph osd pool set-quota ${pname} max_bytes $pquota
fi
ceph osd pool get-quota ${pname}
