function nodes_loadavg {
    cpu_start_time=$(gdate +%s.%N)  #added by Yousef
  	if [ "$environment" == "-e" ] || [ "$environment" == "-b" ];
  	then
  		while true; do
  			echo ""
  		  ##########################################################################
        # remotely access edge nodes and read the current loadavarage
  			echo "Reading loadaverage of the available edge nodes:"
  			cpu_usage1=$(ssh $edgeuser1@$edgeaddress1 cat /proc/loadavg | awk '{print $1}')
  			cpu_usage2=$(ssh $edgeuser2@$edgeaddress2 cat /proc/loadavg | awk '{print $1}')
  			cpu_usage3=$(ssh $edgeuser3@$edgeaddress3 cat /proc/loadavg | awk '{print $1}')
        cpu_usage4=$(ssh $edgeuser4@$edgeaddress4 cat /proc/loadavg | awk '{print $1}')

        #cpu_usage5=$(ssh $edgeuser5@$edgeaddress5 cat /proc/loadavg | awk '{print $1}')
        #cpu_usage6=$(ssh $edgeuser6@$edgeaddress6 cat /proc/loadavg | awk '{print $1}')
        #cpu_usage7=$(ssh $edgeuser7@$edgeaddress7 cat /proc/loadavg | awk '{print $1}')
        #cpu_usage8=$(ssh $edgeuser8@$edgeaddress8 cat /proc/loadavg | awk '{print $1}')
        #cpu_usage5=$(ssh -i "myEC2.pem" $clouduser@$cloudaddress cat /proc/loadavg | awk '{print $1}')

        echo loadavarage of $edgeaddress1 is $cpu_usage1
        echo loadavarage of $edgeaddress2 is $cpu_usage2
        echo loadavarage of $edgeaddress3 is $cpu_usage3
        echo loadavarage of $edgeaddress4 is $cpu_usage4

        #echo loadavarage of $edgeaddress5 is $cpu_usage5
        #echo loadavarage of $edgeaddress6 is $cpu_usage6
        #echo loadavarage of $edgeaddress7 is $cpu_usage7
        #echo loadavarage of $edgeaddress8 is $cpu_usage8
        #echo loadavarage of $clouduser is $cpu_usage5

  			echo -e
        declare nodes_loadavarages=($cpu_usage1 $cpu_usage2 $cpu_usage3 $cpu_usage4 $cpu_usage5
        $cpu_usage6 $cpu_usage7 $cpu_usage8)
        echo loadavarages of the avilable edge nodes =  ${nodes_loadavarages[*]}
  			echo -e

  			max=${nodes_loadavarages[0]}
  			min=${nodes_loadavarages[0]}
  			for i in "${nodes_loadavarages[@]}";
  			do
  				(( $(echo "$i > $max" |bc -l) )) && max=$i
  				(( $(echo "$i < $min" |bc -l) )) && min=$i
  			done
  			echo maximum loadaverage is $max
  			echo minimum loadavarage is $min

  			#to find the index of device with maximum loadavarage
  			for i in "${!nodes_loadavarages[@]}"; do
  			   if [[ "${nodes_loadavarages[$i]}" = "${max}" ]]; then
  			     device1="${i}"
  			     echo index of maximum is $device1;
  			   fi
  			done

  			#To find the index of device with minimum loadavarage
  			for i in "${!nodes_loadavarages[@]}"; do
  			   if [[ "${nodes_loadavarages[$i]}" = "${min}" ]]; then
  			     device2="${i}"
  			       echo index of minimum is $device2;
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
        '4')
           edgeaddress=$edgeaddress5
           edgeuser=$edgeuser5
           break;;
        '5')
           edgeaddress=$edgeaddress6
           edgeuser=$edgeuser6
           break;;
        '6')
           edgeaddress=$edgeaddress7
           edgeuser=$edgeuser7
           break;;
        '7')
           edgeaddress=$edgeaddress8
           edgeuser=$edgeuser8
           break;;
  			*)
  			   echo "Wrong input, try again";;
  		  esac
  		done
  	fi
  	echo ""
  	#echo device that has the maximum workload is $
  	#echo device that has the minimum workload is $edgeaddress
  	echo Workload will be offloaded to edge node $edgeaddress
    cpu_end_time=$(gdate +%s.%N)  #added by Yousef
    cpu_time=$( echo "$cpu_end_time - $cpu_start_time" | bc -l )
    echo cpu_ssh_time= $cpu_time
}
###############################################################################
function nodes_memory {
  memory_start_time=$(gdate +%s.%N)  #added by Yousef
  if [ "$environment" == "-e" ] || [ "$environment" == "-b" ];
  then
    while true; do
      echo "Reading Free Memory of available edge nodes"
      node1_mem=$(ssh $edgeuser1@$edgeaddress1 free --mega | grep Mem | awk '{print $4}')
      node2_mem=$(ssh $edgeuser2@$edgeaddress2 free --mega | grep Mem | awk '{print $4}')
      node3_mem=$(ssh $edgeuser3@$edgeaddress3 free --mega | grep Mem | awk '{print $4}')
      node4_mem=$(ssh $edgeuser4@$edgeaddress4 free --mega | grep Mem | awk '{print $4}')

      #node5_mem=$(ssh $edgeuser5@$edgeaddress5 free --mega | grep Mem | awk '{print $4}')
      #node6_mem=$(ssh $edgeuser6@$edgeaddress6 free --mega | grep Mem | awk '{print $4}')
      #node7_mem=$(ssh $edgeuser7@$edgeaddress7 free --mega | grep Mem | awk '{print $4}')
      #node8_mem=$(ssh $edgeuser8@$edgeaddress8 free --mega | grep Mem | awk '{print $4}')

      echo Free Memory of $edgeaddress1 is $node1_mem megabytes
      echo Free Memory of $edgeaddress2 is $node2_mem megabytes
      echo Free Memory of $edgeaddress3 is $node3_mem megabytes
      echo Free Memory of $edgeaddress4 is $node4_mem megabytes

      #echo Free Memory of $edgeaddress5 is $node5_mem megabytes
      #echo Free Memory of $edgeaddress6 is $node6_mem megabytes
      #echo Free Memory of $edgeaddress7 is $node7_mem megabytes
      #echo Free Memory of $edgeaddress8 is $node8_mem megabytes

  ################################################################################
  #comapare the RAM and select the deivce that has the max
     echo -e
     declare nodes_mem=($node1_mem $node2_mem $node3_mem $node4_mem
     $node5_mem $node6_mem $node7_mem $node8_mem)
     echo Free Memory of the avilable edge nodes =  ${nodes_mem[*]}
     echo -e

     max=${nodes_mem[0]}
     min=${nodes_mem[0]}
     for i in "${nodes_mem[@]}";
     do
       (( $(echo "$i > $max" |bc -l) )) && max=$i
       (( $(echo "$i < $min" |bc -l) )) && min=$i
     done
     echo maximum memory is $max
     echo minimum memory is $min

     #to find the index of device with maximum free memory
     for i in "${!nodes_mem[@]}"; do
       if [[ "${nodes_mem[$i]}" = "${max}" ]]; then
       device1="${i}"
       echo index of maximum is $device1;
     fi
   done

   #To find the index of device with minimum free memory
   for i in "${!nodes_mem[@]}"; do
     if [[ "${nodes_mem[$i]}" = "${min}" ]]; then
       device2="${i}"
      echo index of minimum is $device2;
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
  '4')
     edgeaddress=$edgeaddress5
     edgeuser=$edgeuser5
     break;;
  '5')
     edgeaddress=$edgeaddress6
     edgeuser=$edgeuser6
     break;;
  '6')
     edgeaddress=$edgeaddress7
     edgeuser=$edgeuser7
     break;;
  '7')
     edgeaddress=$edgeaddress8
     edgeuser=$edgeuser8
     break;;
  *)
     echo "Wrong input, try again";;
  esac
