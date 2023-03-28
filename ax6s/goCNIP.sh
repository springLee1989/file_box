#!/bin/sh
#处理dns文件和ip地址
dnsFile="/tmp/dnsmasq.d/"
chnroute_th_file="/root/route_th.txt"
if [ -f $chnroute_th_file ]; then       
     echo "TH route_file  exist"
else                                 
    wget -O- 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | awk -F\| '/TH\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > $chnroute_th_file
fi 
wget --no-check-certificate   https://gitee.com/spring1989/file_box/raw/master/zgq.conf.tar.gz  -O /root/zgq.conf.tar.gz
tar xzf /root/zgq.conf.tar.gz -C $dnsFile
# 创建IPset表
ipset create ss_bypass_set hash:net
ss_server_ip=" \
    8.219.128.0/17 \
    8.134.0.0/17  \
    0.0.0.0/8 \
    10.0.0.0/8 \
    127.0.0.0/8 \
    169.254.0.0/16 \
    172.16.0.0/12 \
    192.168.0.0/16 \
    149.154.164.0/22  \
    149.154.168.0/21  \
    67.198.55.0/24  \
    91.108.4.0/22  \
    91.108.56.0/22  \
    169.45.248.96/26  \
    169.55.60.170  \
    184.173.147.32/26  \
    169.47.5.224/26  \
    169.44.82.96/26  \
    169.45.214.224/26  \
    169.45.219.224/26  \
    108.168.174.0/26  \
    169.47.5.0/24  \
    50.22.198.0/24  \
    125.209.220.0/22  \
    59.125.52.82  \
    224.0.0.0/4 \
    240.0.0.0/4 \
    47.75.0.0/16 \
    208.67.222.222 \
    208.67.220.220 \
    47.243.0.0/16 
"
# 添加内网和服务器地址到ipset
for line in $ss_server_ip; do
    ipset add ss_bypass_set $line 2>/dev/null
done

##添加chinaroute到ipset
if [ -f $chnroute_th_file ]; then       
    for i in `cat $chnroute_th_file `;  
    do                               
      ipset add ss_bypass_set $i 2>/dev/null
    done
    echo "TH route was loaded"    
else                                 
    echo "TH route does not exist"
fi 

# TCP规则
iptables -t nat -N SHADOWSOCKS_TCP

iptables -t nat -A SHADOWSOCKS_TCP -p tcp -m set --match-set ss_bypass_set dst -j RETURN
iptables -t nat -A SHADOWSOCKS_TCP -p tcp -j REDIRECT --to-ports 1080
iptables -t nat -A SHADOWSOCKS_TCP -p icmp -m set --match-set ss_bypass_set dst -j RETURN
iptables -t nat -A SHADOWSOCKS_TCP -p icmp -j REDIRECT --to-ports 1080
# Apply for tcp
# iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS_TCP
iptables -t nat -A PREROUTING -p tcp -j SHADOWSOCKS_TCP
# iptables -t nat -A OUTPUT -p icmp -j SHADOWSOCKS_TCP
# iptables -t nat -A PREROUTING -p icmp -j SHADOWSOCKS_TCP

/etc/init.d/dnsmasq restart
echo "ss-redir is loaded"

