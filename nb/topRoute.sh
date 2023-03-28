#!/bin/sh
ipset del setmefree 149.154.164.0/22
ipset add setmefree 149.154.164.0/22

ipset del setmefree 149.154.168.0/21
ipset add setmefree 149.154.168.0/21

ipset del setmefree 67.198.55.0/24
ipset add setmefree 67.198.55.0/24

ipset del setmefree 91.108.4.0/22
ipset add setmefree 91.108.4.0/22

ipset del setmefree 91.108.56.0/22
ipset add setmefree 91.108.56.0/22

ipset del setmefree 169.45.248.96/26
ipset del setmefree 169.55.60.170
ipset del setmefree 184.173.147.32/26
ipset del setmefree 169.47.5.224/26
ipset del setmefree 169.44.82.96/26
ipset del setmefree 169.45.214.224/26
ipset del setmefree 169.45.219.224/26
ipset del setmefree 108.168.174.0/26
ipset del setmefree 169.47.5.0/24
ipset del setmefree 50.22.198.0/24
ipset del setmefree 125.209.220.0/22


ipset add setmefree 169.45.248.96/26
ipset add setmefree 169.55.60.170
ipset add setmefree 184.173.147.32/26
ipset add setmefree 169.47.5.224/26
ipset add setmefree 169.44.82.96/26
ipset add setmefree 169.45.214.224/26
ipset add setmefree 169.45.219.224/26
ipset add setmefree 108.168.174.0/26
ipset add setmefree 169.47.5.0/24
ipset add setmefree 50.22.198.0/24
ipset add setmefree 125.209.220.0/22
ipset add setmefree 59.125.52.82

ipset del setmefree 180.163.151.33
wget -T 5 -t 3 https://gitee.com/spring1989/file_box/raw/master/dns.tar.gz -O /tmp/dns.tar.gz
tar xzf /tmp/dns.tar.gz -C /etc/dnsmasq.d/

