#Script to set Falcon fans 
#! /bin/sh

logo () {
echo ""
echo "             ▄██▄"
echo "            ▄█  █▄"
echo "           ▄█    █▄"
echo "       ▄▄▄▄█  ▄▄▄ █▄"
echo "   ▄█▀▀▀ ▄█      ▀██▄"
echo " ▄█▀    ▄█         ▀█▄"
echo " A M P E R E COMPUTING"
}

display_usage () {
	echo ""
	echo "Usage: ./setFans.sh auto //Enable Cooling Manager"
	echo "Usage: ./setFans.sh N    //Set fan PWM to N%"
	echo ""
}

set_fan () { 
	echo -n "Setting fan $1 to "
	decPWM=$(printf "%d" $2)
	echo -n "$decPWM%. " 
	fanStat=$(ipmitool raw 0x3C 0x14 $1 $2)	#set fan pwm 
	if [ "$fanStat" = " 00" ]; then
		echo "Success"
	else
		echo "Failed"
	fi
}

logo

if [  $# -ne 1 ]; then
	display_usage
	exit 1
fi

if [ "$1" = "auto" ]; then
	#Enable cooling manager
	cmStat=$(ipmitool raw 0x3C 0x0B 0x00)
	echo -n "Cooling manager "
	if [ "$cmStat" = " 00" ]; then
		echo "enabled"
		echo "Fan speed auto"
	else
		echo "disabled"
		echo "Fan speed manual"
	fi

else
	#Convert decimal pwm to hex
	hexPWM=$(printf "0x%02x" $1)

	#Disable cooling manager
	cmStat=$(ipmitool raw 0x3C 0x0b 0x01)
	echo -n "Cooling manager "
	if [ "$cmStat" = " 01" ]; then
		echo "disabled"
		echo "Fan speed manual"
	else
		echo "enabled"
		echo "Fan speed auto"
	fi
	sleep 1 

	#Set the fans
	for nFan in {2..6}
	do
		set_fan $nFan $hexPWM
	done
fi
