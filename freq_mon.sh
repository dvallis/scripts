#!/bin/bash
#
# Module: freq_mon_rxxx.sh
#
# Description: monitor frequency of each CPU core using CCPC 
#              and output in a .csv format
# Usage example:
#      ./freq_mon_r100.sh | tee frequencies.csv
#
# History:
# _r100: initial release
#
#
# TODO: More elegant solution rather than use of temp variable
#
#

# frequency sample rate in seconds
sample_rate=5


# get number of cores
CORES=$(lscpu | grep "CPU(s):" | awk '{print $2}' | head -n 1)
limit=`expr $CORES - 1`

# array of frqeuencies
freq=()
Ref_Per=()

Ref_Ctr=()
Ref_Counter=()
Ref_Delta=()

Del_Ctr=()
Del_Counter=()
Del_Delta=()

#Define function for floating point
fp() { awk "BEGIN{ printf \"%.1f\n\", $* }"; }

for ((i=0;i<=limit;i++))
do
  Ref_Per[$i]=$(more /sys/devices/system/cpu/cpu"${i}"/acpi_cppc/reference_perf | awk '{print $1}')
  done



# infinite loop
while :
do

  # output a timestamp
  timestamp=$(date | awk '{print $4}')
  echo -ne "[${timestamp}] "

  # take sample one
  for ((i=0;i<=limit;i++))
  do
    temp=$(more /sys/devices/system/cpu/cpu"${i}"/acpi_cppc/feedback_ctrs)
	Ref_temp="$(cut -d':' -f2 <<< $temp)"
	Ref_Counter[$i]="$(cut -d' ' -f1 <<< $Ref_temp)"
	Del_Counter[$i]="$(cut -d':' -f3 <<< $temp)"
  done

  sleep 1.0 

  # take sample two
  for ((i=0;i<=limit;i++))
  do
    temp=$(more /sys/devices/system/cpu/cpu"${i}"/acpi_cppc/feedback_ctrs)
	Ref_temp="$(cut -d':' -f2 <<< $temp)"
	Ref_Ctr[$i]="$(cut -d' ' -f1 <<< $Ref_temp)"
	Del_Ctr[$i]="$(cut -d':' -f3 <<< $temp)"
  done

  # calculate the delta
  for ((i=0;i<=limit;i++))
  do
    Ref_Delta[$i]=$((Ref_Ctr[$i] - Ref_Counter[$i]))
    Del_Delta[$i]=$((Del_Ctr[$i] - Del_Counter[$i]))
  done

  # calculate frequency and output 
  for ((i=0;i<=limit;i++))
  do
    temp=$((Ref_Delta[$i]))
	if [ $temp -eq 0 ] 
	then
	  freq[$i]=0
	else
	  freq[$i]=$((Ref_Per[$i] * Del_Delta[$i] / Ref_Delta[$i]))
	fi
    #if [ $i -eq $limit ]
	#then
          #echo "${freq[$i]}"
	  #Print It!!!!
          f=$(awk -v a="${freq[$i]}" -v b=1000000 'BEGIN {printf "%.1f ",a/b}')
	  echo -n "$f"
	#else
          #echo -ne "${freq[$i]} "
          #awk -v a="${freq[$i]}" -v b=1000000 'BEGIN {printf "%.2f",a/b}'
          #echo "$c "
    #fi
  done
  echo "" 
  sleep $sample_rate

done
