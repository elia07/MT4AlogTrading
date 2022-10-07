
#include	"../../Framework.mqh"

class CTPSLSuperTrendHeikenAshi : public CTPSLBase {

private:

	double	GetValue();

protected:	// member variables

   int		mIndex;
	double	   RRRatio;
   double	GetTakeProfitByRR();

public:	// constructors

	CTPSLSuperTrendHeikenAshi(double rrRatio)			:	CTPSLBase()
	                        {	Init(rrRatio);	}
	CTPSLSuperTrendHeikenAshi(string symbol, ENUM_TIMEFRAMES timeframe,
	                          double rrRatio)
								:	CTPSLBase(symbol, timeframe)	{	Init(rrRatio);	}
	~CTPSLSuperTrendHeikenAshi()														{	}
	
	int			Init(double rrRatio);

public:

	virtual void	SetIndex(int index)					{	mIndex	=	index;	}
	virtual double	GetIndex()								{	return(mIndex);			}

	virtual double	GetTakeProfit()						{	return(GetTakeProfitByRR());			}
	virtual double	GetStopLoss()							{	return(GetValue());			}
	

};

int		CTPSLSuperTrendHeikenAshi::Init(double rrRatio) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());
	mIndex=1;
	RRRatio=rrRatio;
	return(INIT_SUCCEEDED);
	
}

double	CTPSLSuperTrendHeikenAshi::GetValue() {

   double	value	=	GetIndicatorData(0, mIndex);
   MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(Symbol(),PERIOD_CURRENT,0,10,rates);
   double retValue=MathAbs((rates[0].open-value))+0.0010;
   
	
	return(retValue);
	
}

double CTPSLSuperTrendHeikenAshi::GetTakeProfitByRR()
{
   /*MqlRates rates[];
   ArraySetAsSeries(rates,true);
   int copied=CopyRates(Symbol(),PERIOD_CURRENT,3,10,rates);
   double sl=GetValue();
   double value=MathAbs((rates[0].open-sl)*RRRatio);*/
   double sl=GetValue();
   double value=sl*RRRatio;
   
    return value;
}

	
