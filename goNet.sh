#!/bin/sh
##添加chinaroute到ipset
ipset create setmefree hash:net
iptables -t nat -A PREROUTING -p tcp -m set --match-set setmefree dst -j REDIRECT --to-port 1080
iptables -t nat -A PREROUTING -p icmp -m set --match-set setmefree dst -j REDIRECT --to-port 1080
#添加tel软件支持
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
ipset add setmefree 157.240.3.0/24
ipset del setmefree 180.163.151.33
# add cf iprange
# ipset del setmefree 104.18.0.0/20
# ipset add setmefree 104.18.0.0/20
wget --no-check-certificate  https://gitee.com/spring1989/file_box/raw/master/dns.tar.gz -O /tmp/dns.tar.gz
tar xzf /tmp/dns.tar.gz -C /tmp/dnsmasq.d/

# TCP规则
/etc/init.d/dnsmasq restart
echo "yunlink_service is loaded"

