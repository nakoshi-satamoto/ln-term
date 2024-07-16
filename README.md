![ln-term](https://github.com/user-attachments/assets/ee7fda8a-1561-4cf2-91f8-0e2cb973f6a6)

Name: LN-Term

Author: The operator of the lightning node nakoshi-satamoto with public key 038e5677dc7d1ec4e9a82bd004d524b2469fedb0867e85bd1e2f5d3352957e03b7.

Description: This is intended for use with core lightning. Execute with command "./ln-term.sh" or "watch ./ln-term.sh" for realtime monitoring. This tool shows realtime information of a lightning router including channels, balances, and statuses. This was inspired by the core lightning summary.py plugin, but I wanted something that was not using python having no or minimal dependencies. Python apps are a horrendous dependency nightmare with a known high risk of software supply chain compromise. Simplicity is elegance.

Dependencies: jq for parsing json.

Version timestamp: Block 852379

Highlights for this version update: More compact view and a slightly changed appearance, switched to sats from msats, set the numbers of balances in the top part to be lined up with each other, works with channel balances up to 999 BTC. Display of onchain BTC and PeerSwap L-BTC balance.
