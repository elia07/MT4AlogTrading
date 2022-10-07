//+------------------------------------------------------------------+
//|                                                 StartegyBase.mqh |
//|                                                   RockCandyTrade |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "RockCandyTrade"
#property link      "https://www.mql5.com"

#include	"CommonBase.mqh"

Class CClassTemplate : Public CCommonBase{
private:

protected:	// member variables
	
public:	// constructors

   CClassTemplate()															:	CCommonBase()
																				{	Init();	}
	CClassTemplate(string symbol, ENUM_TIMEFRAMES timeframe)		:	CCommonBase(symbol, timeframe)
																				{	Init();	}
	~CClassTemplate()															{	}
	
	int			Init();

}

int		CClassTemplate::Init() {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());
	

	return(INIT_SUCCEEDED);
	
}