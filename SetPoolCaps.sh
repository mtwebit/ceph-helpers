#!/bin/sh

echo "--- CEPH ADMIN: updating user caps to a pool ----------------------------------"

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

if [ "$cname" == "" ]; then
  source `dirname $0`/GetClients.sh
  echo -n "Client name (sysname or bme.mit.uname-groupname): [$2] "
  read cname
  if [ "$cname" == "" ]; then
    cname=$2
  fi
  if [ "$cname" == "" ]; then
    echo "Empty client name. Exiting."
    return
  fi
fi

echo "$cname current caps (permissions):"
source `dirname $0`/GetCaps.sh $cname
echo -n "Do you need to change client caps (permissions)? [n] "
read ans
if [ "$cnomcaps" == "" ]; then
  cmoncaps='allow r'
fi
if [ "$ans" == "y" ]; then
  echo "Suggested: mon '${cmoncaps}' osd '${cosdcaps}, allow rwx pool=${pname}'"
  echo -n "New caps: "
  read new_ccaps
  echo "ceph auth caps client.${cname} ${new_ccaps}"
  echo "ceph auth caps client.${cname} ${new_ccaps}" | sh
fi
