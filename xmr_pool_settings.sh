#!/bin/bash
#MONERODO pool settings

#Menu
while true
do
	clear
	echo "================="
	echo "Manage Pool server settings"
	echo "================="
	echo "[0] Modify pool server conf file (setup the pool wallet)"
	echo "[1] Turn pool on now and on boot"
	echo "[2] Turn pool off"
	echo "[3] Turn pool off now and stop from running on boot"
	echo "[r] Return to device management menu"
	echo -e "\n"
	echo -e "Enter your selection \c"
	read answer
        export mos_service="mos_monerowallet"
	export running=$(service $mos_service status)
	case "$answer" in
		0) ./setup_pool_wallet.sh;;
		1) ./service_on.sh;;
		2) ./service_off.sh;;
		3) ./service_off.sh
		sudo rm /etc/init/$mos_service.conf;;
		r) exit ;;
	esac
	clear
done
