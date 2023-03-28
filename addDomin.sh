#!/bin/sh
Domain=$1
tar xvf dns.tar.gz 
echo server=/.$Domain/208.67.220.220#443 >> fgserver.conf
echo ipset=/.$Domain/setmefree >> fgset.conf
rm -rf dns.tar.gz
tar czvf dns.tar.gz fgset.conf fgserver.conf
rm -rf fgset.conf fgserver.conf
git commit -m'add '$Domain -a
git push