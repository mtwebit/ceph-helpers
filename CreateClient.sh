#!/bin/sh

echo "--- CEPH ADMIN: creating or updating a client (user) -------------------------"
source `dirname $0`/GetClients.sh

echo -n "Client name (sysname or bme.mit.uname-groupname): [$1] "
read cname
if [ "$cname" == "" ]; then
  cname=$1
fi
if [ "$cname" == "" ]; then
  echo "Empty client name. Exiting."
  return
fi
ceph auth get-or-create client.${cname}
