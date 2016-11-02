#!/bin/bash
if [ -f  "/tmp/my_startup_lock" ]
then 
	exit 0
fi
touch /tmp/my_startup_lock

#ifconfig wlan0 10.1.1.1 netmask 255.255.255.0
#hostapd /etc/hostapd/iphone.conf &
#sleep 5

#mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=10.1.1.10:14550 --daemon --cmd="set source_system 254;set heartbeat 0"

#exit 0

#huawei fix
#usb_modeswitch -v 12d1 -p 1f01 -c /usr/share/usb_modeswitch/12d1\:1f01

#huawei e3372h modem switch
usb_modeswitch -s 10 -v 12d1 -p 14fe -V 12d1 -P 1506 -M '55534243123456780000000000000011062000000100000000000000000000'
sleep 1
echo -e "AT^NDISDUP=1,1,\"internet\"\r" > /dev/ttyUSB0
#sleep 10

while true
do
	ifconfig wwan0 | grep -q "inet addr:169"
	if [ $? == 1 ]; then
		break
	fi 	
	sleep 1
done

#wifi ap for iphone
#ifconfig wlan0 10.1.1.1 netmask 255.255.255.0
#sysctl net.ipv4.ip_forward=1
#iptables -t nat -A POSTROUTING -s 10.1.1.0/16 -o eth1 -j MASQUERADE
#hostapd /etc/hostapd/iphone.conf &

#cd /home/pi/src/dtls_transport && /home/pi/src/dtls_transport/a.out -p 8100 140.96.178.37 &
#sleep 10
#python /home/pi/mqtt_client/MQTTSNclient_drone.py drone1 &
#mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udp:127.0.0.1:14550 --daemon --cmd="set source_system 254;set heartbeat 0"
#python /home/pi/src/scripts/mav_enc_fwd.py &
mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udp:140.96.178.37:8090 --daemon --cmd="set source_system 250;set heartbeat 0" --load-module=chobits
exit 0
