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
                   SectionAbsoluteAddress:boolean;
                   SectionAlign:dword;
                   SectionItem:array of unild_item;
                   SectionItemCount:SizeUint;
                   SectionMaxSize:SizeUint;
                   SectionMustHaveContent:boolean;
                   SectionKeepWhenEmpty:boolean;
                   SectionMaintainOriginalAlign:boolean;
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
                  GenerateVersion:boolean;
                  VersionContent:string;
                  GenerateLinkerSign:boolean;
                  LinkerSignContent:string;
                  GenerateCustomSign:boolean;
                  CustomSignSectionName:string;
                  CustomSignContent:string;
                  {For Linker Behaviour when get error}
                  LinkerWait:boolean;
                  {For Implicit Address of Output File}
                  ImplicitName:array of string;
                  ImplicitAddress:array of SizeUint;
                  ImplicitCount:SizeUint;
                  ImplicitSizeName:array of string;
                  ImplicitSize:array of SizeUint;
                  ImplicitSizeCount:SizeUint;
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
                     Column:array of dword;
                     Count:Dword;
                     end;
     unild_line=packed record
                OriginalLine:array of string;
                OriginalLineCount:SizeUint;
                Line:array of unild_line_item;
                LineColumn:array of SizeUint;
                LineCount:SizeUint;
                end;
{For unild script Bracket}
     unild_bracket_stack=packed record
                         BracketLeft:array of Dword;
                         BracketRight:array of Dword;
                         BracketCount:Dword;
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
function unild_script_match_mask(checkstr:string;mask:string;StartIndex:SizeUint=1):boolean;
function unild_translate_string(str:string):string;
function unild_check_str_int(str:string):boolean;
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
 Script.GenerateVersion:=false; Script.GenerateLinkerSign:=false;
 Script.VersionContent:=''; Script.LinkerSignContent:='unild version 0.0.4';
 Script.GenerateCustomSign:=false; Script.CustomSignContent:=''; Script.CustomSignSectionName:='';
 Script.ImplicitSizeCount:=0; Script.ImplicitCount:=0; Script.LinkerWait:=false;
end;
function unild_script_check_str_int(str:string):boolean;
const hex1:string='0123456789ABCDEF';
      hex2:string='0123456789abcdef';
var BitSize:byte;
    i,j,StartPoint,Len:SizeUint;
begin
 Len:=length(str); StartPoint:=1;
 if(len=0) then exit(false);
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
 for i:=StartPoint to len do
  begin
   j:=1;
   while(j<=BitSize)do
    begin
     if(str[i]=Hex1[j]) then break;
     if(str[i]=Hex2[j]) then break;
     inc(j);
    end;
   if(j>BitSize) then exit(false);
  end;
 Result:=true;
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
 Result:=0;
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
function unild_check_str_int(str:string):boolean;
begin
 Result:=unild_script_check_str_int(str);
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
function unild_script_analyze(content:string):unild_line_item;
var i,j,len:SizeUint;
    tempstr:string;
    bool:boolean;
    {For Content Column and Row}
    CurrentColumn,CurrentRow:SizeUint;
    {For Content Relative Column and Row}
    RelativeColumn,RelativeRow:SizeUint;
