#ifndef TOGGLED_TRANSMIT_H
#define TOGGLED_TRANSMIT_H


enum
{
	AM_TOGGLEDTRANSMIT = 6,
	TIMER_PERIOD_MILLI = 250,
	TIMER_PERIOD_MILLI_NEW = 5240
};

typedef nx_struct ToggledTransmitMsg
{
	nx_uint16_t nodeid;
	nx_uint16_t counter;
} ToggledTransmitMsg;


#endif /* TOGGLED_TRANSMIT_H */
