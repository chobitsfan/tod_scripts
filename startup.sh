#!/bin/bash
if [ -f  "/tmp/my_startup_lock" ]
then 
	exit 0
fi
touch /tmp/my_startup_lock

#huawei fix
sudo usb_modeswitch -v 12d1 -p 1f01 -c /usr/share/usb_modeswitch/12d1\:1f01

while true
do
	ifconfig eth1 | grep -q "inet addr"
	if [ $? == 0 ]; then
		break
	fi 	
	sleep 1
done

#wifi ap for iphone
ifconfig wlan0 10.1.1.1 netmask 255.255.255.0
sysctl net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -s 10.1.1.0/16 -o eth1 -j MASQUERADE
hostapd /etc/hostapd/iphone.conf &

cd /home/pi/src/dtls_transport && /home/pi/src/dtls_transport/a.out -p 8100 140.96.178.37 &
sleep 10
python /home/pi/mqtt_client/MQTTSNclient_drone.py drone1 &
mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udp:127.0.0.1:14550 --daemon --cmd="set source_system 254;set heartbeat 0" --load-module=chobits
exit 0
