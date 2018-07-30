#!/bin/sh

source `dirname $0`/_ceph-functions.sh

case $1 in
  ic)
    state=inconsistent
    ;;
  ia)
    state=inactive
    ;;
  inconsistent)
    state=$1
    ;;
  inactive)
    state=$1
    ;;
  *)
    echo "Usage $0 <pg_status>"
    echo "Valid pg_statuses (abbr): ic=inconsistent ia=inactive]"
    exit
    ;;
esac

get_pgs $state pglist

echo "Commands: [s]crub, [d]eep-scrub, [r]epair, [R]repair-all, enter=next"
echo "You might need to restart a specific OSD if repair fails."
echo "  /etc/init.d/ceph restart osd.x"
echo "Running through $state pgs..."
repall=0
for i in $pglist; do
  echo Checking $i...
  echo -n state:
  get_pg_state $i
  echo -n pool:
  get_pg_pool $i
  echo -n "`ceph pg map $i` - ? "
#  printf '%-25s %s\n' $i `ceph auth get-key client.$i`
  if [ $repall == 1 ]; then
    pp=r
    echo "r"
  else
    read pp
  fi
  while [ "$pp" != "" ]; do
    case $pp in
      R) repall=1
         ceph pg repair $i
         echo -n "waiting for repair..."
         ;;
      r) ceph pg repair $i
         echo -n "waiting for repair..."
         ;;
      s) ceph pg scrub $i
         echo -n "waiting for scrubbing..."
         ;;
      d) ceph pg deep-scrub $i
         echo -n "waiting for deep-scrubbing..."
         ;;
    esac
    for j in 1 2 3 4 5; do
      sleep 1; echo -n "."
    done
    get_pg_state $i
    get_pg_pool $i
    [ $repall == 1 ] && break
    echo -n "`ceph pg map $i` - ? "
    read pp
  done
done

