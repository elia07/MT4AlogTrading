/*

   MA Crossover.mq5

   Copyright 2013-2020, Orchard Forex
   https://www.orchardforex.com

	Description:
	
*/

#property copyright "Copyright 2013-2020, Orchard Forex"
#property link      "https://www.orchardforex.com"
#property version   "1.00"
#property strict

//
//	This is where we pull in the framework
//
#include <Orchard/Frameworks/Framework.mqh>

//
//	Input Section
//
input	int	InpPeriod   								=	10;
input	int	InpMultiplier								=	3;
input bool  InpFill                             =  false;

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
CIndicatorSUPERTREND	*SupertrendIndicatorEntry;
CIndicatorSUPERTREND	*SupertrendIndicator4H;
CIndicatorSUPERTREND	*SupertrendIndicator1D;
CIndicatorSUPERTREND	*SupertrendIndicator30M;

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
	SupertrendIndicatorEntry	=	new CIndicatorSUPERTREND(InpPeriod,InpMultiplier,InpFill);
   SupertrendIndicator4H	=	new CIndicatorSUPERTREND(_Symbol,PERIOD_H4,InpPeriod,InpMultiplier,false);
   SupertrendIndicator1D	=	new CIndicatorSUPERTREND(_Symbol,PERIOD_D1,InpPeriod,InpMultiplier,InpFill);
   SupertrendIndicator30M	=	new CIndicatorSUPERTREND(_Symbol,PERIOD_M30,InpPeriod,InpMultiplier,InpFill);
	
	//
	//	Set up the signals
	//
	//Buffers
   //3 Color
	EntrySignal	=	new CSignalMTFColorCrossover();
	EntrySignal.AddIndicator(SupertrendIndicatorEntry, 3);
	EntrySignal.AddIndicator(SupertrendIndicator4H, 3);
	EntrySignal.AddIndicator(SupertrendIndicator1D, 3);
	EntrySignal.AddIndicator(SupertrendIndicator30M, 3);
	
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
	delete	ExitSignal;
	delete	EntrySignal;
	delete	SupertrendIndicatorEntry;
	delete	SupertrendIndicator4H;
	delete	SupertrendIndicator1D;
	delete   SupertrendIndicator30M;
	
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


