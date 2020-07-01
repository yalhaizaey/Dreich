#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: runedge.sh
#
# Purpose: This script invokes a docker exec/run command. Volumes are mounted to allow access to external folders:
#			configuration folder, assets, results and aws credentials. The image keyword binds the image name to the
#			current run process. This process is run in non-interactive mode (detached), allowing for automation of
#			the execute.sh. When finished with the current process, the container will be exit. The execute.sh script
#			is passed in as a CMD asset script. This is run on the Edge service.
#
#########################################################################################################################

#docker run --rm -v ~/defog/configs:/mnt/configs -v ~/defog/assets:/mnt/assets -v ~/defog/results:/mnt/results -v /root/.aws:/root/.aws --name aeneas aeneas ../scripts/execute.sh $1 $2

#changed by Yousef
#docker run --rm -v /home/pi/defog/configs:/mnt/configs -v /home/pi/defog/assets:/mnt/assets -v /home/pi/defog/results:/mnt/results -v /root/.aws:/root/.aws --name aeneas aeneas ../scripts/execute.sh $1 $2

# changed by Yousef to dynamically naming containers
docker run --rm -v /home/pi/defog/configs:/mnt/configs -v /home/pi/defog/assets:/mnt/assets -v /home/pi/defog/results:/mnt/results -v /root/.aws:/root/.aws --name $3 aeneas ../scripts/execute.sh $1 $2 $3
echo $1
echo $2
echo $3
