#!/bin/bash

# Name: LN-Term
# Author: The operator of the lightning node nakoshi-satamoto. 
# Contributers: https://github.com/Lagrang3/ (update-after-deprecated-listpeers)
# Version timestamp: Block 838463

# Description: This is intended for use with core lightning. Execute with command "./ln-term.sh" or "watch ./ln-term.sh" for realtime monitoring. This tool shows realtime information of a lightning router including channels, channel balances, and statuses. This was inspired by the core lightning summary.py plugin, but I wanted something that was not using python having no or minimal dependencies. Python apps are a horrendous dependency nightmare with a known high risk of software supply chain compromise. Simplicity is elegance.

# Dependencies: jq for parsing json.

# Warning: Use this at your own risk, I accept no responsibility for whatever happens as a result of using or relying on this script. This script is in beta and still needs to be security audited.

# If you see the message "⚠INACCURATE_STATE⚠", read the section below "Note on inaccurate channel states"

#To do list, and features to implement after testing
#1. Have a way to show the latest channel with a peer instead of duplicate and out of date info. Eliminating the need to have an "INACCURATE_STATE" label in these scenarios.
#2. Audit security, specifically resilience from bash and jq injections. How well does jq sanitize input?
#3. Show onchain balance

clear
date

#Banner
#you can comment or uncomment different banners to modify what is shown. Make sure the " is before and after what you want shown.
echo -n "
██╗     ██╗ ██████╗ ██╗  ██╗████████╗███╗   ██╗██╗███╗   ██╗ ██████╗ 
██║     ██║██╔════╝ ██║  ██║╚══██╔══╝████╗  ██║██║████╗  ██║██╔════╝ 
██║     ██║██║  ███╗███████║   ██║   ██╔██╗ ██║██║██╔██╗ ██║██║  ███╗
██║     ██║██║   ██║██╔══██║   ██║   ██║╚██╗██║██║██║╚██╗██║██║   ██║
███████╗██║╚██████╔╝██║  ██║   ██║   ██║ ╚████║██║██║ ╚████║╚██████╔╝
╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
"
#███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗       
#████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝       
#██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝        
#██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗        
#██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗       
#╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝       
#"
#echo ""
#echo "=================="
#echo "-LIGHTNING NETWORK-"
#echo "=================="
#echo ""

./lightning-cli getinfo | jq '"alias:" + .alias + " | " + "ID:" + .id'
echo "--------------------------------------------------------------------------------------------------------------"
echo -n "Total redeemable sats in chans:           "
./lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.to_us_msat / 1000)' | jq -s 'add' | awk -F "." {'print $1'} | tr -d '\n' && echo -n " ≐" && echo " | If you see ⚠INACCURATE_STATE⚠ for any of the chans,"
echo -n "Total spendable (out) sats in open chans: "
./lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.spendable_msat / 1000)' | jq -s 'add' | awk -F "." {'print $1'} | tr -d '\n' && echo -n " ≐" && echo " | these totals should be considered inaccurate also."
echo -n "Total receivable (in) sats in open chans: "
./lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.receivable_msat / 1000)' | jq -s 'add' | awk -F "." {'print $1'} | tr -d '\n' && echo -n " ≐" && echo " | Read the documentation in this script for more info."
./lightning-cli getinfo | grep fees

#The numbers are made in a range of 11 character space to account for all msats below 1 bitcoin.
#If you have 1 or more bitcoin (100,000,000,000 msat) in a channel, you can increase the number 11 from below to work with balances above 99,999,999,999 msats.
echo "                                                                       our balance      their balance"
./lightning-cli getinfo | jq '"                               Peers:" + (.num_peers | tostring | (length | if . >=4 then "" else "*" * (4 - .) end) as $padding | "\($padding)\(.)") + "  |  Active channels:" + (.num_active_channels | tostring | (length | if . >=4 then "" else "*" * (4 - .) end) as $padding | "\($padding)\(.)") + " |   out(msats) <----> in(msats)    | redeemable  | short chan ID | chan status"'
echo "____________________________________________________________________|__________________________________|  (msats)"

#The 'sort' command at the end is to list the channels in a uniform and reproducible order by order of public key.
#
#You can optionally assign labels in place of public keys by adding to the 'public key to label' directory in this script below. There are a few added for example purposes. Uncomment the #\ if adding a new line below it. It is recommended to pad the entries with .... to keep the output of ln-term uniform and lined up with the other output. I do not yet know of a suitable way to automatically populate the aliases from the nodes themselves, so this is primarily why it is done manually in this script. Adding the labels manually instead of pulling info from the node's provided alias field might also help with protection from malicious jq injections through the alias fields set by others.
#
#Note on inaccurate channel states
#The 'awk' and 'seen' command is to eliminate duplicates which would occur in certain cases. If you have recently closed a chan with a peer, core lightning remembers that chan for around half a day, 100 blocks or more. If you close a chan with a peer then re-open a new chan to that same peer during this time, jq sees duplicate conflicting states. So instead of showing the duplicate entries and incorrect information this script shows "⚠INACCURATE_STATE⚠". The inaccurate state should go away once Core Lightning forgets the old channel. You can use the command "lightning-cli listpeers" to see how many more blocks until Core Lightning forgets the old channel.
echo "                                                                      ₿≐≐≐≐≐≐≐≐mmm       ₿≐≐≐≐≐≐≐≐mmm  |"
./lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | .peer_id + " | " + "█" + (.spendable_msat | tostring | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)") + "█" + "<-⚡->" + "█" + (.receivable_msat | tostring | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)") + "█" + " | " + (.to_us_msat | tostring | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)") + " | " + .short_channel_id + " | " + .state + " " + (.peer_connected | tostring)'  | awk -F " | " '!seen[$1]++' | sed -e 's/ONCHAIN/⚠INACCURATE_STATE⚠/g' | sort | sed -e 's/ true/ connected/g' | sed -e 's/ false/ ⚠DISCONNECTED⚠/g' \
| sed \
-e 's/038e5677dc7d1ec4e9a82bd004d524b2469fedb0867e85bd1e2f5d3352957e03b7/..................................................nakoshi-satamoto/g' \
-e 's/020a128145c54dec1c1d72e9bf0ec26759d1e16b9a7bba1453e1fc2b4cec6a6fbd/..........................................donate.sparrowwallet.com/g' \
-e 's/026165850492521f4ac8abd9bd8088123446d126f648ca35e60f88177dc149ceb2/.............................................................Boltz/g' \
-e 's/02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69/.......................................................Kraken 🐙⚡/g' \
-e 's/03ceeaec6cb017d1ea8ad04a5dfb3facb24a28399d24624ecce8f319973de361d9/........................................................Lite Roast/g' #\
# ^ public key to label directory ^

echo "_______________________________________________________________________________________________________|"

#padding operation. This is the method used in jq to pad symbols or spaces in front of numbers to have number strings of varying length uniform in appearence.
#(.channels[].receivable_msat | tostring | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)")

