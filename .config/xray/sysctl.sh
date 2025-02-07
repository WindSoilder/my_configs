cp -ar /etc/sysctl.conf /etc/sysctl.conf.bak
cp -ar /etc/security/limits.conf /etc/security/limits.conf.bak

cat << EOF > /etc/sysctl.conf
vm.swappiness = 0
vm.overcommit_ratio = 50
vm.overcommit_memory = 0
vm.min_free_kbytes = 65535
vm.dirty_ratio = 20
vm.dirty_background_ratio = 10
net.ipv4.tcp_wmem = 8192 65536 16777216
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_sack =1
net.ipv4.tcp_rmem = 8192 87380 16777216
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_mem = 25600 51200 1024000
net.ipv4.tcp_max_tw_buckets = 80000
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_keepalive_time = 120
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_ecn = 0
net.ipv4.tcp_congestion_control = bbr
net.ipv4.neigh.default.retrans_time_ms = 250
net.ipv4.neigh.default.mcast_solicit = 20
net.ipv4.neigh.default.base_reachable_time_ms = 600000
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.ip_forward = 1
net.core.wmem_max = 16777216
net.core.wmem_default = 16777216
net.core.somaxconn = 32768
net.core.rmem_max = 16777216
net.core.rmem_default = 16777216
net.core.optmem_max = 65535

net.core.netdev_max_backlog = 16384
net.core.dev_weight = 64
net.core.default_qdisc = fq
kernel.pid_max = 65535
fs.suid_dumpable = 0
fs.inotify.max_user_watches = 655350
fs.file-max = 1024000
fs.aio-max-nr = 3145728
EOF

cat << EOF > /etc/security/limits.conf
* soft nofile 655360
* hard nofile 655360
* soft nproc 655360
* hard nproc 655360
* soft stack unlimited
* hard stack unlimited
EOF

# run sysctl -p after executing the script
