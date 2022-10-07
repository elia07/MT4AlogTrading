/*
 	IndicatorMA.mqh
 	Updated - requires version 2.01 or later
 	
   Copyright 2013-2020, Orchard Forex
   https://www.orchardforex.com
 
*/
 
#include	"../../Framework.mqh"

class CIndicatorTSI : public CIndicatorBase {

private:

protected:	// member variables

	int						mR;
	int						mS;
	int			         mSP;

public:	// constructors

	CIndicatorTSI(int r, int s, int sp)
								:	CIndicatorBase()
								{	Init(r, s, sp);	}
	CIndicatorTSI(string symbol, ENUM_TIMEFRAMES timeframe,
						int r, int s, int sp)
								:	CIndicatorBase(symbol, timeframe)
								{	Init(r, s, sp);	}
	~CIndicatorTSI();
	
	virtual int			Init(int r, int s, int sp);

public:

   virtual double GetData(const int buffer_num,const int index);

};

CIndicatorTSI::~CIndicatorTSI() {

}

int		CIndicatorTSI::Init(int r, int s, int sp) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());
	
	mR			=	r;
	mS			=	s;
	mSP			=	sp;

#ifdef __MQL5__
	mIndicatorHandle			=	iCustom(mSymbol, mTimeframe,"/Indicators/Examples/tsi-indicator.ex5", r, s, sp);
	if (mIndicatorHandle==INVALID_HANDLE)	return(InitError("Failed to create indicator handle", INIT_FAILED));
#endif

	return(INIT_SUCCEEDED);
	
}

double	CIndicatorTSI::GetData(const int buffer_num,const int index) {

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


