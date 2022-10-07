//+------------------------------------------------------------------+
//|                                                     JapsianFuture.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "RockCandyTrade"
#property link      "http://www.mql5.com"
#property description "JapsianFuture"
//--- indicator settings
#property indicator_chart_window
#property indicator_buffers 13
#property indicator_plots   12
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
#property indicator_type3   DRAW_LINE
#property indicator_type4   DRAW_LINE
#property indicator_type5   DRAW_LINE
#property indicator_type6   DRAW_LINE
#property indicator_type7   DRAW_FILLING
#property indicator_type8   DRAW_LINE
#property indicator_type9   DRAW_LINE
#property indicator_type10   DRAW_LINE
#property indicator_type11   DRAW_LINE
#property indicator_type12   DRAW_LINE
#property indicator_color1  Yellow
#property indicator_color2  Yellow
#property indicator_color3  Yellow
#property indicator_color4  Yellow
#property indicator_color5  Red
#property indicator_color6  Blue
#property indicator_color7  SandyBrown,Thistle
#property indicator_color8  Lime
#property indicator_color9  Yellow
#property indicator_color10  Orange
#property indicator_color11  Gray
#property indicator_color12  White
#property indicator_label1  "KijunExt2-sen Predict"
#property indicator_label2  "KijunExt1-sen Predict"
#property indicator_label3  "Kijun-sen Predict"
#property indicator_label4  "Tenkan-sen Predict"
#property indicator_label5  "Tenkan-sen"
#property indicator_label6  "Kijun-sen"
#property indicator_label7  "Senkou Span A;Senkou Span B"
#property indicator_label8  "Chikou Span"
#property indicator_label9  "QualityLine"
#property indicator_label10  "DirectionLine"
#property indicator_label11  "ExtKijun1"
#property indicator_label12  "ExtKijun2"
//--- input parameters
input int InpTenkan=9;     // Tenkan-sen
input int InpKijun=26;     // Kijun-sen
input int InpSenkou=52;    // Senkou Span B
input int InpExtKijun1=104;    // Extra Kijun1
input int InpExtKijun2=208;    // Extra Kijun2
input int InpTenkanPredict=1;
input int InpKijunPredict=1;
input int InpKijunExt1Predict=1;
input int InpKijunExt2Predict=1;
//--- indicator buffers
double    ExtTenkanBuffer[];
double    ExtKijunBuffer[];
double    ExtSpanABuffer[];
double    ExtSpanBBuffer[];
double    ExtChikouBuffer[];
double    ExtQualityBuffer[];
double    ExtDirectionBuffer[];
double    ExtExtraKijun1Buffer[];
double    ExtExtraKijun2Buffer[];
double    ExtTenkanPredictBuffer[];
double    ExtKijunPredictBuffer[];
double    ExtKijunExt1PredictBuffer[];
double    ExtKijunExt2PredictBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtKijunExt2PredictBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,ExtKijunExt1PredictBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,ExtKijunPredictBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,ExtTenkanPredictBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,ExtTenkanBuffer,INDICATOR_DATA);
   SetIndexBuffer(5,ExtKijunBuffer,INDICATOR_DATA);
   SetIndexBuffer(6,ExtSpanABuffer,INDICATOR_DATA);
   SetIndexBuffer(7,ExtSpanBBuffer,INDICATOR_DATA);
   SetIndexBuffer(8,ExtChikouBuffer,INDICATOR_DATA);
   SetIndexBuffer(9,ExtQualityBuffer,INDICATOR_DATA);
   SetIndexBuffer(10,ExtDirectionBuffer,INDICATOR_DATA);
   SetIndexBuffer(11,ExtExtraKijun1Buffer,INDICATOR_DATA);
   SetIndexBuffer(12,ExtExtraKijun2Buffer,INDICATOR_DATA);
   
   
//---
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits+1);
//--- sets first bar from what index will be drawn
   PlotIndexSetInteger(4,PLOT_DRAW_BEGIN,InpTenkan);
   PlotIndexSetInteger(5,PLOT_DRAW_BEGIN,InpKijun);
   PlotIndexSetInteger(6,PLOT_DRAW_BEGIN,InpSenkou-1);
   PlotIndexSetInteger(10,PLOT_DRAW_BEGIN,InpExtKijun1);
   PlotIndexSetInteger(11,PLOT_DRAW_BEGIN,InpExtKijun2);
//--- lines shifts when drawing
   PlotIndexSetInteger(6,PLOT_SHIFT,InpKijun);
   PlotIndexSetInteger(7,PLOT_SHIFT,-InpKijun);
   PlotIndexSetInteger(8,PLOT_SHIFT,InpKijun);
   PlotIndexSetInteger(9,PLOT_SHIFT,-InpKijun);
   PlotIndexSetInteger(3,PLOT_SHIFT,InpTenkanPredict);
   PlotIndexSetInteger(2,PLOT_SHIFT,InpKijunPredict);
   PlotIndexSetInteger(1,PLOT_SHIFT,InpKijunExt1Predict);
   PlotIndexSetInteger(0,PLOT_SHIFT,InpKijunExt2Predict);
//--- change labels for DataWindow
   PlotIndexSetString(4,PLOT_LABEL,"Tenkan-sen("+string(InpTenkan)+")");
   PlotIndexSetString(5,PLOT_LABEL,"Kijun-sen("+string(InpKijun)+")");
   PlotIndexSetString(6,PLOT_LABEL,"Senkou Span A;Senkou Span B("+string(InpSenkou)+")");
  }
