#!/bin/bash
#if [ -f  "/tmp/my_startup_lock" ]
#then 
#    exit 0
#fi
#touch /tmp/my_startup_lock

#iwconfig wlan0 power off

#sudo -u pi tmux new-session -d -s hello "cd /home/pi && mavproxy.py --quadcopter --master=/dev/ttyAMA0,921600 --load-module=DGPS"

#ifconfig wlan0 10.1.1.1 netmask 255.255.255.0
#hostapd /etc/hostapd/iphone.conf &

modprobe qmi_wwan

#sudo -u pi tmux new-session -d -s fwd "cd /home/pi/src/mav_fwd && python mav_fwd3.py"

#exit 0

while true
do
    ifconfig wwan0
    if [ $? == 0 ]; then
        break
    fi
    sleep 1
done

while true
do
    ifconfig wwan0 | grep -q "inet addr:"
    if [ $? == 0 ]; then
        break
    fi
    sleep 1
done

while true
do
    ifconfig wwan0 | grep -q "inet addr:169"
    if [ $? == 1 ]; then
        break
    fi
    sleep 1
done

sleep 1
sudo -u pi tmux new-session -d -s fwd "cd /home/pi/src/mav_fwd && python mav_fwd3.py 140.96.178.37:8090"

exit 0

#sudo -u pi tmux new-session -d -s picam "cd /home/pi/git/robidouille/raspicam_cv && ./raspicamtest"
#sudo -u pi tmux new-session -d -s land "cd /home/pi/src/landing && python picam_landing.py"

#for CES demo
#ifconfig eth1
#if [ $? == 0 ]; then
#    sysctl net.ipv4.ip_forward=1
#    iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
#    iptables -A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#    iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
#    bcast_addr=`ifconfig eth1 | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.255"`
#    sudo -u pi tmux new-session -d -s hello "cd /home/pi && mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udpbcast:$bcast_addr:14550 --cmd='set source_system 250;set heartbeat 0;module load chobits' --moddebug=3"
#    exit 0
#fi

#sudo -u pi tmux new-session -d -s hello 'cd /home/pi/src/landing && python landing_test.py'
#sudo -u pi tmux new-session -d -s hello 'cd /home/pi/src/computex && python trigger_takeoff.py'

#huawei fix
#usb_modeswitch -v 12d1 -p 1f01 -c /usr/share/usb_modeswitch/12d1\:1f01

#service udhcpd start

#for dlink dwm-222
#modprobe qmi_wwan
#usb_modeswitch -s 10 -v 2001 -p ab00 -W -n -M '555342431060D30B000000000001061B000000020000000000000000000000'
#usb_modeswitch -s 10 -v 2001 -p ab00 -V 2001 -P 7e35 -M '555342431060D30B000000000001061B000000020000000000000000000000'
#modprobe option
#echo "2001 7e35" > /sys/bus/usb-serial/drivers/option1/new_id
#qmi-network /dev/cdc-wdm0 start


#huawei e3372h modem switch
usb_modeswitch -s 10 -v 12d1 -p 14fe -V 12d1 -P 1506 -M '55534243123456780000000000000011062000000100000000000000000000'
sleep 3
echo -e "AT^NDISDUP=1,1,\"internet\"\r" > /dev/ttyUSB0
sleep 3

while true
do
    ifconfig wwan0
    if [ $? == 1 ]; then
        exit 0
    fi
    ifconfig wwan0 | grep -q "inet addr:169"
    if [ $? == 1 ]; then
        break
    fi  
    sleep 1
done

while true
do
    ping -q -c1 www.google.com
    if [ $? == 0 ]; then
        break
    fi
    sleep 1
done

#sudo -u pi tmux new-session -d -s hello 'cd /home/pi && mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udp:140.96.178.37:8090 --cmd="set source_system 250;set heartbeat 0;module load chobits" --moddebug=3'
#sudo -u pi tmux new-session -d -s hello 'cd /home/pi && mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udp:10.101.136.142:8090 --cmd="set source_system 250;set heartbeat 0;module load chobits" --moddebug=3'

echo -e "AT+COPS=3,0\r" > /dev/ttyUSB0
echo -e "AT+COPS=3,0\r" > /dev/ttyUSB0 #twice, 1st will error, do not know why
echo -e "AT+COPS?\r" > /dev/ttyUSB0
echo -e "AT+COPS?\r" > /dev/ttyUSB0
while read -r line
do
    if [[ $line =~ .*COPS.* ]]; then
        if [[ $line =~ .*ITRI.* ]]; then
            sudo -u pi tmux new-session -d -s hello 'cd /home/pi && mavproxy.py --quadcopter --master=/dev/ttyAMA0 --baudrate=19200 --out=udp:10.101.136.142:8090 --cmd="set source_system 250;set heartbeat 0;module load chobits" --moddebug=3'
            break
        else
            sudo -u pi tmux new-session -d -s hello 'cd /home/pi && mavproxy.py --quadcopter --master=/dev/ttyAMA0 --baudrate=19200 --out=udp:140.96.178.37:8090 --cmd="set source_system 250;set heartbeat 0;module load chobits" --moddebug=3'
            break
        fi
    fi
done < /dev/ttyUSB0

#wifi ap for iphone
#ifconfig wlan0 10.1.1.1 netmask 255.255.255.0
#sysctl net.ipv4.ip_forward=1
#iptables -t nat -A POSTROUTING -s 10.1.1.0/16 -o eth1 -j MASQUERADE
#hostapd /etc/hostapd/iphone.conf &

#nat for ip camera
#ifconfig wwan0
#if [ $? == 0 ]; then
#    sysctl net.ipv4.ip_forward=1
#    iptables -t nat -A POSTROUTING -o wwan0 -j MASQUERADE
#    iptables -A FORWARD -i wwan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#    iptables -A FORWARD -i eth0 -o wwan0 -j ACCEPT
#fi
#service udhcpd start

#cd /home/pi/src/dtls_transport && /home/pi/src/dtls_transport/a.out -p 8100 140.96.178.37 &
#sleep 10
#python /home/pi/mqtt_client/MQTTSNclient_drone.py drone1 &
#mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udp:127.0.0.1:14550 --daemon --cmd="set source_system 254;set heartbeat 0"
#python /home/pi/src/scripts/mav_enc_fwd.py &
#sudo -u pi tmux new-session -d -s hello 'top'
#mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udp:140.96.178.37:8090 --daemon --cmd="set source_system 250;set heartbeat 0" --load-module=chobits
#mavproxy.py --quadcopter --master=/dev/ttyAMA0 --out=udp:10.101.136.142:8090 --daemon --cmd="set source_system 250;set heartbeat 0" --load-module=chobits