done
fi
echo ""
echo Workload will be offloaded to edge node $edgeaddress
memory_end_time=$(gdate +%s.%N)  #added by Yousef
memory_time=$( echo "$memory_end_time - $memory_start_time" | bc -l )
echo memory_ssh_time= $memory_time

}


################################################################################
function nodes_latency {
  	if [ "$environment" == "-e" ] || [ "$environment" == "-b" ];
  	then
  		while true; do
  			echo ""
  			########################################################################
  			# communication latency using ping
  			echo "Communication Latency to the available Edge Nodes:"
  			#communication_latency1=$(ping -c 1 $edgeaddress1)
  			#extract avg time in ping
  			node1_latency=$(ping -c 1 $edgeaddress1 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
  			node2_latency=$(ping -c 1 $edgeaddress2 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
  			node3_latency=$(ping -c 1 $edgeaddress3 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
        node4_latency=$(ping -c 1 $edgeaddress4 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
        #communication_latency4=$(ping -c 1 $edgeaddress4 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
  			#communication_latency5=$(ping -c 1 $cloudaddress | tail -1| awk '{print $4}' | cut -d '/' -f 2)

  			echo Communciation Latency to $edgeaddress1 is $node1_latency ms
  			echo Communciation Latency to $edgeaddress2 is $node2_latency ms
  			echo Communciation Latency to $edgeaddress3 is $node3_latency ms
        echo Communciation Latency to $edgeaddress4 is $node4_latency ms
        #echo Communciation Latency to $edgeaddress4 is $communication_latency4 ms
  			#echo Communciation Latency to the Cloud-AWS is $communication_latency5 ms

  			########################################################################
  			#comapare the pings and select the deivce that has the min latency
  			echo -e
  			declare nodes_latency=($node1_latency $node2_latency $node3_latency $node4_latency)
  			echo Communication Latency of the avilable edge nodes =  ${nodes_latency[*]}
  			echo -e

  			max=${nodes_latency[0]}
  			min=${nodes_latency[0]}
  			for i in "${nodes_latency[@]}";
  			do
  				(( $(echo "$i > $max" |bc -l) )) && max=$i
  				(( $(echo "$i < $min" |bc -l) )) && min=$i
  			done
  			echo maximum nodes_latency is $max
  			echo minimum nodes_latency is $min

  			#to find the index of device with maximum latency
  			for i in "${!nodes_latency[@]}"; do
  			   if [[ "${nodes_latency[$i]}" = "${max}" ]]; then
  			     device1="${i}"
  			     echo index of maximum is $device1;
  			   fi
  			done

  			#To find the index of device with minimum latecny
  			for i in "${!nodes_latency[@]}"; do
  			   if [[ "${nodes_latency[$i]}" = "${min}" ]]; then
  			     device2="${i}"
  			       echo index of minimum is $device2;
  			   fi
  			done

  			########################################################################
  			#edge_device = the deivce that has min latency
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
  	fi
  	echo ""
  	echo Workload will be offloaded to edge node $edgeaddress

}
################################################################################
function nodes_specification {

  	if [ "$environment" == "-e" ] || [ "$environment" == "-b" ];
  	then
  		while true; do

  			echo ""
  		  ########################################################################
        # remotely access edge devices nodes and read the hardware specifications
  			echo "Reading CPU specifications of available edge nodes:"
  			cpu_info1=$(ssh $edgeuser1@$edgeaddress1 grep bogomips -i /proc/cpuinfo | tail -1| awk '{print $3}' | cut -d '/' -f 2)
  			cpu_info2=$(ssh $edgeuser2@$edgeaddress2 grep bogomips -i /proc/cpuinfo | tail -1| awk '{print $3}' | cut -d '/' -f 2)
  			cpu_info3=$(ssh $edgeuser3@$edgeaddress3 grep bogomips -i /proc/cpuinfo | tail -1| awk '{print $3}' | cut -d '/' -f 2)
        cpu_info4=$(ssh $edgeuser4@$edgeaddress4 grep bogomips -i /proc/cpuinfo | tail -1| awk '{print $3}' | cut -d '/' -f 2)
        #cpu_info5=$(ssh -i "myEC2.pem" $clouduser@$cloudaddress cat /proc/cpuinfo | awk -F: '/model name/ {name=$2} END {print name}')

        echo cpuinfo of $edgeaddress1 is $cpu_info1
        echo cpuinfo of $edgeaddress2 is $cpu_info2
        echo cpuinfo of $edgeaddress3 is $cpu_info3
        echo cpuinfo of $edgeaddress4 is $cpu_info4
        #echo cpuinfo of $cloudaddress is $cpu_info5

  			##########################################################################
  			#comapare the loadavarages and select the deivce that has the min loadavarage
  			echo -e
  			declare nodes_infos=($cpu_info1 $cpu_info2 $cpu_info3 $cpu_info4)

  			max=${nodes_infos[0]}
  			min=${nodes_infos[0]}
  			for i in "${nodes_infos[@]}";
  			do
  				(( $(echo "$i > $max" |bc -l) )) && max=$i
  				(( $(echo "$i < $min" |bc -l) )) && min=$i
  			done
  			echo maximum cpu is $max
  			echo minimum cpu is $min

  			#to find the index of device with maximum value
  			for i in "${!nodes_infos[@]}"; do
  			   if [[ "${nodes_infos[$i]}" = "${max}" ]]; then
  			     device1="${i}"
  			     echo index of maximum is $device1;
  			   fi
  			done

  			#To find the index of device with minimum value
  			for i in "${!nodes_infos[@]}"; do
  			   if [[ "${nodes_infos[$i]}" = "${min}" ]]; then
  			     device2="${i}"
  			       echo index of minimum is $device2;
  			   fi
  			done

  			##########################################################################
  			#edge_device = the deivce that has max MIPS value
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
  	fi
  	echo ""
  	echo Workload will be offloaded to edge node $edgeaddress

}
################################################################################
function profiling_nodes {
  echo
  echo "Profiling edge nodes:"
  echo
  echo "Reading loadaverage of the available edge nodes:"
  cpu_usage1=$(ssh $edgeuser1@$edgeaddress1 cat /proc/loadavg | awk '{print $1}')
  cpu_usage2=$(ssh $edgeuser2@$edgeaddress2 cat /proc/loadavg | awk '{print $1}')
  cpu_usage3=$(ssh $edgeuser3@$edgeaddress3 cat /proc/loadavg | awk '{print $1}')
  cpu_usage4=$(ssh $edgeuser4@$edgeaddress4 cat /proc/loadavg | awk '{print $1}')

  echo loadavarage of $edgeaddress1 is $cpu_usage1
  echo loadavarage of $edgeaddress2 is $cpu_usage2
  echo loadavarage of $edgeaddress3 is $cpu_usage3
  echo loadavarage of $edgeaddress4 is $cpu_usage4
  echo

  echo "Reading Communication Latency to the available Edge Nodes:"
  node1_latency=$(ping -c 1 $edgeaddress1 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
  node2_latency=$(ping -c 1 $edgeaddress2 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
  node3_latency=$(ping -c 1 $edgeaddress3 | tail -1| awk '{print $4}' | cut -d '/' -f 2)
  node4_latency=$(ping -c 1 $edgeaddress4 | tail -1| awk '{print $4}' | cut -d '/' -f 2)

  echo Communciation Latency to $edgeaddress1 is $node1_latency ms
  echo Communciation Latency to $edgeaddress2 is $node2_latency ms
  echo Communciation Latency to $edgeaddress3 is $node3_latency ms
  echo Communciation Latency to $edgeaddress4 is $node4_latency ms
  echo

  echo "Reading Free Memory of available edge nodes"
  node1_mem=$(ssh $edgeuser1@$edgeaddress1 free --mega | grep Mem | awk '{print $4}')
  node2_mem=$(ssh $edgeuser2@$edgeaddress2 free --mega | grep Mem | awk '{print $4}')
  node3_mem=$(ssh $edgeuser3@$edgeaddress3 free --mega | grep Mem | awk '{print $4}')
  node4_mem=$(ssh $edgeuser4@$edgeaddress4 free --mega | grep Mem | awk '{print $4}')

  echo Free Memory of $edgeaddress1 is $node1_mem megabytes
  echo Free Memory of $edgeaddress2 is $node2_mem megabytes
  echo Free Memory of $edgeaddress3 is $node3_mem megabytes
  echo Free Memory of $edgeaddress4 is $node4_mem megabytes
  echo

  echo "Reading CPU specifications of available edge nodes:"
  cpu_info1=$(ssh $edgeuser1@$edgeaddress1 grep bogomips -i /proc/cpuinfo | tail -1| awk '{print $3}' | cut -d '/' -f 2)
  cpu_info2=$(ssh $edgeuser2@$edgeaddress2 grep bogomips -i /proc/cpuinfo | tail -1| awk '{print $3}' | cut -d '/' -f 2)
  cpu_info3=$(ssh $edgeuser3@$edgeaddress3 grep bogomips -i /proc/cpuinfo | tail -1| awk '{print $3}' | cut -d '/' -f 2)
  cpu_info4=$(ssh $edgeuser4@$edgeaddress4 grep bogomips -i /proc/cpuinfo | tail -1| awk '{print $3}' | cut -d '/' -f 2)

  echo cpuinfo of $edgeaddress1 is $cpu_info1
  echo cpuinfo of $edgeaddress2 is $cpu_info2
  echo cpuinfo of $edgeaddress3 is $cpu_info3
  echo cpuinfo of $edgeaddress4 is $cpu_info4
  echo
}
################################################################################
