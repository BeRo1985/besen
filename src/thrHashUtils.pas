unit thrHashUtils;

interface

uses BESENConstants,BESENTypes;

function thrHashKey(const Key:TBESENString):TBESENHash;

implementation

(*
implementation of h*31 + *s simple and fast hashing function

uint32_t X31_hash_string(const char *s)
{
		
	khint_t h = *s;
    for (++s ; *s; ++s) h = (h << 5) - h + *s;
    return h;
}

*)


function thrHashKey(const Key:TBESENString):TBESENHash;
var i,h:longword;
begin
  if length(key)<1 then
  begin
     result:=0;
     exit;
  end;

 h:=ord(Key[1]);
 for i:=2 to length(Key) do begin
  h:=(h shl 5) - h + ord(Key[i]);
 end; 
 
 result:=h;
end;

end.
