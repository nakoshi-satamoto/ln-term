![ln-term](https://github.com/nakoshi-satamoto/ln-term/assets/161100720/8e40893b-fb84-4b01-9b07-edef3f31c33a)

# Name: LN-Term
# Author: The operator of the lightning node nakoshi-satamoto
# Version timestamp: Block 831774

# Description: This is intended for use with core lightning. Execute with command "./ln-term.sh" or "watch ./ln-term.sh" for realtime monitoring. This tool shows realtime information of a lightning router including channels, channel balances, and statuses. This was inspired by the core lightning summary.py plugin, but I wanted something that was not using python having no or minimal dependencies. Python is a horrendous dependency nightmare with a known high risk of software supply chain compromise. Simplicity is elegance.

Dependencies: jq for parsing json.

Warning: Use this at your own risk, I accept no responsibility for whatever happens as a result of using or relying on this script. This also needs to be vetted for security from code injection. I have extensively tested this script, but I would consider it beta. There is also a known issue that needs solved eventually, read the section "Note on inaccurate channel states". Although this is not yet perfect, I am releasing this now because it may be very useful to other lightning operators and I cannot let perfection be the enemy of great. But I can also use help from others with perfecting this script.

To do list, and features to implement after testing:
1. Have a way to show the latest channel with a peer instead of duplicate and out of date info. Eliminating the need to have an "INACCURATE_STATE" label in these scenarios. Filter out recently closed channels from jq results.
2. Audit security, specifically resilience from bash and jq injections.