//+------------------------------------------------------------------+
//| Japsian                                               |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int start;
//---
   if(prev_calculated==0)
      start=0;
   else
      start=prev_calculated-1;
//--- main loop
   for(int i=start; i<rates_total && !IsStopped(); i++)
     {
      ExtChikouBuffer[i]=close[i];
      //--- tenkan sen
      double price_max=Highest(high,InpTenkan,i);
      double price_min=Lowest(low,InpTenkan,i);
      ExtTenkanBuffer[i]=(price_max+price_min)/2.0;
      if(i-InpTenkanPredict>0)
      {
         ExtTenkanPredictBuffer[i-InpTenkanPredict]=(price_max+price_min)/2.0;
      }
      //--- kijun sen
      price_max=Highest(high,InpKijun,i);
      price_min=Lowest(low,InpKijun,i);
      ExtKijunBuffer[i]=(price_max+price_min)/2.0;
      ExtQualityBuffer[i]=(price_max+price_min)/2.0;
      ExtDirectionBuffer[i]=(price_max+price_min)/2.0;
      if(i-InpKijunPredict>0)
      {
         ExtKijunPredictBuffer[i-InpKijunPredict]=(price_max+price_min)/2.0;
      }
      //--- senkou span a
      ExtSpanABuffer[i]=(ExtTenkanBuffer[i]+ExtKijunBuffer[i])/2.0;
      //--- senkou span b
      price_max=Highest(high,InpSenkou,i);
      price_min=Lowest(low,InpSenkou,i);
      ExtSpanBBuffer[i]=(price_max+price_min)/2.0;
      //--- Extra Kijun 1
      price_max=Highest(high,InpExtKijun1,i);
      price_min=Lowest(low,InpExtKijun1,i);
      ExtExtraKijun1Buffer[i]=(price_max+price_min)/2.0;
      if(i-InpKijunExt1Predict>0)
      {
         ExtKijunExt1PredictBuffer[i-InpKijunExt1Predict]=(price_max+price_min)/2.0;
      }
      //--- Extra Kijun 2
      price_max=Highest(high,InpExtKijun2,i);
      price_min=Lowest(low,InpExtKijun2,i);
      ExtExtraKijun2Buffer[i]=(price_max+price_min)/2.0;
      if(i-InpKijunExt2Predict>0)
      {
         ExtKijunExt2PredictBuffer[i-InpKijunExt2Predict]=(price_max+price_min)/2.0;
      }
     }
    
    //Tenkan Predict
    for(int i=InpTenkanPredict;i>0;i--)
    {
      double price_max=Highest(high,InpTenkan-i,rates_total-i);
      double price_min=Lowest(low,InpTenkan-i,rates_total-i);
      if(price_max<high[rates_total-1])
      {
         price_max=high[rates_total-1];
      }
      if(price_min>low[rates_total-1])
      {
         price_min=low[rates_total-1];
      }
      ExtTenkanPredictBuffer[rates_total-i]=(price_max+price_min)/2.0;
    }
    //Kijun Predict
    for(int i=InpKijunPredict;i>0;i--)
    {
      double price_max=Highest(high,InpKijun-i,rates_total-i);
      double price_min=Lowest(low,InpKijun-i,rates_total-i);
      if(price_max<high[rates_total-1])
      {
         price_max=high[rates_total-1];
      }
      if(price_min>low[rates_total-1])
      {
         price_min=low[rates_total-1];
      }
      ExtKijunPredictBuffer[rates_total-i]=(price_max+price_min)/2.0;
    }
    //KijunExt1 Predict
    for(int i=InpKijunExt1Predict;i>0;i--)
    {
      double price_max=Highest(high,InpExtKijun1-i,rates_total-i);
      double price_min=Lowest(low,InpExtKijun1-i,rates_total-i);
      if(price_max<high[rates_total-1])
      {
         price_max=high[rates_total-1];
      }
      if(price_min>low[rates_total-1])
      {
         price_min=low[rates_total-1];
      }
      ExtKijunExt1PredictBuffer[rates_total-i]=(price_max+price_min)/2.0;
    }
    //KijunExt2 Predict
    for(int i=InpKijunExt2Predict;i>0;i--)
    {
      double price_max=Highest(high,InpExtKijun2-i,rates_total-i);
      double price_min=Lowest(low,InpExtKijun2-i,rates_total-i);
      if(price_max<high[rates_total-1])
      {
         price_max=high[rates_total-1];
      }
      if(price_min>low[rates_total-1])
      {
         price_min=low[rates_total-1];
      }
      ExtKijunExt2PredictBuffer[rates_total-i]=(price_max+price_min)/2.0;
    }
//---
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| get price_max value for range                                      |
//+------------------------------------------------------------------+
double Highest(const double& array[],const int range,int from_index)
  {
   double res=0;
//---
   res=array[from_index];
   for(int i=from_index; i>from_index-range && i>=0; i--)
      if(res<array[i])
         res=array[i];
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| get price_min value for range                                       |
//+------------------------------------------------------------------+
double Lowest(const double& array[],const int range,int from_index)
  {
   double res=0;
//---
   res=array[from_index];
   for(int i=from_index; i>from_index-range && i>=0; i--)
      if(res>array[i])
         res=array[i];
//---
   return(res);
  }
//+------------------------------------------------------------------+
