#include <Timer.h>
#include "ToggledTransmit.h"


configuration ToggledTransmitAppC{
}
implementation{
	
	components MainC;
	components ToggledTransmitC as App;
	components ActiveMessageC;
	components new AMSenderC(AM_TOGGLEDTRANSMIT);
	
	components new TimerMilliC() as Timer0;
	components new TimerMilliC() as Timer1;
	
	
	App.Boot -> MainC;
	App.AMControl -> ActiveMessageC;
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	
	App.Timer0 -> Timer0;
	App.Timer1 -> Timer1;
	
	App.PacketAcknowledgements -> AMSenderC;
	
}
