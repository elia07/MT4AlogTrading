/*
 	SignalCrossover.mqh
 	For framework version 1.0
 	
   Copyright 2013-2020, Orchard Forex
   https://www.orchardforex.com
 
*/
 
#include	"../../Framework.mqh"

class CSignalColorCrossover : public CSignalBase {

private:

protected:	// member variables

	int				mIndex1;
	int				mIndex2;
	
public:	// constructors

	CSignalColorCrossover(string symbol, ENUM_TIMEFRAMES timeframe,
								int index1=1, int index2=2)
								:	CSignalBase(symbol, timeframe)
								{	Init(index1, index2);	}
	CSignalColorCrossover(int index1=1, int index2=2)
								:	CSignalBase()
								{	Init(index1, index2);	}
	~CSignalColorCrossover()	{	}
	
	int			Init(int index1, int index2);

public:

	virtual void								UpdateSignal();

};

int		CSignalColorCrossover::Init(int index1, int index2) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

	mIndex1			=	index1;
	mIndex2			=	index2;
			
	return(INIT_SUCCEEDED);
	
}

void		CSignalColorCrossover::UpdateSignal() {

	double	state1	=	GetIndicatorData(0, mIndex1);
	double	state2	=	GetIndicatorData(0, mIndex2);

	if ( (state1!=state2) && state1==0 ) {	//	Crossed up
		mEntrySignal	=	OFX_SIGNAL_BUY;
		mExitSignal		=	OFX_SIGNAL_SELL;
	} else
	if ( (state1!=state2) && state1==1 ) {	//	Crossed down
		mEntrySignal	=	OFX_SIGNAL_SELL;
		mExitSignal		=	OFX_SIGNAL_BUY;
	} else {
		mEntrySignal	=	OFX_SIGNAL_NONE;
		mExitSignal		=	OFX_SIGNAL_NONE;
	}

	return;
	
}

	
