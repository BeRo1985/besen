(*******************************************************************************
                                 L I C E N S E
********************************************************************************

BESEN - A ECMAScript Fifth Edition Object Pascal Implementation
Copyright (C) 2009-2016, Benjamin 'BeRo' Rosseaux

The source code of the BESEN ecmascript engine library and helper tools are 
distributed under the Library GNU Lesser General Public License Version 2.1 
(see the file copying.txt) with the following modification:

As a special exception, the copyright holders of this library give you
permission to link this library with independent modules to produce an
executable, regardless of the license terms of these independent modules,
and to copy and distribute the resulting executable under terms of your choice,
provided that you also meet, for each linked independent module, the terms
and conditions of the license of that module. An independent module is a module
which is not derived from or based on this library. If you modify this
library, you may extend this exception to your version of the library, but you 
are not obligated to do so. If you do not wish to do so, delete this exception
statement from your version.

If you didn't receive a copy of the license, see <http://www.gnu.org/licenses/>
or contact:
      Free Software Foundation
      675 Mass Ave
      Cambridge, MA  02139
      USA

*******************************************************************************)
unit BESENObjectMath;
{$i BESEN.inc}

interface

uses Math,BESENConstants,BESENTypes,BESENObject,BESENValue,BESENObjectPropertyDescriptor;

