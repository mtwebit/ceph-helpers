#!/bin/bash

# prints (if $1 is missing) or returns pg state in $1
function get_pools() {
  if [ "${1}" == "" ]; then
    ceph osd pool stats | grep ^pool | cut -d " " -f 2
  else
    eval "${1}=\"$(ceph osd pool stats | grep ^pool | cut -d " " -f 2)\""
  fi
}

# evals if $1 is a ceph pool
function is_pool() {
  p_found=$(get_pools | grep "^${1}$")
  [ "$p_found" != "" ]
}

# prints (if $2 is missing) or returns pg state in $2
function get_pg_state() {
  [ "${1}" == "" ] && echo "Internal error: missing pg_state args." && exit
  if [ "${2}" == "" ]; then
    echo "${1}: $(ceph pg $1 query|grep '{ "state'|cut -d: -f 2)"
  else
    eval ${2}=$(ceph pg $1 query|grep '{ "state'|cut -d: -f 2)
  fi
}

# sets (if $2 present) or prints the pool name from a pg name
function get_pg_pool() {
  [ "${1}" == "" ] && echo "Internal error: missing pg_state args." && exit
  tmp_pool=$(echo $1 | cut -d. -f 1)
  if [ "${2}" == "" ]; then
    ceph df|grep " $tmp_pool "| awk '{print $1;}'
  else
    eval ${2}=$(ceph df|grep ' $tmp_pool '| awk '{print $1;}')
  fi
}

# sets (if $2 presents) or prints pgs with a given state ($1)
function get_pgs() {
  [ "${1}" == "" ] && echo "Internal error: missing pg state arg." && exit
  if [ "${2}" == "" ]; then
    ceph pg dump 2>/dev/null | grep $state | cut -f -1
  else
    eval "${2}=\"$(ceph pg dump 2>/dev/null | grep $state | cut -f -1 | tr "\n" ' ')\""
  fi
}
