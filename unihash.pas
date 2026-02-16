unit unihash;

interface

{$mode ObjFPC}{$H+}

{Google City Hash is an Open Source Algoritm,Original City Hash is C++ Source Code}
{These algorithm below refers to the Google CityHash,you can search CityHash for the original algoritm}

type unihash_pair=packed record
                  PairValue1,PairValue2:Qword;
                  end;

const unihash_k0:Qword=Qword($c3a5c85c97cb3127);
      unihash_k1:Qword=Qword($b492b66fbe98f273);
      unihash_k2:Qword=Qword($9ae16a3b2f90404f);
      unihash_c1:Dword=Dword($cc9e2d51);
      unihash_c2:Dword=Dword($1b873593);

function unihash_generate_value(str:string):SizeUint;

implementation

procedure unihash_permute_32bit(var Value1:Dword;var Value2:Dword;var Value3:Dword);
var Temp:Dword;
begin
 {Swap the Value 1 and Value 2}
 Temp:=Value1; Value1:=Value2; Value2:=Temp;
 {Then Swap the Value 1 and Value 3}
 Temp:=Value1; Value1:=Value3; Value3:=Temp;
end;
function unihash_byte_swap_32bit(Value:Dword):Dword;
var a:array[1..8] of byte;
    i:byte;
begin
 Result:=0;
 for i:=1 to 4 do a[i]:=(Value shr ((i-1)*8)) and $FF;
 for i:=1 to 4 do Result:=Result shl 8+a[i];
end;
function unihash_mix_32bit(Value:Dword):Dword;
var TempValue:Dword;
begin
 TempValue:=Value xor (Value shr 16);
 TempValue:=TempValue*$85ebca6b;
 TempValue:=TempValue xor (TempValue shr 13);
 TempValue:=TempValue*$c2b2ae35;
 TempValue:=TempValue xor (TempValue shr 16);
 Result:=TempValue;
end;
function unihash_rotate_32bit(Value:Dword;Shift:byte):Dword;
begin
 if(Shift=0) then Result:=Value
 else Result:=(Value shr Shift) or (Value shl (32-Shift));
end;
function unihash_combine_32bit(Value1,Value2:Dword):Dword;
var TempValue1,TempValue2:Dword;
begin
 TempValue1:=Value1*unihash_c1;
 TempValue1:=unihash_rotate_32bit(TempValue1,17);
 TempValue1:=TempValue1*unihash_c2;
 TempValue2:=Value2 xor TempValue1;
 TempValue2:=unihash_rotate_32bit(TempValue2,19);
 Result:=TempValue2*5+$e6546b64;
end;
function unihash_hash_length_0_to_4_32bit(Ptr:Pointer;Length:Dword):Dword;
var TempB:Dword=0;
    TempC:Dword=9;
    TempV:byte=0;
    i:byte=0;
begin
 for i:=1 to Length do
  begin
   TempV:=Pbyte(Ptr+i-1)^;
   TempB:=TempB*unihash_c1+Dword(tempV);
   TempC:=TempC xor TempB;
  end;
 Result:=unihash_mix_32bit(unihash_combine_32bit(TempB,unihash_combine_32bit(Dword(Length),TempC)));
end;
function unihash_hash_length_5_to_12_32bit(Ptr:Pointer;Length:Dword):Dword;
var TempA,TempB,TempC,TempD:Dword;
begin
 TempA:=Length; TempB:=TempA*5; TempC:=9; TempD:=TempB;
 TempA:=TempA+Pdword(Ptr)^;
 TempB:=TempB+Pdword(Ptr+Length-4)^;
 TempC:=TempC+Pdword(Ptr+(Length shr 1) and $4)^;
 Result:=unihash_mix_32bit(unihash_combine_32bit(TempC,
 unihash_combine_32bit(TempB,unihash_combine_32bit(TempA,TempD))));
