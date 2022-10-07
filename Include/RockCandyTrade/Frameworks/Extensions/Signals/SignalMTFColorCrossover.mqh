/*
 	SignalCrossover.mqh
 	For framework version 1.0
 	
   Copyright 2013-2020, Orchard Forex
   https://www.orchardforex.com
 
*/
 
#include	"../../Framework.mqh"

class CSignalMTFColorCrossover : public CSignalBase {

private:

protected:	// member variables

	int				mIndex1;
	int				mIndex2;
	
public:	// constructors

	CSignalMTFColorCrossover(string symbol, ENUM_TIMEFRAMES timeframe,
								int index1=1, int index2=2)
								:	CSignalBase(symbol, timeframe)
								{	Init(index1, index2);	}
	CSignalMTFColorCrossover(int index1=1, int index2=2)
								:	CSignalBase()
								{	Init(index1, index2);	}
	~CSignalMTFColorCrossover()	{	}
	
	int			Init(int index1, int index2);

public:

	virtual void								UpdateSignal();

};

int		CSignalMTFColorCrossover::Init(int index1, int index2) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

	mIndex1			=	index1;
	mIndex2			=	index2;
			
	return(INIT_SUCCEEDED);
	
}

void		CSignalMTFColorCrossover::UpdateSignal() {

	double	state1	=	GetIndicatorData(0, mIndex1);
	double	state2	=	GetIndicatorData(0, mIndex2);
	double	h4State	=	GetIndicatorData(1, mIndex1);
	double	m30State1	=	GetIndicatorData(3, mIndex1);
   double	m30State2	=	GetIndicatorData(3, mIndex2);
   
   
	if ( (state1!=state2) && state1==0 && h4State==0) {	//	Crossed up
		mEntrySignal	=	OFX_SIGNAL_BUY;
	} else
	if ( (state1!=state2) && state1==1 && h4State==1) {	//	Crossed down
		mEntrySignal	=	OFX_SIGNAL_SELL;
	} else {
		mEntrySignal	=	OFX_SIGNAL_NONE;
		mExitSignal		=	OFX_SIGNAL_NONE;
	}
	
	/*if ( (state1!=state2) && state1==0) {	//	Crossed up
		mExitSignal		=	OFX_SIGNAL_SELL;
	} else
	if ( (state1!=state2) && state1==1) {	//	Crossed down
		mExitSignal		=	OFX_SIGNAL_BUY;
	} else {
		mEntrySignal	=	OFX_SIGNAL_NONE;
		mExitSignal		=	OFX_SIGNAL_NONE;
	}*/
	
	if ( (m30State1!=m30State2)) {	//	Crossed up
		mExitSignal		=	OFX_SIGNAL_BOTH;
	} 
	

	return;
	
}

	
