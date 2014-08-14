ToggledTransmit
===============
This application periodically toggles between sending even and odd binary digits to two nodes.

Using three nodes can effectively demonstrate the application. This application, being the transmitting part may be installed on only one mote while the receiving applications (ToggledReceive or ToggledSniffer) may be installed on the other two receiving nodes. The receiving nodes are to be named node 3 and node 4. The count will be sent to the receivng nodes and nothing is displayed on the leds of the transmitting node.

The expected result is the leds of a receiving node in the range of the transmitting node would be the periodicallly toggled display of odd and even binary numbers in the receving node.