end;
function unihash_hash_length_13_to_24_32bit(Ptr:Pointer;Length:Dword):Dword;
var TempA,TempB,TempC,TempD,TempE,TempF,TempH:Dword;
begin
 TempA:=Pdword(Ptr+(length shr 1)-4)^;
 TempB:=Pdword(Ptr+4)^;
 TempC:=Pdword(Ptr+length-8)^;
 TempD:=Pdword(Ptr+(length shr 1))^;
 TempE:=Pdword(Ptr)^;
 TempF:=Pdword(Ptr+length-4)^;
 TempH:=Dword(Length);
 Result:=unihash_mix_32bit(unihash_combine_32bit(TempF,
 unihash_combine_32bit(TempE,unihash_combine_32bit(TempD,
 unihash_combine_32bit(TempC,unihash_combine_32bit(TempB,
 unihash_combine_32bit(TempA,TempH)))))));
end;
function unihash_city_hash_32(Ptr:Pointer;Length:Dword):Dword;
var TempH,TempG,TempF,TempA0,TempA1,TempA2,TempA3,TempA4:Dword;
    TempPtr:Pointer;
    TempLength,TempBlock:Dword;
begin
 if(Length<=24) then
  begin
   if(Length<=12) then
    begin
     if(Length<=4) then exit(unihash_hash_length_0_to_4_32bit(Ptr,Length))
     else exit(unihash_hash_length_5_to_12_32bit(Ptr,Length));
    end
   else exit(unihash_hash_length_13_to_24_32bit(Ptr,Length));
  end;
 TempH:=Length; TempG:=unihash_c1*TempH; TempF:=TempG;
 TempA0:=unihash_rotate_32bit(Pdword(Ptr+length-4)^*unihash_c1,17)*unihash_c2;
 TempA1:=unihash_rotate_32bit(Pdword(Ptr+length-8)^*unihash_c1,17)*unihash_c2;
 TempA2:=unihash_rotate_32bit(Pdword(Ptr+length-12)^*unihash_c1,17)*unihash_c2;
 TempA3:=unihash_rotate_32bit(Pdword(Ptr+length-16)^*unihash_c1,17)*unihash_c2;
 TempA4:=unihash_rotate_32bit(Pdword(Ptr+length-20)^*unihash_c1,17)*unihash_c2;
 TempH:=TempH xor TempA0; TempH:=unihash_rotate_32bit(TempH,19);
 TempH:=TempH*5+$e6546b64; TempH:=TempH xor TempA2; TempH:=TempH*5+$e6546b64;
 TempG:=TempG xor TempA1; TempG:=unihash_rotate_32bit(TempG,19);
 TempG:=TempG*5+$e6546b64; TempG:=TempG xor TempA3; TempG:=TempG*5+$e6546b64;
 TempF:=TempF+TempA4; TempF:=unihash_rotate_32bit(TempF,19); TempF:=TempF*5+$e6546b64;
 TempPtr:=Ptr; TempLength:=Length; TempBlock:=(TempLength-1) div 20;
 repeat
  TempA0:=unihash_rotate_32bit(Pdword(TempPtr)^*unihash_c1,17)*unihash_c2;
  TempA1:=Pdword(TempPtr+4)^;
  TempA2:=unihash_rotate_32bit(Pdword(TempPtr+8)^*unihash_c1,17)*unihash_c2;
  TempA3:=unihash_rotate_32bit(Pdword(TempPtr+12)^*unihash_c1,17)*unihash_c2;
  TempA4:=Pdword(TempPtr+16)^;
  TempH:=TempH xor TempA0; TempH:=unihash_rotate_32bit(TempH,18); TempH:=TempH*5+$e6546b64;
  TempF:=TempF+TempA1; TempF:=unihash_rotate_32bit(TempF,19); TempF:=TempF*unihash_c1;
  TempG:=TempG+TempA2; TempG:=unihash_rotate_32bit(TempG,18); TempG:=TempG*5+$e6546b64;
  TempH:=TempH xor (TempA3+TempA1); TempH:=unihash_rotate_32bit(TempH,19); TempH:=TempH*5+$e6546b64;
  TempG:=TempG xor TempA4; TempG:=unihash_byte_swap_32bit(TempG)*5;
  TempH:=TempH+TempA4*5; TempH:=unihash_byte_swap_32bit(TempH);
  TempF:=TempF+TempA0;
  unihash_permute_32bit(TempF,TempH,TempG);
  dec(TempBlock);
  inc(TempPtr,20);
 until(TempBlock=0);
 TempG:=unihash_rotate_32bit(TempG,11)*unihash_c1;
 TempG:=unihash_rotate_32bit(TempG,17)*unihash_c1;
 TempF:=unihash_rotate_32bit(TempF,11)*unihash_c1;
 TempF:=unihash_rotate_32bit(TempF,17)*unihash_c1;
 TempH:=unihash_rotate_32bit(TempH+TempG,19);
 TempH:=TempH*5+$e6546b64;
 TempH:=unihash_rotate_32bit(TempH,17)*unihash_c1;
 TempH:=unihash_rotate_32bit(TempH+TempF,19);
 TempH:=TempH*5+$e6546b64;
 TempH:=unihash_rotate_32bit(TempH,17);
 Result:=TempH;
