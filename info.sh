#!/bin/bash
#
# Module: osprey-info_r00.sh
#
# Description: Info gathering script
#
# Usage: ./osprey-info.sh <BMC-IP-ADDRESS>
# example: ./osprey-info.sh 10.76.192.92
#
# _r00: initial draft, removed /bin/bash, fru & sdr don't work??
#
# TODO: fru and sdr work different in script versus command line
#       variables like passwords not working properly
#
#

logo () {
echo ""
echo "             ▄██▄"
echo "            ▄█  █▄"
echo "           ▄█    █▄"
echo "       ▄▄▄▄█  ▄▄▄ █▄"
echo "   ▄█▀▀▀ ▄█      ▀██▄"
echo " ▄█▀    ▄█         ▀█▄"
echo " A M P E R E COMPUTING"
echo ""
}

logo

BMC_IP=192.168.1.48

Product_MFG=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Product Manuf" | awk '{print $4}')
echo "Product Manufacturer : ${Product_MFG}"

Product_Name=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Product Name" | awk '{print $4}')
echo "Product Name         : ${Product_Name}"

Product_PN=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Product Part Number" | awk '{print $5}')
echo "Product Part Number  : ${Product_PN}"

Product_SN=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Product Serial" | awk '{print $4}')
echo "Product Serial Number: ${Product_SN}"

Chassis_PN=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Chassis Part Number" | awk '{print $5}')
echo "Chassis Part Number  : ${Chassis_PN}"

Chassis_SN=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Chassis Serial" | awk '{print $4}')
echo "Chassis Serial Number: ${Chassis_SN}"

Board_MFG=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Board Mfg  " | awk '{print $4}')
echo "Board Manufacturer   : ${Board_MFG}"

Board_Name=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Board Product" | awk '{print $4}')
echo "Board Name           : ${Board_Name}"

Board_PN=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Board Part Number" | awk '{print $5}')
echo "Board Part Number    : ${Board_PN}"

Board_SN=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN fru print | grep -i "Board Serial" | awk '{print $4}')
echo "Board Serial Number  : ${Board_SN}"

MFG_ID=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN mc info | grep -i "Manufacturer ID" | awk '{print $4}')
echo "BMC Manufacturer ID  : ${MFG_ID}"

MFG_Name=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN mc info | grep -i "Manufacturer Name" | sed -e 's/.*: //')
echo "BMC Manufacturer Name: ${MFG_Name}"

BMC_MAC=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN lan print | grep "MAC Address" | awk '{print $4}')
echo "BMC MAC address      : ${BMC_MAC}"

BMC_IP=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN lan print | grep "IP Address" | awk '/Address/ && ++n==2 {print $4}')
echo "BMC IP address       : ${BMC_IP}"

BMC_FW=$(sudo ipmitool -I lanplus -H ${BMC_IP} -U ADMIN -P ADMIN mc info | grep -i "Firmware Revision" | awk '{print $4}')
echo "BMC FW revision      : ${BMC_FW}"

NIC_NAME=$(lspci | grep -i ethernet | sed -n -e 's/^.*Ethernet controller: //p')
echo "NIC Card             : ${NIC_NAME}"
echo ""