type TBESENObjectMath=class(TBESENObject)
      public
       constructor Create(AInstance:TObject;APrototype:TBESENObject=nil;AHasPrototypeProperty:longbool=false); overload; override;
       destructor Destroy; override;
       procedure NativeAbs(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeACos(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeASin(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeATan(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeATan2(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeCeil(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeCos(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeExp(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeFloor(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeLog(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeMax(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeMin(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativePow(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeRandom(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeRound(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeSin(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeSqrt(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
       procedure NativeTan(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
     end;

implementation

uses BESEN,BESENNumberUtils;

constructor TBESENObjectMath.Create(AInstance:TObject;APrototype:TBESENObject=nil;AHasPrototypeProperty:longbool=false);
var v:TBESENValue;
begin
 inherited Create(AInstance,APrototype,AHasPrototypeProperty);
 ObjectClassName:='Math';

 v:=BESENEmptyValue;
 v:=BESENNumberValue(2.7182818284590452354);
 OverwriteData('E',v,[]);

 v:=BESENNumberValue(2.7182818284590452354);
 OverwriteData('E',v,[]);

 v:=BESENNumberValue(2.302585092994046);
 OverwriteData('LN10',v,[]);

 v:=BESENNumberValue(0.6931471805599453);
 OverwriteData('LN2',v,[]);

 v:=BESENNumberValue(1.4426950408889634);
 OverwriteData('LOG2E',v,[]);

 v:=BESENNumberValue(0.4342944819032518);
 OverwriteData('LOG10E',v,[]);

 v:=BESENNumberValue(3.1415926535897932);
 OverwriteData('PI',v,[]);

 v:=BESENNumberValue(0.7071067811865476);
 OverwriteData('SQRT1_2',v,[]);

 v:=BESENNumberValue(1.4142135623730951);
 OverwriteData('SQRT2',v,[]);

 RegisterNativeFunction('abs',NativeAbs,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('acos',NativeACos,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('asin',NativeASin,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('atan',NativeATan,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('atan2',NativeATan2,2,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('ceil',NativeCeil,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('cos',NativeCos,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('exp',NativeExp,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('floor',NativeFloor,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('log',NativeLog,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('max',NativeMax,2,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('min',NativeMin,2,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('pow',NativePow,2,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('random',NativeRandom,0,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('round',NativeRound,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('sin',NativeSin,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('sqrt',NativeSqrt,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
 RegisterNativeFunction('tan',NativeTan,1,[bopaWRITABLE,bopaCONFIGURABLE],false);
end;

destructor TBESENObjectMath.Destroy;
begin
 inherited Destroy;
end;

procedure TBESENObjectMath.NativeAbs(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if not BESENIsNaN(ResultValue) then begin
   PBESENDoubleHiLo(@ResultValue)^.Hi:=PBESENDoubleHiLo(@ResultValue)^.Hi and $7fffffff;
  end;
 end;
end;

procedure TBESENObjectMath.NativeACos(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if not BESENIsNaN(ResultValue) then begin
   if (ResultValue<-1) or (ResultValue>1) then begin
    int64(pointer(@ResultValue)^):=int64(pointer(@BESENDoubleNaN)^);
   end else if ResultValue=1 then begin
    ResultValue:=BESENNumberValue(0.0);
   end else begin
    ResultValue:=BESENNumberValue(arccos(ResultValue));
   end;
  end;
 end;
end;

procedure TBESENObjectMath.NativeASin(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if not BESENIsNaN(ResultValue) then begin
   if (ResultValue<-1) or (ResultValue>1) then begin
    int64(pointer(@ResultValue)^):=int64(pointer(@BESENDoubleNaN)^);
   end else if not BESENIsZero(ResultValue) then begin
    ResultValue:=BESENNumberValue(arcsin(ResultValue));
   end;
  end;
 end;
end;

procedure TBESENObjectMath.NativeATan(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if not (BESENIsNaN(ResultValue) or BESENIsZero(ResultValue)) then begin
   if BESENIsPosInfinite(ResultValue) then begin
    ResultValue:=BESENNumberValue(PI*0.5);
   end else if BESENIsNegInfinite(ResultValue) then begin
    ResultValue:=BESENNumberValue(-(PI*0.5));
   end else begin
    ResultValue:=BESENNumberValue(arctan(ResultValue));
   end;
  end;
 end;
end;

procedure TBESENObjectMath.NativeATan2(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
var x,y:TBESENNumber;
begin
 if CountArguments<2 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  y:=TBESEN(Instance).ToNum(Arguments^[0]^);
  x:=TBESEN(Instance).ToNum(Arguments^[1]^);
  if BESENIsNaN(y) or BESENIsNaN(x) then begin
   ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
  end else if (y>0) and BESENIsZero(x) then begin
   ResultValue:=BESENNumberValue(PI*0.5);
  end else if BESENIsPosZero(y) and ((x>0) or BESENIsPosZero(x)) then begin
   ResultValue:=BESENNumberValue(0.0);
  end else if BESENIsPosZero(y) and (BESENIsNegZero(x) or (x<0)) then begin
   ResultValue:=BESENNumberValue(PI)
  end else if BESENIsNegZero(y) and ((BESENIsFinite(x) and not BESENIsNegative(x)) or BESENIsPosZero(x)) then begin
   ResultValue:=BESENNumberValue(0.0);
   PBESENDoubleHiLo(@ResultValue)^.Hi:=PBESENDoubleHiLo(@ResultValue)^.Hi or $80000000;
  end else if BESENIsNegZero(y) and (BESENIsNegZero(x) or (x<0)) then begin
   ResultValue:=BESENNumberValue(-PI)
  end else if (y<0) and BESENIsZero(x) then begin
   ResultValue:=BESENNumberValue(-PI*0.5)
  end else if ((y>0) and BESENIsFinite(y)) and BESENIsPosInfinite(x) then begin
   ResultValue:=BESENNumberValue(0.0);
  end else if ((y>0) and BESENIsFinite(y)) and BESENIsNegInfinite(x) then begin
   ResultValue:=BESENNumberValue(PI);
  end else if ((y<0) and BESENIsFinite(y)) and BESENIsPosInfinite(x) then begin
   ResultValue:=BESENNumberValue(0.0);
   PBESENDoubleHiLo(@ResultValue)^.Hi:=PBESENDoubleHiLo(@ResultValue)^.Hi or $80000000;
  end else if ((y<0) and BESENIsFinite(y)) and BESENIsNegInfinite(x) then begin
   ResultValue:=BESENNumberValue(-PI);
  end else if BESENIsPosInfinite(y) and BESENIsFinite(x) then begin
   ResultValue:=BESENNumberValue(PI*0.5);
  end else if BESENIsNegInfinite(y) and BESENIsFinite(x) then begin
   ResultValue:=BESENNumberValue(-(PI*0.5));
  end else if BESENIsPosInfinite(y) and BESENIsPosInfinite(x) then begin
   ResultValue:=BESENNumberValue(PI*0.25);
  end else if BESENIsPosInfinite(y) and BESENIsNegInfinite(x) then begin
   ResultValue:=BESENNumberValue((3*PI)*0.25);
  end else if BESENIsNegInfinite(y) and BESENIsPosInfinite(x) then begin
   ResultValue:=BESENNumberValue(-(PI*0.25));
  end else if BESENIsNegInfinite(y) and BESENIsNegInfinite(x) then begin
   ResultValue:=BESENNumberValue(-((3*PI)*0.25));
  end else begin
   ResultValue:=BESENNumberValue(arctan2(y,x));
  end;
 end;
end;

procedure TBESENObjectMath.NativeCeil(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if not (BESENIsNaN(ResultValue) or BESENIsInfinite(ResultValue) or BESENIsZero(ResultValue)) then begin
   if (ResultValue<0.0) and (ResultValue>(-1.0)) then begin
    ResultValue:=BESENNumberValue(0.0);
    PBESENDoubleHiLo(@ResultValue)^.Hi:=PBESENDoubleHiLo(@ResultValue)^.Hi or $80000000;
   end else begin
    ResultValue:=BESENNumberValue(BESENCeil(BESENValueNumber(ResultValue)));
   end;
  end;
 end;
end;

procedure TBESENObjectMath.NativeCos(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if BESENIsNaN(ResultValue) or BESENIsInfinite(ResultValue) then begin
   ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
  end else if BESENIsZero(ResultValue) then begin
   ResultValue:=BESENNumberValue(1.0);
  end else begin
   ResultValue:=BESENNumberValue(cos(BESENValueNumber(ResultValue)));
  end;
 end;
end;

procedure TBESENObjectMath.NativeExp(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if BESENIsNaN(ResultValue) then begin
   ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
  end else if BESENIsZero(ResultValue) then begin
   ResultValue:=BESENNumberValue(1.0);
  end else if BESENIsPosInfinite(ResultValue) then begin
   ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleInfPos)^));
  end else if BESENIsNegInfinite(ResultValue) then begin
   ResultValue:=BESENNumberValue(0.0);
  end else begin
   ResultValue:=BESENNumberValue(exp(BESENValueNumber(ResultValue)));
  end;
 end;
end;

procedure TBESENObjectMath.NativeFloor(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if not (BESENIsNaN(ResultValue) or BESENIsInfinite(ResultValue) or BESENIsZero(ResultValue)) then begin
   if (ResultValue>0.0) and (ResultValue<1.0) then begin
    ResultValue:=BESENNumberValue(0.0);
   end else begin
    ResultValue:=BESENNumberValue(BESENFloor(BESENValueNumber(ResultValue)));
   end;
  end;
 end;
end;

procedure TBESENObjectMath.NativeLog(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if BESENIsNaN(ResultValue) or (ResultValue<0) then begin
   ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleNaN)^));
  end else if BESENIsZero(ResultValue) then begin
   ResultValue:=BESENNumberValue(TBESENNumber(pointer(@BESENDoubleInfNeg)^));
  end else if ResultValue=1 then begin
   ResultValue:=0;
  end else if BESENIsPosInfinite(ResultValue) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleInfPos)^);
  end else begin
   ResultValue:=ln(ResultValue);
  end;
 end;
end;

procedure TBESENObjectMath.NativeMax(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
var x,n:TBESENNumber;
    i:integer;
begin
 if CountArguments=0 then begin
  ResultValue:=TBESENNumber(pointer(@BESENDoubleInfNeg)^);
 end else begin
  n:=TBESENNumber(pointer(@BESENDoubleInfNeg)^);
  for i:=0 to CountArguments-1 do begin
   x:=TBESEN(Instance).ToNum(Arguments^[i]^);
   if BESENIsNaN(x) then begin
    n:=TBESENNumber(pointer(@BESENDoubleNaN)^);
    break;
   end;
   if (i=0) or ((x>n) or (BESENIsPosInfinite(x) or (BESENIsPosZero(x) and BESENIsNegZero(n)))) then begin
    n:=x;
   end;
  end;
  ResultValue:=n;
 end;
end;

procedure TBESENObjectMath.NativeMin(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
var x,n:TBESENNumber;
    i:integer;
begin
 if CountArguments=0 then begin
  ResultValue:=TBESENNumber(pointer(@BESENDoubleInfPos)^);
 end else begin
  n:=TBESENNumber(pointer(@BESENDoubleInfPos)^);
  for i:=0 to CountArguments-1 do begin
   x:=TBESEN(Instance).ToNum(Arguments^[i]^);
   if BESENIsNaN(x) then begin
    n:=TBESENNumber(pointer(@BESENDoubleNaN)^);
    break;
   end;
   if (i=0) or ((x<n) or (BESENIsNegInfinite(x) or (BESENIsNegZero(x) and BESENIsPosZero(n)))) then begin
    n:=x;
   end;
  end;
  ResultValue:=n;
 end;
end;

procedure TBESENObjectMath.NativePow(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
var x,y:TBESENNumber;
begin
 if CountArguments<2 then begin
  ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
 end else begin
  x:=TBESEN(Instance).ToNum(Arguments^[0]^);
  y:=TBESEN(Instance).ToNum(Arguments^[1]^);
  if BESENIsNaN(y) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
  end else if BESENIsZero(y) then begin
   ResultValue:=1;
  end else if BESENIsNaN(x) and not BESENIsZero(y) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
  end else if (abs(x)>1) and BESENIsPosInfinite(y) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleInfPos)^);
  end else if (abs(x)>1) and BESENIsNegInfinite(y) then begin
   ResultValue:=0;
  end else if (abs(x)=1) and BESENIsInfinite(y) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
  end else if (abs(x)<1) and BESENIsPosInfinite(y) then begin
   ResultValue:=0;
  end else if (abs(x)<1) and BESENIsNegInfinite(y) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleInfPos)^);
  end else if BESENIsPosInfinite(x) and (y>0) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleInfPos)^);
  end else if BESENIsPosInfinite(x) and (y<0) then begin
   ResultValue:=0;
  end else if BESENIsNegInfinite(x) and (y>0) then begin
   y:=abs(BESENModulo(y,2.0));
   if y=1 then begin
    ResultValue:=TBESENNumber(pointer(@BESENDoubleInfNeg)^);
   end else begin
    ResultValue:=TBESENNumber(pointer(@BESENDoubleInfPos)^);
   end;
  end else if BESENIsNegInfinite(x) and (y<0) then begin
   y:=abs(BESENModulo(-y,2.0));
   ResultValue:=0;
   if y=1 then begin
    PBESENDoubleHiLo(@ResultValue)^.Hi:=PBESENDoubleHiLo(@ResultValue)^.Hi or $80000000;
   end;
  end else if BESENIsPosZero(x) and (y>0) then begin
   ResultValue:=0;
  end else if BESENIsPosZero(x) and (y<0) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleInfPos)^);
  end else if BESENIsNegZero(x) and (y>0) then begin
   y:=abs(BESENModulo(-y,2.0));
   ResultValue:=0;
   if y=1 then begin
    PBESENDoubleHiLo(@ResultValue)^.Hi:=PBESENDoubleHiLo(@ResultValue)^.Hi or $80000000;
   end;
  end else if BESENIsNegZero(x) and (y<0) then begin
   y:=abs(BESENModulo(y,2.0));
   if y=1 then begin
    ResultValue:=TBESENNumber(pointer(@BESENDoubleInfNeg)^);
   end else begin
    ResultValue:=TBESENNumber(pointer(@BESENDoubleInfPos)^);
   end;
  end else if ((x<0) and BESENIsFinite(x)) and (BESENIsFinite(y) and not BESENIsZero(frac(y))) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
  end else begin
   ResultValue:=power(x,y);
  end;
 end;
end;

procedure TBESENObjectMath.NativeRandom(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 ResultValue:=TBESEN(Instance).RandomGenerator.GetNumber;
end;

procedure TBESENObjectMath.NativeRound(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if BESENIsNaN(ResultValue) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
  end else if not (BESENIsZero(ResultValue) or BESENIsInfinite(ResultValue)) then begin
   if (ResultValue>=-0.5) and (ResultValue<0) then begin
    ResultValue:=0;
    PBESENDoubleHiLo(@ResultValue)^.Hi:=PBESENDoubleHiLo(@ResultValue)^.Hi or $80000000;
   end else if (ResultValue>0) and (ResultValue<0.5) then begin
    ResultValue:=0;
   end else begin
    ResultValue:=BESENFloor(ResultValue+0.5);
   end;
  end;
 end;
end;

procedure TBESENObjectMath.NativeSin(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if BESENIsNaN(ResultValue) or BESENIsInfinite(ResultValue) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
  end else if not BESENIsZero(ResultValue) then begin
   ResultValue:=sin(ResultValue);
  end;
 end;
end;

procedure TBESENObjectMath.NativeSqrt(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
 end else begin
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if BESENIsNaN(ResultValue) or BESENIsNegative(ResultValue) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
  end else if not (BESENIsZero(ResultValue) or BESENIsPosInfinite(ResultValue)) then begin
   ResultValue:=sqrt(ResultValue);
  end;
 end;
end;

procedure TBESENObjectMath.NativeTan(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
begin
 if CountArguments=0 then begin
  ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
 end else begin                                                                       
  TBESEN(Instance).ToNumberValue(Arguments^[0]^,ResultValue);
  if BESENIsNaN(ResultValue) or BESENIsInfinite(ResultValue) then begin
   ResultValue:=TBESENNumber(pointer(@BESENDoubleNaN)^);
  end else if not BESENIsZero(ResultValue) then begin
   ResultValue:=tan(ResultValue);
  end;
 end;
end;

end.
