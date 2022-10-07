/*
 	SignalCrossover.mqh
 	For framework version 1.0
 
*/
 
#include	"../../Framework.mqh"

class CSignal_RCS40001 : public CSignalBase {

private:

protected:	// member variables

	int				mIndex1;
	int				mIndex2;
	double			mTsiUpperLimit;
	double			mTsiLowerLimit;
	
public:	// constructors

	CSignal_RCS40001(string symbol, ENUM_TIMEFRAMES timeframe,
								int index1=1, int index2=2,double tsiUpperLimit=30,double tsiLowerLimit=-30)
								:	CSignalBase(symbol, timeframe)
								{	Init(index1, index2,tsiUpperLimit,tsiLowerLimit);	}
	CSignal_RCS40001(int index1=1, int index2=2,double tsiUpperLimit=30,double tsiLowerLimit=-30)
								:	CSignalBase()
								{	Init(index1, index2,tsiUpperLimit,tsiLowerLimit);}
	~CSignal_RCS40001()	{	}
	
	int			Init(int index1, int index2,double tsiUpperLimit,double tsiLowerLimit);

public:

	virtual void								UpdateSignal();

};

int		CSignal_RCS40001::Init(int index1, int index2,double tsiUpperLimit,double tsiLowerLimit) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

	mIndex1			=	index1;
	mIndex2			=	index2;
	mTsiUpperLimit =  tsiUpperLimit;
	mTsiLowerLimit =  tsiLowerLimit;
			
	return(INIT_SUCCEEDED);
	
}

void		CSignal_RCS40001::UpdateSignal() {

	double	fast1	=	GetIndicatorData(0, mIndex1);
	double	fast2	=	GetIndicatorData(0, mIndex2);
	double	fast1Help	=	GetIndicatorData(0, mIndex2);
	double	slow1	=	GetIndicatorData(1, mIndex1);
	double	slow2	=	GetIndicatorData(1, mIndex2);
	double	HeikenAshiColor	=	GetIndicatorData(5, 1);
	double	HeikenAshiColor2	=	GetIndicatorData(5, 2);
	double	HeikenAshiColor3	=	GetIndicatorData(5, 3);
	double	HeikenAshiOpen	=	GetIndicatorData(5, 2);
	double	HeikenAshiClose	=	GetIndicatorData(5, 3);
	
	
	if(true)
	{
	   double a=0;
	}
	else
	{
	   double b=0;
	}
	
   mEntrySignal	=	OFX_SIGNAL_NONE;
  	mExitSignal		=	OFX_SIGNAL_NONE;

	if ((fast1>slow1) && !(fast2>slow2) && HeikenAshiColor==0 && (slow1<=mTsiLowerLimit || slow2<=mTsiLowerLimit)) {	//	Crossed up
		mEntrySignal	=	OFX_SIGNAL_BUY;
	} else
	if ((fast1<slow1) && !(fast2<slow2) && HeikenAshiColor==1 && (slow1>=mTsiUpperLimit || slow2>=mTsiUpperLimit)) {	//	Crossed down
		mEntrySignal	=	OFX_SIGNAL_SELL;
	} else {
		mEntrySignal	=	OFX_SIGNAL_NONE;
	}
	
	
	fast1	=	GetIndicatorData(3, mIndex1);
	fast2	=	GetIndicatorData(3, mIndex2);
	fast1Help	=	GetIndicatorData(3, mIndex2);
	slow1	=	GetIndicatorData(4, mIndex1);
	slow2	=	GetIndicatorData(4, mIndex2);
	
	if ( (fast1>slow1) && !(fast2>slow2) && (slow1<=mTsiLowerLimit || slow2<=mTsiLowerLimit)) {	//	Crossed up
		mExitSignal	=	OFX_SIGNAL_BUY;
	} else
	if ( (fast1<slow1) && !(fast2<slow2) && (slow1>=mTsiUpperLimit || slow2>=mTsiUpperLimit)) {	//	Crossed down
		mExitSignal	=	OFX_SIGNAL_SELL;
	} else {
		mExitSignal	=	OFX_SIGNAL_NONE;
	}
	
	
	return;
	
}

	
