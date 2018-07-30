#!/bin/sh

source `dirname $0`/_ceph-functions.sh

cat <<EOF
--- CEPH ADMIN: creating or updating a pool -----------------------------------
Don't overallocate pg_num since pg/OSD is limited.
Don't underallocate pg_num since it could cause uneven data distribution.
PG number should be rounded to the nearest power of two.
PG calculator: http://ceph.com/pgcalc/
PG manual: http://ceph.com/docs/master/rados/operations/placement-groups/

EOF

echo "Current pools:"
get_pools

echo -n "Pool name (name or bme.mit.uname-or-groupname): [$1] "
read pname
if [ "$pname" == "" ]; then
  pname=$1
fi
if [ "$pname" == "" ]; then
  echo "ERROR: Empty pool name."
  exit
fi

if is_pool $pname; then
  echo "Using ${pname}..."
else
  echo -n "Number of placement groups (pg_num): [512] "
  read pgnum
  if [ "$pgnum" == "" ]; then
    pgnum=512
  fi
  ceph osd pool create ${pname} ${pgnum} && exit 1
  source `dirname $0`/SetPoolReplication.sh
  source `dirname $0`/SetPoolQuota.sh
  source `dirname $0`/SetPoolCaps.sh
fi
