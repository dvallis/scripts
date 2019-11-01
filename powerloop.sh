#!/bin/bash
# 
# Module: powerloop_rxx.sh
# 
# Description: Measures power on SoC via BMC 
#
# r00: initial draft
# r01: minor clean up, power sensor type
#
# To Do List
#
#
# Variables
#BMC_IP=$1
BMC_IP=192.168.1.48
BMC_USERNAME=ADMIN
BMC_PASSWORD=ADMIN
POWER=0
BMC_MAC=""
TIMESTAMP=""
DATESTAMP=""

echo ""
echo "Working please wait"
echo ""

#
# BMC MAC
BMC_MAC=$(ipmitool -I lanplus -H ${BMC_IP} -U ${BMC_USERNAME} -P ${BMC_PASSWORD} lan print | grep "MAC A"| awk '{print $4}')

# Get Date
DATESTAMP=$(date | awk '{print $2 " " $3 ", " $6}')

# Print a summary of the information gathered
echo ""
echo "DATE: ${DATESTAMP}"
echo "BMC IP address  : ${BMC_IP}"
echo "BMC MAC address : ${BMC_MAC}"

while :
do
  # Read power from BMC
  # POWER=$(ipmitool -I lanplus -H ${BMC_IP} -U ${BMC_USERNAME} -P ${BMC_PASSWORD} sdr type 0x08 |& grep -i CPU_Power | awk '{print $3}')    
  #POWER=$(ipmitool -I lanplus -H ${BMC_IP} -U ${BMC_USERNAME} -P ${BMC_PASSWORD} sdr |& grep -i CPU_Power | awk '{print $3}')    
  POWER=$(ipmitool -I lanplus -H ${BMC_IP} -U ${BMC_USERNAME} -P ${BMC_PASSWORD} sensor reading CPU_Power |& awk '{print $3}')    
  # Get Time Stamp
  TIMESTAMP=$(date | awk '{print $4}')
  echo "${POWER},Watts,${TIMESTAMP}"
  sleep 1
done

