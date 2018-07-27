#!/bin/sh

echo "--- CEPH ADMIN: creating a device in a pool for a client ----------------------"
echo "*** Note: valid args are <client> <pool> <device> <pool-quota> <dev-size>"
echo "*** First create/update and select the client..."
source `dirname $0`/CreateClient.sh $1
echo "*** Now create/update and select the device pool..."
source `dirname $0`/CreatePool.sh $2 $4
source `dirname $0`/GetDevices.sh $pname

echo -n "Device name in the pool: [$3] "
read dname
if [ "$dname" == "" ]; then
  dname=$3
fi
if [ "$dname" == "" ]; then
  echo "ERROR: Empty device name."
  return
fi

echo -n "Device size (in GB): [$5] "
read dsize
if [ "$dsize" == "" ]; then
  dsize=$5
fi
if [ "$dsize" == "" ]; then
  echo "ERROR: Empty device size."
  exit
fi

echo "Creating device ${dname}..."
rbd --pool=${pname} --size=$((${dsize} * 1024)) --image-feature layering create ${dname}
echo "Disabling new Jewel features for CentOS 7"
# http://www.spinics.net/lists/ceph-users/msg27787.html
rbd --pool=${pname} feature disable ${dname} deep-flatten,fast-diff,object-map,exclusive-lock