end;
function unihash_byte_swap(Value:Qword):Qword;
var a:array[1..8] of byte;
    i:byte;
begin
 Result:=0;
 for i:=1 to 8 do a[i]:=(Value shr ((i-1)*8)) and $FF;
 for i:=1 to 8 do Result:=Result shl 8+a[i];
end;
function unihash_rotate(Value:Qword;Shift:byte):Qword;
begin
 if(Shift=0) then Result:=Value
 else Result:=(value shr Shift) or (Value shl (64-Shift));
end;
function unihash_shift_mix(Value:Qword):Qword;
begin
 Result:=Value xor (Value shr 47);
end;
function unihash_hash_length_16(x,y:Qword):Qword;
const kmul:Qword=Qword($9ddfea08eb382d69);
var a,b:Qword;
begin
 a:=(x xor y)*kmul;
 a:=a xor (a shr 47);
 b:=(y xor a)*kmul;
 b:=b xor (b shr 47);
 b:=b*kmul;
 Result:=b;
end;
function unihash_hash_length_16(u,v,MultiplyNumber:Qword):Qword;
var a,b:Qword;
begin
 a:=(u xor v)*MultiplyNumber;
 a:=a xor (a shr 47);
 b:=(v xor a)*MultiplyNumber;
 b:=b xor (b shr 47);
 b:=b*MultiplyNumber;
 Result:=b;
end;
function unihash_hash_length_0_to_16(str:Pointer;Len:Qword):Qword;
var a,b,c,d,mul,y,z:Qword;
begin
 if(len>=8) then
  begin
   mul:=unihash_k2+len*2;
   a:=Pqword(str)^+unihash_k2;
   b:=Pqword(str+len-8)^;
   c:=unihash_rotate(b,37)*mul+a;
   d:=(unihash_rotate(a,25)+b)*mul;
   Result:=unihash_hash_length_16(c,d,len);
  end
 else if(len>=4) then
  begin
   mul:=unihash_k2+len*2;
   a:=Pdword(str)^;
   Result:=unihash_hash_length_16(len+(a shl 3),Pdword(str+len-4)^,mul);
  end
 else if(len>0) then
  begin
   a:=Pbyte(str)^; b:=Pbyte(str+len shr 1)^; c:=Pbyte(str+len-1)^;
   y:=a+b shl 8; z:=len+c shl 2;
   Result:=unihash_shift_mix(y*unihash_k2 xor z*unihash_k0)*unihash_k2;
  end
 else Result:=unihash_k2;
end;
function unihash_hash_length_17_to_32(str:Pointer;Len:Qword):Qword;
var mul,a,b,c,d:Qword;
begin
 mul:=unihash_k2+len*2;
 a:=Pqword(str)^*unihash_k1;
 b:=Pqword(str+8)^;
 c:=Pqword(str+len-8)^*mul;
 d:=Pqword(str+len-16)^*unihash_k2;
 Result:=unihash_hash_length_16(unihash_rotate(a+b,43)+unihash_rotate(c,30)+d,
 a+unihash_rotate(b+unihash_k2,18)+c,mul);
