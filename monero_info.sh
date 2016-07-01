#!/bin/bash
#MONERODO Manage Monero Settings

#Menu
while true
do
	echo "================="
	echo "Get info on the Monero daemon"
	echo "================="
	echo "!!!!!!!! Status of daemon !!!!!!!!!!"
	bitmonerod --rpc-bind-ip $current_ip status
	#bitmonerod --rpc-bind-ip $current_ip print_status
	#echo ">>>>>>>> BLOCK HEIGHT <<<<<<<<<"
	#bitmonerod --rpc-bind-ip $current_ip print_height
	echo "other options coming soon"
	echo "[1] Print connections"
	echo "[2] Print peer list"
	echo "[3] Status of all the other things"
	echo "[r] Return to monero settings menu"
	echo -e "\n"
	echo -e "Enter your selection"
	echo "Or leave blank and press enter to update info"
	read answer
	case "$answer" in
		1) bitmonerod --rpc-bind-ip $current_ip print_cn;;
		2) bitmonerod --rpc-bind-ip $current_ip print_pl;;
		3)  echo "!!!!!!! Status of all the other important things!!!!!"
	            echo "Note, just because they are running doesn't mean they are working. Check the logs."
	echo "Status of the pool wallet instance"
	service mos_monerowallet status
	service mos_poolnode status
	echo "Status of the NodeJS instance running the pool"
	service mos_poolnode status
	echo "Status of the nvidia miner on the monerodo pool"
	service mos_miner status
	echo "Status of the nvidia miner on the external pool"
	service mos_ext_miner status
	echo "Status of the CPU miner on this monerodo's pool"
	service mos_cpuminer status
	echo "Status of the CPU miner on an external pool"
	service mos_ext_cpuminer.conf status
	echo "Status of the MiniNodo wallet"
	service mos_mininodo status
	service mos_nodowallet status
	;;
		r) exit ;;
	esac
done
