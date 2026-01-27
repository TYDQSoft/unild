unit unildscript;

{$mode ObjFPC}{$H+}

interface

uses Classes,SysUtils,binbase;

type unild_item=packed record
                ItemClass:SizeUint;
                ItemOffset:SizeUInt;
                ItemRelativeOffset:SizeUint;
                ItemAlign:SizeUint;
                ItemFilter:array of string;
                ItemKeep:boolean;
                ItemSmart:boolean;
                ItemCount:SizeUint;
                end;
     unild_section=packed record
                   SectionName:string;
                   SectionAttribute:array of string;
                   SectionAttributeCount:byte;
                   SectionAddress:SizeUint;
                   SectionAlign:dword;
                   SectionItem:array of unild_item;
                   SectionItemCount:SizeUint;
                   end;
     unild_script=packed record
                  SystemIndex:byte;
                  IsUntypedBinary:boolean;
                  UntypedBinaryAlign:Dword;
                  UntypedBinaryAddressable:boolean;
                  Interpreter:string;
                  InterpreterDynamicLinkFunction:string;
                  FileAlign:SizeUint;
                  Symbolic:boolean;
                  SmartLinking:boolean;
                  LinkAll:boolean;
                  NoSymbol:boolean;
                  NoExecutableStack:boolean;
                  GotAuthority:byte;
                  NoExternalLibrary:boolean;
                  IsEFIFile:boolean;
                  EFIFileIndex:byte;
                  SharedLibraryName:string;
                  DynamicLibraryPath:array of string;
                  DynamicLibraryPathCount:SizeUint;
                  DynamicLibrary:array of string;
                  DynamicLibraryCount:SizeUint;
                  NoDefaultLibrary:boolean;
                  NoFixedAddress:boolean;
                  elfclass:byte;
                  BaseAddress:SizeUint;
                  EntryName:string;
                  InputFile:array of string;
                  InputFileCount:SizeUInt;
                  InputFilePath:array of string;
                  InputFileHaveSubPath:array of boolean;
                  InputFilePathCount:SizeUint;
                  InputArchitecture:word;
                  InputBits:byte;
                  OutputArchitecture:word;
                  OutputBits:byte;
                  OutputFileName:string;
                  Bits:byte;
                  Section:array of unild_section;
                  SectionCount:Word;
                  SectionCountExtra:Word;
                  EnableFileInformation:boolean;
                  EnableSectionInformation:boolean;
                  DynamicSectionAlias:string;
                  DynamicSectionEnable:boolean;
                  DynamicSectionIndex:word;
                  GlobalOffsetTableAlias:string;
                  GlobalOffsetTableSectionEnable:boolean;
                  GlobalOffsetTableSectionIndex:word;
                  DebugSwitch:boolean;
                  VersionSwitch:boolean;
                  EntryAsStartOfSection:boolean;
                  {For Implicit Address of Output File}
                  ImplicitName:array of string;
                  ImplicitAddress:array of SizeUint;
                  ImplicitCount:SizeUint;
                  {Temporary Variables}
                  DynamicPathWithSubDirectoryList:array of string;
                  DynamicPathWithSubDirectoryCount:SizeUint;
                  {For Actually Library Path Name}
                  DynamicLibraryActualPath:array of string;
                  DynamicLibraryActualPathCount:SizeUInt;
                  end;
     unild_line_item=packed record
                     Item:array of string;
                     Offset:array of dword;
                     Count:word;
                     end;
     unild_line=packed record
                Line:array of unild_line_item;
                LineCount:SizeUint;
                end;

const unild_item_offset:byte=0;
      unild_item_align:byte=1;
      unild_item_filter:byte=2;
      unild_item_relativeoffset:byte=3;
      {For ELF File Structure}
      unild_class_relocatable=1;
      unild_class_sharedobject=2;
      unild_class_executable=3;
      unild_class_core=4;
      {For EFI File Structure}
      unild_class_application=1;
      unild_class_bootdriver=2;
      unild_class_runtimedriver=3;
      unild_class_rom=4;
      {For ELF Format File Global Offset Table Writable}
      unild_readonly_got=2;
      unild_writable_got=1;
      unild_unchecked_got=0;

var ScriptEnable:boolean=false;
    Script:unild_script;

procedure unild_initialize;
function unild_script_match_mask(checkstr:string;mask:string):boolean;
function unild_translate_string(str:string):string;
function unild_str_to_int(str:string):SizeUint;
function unild_script_read(filename:string):unild_script;
function unild_generate_default_elf_file:unild_script;
function unild_generate_default_other_file:unild_script;

implementation

procedure unild_initialize;
begin
 ScriptEnable:=true;
 Script.NoSymbol:=false; Script.BaseAddress:=0;
 Script.DynamicLibraryCount:=0; Script.DynamicLibraryPathCount:=0; Script.EFIFileIndex:=0;
 Script.elfclass:=0; Script.Interpreter:='';
 Script.InterpreterDynamicLinkFunction:='_dl_runtime_resolve';
 Script.InputFilePathCount:=0; Script.InputFileCount:=0;
 Script.EntryName:=''; Script.FileAlign:=$1000; Script.NoDefaultLibrary:=false;
 Script.NoExternalLibrary:=false; Script.NoSymbol:=false; Script.NoFixedAddress:=true;
 Script.SectionCount:=0; Script.SystemIndex:=0; Script.SmartLinking:=false; Script.LinkAll:=true;
 Script.NoExecutableStack:=false; Script.GotAuthority:=unild_writable_got;
 Script.InputArchitecture:=0; Script.OutputArchitecture:=0;
 Script.InputBits:=0; Script.OutputBits:=0;
 Script.IsUntypedBinary:=false; Script.UntypedBinaryAlign:=0; Script.UntypedBinaryAddressable:=false;
 Script.DynamicPathWithSubDirectoryCount:=0;
 Script.EnableFileInformation:=true; Script.EnableSectionInformation:=true;
 Script.DynamicSectionAlias:='_DYNAMIC'; Script.SectionCountExtra:=0;
 Script.DynamicSectionEnable:=false; Script.DynamicSectionIndex:=0;
 Script.GlobalOffsetTableAlias:='_GLOBAL_OFFSET_TABLE_';
 Script.GlobalOffsetTableSectionEnable:=false; Script.GlobalOffsetTableSectionIndex:=0;
 Script.DebugSwitch:=false; Script.VersionSwitch:=false;
 Script.EntryAsStartOfSection:=false; Script.OutputFileName:=''; Script.ImplicitCount:=0;
 Script.DynamicLibraryActualPathCount:=0;
end;
function unild_script_str_to_int(str:string):SizeUint;
const hex1:string='0123456789ABCDEF';
      hex2:string='0123456789abcdef';
var BitSize:byte;
    i,j,StartPoint,Len:SizeUint;
begin
 Len:=length(str); StartPoint:=1;
 if(len=0) then exit(0);
 BitSize:=10;
 if(Copy(str,1,2)='0x') or (Copy(str,1,2)='0x') then
  begin
   StartPoint:=3; BitSize:=16;
  end
 else if(Copy(str,1,2)='0b') or (Copy(Str,1,2)='0B') then
  begin
   StartPoint:=3; BitSize:=2;
  end
 else if(str[1]='x') then
  begin
   StartPoint:=2; BitSize:=16;
  end
 else if(str[1]='0') and (len>1) then
  begin
   StartPoint:=2; BitSize:=8;
  end
 else if(len>1) and (str[1]='#') and (str[2]='$') then
  begin
   StartPoint:=3; BitSize:=16;
  end
 else if(str[1]='$') then
  begin
   StartPoint:=2; BitSize:=16;
  end
 else if(str[1]='#') then
  begin
   StartPoint:=2; BitSize:=10;
  end;
 i:=1; Result:=0;
 for i:=StartPoint to len do
  begin
   j:=1;
   while(j<=BitSize)do
    begin
     if(str[i]=Hex1[j]) then break;
     if(str[i]=Hex2[j]) then break;
     inc(j);
    end;
   if(j<=BitSize) then Result:=Result*BitSize+j-1;
  end;
end;
function unild_str_to_int(str:string):SizeUint;
begin
 Result:=unild_script_str_to_int(str);
end;
function unild_script_translate_string(str:string;NoSpace:boolean=false):string;
const hex1:string='0123456789ABCDEF';
      hex2:string='0123456789abcdef';
var i,j,m,len:SizeUint;
    k:word;
    IsCString,OnString:boolean;
