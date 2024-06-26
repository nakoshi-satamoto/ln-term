#!/bin/bash

# Name: LN-Term
# Author: The operator of the lightning node nakoshi-satamoto. 
# Contributers: https://github.com/Lagrang3/ (updated deprecated listpeers command to listpeerchannels)
# Version timestamp: Block 839506

# Description: This is intended for use with core lightning. Execute with command "./ln-term.sh" or "watch ./ln-term.sh" for realtime monitoring. This tool shows realtime information of a lightning router including channels, channel balances, and statuses. This was inspired by the core lightning summary.py plugin, but I wanted something that was not using python having no or minimal dependencies. Python apps are a horrendous dependency nightmare with a known high risk of software supply chain compromise. Simplicity is elegance.

# Dependencies: jq for parsing json.

# If lightning-cli is not in the same directory as this script, you can modify ./lightning-cli to the appropriate path, or just lightning-cli if it is recognized as a system wide command.

# Note to users: You can optionally customize this script. You can search for the relevant section for each feature by the # hashtag.
# #Banner - Choose your banner by commenting and uncommenting the banner of your choice. # Means it is commented out and ignored by the script.
# #Directory - Assigning aliases to your peers in the directory.
# #Log - Declaring the location of your log file if any is used. Otherwise you can uncomment that section.

# Warning: Use this at your own risk, I accept no responsibility for whatever happens as a result of using or relying on this script. This script needs to be security audited.

# To do list, and features to implement after testing
# 1. Audit security, specifically resilience from bash and jq injections. How well does jq sanitize input?
# 2. Show onchain balance
# 3. Have the peer alias directory stored in a separate file which is then loaded into ln-term. This would eliminate the need to re-import the directory into the script after each update. This would also make sharing of lightning router directories with others easy or even allow for the automated generating of a directory.

clear
date

#Banner
# you can comment or uncomment different banners to modify what is shown. Make sure the " is before and after what you want shown.
#
# Fancy Banner
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
#
# Compact Banner
#echo ""
#echo "=================="
#echo "-LIGHTNING NETWORK-"
#echo "=================="
#echo ""

# The top part showing sendable, recievable, and redeemable stats, fees earned.
./lightning-cli getinfo | jq '"network:" + (.network | tostring) + " | " + "blockheight:" + (.blockheight | tostring) + " | " + "alias:" + (.alias | tostring) + " | " + "id:" + .id'
echo "------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -n "Total redeemable sats in chans:           "
./lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.to_us_msat / 1000)' | jq -s 'add' | awk -F "." {'print $1'} | tr -d '\n' && echo -n " ≐" && echo -n " | "
./lightning-cli getinfo | grep fees | sed -e 's/   "fees_collected_msat":/ fees collected:/g' | tr -d ','  | tr -d '\n' && echo " msats"
echo -n "Total spendable (out) sats in open chans: "
./lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.spendable_msat / 1000)' | jq -s 'add' | awk -F "." {'print $1'} | tr -d '\n' && echo -n " ≐" && echo " | "
echo -n "Total receivable (in) sats in open chans: "
./lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | (.receivable_msat / 1000)' | jq -s 'add' | awk -F "." {'print $1'} | tr -d '\n' && echo -n " ≐" && echo " | "

# The middle part, showing peer channels, balances, channel states, connections statuses and more.
# The numbers are made in a range of 11 character space to account for all msats below 1 bitcoin.
# If you have 1 or more bitcoin (100,000,000,000 msat) in a channel, you can increase the number 11 from below to work with balances above 99,999,999,999 msats.
echo "                                                                       our balance      their balance"
./lightning-cli getinfo | jq '"                               Peers:" + (.num_peers | tostring | (length | if . >=4 then "" else "*" * (4 - .) end) as $padding | "\($padding)\(.)") + "  |  Active channels:" + (.num_active_channels | tostring | (length | if . >=4 then "" else "*" * (4 - .) end) as $padding | "\($padding)\(.)") + " |   out(msats) <----> in(msats)    | redeemable  | short chan ID | chan status"'
echo "____________________________________________________________________|__________________________________|  (msats)"
#
# The 'sort' command is used to list the channels in a uniform and reproducible order by order of public key rather than label.
#
#Directory
# You can optionally assign labels in place of public keys by adding to the 'public key to label' directory in this script below. There are a few added for example purposes. Uncomment the #\ if adding a new line below it. It is recommended to pad the entries with .... to keep the output of ln-term uniform and lined up with the other output. I do not yet know of a suitable way to automatically populate the aliases from the nodes themselves, so this is primarily why it is done manually in this script. Adding the labels manually instead of pulling info from the node's provided alias field might also help with protection from malicious jq injections through the alias fields set by others.
echo "                                                                      ₿≐≐≐≐≐≐≐≐mmm       ₿≐≐≐≐≐≐≐≐mmm  |"
./lightning-cli listpeerchannels | jq '.[] | .[] | select(last(.state_changes[].new_state) != "ONCHAIN") | .peer_id + " | " + "█" + (.spendable_msat | tostring | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)") + "█" + "<-⚡->" + "█" + (.receivable_msat | tostring | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)") + "█" + " | " + (.to_us_msat | tostring | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)") + " | " + .short_channel_id + " | " + .state + " " + (.peer_connected | tostring)'  | sort | sed -e 's/ true/ connected/g' | sed -e 's/ false/ ⚠DISCONNECTED⚠/g' \
| sed \
-e 's/038e5677dc7d1ec4e9a82bd004d524b2469fedb0867e85bd1e2f5d3352957e03b7/..................................................nakoshi-satamoto/g' \
-e 's/020a128145c54dec1c1d72e9bf0ec26759d1e16b9a7bba1453e1fc2b4cec6a6fbd/..........................................donate.sparrowwallet.com/g' \
-e 's/026165850492521f4ac8abd9bd8088123446d126f648ca35e60f88177dc149ceb2/.............................................................Boltz/g' \
-e 's/02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69/.......................................................Kraken 🐙⚡/g' \
-e 's/03ceeaec6cb017d1ea8ad04a5dfb3facb24a28399d24624ecce8f319973de361d9/........................................................Lite Roast/g' #\
# ^ public key to label directory ^
#
echo "_______________________________________________________________________________________________________|"

#Log
# Outputting last 5 lines of the log file. Update this with the filepath of your log file as declared in your config settings. You can also modify the number of lines shown by changing the number after 'tail -n'
# Alternatively, you can comment out this section to not include log output in the ln-term interface.
echo ""
#echo "--LOG FILE OUTPUT-------------------------------------------------------------------------------------------------------------------------------------"
echo "// LOG FILE OUTPUT ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////"
tail -n 5 ~/.lightning/ln-log.txt | fold -w 150

# padding operation. This is the method used in jq to pad symbols or spaces in front of numbers to have number strings of varying length uniform in appearence.
# (.channels[].receivable_msat | tostring | (length | if . >=11 then "" else "*" * (11 - .) end) as $padding | "\($padding)\(.)")
