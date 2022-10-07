/*
 	SignalCrossover.mqh
 	For framework version 1.0
 
*/
 
#include	"../../Framework.mqh"

class CSignal_RCS50001 : public CSignalBase {

private:

protected:	// member variables

	int				mIndex1;
	int				mIndex2;
	double			mTsiUpperLimit;
	double			mTsiLowerLimit;
	
public:	// constructors

	CSignal_RCS50001(string symbol, ENUM_TIMEFRAMES timeframe,
								int index1=1, int index2=2,double tsiUpperLimit=30,double tsiLowerLimit=-30)
								:	CSignalBase(symbol, timeframe)
								{	Init(index1, index2,tsiUpperLimit,tsiLowerLimit);	}
	CSignal_RCS50001(int index1=1, int index2=2,double tsiUpperLimit=30,double tsiLowerLimit=-30)
								:	CSignalBase()
								{	Init(index1, index2,tsiUpperLimit,tsiLowerLimit);}
	~CSignal_RCS50001()	{	}
	
	int			Init(int index1, int index2,double tsiUpperLimit,double tsiLowerLimit);

public:

	virtual void								UpdateSignal();

};

int		CSignal_RCS50001::Init(int index1, int index2,double tsiUpperLimit,double tsiLowerLimit) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

	mIndex1			=	index1;
	mIndex2			=	index2;
	mTsiUpperLimit =  tsiUpperLimit;
	mTsiLowerLimit =  tsiLowerLimit;
			
	return(INIT_SUCCEEDED);
	
}

void		CSignal_RCS50001::UpdateSignal() {

	double	fast1	=	GetIndicatorData(0, mIndex1);
	double	fast2	=	GetIndicatorData(0, mIndex2);
	
   mEntrySignal	=	OFX_SIGNAL_NONE;
  	mExitSignal		=	OFX_SIGNAL_NONE;
  	
  	if(fast2>=mTsiLowerLimit && fast1<=mTsiLowerLimit)
  	{
  	      mEntrySignal=OFX_SIGNAL_SELL;
  	}
  	else if(fast2<=mTsiUpperLimit && fast1>mTsiUpperLimit)
  	{
  	      mEntrySignal=OFX_SIGNAL_BUY;
  	}
	
	return;
	
}

	
