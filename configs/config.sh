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

#cloudaddress="ec2-18-212-31-138.compute-1.amazonaws.com"         # Cloud EC2 instance address # created by Yousef VA
#cloudpublicip=18.212.31.138						                           # Cloud public ip address VA
#cloudaddress="ec2-52-56-200-15.eu-west-2.compute.amazonaws.com" # Cloud EC2 instance address #created by Yousef London
#cloudpublicip=52.56.200.15					                             # Cloud public ip address #AWS in Londaon Yousef
#clouduser="ubuntu" 							                                 # Cloud username e.g. IAM user ec2user1

#edgeaddress1=130.209.253.225						  # Edge Node 01 ip address
#edgeuser1=pi								              # Edge Node 01 username
#edgeaddress2=130.209.253.224							# Edge Node 02 ip address
#edgeuser2=pi								              # Edge Node 02 username
#edgeaddress3=130.209.252.49							  # Edge Node 03 ip address
#edgeuser3=pi								              # Edge Node 03 username

#edgeaddress4=130.209.253.225						  # Edge Node 04 ip address
#edgeuser4=pi								              # Edge Node 04 username
#edgeaddress5=130.209.253.224							# Edge Node 05 ip address
#edgeuser5=pi								              # Edge Node 05 username
#edgeaddress6=130.209.252.49							  # Edge Node 06 ip address
#edgeuser6=pi								              # Edge Node 06 username

#edgeaddress7=130.209.253.225						  # Edge Node 07 ip address
#edgeuser7=pi								              # Edge Node 07 username
#edgeaddress8=130.209.253.224							# Edge Node 08 ip address
#edgeuser8=pi								              # Edge Node 08 username
#edgeaddress9=130.209.252.49							  # Edge Node 09 ip address
#edgeuser9=pi								              # Edge Node 09 username

#edgeaddress10=130.209.253.225						  # Edge Node 10 ip address
#edgeuser10=pi								              # Edge Node 10 username
#edgeaddress11=130.209.253.224							# Edge Node 11 ip address
#edgeuser11=pi								              # Edge Node 11 username
#edgeaddress12=130.209.252.49							# Edge Node 12 ip address
#edgeuser12=pi								              # Edge Node 12 username

#edgeaddress13=130.209.253.225						  # Edge Node 13 ip address
#edgeuser13=pi								              # Edge Node 13 username
#edgeaddress14=130.209.253.224							# Edge Node 14 ip address
#edgeuser14=pi								              # Edge Node 14 username
#edgeaddress15=130.209.252.49							# Edge Node 15 ip address
#edgeuser15=pi								              # Edge Node 15 username


#awskey=/Users/Yousef/Documents/configs/EC2.pem 			   	                    # .pem file location on the local user device VA
#edgeawskey=/mnt/configs/EC2.pem 		       	 	                              # .pem file location on the Edge Node VA
#awskey=/Users/Yousef/Documents/DeFog-master/DeFog/configs/myEC2.pem 		    # London
#edgeawskey=/mnt/configs/myEC2.pem 		                                      # .pem file location on the Edge Node # changed by Yousef

#awskey=~/Users/Yousef/Documents/DeFog-master/DeFog/configs/emptyawskey.pem  			# .pem file location on the local user device
#edgeawskey=/mnt/configs/emptyawskey.pem 		        			                       	# .pem file location on the Edge Node

#foglampaddress="http://localhost:8081"			        # foglamp localhost server addresss
