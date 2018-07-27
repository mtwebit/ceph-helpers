cat <<EOF | more
--------------------  Current Ceph Cluster status  ----------------------------
`ceph status`
--------------------  Current Pool activities  --------------------------------
`ceph osd pool stats`
--------------------  Current Performance Statistics  -------------------------
`ceph osd perf`
-------------------------------------------------------------------------------
EOF
