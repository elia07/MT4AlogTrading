
#property copyright ""
#property link      "https://"
#property version   "1.00"
#property strict

//
//	This is where we pull in the framework
//
#include <Orchard/Frameworks/Framework.mqh>

//
//	Input Section
//
input	int	   InpPeriod   								=	10;
input	double	InpMultiplier								=	3.5;
input bool     InpFill                             =  false;
input	int	   InpTSIR   								   =	3;
input	int	   InpTSIS   								   =	7;
input	int	   InpTSISP   								   =	4;

//
//	Some standard inputs,
//		remember to change the default magic for each EA
//
input	double	InpVolume		=	0.01;			//	Default order size
input	string	InpComment		=	__FILE__;	//	Default trade comment
input	int		InpMagicNumber	=	20200701;	//	Magic Number
input	int		InpTakeProfit	=	500;	//	
input	int		InpStopLoss	=	500;	//	

//
//	Declare the expert, use the child class name
//
#define	CExpert	CExpertBase
CExpert		*Expert;

//
//	Signals, use the child class names if applicable
//
CSignalBase	*EntrySignal;
CSignalBase	*ExitSignal;


//
//	Indicators - use the child class name here
//
CIndicatorSTASHI	*SupertrendAshiIndicatorEntry;
CIndicatorTSI     *TsiIndicator;
CIndicatorHEIKENASHI     *HeikenAshiIndicator;


int OnInit() {

	//
	//	Instantiate the expert
	//
	Expert	=	new CExpert();

	//
	//	Assign the default values to the expert
	//
	Expert.SetVolume(InpVolume);
	Expert.SetTradeComment(InpComment);
	Expert.SetMagic(InpMagicNumber);
	
	//
	//	Create the indicators
	//
	SupertrendAshiIndicatorEntry	=	new CIndicatorSTASHI(InpPeriod,InpMultiplier,InpFill);
   TsiIndicator = new CIndicatorTSI(InpTSIR,InpTSIS,InpTSISP);
	HeikenAshiIndicator = new CIndicatorHEIKENASHI();
	//
	//	Set up the signals
	//
	//Buffers
   //3 Color
	EntrySignal	=	new CSignalColorCrossoverAndTSI();
	EntrySignal.AddIndicator(TsiIndicator, 0);
	EntrySignal.AddIndicator(TsiIndicator, 1);
	EntrySignal.AddIndicator(SupertrendAshiIndicatorEntry, 3);
	
	//ExitSignal	=	Not needed, using the same signal as entry
	
	//
	//	Add the signals to the expert
	//
	Expert.AddEntrySignal(EntrySignal);
	Expert.AddExitSignal(EntrySignal);	//	Same signal
	
   //Expert.SetTakeProfitValue(InpTakeProfit);
   //Expert.SetStopLossValue(InpStopLoss);
	
	//
	// Finish expert initialisation and check result
	//
	int	result	=	Expert.OnInit();
	
   return(result);

}

void OnDeinit(const int reason) {

   EventKillTimer();
	
	delete	Expert;
	//delete	ExitSignal;
	delete	EntrySignal;
	delete	SupertrendAshiIndicatorEntry;
	delete	TsiIndicator;
	delete   HeikenAshiIndicator;
	
	return;
	
}

void OnTick() {

	Expert.OnTick();
	return;
	
}

void OnTimer() {

	Expert.OnTimer();
	return;

}

void OnTrade() {

	Expert.OnTrade();
	return;

}

void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result) {

	Expert.OnTradeTransaction(trans, request, result);
	return;

}

double OnTester() {

	return(Expert.OnTester());

}

void OnTesterInit() {

	Expert.OnTesterInit();
	return;

}

void OnTesterPass() {

	Expert.OnTesterPass();
	return;

}

void OnTesterDeinit() {

	Expert.OnTesterDeinit();
	return;

}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {

	Expert.OnChartEvent(id, lparam, dparam, sparam);
	return;
	
}

void OnBookEvent(const string &symbol) {

	Expert.OnBookEvent();
	return;

}


