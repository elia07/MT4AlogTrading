/*
	ExpertBase.mqh

	Copyright 2013-2020, Orchard Forex
	https://www.orchardforex.com

*/


#include	"CommonBase.mqh"
#include "SignalBase.mqh"
#include "TPSLBase.mqh"
#include	"Trade/Trade.mqh"

class CExpertBase : public CCommonBase {

protected:

	int				mMagicNumber;
	string			mTradeComment;
	
	double			mVolume;
	
	datetime			mLastBarTime;
	datetime			mBarTime;
	
	double         mAdditionalStopLoss;

	////Changed
	//	Arrays to hold the signal objects	
	
	////CSignalBase		*mEntrySignal;
	////CSignalBase		*mExitSignal;

	double			mTakeProfitValue;
	double			mStopLossValue;
	CTPSLBase		*mTakeProfitObj;
	CTPSLBase		*mStopLossObj;
	
	CTradeCustom	Trade;

private:

protected:

	virtual bool	LoopMain(bool newBar, bool firstTime);
	
protected:

	int				Init(int magicNumber, string tradeComment);

public:

	//
	//	Constructors
	//
	CExpertBase()							: CCommonBase()
												{	Init(0, "");	}
	CExpertBase(string symbol, int timeframe, int magicNumber, string tradeComment)
												:	CCommonBase(symbol, timeframe)
												{	Init(magicNumber, tradeComment);	}
	CExpertBase(string symbol, ENUM_TIMEFRAMES timeframe, int magicNumber, string tradeComment)
												:	CCommonBase(symbol, timeframe)
												{	Init(magicNumber, tradeComment);	}
	CExpertBase(int magicNumber, string tradeComment)
												:	CCommonBase()
												{	Init(magicNumber, tradeComment);	}

	//
	//	Destructors
	//
	~CExpertBase();

public:	//	Default properties

	//
	//	Assign the default values to the expert
	//
	virtual void	SetVolume(double volume)		{	mVolume			=	volume;	}
	virtual void	SetAdditionalStopLoss(double value)		{	mAdditionalStopLoss			=	value;	}

	virtual void	SetTakeProfitValue(int takeProfitPoints)
																{	mTakeProfitValue	=	PointsToDouble(takeProfitPoints);	}
	virtual void	SetTakeProfitObj(CTPSLBase *takeProfitObj)
																{	mTakeProfitObj	=	takeProfitObj;	}

	virtual void	SetStopLossValue(int stopLossPoints)
																{	mStopLossValue	=	PointsToDouble(stopLossPoints);	}
	virtual void	SetStopLossObj(CTPSLBase *stopLossObj)
																{	mStopLossObj	=	stopLossObj;	}
	
	virtual void	SetTradeComment(string comment)	{	mTradeComment	=	comment;	}
	virtual void	SetMagic(int magicNumber)			{	mMagicNumber	=	magicNumber;
																		Trade.SetExpertMagicNumber(magicNumber);	}
	
public:	//	Event handlers

	virtual int		OnInit();
	virtual void	OnTick();
	virtual void	OnTimer()			{	return;	}
	virtual double	OnTester()			{	return(0.0);	}
	virtual void	OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {};

#ifdef __MQL5__
	virtual void	OnTrade()			{	return;	}
	virtual void	OnTradeTransaction(const MqlTradeTransaction& trans,
                        					const MqlTradeRequest& request,
                        					const MqlTradeResult& result)
                        				{	return;	}
	virtual int		OnTesterInit()		{	return(INIT_SUCCEEDED);	}
	virtual void	OnTesterPass()		{	return;	}
	virtual void	OnTesterDeinit()	{	return;	}
	virtual void	OnBookEvent()		{	return;	}
#endif

public:	// Functions

	virtual void	GetMarketPrices(ENUM_ORDER_TYPE orderType, MqlTradeRequest &request);
	////New
	virtual ENUM_OFX_SIGNAL_DIRECTION	GetCurrentSignal(CSignalBase* &signals[],
																	ENUM_OFX_SIGNAL_TYPE signalType);
	
};

CExpertBase::~CExpertBase() {

}

int   CExpertBase::OnInit() {


   if (mTakeProfitObj!=NULL) {
      if (mTakeProfitObj.InitResult()!=INIT_SUCCEEDED) return(mTakeProfitObj.InitResult());
   }
   if (mStopLossObj!=NULL) {
      if (mStopLossObj.InitResult()!=INIT_SUCCEEDED) return(mStopLossObj.InitResult());
   }

   
   return(INIT_SUCCEEDED);

}

int	CExpertBase::Init(int magicNumber, string tradeComment) {

	if (mInitResult!=INIT_SUCCEEDED) return(mInitResult);
	
	mTradeComment		=	tradeComment;
	SetMagic(magicNumber);

	mTakeProfitValue	=	0.0;
	mStopLossValue		=	0.0;
		
	mLastBarTime		=	0;
	
	return(INIT_SUCCEEDED);
	
}

void	CExpertBase::OnTick(void) {

	if (!TradeAllowed()) return;
	
	mBarTime	=	iTime(mSymbol, mTimeframe, 0);

	bool	firstTime	=	(mLastBarTime==0);
	bool	newBar		=	(mBarTime!=mLastBarTime);
	
	if (LoopMain(newBar, firstTime)) {
		mLastBarTime	=	mBarTime;
	}

	return;
	
}

bool		CExpertBase::LoopMain(bool newBar,bool firstTime) {

	//
	//	To start I will only trade on a new bar
	//		and not on the first bar after start
	//
	if (!newBar)	return(true);
	if (firstTime)	return(true);
	
	return(true);
	
}

void	CExpertBase::GetMarketPrices(ENUM_ORDER_TYPE orderType, MqlTradeRequest &request) {

	double	sl	=	(mStopLossObj==NULL) ? mStopLossValue : mStopLossObj.GetStopLoss();
	double	tp	=	(mTakeProfitObj==NULL) ? mTakeProfitValue : mTakeProfitObj.GetTakeProfit();
	
	if (orderType==ORDER_TYPE_BUY) {
		if (request.price==0.0) request.price	=	SymbolInfoDouble(mSymbol, SYMBOL_ASK);
		request.tp	=	(tp==0.0) ? 0.0 : NormalizeDouble(request.price+tp, mDigits);
		request.sl	=	((sl==0.0) ? 0.0 : NormalizeDouble(request.price-sl, mDigits))-mAdditionalStopLoss;
	}

	if (orderType==ORDER_TYPE_SELL) {
		if (request.price==0.0) request.price	=	SymbolInfoDouble(mSymbol, SYMBOL_BID);
		request.tp	=	(tp==0.0) ? 0.0 : NormalizeDouble(request.price-tp, mDigits);
		request.sl	=	((sl==0.0) ? 0.0 : NormalizeDouble(request.price+sl, mDigits))+mAdditionalStopLoss;
	}

	return;

}





