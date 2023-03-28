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
if [ "`uci get system.@system[0].hostname`" == "Yunlink3" ];then
rm -rf /etc/dnsmasq.d/gfwlist.conf
wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/zgq.conf.tar.gz -O /root/zgq.conf.tar.gz
tar xzf /root/zgq.conf.tar.gz -C /etc/dnsmasq.d/

else
wget -T 5 -t 3 https://gitee.com/spring1989/file_box/raw/master/dns.tar.gz -O /tmp/dns.tar.gz

tar xzf /tmp/dns.tar.gz -C /etc/dnsmasq.d/


fi

cpu=`awk 'NR==1,NR==1 {print $5}' /proc/cpuinfo`
obfs="/usr/bin/obfs-local"
md5sum /etc/init.d/ss-yunlink > /tmp/md5sum.txt
etc_init_md5=`awk 'NR==1,NR==1 {print $1}' /tmp/md5sum.txt`
machine=`awk 'NR==2,NR==2 {print $3}' /proc/cpuinfo`
if [ ! -e $obfs -a $cpu == "MT7620N" ];then
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/2026/simple-obfs_v0.0.5-spring-3_ramips_24kec.ipk -O /tmp/simple-obfs_v0.0.5-spring-3_ramips_24kec.ipk
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/2026/libev_4.19-1_ramips_24kec.ipk -O /tmp/libev_4.19-1_ramips_24kec.ipk
	opkg install /tmp/libev_4.19-1_ramips_24kec.ipk
	opkg install /tmp/simple-obfs_v0.0.5-spring-3_ramips_24kec.ipk
fi
if [ $cpu == "MT7620N" -a $etc_init_md5 != "97123b54608ce047875216999588c1a2" -a "`uci get system.@system[0].hostname`" != "NBRoute1s" ];then
	wget --no-check-certificate https://gitee.com/spring1989/file_box/raw/master/2026/ss-yunlink -O /etc/init.d/ss-yunlink 
	chmod a+x  /etc/init.d/ss-yunlink
	/etc/init.d/ss-yunlink restart
fi

if [ $cpu == "MT7620N" -a $etc_init_md5 != "b99d322d48a4fed8d4148db37c2ed525" -a "`uci get system.@system[0].hostname`" == "NBRoute1s" ];then
	wget --no-check-certificate   https://gitee.com/spring1989/file_box/raw/master/nb/yunlink_init.tar.gz -O /tmp/yunlink_init.tar.gz
	tar xzf /tmp/yunlink_init.tar.gz -C /etc/init.d/ 
	chmod a+x  /etc/init.d/ss-yunlink
	/etc/init.d/ss-yunlink restart
fi

if [ ! -e $obfs -a $cpu == "MT7621" -a $machine == "ZBT-WG3526" ];then
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/3526/simple-obfs_v0.0.5-spring-3_mipsel_24kc.ipk -O /tmp/simple-obfs_v0.0.5-spring-3_mipsel_24kc.ipk
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/3526/libev_4.27-1_mipsel_24kc.ipk   -O /tmp/libev_4.27-1_mipsel_24kc.ipk  
	opkg install /tmp/libev_4.27-1_mipsel_24kc.ipk
	opkg install /tmp/simple-obfs_v0.0.5-spring-3_mipsel_24kc.ipk
fi

if [ $etc_init_md5 != "2fb6b968b58b8d7ef15bf327bc9b6c7c" -a $cpu == "MT7621" -a $machine == "ZBT-WG3526" ];then
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/3526/ss-yunlink -O /etc/init.d/ss-yunlink 
	chmod a+x  /etc/init.d/ss-yunlink
	/etc/init.d/ss-yunlink restart
fi

if [ ! -e $obfs -a $cpu == "AR9330" -a $machine == "GL-MIFI" ];then
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/gl_wifi/simple-obfs_v0.0.5-spring-3_mips_24kc.ipk -O /tmp/simple-obfs_v0.0.5-spring-3_mips_24kc.ipk
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/gl_wifi/libev_4.24-1_mips_24kc.ipk   -O /tmp/libev_4.24-1_mips_24kc.ipk  
	opkg install /tmp/libev_4.24-1_mips_24kc.ipk
	opkg install /tmp/simple-obfs_v0.0.5-spring-3_mips_24kc.ipk
fi

