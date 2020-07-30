#Script to set Falcon fans 
#! /bin/sh

nv=3		# number of variables in each array row
index=0

declare -A servers
servers[0,0]="hr330-0" servers[0,1]="192.168.1.200" servers[0,2]="ADMIN" servers[0,3]="ADMIN"
servers[1,0]="hr330-1" servers[1,1]="192.168.1.201" servers[1,2]="ADMIN" servers[1,3]="Ampere1234!"
servers[2,0]="hr350-0" servers[2,1]="192.168.1.202" servers[2,2]="ADMIN" servers[2,3]="ADMIN"
servers[3,0]="jade-0"  servers[3,1]="192.168.1.203" servers[3,2]="ADMIN" servers[3,3]="ADMIN"

array_size=${#servers[@]}
ns=$(($array_size/($nv+1)))	#number of servers

display_usage () {
	echo ""
	echo "Usage: ./ctrl.sh <server> <on|off|soft|sol a|sol d>"
	echo -ne  "Hosts: "
        for ((i=0;i<ns;i++)) do
                echo -ne "${servers[$i,0]} "
        done
        echo ""
        echo ""
}

if [ $# -ne 2 ] && [ $# -ne 3 ]; then
	display_usage
	exit 1
else 
	match=0
        for ((i=0;i<ns;i++)) do
                #echo "Checking ${servers[$i,0]}"
                if [ "$1" =  ${servers[$i,0]} ]; then
                        #echo "Matched $1"
                        match=1
			index=$i
                fi
        done

        if [ $match -ne 1 ]; then
		display_usage
	else
		if [[ "$2" == "on" || "$2" == "off" || "$2" == "soft" ]]; then
			echo -ne "${servers[$index,0]} power $2"
			if [[ "$2" == "soft" ]]; then
				echo " off"
			else
				echo ""
			fi
			BMCIP=${servers[$index,1]}
			USER=${servers[$index,2]}
			PASS=${servers[$index,3]}
			ipmitool -I lanplus -H $BMCIP -U $USER -P $PASS chassis power $2 
		elif [[ "$2" == "sol"  && ( "$3" == "a" || "$3" == "d" ) ]]; then
			if [ "$3" == "a" ]; then
				SOL=activate
			else
				SOL=deactivate
			fi
			echo "${servers[$index,0]} $2 $SOL"
                        BMCIP=${servers[$index,1]}
                        USER=${servers[$index,2]}
                        PASS=${servers[$index,3]}
                        ipmitool -I lanplus -H $BMCIP -U $USER -P $PASS $2 $SOL 
		else
			display_usage
		fi
        fi
fi

