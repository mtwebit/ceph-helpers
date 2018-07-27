#!/bin/sh

echo Current Ceph clients:
for i in `ceph auth list 2>/dev/null | grep ^client | cut -d . -f 2-`; do
  printf '%-25s %s\n' $i `ceph auth get-key client.$i`
done

