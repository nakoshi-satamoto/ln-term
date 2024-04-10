
![ln-term-screenshot](https://github.com/nakoshi-satamoto/ln-term/assets/161100720/3869d9a3-57fd-4740-856f-b2e9f4edde56)

Name: LN-Term

Author: The operator of the lightning node nakoshi-satamoto

Description: This is intended for use with core lightning. Execute with command "./ln-term.sh" or "watch ./ln-term.sh" for realtime monitoring. This tool shows realtime information of a lightning router including channels, channel balances, and statuses. This was inspired by the core lightning summary.py plugin, but I wanted something that was not using python having no or minimal dependencies. Python apps are a horrendous dependency nightmare with a known high risk of software supply chain compromise. Simplicity is elegance.

Dependencies: jq for parsing json.
