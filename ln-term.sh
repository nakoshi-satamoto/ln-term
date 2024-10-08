#!/bin/bash

# Name: LN-Term
# The operator of the lightning node known as nakoshi-satamoto with public key 038e5677dc7d1ec4e9a82bd004d524b2469fedb0867e85bd1e2f5d3352957e03b7.
# Contributers: https://github.com/Lagrang3/ (updated deprecated listpeers command to listpeerchannels)
# Version timestamp: Block 858746

# This is intended for use with core lightning. This has been tested up to Core Lightning version 24. But Core Lightning is broken after version 23 because version 24 does not support payments which is kind of the point of the lightning network. Stick with Core Lightning version 23 until Core Lightning in later versions is fixed again or if Core Lightning is forked. I intend to fork Core Lightning from version 23 as the base of a new functional lightning network implementation. Core Lightning before version 24 is actually great.
# Execute with command "./ln-term.sh" or "watch ./ln-term.sh" for realtime monitoring. This tool shows realtime information of a lightning router including channels, channel balances, and statuses. This was inspired by the core lightning summary.py plugin, but I wanted something that was not using python, having no or minimal dependencies. Python apps are a horrendous dependency nightmare with a known high risk of software supply chain compromise. Simplicity is elegance.

# Dependencies: jq for parsing json.

# If lightning is not installed system wide, you can replace lightning-cli in this script with ./lightning-cli if in the same directory as the lightning binaries, or you can declare the full path to lighting-cli.

# Options:
PeerSwapEnabled=no
KeySendEnabled=yes
NumberOfKeySends=1
LogEnabled=yes
LogLocation=~/.lightning/ln-log.txt
NumberOfLogEntries=3

# You can optionally customize this script. You can search for the relevant section for each feature by the # hashtag.
# #Banner - Choose your banner by commenting and uncommenting the banner of your choice. # Means it is commented out and ignored by the script.
# #PeerSwap - This shows info relating to PeerSwap such as your Liquid BTC balance and number of PeerSwap peers. You can enable this in the options above.
# #Directory - Assigning aliases to your peers in the directory.
# #Keysend - Outputs the latest keysend messages. You can enable or disable this in the options above along with the number of output lines.
# #Log - Declaring the location of your log file in the above options LogLocation, if any is used. You also can enable or disable this in the options above along with the number of output lines.

# Warning: Use this at your own risk, I accept no responsibility for whatever happens as a result of using or relying on this script. This script needs to be security audited. That being said, this script works great for me and I have never had any issues with it.

# To do list, and features to possibly implement in the future after testing
# 1. Audit security, specifically resilience from bash and jq injections. How well does jq sanitize input?
# 2. Have the peer alias directory stored in a separate file which is then loaded into ln-term. This would eliminate the need to re-import the directory into the script after each update. This would also make sharing of lightning router directories with others easy or even allow for the automated generating of a directory.
# 3. Mark peers which support PeerSwap.

clear

#Banner
# you can comment or uncomment different banners to modify what is shown. Make sure the " is before and after what you want shown.
#
# Fancy Banner
#echo -n "
#					██╗     ██╗ ██████╗ ██╗  ██╗████████╗███╗   ██╗██╗███╗   ██╗ ██████╗ 
#					██║     ██║██╔════╝ ██║  ██║╚══██╔══╝████╗  ██║██║████╗  ██║██╔════╝ 
#					██║     ██║██║  ███╗███████║   ██║   ██╔██╗ ██║██║██╔██╗ ██║██║  ███╗
#					██║     ██║██║   ██║██╔══██║   ██║   ██║╚██╗██║██║██║╚██╗██║██║   ██║
#					███████╗██║╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║██║ ╚████║╚██████╔╝
#					╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
#"
#					███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗       
#					████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝       
#					██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝        
#					██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗        
#					██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗       
#					╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝       
#"
#
# Compact Banner
echo "								==================="
echo "								⚡LIGHTNING NETWORK⚡"
echo "								==================="
echo -n "								" && date +"%Y-%m-%d,%H:%M:%S"

# Top part
# {'printf("%" "11d", $1)'} is the padding operation used in this top part where if an amount is less than 11 characters in length it pads it with a space in front. This is enough to display up to 999 bitcoins. If you have more than that on a lightning node you can increase this number from 11. 
lightning-cli getinfo | jq '"Network:" + (.network | tostring) + " | " + "Blockheight:" + (.blockheight | tostring) + " | " + "Alias:" + (.alias | tostring) + " | " + "ID:" + .id'
echo -n "Your view of the lightning network: " && lightning-cli -H listnodes | grep -c ^nodeid | tr -d '\n' && echo -n " nodes, " && lightning-cli -H listchannels | grep -c ^short_channel_id | tr -d '\n' && echo " chans"
#echo "--------------------------------------------------------------------------------------------------------------------------------------------------"
#
# top row 1
# Lightning fees earned (sats) earned over time
echo -n "  Lightning fees (sats) earned over time: "
lightning-cli getinfo | jq '.fees_collected_msat / 1000' | awk {'printf("%" "11d", $1)'} | tr -d '\n' && echo -n " ≐" && echo -n " | "
# Total redeemable sats in openchans
echo -n "  Total redeemable sats in open chans: "
lightning-cli listpeerchannels  | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.to_us_msat / 1000)' | jq -s 'add' | awk -F "." {'printf("%" "11d", $1)'} | tr -d '\n' && echo " ≐ |"
#
# top row 2
# total spendable (out) sats in open chans
echo -n "Total spendable (out) sats in open chans: "
lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.spendable_msat / 1000)' | jq -s 'add' | awk -F "." {'printf("%" "11d", $1)'} | tr -d '\n' && echo -n " ≐" && echo -n " | "
# Node's onchain Bitcoin balance
echo -n "Node's onchain Bitcoin balance (sats): " && lightning-cli listfunds | jq '.outputs | map(.amount_msat / 1000) | add' | awk {'printf("%" "11d", $1)'} | tr -d '\n' && echo " ≐ |"
#
# top row 3
# total receivable (in) sats in open chans
echo -n "Total receivable (in) sats in open chans: "

