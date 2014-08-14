#include <Timer.h>
#include "ToggledTransmit.h"


module ToggledTransmitC{
	
	uses interface Boot;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	
	uses interface Timer<TMilli> as Timer0;
	uses interface Timer<TMilli> as Timer1;
	
	uses interface PacketAcknowledgements;
	
}
implementation{
	
	uint16_t counter;
	uint16_t new_counter;
	
	message_t pkt;
	bool busy = FALSE;
	
	uint8_t node1 = 0x03;
	uint8_t node2 = 0x04;
	uint8_t node3 = 0x99;
	
	
	event void Boot.booted()
	{
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err)
	{
		if(err == SUCCESS)
		{
			call Timer1.startPeriodic(TIMER_PERIOD_MILLI_NEW);
			
			call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
		}
		
		else 
		{
			call AMControl.start();
		}
	}
	
	event void AMControl.stopDone(error_t err)
	{}
	
	event void Timer1.fired()
	{
		node3 = node2;
		node2 = node1;
		node1 = node3;
	}
	
	event void Timer0.fired()
	{
		counter ++;
		
		if (!busy)
		{
			ToggledTransmitMsg* ttpkt = (ToggledTransmitMsg*)(call Packet.getPayload(&pkt, sizeof(ToggledTransmitMsg)));
			
			if (ttpkt == NULL)
			{
				return;
			}
			
			ttpkt->nodeid = TOS_NODE_ID;
			ttpkt->counter = counter;
			
			if (ttpkt->counter % 0x02 == 0)
			{
				call PacketAcknowledgements.requestAck(&pkt);
				if (call AMSend.send(node1, &pkt, sizeof(ToggledTransmitMsg)) == SUCCESS)
				{
					busy = TRUE;
				}
			}
			
			else 
			{
				call PacketAcknowledgements.requestAck(&pkt);
				if (call AMSend.send(node2, &pkt, sizeof(ToggledTransmitMsg)) == SUCCESS)
				{
					busy = TRUE;
				}
			}
		}
	}
	
	event void AMSend.sendDone(message_t* msg, error_t err)
	{
		if (&pkt == msg)
		{
			busy = FALSE;
			dbg("TogggleTransmitC", "Message was sent @ %s, \n", sim_time_string());
		}
		
		if (call PacketAcknowledgements.wasAcked(msg))
		{
			call AMControl.start();
		}
	}	
	
}
