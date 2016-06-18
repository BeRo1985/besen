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
unit BESENValue;
{$i BESEN.inc}

interface

uses BESENConstants,BESENTypes,BESENStringUtils,BESENCharSet,Variants,BESENGarbageCollector;

const brbvtUNDEFINED=0;
      brbvtBOOLEAN=1;
      brbvtNUMBER=2;
      brbvtSTRING=3;
      brbvtOBJECT=4;
      brbvtENVREC=5;

      brbvtFIRST=brbvtUNDEFINED;
      brbvtLAST=brbvtENVREC;
                                
      BESENValueSignalingNaNMask=TBESENUInt64($7ff8000000000000);
      BESENValueSignalingNaNMaskValue=TBESENUInt64($7ff0000000000000);
      BESENValueSignalingNaNMantissaMask=TBESENUInt64($0007ffffffffffff);
      BESENValueSignalingNaNValueTypeMask=TBESENUInt64($0007000000000000);
      BESENValueSignalingNaNValueTypeShift=48;
      BESENValueSignalingNaNValueTypeShiftMask=7;
      BESENValueSignalingNaNValueTagMask=TBESENUInt64($0000ffffffffffff);

type PBESENValueType=^TBESENValueType;
     TBESENValueType=(
      bvtUNDEFINED=0,
      bvtNULL=1,
      bvtBOOLEAN=2,
      bvtSTRING=3,
      bvtOBJECT=4,
      bvtREFERENCE=5,
      bvtLOCAL=6,
      bvtENVREC=7,
      ////////////
      bvtNUMBER=8,  // must be after 7, because all other values must be inside the 3-bit 0..7 range, for the NaN-boxing
      ////////////
      bvtFIRST=bvtUNDEFINED,
      bvtLAST=bvtNUMBER
     );

const BESENUndefinedValueRaw=TBESENUInt64(BESENValueSignalingNaNMaskValue or (TBESENUInt64(TBESENUInt32(bvtUNDEFINED)) shl BESENValueSignalingNaNValueTypeShift) or BESENValueSignalingNaNValueTagMask);
      BESENNullValueRaw=TBESENUInt64(BESENValueSignalingNaNMaskValue or (TBESENUInt64(TBESENUInt32(bvtNULL)) shl BESENValueSignalingNaNValueTypeShift) or BESENValueSignalingNaNValueTagMask);
      BESENNoneValueRaw=TBESENUInt64(UInt64($8000000000000000) or BESENValueSignalingNaNMaskValue or (TBESENUInt64(TBESENUInt32(bvtUNDEFINED)) shl BESENValueSignalingNaNValueTypeShift) or BESENValueSignalingNaNValueTagMask);

type TBESENReferenceBaseValueType=ptruint;

     PBESENReferenceBaseValue=^TBESENReferenceBaseValue;
     TBESENReferenceBaseValue=record
      Str:TBESENString;
{$ifdef BESENEmbarcaderoNextGen}
      Obj:TObject;
      EnvRec:TObject;
{$endif}
      case ValueType:TBESENReferenceBaseValueType of
       brbvtUNDEFINED:(
       );
       brbvtBOOLEAN:(
        Bool:TBESENBoolean;
       );
       brbvtNUMBER:(
        Num:TBESENNumber;
       );
       brbvtSTRING:(
       );
       brbvtOBJECT:(
{$ifndef BESENEmbarcaderoNextGen}
        Obj:TObject;
{$endif}
       );
       brbvtENVREC:(
{$ifndef BESENEmbarcaderoNextGen}
        EnvRec:TObject;
{$endif}
       );
     end;

     TBESENValueString=class(TBESENGarbageCollectorObject)
      public
       Str:TBESENString;
     end;

     TBESENValueReference=class(TBESENGarbageCollectorObject)
      public
       ReferenceBase:double;
       ReferenceIsStrict:longbool;
       ReferenceHash:TBESENHash;
       ReferenceIndex:TBESENINT32;
       ReferenceID:TBESENINT32;
     end;

     TBESENValueTypes=array of TBESENValueType;

     TBESENValueTypesItems=array of TBESENValueTypes;

     TBESENValues=array of TBESENValue;

     TBESENValuePointers=array of PBESENValue;

     PPBESENValues=^TPBESENValues;
     TPBESENValues=array[0..($7fffffff div sizeof(PBESENValue))-1] of PBESENValue;

     TBESENPointerToValues=array of PBESENValue;

     TBESENCopyReferenceBaseValueProc=procedure(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}

     TBESENCopyReferenceBaseValueProcs=array[brbvtFIRST..brbvtLAST] of TBESENCopyReferenceBaseValueProc;

     TBESENCopyValueProc=procedure(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}

     TBESENCopyValueProcs=array[bvtFIRST..bvtLAST] of TBESENCopyValueProc;

     TBESENValueToRefBaseValueProc=procedure(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}

     TBESENValueToRefBaseValueProcs=array[bvtFIRST..bvtLAST] of TBESENValueToRefBaseValueProc;

     TBESENRefBaseValueToValueProc=procedure(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}

     TBESENRefBaseValueToValueProcs=array[brbvtFIRST..brbvtLAST] of TBESENRefBaseValueToValueProc;

     TBESENRefBaseValueToCallThisArgValueProc=procedure(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue);

     TBESENRefBaseValueToCallThisArgValueProcs=array[brbvtFIRST..brbvtLAST] of TBESENRefBaseValueToCallThisArgValueProc;