begin
 i:=1; len:=length(content); tempstr:='';
 Result.Count:=0; Bool:=false;
 SetLength(Result.Item,0); SetLength(Result.Offset,0); SetLength(Result.Column,0);
 CurrentColumn:=1; CurrentRow:=1; RelativeColumn:=1; RelativeRow:=1;
 while(i<=len)do
  begin
   if(Copy(Content,i,3)='###') then
    begin
     if(tempstr<>'') then
      begin
       inc(Result.Count);
       SetLength(Result.Item,Result.Count);
       SetLength(Result.Column,Result.Count);
       SetLength(Result.Offset,Result.Count);
       Result.Item[Result.Count-1]:=tempstr;
       Result.Column[Result.Count-1]:=CurrentColumn;
       Result.Offset[Result.Count-1]:=CurrentRow;
       CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
       tempstr:='';
      end;
     tempstr:=Copy(Content,i,3);
     RelativeColumn:=CurrentColumn; RelativeRow:=CurrentRow+3;
     j:=i+3;
     while(j<=len)do
      begin
       if(Copy(Content,j,3)='###') then
        begin
         TempStr:=TempStr+Copy(Content,j,3);
         inc(j,3); inc(RelativeRow,3); break;
        end
       else if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then
        begin
         TempStr:=TempStr+Copy(Content,j,2);
         inc(j,2); inc(RelativeColumn); RelativeRow:=1; continue;
        end
       else if(Content[j]=#13) or (Content[j]=#10) then
        begin
         TempStr:=TempStr+Content[j];
         inc(j); inc(RelativeColumn); RelativeRow:=1; continue;
        end
       else
        begin
         TempStr:=TempStr+Content[j]; inc(RelativeRow);
        end;
       inc(j);
      end;
     i:=j; CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow; TempStr:='';
     continue;
    end
   else if(Copy(Content,i,2)='(*') then
    begin
     if(tempstr<>'') then
      begin
       inc(Result.Count);
       SetLength(Result.Item,Result.Count);
       SetLength(Result.Column,Result.Count);
       SetLength(Result.Offset,Result.Count);
       Result.Item[Result.Count-1]:=tempstr;
       Result.Column[Result.Count-1]:=CurrentColumn;
       Result.Offset[Result.Count-1]:=CurrentRow;
       inc(RelativeRow); CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
       tempstr:='';
      end;
     tempstr:=Copy(Content,i,2);
     RelativeColumn:=CurrentColumn; RelativeRow:=CurrentRow+2;
     j:=i+1;
     while(j<=len)do
      begin
       if(Copy(Content,j,2)='*)') then
        begin
         TempStr:=TempStr+Copy(Content,j,2);
         inc(j,2); inc(RelativeRow,2); break;
        end
       else if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then
        begin
         TempStr:=TempStr+Copy(Content,j,2);
         inc(j,2); inc(RelativeColumn); RelativeRow:=1; continue;
        end
       else if(Content[j]=#13) or (Content[j]=#10) then
        begin
         TempStr:=TempStr+Content[j];
         inc(j); inc(RelativeColumn); RelativeRow:=1; continue;
        end
       else
        begin
         TempStr:=TempStr+Content[j]; inc(RelativeRow);
        end;
       inc(j);
      end;
     i:=j; CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow; TempStr:='';
     continue;
    end
   else if(Copy(Content,i,2)='/*') then
    begin
     if(tempstr<>'') then
      begin
       inc(Result.Count);
       SetLength(Result.Item,Result.Count);
       SetLength(Result.Column,Result.Count);
       SetLength(Result.Offset,Result.Count);
       Result.Item[Result.Count-1]:=tempstr;
       Result.Column[Result.Count-1]:=CurrentColumn;
       Result.Offset[Result.Count-1]:=CurrentRow;
       inc(RelativeRow); CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
       tempstr:='';
      end;
     tempstr:=Copy(Content,i,2);
     RelativeColumn:=CurrentColumn; RelativeRow:=CurrentRow+2;
     j:=i+1;
     while(j<=len)do
      begin
       if(Copy(Content,j,2)='*/') then
        begin
         TempStr:=TempStr+Copy(Content,j,2);
         inc(j,2); inc(RelativeRow,2); break;
        end
       else if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then
        begin
         TempStr:=TempStr+Copy(Content,j,2);
         inc(j,2); inc(RelativeColumn); RelativeRow:=1; continue;
        end
       else if(Content[j]=#13) or (Content[j]=#10) then
        begin
         TempStr:=TempStr+Content[j];
         inc(j); inc(RelativeColumn); RelativeRow:=1; continue;
        end
       else
        begin
         TempStr:=TempStr+Content[j]; inc(RelativeRow);
        end;
       inc(j);
      end;
     i:=j; CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow; TempStr:='';
     continue;
    end
   else if(Copy(Content,i,2)='//') then
    begin
     if(tempstr<>'') then
      begin
       inc(Result.Count);
       SetLength(Result.Item,Result.Count);
       SetLength(Result.Column,Result.Count);
       SetLength(Result.Offset,Result.Count);
       Result.Item[Result.Count-1]:=tempstr;
       Result.Column[Result.Count-1]:=CurrentColumn;
       Result.Offset[Result.Count-1]:=CurrentRow;
       inc(RelativeRow); CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
       tempstr:='';
      end;
     tempstr:=Copy(Content,i,2);
     RelativeColumn:=CurrentColumn; RelativeRow:=CurrentRow+2;
     j:=i+2;
     while(j<=len)do
      begin
       if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then
        begin
         inc(j,2); break;
        end
       else if(Content[j]=#13) or (Content[j]=#10) then
        begin
         inc(j); break;
        end;
       inc(j); inc(RelativeRow);
      end;
     i:=j; CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow; TempStr:='';
     continue;
    end
   else if(Content[i]='#') then
    begin
     if(tempstr<>'') then
      begin
       inc(Result.Count);
       SetLength(Result.Item,Result.Count);
       SetLength(Result.Column,Result.Count);
       SetLength(Result.Offset,Result.Count);
       Result.Item[Result.Count-1]:=tempstr;
       Result.Column[Result.Count-1]:=CurrentColumn;
       Result.Offset[Result.Count-1]:=CurrentRow;
       inc(RelativeRow); CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
       tempstr:='';
      end;
     tempstr:=Content[i];
     RelativeColumn:=CurrentColumn; RelativeRow:=CurrentRow+1;
     j:=i+1;
     while(j<=len)do
      begin
       if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then
        begin
         inc(j,2); break;
        end
       else if(Content[j]=#13) or (Content[j]=#10) then
        begin
         inc(j); break;
        end;
       inc(j); inc(RelativeRow);
      end;
     i:=j; CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow; TempStr:='';
     continue;
    end
   else if((content[i]='"') or (content[i]=#39)) then
    begin
     if(tempstr<>'') then
      begin
       inc(Result.Count);
       SetLength(Result.Item,Result.Count);
       SetLength(Result.Column,Result.Count);
       SetLength(Result.Offset,Result.Count);
       Result.Item[Result.Count-1]:=tempstr;
       Result.Column[Result.Count-1]:=CurrentColumn;
       Result.Offset[Result.Count-1]:=CurrentRow;
       inc(RelativeRow); CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
       tempstr:='';
      end;
     j:=i+1;
     RelativeColumn:=CurrentColumn; RelativeRow:=CurrentRow+1;
     while(j<=len)do
      begin
       if(Copy(Content,j,2)=#13#10) or (Copy(Content,j,2)=#10#13) then
        begin
         inc(RelativeColumn); RelativeRow:=1; inc(j,2);
        end
       else if(Content[j]=#10) or (Content[j]=#13) then
        begin
         inc(RelativeColumn); RelativeRow:=1; inc(j);
        end;
       if(j>i+3) and ((content[j]='"') or (content[j]=#39))
       and (content[j-1]='\') and (content[j-2]<>'\') then
        begin
         inc(RelativeRow); inc(j);
        end
       else if(j>i+2) and ((content[j]='"') or (content[j]=#39)) and (content[j-1]='\') then
        begin
         inc(RelativeRow); inc(j);
        end
       else if(content[j]='"') or (content[j]=#39) then
        begin
         inc(RelativeRow); inc(j); break;
        end;
       inc(j);
      end;
     inc(Result.Count);
     SetLength(Result.Item,Result.Count);
     SetLength(Result.Offset,Result.Count);
     SetLength(Result.Column,Result.Count);
     Result.Item[Result.Count-1]:=Copy(content,i,j-i+1);
     Result.Column[Result.Count-1]:=CurrentColumn;
     Result.Offset[Result.Count-1]:=CurrentRow;
     bool:=false; CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
     i:=j; continue;
    end
   else if(Copy(Content,i,2)=#13#10) or (Copy(Content,i,2)=#10#13) then
    begin
     inc(RelativeColumn); RelativeRow:=1; inc(i,2); continue;
    end
   else if(Content[i]=#13) or (Content[i]=#10) then
    begin
     inc(RelativeColumn); RelativeRow:=1; inc(i); continue;
    end
   else if(content[i]=',') or (content[i]=':') or (content[i]='(') or (content[i]=')')
   or (content[i]='=') or (content[i]='{') or (content[i]='}') then
    begin
     if(tempstr<>'') then
      begin
       inc(Result.Count);
       SetLength(Result.Item,Result.Count);
       SetLength(Result.Column,Result.Count);
       SetLength(Result.Offset,Result.Count);
       Result.Item[Result.Count-1]:=tempstr;
       Result.Column[Result.Count-1]:=CurrentColumn;
       Result.Offset[Result.Count-1]:=CurrentRow;
       inc(RelativeRow); CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
       tempstr:='';
      end;
     inc(Result.Count);
     SetLength(Result.Item,Result.Count);
     SetLength(Result.Column,Result.Count);
     SetLength(Result.Offset,Result.Count);
     Result.Item[Result.Count-1]:=content[i];
     Result.Column[Result.Count-1]:=CurrentColumn;
     Result.Offset[Result.Count-1]:=CurrentRow;
     CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow+1;
     bool:=false;
    end
   else if(i=len) and (content[i]>' ') then
    begin
     if(tempstr='') then
      begin
       tempstr:=content[i];
       inc(RelativeRow); CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
      end
     else tempstr:=tempstr+content[i];
     inc(Result.Count);
     SetLength(Result.Item,Result.Count);
     SetLength(Result.Column,Result.Count);
     SetLength(Result.Offset,Result.Count);
     Result.Item[Result.Count-1]:=tempstr;
     Result.Column[Result.Count-1]:=CurrentColumn;
     Result.Offset[Result.Count-1]:=CurrentRow;
     tempstr:='';
    end
   else if(bool=false) and (content[i]>' ') then
    begin
     tempstr:=content[i];
     inc(RelativeRow); CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
     bool:=true;
    end
   else if(bool) and (content[i]<=' ') then
    begin
     inc(Result.Count);
     SetLength(Result.Item,Result.Count);
     SetLength(Result.Column,Result.Count);
     SetLength(Result.Offset,Result.Count);
     Result.Item[Result.Count-1]:=tempstr;
     Result.Column[Result.Count-1]:=CurrentColumn;
     Result.Offset[Result.Count-1]:=CurrentRow;
     inc(RelativeRow); CurrentColumn:=RelativeColumn; CurrentRow:=RelativeRow;
     tempstr:=''; inc(RelativeRow); bool:=false;
    end
   else if(bool) then
    begin
     tempstr:=tempstr+content[i]; inc(RelativeRow);
    end
   else inc(RelativeRow);
   inc(i);
  end;
end;
function unild_script_match_mask(checkstr:string;mask:string;StartIndex:SizeUInt=1):boolean;
var i,j,len1,len2:SizeUint;
begin
 i:=StartIndex; j:=StartIndex;
 len1:=length(checkstr); len2:=length(mask);
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
procedure unild_script_raise_error(ErrorLine:string;ErrorColumn,ErrorRow:SizeUint;ErrorLength:SizeUint;
ErrorDetail:string);
var i:SizeUint;
begin
 writeln('ERROR appeared when in linker script parsing stage:');
 writeln('ERROR in Column '+IntToStr(ErrorColumn)+', Row '+IntToStr(ErrorRow)+':');
 writeln(ErrorLine);
 i:=1;
 while(i<=ErrorRow)do
  begin
   write(' '); inc(i);
  end;
 i:=1;
 while(i<=ErrorLength)do
  begin
   write('^'); inc(i);
  end;
 writeln('ERROR Detail:'+ErrorDetail);
 writeln('Please check the linker script inside for more information.');
 if(Script.LinkerWait) then readln;
 halt;
end;
function unild_script_read(filename:string):unild_script;
var StrList:TStringList;
    Content:string;
    {For Scanning the Content}
    LineList:unild_line;
    tempstr:string;
    tempbool:boolean;
    i,j,k,m,row,len:SizeUint;
    {For Content to the Linker Data}
    tempstr1,tempstr2,tempstr3:string;
    tempvalue:SizeUint;
    {For Raise Error when Linker Annotation not ended}
    CurrentColumn,CurrentRow:SizeUint;
    SearchColumn,SearchRow:SizeUint;
    CurrentLineStr:string;
    CurrentClass:byte;
    {For Bracket Stack}
    BracketStack:unild_bracket_stack;
    a,b:Dword;
begin
 {Read the String from File}
 StrList:=TStringList.Create;
 StrList.LoadFromFile(filename);
 {Translate the String to String Array to support linker script error handling}
 LineList.OriginalLineCount:=StrList.Count;
 SetLength(LineList.OriginalLine,StrList.Count);
 for i:=1 to StrList.Count do LineList.OriginalLine[i-1]:=StrList[i-1];
 {Set the String to Rehandle}
 Content:=StrList.Text;
 {Free the String List}
 StrList.Free;
 {Transform the string to Line}
 LineList.LineCount:=0; SetLength(LineList.Line,0);
 i:=1; j:=1; len:=length(Content); row:=1; TempStr:='';
 CurrentColumn:=1; CurrentRow:=1; SearchColumn:=1; SearchRow:=1;
 while(i<=len)do
  begin
   if(Copy(Content,i,3)='###') then
    begin
     j:=i+3; TempStr:=TempStr+'###';
     inc(SearchRow,3);
     while(j<=len)do
      begin
       if(Copy(Content,j,2)=#10#13) or (Copy(Content,j,2)=#13#10) then
        begin
         TempStr:=TempStr+Copy(Content,j,2);
         inc(j,2); inc(SearchColumn); SearchRow:=1;
        end
       else if(Content[j]=#10) or (Content[j]=#13) then
        begin
         TempStr:=TempStr+Content[j];
         inc(j); inc(SearchColumn); SearchRow:=1;
        end
       else
        begin
         TempStr:=TempStr+Content[j]; inc(SearchRow);
        end;
       if(Copy(Content,j,3)='###') then
        begin
         TempStr:=TempStr+'###';
         inc(j,3); inc(SearchRow,3); break;
        end;
       inc(j);
      end;
     if(j>len) then
      begin
       unild_script_raise_error(LineList.OriginalLine[CurrentColumn-1],CurrentColumn,CurrentRow,3,
       'Annotation Sign ### does not ended in the linker script file.');
      end;
     i:=j; continue;
    end
   else if(Copy(Content,i,2)='/*') or (Copy(Content,i,2)='(*') then
    begin
     j:=i+1; TempStr:=Content[i];
     inc(SearchRow,2);
     if(Copy(Content,i,2)='/*') then CurrentClass:=1
     else if(Copy(Content,i,2)='(*') then CurrentClass:=2;
     while(j<=len)do
      begin
       if(Copy(Content,j,2)=#10#13) or (Copy(Content,j,2)=#13#10) then
        begin
         TempStr:=TempStr+Copy(Content,j,2);
         inc(j,2); inc(SearchColumn); SearchRow:=1;
        end
       else if(Content[j]=#10) or (Content[j]=#13) then
        begin
         TempStr:=TempStr+Content[j];
         inc(j); inc(SearchColumn); SearchRow:=1;
        end
       else
        begin
         TempStr:=TempStr+Content[j]; inc(SearchRow);
        end;
       if(CurrentClass=1) and (Copy(Content,j,2)='*/') then
        begin
         TempStr:=TempStr+'*/';
         inc(j,2); inc(SearchRow,2); break;
        end;
       if(CurrentClass=2) and (Copy(Content,j,2)='*)') then
        begin
         TempStr:=TempStr+'*)';
         inc(j,2); inc(SearchRow,2); break;
        end;
       inc(j);
      end;
     if(j>len) then
      begin
       unild_script_raise_error(LineList.OriginalLine[CurrentColumn-1],CurrentColumn,CurrentRow,3,
       'Annotation Sign '+Copy(Content,i,2)+' does not ended in the linker script file.');
      end;
     i:=j; CurrentClass:=0; continue;
    end
   else if(Content[i]='"') or (Content[i]=#39) then
    begin
     j:=i+1; TempStr:=TempStr+Content[i];
     inc(SearchRow);
     while(j<=len)do
      begin
       if(Copy(Content,j,2)=#10#13) or (Copy(Content,j,2)=#13#10) then
        begin
         TempStr:=TempStr+Copy(Content,j,2); inc(SearchColumn); SearchRow:=1;
        end
       else if(Content[j]=#13) or (Content[j]=#10) then
        begin
         TempStr:=TempStr+Content[j]; inc(SearchColumn); SearchRow:=1;
        end;
       if(j>=i+3) and (Content[j-2]='\') and (Content[j-1]='\') and (Content[j]='"') then
        begin
         TempStr:=TempStr+Content[j]; break;
        end
       else if(j>=i+1) and (Content[j]='"') then
        begin
         TempStr:=TempStr+Content[j]; break;
        end;
       inc(j);
      end;
     if(j>len) then
      begin
       unild_script_raise_error(LineList.OriginalLine[CurrentColumn-1],CurrentColumn,CurrentRow,3,
       'String Sign '+Content[i]+' does not ended in the linker script file.');
      end;
     i:=j; continue;
    end
   else if(i=len) and (TempStr<>'') then
    begin
     inc(LineList.LineCount);
     SetLength(LineList.Line,LineList.LineCount);
     SetLength(LineList.LineColumn,LineList.LineCount);
     LineList.Line[LineList.LineCount-1]:=unild_script_analyze(TempStr);
     LineList.LineColumn[LineList.LineCount-1]:=CurrentColumn;
    end
   else if(Copy(Content,i,2)=#13#10) or (Copy(Content,i,2)=#10#13) then
    begin
     if(TempStr<>'') then
      begin
       inc(LineList.LineCount);
       SetLength(LineList.Line,LineList.LineCount);
       SetLength(LineList.LineColumn,LineList.LineCount);
       LineList.Line[LineList.LineCount-1]:=unild_script_analyze(TempStr);
       LineList.LineColumn[LineList.LineCount-1]:=CurrentColumn;
      end;
     inc(i,2); TempStr:='';
     inc(SearchColumn); SearchRow:=1;
     CurrentColumn:=SearchColumn; CurrentRow:=SearchRow; continue;
    end
   else if(Content[i]=#13) or (Content[i]=#10) then
    begin
     if(TempStr<>'') then
      begin
       inc(LineList.LineCount);
       SetLength(LineList.Line,LineList.LineCount);
       SetLength(LineList.LineColumn,LineList.LineCount);
       LineList.Line[LineList.LineCount-1]:=unild_script_analyze(TempStr);
       LineList.LineColumn[LineList.LineCount-1]:=CurrentColumn;
      end;
     inc(i); TempStr:='';
     inc(SearchColumn); SearchRow:=1;
     CurrentColumn:=SearchColumn; CurrentRow:=SearchRow; continue;
    end
   else TempStr:=TempStr+Content[i];
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
     else if(LowerCase(LineList.Line[i-1].Item[0])='generatelinkersign')
     or(LowerCase(LineList.Line[i-1].Item[0])='genlinkersign') then
      begin
       Result.GenerateLinkerSign:=true;
       Result.LinkerSignContent:='unild version 0.0.4';
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'GOT(Global Offset Table) Alias must be gotalias/got_alias(alias).');
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Dynamic Section Alias must be dynamicalias/dynamic_alias(alias).');
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Shared Library Name(filename) '+
         'must be sharedlibraryname/shared_library_name/sharedlibrary_name(internal name).');
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'File Align must be filealign(alignvalue).');
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='genversion')
     or(LowerCase(LineList.Line[i-1].Item[0])='generateversion') then
      begin
       if(LineList.Line[i-1].Count=4) then
        begin
         Result.GenerateVersion:=true;
         Result.VersionContent:=LineList.Line[i-1].Item[2];
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Version Generate must be genversion/generateversion(versionvalue).');
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='gencustomsign')
     or(LowerCase(LineList.Line[i-1].Item[0])='generatecustomsign') then
      begin
       if(LineList.Line[i-1].Count=6) then
        begin
         Result.GenerateCustomSign:=true;
         Result.CustomSignSectionName:=LineList.Line[i-1].Item[2];
         Result.CustomSignContent:=LineList.Line[i-1].Item[4];
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Custom Sign Generate must be gencustomsign'+
         '/generatecustomsign(customsignsectionname,customsigncontent).');
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Binary align must be binaryalign(alignvalue).');
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='baseaddress')
     or(LowerCase(LineList.Line[i-1].Item[0])='base_address')
     or(LowerCase(LineList.Line[i-1].Item[0])='startaddress')
     or(LowerCase(LineList.Line[i-1].Item[0])='start_address') then
      begin
       if(LineList.Line[i-1].Count=4) and (unild_script_check_str_int(LineList.Line[i-1].Item[2])) then
        begin
         tempstr1:=LineList.Line[i-1].Item[2];
         Result.BaseAddress:=unild_script_str_to_int(tempstr1);
         Result.NoFixedAddress:=false;
        end
       else if(unild_script_check_str_int(LineList.Line[i-1].Item[2])=false) then
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[2],
         length(LineList.Line[i-1].Item[2]),
         'Input Base Address in Base Address Directive baseaddress/base_address/startaddress/start_address'+
         '(address) is not a vaild address,vaild address must be an unsigned value.');
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Base Address must be baseaddress/base_address/startaddress/start_address'+
         '(address),must have at least one parameter.');
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='entry')or(LowerCase(LineList.Line[i-1].Item[0])='entry_name')
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Entry Name must be entry/entry_name/entryname/entry_symbol/entrysymbol'+
         '(entryname).');
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
           if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr1[length(tempstr1)]='"')) or
           ((tempstr1[1]=#39) and (tempstr1[length(tempstr1)]=#39))) then
           tempstr1:=Copy(tempstr1,2,length(tempstr1)-2);
           Result.Interpreter:=tempstr1;
           if(FileExists(Result.Interpreter)) then break
           else Result.Interpreter:='';
           j:=k+1;
          end;
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Interpreter Name must be interpreter/interp(interpretername)');
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='interpreter_need_function') or
     (LowerCase(LineList.Line[i-1].Item[0])='interpreter_needfunction') or
     (LowerCase(LineList.Line[i-1].Item[0])='interpreterneedfunction') or
     (LowerCase(LineList.Line[i-1].Item[0])='interp_need_function') or
     (LowerCase(LineList.Line[i-1].Item[0])='interp_needfunction') or
     (LowerCase(LineList.Line[i-1].Item[0])='interpneedfunction') or
     (LowerCase(LineList.Line[i-1].Item[0])='interp_need_func') or
     (LowerCase(LineList.Line[i-1].Item[0])='interp_needfunc') or
     (LowerCase(LineList.Line[i-1].Item[0])='interpneedfunc')
     then
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
           Result.InterpreterDynamicLinkFunction:=tempstr1;
           j:=k+1;
          end;
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Interpreter Needed Function Name must be '+
         'interpreter_need_function/interpreter_needfunction/interpreterneedfunction'+
         'interp_need_function/interp_needfunction/interpneedfunction'+
         '(interpretername).');
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
           if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr1[length(tempstr1)]='"')) or
           ((tempstr1[1]=#39) and (tempstr1[length(tempstr1)]=#39))) then
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Dynamic Library Name must be dynamiclibrary/dynamic_library'
         +'/sharedlibrary/shared_library(Libraryname/LibraryPath)');
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
           if(length(tempstr1)>=2) and (((tempstr1[1]='"') and (tempstr1[length(tempstr1)]='"')) or
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Dynamic Library Path must be dynamiclibrarysearchpath/dynamic_library_search_path'+
         '/sharedlibrarysearchpath/shared_library_search_path(LibrarySearchPath)');
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Dynamic Library Path must be dynamiclibrary_search_withsubdir/dynamiclibrarysearch_withsubdir/'
         +'dynamiclibrary_search_withsubdir/sharedlibrary_search_withsubdir'
         +'/sharedlibrarysearch_withsubdir/sharedlibrary_search_withsubdir(LibrarySearchPath(withSubDirectory))');
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='bits')
     or(LowerCase(LineList.Line[i-1].Item[0])='filebits')
     or(LowerCase(LineList.Line[i-1].Item[0])='file_bits') then
      begin
       if(LineList.Line[i-1].Count>=4) and
       (unild_script_check_str_int(LineList.Line[i-1].Item[2])) then
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
       else if(unild_script_check_str_int(LineList.Line[i-1].Item[2])=false) then
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[2],
         length(LineList.Line[i-1].Item[2]),
         'File Bits input parameter must be a unsigned number not the other type of values.');
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[2],
         length(LineList.Line[i-1].Item[2]),
         'File Bits must be file_bits/bits/filebits(bitvalue) and not define at least twice.');
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
           unild_script_raise_error(
           LineList.OriginalLine[LineList.LineColumn[i-1]-1],
           LineList.LineColumn[i-1],LineList.Line[i-1].Offset[2],
           length(LineList.Line[i-1].Item[2]),
           'Unsupported Output Architecture '+tempstr1);
          end;
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Output Architecture must be '+
         'output_architecture/outputarchitecture/output_arch/outputarch(Architecture).');
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
           unild_script_raise_error(
           LineList.OriginalLine[LineList.LineColumn[i-1]-1],
           LineList.LineColumn[i-1],LineList.Line[i-1].Offset[2],
           length(LineList.Line[i-1].Item[2]),
           'Unsupported Input Architecture '+tempstr1);
          end;
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'input Architecture must be '+
         'input_architecture/inputarchitecture/input_arch/inputarch(Architecture).');
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Output FileName must be output_filename/outputfilename/output(filename).');
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Input FileName Directive Parameter must not be empty.');
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Correct Input FileName Format must be inputfile/input/inputfile().');
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Input File Path must not be empty.');
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Input FileName must be input_file_path/input_filepath/input_path/inputpath/'
         +'inputfilepath(paths to the file).');
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Input File Path With Sub Directory must not be empty.');
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Input FileName must be inputfilepath_withsub/inputpath_withsub/'+
         'input_path_withsub/input_file_path_withsub/input_filepath_withsub/'+
         'inputfilepathwithsub/inputpathwithsub/input_pathwithsub/input_file_pathwithsub'+
         'input_filepathwithsub(File Paths which contains object files).');
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='implicit_section_address')
     or(LowerCase(LineList.Line[i-1].Item[0])='implicitsection_address')
     or(LowerCase(LineList.Line[i-1].Item[0])='implicitsectionaddress') then
      begin
       j:=3;
       if(LineList.Line[i-1].Count>=6) then
        begin
         k:=j+1; tempstr:=''; tempstr1:=''; m:=3;
         while(j<=LineList.Line[i-1].Count)do
          begin
           tempstr:=''; k:=j+1; m:=j;
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=',') or (LineList.Line[i-1].Item[k-1]=')') then break;
             tempstr:=tempstr1+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           if(tempstr1='') then
            begin
             tempstr:=tempstr1;
             if(tempstr1='.strtab') or (tempstr1='.symtab') or (tempstr1='.shstrtab') then
              begin
               unild_script_raise_error(
               LineList.OriginalLine[LineList.LineColumn[i-1]-1],
               LineList.LineColumn[i-1],LineList.Line[i-1].Offset[j-1],
               length(LineList.Line[i-1].Item[j-1]),
               'Typed section '+tempstr1+' is specified section auto-generated by linker and'+
               'and it cannot to be changed and it is not an implicit section,'+
               'cannot change address with the Implicit Section Address Command.');
              end
             else if(tempstr1<>'.hash')and(tempstr1<>'.gnu.hash')and(tempstr1<>'.dynamic')
             and(tempstr1<>'.dynsym')and(tempstr1<>'.dynstr')and(tempstr1<>'.got')
             and(tempstr1<>'.got.plt')and(Copy(tempstr1,1,5)<>'.rela')and(Copy(tempstr1,1,5)<>'.relr')
             and(Copy(tempstr1,1,4)<>'.rel')and(tempstr1<>'.version')and(tempstr1<>'.unidata')then
              begin
               unild_script_raise_error(
               LineList.OriginalLine[LineList.LineColumn[i-1]-1],
               LineList.LineColumn[i-1],LineList.Line[i-1].Offset[j-1],
               length(LineList.Line[i-1].Item[j-1]),
               'Typed section '+tempstr1+' is not the implicit section,'+
               'cannot change its address with the Implicit Section Address Command.');
              end;
            end
           else
            begin
             tempvalue:=unild_str_to_int(tempstr);
             inc(Script.ImplicitCount);
             SetLength(Script.ImplicitName,Script.ImplicitCount);
             SetLength(Script.ImplicitAddress,Script.ImplicitCount);
             Script.ImplicitName[i-1]:=tempstr1;
             Script.ImplicitAddress[i-1]:=tempvalue;
             tempstr1:='';
            end;
           j:=k+1;
          end;
         if(tempstr1<>'') then
          begin
           unild_script_raise_error(
           LineList.OriginalLine[LineList.LineColumn[i-1]-1],
           LineList.LineColumn[i-1],LineList.Line[i-1].Offset[j-1],
           length(LineList.Line[i-1].Item[j-1]),
           'Typed section '+tempstr1+' address have not specified,must be specified '+
           'when the implicit section name specified.');
          end;
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Implicit Section Address(implicit_section_address/'
         +'implicitsection_address/implicitsectionaddress(SectionName,Section Address,'+
         '...(with Section Name and Section Address Pair)) have no enough parameters.');
        end;
      end
     else if(LowerCase(LineList.Line[i-1].Item[0])='implicit_section_maxsize')
     or(LowerCase(LineList.Line[i-1].Item[0])='implicitsection_maxsize')
     or(LowerCase(LineList.Line[i-1].Item[0])='implicitsectionmaxsize') then
      begin
       j:=3;
       if(LineList.Line[i-1].Count>=6) then
        begin
         k:=j+1; tempstr:=''; tempstr1:=''; m:=3;
         while(j<=LineList.Line[i-1].Count)do
          begin
           tempstr:=''; k:=j+1; m:=j;
           while(k<=LineList.Line[i-1].Count)do
            begin
             if(LineList.Line[i-1].Item[k-1]=',') or (LineList.Line[i-1].Item[k-1]=')') then break;
             tempstr:=tempstr1+LineList.Line[i-1].Item[k-1];
             inc(k);
            end;
           if(tempstr1='') then
            begin
             tempstr:=tempstr1;
             if(tempstr1='.strtab') or (tempstr1='.symtab') or (tempstr1='.shstrtab') then
              begin
               unild_script_raise_error(
               LineList.OriginalLine[LineList.LineColumn[i-1]-1],
               LineList.LineColumn[i-1],LineList.Line[i-1].Offset[j-1],
               length(LineList.Line[i-1].Item[j-1]),
               'Typed section '+tempstr1+' is specified section auto-generated by linker and'+
               'and it cannot to be changed and it is not an implicit section,'+
               'cannot change maximum with the Implicit Section Maximum Command.');
              end
             else if(tempstr1<>'.hash')and(tempstr1<>'.gnu.hash')and(tempstr1<>'.dynamic')
             and(tempstr1<>'.dynsym')and(tempstr1<>'.dynstr')and(tempstr1<>'.got')
             and(tempstr1<>'.got.plt')and(Copy(tempstr1,1,5)<>'.rela')and(Copy(tempstr1,1,5)<>'.relr')
             and(Copy(tempstr1,1,4)<>'.rel')and(tempstr1<>'.version')and(tempstr1<>'.unidata')then
              begin
               unild_script_raise_error(
               LineList.OriginalLine[LineList.LineColumn[i-1]-1],
               LineList.LineColumn[i-1],LineList.Line[i-1].Offset[j-1],
               length(LineList.Line[i-1].Item[j-1]),
               'Typed section '+tempstr1+' is not the implicit section,'+
               'cannot change its maximum size with the Implicit Section Maximum Size Command.');
              end;
            end
           else
            begin
             tempvalue:=unild_str_to_int(tempstr);
             inc(Script.ImplicitSizeCount);
             SetLength(Script.ImplicitSizeName,Script.ImplicitSizeCount);
             SetLength(Script.ImplicitSize,Script.ImplicitSizeCount);
             Script.ImplicitSizeName[i-1]:=tempstr1;
             Script.ImplicitSize[i-1]:=tempvalue;
             tempstr1:='';
            end;
           j:=k+1;
          end;
         if(tempstr1<>'') then
          begin
           unild_script_raise_error(
           LineList.OriginalLine[LineList.LineColumn[i-1]-1],
           LineList.LineColumn[i-1],LineList.Line[i-1].Offset[j-1],
           length(LineList.Line[i-1].Item[j-1]),
           'Typed section '+tempstr1+' maximum have not specified,must be specified '+
           'when the implicit section name specified.');
          end;
        end
       else
        begin
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
         length(LineList.Line[i-1].Item[0]),
         'Implicit Section Maximum Size(implicit_section_address/'
         +'implicitsection_address/implicitsectionaddress(SectionName,Section Address,'+
         '...(with Section Name and Section Address Pair)) have no enough parameters.');
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
            end
           else if((LowerCase(LineList.Line[i-1].Item[j-1])='maxsize') or
           (LowerCase(LineList.Line[i-1].Item[j-1])='sectionmaxsize')) and
           (LineList.Line[i-1].Item[j]='=') then
            begin
             tempstr1:=LineList.Line[i-1].Item[j+1];
             Result.Section[Result.SectionCount-1].SectionMaxSize:=unild_script_str_to_int(tempstr1);
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
           or(Copy(tempstr1,1,5)='.rela')or(Copy(tempstr1,1,4)='.rel') or (Copy(tempstr1,1,5)='.relr')
           or(tempstr1='.version') or (tempstr1='.unidata')) then
            begin
             unild_script_raise_error(
             LineList.OriginalLine[LineList.LineColumn[i-1]-1],
             LineList.LineColumn[i-1],LineList.Line[i-1].Offset[j-1],
             Length(LineList.Line[i-1].Item[j-1]),
             'Section Name '+tempstr1+' is a special section,cannot be specified in Linker Script.');
            end
           else if(Result.IsEFIFile) and (length(tempstr1)>8) then
            begin
             unild_script_raise_error(
             LineList.OriginalLine[LineList.LineColumn[i-1]-1],
             LineList.LineColumn[i-1],LineList.Line[i-1].Offset[j-1],
             Length(LineList.Line[i-1].Item[j-1]),
             'Section Name '+tempstr1+' length exceeds 8,cannot generate this section in the EFI File.');
            end
           else if(Result.Section[Result.SectionCount-1].SectionName='') then
           Result.Section[Result.SectionCount-1].SectionName:=tempstr1
           else if(LowerCase(tempstr1)='keepwhenempty') or (LowerCase(tempstr1)='maintainwhenempty')
           then
            begin
             Result.Section[Result.SectionCount-1].SectionKeepWhenEmpty:=true;
            end
           else if(LowerCase(tempstr1)='musthavecontent') or (LowerCase(tempstr1)='neededcontent')
           or (LowerCase(tempstr1)='checkcontent') then
            begin
             Result.Section[Result.SectionCount-1].SectionMustHaveContent:=true;
            end
           else if(LowerCase(tempstr1)='absaddress') or (LowerCase(tempstr1)='absoluteaddress')
           or(LowerCase(tempstr1)='absaddr') then
            begin
             Result.Section[Result.SectionCount-1].SectionAbsoluteAddress:=true;
             Result.NoFixedAddress:=false;
            end
           else if(LowerCase(tempstr1)='keeporgalign') or (LowerCase(tempstr1)='maintainorgalign')
           or(LowerCase(tempstr1)='keeporiginalalign') or (LowerCase(tempstr1)='maintainoriginalalign')
           then
            begin
             Result.Section[Result.SectionCount-1].SectionMaintainOriginalAlign:=true;
            end
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
         unild_script_raise_error(
         LineList.OriginalLine[LineList.LineColumn[i-1]-1],
         LineList.LineColumn[i-1],LineList.Line[i-1].Offset[j-1],
         Length(LineList.Line[i-1].Item[j-1]),
         'Section with its index '+IntToStr(Result.SectionCount)+' Name not found in the linker script.');
        end;
       BracketStack.BracketCount:=0; j:=i+1; a:=1; b:=0;
       while(j<=LineList.LineCount) do
        begin
         if(LineList.Line[j-1].Count=1) and
         ((LineList.Line[j-1].Item[0]='{') or (LowerCase(LineList.Line[j-1].Item[0])='begin')) then
          begin
           inc(BracketStack.BracketCount);
           SetLength(BracketStack.BracketLeft,BracketStack.BracketCount);
           SetLength(BracketStack.BracketRight,BracketStack.BracketCount);
           BracketStack.BracketLeft[BracketStack.BracketCount-1]:=j;
           BracketStack.BracketRight[BracketStack.BracketCount-1]:=0;
          end
         else if(LineList.Line[j-1].Count=1) and
         ((LineList.Line[j-1].Item[0]='}') or (LowerCase(LineList.Line[j-1].Item[0])='end;')
         or(LowerCase(LineList.Line[j-1].Item[0])='end')or(LowerCase(LineList.Line[j-1].Item[0])='end.')) then
          begin
           a:=BracketStack.BracketCount;
           while(a>0)do
            begin
             if(BracketStack.BracketRight[a-1]=0) then
              begin
               BracketStack.BracketRight[a-1]:=j; inc(b); break;
              end;
             dec(a);
            end;
           if(a=0) then
            begin
             unild_script_raise_error(
             LineList.OriginalLine[LineList.LineColumn[j-1]-1],
             LineList.LineColumn[j-1],LineList.Line[j-1].Offset[0],
             Length(LineList.Line[j-1].Item[0]),
             'End of Section Definition block have not any corresponding Start of Definition block.');
            end
           else if(a=1) then break;
          end
         else if(b<BracketStack.BracketCount) and (LineList.Line[j-1].Count>=4) then
          begin
           tempstr1:=unild_script_translate_string(LineList.Line[j-1].Item[0],true);
           inc(Result.Section[Result.SectionCount-1].SectionItemCount);
           SetLength(Result.Section[Result.SectionCount-1].SectionItem,
           Result.Section[Result.SectionCount-1].SectionItemCount);
           Result.Section[Result.SectionCount-1].SectionItem[
           Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemCount:=0;
           if(LowerCase(tempstr1)='offset') or (LowerCase(tempstr1)='absoluteoffset')
           or(LowerCase(tempstr1)='absoffset') or(LowerCase(tempstr1)='absoff') then
            begin
             if(LineList.Line[j-1].Count<>4) then
              begin
               unild_script_raise_error(
               LineList.OriginalLine[LineList.LineColumn[j-1]-1],
               LineList.LineColumn[j-1],LineList.Line[j-1].Offset[0],
               Length(LineList.Line[j-1].Item[0]),
               'Section Offset (Offset/absoluteOffset/absoffset/absoff(Value)) should be only one parameter.');
              end;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemClass:=unild_item_offset;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemOffset:=
             unild_script_str_to_int(LineList.Line[j-1].Item[2]);
            end
           else if(LowerCase(tempstr1)='reloffset') or (LowerCase(tempstr1)='relativeoffset')
           or (LowerCase(tempstr1)='reloff') then
            begin
             if(LineList.Line[j-1].Count<>4) then
              begin
               unild_script_raise_error(
               LineList.OriginalLine[LineList.LineColumn[j-1]-1],
               LineList.LineColumn[j-1],LineList.Line[j-1].Offset[0],
               Length(LineList.Line[j-1].Item[0]),
               'Section Relative Offset (RelOffset/RelativeOffset/RelOff(Value)) should be only one parameter.');
              end;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemClass:=
             unild_item_relativeoffset;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemRelativeOffset:=
             unild_script_str_to_int(LineList.Line[j-1].Item[2]);
            end
           else if(LowerCase(tempstr1)='alignassection') or (LowerCase(tempstr1)='sectionalign')
           or (LowerCase(tempstr1)='alignofsection') then
            begin
             if(LineList.Line[j-1].Count<>4) then
              begin
               unild_script_raise_error(
               LineList.OriginalLine[LineList.LineColumn[j-1]-1],
               LineList.LineColumn[j-1],LineList.Line[j-1].Offset[0],
               Length(LineList.Line[j-1].Item[0]),
               'Align As Section Align(alignassection/sectionalign/alignofsection(Value))'+
               ' should be only one parameter.');
              end;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemClass:=unild_item_align;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemRelativeOffset:=
             Result.Section[Result.SectionCount-1].SectionAlign;
            end
           else if(LowerCase(tempstr1)='align') or (LowerCase(tempstr1)='internalalign')
           or (LowerCase(tempstr1)='inneralign') then
            begin
             if(LineList.Line[j-1].Count<>4) then
              begin
               unild_script_raise_error(
               LineList.OriginalLine[LineList.LineColumn[j-1]-1],
               LineList.LineColumn[j-1],LineList.Line[j-1].Offset[0],
               Length(LineList.Line[j-1].Item[0]),
               'Section Internal Align (align/internalalign/inneralign(Value)) should be only one parameter.');
              end;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemClass:=unild_item_align;
             Result.Section[Result.SectionCount-1].SectionItem[
             Result.Section[Result.SectionCount-1].SectionItemCount-1].ItemAlign:=
             unild_script_str_to_int(LineList.Line[j-1].Item[2]);
            end
           else if(tempstr1='*') or (LowerCase(tempstr1)='keep') or (LowerCase(tempstr1)='maintain')
           or (LowerCase(tempstr1)='preserve') or (LowerCase(tempstr1)='useful')
           or (LowerCase(tempstr1)='smart') or (LowerCase(tempstr1)='intelligent') then
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
             else if(LowerCase(tempstr1)='smart') or (LowerCase(tempstr1)='useful')
             or (LowerCase(tempstr1)='intelligent') then
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
             unild_script_raise_error(
             LineList.OriginalLine[LineList.LineColumn[j-1]-1],
             LineList.LineColumn[j-1],LineList.Line[j-1].Offset[0],
             Length(LineList.Line[j-1].Item[0]),
             'Section Item '+LineList.Line[j-1].Item[0]+' Directive invaild.');
            end;
          end
         else if(b<BracketStack.BracketCount) and (j=LineList.LineCount) then
          begin
           unild_script_raise_error(
           LineList.OriginalLine[BracketStack.BracketLeft[a-1]-1],
           LineList.LineColumn[BracketStack.BracketLeft[a-1]-1],
           LineList.Line[BracketStack.BracketLeft[a-1]-1].Offset[0],
           Length(LineList.Line[BracketStack.BracketLeft[a-1]-1].Item[0]),
           'Bracket in this position not closed.');
          end;
         inc(j);
        end;
       i:=j;
      end
     else
      begin
       unild_script_raise_error(
       LineList.OriginalLine[LineList.LineColumn[i-1]-1],
       LineList.LineColumn[i-1],LineList.Line[i-1].Offset[0],
       length(LineList.Line[i-1].Item[0]),
       'Directive '+LineList.Line[i-1].Item[0]+' unrecognized.');
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
end;
function unild_generate_default_elf_file:unild_script;
var i:SizeUint;
begin
 if(ScriptEnable) then Result:=Script;
 if(Script.DebugSwitch) then Result.SectionCount:=19 else Result.SectionCount:=13;
 if(Script.VersionSwitch) then inc(Result.SectionCount,3);
 SetLength(Result.Section,Result.SectionCount);
 i:=1;
 if(Result.EntryName='') and (not ((Result.elfclass<=1) and (Result.IsEFIFile=false)
 and (Result.IsUntypedBinary=false))) then Result.EntryName:='_start'
 else if(Result.EntryName<>'') then Result.EntryName:='';
 if((Result.elfclass<=1) and (Result.IsEFIFile=false) and (Result.IsUntypedBinary=false)) then
 Result.SmartLinking:=false;
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