begin
 i:=1; len:=length(str); OnString:=false; IsCString:=false;
 if((len>=1) and (str[1]='"')) or
 ((len>4) and (str[1]=#39) and (str[2]='\')) then IsCString:=true;
 Result:='';
 if(IsCString) then
  begin
   while(i<=len)do
    begin
     if(str[i]='"') and (OnString=false) then
      begin
       OnString:=true;
      end
     else if(str[i]='"') and (OnString) then
      begin
       OnString:=false;
      end
     else if(str[i]='\') and (i<len) then
      begin
       if(str[i+1]='a') then
        begin
         Result:=Result+#7;
         inc(i);
        end
       else if(str[i+1]='b') then
        begin
         Result:=Result+#8;
         inc(i);
        end
       else if(str[i+1]='f') then
        begin
         Result:=Result+#12;
         inc(i);
        end
       else if(str[i+1]='n') then
        begin
         Result:=Result+#10;
         inc(i);
        end
       else if(str[i+1]='r') then
        begin
         Result:=Result+#13;
         inc(i);
        end
       else if(str[i+1]='t') then
        begin
         Result:=Result+#9;
         inc(i);
        end
       else if(str[i+1]='v') then
        begin
         Result:=Result+#11;
         inc(i);
        end
       else if(str[i+1]='\') then
        begin
         Result:=Result+#92;
         inc(i);
        end
       else if(str[i+1]=#39) then
        begin
         Result:=Result+#11;
         inc(i);
        end
       else if(str[i+1]='"') then
        begin
         Result:=Result+#92;
         inc(i);
        end
       else if(str[i+1]='?') then
        begin
         Result:=Result+#92;
         inc(i);
        end
       else if(str[i+1]='0') then
        begin
         Result:=Result+#0;
         inc(i);
        end
       else if(str[i+1]='x') then
        begin
         j:=i+2;
         while(j<=len)do
          begin
           k:=1;
           while(k<=16)do
            begin
             if(hex1[k]=str[j]) then break;
             if(hex2[k]=str[j]) then break;
             inc(k);
            end;
           if(k>16) then break;
           inc(j);
          end;
         dec(j); i:=j;
         m:=unild_script_str_to_int(Copy(str,i+1,j-i));
         if(m>255) then break;
         Result:=Result+Char(m);
        end
       else if(str[i+1]='0') then
        begin
         j:=i+2;
         while(j<=len)do
          begin
           k:=1;
           while(k<=8)do
            begin
             if(hex1[k]=str[j]) then break;
             inc(k);
            end;
           if(k>8) then break;
           inc(j);
          end;
         dec(j); i:=j;
         m:=unild_script_str_to_int(Copy(str,i+1,j-i));
         if(m>255) then break;
         Result:=Result+Char(m);
        end
       else break;
      end
     else if(OnString) then Result:=Result+str[i]
     else break;
     inc(i);
    end;
   if(i<=len) or (OnString=false) then exit(str);
  end
 else
  begin
   OnString:=false;
   while(i<=len)do
    begin
     if(OnString=false) and (str[i]=#39) then
      begin
       OnString:=true;
      end
     else if(OnString) and (str[i]=#39) then
      begin
       OnString:=false;
      end
     else if(str[i]='#') then
      begin
       j:=i+1;
       while(j<=len) and ((str[j]<>'#') and (str[j]<>#39)) do inc(j);
       dec(j);
       m:=unild_script_str_to_int(Copy(str,i,j-i+1));
       if(m>255) then break;
       Result:=Result+Char(m);
       i:=j;
      end
     else if(OnString=true) then Result:=Result+str[i]
     else break;
     inc(i);
    end;
   if(i<=len) or (OnString) then exit(str);
  end;
 if(NoSpace) and (length(Result)>=1) then
  begin
   while(Result[length(Result)]<=' ') do Delete(Result,length(Result),1);
   while(Result[1]<=' ')do Delete(Result,1,1);
  end;
end;
function unild_translate_string(str:string):string;
begin
 unild_translate_string:=unild_script_translate_string(str,true);
end;
function unild_script_analyze(content:string;StartIndex:SizeUint=1):unild_line_item;
var i,j,len:SizeUint;
    StartPoint:SizeUInt;
    tempstr:string;
    bool:boolean;
begin
 i:=1; len:=length(content); tempstr:=''; StartPoint:=1; bool:=false;
 Result.Count:=0; SetLength(Result.Item,0); SetLength(Result.Offset,0);
 while(i<=len)do
  begin
   if((content[i]='"') or (content[i]=#39)) then
    begin
     j:=i+1;
     while(j<=len)do
      begin
       if(j>i+3) and ((content[j]='"') or (content[j]=#39))
       and (content[j-1]='\') and (content[j-2]<>'\') then inc(j)
       else if(j>i+1) and ((content[j]='"') or (content[j]=#39)) and (content[j-1]='\') then break
       else if(content[j]='"') or (content[j]=#39) then inc(j);
       inc(j);
      end;
     inc(Result.Count);
     SetLength(Result.Item,Result.Count);
     SetLength(Result.Offset,Result.Count);
     Result.Item[Result.Count-1]:=Copy(content,i,j-i+1);
     Result.Offset[Result.Count-1]:=i;
     bool:=false;
     i:=j+1;
    end
   else if(content[i]=',') or (content[i]=':') or (content[i]='(') or (content[i]=')')
   or (content[i]='=') or (content[i]='{') or (content[i]='}') then
    begin
     if(tempstr<>'') then
      begin
       inc(Result.Count);
       SetLength(Result.Item,Result.Count);
       SetLength(Result.Offset,Result.Count);
       Result.Item[Result.Count-1]:=tempstr;
       Result.Offset[Result.Count-1]:=StartIndex+StartPoint-1;
       tempstr:='';
      end;
     inc(Result.Count);
     SetLength(Result.Item,Result.Count);
     SetLength(Result.Offset,Result.Count);
     Result.Item[Result.Count-1]:=content[i];
     Result.Offset[Result.Count-1]:=i;
     bool:=false;
    end
   else if(bool=false) and (content[i]>' ') then
    begin
     tempstr:=content[i];
     bool:=true; StartPoint:=i;
    end
   else if(bool) and (content[i]<=' ') then
    begin
     inc(Result.Count);
     SetLength(Result.Item,Result.Count);
     SetLength(Result.Offset,Result.Count);
     Result.Item[Result.Count-1]:=tempstr;
     Result.Offset[Result.Count-1]:=StartIndex+StartPoint-1;
     tempstr:='';
     bool:=false;
    end
   else if(i=len) and (content[i]>' ') then
    begin
     inc(Result.Count);
     SetLength(Result.Item,Result.Count);
     SetLength(Result.Offset,Result.Count);
     Result.Item[Result.Count-1]:=tempstr+content[i];
     Result.Offset[Result.Count-1]:=StartIndex+StartPoint-1;
     tempstr:='';
     bool:=false;
    end
   else if(bool) then
    begin
     tempstr:=tempstr+content[i];
    end;
   inc(i);
  end;
end;
function unild_script_match_mask(checkstr:string;mask:string):boolean;
var i,j,len1,len2:SizeUint;
begin
 i:=1; j:=1; len1:=length(checkstr); len2:=length(mask);
 while(i<=len1)do
  begin
   if(mask[j]='*') then
    begin
     while(j<=len2) and (mask[j]='*') do inc(j);
     if(j>len2) then exit(True);
     while(i<=len1) and (checkstr[i]<>mask[j]) do inc(i);
     if(i>len1) then exit(True);
     continue;
    end
   else if(mask[j]='?') then
    begin
     inc(j); inc(i); continue;
    end
   else
    begin
     if(checkstr[i]<>mask[j]) then exit(false) else
      begin
       inc(i); inc(j); continue;
      end;
    end;
   inc(i);
  end;
 unild_script_match_mask:=true;
end;
function unild_script_read(filename:string):unild_script;
var StrList:TStringList;
    Content:string;
    {For Scanning the Content}
    LineList:unild_line;
    tempstr:string;
    i,j,k,m,row,len:SizeUint;
    {For Content to the Linker Data}
    BracketLayer:byte;
    tempstr1,tempstr2,tempstr3:string;
    tempvalue:SizeUint;
begin
 {Transform the Data to String}
 StrList:=TStringList.Create;
 StrList.LoadFromFile(filename);
 Content:=StrList.Text;
 {Transform the string to Line}
 LineList.LineCount:=0; SetLength(LineList.Line,0);
 i:=1; j:=1; len:=length(Content);
 while(i<=len)do
  begin
   if(Copy(Content,i,3)='###') then
    begin
     j:=i+3; k:=0;
     while(j<=len-2) and (Copy(Content,j,3)<>'###') do
      begin
       if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then
        begin
         inc(j,2); inc(k); row:=1; continue;
        end
       else if(Content[j]=#13) or (Content[j]=#10) then
        begin
         inc(j); inc(k); row:=1; continue;
        end
       else
        begin
         inc(j); inc(row);
        end;
      end;
     i:=j+3;
     j:=LineList.LineCount+1;
     inc(LineList.LineCount,k);
     SetLength(LineList.Line,LineList.LineCount);
     while(j<=LineList.LineCount)do
      begin
       LineList.Line[j-1].Count:=0; inc(j);
      end;
    end
   else if(Copy(Content,i,2)='/*') then
    begin
     j:=i+1; k:=0;
     while(j<=len-1) and (Copy(Content,j,2)<>'*/') do
      begin
       if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then
        begin
         inc(j,2); inc(k); row:=1; continue;
        end
       else if(Content[j]=#13) or (Content[j]=#10) then
        begin
         inc(j); inc(k); row:=1; continue;
        end
       else
        begin
         inc(j); inc(row);
        end;
      end;
     i:=j+2;
     j:=LineList.LineCount+1;
     inc(LineList.LineCount,k);
     SetLength(LineList.Line,LineList.LineCount);
     while(j<=LineList.LineCount)do
      begin
       LineList.Line[j-1].Count:=0; inc(j);
      end;
    end
   else if(Copy(content,i,2)='//') or (content[i]='#') then
    begin
     if(Copy(content,i,2)='//') then j:=i+2 else j:=i+1;
     while(j<=len-1) do
      begin
       if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then
        begin
         inc(j,2); row:=1; break;
        end
       else if(Content[j]=#13) or (Content[j]=#10) then
        begin
         inc(j); row:=1; break;
        end
       else inc(j);
      end;
     inc(LineList.LineCount);
     SetLength(LineList.Line,LineList.LineCount);
     LineList.Line[LineList.LineCount-1].Count:=0;
    end
   else if(Copy(Content,i,2)=#13#10) or (Copy(Content,i,2)=#10#13) then
    begin
     inc(LineList.LineCount);
     SetLength(LineList.Line,LineList.LineCount);
     tempstr:=Copy(Content,j,i-j);
     LineList.Line[LineList.LineCount-1]:=unild_script_analyze(tempstr,row);
     j:=i+2; i:=j; row:=1;
    end
   else if(Content[i]=#10) or (Content[i]=#13) then
    begin
     inc(LineList.LineCount);
     SetLength(LineList.Line,LineList.LineCount);
     tempstr:=Copy(Content,j,i-j);
     LineList.Line[LineList.LineCount-1]:=unild_script_analyze(tempstr,row);
     j:=i+1; i:=j; row:=1;
    end
   else if(Content[i]='{') or (Content[i]='}') then
    begin
     inc(LineList.LineCount);
     SetLength(LineList.Line,LineList.LineCount);
     tempstr:=Content[i];
     LineList.Line[LineList.LineCount-1]:=unild_script_analyze(tempstr,row);
     j:=i+1;
     if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then inc(j,2)
     else if(Content[j]=#10) or (Content[j]=#13) then inc(j);
     row:=1; i:=j;
    end
   else if(Copy(Content,i,5)='begin') then
    begin
     inc(LineList.LineCount);
     SetLength(LineList.Line,LineList.LineCount);
     tempstr:=Copy(Content,i,5);
     LineList.Line[LineList.LineCount-1]:=unild_script_analyze(tempstr,row);
     j:=i+5;
     if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then inc(j,2)
     else if(Content[j]=#10) or (Content[j]=#13) then inc(j);
     row:=1; i:=j;
    end
   else if(Copy(Content,i,3)='end') then
    begin
     inc(LineList.LineCount);
     SetLength(LineList.Line,LineList.LineCount);
     tempstr:=Copy(Content,i,3);
     LineList.Line[LineList.LineCount-1]:=unild_script_analyze(tempstr,row);
     j:=i+3;
     if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then inc(j,2)
     else if(Content[j]=#10) or (Content[j]=#13) then inc(j);
     row:=1; i:=j;
    end
   else if(Copy(Content,i,4)='end;') or (Copy(Content,i,4)='end.') then
    begin
     inc(LineList.LineCount);
     SetLength(LineList.Line,LineList.LineCount);
     tempstr:=Copy(Content,i,4);
     LineList.Line[LineList.LineCount-1]:=unild_script_analyze(tempstr,row);
     j:=i+4;
     if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then inc(j,2)
     else if(Content[j]=#10) or (Content[j]=#13) then inc(j);
     row:=1; i:=j;
    end
   else if(i=len) then
    begin
     inc(LineList.LineCount);
     SetLength(LineList.Line,LineList.LineCount);
     tempstr:=Copy(Content,j,i-j+1);
     LineList.Line[LineList.LineCount-1]:=unild_script_analyze(tempstr,row);
     j:=i+1; row:=1;
    end;
   inc(i);
  end;
 {Scanning the Line from the Content while checking the error for the line}
 i:=1; j:=1;
 Result.EntryName:=''; Result.Interpreter:=''; Result.NoDefaultLibrary:=false; Result.Symbolic:=false;
 Result.elfclass:=unild_class_executable; Result.IsEFIFile:=false; Result.EFIFileIndex:=0;
 Result.DynamicLibraryPathCount:=0; Result.NoSymbol:=false; Result.NoExternalLibrary:=false;
 Result.SectionCount:=0; Result.InputFileCount:=0; Result.DynamicLibraryCount:=0;
 Result.BaseAddress:=0; Result.NoFixedAddress:=true; Result.SystemIndex:=0;
 Result.NoExecutableStack:=false; Result.GotAuthority:=unild_writable_got;
 if(ScriptEnable) then Result:=Script;
 while(i<=LineList.LineCount)do
  begin
   if(LineList.Line[i-1].Count>0) then
    begin
     if(LowerCase(LineList.Line[i-1].Item[0])='noexecstack') or
     (LowerCase(LineList.Line[i-1].Item[0])='noexecutablestack') then
      begin
       Result.NoExecutableStack:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='pie') then
      begin
       Result.NoFixedAddress:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='static_pie') or
     (LowerCase(LineList.Line[i-1].Item[0])='staticpie') then
      begin
       Result.NoFixedAddress:=true; Result.Interpreter:='';
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='disablefilesymbol') or
     (LowerCase(LineList.Line[i-1].Item[0])='disable_filesymbol') or
     (LowerCase(LineList.Line[i-1].Item[0])='disable_file_symbol') then
      begin
       Result.EnableFileInformation:=false;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='disablesectionsymbol') or
     (LowerCase(LineList.Line[i-1].Item[0])='disable_sectionsymbol') or
     (LowerCase(LineList.Line[i-1].Item[0])='disable_section_symbol') then
      begin
       Result.EnableSectionInformation:=false;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='nogotwritable') or
     (LowerCase(LineList.Line[i-1].Item[0])='gotnotwritable') or
     (LowerCase(LineList.Line[i-1].Item[0])='got_notwritable') or
     (LowerCase(LineList.Line[i-1].Item[0])='got_readonly') or
     (LowerCase(LineList.Line[i-1].Item[0])='gotreadonly') then
      begin
       Result.GotAuthority:=unild_readonly_got;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='gotwritable') or
     (LowerCase(LineList.Line[i-1].Item[0])='got_writable') then
      begin
       Result.GotAuthority:=unild_writable_got;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='gotnocheck') or
     (LowerCase(LineList.Line[i-1].Item[0])='got_nocheck') or
     (LowerCase(LineList.Line[i-1].Item[0])='nocheckgot') or
     (LowerCase(LineList.Line[i-1].Item[0])='nocheck_got') then
      begin
       Result.GotAuthority:=unild_unchecked_got;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='nodeflib') or
     (LowerCase(LineList.Line[i-1].Item[0])='nodefaultlib') or
     (LowerCase(LineList.Line[i-1].Item[0])='nodefaultlibrary') then
      begin
       Result.NoDefaultLibrary:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='noextlib') or
     (LowerCase(LineList.Line[i-1].Item[0])='noexterallib') or
     (LowerCase(LineList.Line[i-1].Item[0])='noexterallibrary') then
      begin
       Result.NoExternalLibrary:=true;
       if(not Result.NoDefaultLibrary) then Result.NoDefaultLibrary:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='got_enable') or
     (LowerCase(LineList.Line[i-1].Item[0])='gotenable') then
      begin
       Result.GlobalOffsetTableSectionEnable:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='dynamic_enable') or
     (LowerCase(LineList.Line[i-1].Item[0])='dynamicenable') then
      begin
       Result.DynamicSectionEnable:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='debug_enable') or
     (LowerCase(LineList.Line[i-1].Item[0])='debugenable') then
      begin
       Result.DebugSwitch:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='version_enable') or
     (LowerCase(LineList.Line[i-1].Item[0])='versionenable') or
     (LowerCase(LineList.Line[i-1].Item[0])='verenable') or
     (LowerCase(LineList.Line[i-1].Item[0])='ver_enable')  then
      begin
       Result.VersionSwitch:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='sharedobject') or
     (LowerCase(LineList.Line[i-1].Item[0])='sharedlibrary') then
      begin
       Result.elfclass:=unild_class_sharedobject;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='relocatable') then
      begin
       Result.elfclass:=unild_class_relocatable;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='core') then
      begin
       Result.elfclass:=unild_class_core;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='executable') then
      begin
       Result.elfclass:=unild_class_executable;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='symbolic') then
      begin
       Result.Symbolic:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='entryasstart') then
      begin
       Result.EntryAsStartOfSection:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='nosymbol')
     or(LowerCase(LineList.Line[i-1].Item[0])='deletesymbol')
     or(LowerCase(LineList.Line[i-1].Item[0])='delete_symbol')
     or(LowerCase(LineList.Line[i-1].Item[0])='stripsymbol')
     or(LowerCase(LineList.Line[i-1].Item[0])='strip_symbol')
     or(LowerCase(LineList.Line[i-1].Item[0])='discardsymbol')
     or(LowerCase(LineList.Line[i-1].Item[0])='discard_symbol')then
      begin
       Result.NoSymbol:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='startonentry') or
     (LowerCase(LineList.Line[i-1].Item[0])='start_onentry') or
     (LowerCase(LineList.Line[i-1].Item[0])='start_on_entry') then
      begin
       Result.EntryAsStartOfSection:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='linkall') or
     (LowerCase(LineList.Line[i-1].Item[0])='nosmartlink') or
     (LowerCase(LineList.Line[i-1].Item[0])='nosmartlinking') or
     (LowerCase(LineList.Line[i-1].Item[0])='nosmart')then
      begin
       Result.LinkAll:=true; Result.SmartLinking:=false;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='untypedbinary')
     or(LowerCase(LineList.Line[i-1].Item[0])='untyped_binary') then
      begin
       Result.IsUntypedBinary:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='smartlinking') or
     (LowerCase(LineList.Line[i-1].Item[0])='smartlink') or
     (LowerCase(LineList.Line[i-1].Item[0])='smart') then
      begin
       Result.SmartLinking:=true; Result.LinkAll:=false;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='linux')
     or(LowerCase(LineList.Line[i-1].Item[0])='gnu')
     or(LowerCase(LineList.Line[i-1].Item[0])='gnulinux') then
      begin
       Result.SystemIndex:=1;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='efiapplication')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_application')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_app')
     or(LowerCase(LineList.Line[i-1].Item[0])='efiapp')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefi_application')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefiapplication')then
      begin
       Result.IsEFIFile:=true; Result.EFIFileIndex:=unild_class_application;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='efirom')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_rom')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefi_rom')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefirom')then
      begin
       Result.IsEFIFile:=true; Result.EFIFileIndex:=unild_class_rom;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='efibootdriver')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_bootdriver')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_boot_driver')
     or(LowerCase(LineList.Line[i-1].Item[0])='efibootdrv')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_bootdrv')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_boot_drv')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefi_boot_driver')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefi_bootdriver')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefibootdriver')then
      begin
       Result.IsEFIFile:=true; Result.EFIFileIndex:=unild_class_bootdriver;
       Result.NoExternalLibrary:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='efiruntimedriver')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_runtimedriver')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_runtime_driver')
     or(LowerCase(LineList.Line[i-1].Item[0])='efiruntimedrv')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_runtimedrv')
     or(LowerCase(LineList.Line[i-1].Item[0])='efi_runtime_drv')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefi_runtime_driver')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefi_runtimedriver')
     or(LowerCase(LineList.Line[i-1].Item[0])='uefiruntimedriver')then
      begin
       Result.IsEFIFile:=true; Result.EFIFileIndex:=unild_class_runtimedriver;
       Result.NoExternalLibrary:=true;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='gotalias')
     or(LowerCase(LineList.Line[i-1].Item[0])='got_alias') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LineList.Line[i-1].Item[2];
         Result.GlobalOffsetTableAlias:=tempstr1;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:GOT(Global Offset Table) Alias '+
         'must be gotalias/got_alias(alias).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='dynamicalias')
     or(LowerCase(LineList.Line[i-1].Item[0])='dynamic_alias') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LineList.Line[i-1].Item[2];
         Result.DynamicSectionAlias:=tempstr1;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Dynamic Section Alias '+
         'must be dynamicalias/dynamic_alias(alias).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='sharedlibraryname')
     or(LowerCase(LineList.Line[i-1].Item[0])='shared_library_name')
     or(LowerCase(LineList.Line[i-1].Item[0])='sharedlibrary_name') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LineList.Line[i-1].Item[2];
         Result.SharedLibraryName:=tempstr1;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Shared Library Name(filename) '+
         'must be sharedlibraryname/shared_library_name/sharedlibrary_name(internal name).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='filealign')
     or(LowerCase(LineList.Line[i-1].Item[0])='file_align') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LineList.Line[i-1].Item[2];
         Result.FileAlign:=unild_script_str_to_int(tempstr1);
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:File Align must be filealign(alignvalue).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='untypedbinaryalign')
     or(LowerCase(LineList.Line[i-1].Item[0])='untypedbinary_align')
     or(LowerCase(LineList.Line[i-1].Item[0])='untyped_binary_align')then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LineList.Line[i-1].Item[2];
         Result.IsUntypedBinary:=true;
         Result.UntypedBinaryAlign:=unild_script_str_to_int(tempstr1);
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Binary align must be binaryalign(alignvalue).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='baseaddress')
     or(LowerCase(LineList.Line[i-1].Item[0])='base_address')
     or(LowerCase(LineList.Line[i-1].Item[0])='startaddress')
     or(LowerCase(LineList.Line[i-1].Item[0])='start_address') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LineList.Line[i-1].Item[2];
         Result.BaseAddress:=unild_script_str_to_int(tempstr1);
         Result.NoFixedAddress:=false;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Base Address must be baseaddress/base_address/startaddress/start_address'+
         '(address).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='entry')
     or(LowerCase(LineList.Line[i-1].Item[0])='entry_name')
     or(LowerCase(LineList.Line[i-1].Item[0])='entry_symbol')
     or(LowerCase(LineList.Line[i-1].Item[0])='entryname')
     or(LowerCase(LineList.Line[i-1].Item[0])='entrysymbol') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LineList.Line[i-1].Item[2];
         if(length(tempstr1)>=2) then
          begin
           if(tempstr1[1]='"') or (tempstr1[1]=#39) then
           Result.EntryName:=Copy(tempstr1,2,length(tempstr1)-2)
           else
           Result.EntryName:=tempstr1;
          end
         else Result.EntryName:=tempstr1;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Entry Name must be entry/entry_name/entryname/entry_symbol/entrysymbol'+
         '(entryname)');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='interpreter') or
     (LowerCase(LineList.Line[i-1].Item[0])='interp') then
      begin
       if(LineList.Line[i-1].Count>=4) then
        begin
         j:=3; k:=4;
         while(j<=LineList.Line[i-1].Count)do
          begin
           k:=j+1; tempstr2:=LineList.Line[i-1].Item[j-1];
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=')') or (LineList.Line[i-1].Item[k-1]=',') then break;
             tempstr2:=tempstr2+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           tempstr1:=tempstr2;
           if(length(tempstr1)>=2) and (((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
           ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           Result.Interpreter:=tempstr1;
           if(FileExists(Result.Interpreter)) then break
           else Result.Interpreter:='';
           j:=k+1;
          end;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Interpreter Name must be interpreter/interp(interpretername).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='interpreter_need_function') or
     (LowerCase(LineList.Line[i-1].Item[0])='interpreter_needfunction') or
     (LowerCase(LineList.Line[i-1].Item[0])='interpreterneedfunction') or
     (LowerCase(LineList.Line[i-1].Item[0])='interp_need_function') or
     (LowerCase(LineList.Line[i-1].Item[0])='interp_needfunction') or
     (LowerCase(LineList.Line[i-1].Item[0])='interpneedfunction') then
      begin
       if(LineList.Line[i-1].Count>=4) then
        begin
         j:=3; k:=4;
         while(j<=LineList.Line[i-1].Count)do
          begin
           k:=j+1; tempstr2:=LineList.Line[i-1].Item[j-1];
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=')') or (LineList.Line[i-1].Item[k-1]=',') then break;
             tempstr2:=tempstr2+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           tempstr1:=tempstr2;
           if(length(tempstr1)>=2) and (((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
           ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           Result.InterpreterDynamicLinkFunction:=tempstr1;
           j:=k+1;
          end;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Interpreter Needed Function Name must be '+
         'interpreter_need_function/interpreter_needfunction/interpreterneedfunction'+
         'interp_need_function/interp_needfunction/interpneedfunction'+
         '(interpretername).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='dynamiclibrary')
     or(LowerCase(LineList.Line[i-1].Item[0])='dynamic_library')
     or(LowerCase(LineList.Line[i-1].Item[0])='sharedlibrary')
     or(LowerCase(LineList.Line[i-1].Item[0])='shared_library') then
      begin
       if(LineList.Line[i-1].Count>=4) then
        begin
         j:=3; k:=4;
         while(j<=LineList.Line[i-1].Count)do
          begin
           k:=j+1; tempstr2:=LineList.Line[i-1].Item[j-1];
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=')') or (LineList.Line[i-1].Item[k-1]=',') then break;
             tempstr2:=tempstr2+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           tempstr1:=tempstr2;
           if(length(tempstr1)>=2) and (((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
           ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           tempstr3:=ExtractFileName(tempstr1);
           inc(Result.DynamicLibraryCount);
           SetLength(Result.DynamicLibrary,Result.DynamicLibraryCount);
           Result.DynamicLibrary[Result.DynamicLibraryCount-1]:=ExtractFileName(tempstr3);
           if(tempstr1<>tempstr3) then
            begin
             tempstr1:=Copy(tempstr1,1,length(tempstr1)-length(tempstr3)-1);
             if(tempstr1<>'') then
              begin
               j:=k+1; continue;
              end;
             inc(Result.DynamicLibraryPathCount);
             SetLength(Result.DynamicLibraryPath,Result.DynamicLibraryPathCount);
             Result.DynamicLibraryPath[Result.DynamicLibraryPathCount-1]:=
             tempstr1;
            end;
           j:=k+1;
          end;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Dynamic Library Name must be dynamiclibrary/dynamic_library'
         +'/sharedlibrary/shared_library(Libraryname/LibraryPath)');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='dynamiclibrarysearchpath')
     or(LowerCase(LineList.Line[i-1].Item[0])='dynamic_library_search_path')
     or(LowerCase(LineList.Line[i-1].Item[0])='dynamic_library_searchpath')
     or(LowerCase(LineList.Line[i-1].Item[0])='dynamiclibrary_search_path')
     or(LowerCase(LineList.Line[i-1].Item[0])='dynamiclibrary_searchpath')
     or(LowerCase(LineList.Line[i-1].Item[0])='sharedlibrarysearchpath')
     or(LowerCase(LineList.Line[i-1].Item[0])='shared_library_search_path')
     or(LowerCase(LineList.Line[i-1].Item[0])='shared_library_searchpath')
     or(LowerCase(LineList.Line[i-1].Item[0])='sharedlibrary_search_path')
     or(LowerCase(LineList.Line[i-1].Item[0])='sharedlibrary_searchpath') then
      begin
       if(LineList.Line[i-1].Count>=4) then
        begin
         j:=3; k:=4;
         while(j<=LineList.Line[i-1].Count)do
          begin
           k:=j+1; tempstr2:=LineList.Line[i-1].Item[j-1];
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=')') or (LineList.Line[i-1].Item[k-1]=',') then break;
             tempstr2:=tempstr2+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           tempstr1:=tempstr2;
           if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr[length(tempstr1)]='"')) or
           ((tempstr1[1]=#39) and (tempstr1[length(tempstr1)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           inc(Result.DynamicLibraryCount);
           SetLength(Result.DynamicLibraryPath,Result.DynamicLibraryPathCount);
           Result.DynamicLibraryPath[Result.DynamicLibraryPathCount-1]:=tempstr1;
           j:=k+1;
          end;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Dynamic Library Path must be '+
         'dynamiclibrarysearchpath/dynamic_library_search_path'+
         '/sharedlibrarysearchpath/shared_library_search_path(LibrarySearchPath)');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='dynamiclibrary_search_withsubdir') or
     (LowerCase(LineList.Line[i-1].Item[0])='dynamiclibrarysearch_withsubdir') or
     (LowerCase(LineList.Line[i-1].Item[0])='dynamiclibrarysearchwithsubdir') or
     (LowerCase(LineList.Line[i-1].Item[0])='sharedlibrary_search_withsubdir') or
     (LowerCase(LineList.Line[i-1].Item[0])='sharedlibrarysearch_withsubdir') or
     (LowerCase(LineList.Line[i-1].Item[0])='sharedlibrarysearchwithsubdir') then
      begin
       if(LineList.Line[i-1].Count>=4) then
        begin
         j:=3; k:=4;
         while(j<=LineList.Line[i-1].Count)do
          begin
           k:=j+1; tempstr2:=LineList.Line[i-1].Item[j-1];
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=')') or (LineList.Line[i-1].Item[k-1]=',') then break;
             tempstr2:=tempstr2+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           tempstr1:=tempstr2;
           if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr1[length(tempstr1)]='"')) or
           ((tempstr1[1]=#39) and (tempstr1[length(tempstr1)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           inc(Result.DynamicPathWithSubDirectoryCount);
           SetLength(Result.DynamicPathWithSubDirectoryList,
           Result.DynamicPathWithSubDirectoryCount);
           Result.DynamicPathWithSubDirectoryList[
           Result.DynamicPathWithSubDirectoryCount-1]:=tempstr1;
           j:=k+1;
          end;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Dynamic Library Path must be '+
         'dynamiclibrary_search_withsubdir/dynamiclibrarysearch_withsubdir/'
         +'dynamiclibrary_search_withsubdir/sharedlibrary_search_withsubdir'
         +'/sharedlibrarysearch_withsubdir/sharedlibrary_search_withsubdir'
         +'(LibrarySearchPath(withSubDirectory))');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='bits')
     or(LowerCase(LineList.Line[i-1].Item[0])='filebits')
     or(LowerCase(LineList.Line[i-1].Item[0])='file_bits') then
      begin
       if(LineList.Line[i-1].Count>=4) then
        begin
         tempstr1:=LowerCase(LineList.Line[i-1].Item[2]);
         if(length(tempstr1)>=2) then
          begin
           if(tempstr1[1]='"') or (tempstr1[1]=#39) then
           Result.Bits:=unild_script_str_to_int(Copy(tempstr1,2,length(tempstr1)-2))
           else
           Result.Bits:=unild_script_str_to_int(tempstr1);
          end
         else Result.Bits:=unild_script_str_to_int(tempstr1);
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:File Bits must be file_bits/bits/filebits(bitvalue) and not define at least twice.');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='output_architecture')
     or(LowerCase(LineList.Line[i-1].Item[0])='outputarchitecture')
     or(LowerCase(LineList.Line[i-1].Item[0])='output_arch')
     or(LowerCase(LineList.Line[i-1].Item[0])='outputarch') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LowerCase(LineList.Line[i-1].Item[2]);
         if(length(tempstr1)>=2) then
          begin
           if(tempstr1[1]='"') or (tempstr1[1]=#39) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
          end;
         if(tempstr1='i386') or (tempstr1='ia32') then
          begin
           Result.InputArchitecture:=elf_machine_386; Result.InputBits:=32;
          end
         else if(tempstr1='x86_64') or (tempstr1='x86')
         or (tempstr1='amd64') then
          begin
           Result.InputArchitecture:=elf_machine_x86_64; Result.InputBits:=64;
          end
         else if(tempstr1='arm') or (tempstr1='arm32') or
         (tempstr1='aarch32') then
          begin
           Result.InputArchitecture:=elf_machine_arm; Result.InputBits:=32;
          end
         else if(tempstr1='arm64') or (tempstr1='aarch64') then
          begin
           Result.InputArchitecture:=elf_machine_aarch64; Result.InputBits:=64;
          end
         else if(tempstr1='riscv32') or (tempstr1='rv32') then
          begin
           Result.InputArchitecture:=elf_machine_riscv; Result.InputBits:=32;
          end
         else if(tempstr1='riscv64') or (tempstr1='rv64') then
          begin
           Result.InputArchitecture:=elf_machine_riscv; Result.InputBits:=64;
          end
         else if(tempstr1='loongarch32') or (tempstr1='la32') then
          begin
           Result.InputArchitecture:=elf_machine_loongarch; Result.InputBits:=32;
          end
         else if(tempstr1='loongarch64') or (tempstr1='la64') then
          begin
           Result.InputArchitecture:=elf_machine_loongarch; Result.InputBits:=64;
          end
         else
          begin
           writeln('ERROR:Unsupported Architecture '+tempstr1);
           readln;
           halt;
          end;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Output Architecture must be '+
         'output_architecture/outputarchitecture/output_arch/outputarch(Architecture).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='input_architecture')
     or(LowerCase(LineList.Line[i-1].Item[0])='inputarchitecture')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_arch')
     or(LowerCase(LineList.Line[i-1].Item[0])='inputarch') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LowerCase(LineList.Line[i-1].Item[2]);
         if(length(tempstr1)>=2) then
          begin
           if(tempstr1[1]='"') or (tempstr1[1]=#39) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
          end;
         if(tempstr1='i386') or (tempstr1='ia32') then
          begin
           Result.OutputArchitecture:=elf_machine_386; Result.OutputBits:=32;
          end
         else if(tempstr1='x86_64') or (tempstr1='x86')
         or (tempstr1='amd64') then
          begin
           Result.OutputArchitecture:=elf_machine_x86_64; Result.OutputBits:=64;
          end
         else if(tempstr1='arm') or (tempstr1='arm32') or
         (tempstr1='aarch32') then
          begin
           Result.OutputArchitecture:=elf_machine_arm; Result.OutputBits:=32;
          end
         else if(tempstr1='arm64') or (tempstr1='aarch64') then
          begin
           Result.OutputArchitecture:=elf_machine_aarch64; Result.OutputBits:=64;
          end
         else if(tempstr1='riscv32') or (tempstr1='rv32') then
          begin
           Result.OutputArchitecture:=elf_machine_riscv; Result.OutputBits:=32;
          end
         else if(tempstr1='riscv64') or (tempstr1='rv64') then
          begin
           Result.OutputArchitecture:=elf_machine_riscv; Result.OutputBits:=64;
          end
         else if(tempstr1='loongarch32') or (tempstr1='la32') then
          begin
           Result.OutputArchitecture:=elf_machine_loongarch; Result.OutputBits:=32;
          end
         else if(tempstr1='loongarch64') or (tempstr1='la64') then
          begin
           Result.OutputArchitecture:=elf_machine_loongarch; Result.OutputBits:=64;
          end
         else
          begin
           writeln('ERROR:Unsupported Architecture '+tempstr1);
           readln;
           halt;
          end;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:input Architecture must be '+
         'input_architecture/inputarchitecture/input_arch/inputarch(Architecture).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='output_filename')
     or(LowerCase(LineList.Line[i-1].Item[0])='outputfilename')
     or(LowerCase(LineList.Line[i-1].Item[0])='output') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         tempstr1:=LowerCase(LineList.Line[i-1].Item[2]);
         if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr1[length(tempstr1)]='"')) or
         ((tempstr1[1]=#39) and (tempstr1[length(tempstr1)]=#39))) then
         tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
         Result.OutputFileName:=tempstr1;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+', Row 1');
         writeln('ERROR:Output FileName must be output_filename/outputfilename/output(filename).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='inputfile')
     or(LowerCase(LineList.Line[i-1].Item[0])='input')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_file') then
      begin
       if(LineList.LineCount>=4) then
        begin
         j:=3; k:=4;
         while(j<=LineList.Line[i-1].Count)do
          begin
           k:=j+1; tempstr2:=LineList.Line[i-1].Item[j-1];
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=')') or (LineList.Line[i-1].Item[k-1]=',') then break;
             tempstr2:=tempstr2+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           tempstr1:=tempstr2;
           if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr1[length(tempstr1)]='"')) or
           ((tempstr1[1]=#39) and (tempstr1[length(tempstr1)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           inc(Result.InputFileCount);
           SetLength(Result.InputFile,Result.InputFileCount);
           Result.InputFile[Result.InputFileCount-1]:=tempstr1;
           j:=k+1;
          end;
        end
       else if(LineList.Line[i-1].Count=3) then
        begin
         writeln('ERROR in Column '+IntToStr(i)+' ,Row 1');
         writeln('ERROR:Input FileName must not be empty.');
         readln;
         halt;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+' ,Row 1');
         writeln('ERROR:Input FileName must be inputfile/input/inputfile().');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='inputfilepath')
     or(LowerCase(LineList.Line[i-1].Item[0])='inputpath')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_path')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_file_path')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_filepath') then
      begin
       if(LineList.LineCount>=4) then
        begin
         j:=3; k:=4;
         while(j<=LineList.Line[i-1].Count)do
          begin
           k:=j+1; tempstr2:=LineList.Line[i-1].Item[j-1];
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=')') or (LineList.Line[i-1].Item[k-1]=',') then break;
             tempstr2:=tempstr2+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           tempstr1:=tempstr2;
           if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr1[length(tempstr1)]='"')) or
           ((tempstr1[1]=#39) and (tempstr1[length(tempstr1)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           inc(Result.InputFilePathCount);
           SetLength(Result.InputFilePath,Result.InputFilePathCount);
           SetLength(Result.InputFileHaveSubPath,Result.InputFilePathCount);
           Result.InputFilePath[Result.InputFilePathCount-1]:=tempstr1;
           Result.InputFileHaveSubPath[Result.InputFilePathCount-1]:=false;
           j:=k+1;
          end;
        end
       else if(LineList.Line[i-1].Count=3) then
        begin
         writeln('ERROR in Column '+IntToStr(i)+' ,Row 1');
         writeln('ERROR:Input File Path must not be empty.');
         readln;
         halt;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+' ,Row 1');
         writeln('ERROR:Input FileName must be input_file_path/input_filepath/input_path/inputpath/'
         +'inputfilepath(paths to the file).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='inputpath_withsub')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_path_withsub')
     or(LowerCase(LineList.Line[i-1].Item[0])='inputpathwithsub')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_pathwithsub')
     or(LowerCase(LineList.Line[i-1].Item[0])='inputfilepath_withsub')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_file_path_withsub')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_filepath_withsub')
     or(LowerCase(LineList.Line[i-1].Item[0])='inputfilepathwithsub')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_file_pathwithsub')
     or(LowerCase(LineList.Line[i-1].Item[0])='input_filepathwithsub') then
      begin
       if(LineList.LineCount>=4) then
        begin
         j:=3; k:=4;
         while(j<=LineList.Line[i-1].Count)do
          begin
           k:=j+1; tempstr2:=LineList.Line[i-1].Item[j-1];
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=')') or (LineList.Line[i-1].Item[k-1]=',') then break;
             tempstr2:=tempstr2+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           tempstr1:=tempstr2;
           if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr1[length(tempstr1)]='"')) or
           ((tempstr1[1]=#39) and (tempstr1[length(tempstr1)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           inc(Result.InputFilePathCount);
           SetLength(Result.InputFilePath,Result.InputFilePathCount);
           SetLength(Result.InputFileHaveSubPath,Result.InputFilePathCount);
           Result.InputFilePath[Result.InputFilePathCount-1]:=tempstr1;
           Result.InputFileHaveSubPath[Result.InputFilePathCount-1]:=true;
           j:=k+1;
          end;
        end
       else if(LineList.Line[i-1].Count=3) then
        begin
         writeln('ERROR in Column '+IntToStr(i)+' ,Row 1');
         writeln('ERROR:Input File Path With Sub Directory must not be empty.');
         readln;
         halt;
        end
       else
        begin
         writeln('ERROR in Column '+IntToStr(i)+' ,Row 1');
         writeln('ERROR:Input FileName must be inputfilepath_withsub/inputpath_withsub/'+
         'input_path_withsub/input_file_path_withsub/input_filepath_withsub/'+
         'inputfilepathwithsub/inputpathwithsub/input_pathwithsub/input_file_pathwithsub'+
         'input_filepathwithsub(File Paths which contains object files).');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='implicit_section_address')
     or(LowerCase(LineList.Line[i-1].Item[0])='implicitsection_address')
     or(LowerCase(LineList.Line[i-1].Item[0])='implicitsectionaddress') then
      begin
       j:=3;
       if(LineList.Line[i-1].Count>=6) then
        begin
         k:=j+1; tempstr1:=''; tempstr1:=''; m:=3;
         while(j<=LineList.Line[i-1].Count)do
          begin
           tempstr1:=''; k:=j+1; m:=j;
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=',') or (LineList.Line[i-1].Item[k-1]=')') then break;
             tempstr1:=tempstr1+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           if(tempstr1='') then
            begin
             tempstr1:=tempstr1;
             if(tempstr1='.strtab') or (tempstr1='.symtab') or (tempstr1='.shstrtab') then
              begin
               writeln('ERROR in Column ',i,',Row ',LineList.Line[i-1].Offset[j-1],':');
               writeln('ERROR:Typed section '+tempstr1+' is specified section auto-generated and'+
               'and it cannot to be changed,'+
               'cannot change address with the Implicit Section Address Command.');
               readln;
               halt;
              end
             else if(tempstr1<>'.hash')and(tempstr1<>'.gnu.hash')and(tempstr1<>'.dynamic')
             and(tempstr1<>'.dynsym')and(tempstr1<>'.dynstr')and(tempstr1<>'.got')
             and(tempstr1<>'.got.plt')and(Copy(tempstr1,1,5)<>'.rela')and(Copy(tempstr1,1,5)<>'.relr')
             and(Copy(tempstr1,1,4)<>'.rel')then
              begin
               writeln('ERROR in Column ',i,',Row ',LineList.Line[i-1].Offset[j-1],':');
               writeln('ERROR:Typed section '+tempstr1+' is not the implicit section,'+
               'cannot change its address with the Implicit Section Address Command.');
               readln;
               halt;
              end;
            end
           else
            begin
             tempvalue:=unild_str_to_int(tempstr1);
             inc(Script.ImplicitCount);
             SetLength(Script.ImplicitName,Script.ImplicitCount);
             SetLength(Script.ImplicitAddress,Script.ImplicitCount);
             Script.ImplicitName[i-1]:=tempstr1;
             Script.ImplicitAddress[i-1]:=tempvalue;
             tempstr1:='';
            end;
           j:=k+1;
          end;
         if(tempstr1='') then
          begin
           writeln('ERROR in Column ',i,',Row ',LineList.Line[i-1].Offset[m-1],':');
           writeln('ERROR:Typed section '+tempstr1+' address have not specified,must be specified '+
           'when the implicit section name specified.');
           readln;
           halt;
          end;
        end
       else
        begin
         writeln('ERROR in Column ',i,',Row '+IntToStr(LineList.Line[i-1].Offset[0])+':');
         writeln('ERROR:Implicit Section Address(implicit_section_address/'
         +'implicitsection_address/implicitsectionaddress(SectionName,SectionAddress,'+
         '...(with Section Name and Section Address Pair)) have no enough parameters.');
         readln;
         halt;
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='section') or
     (LowerCase(LineList.Line[i-1].Item[0])='sect') or
     (LowerCase(LineList.Line[i-1].Item[0])='sec') then
      begin
       j:=3;
       inc(Result.SectionCount);
       SetLength(Result.Section,Result.SectionCount);
       Result.Section[Result.SectionCount-1].SectionAttributeCount:=0;
       Result.Section[Result.SectionCount-1].SectionItemCount:=0;
       Result.Section[Result.SectionCount-1].SectionAddress:=0;
       Result.Section[Result.SectionCount-1].SectionAlign:=0;
       Result.Section[Result.SectionCount-1].SectionName:='';
       while(j<=LineList.Line[i-1].Count)do
        begin
         k:=j+1;
         while(k<=LineList.Line[i-1].Count)do
          begin
           if(LineList.Line[i-1].Item[k-1]=',') or (LineList.Line[i-1].Item[k-1]=')') then break;
           inc(k);
          end;
         if(k-j>2) then
          begin
           if((LowerCase(LineList.Line[i-1].Item[j-1])='address') or
           (LowerCase(LineList.Line[i-1].Item[j-1])='addr')) and
           (LineList.Line[i-1].Item[j]='=') then
            begin
             tempstr1:=LineList.Line[i-1].Item[j+1];
             Result.Section[Result.SectionCount-1].SectionAddress:=unild_script_str_to_int(tempstr1);
             Result.NoFixedAddress:=false;
            end
           else if(LowerCase(LineList.Line[i-1].Item[j-1])='align') and
           (LineList.Line[i-1].Item[j]='=') then
            begin
             tempstr1:=LineList.Line[i-1].Item[j+1];
             Result.Section[Result.SectionCount-1].SectionAlign:=unild_script_str_to_int(tempstr1);
            end;
          end
         else
          begin
           tempstr1:=unild_script_translate_string(LineList.Line[i-1].Item[j-1],true);
           if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr1[length(tempstr1)]='"')) or
           ((tempstr1[1]=#39) and (tempstr1[length(tempstr1)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           if(Result.Section[Result.SectionCount-1].SectionName='')
           and((tempstr1='.hash')or(tempstr1='.gnu.hash') or
           (tempstr1='.symtab')or(tempstr1='.strtab')or(tempstr1='.shstrtab')or(tempstr1='.dynamic')
           or(tempstr1='.dynsym')or(tempstr1='.dynstr')or(tempstr1='.got')or(tempstr1='.got.plt')
           or(Copy(tempstr1,1,5)='.rela')or(Copy(tempstr1,1,4)='.rel') or (Copy(tempstr1,1,5)='.relr')) then
            begin
             writeln('ERROR in Column '+IntToStr(i)+',Row '+IntToStr(LineList.Line[i-1].Offset[j-1])+':');
             writeln('Section Name '+tempstr1+' is a special section,cannot be specified in Linker Script.');
             readln;
             halt;
            end
           else if(Result.IsEFIFile) and (length(tempstr1)>8) then
            begin
             writeln('ERROR in Column '+IntToStr(i)+',Row '+IntToStr(LineList.Line[i-1].Offset[j-1])+':');
             writeln('Section Name '+tempstr1+' length exceeds 8,cannot generate this section in '+
             'the EFI File.');
             readln;
             halt;
            end
           else if(Result.Section[Result.SectionCount-1].SectionName='') then
           Result.Section[Result.SectionCount-1].SectionName:=tempstr1
           else
            begin
             inc(Result.Section[Result.SectionCount-1].SectionAttributeCount);
             setLength(Result.Section[Result.SectionCount-1].SectionAttribute,
             Result.Section[Result.SectionCount-1].SectionAttributeCount);
             Result.Section[Result.SectionCount-1].SectionAttribute[
             Result.Section[Result.SectionCount-1].SectionAttributeCount-1]:=LowerCase(tempstr1);
            end;
          end;
         if(LineList.Line[i-1].Item[k-1]=')') then break;
         j:=k+1;
        end;
       if(Result.Section[Result.SectionCount-1].SectionName='') then
        begin
         writeln('ERROR in the section '+IntToStr(Result.SectionCount)+':');
         writeln('ERROR:Section Name Not Found.');
         readln;
         halt;
        end;
       j:=i+1; BracketLayer:=0;
       while(j<=LineList.LineCount) do
        begin
         if(LineList.Line[j-1].Count>0) and
         ((LineList.Line[j-1].Item[0]='{') or (LowerCase(LineList.Line[j-1].Item[0])='begin')) then
          begin
           inc(BracketLayer);
          end
         else if(LineList.Line[j-1].Count>0) and
         ((LineList.Line[j-1].Item[0]='}') or (LowerCase(LineList.Line[j-1].Item[0])='end;')
          or (LowerCase(LineList.Line[j-1].Item[0])='end')
          or (LowerCase(LineList.Line[j-1].Item[0])='end.')) then
          begin
           if(BracketLayer=0) then
            begin
             writeln('ERROR in column '+IntToStr(j)+',Row '+IntToStr(LineList.Line[i-1].Offset[0])+':');
             writeln('Bracket not closed.');
             readln;
             halt;
            end;
           dec(BracketLayer);
           if(BracketLayer=0) then break;
          end
         else if(BracketLayer>0) and (LineList.Line[j-1].Count>=4) then
          begin
           tempstr1:=unild_script_translate_string(LineList.Line[j-1].Item[0],true);
           inc(Result.Section[Result.SectionCount-1].SectionItemCount);
           SetLength(Result.Section[Result.SectionCount-1].SectionItem,
           Result.Section[Result.SectionCount-1].SectionItemCount);
           Result.Section[Result.SectionCount-1].SectionItem[
           Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemCount:=0;
           if(LowerCase(tempstr1)='offset') or (LowerCase(tempstr1)='absoluteoffset')
           or(LowerCase(tempstr1)='absoffset') then
            begin
             if(LineList.Line[j-1].Count>4) then
              begin
               writeln('ERROR in Column '+IntToStr(j)+' ,Row 1');
               writeln('ERROR:Section Offset (Offset/absoluteOffset/absoffset(Value))'+
               'should be only one parameter.');
               readln;
               halt;
              end;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemClass:=unild_item_offset;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemOffset:=
             unild_script_str_to_int(LineList.Line[j-1].Item[2]);
            end
           else if(LowerCase(tempstr1)='reloffset') or (LowerCase(tempstr1)='relativeoffset') then
            begin
             if(LineList.Line[j-1].Count>4) then
              begin
               writeln('ERROR in Column '+IntToStr(j)+' ,Row 1');
               writeln('ERROR:Section RelativeOffset (RelOffset/RelativeOffset(Value))'
               +'should be only one parameter.');
               readln;
               halt;
              end;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemClass:=
             unild_item_relativeoffset;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemRelativeOffset:=
             unild_script_str_to_int(LineList.Line[j-1].Item[2]);
            end
           else if(LowerCase(tempstr1)='align') or (LowerCase(tempstr1)='internalalign') then
            begin
             if(LineList.Line[j-1].Count>4) then
              begin
               writeln('ERROR in Column '+IntToStr(j)+' ,Row 1');
               writeln('ERROR:Section Internal Align (align/internalalign(Value))'
               +'should be only one parameter.');
               readln;
               halt;
              end;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemClass:=unild_item_align;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemAlign:=
             unild_script_str_to_int(LineList.Line[j-1].Item[2]);
            end
           else if(tempstr1='*') or (LowerCase(tempstr1)='keep') or (LowerCase(tempstr1)='maintain')
           or (LowerCase(tempstr1)='preserve') or (LowerCase(tempstr1)='useful')
           or (LowerCase(tempstr1)='smart') then
            begin
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemClass:=unild_item_filter;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemKeep:=false;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemSmart:=false;
             if(LowerCase(tempstr1)='keep') or (LowerCase(tempstr1)='maintain')
             or(LowerCase(tempstr1)='preserve') then
              begin
               Result.Section[Result.SectionCount-1].SectionItem[
               Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemKeep:=true;
              end
             else if(LowerCase(tempstr1)='smart') or (LowerCase(tempstr1)='useful') then
              begin
               Result.Section[Result.SectionCount-1].SectionItem[
               Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemSmart:=true;
              end;
             k:=3; tempstr2:='';
             while(k<=LineList.Line[j-1].Count)do
              begin
               if(LineList.Line[j-1].Item[k-1]=',') or (LineList.Line[j-1].Item[k-1]=')') then
                begin
                 inc(Result.Section[Result.SectionCount-1].SectionItem[
                 Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemCount);
                 SetLength(Result.Section[Result.SectionCount-1].SectionItem[
                 Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemFilter,
                 Result.Section[Result.SectionCount-1].SectionItem[
                 Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemCount);
                 Result.Section[Result.SectionCount-1].SectionItem
                 [Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemFilter
                 [Result.Section[Result.SectionCount-1].SectionItem[
                  Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemCount-1]:=tempstr2;
                 tempstr2:='';
                end
               else tempstr2:=tempstr2+LineList.Line[j-1].Item[k-1];
               if(LineList.Line[j-1].Item[k-1]=')') then break;
               inc(k);
              end;
            end
           else
            begin
             writeln('ERROR in Column '+IntToStr(j)+' ,Row 1');
             writeln('ERROR:Section Item should be vaild.');
             readln;
             halt;
            end;
          end
         else if(BracketLayer>0) and (j=LineList.LineCount) then
          begin
           writeln('ERROR in column '+IntToStr(j)+',Row '+IntToStr(LineList.Line[i-1].Offset[0])+':');
           writeln('ERROR:Bracket not closed.');
           readln;
           halt;
          end;
         inc(j);
        end;
       i:=j;
      end;
    end;
   inc(i);
  end;
 if(Result.elfclass=unild_class_relocatable) and (Result.NoSymbol) then Result.NoSymbol:=false;
 if(Result.elfclass=unild_class_relocatable) then Result.Interpreter:='';
 Result.SectionCountExtra:=0;
 if(not ((Result.IsUntypedBinary=false) and
 (Result.IsEFIFile=false) and (Result.elfclass=unild_class_relocatable))) then
  begin
   if(Script.DynamicSectionEnable) then
    begin
     inc(Result.SectionCountExtra); Result.DynamicSectionIndex:=Result.SectionCountExtra;
    end;
   if(Script.GlobalOffsetTableSectionEnable) then
    begin
     inc(Result.SectionCountExtra); Result.GlobalOffsetTableSectionIndex:=Result.SectionCountExtra;
    end;
  end;
 {Free the String List}
 StrList.Free;
end;
function unild_generate_default_elf_file:unild_script;
var i:SizeUint;
begin
 if(ScriptEnable) then Result:=Script;
 if(Script.DebugSwitch) then Result.SectionCount:=19 else Result.SectionCount:=13;
 if(Script.VersionSwitch) then inc(Result.SectionCount,3);
 SetLength(Result.Section,Result.SectionCount);
 i:=1;
 if(Result.EntryName='') then Result.EntryName:='_start';
 if(Result.FileAlign=0) then Result.FileAlign:=$1000;
 {Set the Section .text,can be read and execute}
 Result.Section[i-1].SectionName:='.text';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='execute';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.text*';
 inc(i);
 {Set the Section .init_array,can be read and execute}
 Result.Section[i-1].SectionName:='.init_array';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.init_array*';
 inc(i);
 {Set the Section .init,can be read and execute}
 Result.Section[i-1].SectionName:='.init';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='execute';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.init*';
 inc(i);
 {Set the Section .fini_array,can be read and execute}
 Result.Section[i-1].SectionName:='.fini_array';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.fini_array*';
 inc(i);
 {Set the Section .fini,can be read and execute}
 Result.Section[i-1].SectionName:='.fini';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='execute';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.fini*';
 inc(i);
 {Set the Section .preinit_array,can be read and execute}
 Result.Section[i-1].SectionName:='.preinit_array';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.preinit_array*';
 inc(i);
 {Set the Section .rodata,can be readonly}
 Result.Section[i-1].SectionName:='.rodata';
 Result.Section[i-1].SectionAttributeCount:=1;
 SetLength(Result.Section[i-1].SectionAttribute,1);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.rodata*';
 inc(i);
 {Set the Section .data,can be read and write}
 Result.Section[i-1].SectionName:='.data';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.data*';
 inc(i);
 {Set the Section .sdata,can be read and write}
 Result.Section[i-1].SectionName:='.sdata';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.sdata*';
 inc(i);
 {Set the Section .bss,can be read and write}
 Result.Section[i-1].SectionName:='.bss';
 Result.Section[i-1].SectionAttributeCount:=3;
 SetLength(Result.Section[i-1].SectionAttribute,3);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionAttribute[2]:='nobit';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.bss*';
 inc(i);
 {Set the Section .sbss,can be read and write}
 Result.Section[i-1].SectionName:='.sbss';
 Result.Section[i-1].SectionAttributeCount:=3;
 SetLength(Result.Section[i-1].SectionAttribute,3);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionAttribute[2]:='nobit';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.sbss*';
 inc(i);
 {Set the Section .tdata,can be read and write}
 Result.Section[i-1].SectionName:='.tdata';
 Result.Section[i-1].SectionAttributeCount:=3;
 SetLength(Result.Section[i-1].SectionAttribute,3);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionAttribute[2]:='tls';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.tdata*';
 inc(i);
 {Set the Section .tbss,can be read and write}
 Result.Section[i-1].SectionName:='.tdata';
 Result.Section[i-1].SectionAttributeCount:=3;
 SetLength(Result.Section[i-1].SectionAttribute,3);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionAttribute[2]:='tls';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.tbss*';
 inc(i);
 if(Script.DebugSwitch) then
  begin
   {Set the Section .debug_frame}
   Result.Section[i-1].SectionName:='.debug_frame';
   Result.Section[i-1].SectionAttributeCount:=0;
   SetLength(Result.Section[i-1].SectionAttribute,0);
   Result.Section[i-1].SectionItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem,1);
   Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
   Result.Section[i-1].SectionItem[0].ItemCount:=1;
   Result.Section[i-1].SectionItem[0].ItemKeep:=true;
   SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.debug_frame*';
   inc(i);
   {Set the Section .debug_info}
   Result.Section[i-1].SectionName:='.debug_info';
   Result.Section[i-1].SectionAttributeCount:=0;
   SetLength(Result.Section[i-1].SectionAttribute,0);
   Result.Section[i-1].SectionItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem,1);
   Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
   Result.Section[i-1].SectionItem[0].ItemCount:=1;
   Result.Section[i-1].SectionItem[0].ItemKeep:=true;
   SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.debug_info*';
   inc(i);
   {Set the Section .debug_line}
   Result.Section[i-1].SectionName:='.debug_line';
   Result.Section[i-1].SectionAttributeCount:=0;
   SetLength(Result.Section[i-1].SectionAttribute,0);
   Result.Section[i-1].SectionItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem,1);
   Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
   Result.Section[i-1].SectionItem[0].ItemCount:=1;
   Result.Section[i-1].SectionItem[0].ItemKeep:=true;
   SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.debug_line*';
   inc(i);
   {Set the Section .debug_aranges}
   Result.Section[i-1].SectionName:='.debug_aranges';
   Result.Section[i-1].SectionAttributeCount:=0;
   SetLength(Result.Section[i-1].SectionAttribute,0);
   Result.Section[i-1].SectionItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem,1);
   Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
   Result.Section[i-1].SectionItem[0].ItemCount:=1;
   Result.Section[i-1].SectionItem[0].ItemKeep:=true;
   SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.debug_aranges*';
   inc(i);
   {Set the Section .debug_ranges}
   Result.Section[i-1].SectionName:='.debug_ranges';
   Result.Section[i-1].SectionAttributeCount:=0;
   SetLength(Result.Section[i-1].SectionAttribute,0);
   Result.Section[i-1].SectionItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem,1);
   Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
   Result.Section[i-1].SectionItem[0].ItemCount:=1;
   Result.Section[i-1].SectionItem[0].ItemKeep:=true;
   SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.debug_ranges*';
   inc(i);
   {Set the Section .debug_addrev}
   Result.Section[i-1].SectionName:='.debug_abbrev';
   Result.Section[i-1].SectionAttributeCount:=0;
   SetLength(Result.Section[i-1].SectionAttribute,0);
   Result.Section[i-1].SectionItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem,1);
   Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
   Result.Section[i-1].SectionItem[0].ItemKeep:=true;
   Result.Section[i-1].SectionItem[0].ItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.debug_abbrev*';
   inc(i);
  end;
 if(Script.VersionSwitch) then
  begin
   {Set the Section .gnu_version}
   Result.Section[i-1].SectionName:='.gnu_version';
   Result.Section[i-1].SectionAttributeCount:=0;
   SetLength(Result.Section[i-1].SectionAttribute,0);
   Result.Section[i-1].SectionItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem,1);
   Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
   Result.Section[i-1].SectionItem[0].ItemKeep:=true;
   Result.Section[i-1].SectionItem[0].ItemCount:=2;
   SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,2);
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.gnu_version*';
   Result.Section[i-1].SectionItem[0].ItemFilter[1]:='.versym*';
   inc(i);
   {Set the Section .gnu_version}
   Result.Section[i-1].SectionName:='.gnu_version_d';
   Result.Section[i-1].SectionAttributeCount:=0;
   SetLength(Result.Section[i-1].SectionAttribute,0);
   Result.Section[i-1].SectionItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem,1);
   Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
   Result.Section[i-1].SectionItem[0].ItemKeep:=true;
   Result.Section[i-1].SectionItem[0].ItemCount:=2;
   SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,2);
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.gnu_version_d*';
   Result.Section[i-1].SectionItem[0].ItemFilter[1]:='.verdef*';
   inc(i);
   {Set the Section .gnu_version}
   Result.Section[i-1].SectionName:='.gnu_version_r';
   Result.Section[i-1].SectionAttributeCount:=0;
   SetLength(Result.Section[i-1].SectionAttribute,0);
   Result.Section[i-1].SectionItemCount:=1;
   SetLength(Result.Section[i-1].SectionItem,1);
   Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
   Result.Section[i-1].SectionItem[0].ItemKeep:=true;
   Result.Section[i-1].SectionItem[0].ItemCount:=2;
   SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,2);
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.gnu_version_r*';
   Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.verneed*';
   inc(i);
  end;
