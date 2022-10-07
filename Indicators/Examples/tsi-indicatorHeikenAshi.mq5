#property description ""
#property description ""

#property indicator_separate_window
#property indicator_buffers 8
#property indicator_plots   2
//#property indicator_applied_price PRICE_TYPICAL
//--- Connect a function of averaging from the MovingAverages.mqh file
#include <MovingAverages.mqh>
//---- plot TSI
#property indicator_label1  "TSI"
#property indicator_type1   DRAW_LINE
#property indicator_color1  Blue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//---- plot TSI Signal
#property indicator_label2 "TSISignal" // Name of the line that is displayed in a pop up help when the mouse pointer is put over the line.
#property indicator_type2 DRAW_LINE    // Type of buffer 
#property indicator_color2 Red         // Color of the line
#property indicator_style2 STYLE_SOLID // Style
#property indicator_width2 1           // Thickness of the line
//--- input parameters
input int r=25;
input int s=13;
input int sp=5;
input ENUM_MA_METHOD sm=MODE_EMA;
//--- indicator buffers
double         TSIBuffer[];
double         TSISigBuffer[];
double         MTMBuffer[];
double         AbsMTMBuffer[];
double         EMA_MTMBuffer[];
double         EMA2_MTMBuffer[];
double         EMA_AbsMTMBuffer[];
double         EMA2_AbsMTMBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,TSIBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,TSISigBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,MTMBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(3,AbsMTMBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(4,EMA_MTMBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(5,EMA2_MTMBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(6,EMA_AbsMTMBuffer,INDICATOR_CALCULATIONS);
   SetIndexBuffer(7,EMA2_AbsMTMBuffer,INDICATOR_CALCULATIONS);
//--- A bar starting from which the indicator will be drawn
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,r+s-1);
   string shortname;
   StringConcatenate(shortname,"TSI(",r,",",s,")");
//--- Set a label for displaying in the DataWindow
   PlotIndexSetString(0,PLOT_LABEL,shortname);
//--- set a name that will be shown in a separate sub-window and in a pop up help
   IndicatorSetString(INDICATOR_SHORTNAME,shortname);
//--- specify accuracy of displaying values of the indicator
   IndicatorSetInteger(INDICATOR_DIGITS,2);
//---
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,r+s+sp);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate (const int rates_total,    // size of the price[] array;
                 const int prev_calculated,// number of available bars ;
                                           // at the previous call;
                 const int begin,          // what index in the array 
                                           // price[] the reliable information starts from;
                 const double &price[])    // array the indicator will be calculated by;
  {
//--- flag for one-time displaying of values of price[]
   static bool printed=false;
//--- if begin is not equal to zero, then there values that we shouldn't take into consideration
   if(begin>0 && !printed)
     {
      //--- display
      Print("Values for calculation start from the index begin =",begin,
            "   size of the array price[] =",rates_total);

      //--- let's see how the values that shouldn't be taken for calculations look like
      for(int i=0;i<=begin;i++)
        {
         Print("i =",i,"  value =",price[i]);
        }
      //--- set an attribute that the values have been already displayed in the log
      printed=true;
     }
//--- if the size of the price[] array is too small
   if(rates_total<r+s) return(0); // don't calculate anything and don't draw anything on the chart
//--- if it's a first call 
   if(prev_calculated==0)
     {
      //--- increase the index of data beginning by begin bars as a result of calculations using data of another indicator
      if(begin>0)PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,begin+r+s-1);
      //--- initialize indicator buffers with EMPTY_VALUE value
      ArrayInitialize(TSIBuffer,EMPTY_VALUE);
      ArrayInitialize(MTMBuffer,EMPTY_VALUE);
      ArrayInitialize(AbsMTMBuffer,EMPTY_VALUE);
      ArrayInitialize(EMA_MTMBuffer,EMPTY_VALUE);
      ArrayInitialize(EMA2_MTMBuffer,EMPTY_VALUE);
      ArrayInitialize(EMA_AbsMTMBuffer,EMPTY_VALUE);
      ArrayInitialize(EMA2_AbsMTMBuffer,EMPTY_VALUE);
      //--- for zero indexes set zero values
      MTMBuffer[0]=0.0;
      AbsMTMBuffer[0]=0.0;
     }

//--- calculate mtm and |mtm| values
   int start;
   if(prev_calculated==0) start=begin+1;  // start filling MTMBuffer[] and AbsMTMBuffer[] from the begin+1 index
   else start=prev_calculated-1;          // set 'start' equal to the last index in arrays 
   for(int i=start;i<rates_total;i++)
     {
      MTMBuffer[i]=price[i]-price[i-1];
      AbsMTMBuffer[i]=fabs(MTMBuffer[i]);
     }

//--- calculate the first moving average on arrays
   ExponentialMAOnBuffer(rates_total,prev_calculated,
                         begin+1,         // an index the values start from in the array for smoothing 
                         r,               // period of exponential average
                         MTMBuffer,       // buffer for taking average
                         EMA_MTMBuffer);  // place the values of average in this buffer
   ExponentialMAOnBuffer(rates_total,prev_calculated,
                         begin+1,r,AbsMTMBuffer,EMA_AbsMTMBuffer);

//--- calculate the second moving average on the arrays
   ExponentialMAOnBuffer(rates_total,prev_calculated,
                         begin+r,s,EMA_MTMBuffer,EMA2_MTMBuffer);
   ExponentialMAOnBuffer(rates_total,prev_calculated,
                         begin+r,s,EMA_AbsMTMBuffer,EMA2_AbsMTMBuffer);

//--- now calculate values of the indicator
   if(prev_calculated==0) start=begin+r+s-1; // set the initial index for the input arrays
   else start=prev_calculated-1;             // set 'start' equal to the last index in the arrays 
   for(int i=start;i<rates_total;i++)
     {
      TSIBuffer[i]=100*EMA2_MTMBuffer[i]/EMA2_AbsMTMBuffer[i];
     }
   int begin2=begin+r+s-1;
   int WeightSum=0;
   switch(sm)
     {
      case MODE_EMA:
         ExponentialMAOnBuffer(rates_total,prev_calculated,begin2,sp,TSIBuffer,TSISigBuffer);
         break;
      case MODE_LWMA:
         LinearWeightedMAOnBuffer(rates_total,prev_calculated,begin2,sp,TSIBuffer,TSISigBuffer,WeightSum);
         break;
      case MODE_SMA:
         SimpleMAOnBuffer(rates_total,prev_calculated,begin2,sp,TSIBuffer,TSISigBuffer);
         break;
      case MODE_SMMA:
         SmoothedMAOnBuffer(rates_total,prev_calculated,begin2,sp,TSIBuffer,TSISigBuffer);
         break;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
