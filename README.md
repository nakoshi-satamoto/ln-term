![ln-term](https://github.com/user-attachments/assets/79c70ec9-47c0-4029-8d70-f56caee46418)


Name: LN-Term

Author: The operator of the lightning node nakoshi-satamoto with public key 038e5677dc7d1ec4e9a82bd004d524b2469fedb0867e85bd1e2f5d3352957e03b7.

Description: This is intended for use with core lightning. Execute with command "./ln-term.sh" or "watch ./ln-term.sh" for realtime monitoring. This tool shows realtime information of a lightning router including channels, channel statuses and balances, peers, and more. This was inspired by the core lightning summary.py plugin, but I wanted something that was not using python and having no or minimal dependencies. Python apps are a horrendous dependency nightmare with a known high risk of software supply chain compromise. Simplicity is elegance. This is just bash script using fancy jq magic. Most of the content is documentation, the actual code is around 70 lines. Because it is a bash script it is also transparent in what it does, and very easily modifiable, works on just about any real operating system (don't use windoze).

Note on using Core Lightning: Core Lightning is broken after version 23 because version 24 does not support payments which is kind of the point of the lightning network. Stick with Core Lightning version 23 until Core Lightning in later versions is fixed again or if Core Lightning is forked. I intend to fork Core Lightning from version 23 as the base of a new functional lightning network implementation, until Core Lightning is fixed. Core Lightning before version 24 is actually great.

Dependencies: jq for parsing json.

Version timestamp: Block 858746

Highlights for this version update: 
* Toggleable options using a built in config including for enabling and disabling PeerSwap support. Refer to section # Options in the top part of the script
* Added the display of keysend messages