end;
function unild_generate_default_other_file:unild_script;
var i:SizeUint;
begin
 if(ScriptEnable) then Result:=Script;
 Result.SectionCount:=4; SetLength(Result.Section,4);
 i:=1;
 if(Result.EntryName='') then Result.EntryName:='_start';
 if(Result.FileAlign=0) then Result.FileAlign:=$1000;
 {Set the Section .text,can be read and execute}
 Result.Section[i-1].SectionName:='.text';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='execute';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.text*';
 inc(i);
 {Set the Section .rodata,can be read and execute}
 Result.Section[i-1].SectionName:='.rodata';
 Result.Section[i-1].SectionAttributeCount:=1;
 SetLength(Result.Section[i-1].SectionAttribute,1);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,1);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.rodata*';
 inc(i);
 {Set the Section .data,can be read and write}
 Result.Section[i-1].SectionName:='.data';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=2;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,2);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.data*';
 Result.Section[i-1].SectionItem[0].ItemFilter[1]:='.bss*';
 inc(i);
 {Set the Section .data,can be read and write}
 Result.Section[i-1].SectionName:='.sdata';
 Result.Section[i-1].SectionAttributeCount:=2;
 SetLength(Result.Section[i-1].SectionAttribute,2);
 Result.Section[i-1].SectionAttribute[0]:='read';
 Result.Section[i-1].SectionAttribute[1]:='write';
 Result.Section[i-1].SectionItemCount:=1;
 SetLength(Result.Section[i-1].SectionItem,1);
 Result.Section[i-1].SectionItem[0].ItemClass:=unild_item_filter;
 Result.Section[i-1].SectionItem[0].ItemCount:=2;
 SetLength(Result.Section[i-1].SectionItem[0].ItemFilter,2);
 Result.Section[i-1].SectionItem[0].ItemFilter[0]:='.sdata*';
 Result.Section[i-1].SectionItem[0].ItemFilter[1]:='.sbss*';
 inc(i);
end;

end.