end;
function unihash_hash_length_33_to_64(str:Pointer;Len:byte):Qword;
var mul,a,b,c,d,e,f,g,h,u,v,w,x,y,z:Qword;
begin
 mul:=unihash_k2+len*2;
 a:=Pqword(str)^*unihash_k2;
 b:=Pqword(str+8)^;
 c:=Pqword(str+len-24)^;
 d:=Pqword(str+len-32)^;
 e:=Pqword(str+16)^*unihash_k2;
 f:=Pqword(str+24)^*9;
 g:=Pqword(str+len-8)^;
 h:=Pqword(str+len-16)^*mul;
 u:=unihash_rotate(a+g,43)+(unihash_rotate(b,30)+c)*9;
 v:=((a+g) xor d)+f+1;
 w:=unihash_byte_swap((u+v)*mul)+h;
 x:=unihash_rotate(e+f,42)+c;
 y:=(unihash_byte_swap((v+w)*mul)+g)*mul;
 z:=e+f+c;
 a:=unihash_byte_swap((x+z)*mul+y)+b;
 b:=unihash_shift_mix((z+a)*mul+d+h)*mul;
 Result:=b+x;
end;
function unihash_weak_hash_length_32_with_seeds_internal(w,x,y,z,a,b:Qword):unihash_pair;
var a1,b1,c1:Qword;
begin
 a1:=a+w;
 b1:=unihash_rotate(b+a1+z,21);
 c1:=a1;
 a1:=a1+x;
 a1:=a1+y;
 b1:=b1+unihash_rotate(a1,44);
 Result.PairValue1:=a1+z;
 Result.PairValue2:=b1+c1;
end;
function unihash_weak_hash_length_32_with_seeds(str:Pointer;a,b:Qword):unihash_pair;
begin
 Result:=unihash_weak_hash_length_32_with_seeds_internal(
 Pqword(str)^,Pqword(str+8)^,Pqword(str+16)^,Pqword(str+24)^,a,b);
end;
function unihash_city_hash_64(str:Pointer;len:Qword):Qword;
var x,y,z,t:Qword;
    v,w:unihash_pair;
    Ptr:Pointer;
    PtrLength:SizeUint;
begin
 if(Len<=32) then
  begin
   if(Len<=16) then exit(unihash_hash_length_0_to_16(str,len))
   else exit(unihash_hash_length_17_to_32(str,len));
  end
 else if(Len<=64) then exit(unihash_hash_length_33_to_64(str,len));
 Ptr:=str; PtrLength:=len;
 x:=Pqword(Ptr+PtrLength-40)^;
 y:=Pqword(Ptr+PtrLength-16)^+Pqword(Ptr+PtrLength-56)^;
 z:=unihash_hash_length_16(Pqword(Ptr+PtrLength-48)^+PtrLength,Pqword(Ptr+PtrLength-24)^);
 v:=unihash_weak_hash_length_32_with_seeds(Ptr+PtrLength-64,PtrLength,z);
 w:=unihash_weak_hash_length_32_with_seeds(Ptr+PtrLength-32,y+unihash_k1,x);
 x:=unihash_k1*x+Pqword(Ptr)^;
 Ptrlength:=(Ptrlength-1) div 64*64;
 repeat
  x:=unihash_rotate(x+y+v.PairValue1+Pqword(Ptr+8)^,37)*unihash_k1;
  y:=unihash_rotate(y+v.PairValue2+Pqword(ptr+48)^,42)*unihash_k1;
  x:=x xor w.PairValue2;
  inc(y,v.PairValue1+Pqword(Ptr+40)^);
  z:=unihash_rotate(z+w.PairValue1,33)*unihash_k1;
  v:=unihash_weak_hash_length_32_with_seeds(Ptr,v.PairValue2*unihash_k1,x+w.PairValue1);
  w:=unihash_weak_hash_length_32_with_seeds(Ptr+32,z+w.PairValue2,y+Pqword(Ptr+16)^);
  t:=x; x:=z; z:=t;
  inc(Ptr,64);
  dec(Ptrlength,64);
 until(Ptrlength=0);
 Result:=unihash_hash_length_16(unihash_hash_length_16(v.PairValue1,w.PairValue1)+
 unihash_shift_mix(y)*unihash_k1+z,unihash_hash_length_16(v.PairValue2,w.PairValue2)+x);
end;
function unihash_generate_value(str:string):SizeUint;
var TempSize:byte;
begin
 if(str='') then exit(0);
 TempSize:=sizeof(SizeUInt);
 if(TempSize=4) then Result:=unihash_city_hash_32(Pointer(str),length(str))
 else Result:=unihash_city_hash_64(Pointer(str),length(str));
end;

end.
