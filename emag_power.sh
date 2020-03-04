#!/bin/bash

# =======================================================
# Power viewer script
# Darrin Vallis, Ampere Computing
# =======================================================

BMC_IP=192.168.1.63

# ======================================================
# disp_bar(value,color,label)
# ======================================================
RED=1
GREEN=2
YELLOW=3
disp_bar(){ #value color label 
max=`expr $1 / 2`
echo -n $3" "
for (( i = 0 ; i <= $max ; i++ ))
do
        echo -n "$(tput dim)$(tput bold)$(tput setab $2) "
done
echo "$(tput sgr 0) $1 "
}

#initial setup
clear
cpu_power=0
mem_power=0
tot_power=0

while [ 1 ]
do
	echo EMAG POWER METER
	disp_bar $cpu_power $GREEN CPU
	disp_bar $mem_power $YELLOW MEM
	disp_bar $tot_power $RED TOT
	echo $(date)
	sdr=$(ipmitool -I lanplus -H 192.168.1.63 -U ADMIN -P ADMIN sdr type 'Power Supply')
	sleep 5
	cpu_power=$(echo "$sdr" | grep CPU_Power | sed -rn 's/(^|(.* ))([^ ]*) Watts(( .*)|$)/\3/; T; p; q')
	mem_power=$(echo "$sdr" | grep MEM_Power | sed -rn 's/(^|(.* ))([^ ]*) Watts(( .*)|$)/\3/; T; p; q')
	tot_power=$(echo "$sdr" | grep Total_Power | sed -rn 's/(^|(.* ))([^ ]*) Watts(( .*)|$)/\3/; T; p; q')
	clear
done
