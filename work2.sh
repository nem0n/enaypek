#!/bin/bash
#[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}

echo -n -e  "\e[1;31m Hostname: \e[0m" ; hostname
echo -e  "\e[1;31m Disk Informations: \e[0m" ; df -h
echo -n -e  "\e[1;31m Network Devices: \e[0m" ; ls /sys/class/net
echo ""
#echo -n -e  "\e[1;31m Device names: \e[0m" ; ip addr show | awk 'FNR==7 {print $2}' | tr -d :
echo -n -e  "\e[1;31m Ip Address: \e[0m" ; ip addr show |grep -w inet |grep -v 127.0.0.1|awk '{ print $2}'| cut -d "/" -f 1
echo -n -e  "\e[1;31m Broadcast: \e[0m" ; ip addr show |grep brd |grep -v 127.0.0.1|awk '/inet / {print $4}'
echo -n -e  "\e[1;31m Netmask: \e[0m" ; ip addr show |grep -w inet |grep -v 127.0.0.1|awk '{ print $2}'| cut -d "/" -f 2
echo ""
echo -n -e  "\e[1;31m OS Kernel Version: \e[0m" ; uname -srm
echo -n -e  "\e[1;31m OS Version: \e[0m" ; cat /etc/*-release | grep -w VERSION

selinuxenabled
if [ $? -ne 0 ]
then 
    echo -n -e  "\e[1;31m Selinux is DISABLED: \e[0m"
else
    echo -n -e  "\e[1;31m Selinux is ENABLED: \e[0m"
fi

echo ""
echo -e  "\e[1;31m Firewall Configs: \e[0m" ; iptables -L
echo ""
echo -e  "\e[1;31m Active Repositories: \e[0m" ; yum repolist
echo -e  "\e[1;31m Number of Installed Packages: \e[0m" ; yum list installed | wc -l
#grep -c '^ii'
echo ""
echo -e  "\e[1;31m Name of Installed Packages: \e[0m" ; yum list installed | awk -F"\t" '{print $1}'
echo ""
echo -e  "\e[1;31m Local Dns Resolver Server: \e[0m" ; cat /etc/resolv.conf | grep -w nameserver
echo -n -e  "\e[1;31m List of Active Shells Users: \e[0m" ; who -a
echo ""
echo -n -e  "\e[1;31m OS Installation Date: \e[0m" ; rpm -qi setup | perl -lne 'print $1 if /^Install Date:\s*(.*)/' 
#fs=$(df / | tail -1 | cut -f1 -d' ') && tune2fs -l $fs | sed -n 's/Filesystem created://p'
echo -e  "\e[1;31m Hardware Details: \e[0m" ; lscpu
echo -e  "\e[1;31m Running Services: \e[0m" ;  systemctl list-units --type=service | grep -w running 
#service --status-all | grep -w '[ + ] '
echo ""
echo -e  "\e[1;31m Not Running Services: \e[0m" ;  systemctl list-units --type=service | grep -w exited 
#service --status-all | grep -w '[ - ] '
echo ""
echo -e  "\e[1;31m OS Users: \e[0m" ; awk -F: '{ print $1}' /etc/passwd
echo ""
