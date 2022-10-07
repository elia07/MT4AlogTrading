
#property copyright ""
#property link      ""
#property version   "1.00"
#property strict

//
//	This is where we pull in the framework
//
#include <Orchard/Frameworks/Framework.mqh>

//
//	Input Section
//
input	int	InpTenkansen								=	9;
input	int	InpKijunsen								   =	26;
input int   InpSenkou                           =  52;
input	int	InpExtraKijun1								=	104;
input	int	InpExtraKijun2								=	208;
//
//	Some standard inputs,
//		remember to change the default magic for each EA
//
input	double	InpVolume		=	0.01;			//	Default order size
input	string	InpComment		=	__FILE__;	//	Default trade comment
input	int		InpMagicNumber	=	20200701;	//	Magic Number

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
CIndicatorJapsian	*JapsianIndicator;

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
	JapsianIndicator	=	new CIndicatorJapsian(InpTenkansen,InpKijunsen,InpSenkou,InpExtraKijun1,InpExtraKijun2);
	
	//
	//	Set up the signals
	//
	//Buffers
	/* double    ExtTenkanBuffer[];
      double    ExtKijunBuffer[];
      double    ExtSpanABuffer[];
      double    ExtSpanBBuffer[];
      double    ExtChikouBuffer[];
      double    ExtQualityBuffer[];
      double    ExtDirectionBuffer[];
      double    ExtExtraKijun1Buffer[];
      double    ExtExtraKijun2Buffer[];
   */
	EntrySignal	=	new CSignalCrossoverSimple();
	EntrySignal.AddIndicator(JapsianIndicator, 7);
	EntrySignal.AddIndicator(JapsianIndicator, 8);
	
	//ExitSignal	=	Not needed, using the same signal as entry
	
	//
	//	Add the signals to the expert
	//
	Expert.AddEntrySignal(EntrySignal);
	Expert.AddExitSignal(EntrySignal);	//	Same signal
	
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
	delete	JapsianIndicator;
	
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


