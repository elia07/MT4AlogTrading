//+------------------------------------------------------------------+
//|                                                 StartegyBase.mqh |
//|                                                   RockCandyTrade |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "RockCandyTrade"
#property link      "https://www.mql5.com"

#include	"CommonBase.mqh"
#include	"SignalBase.mqh"

enum ENUM_OFX_ORDER_TPSL_TYPE {
	OFX_ORDER_TPSL_PlaceOnBroker,
	OFX_ORDER_TPSL_ManageModeClose,
	OFX_ORDER_TPSL_ManageModeTouch,
	OFX_ORDER_TPSL_OnSignal
};

enum ENUM_OFX_ORDER_TYPE {
	OFX_ORDER_TYPE_Bull,
	OFX_ORDER_TYPE_Bear
};

enum ENUM_OFX_ORDER_PRIORITY {
	ENUM_OFX_ORDER_PRIORITY_NewSignal,
	ENUM_OFX_ORDER_PRIORITY_Instant
};

enum ENUM_OFX_ORDER_EXECUTION_TYPE {
	ENUM_OFX_ORDER_EXECUTION_TYPE_Normal,
	ENUM_OFX_ORDER_EXECUTION_TYPE_BuyStop,
	ENUM_OFX_ORDER_EXECUTION_TYPE_SellStop,
	ENUM_OFX_ORDER_EXECUTION_TYPE_Oco
};

enum ENUM_OFX_ORDER_EXECUTION_STATUS_TYPE {
	ENUM_OFX_ORDER_EXECUTION_STATUS_TYPE_Accepted,
	ENUM_OFX_ORDER_EXECUTION_STATUS_TYPE_Rejected,
	ENUM_OFX_ORDER_EXECUTION_STATUS_TYPE_Waiting
};

enum ENUM_OFX_ORDER_MONITOR_TYPE {
	ENUM_OFX_ORDER_MONITOR_TYPE_EachCandle,
	ENUM_OFX_ORDER_MONITOR_TYPE_EachTick
};


class COrderBase : public CCommonBase {

private:

   string mGeneratedStartegy;
   string mGeneratedSignal;

   ENUM_OFX_ORDER_TPSL_TYPE         mOrderTpSlType;
   ENUM_OFX_ORDER_TYPE              mOrderType;
   ENUM_OFX_ORDER_PRIORITY          mOrderPriorityType;
   ENUM_OFX_ORDER_EXECUTION_TYPE    mOrderExecutionType;
   ENUM_OFX_ORDER_MONITOR_TYPE      mOrderMonitorType;
   
   double                           mTakeProfit;
   double                           mStopLoss;
   bool                             mManageTPSLLocally;
   CSignalBase                      *mTakeProfitSignal[];
   CSignalBase                      *mStopLossSignal[];
   CSignalBase                      *mExitSignal[];
   
   ENUM_OFX_ORDER_EXECUTION_STATUS_TYPE   mOrderExecutionStatusType;
   string                                 mOrderExecutionComment;
   
   
   
   

protected:	// member variables
	
public:	// constructors

   COrderBase(ENUM_OFX_ORDER_TPSL_TYPE orderTpSlType,ENUM_OFX_ORDER_TYPE orderType,ENUM_OFX_ORDER_PRIORITY orderPriorityType,ENUM_OFX_ORDER_EXECUTION_TYPE orderExecutionType,ENUM_OFX_ORDER_MONITOR_TYPE orderMonitorType,string generatedStartegy,string generatedSignal)															:	CCommonBase()
																				{	Init(mOrderTpSlType,mOrderType,mOrderPriorityType,mOrderExecutionType,mOrderMonitorType,generatedStartegy,generatedSignal);	}
	COrderBase(string symbol, ENUM_TIMEFRAMES timeframe,ENUM_OFX_ORDER_TPSL_TYPE orderTpSlType,ENUM_OFX_ORDER_TYPE orderType,ENUM_OFX_ORDER_PRIORITY orderPriorityType,ENUM_OFX_ORDER_EXECUTION_TYPE orderExecutionType,ENUM_OFX_ORDER_MONITOR_TYPE orderMonitorType,string generatedStartegy,string generatedSignal)		:	CCommonBase(symbol, timeframe)
																				{	Init(mOrderTpSlType,mOrderType,mOrderPriorityType,mOrderExecutionType,mOrderMonitorType,generatedStartegy,generatedSignal);	}
	~COrderBase()															{	}
	
	int			Init(ENUM_OFX_ORDER_TPSL_TYPE orderTpSlType,ENUM_OFX_ORDER_TYPE orderType,ENUM_OFX_ORDER_PRIORITY orderPriorityType,ENUM_OFX_ORDER_EXECUTION_TYPE orderExecutionType,ENUM_OFX_ORDER_MONITOR_TYPE orderMonitorType,string generatedStartegy,string generatedSignal);

public : // Setup
   virtual void	AddTakeProfitSignal(CSignalBase *signal)	{	AddSignal(signal, mTakeProfitSignal);	}
	virtual void	AddStopLossSignal(CSignalBase *signal)	{	AddSignal(signal, mStopLossSignal);	}
	virtual void	AddExitSignal(CSignalBase *signal)	{	AddSignal(signal, mExitSignal);	}
	virtual void	SetTakeProfit(double value)   { mTakeProfit=value; }
	virtual void	SetStopLoss(double value)   { mStopLoss=value; }
	virtual void	SetManageTPSLLocally(double value)   { mManageTPSLLocally=value; }
	
	virtual void	SetOrderExecutionComment(string value)   { mOrderExecutionComment=value; }
	virtual void	SetOrderExecutionStatus(ENUM_OFX_ORDER_EXECUTION_STATUS_TYPE value)   { mOrderExecutionStatusType=value; }
	
	virtual void	AddSignal(CSignalBase *signal, CSignalBase* &signals[]);

public : //Events
   virtual void	OnExecition(); 
   virtual void	OnTakeProfit(); 
   virtual void	OnStopLoss(); 
   virtual void	OnExit();

};
int		COrderBase::Init(ENUM_OFX_ORDER_TPSL_TYPE orderTpSlType,ENUM_OFX_ORDER_TYPE orderType,ENUM_OFX_ORDER_PRIORITY orderPriorityType,ENUM_OFX_ORDER_EXECUTION_TYPE orderExecutionType,ENUM_OFX_ORDER_MONITOR_TYPE orderMonitorType,string generatedStartegy,string generatedSignal) {

	if (InitResult()!=INIT_SUCCEEDED)	return(InitResult());
	
   mOrderTpSlType=orderTpSlType;
   mOrderType=orderType;
   mOrderPriorityType=orderPriorityType;
   mOrderExecutionType=orderExecutionType;
   mOrderMonitorType=orderMonitorType;
   mOrderExecutionStatusType=ENUM_OFX_ORDER_EXECUTION_STATUS_TYPE_Waiting;
   mGeneratedSignal=generatedSignal;
   mGeneratedStartegy=generatedStartegy;
	return(INIT_SUCCEEDED);
	
}

void	COrderBase::AddSignal(CSignalBase *signal, CSignalBase* &signals[]) {

	int		index	=	ArraySize(signals);
	ArrayResize(signals, index+1);
	signals[index]	=	signal;
	
}