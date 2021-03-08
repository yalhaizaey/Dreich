#!/bin/bash

# link local address to the config file - UPDATE condig.sh LOCATION
source /Users/Yousef/Documents/configs/config.sh

# create local variables of config variables - Make sure to UPDATE the location of the configs
cloudaddress=$cloudaddress
clouduser=$clouduser

edgeaddress1=$edgeaddress1
edgeaddress2=$edgeaddress2
edgeaddress3=$edgeaddress3
edgeaddress4=$edgeaddress4


edgeuser1=$edgeuser1
edgeuser2=$edgeuser2
edgeuser3=$edgeuser3
edgeuser4=$edgeuser4


awskey=$awskey
cloudpublicip=$cloudpublicip

configslocation=/Users/Yousef/Documents/configs/*
configfilelocation=/Users/Yousef/Documents/config.sh


function nodes_loadavg {
  cpu_start_time=$(gdate +%s.%N)
  while true; do
    echo "Reading loadaverage of the available edge nodes"
    cpu_usage1=$(ssh $edgeuser1@$edgeaddress1 cat /proc/loadavg | awk '{print $1}')
    cpu_usage2=$(ssh $edgeuser2@$edgeaddress2 cat /proc/loadavg | awk '{print $1}')
    cpu_usage3=$(ssh $edgeuser3@$edgeaddress3 cat /proc/loadavg | awk '{print $1}')
    cpu_usage4=$(ssh $edgeuser4@$edgeaddress4 cat /proc/loadavg | awk '{print $1}')

    echo cpu load of $edgeaddress1 = $cpu_usage1
    echo cpu load of $edgeaddress2 = $cpu_usage2
    echo cpu load of $edgeaddress3 = $cpu_usage3
    echo cpu load of $edgeaddress4 = $cpu_usage4

    declare nodes_loadavarages=($cpu_usage1 $cpu_usage2 $cpu_usage3 $cpu_usage4)

    # declare nodes_loadavarages=($cpu_usage1 $cpu_usage2 $cpu_usage3 $cpu_usage4 $cpu_usage5
    # $cpu_usage6 $cpu_usage7 $cpu_usage8)

  	max=${nodes_loadavarages[0]}
  	min=${nodes_loadavarages[0]}
    for i in "${nodes_loadavarages[@]}";
    do
      (( $(echo "$i > $max" |bc -l) )) && max=$i
      (( $(echo "$i < $min" |bc -l) )) && min=$i
    done

  	#to find the index of device with maximum loadavarage
  	for i in "${!nodes_loadavarages[@]}"; do
      if [[ "${nodes_loadavarages[$i]}" = "${max}" ]]; then
        device1="${i}"
      fi
    done

  	#To find the index of device with minimum loadavarage
  	for i in "${!nodes_loadavarages[@]}"; do
      if [[ "${nodes_loadavarages[$i]}" = "${min}" ]]; then
        device2="${i}"
      fi
    done

  	##########################################################################
  	#edge_device = the deivce that has min loadavarage
  	edge_device=$device2
  	case $edge_device in
      '0')
      edgeaddress=$edgeaddress1
      edgeuser=$edgeuser1
      break;;
  		'1')
  		edgeaddress=$edgeaddress2
  		edgeuser=$edgeuser2
  		break;;
  		'2')
  		edgeaddress=$edgeaddress3
  		edgeuser=$edgeuser3
  		break;;
      '3')
      edgeaddress=$edgeaddress4
      edgeuser=$edgeuser4
      break;;
  		*)
      echo "Wrong input, try again";;
  		esac
    done
    cpunode=$edgeaddress
    echo Workload will be offloaded to edge node $cpunode
    cpu_end_time=$(gdate +%s.%N)  #added by Yousef
    cpu_time=$( echo "$cpu_end_time - $cpu_start_time" | bc -l )
    echo cpu_ssh_time= $cpu_time
    echo

}
while true; do
  nodes_loadavg
  echo $cpunode &> /Users/Yousef/Desktop/Dreich_v1/DeFog/dm/cpu.txt
done

# to read results is a file
# function nodes_loadavg {
#   edgeaddress=$(cat /Users/Yousef/Desktop/Dreich_v1/DeFog/dm/cpu.txt)
#   edgeuser=pi
#   echo $edgeaddress
# }
