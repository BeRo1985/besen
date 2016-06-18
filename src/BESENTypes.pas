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
unit BESENTypes;
{$i BESEN.inc}

interface

uses BESENConstants;

type{$ifdef BESENSingleStringType}
     TBESENCHAR=widechar;

     PBESENCHAR=pwidechar;
{$else}
     TBESENCHAR=ansichar;

     PBESENCHAR=pansichar;
{$endif}

     TBESENWIDECHAR=widechar;

     PBESENWIDECHAR=pwidechar;

     PBESENByte=^byte;

{$ifdef BESENSingleStringType}
{$ifdef BESENEmbarcaderoNextGen}
     WideString=UnicodeString;
{$endif}
{$else}
     TBESENANSISTRING=ansistring;

     TBESENUTF8STRING=TBESENANSISTRING;
{$endif}

     TBESENUTF16STRING=widestring;

     TBESENUTF32CHAR=longword;

     PBESENUTF32CHARS=^TBESENUTF32CHARS;
     TBESENUTF32CHARS=array[0..($7fffffff div sizeof(TBESENUTF32CHAR))-1] of TBESENUTF32CHAR;

     TBESENUTF32STRING=array of TBESENUTF32CHAR;

{$ifdef fpc}
 {$undef OldDelphi}
{$else}
 {$ifdef conditionalexpressions}
  {$if CompilerVersion>=23.0}
   {$undef OldDelphi}
     qword=uint64;
     ptruint=NativeUInt;
     ptrint=NativeInt;
  {$else}
   {$define OldDelphi}
  {$ifend}
 {$else}
  {$define OldDelphi}
 {$endif}
{$endif}
{$ifdef OldDelphi}
     qword=int64;
{$ifdef cpu64}
     ptruint=qword;
     ptrint=int64;
{$else}
     ptruint=longword;
     ptrint=longint;
{$endif}
{$endif}

     PBESENInt8=^TBESENInt8;
     TBESENInt8={$ifdef fpc}Int8{$else}shortint{$endif};

     PBESENUInt8=^TBESENUInt8;
     TBESENUInt8={$ifdef fpc}UInt8{$else}byte{$endif};

     PBESENInt16=^TBESENInt16;
     TBESENInt16={$ifdef fpc}Int16{$else}smallint{$endif};

     PBESENUInt16=^TBESENUInt16;
     TBESENUInt16={$ifdef fpc}UInt16{$else}word{$endif};

     PBESENInt32=^TBESENInt32;
     TBESENInt32={$ifdef fpc}Int32{$else}longint{$endif};

     PBESENUInt32=^TBESENUInt32;
     TBESENUInt32={$ifdef fpc}UInt32{$else}longword{$endif};

     PBESENInt64=^TBESENInt64;
     TBESENInt64=Int64;

     PBESENUInt64=^TBESENUInt64;
     TBESENUInt64=UInt64;

     PBESENDouble=^TBESENDouble;
     TBESENDouble=Double;

     PBESENDoubleBytes=^TBESENDoubleBytes;
     TBESENDoubleBytes=array[0..SizeOf(TBESENDouble)-1] of byte;

     PBESENValue=^TBESENValue;
     TBESENValue=Double;
     
     TBESENParsingNumberType={$ifdef HAS_TYPE_EXTENDED}extended{$else}double{$endif};

     PBESENNumber=^TBESENNumber;
     TBESENNumber=TBESENDouble;

     TBESENBoolean=longbool;

     TBESENDate=TBESENNumber;

     PBESENString=^TBESENString;
     TBESENString=TBESENUTF16STRING;

     TBESENHash=TBESENUINT32;

     TBESENTarget=TBESENINT32;

     PBESENByteArray=^TBESENByteArray;
     TBESENByteArray=array[0..$7fffffff-2] of byte;

     PBESENUINT32Array=^TBESENUINT32Array;
     TBESENUINT32Array=array[0..($7fffffff div sizeof(TBESENUINT32))-1] of TBESENUINT32;

     PBESENINT32Array=^TBESENINT32Array;
     TBESENINT32Array=array[0..($7fffffff div sizeof(TBESENUINT32))-1] of TBESENINT32;

     PBESENINT64Array=^TBESENINT64Array;
     TBESENINT64Array=array[0..($7fffffff div sizeof(TBESENINT64))-1] of TBESENINT64;

     TBESENBytes=array of byte;

     TBESENIntegers=array of integer;

     TBESENUINT32s=array of TBESENUINT32;

     TBESENINT32s=array of TBESENINT32;

     TBESENNativeCodePCOffsets=array of pointer;

     TBESENRadixChars=array[0..35] of TBESENCHAR;

     TBESENLocation=record
      LineNumber:integer;
     end;

     PBESENDoubleHiLo=^TBESENDoubleHiLo;
     TBESENDoubleHiLo=packed record
{$ifdef BIG_ENDIAN}
      Hi,Lo:TBESENUInt32;
{$else}
      Lo,Hi:TBESENUInt32;
{$endif}
     end;

     TBESENLocations=array of TBESENLocation;

     TBESENStrings=array of TBESENString;

     TBESENWarningProc=procedure(LineNumber:integer;const Msg:TBESENSTRING) of object;

     TBESENTraceType=(bttNONE,bttSTATEMENT,bttCALL,bttRETURN,bttTHROW,bttDEBUGGER);

     TBESENCompatibilityMode=record
      Name:TBESENString;
      Flag:longword;
     end;

     TBESENCompatibilityModes=array[0..3] of TBESENCompatibilityMode;

{$ifdef BESENDelphiHasNoSystemTimeMore}
     TSystemTime=record
      wYear:word;
      wMonth:word;
      wDayOfWeek:word;
      wDay:word;
      wHour:word;
      wMinute:word;
      wSecond:word;
      wMilliseconds:word;
     end;
{$endif}
     
implementation

end.
