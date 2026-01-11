unit unihash;

interface

{$mode ObjFPC}{$H+}

type PPointer=^Pointer;

const unihash_magic_number:array[1..16] of Qword=(
Qword($D9AC56CA99C37CEE),Qword($DE035DAB9AF7868A),Qword($3FE51EABFC1EE659),Qword($0C4D58AD1ECBEE5B),
Qword($5484601A6A4D3047),Qword($FBE55EF258B70273),Qword($2305DC5CCE5FDE1D),Qword($BD444F39146BFD0C),
Qword($87264D90E57DAC89),Qword($74D29EC17572E875),Qword($5828E5F5A936E833),Qword($9BC0825EDC32BE03),
Qword($3056380467F0883B),Qword($4550FA26CFBF0353),Qword($758EA9E3D5B2CF9F),Qword($49D5B1339456E38C));
      unihash_move_number:array[1..16] of byte=(17,31,25,5,35,13,11,29,7,35,7,23,25,23,35,11);
      unihash_rotate_number:array[1..16] of byte=(5,1,31,7,7,23,37,19,25,35,7,25,31,29,5,1);

var unihash_section_index:array[1..2] of byte;

procedure unihash_initialize;
function unihash_generate_value(str:string;SectionSwitch:boolean):qword;

implementation

procedure unihash_initialize;
var SectionBool:array[1..16] of boolean;
    i,j:SizeUint;
begin
 randomize;
 for i:=1 to 16 do SectionBool[i]:=false;
 for i:=1 to 2 do
  begin
   j:=1+random(16);
   while(SectionBool[j]) do j:=1+random(16);
   SectionBool[j]:=true;
   unihash_section_index[i]:=j;
  end;
end;
function unihash_string_to_pointer(value:string):Pointer;
begin
 unihash_string_to_pointer:=PPointer(@value)^;
end;
function unihash_rotate(value:Qword;shift:byte):Qword;
begin
 unihash_rotate:=(value shr shift) or (value shl (64-shift));
end;
function unihash_mix(value1,value2:Qword;index:byte):Qword;
var tempnum1,tempnum2:Qword;
begin
 tempnum1:=value1 xor value2;
 tempnum1:=tempnum1*unihash_magic_number[index];
 tempnum1:=tempnum1 xor (tempnum1 shr unihash_move_number[index]);
 tempnum2:=value2 xor tempnum1;
 tempnum2:=tempnum2*unihash_magic_number[index];
 tempnum2:=tempnum2 xor (tempnum2 shr unihash_move_number[index]);
 unihash_mix:=tempnum2*unihash_magic_number[index];
end;
function unihash_hash_0to16(str:string;len:byte;index:byte):Qword;
var q1,q2:qword;
    d1,d2:dword;
    b1,b2,b3:byte;
begin
 if(len>=8) then
  begin
   q1:=Pqword(unihash_string_to_pointer(str))^;
   q2:=Pqword(unihash_string_to_pointer(str)+len-8)^;
   unihash_hash_0to16:=unihash_mix(q1,unihash_rotate(q2+len,len),index) xor q2;
  end
 else if(len>=4) then
  begin
   d1:=Pdword(unihash_string_to_pointer(str))^;
   d2:=Pdword(unihash_string_to_pointer(str)+len-4)^;
   unihash_hash_0to16:=unihash_mix(len+Qword(d1) shl 3,d2,index);
  end
 else if(len>0) then
  begin
   b1:=Pbyte(unihash_string_to_pointer(str))^;
   b2:=Pbyte(unihash_string_to_pointer(str)+len shr 1)^;
   b3:=Pbyte(unihash_string_to_pointer(str)+len-1)^;
   d1:=b1+Dword(b2) shl 8;
   d2:=len+Dword(b3) shl 2;
   unihash_hash_0to16:=unihash_mix(d1,d2,index);
  end
 else unihash_hash_0to16:=unihash_magic_number[index];
end;
function unihash_generate_value_endline(str:string;index:byte):qword;
var i,len,reallen:dword;
    h,g,f,a,b,offset:Qword;
begin
 len:=length(str); reallen:=len;
 if(len=0) then exit(0);
 if(len<=16) then exit(unihash_hash_0to16(str,len,index));
 h:=len; g:=unihash_magic_number[index]*len; f:=g; offset:=0;
 while(len>=16)do
  begin
   a:=Pqword(unihash_string_to_pointer(str)+offset)^;
   b:=Pqword(unihash_string_to_pointer(str)+offset+8)^;
   h:=h xor unihash_mix(a,b,index);
   h:=unihash_rotate(h,unihash_rotate_number[index])*unihash_magic_number[index]+g;
   dec(len,16);
   inc(offset,16);
  end;
 if(len>0) then
  begin
   h:=h xor unihash_hash_0to16(Copy(str,offset,reallen-offset+1),reallen-offset+1,index);
   h:=h*unihash_magic_number[index];
  end;
 h:=unihash_mix(h,f,index);
 unihash_generate_value_endline:=h;
end;
function unihash_generate_value(str:string;SectionSwitch:boolean):SizeUint;
begin
 if(SectionSwitch) then
 Result:=unihash_generate_value_endline(str,unihash_section_index[1])
 else
 Result:=unihash_generate_value_endline(str,unihash_section_index[2]);
end;

end.