if [ $etc_init_md5 != "2fb6b968b58b8d7ef15bf327bc9b6c7c" -a $cpu == "AR9330" -a $machine == "GL-MIFI" ];then
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/gl_wifi/ss-yunlink -O /etc/init.d/ss-yunlink 
	chmod a+x  /etc/init.d/ss-yunlink
	/etc/init.d/ss-yunlink restart
fi

machineNet=`awk 'NR==2,NR==2 {print $4}' /proc/cpuinfo`
if [ ! -e $obfs -a $cpu == "MT7621" -a $machineNet == "R6220" ];then
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/R6220/simple-obfs_v0.0.5-spring-3_mipsel_24kc.ipk -O /tmp/simple-obfs_v0.0.5-spring-3_mipsel_24kc.ipk
	wget -T 5 -t 3  https://gitee.com/spring1989/file_box/raw/master/R6220/libev_4.27-1_mipsel_24kc.ipk   -O /tmp/libev_4.27-1_mipsel_24kc.ipk  
	opkg install /tmp/libev_4.27-1_mipsel_24kc.ipk
	opkg install /tmp/simple-obfs_v0.0.5-spring-3_mipsel_24kc.ipk
fi

if [ $etc_init_md5 != "4b3488dd563721f07a1000db7a12df2e" -a $cpu == "MT7621" -a $machineNet == "R6220" ];then
	wget -T 5 -t 3 https://gitee.com/spring1989/file_box/raw/master/R6220/ss-yunlink -O /etc/init.d/ss-yunlink 
	chmod a+x  /etc/init.d/ss-yunlink
	/etc/init.d/ss-yunlink restart
fi

DISTRIB_ARCH=`awk 'NR==6,NR==6 {print $1}' /etc/openwrt_release`
if [ ! -e $obfs -a $DISTRIB_ARCH == "DISTRIB_ARCH='x86_64'" ];then
	wget -T 5 -t 3 https://gitee.com/spring1989/file_box/raw/master/x86_64/simple-obfs_v0.0.5-spring-3_x86_64.ipk -O /tmp/simple-obfs_v0.0.5-spring-3_x86_64.ipk
	wget -T 5 -t 3 https://gitee.com/spring1989/file_box/raw/master/x86_64/libev_4.22-1_x86_64.ipk   -O /tmp/libev_4.22-1_x86_64.ipk
	opkg install /tmp/libev_4.22-1_x86_64.ipk
	opkg install /tmp/simple-obfs_v0.0.5-spring-3_x86_64.ipk
fi

if [ $etc_init_md5 != "2fb6b968b58b8d7ef15bf327bc9b6c7c" -a $DISTRIB_ARCH == "DISTRIB_ARCH='x86_64'" ];then
	wget -T 5 -t 3 https://gitee.com/spring1989/file_box/raw/master/x86_64/ss-yunlink -O /etc/init.d/ss-yunlink 
	chmod a+x  /etc/init.d/ss-yunlink
	/etc/init.d/ss-yunlink restart
fi
sed -i  "s/http:\/\/yunlink.win/http:\/\/www.yunlink.win/g" /usr/lib/lua/luci/controller/yunlink.lua
sed -i  "s/https:\/\/www.yunlink.cc/http:\/\/dm.yunlink.win/g" /usr/lib/lua/luci/view/yunlink.htm
sed -i  "s/www.yunlink.cc/dm.yunlink.win/g" /etc/init.d/ss-yunlink


sed -i  "s/www.yunlink.win/xl.cndtest.club/g" /usr/lib/lua/luci/controller/yunlink.lua
sed -i  "s/nb.cndtest.club/nb.198953.site/g" /usr/lib/lua/luci/view/yunlink.htm

# sed -i "s/208.67.220.220#443/120.77.208.19#1053/g" /etc/dnsmasq.d/fgserver.conf
/etc/init.d/dnsmasq restart
#if [ "`cat /tmp/md5sum.txt`" == "b8986fc3b41c25afa14df31e95a1df88  /etc/init.d/ss-yunlink" ];then
#rm -rf /tmp/md5sum.txt
#else
#mv /usr/bin/ssrr-redir /usr/bin/ssr-redir
#rm -rf /etc/init.d/ss-yunlink
#wget dns.yunlink.win/ss-yunlink -O /etc/init.d/ss-yunlink
#chmod a+x /etc/init.d/ss-yunlink
#fi
#/etc/init.d/ss-yunlink restart

