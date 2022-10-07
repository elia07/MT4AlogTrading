//+------------------------------------------------------------------+
//|                                                 StartegyBase.mqh |
//|                                                   RockCandyTrade |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "RockCandyTrade"
#property link      "https://www.mql5.com"

#include	"CommonBase.mqh"
#include	"SignalBaseBase.mqh"
#include	"OrderBase.mqh"

Class CPendingOrder : Public CCommonBase{
private:
   
   COrderBase  *mOrder;
   CSignalBase *mActivatingSignal;
   datetime    mExpireDate;

protected:	// member variables
	
public:	// constructors

   CPendingOrder()															:	CCommonBase(COrderBase *order,CSignalBase *activatingSignal,datetime expireDate)
																				{	Init(order,activatingSignal,expireDate);	}
	CPendingOrder(string symbol, ENUM_TIMEFRAMES timeframe)		:	CCommonBase(symbol, timeframe,COrderBase *order,CSignalBase *activatingSignal,datetime expireDate)
																				{	Init(order,activatingSignal,expireDate);	}
	~CPendingOrder()															{	}
	
	int			Init(COrderBase *order,CSignalBase *activatingSignal,datetime expireDate);

}

int		CPendingOrder::Init(COrderBase *order,CSignalBase *activatingSignal,datetime expireDate) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());
	mOrder=order;
	mActivatingSignal=activatingSignal;
   mExpireDate=expireDate;
	return(INIT_SUCCEEDED);
	
}