/*
 	IndicatorMA.mqh
 	Updated - requires version 2.01 or later
 	
   Copyright 2013-2020, Orchard Forex
   https://www.orchardforex.com
 
*/
 
#include	"../../Framework.mqh"

class CIndicatorHEIKENASHI : public CIndicatorBase {

private:

protected:	// member variables

public:	// constructors

	CIndicatorHEIKENASHI()
								:	CIndicatorBase()
								{	Init();	}
	CIndicatorHEIKENASHI(string symbol, ENUM_TIMEFRAMES timeframe)
								:	CIndicatorBase(symbol, timeframe)
								{	Init();	}
	~CIndicatorHEIKENASHI();
	
	virtual int			Init();

public:

   virtual double GetData(const int buffer_num,const int index);

};

CIndicatorHEIKENASHI::~CIndicatorHEIKENASHI() {

}

int		CIndicatorHEIKENASHI::Init() {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());

#ifdef __MQL5__
	mIndicatorHandle			=	iCustom(_Symbol, _Period,"/Indicators/Examples/Heiken_Ashi.ex5");
	if (mIndicatorHandle==INVALID_HANDLE)	return(InitError("Failed to create indicator handle", INIT_FAILED));
#endif

	return(INIT_SUCCEEDED);
	
}

double	CIndicatorHEIKENASHI::GetData(const int buffer_num,const int index) {

	double	value	=	0;
#ifdef __MQL4__
	
#endif

#ifdef __MQL5__
	double	bufferData[];
	ArraySetAsSeries(bufferData, true);
	int cnt	=	CopyBuffer(mIndicatorHandle, buffer_num, index, 1, bufferData);
	if (cnt>0) value	=	bufferData[0];
#endif

	return(value);
	
}


