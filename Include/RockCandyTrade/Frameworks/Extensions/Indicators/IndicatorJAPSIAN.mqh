/*
 	IndicatorJAPSIAN.mqh
 	Updated as of framework version 2.02
 	
   Copyright 2013-2020, RockCandyTrade
   https://www.RockCandyTrade.com
 
*/

// Next line assumes this file is located in .../Frameworks/Extensions/someFolder 
#include	"../../Framework.mqh"

class CIndicatorJapsian : public CIndicatorBase {

private:

protected:	// member variables

   int						mTenkanSen;
   int						mKijunSen;
   int						mSenkou;
   int						mKijunExt1;
   int						mKijunExt2;

public:	// constructors

	//	Add any required constructor arguments
	//	e.g. CIndicatorXYZ(int periods, double multiplier)
	CIndicatorJapsian(int tenkanSen,int kijunSen,int senkou,int kijunExt1,int kijunExt2)
								:	CIndicatorBase()
								{	Init(tenkanSen,kijunSen,senkou,kijunExt1,kijunExt2);	}
	// Same constructor with symbol and timeframe added
	CIndicatorJapsian(string symbol, ENUM_TIMEFRAMES timeframe,
	                  int tenkanSen,int kijunSen,int senkou,int kijunExt1,int kijunExt2)
								:	CIndicatorBase(symbol, timeframe)
								{	Init(tenkanSen,kijunSen,senkou,kijunExt1,kijunExt2);	}
	~CIndicatorJapsian();

	//	Include all arguments to match the constructor
	virtual int			Init(int tenkanSen,int kijunSen,int senkou,int kijunExt1,int kijunExt2);

public:

	//	Add this line to override the same function from the parent class
   virtual double GetData(const int buffer_num,const int index);

};

CIndicatorJapsian::~CIndicatorJapsian() {

	//	Any destructors here
	
}

int		CIndicatorJapsian::Init(int tenkanSen,int kijunSen,int senkou,int kijunExt1,int kijunExt2) {

	//	Checks if init has been set to fail by any parent class already
	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

	mTenkanSen=tenkanSen;
   mKijunSen=kijunSen;
   mSenkou=senkou;
   mKijunExt1=kijunExt1;
   mKijunExt2=kijunExt2;

#ifdef __MQL5__
 	mIndicatorHandle			=	iCustom(mSymbol, mTimeframe,"/Indicators/Examples/Japsian.ex5", mTenkanSen, mKijunSen, mSenkou, mKijunExt1,mKijunExt2);
	if (mIndicatorHandle==INVALID_HANDLE) return(InitError("Failed to create indicator handle", INIT_FAILED));
#endif

	return(INIT_SUCCEEDED);
	
}

double	CIndicatorJapsian::GetData(const int buffer_num,const int index) {

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


