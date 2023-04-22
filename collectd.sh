#!/bin/bash
total=$#
array=($*)

sudo amazon-linux-extras install collectd -y
mkdir /etc/collectd
echo "collectd: collectd" > /etc/collectd/auth_file

sed -i "0,/Hostname/{s/#Hostname/Hostname/}" /etc/collectd.conf
sed -i "0,/localhost/{s/localhost/"`hostname`"/}" /etc/collectd.conf
sed -i "0,/FQDNLookup/{s/#FQDNLookup/FQDNLookup/}" /etc/collectd.conf
sed -i "0,/BaseDir/{s/#BaseDir/BaseDir/}" /etc/collectd.conf
sed -i "0,/PIDFile/{s/#PIDFile/PIDFile/}" /etc/collectd.conf
sed -i "0,/PluginDir/{s/#PluginDir/PluginDir/}" /etc/collectd.conf
sed -i "0,/TypesDB/{s/#TypesDB/TypesDB/}" /etc/collectd.conf
sed -i "0,/AutoLoadPlugin/{s/#AutoLoadPlugin/AutoLoadPlugin/}" /etc/collectd.conf
sed -i "0,/Interval/{s/#Interval/Interval/}" /etc/collectd.conf

sed -i "0,/LoadPlugin cpu/{s/LoadPlugin cpu/#LoadPlugin cpu/}" /etc/collectd.conf
sed -i "0,/LoadPlugin interface/{s/LoadPlugin interface/#LoadPlugin interface/}" /etc/collectd.conf
sed -i "0,/LoadPlugin memory/{s/LoadPlugin memory/#LoadPlugin memory/}" /etc/collectd.conf
sed -i "0,/#LoadPlugin network/{s/#LoadPlugin network/LoadPlugin network/}" /etc/collectd.conf
sed -i "0,/#LoadPlugin processes/{s/#LoadPlugin processes/LoadPlugin processes/}" /etc/collectd.conf
sed -i "0,/#LoadPlugin write_log/{s/#LoadPlugin write_log/LoadPlugin write_log/}" /etc/collectd.conf

sed -i '$i <Plugin network>' /etc/collectd.conf
sed -i '$i \\t<Server "127.0.0.1" "25826">' /etc/collectd.conf
sed -i '$i \\t\tSecurityLevel Encrypt' /etc/collectd.conf
sed -i '$i \\t\tUsername "collectd"' /etc/collectd.conf
sed -i '$i \\t\tPassword "collectd"' /etc/collectd.conf
sed -i '$i \\t</Server>' /etc/collectd.conf
sed -i '$i \\tCacheFlush 1800' /etc/collectd.conf
sed -i '$i </Plugin>' /etc/collectd.conf

sed -i '$i <Plugin processes>' /etc/collectd.conf
for ((i=1;i<=${total};i++))
do
        sed -i '$i \\tProcessMatch \"'${array[$i-1]}'\" \".*'${array[$i-1]}'.*\"' /etc/collectd.conf
done
sed -i '$i </Plugin>' /etc/collectd.conf

systemctl enable collectd
systemctl start collectd
