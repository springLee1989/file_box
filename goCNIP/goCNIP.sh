#!/bin/sh


dnsFile="/etc/dnsmasq.d/zgq.conf"
chnroute_file="/root/route.txt"
chnroute_th_file="/root/route_cn.txt"
if [ -f $chnroute_file ]; then       
     echo "AE route_file  exist"
else                                 
    wget -O- 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > /root/route.txt
fi 
if [ -f $chnroute_th_file ]; then       
     echo "CN route_file  exist"
fi
if [ -f $dnsFile ];then
    rm -rf /etc/dnsmasq.d/*.conf
fi


if [ "`uci get system.@system[0].hostname`" == "LEDE" ];then
rm -rf /etc/dnsmasq.d/gfwlist.conf
wget --no-check-certificate   https://gitee.com/spring1989/file_box/raw/master/goCNIP/goCNIP.tar.gz -O /root/zgq.conf.tar.gz
tar xzf /root/zgq.conf.tar.gz -C /etc/dnsmasq.d/
fi


ipset create setmefree hash:net

cpu=`awk 'NR==1,NR==1 {print $5}' /proc/cpuinfo`
obfs="/usr/bin/obfs-local"
md5sum /etc/init.d/ss-yunlink > /tmp/md5sum.txt
etc_init_md5=`awk 'NR==1,NR==1 {print $1}' /tmp/md5sum.txt`
machine=`awk 'NR==2,NR==2 {print $3}' /proc/cpuinfo`



if [ ! -e $obfs -a $cpu == "MT7620N" ];then
	wget --no-check-certificate   https://gitee.com/spring1989/file_box/raw/master/2026/simple-obfs_v0.0.5-spring-3_ramips_24kec.ipk -O /tmp/simple-obfs_v0.0.5-spring-3_ramips_24kec.ipk
	wget --no-check-certificate   https://gitee.com/spring1989/file_box/raw/master/2026/libev_4.19-1_ramips_24kec.ipk -O /tmp/libev_4.19-1_ramips_24kec.ipk
	opkg install /tmp/libev_4.19-1_ramips_24kec.ipk
	opkg install /tmp/simple-obfs_v0.0.5-spring-3_ramips_24kec.ipk
fi
if [ $cpu == "MT7620N" -a $etc_init_md5 != "407caad4ec8d8fa09cdc1853f191ec95" -a "`uci get system.@system[0].hostname`" == "YunLink1s-gohome" ];then
	wget --no-check-certificate   https://gitee.com/spring1989/file_box/raw/master/gohome/ss-yunlink -O /etc/init.d/ss-yunlink 
	chmod a+x  /etc/init.d/ss-yunlink
	/etc/init.d/ss-yunlink restart
fi
ss_server_ip=" \
    120.77.208.19 \
    120.77.206.191  \
    47.243.113.0/24 \
    47.243.104.0/24 \
"
ss_redir_port=8082
# ss_redir_pid=/var/run/shadowsocks.pid
# ss_config_file=/etc/config/shadowsocks.json
chnroute_file="/root/route.txt"

# 开启redir
#ss-redir -u -c $ss_config_file -f $ss_redir_pid

# IP内网地址
BYPASS_RESERVED_IPS=" \
    0.0.0.0/8 \
    10.0.0.0/8 \
    127.0.0.0/8 \
    169.254.0.0/16 \
    172.16.0.0/12 \
    192.168.0.0/16 \
    224.0.0.0/4 \
    240.0.0.0/4 \
    47.75.0.0/16 \
    47.243.0.0/16
"

ipset create ss_bypass_set hash:net

# 添加内网地址到ipset
for line in $BYPASS_RESERVED_IPS; do
    ipset add ss_bypass_set $line
done

for line in $ss_server_ip; do
    ipset add ss_bypass_set $line
done
# 添加ss地址到ipset
# ipset add ss_bypass_set $ss_server_ip

##添加chinaroute到ipset
if [ -f $chnroute_file ]; then       
    IPS=`which ipset`                
    for i in `cat $chnroute_file `;  
    do                               
      ipset add ss_bypass_set $i     
    done
    echo "CN route was loaded"    
else                                 
    echo "CN route does not exist"
fi 


#ipset -N setmefree iphash -!
#iptables -t nat -A PREROUTING -p tcp -m set --match-set setmefree dst -j REDIRECT --to-port 1080


sed -i "s/iptables/# xxxxx/g" /etc/firewall.user
sed -i "s/ipset/# xxxxx/g" /etc/firewall.user

# TCP规则
iptables -t nat -N SHADOWSOCKS_TCP

iptables -t nat -A SHADOWSOCKS_TCP -p tcp -m set --match-set ss_bypass_set dst -j RETURN
iptables -t nat -A SHADOWSOCKS_TCP -p tcp -j REDIRECT --to-ports 1080
iptables -t nat -A SHADOWSOCKS_TCP -p icmp -m set --match-set ss_bypass_set dst -j RETURN
iptables -t nat -A SHADOWSOCKS_TCP -p icmp -j REDIRECT --to-ports 1080
# Apply for tcp
iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS_TCP
iptables -t nat -A PREROUTING -p tcp -j SHADOWSOCKS_TCP
iptables -t nat -A OUTPUT -p icmp -j SHADOWSOCKS_TCP
iptables -t nat -A PREROUTING -p icmp -j SHADOWSOCKS_TCP

/usr/bin/ssrr-redir -c /etc/shadowsocks/config.json -b 0.0.0.0 -s 127.0.0.1 -p 1058 2>/dev/null &
# /usr/bin/obfs-local  -c /etc/shadowsocks/config.json -b 0.0.0.0 -p 2082  -l 1058 --obfs http   2>/dev/null &
/etc/init.d/dnsmasq restart
echo "ss-redir is loaded"

