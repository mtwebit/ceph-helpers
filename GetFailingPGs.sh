#!/bin/sh

source `dirname $0`/_ceph-functions.sh

case $1 in
  i)
    state=inconsistent
    ;;
  inconsistent)
    state=$1
    ;;
  *)
    echo "Usage $0 <pg_status>"
    echo "Valid pg_statuses (abbr): i[nconsistent]"
    exit
    ;;
esac

get_pgs $state pglist

for i in $pglist; do
  get_pg_state $i
  echo -n "pool: "
  get_pg_pool $i
  ceph pg map $i
  echo "--------"
done | less
