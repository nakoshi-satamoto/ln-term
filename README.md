![ln-term](https://github.com/user-attachments/assets/79c70ec9-47c0-4029-8d70-f56caee46418)


Name: LN-Term

Author: The operator of the lightning node nakoshi-satamoto with public key 038e5677dc7d1ec4e9a82bd004d524b2469fedb0867e85bd1e2f5d3352957e03b7.

Description: This is intended for use with core lightning. Execute with command "./ln-term.sh" or "watch ./ln-term.sh" for realtime monitoring. This tool shows realtime information of a lightning router including channels, channel statuses and balances, peers, and more. This was inspired by the core lightning summary.py plugin, but I wanted something that was not using python and having no or minimal dependencies. Python apps are a horrendous dependency nightmare with a known high risk of software supply chain compromise. Simplicity is elegance. This is just bash script using fancy jq magic. Most of the content is documentation, the actual code is around 70 lines. Because it is a bash script it is also transparent in what it does, and very easily modifiable, works on just about any real operating system (don't use windoze).

 ̶N̶o̶t̶e̶ ̶o̶n̶ ̶u̶s̶i̶n̶g̶ ̶C̶o̶r̶e̶ ̶L̶i̶g̶h̶t̶n̶i̶n̶g̶:̶ ̶C̶o̶r̶e̶ ̶L̶i̶g̶h̶t̶n̶i̶n̶g̶ ̶i̶s̶ ̶b̶r̶o̶k̶e̶n̶ ̶a̶f̶t̶e̶r̶ ̶v̶e̶r̶s̶i̶o̶n̶ ̶2̶3̶ ̶b̶e̶c̶a̶u̶s̶e̶ ̶v̶e̶r̶s̶i̶o̶n̶ ̶2̶4̶ ̶d̶o̶e̶s̶ ̶n̶o̶t̶ ̶s̶u̶p̶p̶o̶r̶t̶ ̶p̶a̶y̶m̶e̶n̶t̶s̶ ̶w̶h̶i̶c̶h̶ ̶i̶s̶ ̶k̶i̶n̶d̶ ̶o̶f̶ ̶t̶h̶e̶ ̶p̶o̶i̶n̶t̶ ̶o̶f̶ ̶t̶h̶e̶ ̶l̶i̶g̶h̶t̶n̶i̶n̶g̶ ̶n̶e̶t̶w̶o̶r̶k̶.̶ ̶S̶t̶i̶c̶k̶ ̶w̶i̶t̶h̶ ̶C̶o̶r̶e̶ ̶L̶i̶g̶h̶t̶n̶i̶n̶g̶ ̶v̶e̶r̶s̶i̶o̶n̶ ̶2̶3̶ ̶u̶n̶t̶i̶l̶ ̶C̶o̶r̶e̶ ̶L̶i̶g̶h̶t̶n̶i̶n̶g̶ ̶i̶n̶ ̶l̶a̶t̶e̶r̶ ̶v̶e̶r̶s̶i̶o̶n̶s̶ ̶i̶s̶ ̶f̶i̶x̶e̶d̶ ̶a̶g̶a̶i̶n̶ ̶o̶r̶ ̶i̶f̶ ̶C̶o̶r̶e̶ ̶L̶i̶g̶h̶t̶n̶i̶n̶g̶ ̶i̶s̶ ̶f̶o̶r̶k̶e̶d̶.̶ ̶I̶ ̶i̶n̶t̶e̶n̶d̶ ̶t̶o̶ ̶f̶o̶r̶k̶ ̶C̶o̶r̶e̶ ̶L̶i̶g̶h̶t̶n̶i̶n̶g̶ ̶f̶r̶o̶m̶ ̶v̶e̶r̶s̶i̶o̶n̶ ̶2̶3̶ ̶a̶s̶ ̶t̶h̶e̶ ̶b̶a̶s̶e̶ ̶o̶f̶ ̶a̶ ̶n̶e̶w̶ ̶f̶u̶n̶c̶t̶i̶o̶n̶a̶l̶ ̶l̶i̶g̶h̶t̶n̶i̶n̶g̶ ̶n̶e̶t̶w̶o̶r̶k̶ ̶i̶m̶p̶l̶e̶m̶e̶n̶t̶a̶t̶i̶o̶n̶,̶ ̶u̶n̶t̶i̶l̶ ̶C̶o̶r̶e̶ ̶L̶i̶g̶h̶t̶n̶i̶n̶g̶ ̶i̶s̶ ̶f̶i̶x̶e̶d̶.̶ ̶C̶o̶r̶e̶ ̶L̶i̶g̶h̶t̶n̶i̶n̶g̶ ̶b̶e̶f̶o̶r̶e̶ ̶v̶e̶r̶s̶i̶o̶n̶ ̶2̶4̶ ̶i̶s̶ ̶a̶c̶t̶u̶a̶l̶l̶y̶ ̶g̶r̶e̶a̶t̶.̶
Core Lightning appears to have fixed this issue! https://github.com/ElementsProject/lightning/issues/7180


Dependencies: jq for parsing json.

Version timestamp: Block 858746

Highlights for this version update: 
* Toggleable options using a built in config including for enabling and disabling PeerSwap support. Refer to section # Options in the top part of the script
* Added the display of keysend messages

