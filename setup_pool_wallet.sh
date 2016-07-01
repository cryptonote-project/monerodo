#!/bin/bash
#MONERODO script to setup pool wallet

FILEDIR=$(grep -n 'filedir' /home/bob/monerodo/conf_files/monerodo.index |cut -d"=" -f2)


echo "This script configures your Monerodo with a new pool wallet."
echo "In order for your Monerodo to work properly, your pool wallet password is stored in a configuration file"
echo "It is HIGHLY recommended that your pool wallet is different than your primary wallet."
echo "Your pool wallet is where pool fees are deposited and from where pool payouts are made"
echo "You will now create a new pool wallet. Please remember the name and password for your wallet."
echo ""
echo "When you are done creating the wallet, type exit and hit enter"
echo ""
echo "Press enter to continue"
read input
./monero_simplewallet.sh
clear

echo "You have now created a new pool wallet."
test_add=0
while ((test_add == 0))
do
	echo "For your reference, these are the available wallets in your wallet directory."
	echo "------------------------------------------------"
	cd /monerodo/wallets/
	dir *.bin
	cd /home/bob/monerodo/
	echo "------------------------------------------------"
	echo ""
	echo "Please enter the name of your pool wallet and then press enter - example: mypoolwallet.bin"
	read poolwallet
	echo ""
	echo "Please enter the password for your poolwallet and then press enter"
	read poolpass
	echo "You have entered $poolwallet and $poolpass. Are these correct? (y)yes or (n)o"
	read info_correct
	case "$info_correct" in
		n) echo "please try again. Press enter to continue" read input ;;
		y) test_add=1 ;;
	esac
	clear
	#The below check was commented out due to the poor performance of the refresh. Could work back in thanks to new optimizations. 
	#echo "We will now test your information to confirm that your pool wallet works properly"
	#echo "Simplewallet will load and attempt to open your wallet using the information you provided"
	#echo "If the wallet loads correctly, please type exit to exit simplewallet and return to setup"
	#echo "If the wallet does not load correctly, please press ctrl+c to return to this menu and try again"
	#echo ""
	#/home/bob/bitmonero/build/release/bin/simplewallet --wallet-file $poolwallet --password $poolpass --daemon-host $monerodo_ip;;
	#echo "-----------------------------------------------"
	#echo "Did the wallet load properly? please enter (y)es or (n)o"
	#read poolrun
	#case "$poolrun" in
	#	n) test_new_wallet=0;;
	#	y) test_new_wallet=(test_new_wallet+1);;
	#esac
	#clear
done
clear
echo "You have succesfully created a pool wallet. We will now create the .conf file that will load simplewallet on boot."
echo "Press enter to continue. At some point during the process, you will be asked to enter your UNIX password."
read input2
echo "We are stopping running services. Please be patient"
# WRITE CONF FILE AND MOVE TO /etc/init/


sudo service mos_monerowallet stop
mv $FILEDIR/mos_monerowallet.conf $FILEDIR/mos_monerowallet.previous

echo -e  "start on bitmonero_sync \n\
stop on stopping mos_bitmonero \n\
console log \n\
respawn \n\
respawn limit 10 10 \n\
pre-start exec logrotate -f /etc/logrotate.d/upstart \n\
post-start exec sh -c 'tail -n +0 --pid=$$ -f /var/log/upstart/mos_monerowallet.log | { sed "/Run net_service/ q" && kill $$ ;}' \n\
exec simplewallet --daemon-host $current_ip --rpc-bind-port 8082 --rpc-bind-ip 127.0.0.1 --wallet-file /monerodo/wallets/$poolwallet --password $poolpass \n\
" > $FILEDIR/mos_monerowallet.conf
#sudo cp $FILEDIR/mos_monerowallet.conf /etc/init/

# modify pool address in config.json in local monerodo directory and copy to pool directory

old_pool="$(awk '{print;}' /monerodo/pool_add.txt)"
ext=".address.txt"
new_pool="$(awk '{print;}' /monerodo/wallets/$poolwallet$ext)"
echo "This is your new pool wallet address: "$new_pool
new_line="\"poolAddress\": \"$new_pool\","

sed -i "s/.*poolAddress.*/$new_line/" $FILEDIR/config.json

#echo $old_pool
#echo $ext
#echo $new_pool
echo "This was the line entered into your config.json for your pool server"
echo $new_line
echo "This is the line in your config.json"
sudo cp $FILEDIR/config.json /monerodo/sam_pool/
grep "poolAddress" $FILEDIR/config.json

sudo cp $FILEDIR/mos_poolnode.conf /etc/init/

echo "======================="
echo "You'll need to manually turn on the pool in the settings menu"
echo "Press enter to continue"
read input3




