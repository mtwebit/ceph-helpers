#!/bin/sh

echo "--- CEPH ADMIN: updating pool replication level --------------------------------"

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

echo -n "Current replication level (size) "
ceph osd pool get ${pname} size
echo -n "Current I/O replication level (min_size) "
ceph osd pool get ${pname} min_size

echo -n "Replication level (size, 1=no replicas, n=n-1 spare): [`ceph osd pool get ${pname} size|cut -d " " -f 2-`] "
read psize
if [ "$psize" != "" ]; then
  ceph osd pool set ${pname} size $psize
fi


echo -n "I/O replication level (min_size <= size): [`ceph osd pool get ${pname} min_size|cut -d " " -f 2-`] "
read pmsize
if [ "$pmsize" != "" ]; then
  ceph osd pool set ${pname} min_size $pmsize
fi
