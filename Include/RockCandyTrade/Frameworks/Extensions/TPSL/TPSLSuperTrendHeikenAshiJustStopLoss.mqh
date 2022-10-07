
#include	"../../Framework.mqh"

class CTPSLSuperTrendHeikenAshiJustStopLoss : public CTPSLBase {
      
private:

	double	GetValue();

protected:	// member variables

   int		mIndex;

public:	// constructors

	CTPSLSuperTrendHeikenAshiJustStopLoss()			:	CTPSLBase()
	                        {	Init();	}
	CTPSLSuperTrendHeikenAshiJustStopLoss(string symbol, ENUM_TIMEFRAMES timeframe)
								:	CTPSLBase(symbol, timeframe)	{	Init();	}
	~CTPSLSuperTrendHeikenAshiJustStopLoss()														{	}
	
	int			Init();

public:

	virtual void	SetIndex(int index)					{	mIndex	=	index;	}
	virtual double	GetIndex()								{	return(mIndex);			}

	virtual double	GetTakeProfit()						{	return(0);			}
	virtual double	GetStopLoss()							{	return(GetValue());			}
	

};

int		CTPSLSuperTrendHeikenAshiJustStopLoss::Init() {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());
	mIndex=1;
	return(INIT_SUCCEEDED);
	
}

double	CTPSLSuperTrendHeikenAshiJustStopLoss::GetValue() {

   double	value	=	GetIndicatorData(0, mIndex);
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(Symbol(),PERIOD_CURRENT,0,10,rates);
   double retValue=MathAbs((rates[0].open-value));
   
	
	return(retValue);
	
}


	
