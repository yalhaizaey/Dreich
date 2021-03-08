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


function nodes_memory {
memory_start_time=$(gdate +%s.%N)  #added by Yousef
while true; do

echo "Reading Free Memory of available edge nodes"
node1_mem=$(ssh $edgeuser1@$edgeaddress1 free --mega | grep Mem | awk '{print $4}')
node2_mem=$(ssh $edgeuser2@$edgeaddress2 free --mega | grep Mem | awk '{print $4}')
node3_mem=$(ssh $edgeuser3@$edgeaddress3 free --mega | grep Mem | awk '{print $4}')
node4_mem=$(ssh $edgeuser4@$edgeaddress4 free --mega | grep Mem | awk '{print $4}')

echo memory at $edgeaddress1 = $node1_mem
echo memory at $edgeaddress2 = $node2_mem
echo memory at $edgeaddress3 = $node3_mem
echo memory at $edgeaddress4 = $node4_mem

#comapare the RAM and select the deivce that has the max
declare nodes_mem=($node1_mem $node2_mem $node3_mem $node4_mem)

# echo Free Memory of the avilable edge nodes =  ${nodes_mem[*]}
# echo -e

max=${nodes_mem[0]}
min=${nodes_mem[0]}
for i in "${nodes_mem[@]}";
do
  (( $(echo "$i > $max" |bc -l) )) && max=$i
  (( $(echo "$i < $min" |bc -l) )) && min=$i
done

#to find the index of device with maximum free memory
for i in "${!nodes_mem[@]}"; do
  if [[ "${nodes_mem[$i]}" = "${max}" ]]; then
    device1="${i}"
    #echo index of maximum is $device1;
  fi
done

#To find the index of device with minimum free memory
for i in "${!nodes_mem[@]}"; do
  if [[ "${nodes_mem[$i]}" = "${min}" ]]; then
    device2="${i}"
    #echo index of minimum is $device2;
  fi
done

  ########################################################################
  #edge_device = the deivce that has max free memory

edge_device=$device1

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

memnode=$edgeaddress
echo Workload will be offloaded to edge node $memnode

memory_end_time=$(gdate +%s.%N)  #added by Yousef
memory_time=$( echo "$memory_end_time - $memory_start_time" | bc -l )
echo memory_ssh_time= $memory_time
echo

}

while true; do
  nodes_memory
  echo $memnode &> /Users/Yousef/Desktop/Dreich_v1/DeFog/dm/memory.txt
done
