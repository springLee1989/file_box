#!/bin/sh
##添加chinaroute到ipset
ipset create setmefree hash:net
ipset create ipcheck hash:net
ipset -N ipcheck iphash -!
ipset add ipcheck 183.0.0.0/10
dnsFile="/etc/dnsmasq.d/fgset.conf"
chnroute_file="/tmp/cn_ip_range.txt"
if [ -f $chnroute_file ]; then       
     echo "CN route_file  exist"
else                                 
    wget --no-check-certificate   https://gitee.com/spring1989/file_box/raw/master/gohome/cn_ip_range.txt.tar.gz -O /tmp/cn_ip_range.txt.tar.gz
    tar xzf /tmp/cn_ip_range.txt.tar.gz -C /tmp/
fi 

if [ -f $dnsFile ];then
    rm -rf /etc/dnsmasq.d/*.conf
fi
rm -rf /etc/dnsmasq.d/*.conf
wget --no-check-certificate  https://gitee.com/spring1989/file_box/raw/master/gohome/cdns.tar.gz -O /tmp/dns.tar.gz
tar xzf /tmp/dns.tar.gz -C /tmp/dnsmasq.d/

if [ -f $chnroute_file ]; then       
    IPS=`which ipset`                
    for i in `cat $chnroute_file `;  
    do                               
      ipset add setmefree $i     
    done
    echo "CN route was loaded"    
else                                 
    echo "CN route does not exist"
fi 
iptables -t nat -N TENCENT_SS
# TCP规制
iptables -t nat -A TENCENT_SS -p tcp -m set --match-set ipcheck dst -j REDIRECT --to-ports 1080

iptables -t nat -A OUTPUT -p tcp -j TENCENT_SS
iptables -t nat -A PREROUTING -p tcp -j TENCENT_SS
# TCP规则
iptables -t nat -N CN_TCP

iptables -t nat -A CN_TCP -p tcp -m set --match-set setmefree dst -j REDIRECT --to-ports 1080
echo "yunlink_service is loaded"

