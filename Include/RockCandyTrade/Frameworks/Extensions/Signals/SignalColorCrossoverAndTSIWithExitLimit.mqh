/*
 	SignalCrossover.mqh
 	For framework version 1.0
 
*/
 
#include	"../../Framework.mqh"

class CSignalColorCrossoverAndTSIWithExitLimit : public CSignalBase {

private:

protected:	// member variables

	int				mIndex1;
	int				mIndex2;
	double			mTsiUpperLimit;
	double			mTsiLowerLimit;
	double         mTsiUpperExitLimit;
	double         mTsiLowerExitLimit;
	double         mCrossThreshold;
	
public:	// constructors

	CSignalColorCrossoverAndTSIWithExitLimit(string symbol, ENUM_TIMEFRAMES timeframe,
								int index1=1, int index2=2,double tsiUpperLimit=30,double tsiLowerLimit=-30,double tsiUpperExitLimit=10,double tsiLowerExitLimit=-10,double crossThreshold=10)
								:	CSignalBase(symbol, timeframe)
								{	Init(index1, index2,tsiUpperLimit,tsiLowerLimit,tsiUpperExitLimit,tsiLowerExitLimit,crossThreshold);	}
	CSignalColorCrossoverAndTSIWithExitLimit(int index1=1, int index2=2,double tsiUpperLimit=30,double tsiLowerLimit=-30,double tsiUpperExitLimit=10,double tsiLowerExitLimit=-10,double crossThreshold=10)
								:	CSignalBase()
								{	Init(index1, index2,tsiUpperLimit,tsiLowerLimit,tsiUpperExitLimit,tsiLowerExitLimit,crossThreshold);	}
	~CSignalColorCrossoverAndTSIWithExitLimit()	{	}
	
	int			Init(int index1, int index2,double tsiUpperLimit,double tsiLowerLimit,double tsiUpperExitLimit,double tsiLowerExitLimit,double crossThreshold);

public:

	virtual void								UpdateSignal();

};

int		CSignalColorCrossoverAndTSIWithExitLimit::Init(int index1, int index2,double tsiUpperLimit,double tsiLowerLimit,double tsiUpperExitLimit,double tsiLowerExitLimit,double crossThreshold) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

	mIndex1			=	index1;
	mIndex2			=	index2;
	mTsiUpperLimit =  tsiUpperLimit;
	mTsiLowerLimit =  tsiLowerLimit;
	mTsiUpperExitLimit=tsiUpperLimit;
	mTsiLowerExitLimit=tsiLowerExitLimit;
	mCrossThreshold= crossThreshold;
			
	return(INIT_SUCCEEDED);
	
}

void		CSignalColorCrossoverAndTSIWithExitLimit::UpdateSignal() {

	double	fast1	=	GetIndicatorData(0, mIndex1);
	double	fast2	=	GetIndicatorData(0, mIndex2);
	double	fast1Help	=	GetIndicatorData(0, mIndex2);
	double	slow1	=	GetIndicatorData(1, mIndex1);
	double	slow2	=	GetIndicatorData(1, mIndex2);
   double   superTrendState =  GetIndicatorData(2, mIndex1);

//
//
   mEntrySignal	=	OFX_SIGNAL_NONE;
	mExitSignal		=	OFX_SIGNAL_NONE;

	if ( (fast1>slow1) && !(fast2>slow2) && superTrendState==0 && (slow1<=mTsiLowerLimit)) {	//	Crossed up
		mEntrySignal	=	OFX_SIGNAL_BUY;
	} else
	if ( (fast1<slow1) && !(fast2<slow2) && superTrendState==1 && (slow1>=mTsiUpperLimit)) {	//	Crossed down
		mEntrySignal	=	OFX_SIGNAL_SELL;
	} else {
		mEntrySignal	=	OFX_SIGNAL_NONE;
	}
	
	//Exit for TakeProfits
	if ( (fast1>slow1) && !(fast2>slow2) && MathAbs(fast1-slow1)>mCrossThreshold && (fast1<mTsiLowerExitLimit || fast2<mTsiLowerExitLimit)) {	//	Crossed up
		mExitSignal		=	OFX_SIGNAL_SELL;
	} else
	if ( (fast1<slow1) && !(fast2<slow2) && MathAbs(fast1-slow1)>mCrossThreshold && (fast1>mTsiUpperExitLimit || fast2>mTsiUpperExitLimit)) {	//	Crossed down
		mExitSignal		=	OFX_SIGNAL_BUY;
	} else {
		mExitSignal		=	OFX_SIGNAL_NONE;
	}
	
	//Exit for Stops
	if ( (fast1>slow1) && !(fast2>slow2) && MathAbs(fast1-slow1)>mCrossThreshold) {	//	Crossed up
		mExitSignal		=	OFX_SIGNAL_SELL;
	} else
	if ( (fast1<slow1) && !(fast2<slow2) && MathAbs(fast1-slow1)>mCrossThreshold) {	//	Crossed down
		mExitSignal		=	OFX_SIGNAL_BUY;
	} else {
		mExitSignal		=	OFX_SIGNAL_NONE;
	}
	
	return;
	
}

	
