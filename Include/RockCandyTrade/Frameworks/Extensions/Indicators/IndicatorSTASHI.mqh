/*
 	IndicatorSTASHI.mqh
 	Updated as of framework version 2.02
 	
   Copyright 2013-2020, RockCandyTrade
   https://www.RockCandyTrade.com
 
*/

// Next line assumes this file is located in .../Frameworks/Extensions/someFolder 
#include	"../../Framework.mqh"

class CIndicatorSTASHI : public CIndicatorBase {

private:

protected:	// member variables

   int						mPeriod;
   double					mMultiplier;
   bool						mFill;

public:	// constructors

	//	Add any required constructor arguments
	//	e.g. CIndicatorXYZ(int periods, double multiplier)
	CIndicatorSTASHI(int period,double multiplier,bool fill)
								:	CIndicatorBase()
								{	Init(period,multiplier,fill);	}
	// Same constructor with symbol and timeframe added
	CIndicatorSTASHI(string symbol, ENUM_TIMEFRAMES timeframe,
	                  int period,double multiplier,bool fill)
								:	CIndicatorBase(symbol, timeframe)
								{	Init(period,multiplier,fill);	}
	~CIndicatorSTASHI();

	//	Include all arguments to match the constructor
	virtual int			Init(int period,double multiplier,bool fill);

public:

	//	Add this line to override the same function from the parent class
   virtual double GetData(const int buffer_num,const int index);

};

CIndicatorSTASHI::~CIndicatorSTASHI() {

	//	Any destructors here
	
}

int		CIndicatorSTASHI::Init(int period,double multiplier,bool fill) {

	//	Checks if init has been set to fail by any parent class already
	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

	mPeriod=period;
   mMultiplier=multiplier;
   mFill=fill;

#ifdef __MQL5__
 	mIndicatorHandle			=	iCustom(mSymbol, mTimeframe,"/Indicators/Examples/supertrendHeikenAshi.ex5", mPeriod, mMultiplier, mFill);
	if (mIndicatorHandle==INVALID_HANDLE) return(InitError("Failed to create indicator handle", INIT_FAILED));
#endif

	return(INIT_SUCCEEDED);
	
}

double	CIndicatorSTASHI::GetData(const int buffer_num,const int index) {

	double	value	=	0;
#ifdef __MQL4__
	//Do for MQL4
#endif

#ifdef __MQL5__
	//	For MQL5 once indicator handle is set the code here should be common
	//	Declare a buffer to hold the data being retrieved
	double	bufferData[];
	//	Set as series so the sequence matches the chrt
	ArraySetAsSeries(bufferData, true);
	//	Copy indicator data into the buffer and get the count of elements
	int cnt	=	CopyBuffer(mIndicatorHandle, buffer_num, index, 1, bufferData);
	//	If not enough elements came back then don't use the data
	if (cnt>0) value	=	bufferData[0];
#endif

	return(value);
	
}