#PeerSwap
# Node's PeerSwap Liquid balance, and count of peers with PeerSwap support
if [ $PeerSwapEnabled = "yes" ];
then
   lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.receivable_msat / 1000)' | jq -s 'add' | awk -F "." {'printf("%" "11d", $1)'} | tr -d '\n' && echo -n " ≐" && echo -n " | "
   peerswapcount=$(lightning-cli peerswap-listpeers | jq '.[] | .nodeid' | wc -l)
   echo -n "Node's PeerSwap Liquid balance (sats): " && lightning-cli peerswap-lbtc-getbalance | jq '.[]' | awk {'printf("%" "11d", $1)'} | tr -d '\n' && echo -n " ≐ | " &&  echo " $peerswapcount peers support PeerSwap"
else
   lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.receivable_msat / 1000)' | jq -s 'add' | awk -F "." {'printf("%" "11d", $1)'} | tr -d '\n' && echo -n " ≐" && echo " | "
fi

# seperate top from middle section
#echo ""
echo "--------------------------------------------------------------------------------------------------------------------------------------------------"

# The middle part, showing peer channels, balances, channel states, connections statuses and more.
# The numbers are made in a range of an 11 character length space to account for all sats below 1000 bitcoins (999.99999999 btc). If you have more than 999 bitcoins on a lightning channel, you can easily modify this script to accommodate.
# The sub("...$"; "") function in jq is to truncate the last three chraacters from a string, to convert a number from msats to sats.
echo "                                                                       our balance      their balance"
lightning-cli getinfo | jq '"                               Peers:" + (.num_peers | tostring | (length | if . >=4 then "" else "*" * (4 - .) end) as $padding | "\($padding)\(.)") + "  |  Active channels:" + (.num_active_channels | tostring | (length | if . >=4 then "" else "*" * (4 - .) end) as $padding | "\($padding)\(.)") + " |   out (sats) <----> in (sats)    | redeemable  | short chan ID | chan status"'
echo "____________________________________________________________________|__________________________________|   (sats)"
# The 'sort' command is used to list the channels in a uniform and reproducible order by order of public key rather than label.
#
#Directory
# You can optionally assign labels in place of public keys by adding to the 'public key to label' directory in this script below. There are a few added for example purposes. Uncomment the #\ if adding a new line below it. It is recommended to pad the entries with .... to keep the output of ln-term uniform and lined up with the other output. I do not yet know of a suitable way to automatically populate the aliases from the nodes themselves, so this is primarily why it is done manually in this script. Adding the labels manually instead of pulling info from the node's provided alias field might also help with protection from malicious jq injections through the alias fields set by others.
echo "                                                                       ₿₿₿≐≐≐≐≐≐≐≐        ₿₿₿≐≐≐≐≐≐≐≐  |"
lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | .peer_id + " | " + "█" + (.spendable_msat | tostring | sub("...$"; "") | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)") + "█" + "<-⚡->" + "█" + (.receivable_msat | tostring | sub("...$"; "") | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)") + "█" + " | " + (.to_us_msat | tostring | sub("...$"; "") | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)") + " | " + .short_channel_id + " | " + .state + " " + (.peer_connected | tostring)'  | sort | sed -e 's/ true/ connected/g' | sed -e 's/ false/ DISCONNECTED/g' \
| sed \
-e 's/038e5677dc7d1ec4e9a82bd004d524b2469fedb0867e85bd1e2f5d3352957e03b7/..................................................nakoshi-satamoto/g' \
-e 's/020a128145c54dec1c1d72e9bf0ec26759d1e16b9a7bba1453e1fc2b4cec6a6fbd/..........................................donate.sparrowwallet.com/g' \
-e 's/026165850492521f4ac8abd9bd8088123446d126f648ca35e60f88177dc149ceb2/.............................................................Boltz/g' \
-e 's/02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69/.......................................................Kraken 🐙⚡/g' \
-e 's/03ceeaec6cb017d1ea8ad04a5dfb3facb24a28399d24624ecce8f319973de361d9/........................................................Lite Roast/g' \
-e 's/03e7d1b2db2f6909365a066a2b40d5ef3a66f1c4d70d8cac3337e09ff2fd2d408f/.......................................................routemaster/g' \
-e 's/020cb9b93492969c03d4dd24441e56b6a2c40361fc2033cdef43779dad72b43592/................................................RetiringOn.Bitcoin/g' #\
# ^ public key to label directory ^
#
echo "_______________________________________________________________________________________________________|"

#Keysend
# Outputting latest keysend messages.
if [ $KeySendEnabled = "yes" ];
then
   echo "--KEYSEND MESSAGES--------------------------------------------------------------------------------------------------------------------------------"
   lightning-cli listinvoices | jq '.[] | .[] | .description' | grep keysend: | tail -n $NumberOfKeySends
fi

#Log
# Outputting latest lines of the log file.
if [ $LogEnabled = "yes" ];
then
   echo "--LOG FILE OUTPUT---------------------------------------------------------------------------------------------------------------------------------"
   tail -n $NumberOfLogEntries $LogLocation
fi

# padding operation. This is the method used in jq to pad symbols or spaces in front of numbers to have number strings of varying length uniform in appearance.
# (.channels[].receivable_msat | tostring | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)")
#
# {'printf("%" "11d", $1)'} is another padding method used in this script for use outside of jq.
