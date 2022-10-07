//+------------------------------------------------------------------+
//|                                                 StartegyBase.mqh |
//|                                                   RockCandyTrade |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "RockCandyTrade"
#property link      "https://www.mql5.com"

#include	"CommonBase.mqh"
#include	"SignalBase.mqh"
#include	"OrderBase.mqh"
#include	"PendingOrderBase.mqh"

Class CStrategyBase : Public CCommonBase{
private:

protected:	// member variables

   CSignalBase		*mEntrySignals[];
	CSignalBase		*mExitSignals[];
	COrderBase     *mOrders[];
	CPendingOrder  *mPendingOrders[];
	
public:	// constructors

   CStrategyBase()															:	CCommonBase()
																				{	Init();	}
	CStrategyBase(string symbol, ENUM_TIMEFRAMES timeframe)		:	CCommonBase(symbol, timeframe)
																				{	Init();	}
	~CStrategyBase()															{	}
	
	int			Init();

}

public : // Setup
   virtual void	AddEntrySignal(CSignalBase *signal)	{	AddSignal(signal, mEntrySignals);	}
	virtual void	AddExitSignal(CSignalBase *signal)	{	AddSignal(signal, mExitSignals);	}
	virtual void	AddSignal(CSignalBase *signal, CSignalBase* &signals[]);

public : //EventHandler
   virtual void	OnTick();
   virtual void	OnOrderPlaced(); 
   virtual void	OnOrderReject();
   //On New Candle
    

int		CStrategyBase::Init() {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());
	////New
	ArrayResize(mEntrySignals, 0);	//	Just make sure these are initialised
	ArrayResize(mExitSignals, 0);
	
	int   i  =  0;
	for (i=ArraySize(mEntrySignals)-1; i>=0; i--) {
      if (mEntrySignals[i].InitResult()!=INIT_SUCCEEDED) return(mEntrySignals[i].InitResult());
   }
   for (i=ArraySize(mExitSignals)-1; i>=0; i--) {
      if (mExitSignals[i].InitResult()!=INIT_SUCCEEDED) return(mExitSignals[i].InitResult());
   }

	return(INIT_SUCCEEDED);
	
}

void	CStrategyBase::AddSignal(CSignalBase *signal, CSignalBase* &signals[]) {

	int		index	=	ArraySize(signals);
	ArrayResize(signals, index+1);
	signals[index]	=	signal;
	
}