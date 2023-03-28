module("luci.controller.yunlink", package.seeall)

function index()
  entry({"admin", "services", "yunlink"}, call("init_view"), _("国际网络加速"), 100)
end


function init_view()
  require("luci.model.uci")
  local isSubmit         = tonumber(luci.http.formvalue("isSubmit") or 0)
  
  local isStop         = tonumber(luci.http.formvalue("isStop") or 0)
  
  local isUpdateDns    = tonumber(luci.http.formvalue("isUpdateDns") or 0)
  
  
if isStop == 1 then
	luci.util.exec("/etc/init.d/ss-yunlink stop &")
end

if isUpdateDns == 1 then
	mac = luci.util.exec("cat /sys/class/net/eth0/address|awk -F ':' '{print $1''$2''$3''$4''$5''$6 }'| tr a-z A-Z") or '0'
	mac = string.sub(mac,0,12)
	execCmd = "/usr/bin/wget http://www.yunlink.win/auth/dns4fgset?mac="..mac
	execCmd1 = execCmd.." -O /etc/dnsmasq.d/fgset.conf && /usr/bin/wget http://www.yunlink.win/auth/dns4fgserver?mac="
	execCmd2 = execCmd1..mac
	execCmd3 = execCmd2.." -O /etc/dnsmasq.d/fgserver.conf"
	luci.util.exec(execCmd3)
	luci.util.exec("/etc/init.d/dnsmasq restart &")
end


if isSubmit == 1
then   luci.util.exec("/etc/init.d/ss-yunlink restart &")  luci.template.render("yunlink",{ isSubmit=0,isStop=0 ,isUpdateDns=0})
else
	luci.template.render("yunlink",{ isSubmit=0,isStop=0,isUpdateDns=0})
end
  
end