function BESENValueType(const v:TBESENValue):TBESENValueType; {$ifdef caninline}inline;{$endif}
function BESENValueTag(const v:TBESENValue):TBESENUInt64; {$ifdef caninline}inline;{$endif}
function BESENValueNumber(const v:TBESENValue):TBESENNumber; {$ifdef caninline}inline;{$endif}
function BESENValueBoolean(const v:TBESENValue):longbool; {$ifdef caninline}inline;{$endif}
function BESENValuePointer(const v:TBESENValue):pointer; {$ifdef caninline}inline;{$endif}
function BESENValueString(const v:TBESENValue):TBESENString; {$ifdef caninline}inline;{$endif}
function BESENValueObject(const v:TBESENValue):pointer; {$ifdef caninline}inline;{$endif}
function BESENValueReference(const v:TBESENValue):TBESENValueReference; {$ifdef caninline}inline;{$endif}

procedure BESENCopyReferenceBaseValueUndefined(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyReferenceBaseValueBoolean(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyReferenceBaseValueNumber(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyReferenceBaseValueString(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyReferenceBaseValueObject(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyReferenceBaseValueEnvRec(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyReferenceBaseValueNone(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}

procedure BESENCopyReferenceBaseValue(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}

procedure BESENCopyValueUndefined(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyValueNull(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyValueBoolean(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyValueNumber(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyValueString(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyValueObject(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyValueReference(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyValueLocal(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyValueEnvRec(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENCopyValueNone(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}

procedure BESENCopyValue(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}

procedure BESENValueToRefBaseValueUndefined(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENValueToRefBaseValueNull(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENValueToRefBaseValueBoolean(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENValueToRefBaseValueNumber(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENValueToRefBaseValueString(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENValueToRefBaseValueObject(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENValueToRefBaseValueReference(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENValueToRefBaseValueLocal(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENValueToRefBaseValueEnvRec(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
procedure BESENValueToRefBaseValueNone(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}

procedure BESENValueToReferenceBaseValue(const Value:TBESENValue;var AResult:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}

procedure BESENRefBaseValueToValueUndefined(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToValueBoolean(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToValueNumber(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToValueString(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToValueObject(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToValueEnvRec(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}

procedure BESENReferenceBaseValueToValue(const Value:TBESENReferenceBaseValue;var AResult:TBESENValue); {$ifdef UseRegister}register;{$endif}

procedure BESENRefBaseValueToCallThisArgValueUndefined(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToCallThisArgValueBoolean(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToCallThisArgValueNumber(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToCallThisArgValueString(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToCallThisArgValueObject(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
procedure BESENRefBaseValueToCallThisArgValueEnvRec(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}

const BESENCopyReferenceBaseValueProcs:TBESENCopyReferenceBaseValueProcs=(BESENCopyReferenceBaseValueUndefined,
                                                                          BESENCopyReferenceBaseValueBoolean,
                                                                          BESENCopyReferenceBaseValueNumber,
                                                                          BESENCopyReferenceBaseValueString,
                                                                          BESENCopyReferenceBaseValueObject,
                                                                          BESENCopyReferenceBaseValueEnvRec);

      BESENCopyValueProcs:TBESENCopyValueProcs=(BESENCopyValueUndefined,
                                                BESENCopyValueNull,
                                                BESENCopyValueBoolean,
                                                BESENCopyValueNumber,
                                                BESENCopyValueString,
                                                BESENCopyValueObject,
                                                BESENCopyValueReference,
                                                BESENCopyValueLocal,
                                                BESENCopyValueEnvRec);

      BESENValueToRefBaseValueProcs:TBESENValueToRefBaseValueProcs=(BESENValueToRefBaseValueUndefined,
                                                                    BESENValueToRefBaseValueNull,
                                                                    BESENValueToRefBaseValueBoolean,
                                                                    BESENValueToRefBaseValueNumber,
                                                                    BESENValueToRefBaseValueString,
                                                                    BESENValueToRefBaseValueObject,
                                                                    BESENValueToRefBaseValueReference,
                                                                    BESENValueToRefBaseValueLocal,
                                                                    BESENValueToRefBaseValueEnvRec);

      BESENRefBaseValueToValueProcs:TBESENRefBaseValueToValueProcs=(BESENRefBaseValueToValueUndefined,
                                                                    BESENRefBaseValueToValueBoolean,
                                                                    BESENRefBaseValueToValueNumber,
                                                                    BESENRefBaseValueToValueString,
                                                                    BESENRefBaseValueToValueObject,
                                                                    BESENRefBaseValueToValueEnvRec);

      BESENRefBaseValueToCallThisArgValueProcs:TBESENRefBaseValueToCallThisArgValueProcs=(BESENRefBaseValueToCallThisArgValueUndefined,
                                                                                          BESENRefBaseValueToCallThisArgValueBoolean,
                                                                                          BESENRefBaseValueToCallThisArgValueNumber,
                                                                                          BESENRefBaseValueToCallThisArgValueString,
                                                                                          BESENRefBaseValueToCallThisArgValueObject,
                                                                                          BESENRefBaseValueToCallThisArgValueEnvRec);

function BESENValueToVariant(const v:TBESENValue):Variant;
procedure BESENVariantToValue(const vt:Variant;var v:TBESENValue);

function BESENBooleanValue(const Bool:TBESENBoolean):TBESENValue; {$ifdef caninline}inline;{$endif}
function BESENNumberValue(const Num:TBESENNumber):TBESENValue; {$ifdef caninline}inline;{$endif}
function BESENStringValue(const Str:TBESENString):TBESENValue;
{$ifndef BESENSingleStringType}
function BESENStringLocaleCharsetValue(const Str:TBESENAnsiString):TBESENValue;
{$endif}
function BESENObjectValue(const Obj:TObject):TBESENValue; {$ifdef caninline}inline;{$endif}
function BESENObjectValueEx(const Obj:TObject):TBESENValue; {$ifdef caninline}inline;{$endif}

function BESENEqualityExpressionStrictEquals(const a,b:TBESENValue):longbool;

var BESENEmptyValue:TBESENValue;
    BESENNullValue:TBESENValue;
    BESENUndefinedValue:TBESENValue;
    BESENDummyValue:TBESENValue;

implementation

uses BESEN,BESENNumberUtils,BESENEnvironmentRecord;

function BESENValueType(const v:TBESENValue):TBESENValueType; {$ifdef caninline}inline;{$endif}
begin
 if (TBESENUInt64(pointer(@v)^) and BESENValueSignalingNaNMask)=BESENValueSignalingNaNMaskValue) and
    (TBESENUInt64(pointer(@v)^) and BESENValueSignalingNaNMantissaMask)<>0) then begin
  result:=TBESENValueType(TBESENInt32(TBESENUInt32(TBESENUInt64(pointer(@v)^) shr BESENValueSignalingNaNValueTypeShift) and BESENValueSignalingNaNValueTypeShiftMask));
 end else begin
  result:=bvtNUMBER;
 end;
end;

function BESENValueTag(const v:TBESENValue):TBESENUInt64; {$ifdef caninline}inline;{$endif}
begin
 result:=TBESENUInt64(pointer(@v)^) and BESENValueSignalingNaNValueTagMask;
end;

function BESENValueNumber(const v:TBESENValue):TBESENNumber; {$ifdef caninline}inline;{$endif}
begin
 result:=v;
end;

function BESENValueBoolean(const v:TBESENValue):longbool; {$ifdef caninline}inline;{$endif}
begin
 result:=longbool(longword(TBESENUInt64(pointer(@v)^) and BESENValueSignalingNaNValueTagMask));
end;

function BESENValuePointer(const v:TBESENValue):pointer; {$ifdef caninline}inline;{$endif}
begin
 result:=pointer(TBESENPtrUInt(TBESENUInt64(pointer(@v)^) and BESENValueSignalingNaNValueTagMask));
end;

function BESENValueString(const v:TBESENValue):TBESENString; {$ifdef caninline}inline;{$endif}
begin
 result:='';
// result:=pointer(TBESENPtrUInt(TBESENUInt64(pointer(@v)^) and BESENValueSignalingNaNValueTagMask));
end;

function BESENValueObject(const v:TBESENValue):pointer; {$ifdef caninline}inline;{$endif}
begin
 result:=pointer(TBESENPtrUInt(TBESENUInt64(pointer(@v)^) and BESENValueSignalingNaNValueTagMask));
end;

function BESENValueReference(const v:TBESENValue):TBESENValueReference; {$ifdef caninline}inline;{$endif}
begin
 result:=pointer(TBESENPtrUInt(TBESENUInt64(pointer(@v)^) and BESENValueSignalingNaNValueTagMask));
end;

procedure BESENCopyReferenceBaseValueUndefined(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtUNDEFINED;
end;

procedure BESENCopyReferenceBaseValueBoolean(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtBOOLEAN;
 Dest.Bool:=Src.Bool;
end;

procedure BESENCopyReferenceBaseValueNumber(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtNUMBER;
 Dest.Num:=Src.Num;
end;

procedure BESENCopyReferenceBaseValueString(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtSTRING;
 Dest.Str:=Src.Str;
end;

procedure BESENCopyReferenceBaseValueObject(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtOBJECT;
 Dest.Obj:=Src.Obj;
end;

procedure BESENCopyReferenceBaseValueEnvRec(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtENVREC;
 Dest.EnvRec:=Src.EnvRec;
end;

procedure BESENCopyReferenceBaseValueNone(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtNONE;
end;

procedure BESENCopyReferenceBaseValue(var Dest:TBESENReferenceBaseValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 BESENCopyReferenceBaseValueProcs[Src.ValueType](Dest,Src);
end;

procedure BESENCopyValueUndefined(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtUNDEFINED;
end;

procedure BESENCopyValueNull(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtNULL;
end;

procedure BESENCopyValueBoolean(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtBOOLEAN;
 Dest.Bool:=Src.Bool;
end;

procedure BESENCopyValueNumber(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtNUMBER;
 Dest.Num:=Src.Num;
end;

procedure BESENCopyValueString(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtSTRING;
 Dest.Str:=Src.Str;
end;

procedure BESENCopyValueObject(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtOBJECT;
 Dest.Obj:=Src.Obj;
end;

procedure BESENCopyValueReference(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtREFERENCE;
 BESENCopyReferenceBaseValue(Dest.ReferenceBase,Src.ReferenceBase);
 Dest.Str:=Src.Str;
 Dest.ReferenceIsStrict:=Src.ReferenceIsStrict;
 Dest.ReferenceHash:=Src.ReferenceHash;
 Dest.ReferenceIndex:=Src.ReferenceIndex;
 Dest.ReferenceID:=Src.ReferenceID;
end;

procedure BESENCopyValueLocal(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtLOCAL;
 Dest.LocalIndex:=Src.LocalIndex;
end;

procedure BESENCopyValueEnvRec(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtENVREC;
 Dest.EnvRec:=Src.EnvRec;
end;

procedure BESENCopyValueNone(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtNONE;
end;

procedure BESENCopyValue(var Dest:TBESENValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 BESENCopyValueProcs[Src.ValueType](Dest,Src);
end;

procedure BESENValueToRefBaseValueUndefined(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtUNDEFINED;
end;

procedure BESENValueToRefBaseValueNull(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtUNDEFINED;
end;

procedure BESENValueToRefBaseValueBoolean(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtBOOLEAN;
 Dest.Bool:=Src.Bool;
end;

procedure BESENValueToRefBaseValueNumber(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtNUMBER;
 Dest.Num:=Src.Num;
end;

procedure BESENValueToRefBaseValueString(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtSTRING;
 Dest.Str:=Src.Str;
end;

procedure BESENValueToRefBaseValueObject(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtOBJECT;
 Dest.Obj:=Src.Obj;
end;

procedure BESENValueToRefBaseValueReference(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtUNDEFINED;
end;

procedure BESENValueToRefBaseValueLocal(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtUNDEFINED;
end;

procedure BESENValueToRefBaseValueEnvRec(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtENVREC;
 Dest.EnvRec:=Src.EnvRec;
end;

procedure BESENValueToRefBaseValueNone(var Dest:TBESENReferenceBaseValue;const Src:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=brbvtUNDEFINED;
end;

procedure BESENValueToReferenceBaseValue(const Value:TBESENValue;var AResult:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 BESENValueToRefBaseValueProcs[Value.ValueType](AResult,Value);
end;

procedure BESENRefBaseValueToValueUndefined(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtUNDEFINED;
end;

procedure BESENRefBaseValueToValueBoolean(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtBOOLEAN;
 Dest.Bool:=Src.Bool;
end;

procedure BESENRefBaseValueToValueNumber(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtNUMBER;
 Dest.Num:=Src.Num;
end;

procedure BESENRefBaseValueToValueString(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtSTRING;
 Dest.Str:=Src.Str;
end;

procedure BESENRefBaseValueToValueObject(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtOBJECT;
 Dest.Obj:=Src.Obj;
end;

procedure BESENRefBaseValueToValueEnvRec(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtENVREC;
 Dest.EnvRec:=Src.EnvRec;
end;

procedure BESENReferenceBaseValueToValue(const Value:TBESENReferenceBaseValue;var AResult:TBESENValue); {$ifdef UseRegister}register;{$endif}
begin
 BESENRefBaseValueToValueProcs[Value.ValueType](AResult,Value);
end;

procedure BESENRefBaseValueToCallThisArgValueUndefined(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtUNDEFINED;
end;

procedure BESENRefBaseValueToCallThisArgValueBoolean(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtBOOLEAN;
 Dest.Bool:=Src.Bool;
end;

procedure BESENRefBaseValueToCallThisArgValueNumber(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtNUMBER;
 Dest.Num:=Src.Num;
end;

procedure BESENRefBaseValueToCallThisArgValueString(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtSTRING;
 Dest.Str:=Src.Str;
end;

procedure BESENRefBaseValueToCallThisArgValueObject(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
begin
 Dest.ValueType:=bvtOBJECT;
 Dest.Obj:=Src.Obj;
end;

procedure BESENRefBaseValueToCallThisArgValueEnvRec(var Dest:TBESENValue;const Src:TBESENReferenceBaseValue); {$ifdef UseRegister}register;{$endif}
var ImplicitThisValue:PBESENValue;
begin
 ImplicitThisValue:=@TBESENEnvironmentRecord(Src.EnvRec).ImplicitThisValue;
 Dest.ValueType:=ImplicitThisValue.ValueType;
 Dest.Obj:=ImplicitThisValue.Obj;
end;

function BESENValueToVariant(const v:TBESENValue):Variant;
begin
 case v.ValueType of
  bvtNULL:begin
   result:=Variants.Null;
  end;
  bvtBOOLEAN:begin
   result:=V.Bool;
  end;
  bvtSTRING:begin
   result:=V.Str;
  end;
  bvtNUMBER:begin
   result:=V.Num;
  end;
  else begin
   result:=Variants.Unassigned;
  end;
 end;
end;

procedure BESENVariantToValue(const vt:Variant;var v:TBESENValue);
begin
 try
  case VarType(vt) of
   varNull:begin
    V.ValueType:=bvtNULL;
   end;
   varSmallInt,varInteger,varShortInt,varByte,varWord,varLongWord,varInt64{$ifdef fpc},varQWord{$endif}:begin
    V.ValueType:=bvtNUMBER;
    V.Num:=vt;
   end;
   varSingle,varDouble,varDATE,varCurrency:begin
    V.ValueType:=bvtNUMBER;
    V.Num:=vt;
   end;
   varBoolean:begin
    V.ValueType:=bvtBOOLEAN;
    V.Bool:=vt;
   end;
   varString,varOleStr:begin
    V.ValueType:=bvtSTRING;
    V.Str:=vt;
   end;
   else begin
    V.ValueType:=bvtUNDEFINED;
   end;
  end;
 except
  V.ValueType:=bvtUNDEFINED;
 end;
end;

function BESENBooleanValue(const Bool:TBESENBoolean):TBESENValue;
begin
 result.ValueType:=bvtBOOLEAN;
 result.Bool:=Bool;
end;

function BESENNumberValue(const Num:TBESENNumber):TBESENValue;
begin
 result.ValueType:=bvtNUMBER;
 result.Num:=Num;
end;

function BESENStringValue(const Str:TBESENString):TBESENValue;
begin
 result.ValueType:=bvtSTRING;
 result.Str:=Str;
end;

{$ifndef BESENSingleStringType}
function BESENStringLocaleCharsetValue(const Str:TBESENAnsiString):TBESENValue;
begin
 result.ValueType:=bvtSTRING;
 result.Str:=BESENUTF8ToUTF16(BESENEncodeString(Str,BESENLocaleCharset,UTF_8));
end;
{$endif}

function BESENObjectValue(const Obj:TObject):TBESENValue; {$ifdef caninline}inline;{$endif}
begin
 result.ValueType:=bvtOBJECT;
 result.Obj:=Obj;
end;

function BESENObjectValueEx(const Obj:TObject):TBESENValue; {$ifdef caninline}inline;{$endif}
begin
 if assigned(Obj) then begin
  result.ValueType:=bvtOBJECT;
  result.Obj:=Obj;
 end else begin
  result:=BESENNullValue;
 end;
end;

function BESENObjectValueEx2(const Obj:TObject):TBESENValue; {$ifdef caninline}inline;{$endif}
begin
 if assigned(Obj) then begin
  result.ValueType:=bvtOBJECT;
  result.Obj:=Obj;
 end else begin
  result:=BESENUndefinedValue;
 end;
end;

function BESENEqualityExpressionStrictEquals(const a,b:TBESENValue):longbool;
begin
 if a.ValueType<>b.ValueType then begin
  result:=false;
 end else begin
  case a.ValueType of
   bvtUNDEFINED:begin
    result:=true;
   end;
   bvtNULL:begin
    result:=true;
   end;
   bvtNUMBER:begin
{$ifdef UseSafeOperations}
    if BESENIsNaN(a.Num) then begin
     result:=false;
    end else if BESENIsNaN(b.Num) then begin
     result:=false;
    end else begin
     result:=(a.Num=b.Num) or (BESENIsZero(a.Num) and BESENIsZero(b.Num));
    end;
{$else}
    result:=(not (BESENIsNaN(a.Num) or BESENIsNaN(b.Num))) and (a.Num=b.Num);
{$endif}
   end;
   bvtSTRING:begin
    result:=a.Str=b.Str;
   end;
   bvtBOOLEAN:begin
    result:=a.Bool=b.Bool;
   end;
   bvtOBJECT:begin
    result:=a.Obj=b.Obj;
   end;
   else begin
    result:=false;
   end;
  end;
 end;
end;

procedure InitBESEN;
begin
 TBESENUInt64(pointer(@BESENEmptyValue)^):=BESENUndefinedValueRaw;
 TBESENUInt64(pointer(@BESENNullValue)^):=BESENNullValueRaw;
 TBESENUInt64(pointer(@BESENUndefinedValue)^):=BESENUndefinedValueRaw;
 TBESENUInt64(pointer(@BESENDummyValue)^):=BESENUndefinedValueRaw;
end;

procedure DoneBESEN;
begin
end;

initialization
 InitBESEN;
finalization
 DoneBESEN;
end.
