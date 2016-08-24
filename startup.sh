#!/bin/bash
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
cd /home/pi/src/dtls_transport && /home/pi/src/dtls_transport/a.out -p 8100 140.96.178.37 &
sleep 5
python /home/pi/mqtt_client/MQTTSNclient_drone.py drone1 &
mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udp:127.0.0.1:14550 --daemon --cmd="set source_system 254;set heartbeat 0" --load-module=chobits
exit 0
