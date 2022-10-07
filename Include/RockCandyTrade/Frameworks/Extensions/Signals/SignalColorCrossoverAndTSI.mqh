/*
 	SignalCrossover.mqh
 	For framework version 1.0
 
*/
 
#include	"../../Framework.mqh"

class CSignalColorCrossoverAndTSI : public CSignalBase {

private:

protected:	// member variables

	int				mIndex1;
	int				mIndex2;
	double			mTsiUpperLimit;
	double			mTsiLowerLimit;
	
public:	// constructors

	CSignalColorCrossoverAndTSI(string symbol, ENUM_TIMEFRAMES timeframe,
								int index1=1, int index2=2,double tsiUpperLimit=30,double tsiLowerLimit=-30)
								:	CSignalBase(symbol, timeframe)
								{	Init(index1, index2,tsiUpperLimit,tsiLowerLimit);	}
	CSignalColorCrossoverAndTSI(int index1=1, int index2=2,double tsiUpperLimit=30,double tsiLowerLimit=-30)
								:	CSignalBase()
								{	Init(index1, index2,tsiUpperLimit,tsiLowerLimit);	}
	~CSignalColorCrossoverAndTSI()	{	}
	
	int			Init(int index1, int index2,double tsiUpperLimit,double tsiLowerLimit);

public:

	virtual void								UpdateSignal();

};

int		CSignalColorCrossoverAndTSI::Init(int index1, int index2,double tsiUpperLimit,double tsiLowerLimit) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

	mIndex1			=	index1;
	mIndex2			=	index2;
	mTsiUpperLimit =  tsiUpperLimit;
	mTsiLowerLimit =  tsiLowerLimit;
			
	return(INIT_SUCCEEDED);
	
}

void		CSignalColorCrossoverAndTSI::UpdateSignal() {

	double	fast1	=	GetIndicatorData(0, mIndex1);
	double	fast2	=	GetIndicatorData(0, mIndex2);
	double	fast1Help	=	GetIndicatorData(0, mIndex2);
	double	slow1	=	GetIndicatorData(1, mIndex1);
	double	slow2	=	GetIndicatorData(1, mIndex2);
   double   superTrendState =  GetIndicatorData(2, mIndex1);
   double	state1	=	GetIndicatorData(2, mIndex1);
	double	state2	=	GetIndicatorData(2, mIndex2);
//
//
   mEntrySignal	=	OFX_SIGNAL_NONE;
	mExitSignal		=	OFX_SIGNAL_NONE;

	if ( (fast1>slow1) && !(fast2>slow2) && superTrendState==0 && (fast1<=mTsiLowerLimit || fast1Help<=mTsiLowerLimit)) {	//	Crossed up
		mEntrySignal	=	OFX_SIGNAL_BUY;
	} else
	if ( (fast1<slow1) && !(fast2<slow2) && superTrendState==1 && (fast1>=mTsiUpperLimit || fast1Help>=mTsiUpperLimit)) {	//	Crossed down
		mEntrySignal	=	OFX_SIGNAL_SELL;
	} else {
		mEntrySignal	=	OFX_SIGNAL_NONE;
	}
	
	//Exit for TakeProfits
	if ( (fast1>slow1) && !(fast2>slow2)) {	//	Crossed up
		mExitSignal		=	OFX_SIGNAL_SELL;
	} else
	if ( (fast1<slow1) && !(fast2<slow2)) {	//	Crossed down
		mExitSignal		=	OFX_SIGNAL_BUY;
	} else {
		mExitSignal		=	OFX_SIGNAL_NONE;
	}
	
	
	//ExitForStopLosss
	/*if ( (state1!=state2) && state1==0 ) {	
		mExitSignal		=	OFX_SIGNAL_SELL;
	} else
	if ( (state1!=state2) && state1==1 ) {	
		mExitSignal		=	OFX_SIGNAL_BUY;
	} */
	
	return;
	
}

	
