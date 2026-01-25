unit unihash;

interface

{$mode ObjFPC}{$H+}

{These algorithm comes from the Google CityHash64}

type unihash_pair=packed record
                  PairValue1,PairValue2:Qword;
                  end;

const unihash_k0:Qword=Qword($c3a5c85c97cb3127);
      unihash_k1:Qword=Qword($b492b66fbe98f273);
      unihash_k2:Qword=Qword($9ae16a3b2f90404f);

function unihash_generate_value(str:string):qword;
function unihash_generate_value(str:string;IsSection:boolean):qword;

implementation

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
 a:=x*y*kmul;
 a:=a xor (a shr 47);
 b:=y*a*kmul;
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
function unihash_hash_length_0_to_16(str:Pointer;Len:SizeUint):Qword;
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
function unihash_hash_length_17_to_32(str:Pointer;Len:SizeUint):Qword;
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
function unihash_byte_swap_64(Value:Qword):Qword;
var a:array[1..8] of byte;
    i:byte;
begin
 Result:=0;
 for i:=1 to 8 do a[i]:=(Value shr ((i-1)*8)) and $FF;
 for i:=1 to 8 do Result:=Result shl 8+a[i];
end;
function unihash_hash_length_33_to_64(str:Pointer;Len:SizeUint):Qword;
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
 w:=unihash_byte_swap_64((u+v)*mul)+h;
 x:=unihash_rotate(e+f,42)+c;
 y:=(unihash_byte_swap_64((v+w)*mul)+g)*mul;
 z:=e+f+c;
 a:=unihash_byte_swap_64((x+z)*mul+y)+b;
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
function unihash_city_hash_64(str:Pointer;len:SizeUint):Qword;
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
 w:=unihash_weak_hash_length_32_with_seeds(Ptr+PtrLength-32,y+unihash_k1,z);
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
begin
 if(str='') then exit(0);
 Result:=unihash_city_hash_64(Pointer(str),length(str));
end;
function unihash_generate_value(str:string;IsSection:boolean):qword;
begin
 if(str='') then exit(0);
 Result:=unihash_city_hash_64(Pointer(str),length(str));
end;

end.


