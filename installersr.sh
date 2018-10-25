#!/usr/bin/env bash

apt-get update && sudo apt-get upgrade -y

rm shadowsockR.sh
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh
chmod +x shadowsocksR.sh

echo Going to install Shadowsocks
echo Use the following settings:
echo Port: 443
echo cipher: chacha20
echo protocol: origin
echo obfs: http_simple_compatible

read -rsp $'Press enter to continue...\n'

./shadowsocksR.sh

echo Checking if bbr is installed:

lsmod | grep bbr

echo If not, you need to:
echo 'wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh'

read -rsp $'Press enter to continue...\n'

cat <<EOT >> /etc/sysctl.conf
fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
EOT

sysctl -p

cat <<EOT >> /etc/security/limits.conf
* soft nofile 51200
* hard nofile 51200
EOT

cat <<EOT >> /etc/pam.d/common-session
session required pam_limits.so
EOT

cat <<EOT >> /etc/profile
ulimit -n 51200
EOT

ulimit -n 51200

/etc/init.d/shadowsocks restart

echo All done, download Shadowsockr from
echo https://github.com/shadowsocksrr/shadowsocksr-csharp/releases
echo https://github.com/shadowsocksrr/shadowsocksr-android/releases

read -rsp $'Press enter to finish...\n'
