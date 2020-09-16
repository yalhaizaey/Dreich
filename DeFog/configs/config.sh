#!/usr/bin/env bash
#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: config.sh
#
# Purpose: Configuration (config) file paramter setup, used to customise the development/deployment environment.
#
#########################################################################################################################

declare -g edge_devices=('192.168.1.224' '192.168.1.168' '192.168.1.182' '192.168.1.131'
'192.168.1.222' '192.168.1.229' '192.168.1.148' '192.168.1.230')

cloudaddress="ec2-3-87-222-15.compute-1.amazonaws.com"          # Cloud EC2 instance address # created by Yousef VA
cloudpublicip=3.87.222.15						                            # Cloud public ip address VA
#cloudaddress="ec2-18-130-129-13.eu-west-2.compute.amazonaws.com"     # Cloud EC2 instance address #created by Yousef London
#cloudpublicip=18.130.129.13				                                   # Cloud public ip address #AWS in Londaon Yousef
clouduser="ubuntu" 							                                   # Cloud username e.g. IAM user ec2user1


#edgeaddress1=192.168.1.224							  # Edge Node 01 ip address   # pi2
edgeaddress1=${edge_devices[0]}
edgeuser1=pi								              # Edge Node 01 username

#edgeaddress2=192.168.1.168						    # Edge Node 02 ip address   # pi3 B
edgeaddress2=${edge_devices[1]}
edgeuser2=pi								              # Edge Node 02 username

#edgeaddress3=192.168.1.182							  # Edge Node 03 ip address   # pi3 B+
edgeaddress3=${edge_devices[2]}
edgeuser3=pi								              # Edge Node 03 username

#edgeaddress4=192.168.1.131						    # Edge Node 04 ip address   #pi 4
edgeaddress4=${edge_devices[3]}
edgeuser4=pi

#edgeaddress4=192.168.1.222						    # Edge Node 05 ip address   #pi 5
edgeaddress5=${edge_devices[4]}
edgeuser5=pi

#edgeaddress4=192.168.1.229					    # Edge Node 06 ip address   #pi 6
edgeaddress6=${edge_devices[5]}
edgeuser6=pi

#edgeaddress4=192.168.1.148					    # Edge Node 06 ip address   #pi 7
edgeaddress7=${edge_devices[6]}
edgeuser7=pi

#edgeaddress4=192.168.1.230					    # Edge Node 06 ip address   #pi 7
edgeaddress8=${edge_devices[7]}
edgeuser8=pi



awskey=/Users/Yousef/Documents/configs/EC2.pem 			   	                  # .pem file location on the local user device VA
edgeawskey=/mnt/configs/EC2.pem 		       	 	                            # .pem file location on the Edge Node VA
#awskey=/Users/Yousef/Documents/configs/myEC2.pem 		                    # London
#edgeawskey=/mnt/configs/myEC2.pem 		                                    # .pem file location on the Edge Node # changed by Yousef

#awskey=~/Users/Yousef/Documents/DeFog-master/DeFog/configs/emptyawskey.pem  			# .pem file location on the local user device
#edgeawskey=/mnt/configs/emptyawskey.pem 		        			                       	# .pem file location on the Edge Node

foglampaddress="http://localhost:8081"			        # foglamp localhost server addresss
