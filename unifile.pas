unit unifile;

{$mode ObjFPC}{$H+}

interface

uses Classes,SysUtils,binbase,unildscript,unihash;

type unifile_elf_object_file_symbol_table=packed record
                                          SymbolName:array of string;
                                          SymbolBinding:array of byte;
                                          SymbolType:array of byte;
                                          SymbolVisibility:array of byte;
                                          SymbolSectionIndex:array of word;
                                          SymbolSize:array of SizeUint;
                                          SymbolValue:array of SizeUint;
                                          SymbolCount:SizeUint;
                                          end;
     unifile_elf_object_file=packed record
                             FilePointer:Pointer;
                             Architecture:word;
                             Bits:Byte;
                             FileFlag:Dword;
                             SectionCount:word;
                             SectionName:array of string;
                             SectionType:array of dword;
                             SectionFlag:array of SizeUint;
                             SectionContent:array of Pointer;
                             SectionSize:array of SizeUint;
                             SectionLink:array of word;
                             SectionInfo:array of word;
                             SectionAlign:array of SizeUint;
                             {For Object File's symbol Table}
                             SymbolTable:unifile_elf_object_file_symbol_table;
                             RelocationCount:SizeUInt;
                             end;
     unifile_elf_archive_file=packed record
                              MainPointer:Pointer;
                              Objects:array of unifile_elf_object_file;
                              ObjectCount:SizeUint;
                              end;
     unifile_elf_object_file_total=packed record
                                   Objects:array of unifile_elf_object_file;
                                   ObjectCount:SizeUint;
                                   ObjectPointer:array of Pointer;
                                   ObjectPointerCount:SizeUint;
                                   ObjectSectionCount:SizeUint;
                                   ObjectRelocationCount:SizeUint;
                                   ObjectSymbolCount:SizeUint;
                                   end;
     unifile_elf_interpreter_hash_table=packed record
                                        BucketCount:Dword;
                                        BucketItem:array of Dword;
                                        BucketHash:array of Dword;
                                        ChainCount:Dword;
                                        ChainItem:array of Dword;
                                        ChainHash:array of Dword;
                                        end;
     unifile_elf_interpreter=packed record
                             InterpreterSymbolHash:array of Dword;
                             InterpreterHashTable:unifile_elf_interpreter_hash_table;
                             DynamicLibraryResolveOffset:SizeUint;
                             end;
     unifile_elf_dynamic_library=packed record
                                 SharedObjectName:string;
                                 SymbolName:array of string;
                                 SymbolNameHash:array of SizeUint;
                                 SymbolCount:SizeUint;
                                 end;
     unifile_elf_dynamic_library_total=packed record
                                       SharedObjectName:array of string;
                                       SharedObjectCount:SizeUint;
                                       HashTableEnable:boolean;
                                       BucketCount:SizeUint;
                                       BucketEnable:array of boolean;
                                       BucketItem:array of SizeUint;
                                       ChainCount:SizeUint;
                                       ChainEnable:array of boolean;
                                       ChainItem:array of SizeUint;
                                       SymbolFileIndex:array of SizeUint;
                                       SymbolName:array of string;
                                       SymbolNameHash:array of SizeUint;
                                       SymbolCount:SizeUint;
                                       end;
     unifile_elf_object_file_parsed_relocation=packed record
                                               RelocationSection:string;
                                               RelocationSectionHash:SizeUint;
                                               RelocationSymbol:array of string;
                                               RelocationSymbolHash:array of SizeUint;
                                               RelocationOffset:array of SizeUint;
                                               RelocationType:array of SizeUint;
                                               RelocationClass:array of boolean;
                                               RelocationAddend:array of SizeInt;
                                               RelocationCount:SizeUint;
                                               end;
     unifile_elf_object_file_parsed_symbol_table=packed record
                                                 SymbolName:array of string;
                                                 SymbolNameHash:array of SizeUint;
                                                 SymbolBinding:array of byte;
                                                 SymbolType:array of byte;
                                                 SymbolVisibility:array of byte;
                                                 SymbolSectionName:array of string;
                                                 SymbolSectionNameHash:array of SizeUint;
                                                 SymbolSize:array of SizeUint;
                                                 SymbolValue:array of SizeUint;
                                                 SymbolCount:SizeUint;
                                                 end;
     unifile_elf_object_file_parsed=packed record
                                    Architecture:word;
                                    Bits:byte;
                                    FileFlag:dword;
                                    {For Basic Attributes}
                                    SectionCount:SizeUint;
                                    SectionType:array of SizeUint;
                                    SectionFlag:array of SizeUint;
                                    SectionUsed:array of boolean;
                                    SectionAlign:array of dword;
                                    SectionName:array of string;
                                    SectionNameHash:array of SizeUint;
                                    SectionContent:array of Pointer;
                                    SectionSize:array of SizeUint;
                                    {For Relocation Attributes}
                                    SectionRelocationCount:SizeUint;
                                    SectionRelocation:array of unifile_elf_object_file_parsed_relocation;
                                    {For Symbol Table Attributes}
                                    SectionSymbolTable:unifile_elf_object_file_parsed_symbol_table;
                                    end;
     unifile_temporary_relocation_list=packed record
                                       RelocationCount:SizeUint;
                                       Relocation:array of unifile_elf_object_file_parsed_relocation;
                                       end;
     unifile_temporary_vaild_list=packed record
                                  Enable:array of boolean;
                                  ItemCount:SizeUint;
                                  end;
     unifile_temporary_hash_table=packed record
                                  BucketCount:SizeUint;
                                  BucketItem:array of SizeUint;
                                  BucketHash:array of SizeUint;
                                  BucketEnable:array of boolean;
                                  ChainCount:SizeUint;
                                  ChainItem:array of SizeUint;
                                  ChainHash:array of SizeUint;
                                  ChainEnable:array of boolean;
                                  end;
     unifile_temporary_adjust_table=packed record
                                    OriginalSectionIndex:array of Word;
                                    OriginalOffset:array of SizeInt;
                                    GoalSectionIndex:array of Word;
                                    GoalOffset:array of SizeInt;
                                    AdjustName:array of string;
                                    AdjustHash:array of SizeUint;
                                    AdjustAddend:array of SizeInt;
                                    AdjustFunc:array of boolean;
                                    AdjustType:array of SizeUInt;
                                    AdjustSize:array of SizeUint;
                                    AdjustRiscVType:array of byte;
                                    Count:SizeInt;
                                    end;
     unifile_linked_file_content_info=packed record
                                      ContentStartIndex:SizeUInt;
                                      ContentCount:SizeUint;
                                      ContentSize:SizeUint;
                                      end;
     unifile_linked_file_content=packed record
                                 Index:SizeUint;
                                 Offset:SizeUint;
                                 Name:string;
                                 NameHash:SizeUInt;
                                 Memory:Pointer;
                                 Size:SizeUint;
                                 end;
     unifile_linked_file_symbol_table=packed record
                                      SymbolSectionName:array of string;
                                      SymbolSectionNameHash:array of SizeUint;
                                      SymbolName:array of string;
                                      SymbolNameHash:array of SizeUint;
                                      SymbolBinding:array of byte;
                                      SymbolType:array of byte;
                                      SymbolVisibility:array of byte;
                                      SymbolSize:array of SizeUint;
                                      SymbolValue:array of SizeUint;
                                      SymbolCount:SizeUint;
                                      end;
     unifile_linked_file_stage=packed record
                               Architecture:word;
                               Bits:byte;
                               FileFlag:dword;
                               {For Sections}
                               SectionCount:SizeUint;
                               SectionName:array of string;
                               SectionNameHash:array of SizeUint;
                               SectionAttribute:array of byte;
                               SectionContentInfo:array of unifile_linked_file_content_info;
                               SectionContent:array of unifile_linked_file_content;
                               SectionContentAssist:unifile_temporary_hash_table;
                               SectionVaild:array of boolean;
                               SectionAlign:array of SizeUint;
                               SectionAddress:array of SizeUint;
                               {For Adjust Table}
                               AdjustTable:unifile_temporary_adjust_table;
                               AdjustVaildReflect:array of SizeUint;
                               AdjustVaildIndex:array of SizeUint;
                               AdjustVaildCount:SizeUint;
                               {For Symbol Table}
                               SymbolTable:unifile_linked_file_symbol_table;
                               SymbolTableAssist:unifile_temporary_hash_table;
                               {For Entry Name}
                               EntryName:String;
                               EntryHash:SizeUint;
                               EntrySection:string;
                               EntrySectionHash:SizeUint;
                               EntryOffset:SizeUint;
                               EntrySectionIndex:word;
                               {For Addition Items}
                               SymbolCount:SizeUint;
                               DynamicSymbolCount:SizeUint;
                               {For Files}
                               FileName:array of string;
                               FileNameCount:SizeUint;
                               {For External Needs}
                               ExternalNeeded:boolean;
                               end;
     unifile_file_symbol_table=packed record
                               SymbolSectionIndex:array of word;
                               SymbolName:array of string;
                               SymbolNameHash:array of SizeUint;
                               SymbolBinding:array of byte;
                               SymbolType:array of byte;
                               SymbolVisibility:array of byte;
                               SymbolSize:array of SizeUint;
                               SymbolValue:array of SizeUint;
                               SymbolCount:SizeUint;
                               end;
     unifile_file_list=packed record
                       GotCountOriginal:SizeUint;
                       GotHashList:array of SizeUint;
                       GotHashOriginal:unifile_temporary_hash_table;
                       GotEnable:array of boolean;
                       GotCount:SizeUInt;
                       GotHash:array of SizeUint;
                       GotHashTable:unifile_temporary_hash_table;
                       GotHashEnable:array of boolean;
                       end;
     unifile_check_result=packed record
                          GotBool:boolean;
                          NeedRelocationBits:byte;
                          end;
     unifile_check_needed_list=packed record
                               NeedAddress:array of SizeUint;
                               NeedBits:array of byte;
                               NeedCount:SizeUint;
                               end;
     unifile_result=packed record
                    GotType:byte;
                    AdjustValue:SizeInt;
                    SpecialBool:boolean;
                    RiscvType:byte;
                    Bits:byte;
                    ConvertToRelocationBits:byte;
                    end;
     unifile_file_hash_table=packed record
                             BucketCount:dword;
                             ChainCount:dword;
                             BucketItem:array of dword;
                             ChainItem:array of dword;
                             end;
     unifile_file_dynamic_item=packed record
                               DynamicSection:string;
                               DynamicString:string;
                               DynamicValue:SizeUint;
                               end;
     unifile_file_dynamic_list=packed record
                               DynamicItem:array of unifile_file_dynamic_item;
                               DynamicType:array of Integer;
                               DynamicSubType:array of byte;
                               DynamicCount:SizeUint;
                               end;
     unifile_file_coff_relocation_item=bitpacked record
                                       Offset:0..4095;
                                       ItemType:0..15;
                                       end;
     unifile_file_coff_relocation_list=packed record
                                       VirtualAddress:dword;
                                       SizeOfBlock:dword;
                                       Item:array of unifile_file_coff_relocation_item;
                                       ItemCount:dword;
                                       end;
     unifile_index_list=array of SizeUint;
     unifile_file_final=packed record
                        {For Bits and Architecture,Flags(ELF Only)}
                        Architecture:word;
                        Bits:byte;
                        FileFlag:dword;
                        {For FileStartAddress}
                        FileStartAddress:SizeUint;
                        FileProgramCount:Word;
                        {For File Size}
                        FinalFileSize:SizeUint;
                        FinalSectionOffset:SizeUint;
                        {For Sections}
                        SectionNameIndex:array of Dword;
                        SectionName:array of string;
                        SectionAttribute:array of byte;
                        SectionContent:array of Pointer;
                        SectionSize:array of SizeUint;
                        SectionAlign:array of SizeUInt;
                        SectionOffset:array of SizeUint;
                        SectionAddress:array of SizeUint;
                        SectionCount:SizeUInt;
                        {For Entry Address}
                        EntryAddress:SizeUint;
                        {For Symbol Table}
                        SymbolTable:unifile_file_symbol_table;
                        SymbolTableAssist:unifile_temporary_hash_table;
                        SymbolTableNewIndex:unifile_index_list;
                        SymbolTableLocalCount:SizeUint;
                        {For Dynamic Symbol Table}
                        DynamicSymbolTable:unifile_file_symbol_table;
                        DynamicSymbolTableAssist:unifile_temporary_hash_table;
                        DynamicSymbolTableNewIndex:unifile_index_list;
                        {For File List}
                        GotTableList:unifile_file_list;
                        {For Section Fast Index}
                        InterpreterIndex:word;
                        DynamicIndex:word;
                        DynamicStringTableIndex:word;
                        DynamicSymbolIndex:word;
                        RelocationDynamicTableIndex:word;
                        GotIndex:word;
                        SymbolTableIndex:word;
                        SymbolStringTableIndex:word;
                        StringTableIndex:word;
                        HashTableIndex:word;
                        RelocationIndex:word;
                        {For Dynamic Entry}
                        DynamicList:unifile_file_dynamic_list;
                        {For PE File Align(PE Only)}
                        FileAlign:Dword;
                        {For PE Symbol Table(PE Only)}
                        CoffSymbolTableContent:Pcoff_symbol_table_item;
                        CoffSymbolTableSize:SizeUint;
                        CoffStringTableContent:PChar;
                        CoffStringTableSize:SizeUint;
                        {For PE Information(PE Only)}
                        SizeofCode:SizeUint;
                        SizeofInitializedData:SizeUint;
                        SizeofUninitializedData:SizeUint;
                        BaseOfCode:SizeUint;
                        BaseOfData:SizeUint;
                        {For PE Relocation Table(PE Only)}
                        CoffList:array of unifile_file_coff_relocation_list;
                        CoffListCount:dword;
                        CoffListSpecialize:boolean;
                        {For Executable Base Address}
                        BaseAddress:SizeUint;
                        end;
     unifile_file_list_settings=packed record
                                FileName:array of string;
                                FileCount:SizeUint;
                                end;
     unifile_file_remember=packed record
                           TypeItem:array of word;
                           TypeItemCount:array of SizeUint;
                           TypeCount:SizeUint;
                           end;

var unifile_fileList:unifile_file_list_settings;


      {For Bits Constant}
const unifile_bit_32=32;
      unifile_bit_64=64;
      unifile_bit_128=128;
      {For Universal File Attributes}
      unifile_attribute_alloc:byte=$01;
      unifile_attribute_write:byte=$02;
      unifile_attribute_execute:byte=$04;
      unifile_attribute_not_in_file:byte=$08;
      unifile_attribute_information:byte=$10;
      unifile_attribute_thread_local_storage:byte=$20;
      unifile_attribute_note:byte=$40;
      {For Universal File Class}
      unifile_class_elf_file:byte=$00;
      unifile_class_pe_file:byte=$01;
      unifile_class_binary_file:byte=$02;
      {For Universal Got Class}
      unifile_got_class_none=0;
      unifile_got_class_got=1;
      unifile_got_class_got_plt=2;
      {For Universal Dynamic Entry Class}
      unifile_dynamic_class_section=0;
      unifile_dynamic_class_value=1;
      {For Universal Risc-V File Relocations}
      unifile_riscv_got=1;

procedure unifile_filelist_initialize;
function unifile_lsb_to_msb(lsbdata:word):word;
function unifile_lsb_to_msb(lsbdata:dword):dword;
function unifile_lsb_to_msb(lsbdata:qword):qword;
function unifile_msb_to_lsb(msbdata:word):word;
function unifile_msb_to_lsb(msbdata:dword):dword;
function unifile_msb_to_lsb(msbdata:qword):qword;
function unifile_generate_index(Index1:SizeUint;Index2:SizeUInt;Index2Needed:boolean=false):string;
function unifile_align(base,align:SizeUint):SizeUint;
function unifile_read_elf_file(fn:string):unifile_elf_object_file;
function unifile_read_archive_file(fn:string):unifile_elf_archive_file;
procedure unifile_total_file_initialize(var totalfile:unifile_elf_object_file_total);
procedure unifile_total_add_file(var totalfile:unifile_elf_object_file_total;
objectfile:unifile_elf_object_file);
procedure unifile_total_add_archive_file(var totalfile:unifile_elf_object_file_total;
archivefile:unifile_elf_archive_file);
procedure unifile_total_free(var totalfile:unifile_elf_object_file_total);
function unifile_total_check_bits(totalfile:unifile_elf_object_file_total;Bits:byte):boolean;
function unifile_total_check(totalfile:unifile_elf_object_file_total;Architecture:byte;Bits:byte):boolean;
function unifile_parse(var totalfile:unifile_elf_object_file_total):unifile_elf_object_file_parsed;
function unifile_parsed_to_first_stage(var basefile:unifile_elf_object_file_parsed;
var basescript:unild_script;SmartLinking:boolean):unifile_linked_file_stage;
procedure unifile_convert_file_to_final(var basefile:unifile_linked_file_stage;
var basescript:unild_script;filename:string;fileclass:byte);

implementation

procedure unifile_filelist_initialize;
begin
 unifile_filelist.FileCount:=0;
end;
function unifile_hash_table_bucket_count(SearchCount:SizeUint):SizeUInt;
begin
 Result:=SearchCount*9 div 5;
end;
function unifile_lsb_to_msb(lsbdata:word):word;
begin
 Result:=lsbdata shl 8+lsbdata shr 8;
end;
function unifile_lsb_to_msb(lsbdata:dword):dword;
begin
 Result:=lsbdata shr 24+lsbdata shr 8 and $0000FF00+lsbdata shl 8 and $00FF0000+lsbdata shl 24;
end;
function unifile_lsb_to_msb(lsbdata:qword):qword;
begin
 Result:=lsbdata shr 56+lsbdata shr 40 and $000000000000FF00+lsbdata shr 24 and $0000000000FF0000+
 lsbdata shr 8 and $00000000FF000000+
 lsbdata shl 8 and $000000FF00000000+
 lsbdata shl 24 and $0000FF0000000000+
 lsbdata shl 40 and $00FF000000000000+
 lsbdata shl 56;
end;
function unifile_msb_to_lsb(msbdata:word):word;
begin
 Result:=msbdata shl 8+msbdata shr 8;
end;
function unifile_msb_to_lsb(msbdata:dword):dword;
begin
 Result:=msbdata shr 24+msbdata shr 8 and $00FF0000+msbdata shl 8 and $0000FF00+msbdata shl 24;
end;
function unifile_msb_to_lsb(msbdata:qword):qword;
begin
 Result:=msbdata shr 56+msbdata shr 40 and $000000000000FF00+msbdata shr 24 and $0000000000FF0000+
 msbdata shr 8 and $00000000FF000000+
 msbdata shl 8 and $000000FF00000000+
 msbdata shl 24 and $0000FF0000000000+
 msbdata shl 40 and $00FF000000000000+
 msbdata shl 56;
end;
function unifile_string_to_integer(str:string):SizeInt;
var i,len:byte;
begin
 len:=length(str); Result:=0;
 for i:=1 to len do
  begin
   Result:=Result*10+Byte(str[i])-Byte('0');
  end;
end;
function unifile_generate_index(Index1:SizeUint;Index2:SizeUInt;Index2Needed:boolean=false):string;
const maincode:PChar='YABJk5gP%$db"zo*4nw`T<x)';
      subcode:PChar=';ZqRL{9h@0Ci~#?XVf2,Dj=(&_mH:lsWEv!-+t86F1K}[MuN';
var tempnum1,tempnum2:SizeUint;
begin
 tempnum1:=Index1; Result:='.';
 if(tempnum1>0) then
  begin
   while(tempnum1>0)do
    begin
     Result:=Result+(maincode+tempnum1 mod 24)^;
     tempnum1:=tempnum1 div 24;
    end;
  end
 else Result:=Result+maincode^;
 if(Index2Needed) then
  begin
   tempnum2:=Index2;
   if(tempnum2=0) then Result:=Result+subcode^;
   while(tempnum2>0)do
    begin
     Result:=Result+(subcode+tempnum2 mod 48)^;
     tempnum2:=tempnum2 div 48;
    end;
  end;
end;
function unifile_align_relocation(base,align:SizeUint):SizeUint;
begin
 Result:=base div align*align;
end;
function unifile_align(base,align:SizeUint):SizeUint;
begin
 Result:=(base+align-1) div align*align;
end;
function unifile_elf_hash(str:string):dword;
var i,hash,x:Dword;
begin
 hash:=0; x:=0; i:=1;
 while(i<=length(str))do
  begin
   hash:=hash shl 4+Byte(str[i]);
   x:=hash and $F0000000;
   if(x<>0) then
    begin
     hash:=hash xor (x shr 24);
     hash:=hash and (not x);
    end;
   inc(i);
  end;
 Result:=hash and $7FFFFFFF;
end;
function unifile_search_for_interpreter_hash_table(HashTable:unifile_elf_interpreter_hash_table;
GoalHash:Dword):Dword;
var Index:Dword;
begin
 Index:=GoalHash mod HashTable.BucketCount; Result:=0;
 if(HashTable.BucketHash[Index]=GoalHash) then exit(Index);
 if(Index<>0) then
  begin
   Index:=HashTable.BucketItem[Index];
   while(HashTable.ChainItem[Index]<>0)do
    begin
     if(HashTable.ChainHash[Index]=GoalHash) then exit(Index);
     Index:=HashTable.ChainItem[Index];
    end;
  end;
end;
procedure unifile_dynamic_library_total_initialize(var TotalLibrary:unifile_elf_dynamic_library_total);
begin
 TotalLibrary.HashTableEnable:=false;
 TotalLibrary.SharedObjectCount:=0;
 TotalLibrary.SymbolCount:=0;
end;
function unifile_read_elf_dynamic_library(DynamicLibraryPath:string;
CheckArchitecture:word;CheckBits:byte):unifile_elf_dynamic_library;
var fs:TFileStream;
    SharedContent:Pointer;
    i,j:SizeUint;
    {For Acquire the Dynamic Symbol}
    SearchOffset:Pointer;
    SearchCount:SizeUint;
    DynamicPointer:Pointer;
    DynamicCount:SizeUint;
    HashPointer:Pointer;
    DynamicSymbolTablePointer:Pointer;
    DynamicStringTablePointer:Pointer;
    DynamicSymbolTableCount:SizeUint;
    DynamicSharedObjectNameIndex:SizeUint;
    {For Temporary Variables of Acquiring}
    TempNum1,TempNum2:SizeUint;
begin
 {Read the Shared Object File}
 fs:=TFileStream.Create(DynamicLibraryPath,fmOpenRead);
 SharedContent:=allocmem(fs.Size);
 fs.Read(SharedContent^,fs.Size);
 fs.Free;
 {Set the Shared Object Name to None as initial.}
 Result.SharedObjectName:='';
 {Then Check the Shared Object File}
 if(elf_check_signature(Pelf32_header(SharedContent)^.elf_id)=false) then
  begin
   FreeMem(SharedContent);
   writeln('ERROR:'+DynamicLibraryPath+' is not a vaild ELF Format Dynamic Library.');
   readln;
   halt;
  end;
 if(CheckBits=32) and
 (Pelf32_header(SharedContent)^.elf_id[elf_class_position]<>elf_class_32) then
  begin
   FreeMem(SharedContent);
   writeln('ERROR:'+DynamicLibraryPath+' is not a vaild ELF 32-bit Dynamic Library.');
   readln;
   halt;
  end
 else if(CheckBits=64) and
 (Pelf64_header(SharedContent)^.elf_id[elf_class_position]<>elf_class_64) then
  begin
   FreeMem(SharedContent);
   writeln('ERROR:'+DynamicLibraryPath+' is not a vaild ELF 64-bit Dynamic Library.');
   readln;
   halt;
  end;
 if(CheckBits=32) then
  begin
   {Check the ELF File Type is the Shared Object}
   if(Pelf32_header(SharedContent)^.elf_type<>elf_type_dynamic) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:File '+DynamicLibraryPath+' is not the Shared Object File.');
     readln;
     halt;
    end;
   {Check the Architecture of the Dynamic Library}
   if(Pelf32_header(SharedContent)^.elf_machine<>CheckArchitecture) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:'+DynamicLibraryPath+' is not a vaild ELF Dynamic Library with corresponding architecture.');
     readln;
     halt;
    end;
   {Get the Program Header Offset and its Count}
   SearchOffset:=SharedContent+Pelf32_header(SharedContent)^.elf_program_header_offset;
   SearchCount:=Pelf32_header(SharedContent)^.elf_program_header_number;
   i:=1;
   while(i<=SearchCount)do
    begin
     if(Pelf32_program_header(SearchOffset+(i-1)*sizeof(Pelf32_program_header))^.program_type=
     elf_program_header_type_dynamic) then
      begin
       DynamicPointer:=
       SharedContent+Pelf32_program_header(SearchOffset+(i-1)*
       sizeof(Pelf32_program_header))^.program_offset;
       DynamicCount:=Pelf32_program_header(SearchOffset+(i-1)*
       sizeof(Pelf32_program_header))^.program_file_size div sizeof(elf32_dynamic_entry);
       break;
      end;
     inc(i);
    end;
   if(i>SearchCount) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:Cannot find dynamic section in Dynamic Library '+DynamicLibraryPath+
     '.Dynamic Library is not vaild.');
     readln;
     halt;
    end;
   {Then find the .hash,.dynsym and .dynstr section.}
   i:=1;
   HashPointer:=nil; DynamicStringTablePointer:=nil; DynamicSymbolTablePointer:=nil;
   DynamicSymbolTableCount:=0; DynamicSharedObjectNameIndex:=0;
   while(i<=DynamicCount)do
    begin
     if(Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_hash) then
      begin
       HashPointer:=SharedContent+
       Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_string_table) then
      begin
       DynamicStringTablePointer:=SharedContent+
       Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_symbol_table) then
      begin
       DynamicSymbolTablePointer:=SharedContent+
       Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_shared_object_name) then
      begin
       DynamicSharedObjectNameIndex:=
       Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value;
      end;
     inc(i);
    end;
   if(HashPointer=nil) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:Hash Table missing,cannot determine the symbol count of the library '+
     DynamicLibraryPath);
     readln;
     halt;
    end;
   DynamicSymbolTableCount:=(Pdword(HashPointer)^-1) shr 1;
   if(DynamicSymbolTablePointer=nil) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:Dynamic Symbol Table Missing,cannot parse the dynamic symbol table.');
     readln;
     halt;
    end;
   if(DynamicStringTablePointer=nil) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:Dynamic String Table Missing,cannot parse the dynamic symbol table.');
     readln;
     halt;
    end;
   Result.SharedObjectName:=PChar(DynamicStringTablePointer+DynamicSharedObjectNameIndex);
   SetLength(Result.SymbolName,DynamicSymbolTableCount-1);
   SetLength(Result.SymbolNameHash,DynamicSymbolTableCount-1);
   i:=0; j:=2;
   while(j<=DynamicSymbolTableCount)do
    begin
     if(elf32_reloc_type(Pelf32_symbol_table_entry(DynamicSymbolTablePointer+(j-1)*
     sizeof(elf32_symbol_table_entry))^.symbol_info)<>elf_symbol_type_function) and
     (elf32_reloc_type(Pelf32_symbol_table_entry(DynamicSymbolTablePointer+(j-1)*
     sizeof(elf32_symbol_table_entry))^.symbol_info)<>elf_symbol_type_object) then
      begin
       inc(j); continue;
      end;
     inc(i);
     Result.SymbolName[i-1]:=
     PChar(DynamicStringTablePointer+Pelf32_symbol_table_entry(DynamicSymbolTablePointer+(j-1)*
     sizeof(elf32_symbol_table_entry))^.symbol_name);
     Result.SymbolNameHash[i-1]:=unihash_generate_value(Result.SymbolName[i-1],false);
     inc(j);
    end;
   Result.SymbolCount:=i;
  end
 else if(CheckBits=64) then
  begin
   {Check the ELF File Type is the Shared Object}
   if(Pelf64_header(SharedContent)^.elf_type<>elf_type_dynamic) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:File '+DynamicLibraryPath+' is not the Shared Object File.');
     readln;
     halt;
    end;
   {Check the Architecture of the Dynamic Library}
   if(Pelf64_header(SharedContent)^.elf_machine<>CheckArchitecture) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:'+DynamicLibraryPath+' is not a vaild ELF Dynamic Library with corresponding architecture.');
     readln;
     halt;
    end;
   {Get the Program Header Offset and its Count}
   SearchOffset:=SharedContent+Pelf64_header(SharedContent)^.elf_program_header_offset;
   SearchCount:=Pelf64_header(SharedContent)^.elf_program_header_number;
   i:=1;
   while(i<=SearchCount)do
    begin
     if(Pelf64_program_header(SearchOffset+(i-1)*sizeof(Pelf64_program_header))^.program_type=
     elf_program_header_type_dynamic) then
      begin
       DynamicPointer:=
       SharedContent+Pelf64_program_header(SearchOffset+(i-1)*
       sizeof(Pelf64_program_header))^.program_offset;
       DynamicCount:=
       Pelf64_program_header(SearchOffset+(i-1)*
       sizeof(Pelf64_program_header))^.program_file_size div sizeof(elf64_dynamic_entry);
       break;
      end;
     inc(i);
    end;
   if(i>SearchCount) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:Cannot find dynamic section in Dynamic Library '+DynamicLibraryPath+
     '.Dynamic Library is not vaild.');
     readln;
     halt;
    end;
   {Then find the .hash,.dynsym and .dynstr section.}
   i:=1;
   HashPointer:=nil; DynamicStringTablePointer:=nil; DynamicSymbolTablePointer:=nil;
   DynamicSymbolTableCount:=0; DynamicSharedObjectNameIndex:=0;
   while(i<=DynamicCount)do
    begin
     if(Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_hash) then
      begin
       HashPointer:=SharedContent+
       Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_string_table) then
      begin
       DynamicStringTablePointer:=SharedContent+
       Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_symbol_table) then
      begin
       DynamicSymbolTablePointer:=SharedContent+
       Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_shared_object_name) then
      begin
       DynamicSharedObjectNameIndex:=
       Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value;
      end;
     inc(i);
    end;
   if(HashPointer=nil) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:Hash Table missing,cannot determine the symbol count of the library '+
     DynamicLibraryPath);
     readln;
     halt;
    end;
   DynamicSymbolTableCount:=(Pdword(HashPointer)^-1) shr 1;
   if(DynamicSymbolTablePointer=nil) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:Dynamic Symbol Table Missing,cannot parse the dynamic symbol table.');
     readln;
     halt;
    end;
   if(DynamicStringTablePointer=nil) then
    begin
     FreeMem(SharedContent);
     writeln('ERROR:Dynamic String Table Missing,cannot parse the dynamic symbol table.');
     readln;
     halt;
    end;
   Result.SharedObjectName:=PChar(DynamicStringTablePointer+DynamicSharedObjectNameIndex);
   SetLength(Result.SymbolName,DynamicSymbolTableCount-1);
   SetLength(Result.SymbolNameHash,DynamicSymbolTableCount-1);
   i:=0; j:=2;
   while(j<=DynamicSymbolTableCount)do
    begin
     if(elf64_reloc_type(Pelf64_symbol_table_entry(DynamicSymbolTablePointer+(j-1)*
     sizeof(elf64_symbol_table_entry))^.symbol_info)<>elf_symbol_type_function) and
     (elf64_reloc_type(Pelf64_symbol_table_entry(DynamicSymbolTablePointer+(j-1)*
     sizeof(elf64_symbol_table_entry))^.symbol_info)<>elf_symbol_type_object) then
      begin
       inc(j); continue;
      end;
     inc(i);
     Result.SymbolName[i-1]:=
     PChar(DynamicStringTablePointer+Pelf64_symbol_table_entry(DynamicSymbolTablePointer+(j-1)*
     sizeof(elf64_symbol_table_entry))^.symbol_name);
     Result.SymbolNameHash[i-1]:=unihash_generate_value(Result.SymbolName[i-1],false);
     inc(j);
    end;
   Result.SymbolCount:=i;
  end;
 FreeMem(SharedContent);
end;
procedure unifile_add_elf_dynamic_library_to_total(var TotalLibrary:unifile_elf_dynamic_library_total;
SubDynamicLibrary:unifile_elf_dynamic_library);
var i,StartPoint:SizeUint;
begin
 inc(TotalLibrary.SharedObjectCount);
 SetLength(TotalLibrary.SharedObjectName,TotalLibrary.SharedObjectCount);
 TotalLibrary.SharedObjectName[TotalLibrary.SharedObjectCount-1]:=
 SubDynamicLibrary.SharedObjectName;
 StartPoint:=TotalLibrary.SymbolCount+1;
 inc(TotalLibrary.SymbolCount,SubDynamicLibrary.SymbolCount);
 SetLength(TotalLibrary.SymbolFileIndex,TotalLibrary.SymbolCount);
 SetLength(TotalLibrary.SymbolName,TotalLibrary.SymbolCount);
 SetLength(TotalLibrary.SymbolNameHash,TotalLibrary.SymbolCount);
 for i:=StartPoint to TotalLibrary.SymbolCount do
  begin
   TotalLibrary.SymbolFileIndex[i-1]:=TotalLibrary.SharedObjectCount;
   TotalLibrary.SymbolName[i-1]:=SubDynamicLibrary.SymbolName[i-StartPoint];
   TotalLibrary.SymbolNameHash[i-1]:=SubDynamicLibrary.SymbolNameHash[i-StartPoint];
  end;
end;
procedure unifile_elf_dynamic_library_total_generate_hash_table(
var TotalLibrary:unifile_elf_dynamic_library_total);
var i,Index:SizeUint;
    TempBool:boolean;
begin
 TotalLibrary.HashTableEnable:=true;
 TotalLibrary.BucketCount:=TotalLibrary.SymbolCount*8 div 7;
 SetLength(TotalLibrary.BucketEnable,TotalLibrary.SymbolCount+1);
 SetLength(TotalLibrary.BucketItem,TotalLibrary.SymbolCount+1);
 TotalLibrary.ChainCount:=TotalLibrary.SymbolCount;
 SetLength(TotalLibrary.ChainEnable,TotalLibrary.SymbolCount+1);
 SetLength(TotalLibrary.ChainItem,TotalLibrary.SymbolCount+1);
 for i:=1 to TotalLibrary.SymbolCount do
  begin
   Index:=TotalLibrary.SymbolNameHash[i-1] mod TotalLibrary.BucketCount+1;
   TempBool:=false;
   if(TotalLibrary.BucketEnable[Index]=false) then
    begin
     TotalLibrary.BucketEnable[Index]:=true;
     TotalLibrary.BucketItem[Index]:=i;
    end
   else
    begin
     Index:=TotalLibrary.BucketItem[Index];
     if(TotalLibrary.SymbolNameHash[Index-1]=TotalLibrary.SymbolNameHash[i-1]) then TempBool:=true;
     if(TempBool) then continue;
     while(TotalLibrary.ChainEnable[Index])do
      begin
       if(TempBool) then break;
       Index:=TotalLibrary.ChainItem[Index];
      end;
     if(TempBool) then continue;
     TotalLibrary.ChainEnable[Index]:=true;
     TotalLibrary.ChainItem[Index]:=i;
    end;
  end;
end;
function unifile_elf_dynamic_library_total_search_for_hash_table(
TotalLibrary:unifile_elf_dynamic_library_total;TotalHash:SizeUint):boolean;
var SearchIndex:SizeUint;
begin
 if(TotalLibrary.HashTableEnable=false) then exit(false);
 SearchIndex:=TotalHash mod TotalLibrary.SymbolCount+1;
 if(TotalLibrary.BucketEnable[SearchIndex]) then
  begin
   SearchIndex:=TotalLibrary.BucketItem[SearchIndex];
   if(TotalLibrary.SymbolNameHash[SearchIndex-1]=TotalHash) then exit(true)
   else
    begin
     while(TotalLibrary.ChainEnable[SearchIndex])do
      begin
       if(TotalLibrary.SymbolNameHash[SearchIndex]=TotalHash) then exit(true);
       SearchIndex:=TotalLibrary.ChainItem[SearchIndex];
      end;
     Result:=false;
    end;
  end
 else exit(false);
end;
function unifile_check_interpreter(InterpreterPath:string;CheckArchitecture:word;CheckBits:byte;
var basescript:unild_script):unifile_elf_interpreter;
var fs:TFileStream;
    InterpreterContent:Pointer;
    i,j,FunctionIndex:SizeUint;
    {For Finding the Needed Function}
    SearchOffset:Dword;
    SearchCount:Dword;
    SearchFunctionHash:Dword;
    DynamicPointer:Pointer;
    DynamicCount:Dword;
    HashPointer:Pointer;
    DynamicSymbolPointer:Pointer;
    DynamicSymbolCount:Dword;
    DynamicStringPointer:Pointer;
    {For Temporary Variable during searching}
    tempnum1,tempnum2,tempnum3:SizeUint;
begin
 {Read the elf interpreter file in disk}
 fs:=TFileStream.Create(InterpreterPath,fmOpenRead);
 InterpreterContent:=allocmem(fs.Size);
 fs.Read(InterpreterContent^,fs.Size);
 fs.Free;
 {Hash the Search Function}
 SearchFunctionHash:=unifile_elf_hash(basescript.InterpreterDynamicLinkFunction);
 {Then Check the elf file}
 if(elf_check_signature(Pelf32_header(InterpreterContent)^.elf_id)=false) then
  begin
   FreeMem(InterpreterContent);
   writeln('ERROR:Interpreter is not the ELF Format File.');
   readln;
   halt;
  end;
 if(CheckBits=32) and
 (Pelf32_header(InterpreterContent)^.elf_id[elf_class_position]<>elf_class_32) then
  begin
   FreeMem(InterpreterContent);
   writeln('ERROR:Interpreter is not the ELF File correspond to the 32-bit file.');
   readln;
   halt;
  end
 else if(CheckBits=64) and
 (Pelf32_header(InterpreterContent)^.elf_id[elf_class_position]<>elf_class_64) then
  begin
   FreeMem(InterpreterContent);
   writeln('ERROR:Interpreter is not the ELF File correspond to the 64-bit file.');
   readln;
   halt;
  end;
 if(CheckBits=32) then
  begin
   {Check the ELF File Type is the Shared Object}
   if(Pelf32_header(InterpreterContent)^.elf_type<>elf_type_dynamic) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:File '+InterpreterPath+' is not the Shared Object File.');
     readln;
     halt;
    end;
   {Check the Interpreter is equal to the output file architecture}
   if(Pelf32_header(InterpreterContent)^.elf_machine<>CheckArchitecture) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Interpreter Architecture is not equal the Executable Architecture.');
     readln;
     halt;
    end;
   {Search for Dynamic Section}
   SearchOffset:=Pelf32_header(InterpreterContent)^.elf_program_header_offset;
   SearchCount:=Pelf32_header(InterpreterContent)^.elf_program_header_number;
   i:=1; DynamicPointer:=nil;
   while(i<=SearchCount)do
    begin
     if(Pelf32_program_header(InterpreterContent+SearchOffset+
     (i-1)*sizeof(elf32_program_header))^.program_type=elf_program_header_type_dynamic) then
      begin
       DynamicPointer:=InterpreterContent+
       Pelf32_program_header(InterpreterContent+SearchOffset+
       (i-1)*sizeof(elf32_program_header))^.program_offset;
       DynamicCount:=Pelf32_program_header(InterpreterContent+SearchOffset+
       (i-1)*sizeof(elf32_program_header))^.program_file_size div sizeof(elf32_program_header);
       break;
      end;
     inc(i);
    end;
   if(i>SearchCount) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Cannot find the dynamic section in interpreter '+InterpreterPath);
     readln;
     halt;
    end;
   i:=1;
   HashPointer:=nil; DynamicSymbolPointer:=nil; DynamicSymbolCount:=0; DynamicStringPointer:=nil;
   while(i<=DynamicCount)do
    begin
     if(Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_hash) then
      begin
       HashPointer:=InterpreterContent+
       Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_symbol_table) then
      begin
       DynamicSymbolPointer:=InterpreterContent+
       Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_String_table) then
      begin
       DynamicStringPointer:=InterpreterContent+
       Pelf32_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer;
      end;
     inc(i);
    end;
   if(HashPointer=nil) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Hash Section does not exist,cannot determine the count of the symbol table.');
     readln;
     halt;
    end;
   if(DynamicStringPointer=nil) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Dynamic String Table Section does not exist,cannot know the symbol name.');
     readln;
     halt;
    end;
   if(DynamicSymbolPointer=nil) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Dynamic Symbol Table does not exist,cannot acquire the symbol attributes.');
     readln;
     halt;
    end;
   {Translate the hash data to data structure of the linker}
   tempnum1:=Pdword(HashPointer)^;
   Result.InterpreterHashTable.BucketCount:=tempnum1;
   SetLength(Result.InterpreterHashTable.BucketItem,tempnum1);
   SetLength(Result.InterpreterHashTable.BucketHash,tempnum1);
   tempnum2:=Pdword(HashPointer+4)^;
   Result.InterpreterHashTable.ChainCount:=tempnum2;
   SetLength(Result.InterpreterHashTable.ChainItem,tempnum2);
   SetLength(Result.InterpreterHashTable.ChainHash,tempnum2);
   SetLength(Result.InterpreterSymbolHash,tempnum2);
   for i:=2 to tempnum1 do
    begin
     Result.InterpreterSymbolHash[i-1]:=
     unifile_elf_hash(PChar(DynamicStringPointer+
     Pelf32_symbol_table_entry(DynamicSymbolPointer+(i-1)*sizeof(elf32_symbol_table_entry))^.symbol_name));
    end;
   for i:=1 to Result.InterpreterHashTable.BucketCount do
    begin
     Result.InterpreterHashTable.BucketItem[i-1]:=Pdword(HashPointer+4+i*4)^;
     Result.InterpreterHashTable.BucketHash[i-1]:=
     Result.InterpreterSymbolHash[Pdword(HashPointer+i*4)^];
    end;
   for i:=1 to Result.InterpreterHashTable.ChainCount do
    begin
     Result.InterpreterHashTable.ChainItem[i-1]:=Pdword(HashPointer+4+tempnum1*4+i*4)^;
     Result.InterpreterHashTable.ChainHash[i-1]:=
     Result.InterpreterSymbolHash[Pdword(HashPointer+4+tempnum1*4+i*4)^];
    end;
   DynamicSymbolCount:=Result.InterpreterHashTable.ChainCount;
   FunctionIndex:=unifile_search_for_interpreter_hash_table(
   Result.InterpreterHashTable,SearchFunctionHash);
   if(FunctionIndex=0) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Needed Function '+basescript.InterpreterDynamicLinkFunction
     + 'not found in interpreter.');
     readln;
     halt;
    end;
   Result.DynamicLibraryResolveOffset:=
   Pelf32_symbol_table_entry(DynamicSymbolPointer+(
   FunctionIndex-1)*sizeof(elf32_symbol_table_entry))^.symbol_value;
  end
 else if(CheckBits=64) then
  begin
   {Check the ELF File Type is the Shared Object}
   if(Pelf64_header(InterpreterContent)^.elf_type<>elf_type_dynamic) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:File '+InterpreterPath+' is not the Shared Object File.');
     readln;
     halt;
    end;
   {Check the Interpreter is equal to the output file architecture}
   if(Pelf64_header(InterpreterContent)^.elf_machine<>CheckArchitecture) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Interpreter Architecture is not equal the Executable Architecture.');
     readln;
     halt;
    end;
   {Search for Dynamic Section}
   SearchOffset:=Pelf64_header(InterpreterContent)^.elf_program_header_offset;
   SearchCount:=Pelf64_header(InterpreterContent)^.elf_program_header_number;
   i:=1; DynamicPointer:=nil;
   while(i<=SearchCount)do
    begin
     if(Pelf64_program_header(InterpreterContent+SearchOffset+
     (i-1)*sizeof(elf64_program_header))^.program_type=elf_program_header_type_dynamic) then
      begin
       DynamicPointer:=InterpreterContent+
       Pelf64_program_header(InterpreterContent+SearchOffset+
       (i-1)*sizeof(elf64_program_header))^.program_offset;
       DynamicCount:=Pelf64_program_header(InterpreterContent+SearchOffset+
       (i-1)*sizeof(elf64_program_header))^.program_file_size div sizeof(elf64_program_header);
       break;
      end;
     inc(i);
    end;
   if(i>SearchCount) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Cannot find the dynamic section in interpreter '+InterpreterPath);
     readln;
     halt;
    end;
   i:=1;
   HashPointer:=nil; DynamicSymbolPointer:=nil; DynamicSymbolCount:=0; DynamicStringPointer:=nil;
   while(i<=DynamicCount)do
    begin
     if(Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_hash) then
      begin
       HashPointer:=InterpreterContent+
       Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_symbol_table) then
      begin
       DynamicSymbolPointer:=InterpreterContent+
       Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer;
      end
     else if(Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type=
     elf_dynamic_type_String_table) then
      begin
       DynamicStringPointer:=InterpreterContent+
       Pelf64_dynamic_entry(DynamicPointer+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer;
      end;
     inc(i);
    end;
   if(HashPointer=nil) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Hash Section does not exist,cannot determine the count of the symbol table.');
     readln;
     halt;
    end;
   if(DynamicStringPointer=nil) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Dynamic String Table Section does not exist,cannot know the symbol name.');
     readln;
     halt;
    end;
   if(DynamicSymbolPointer=nil) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Dynamic Symbol Table does not exist,cannot acquire the symbol attributes.');
     readln;
     halt;
    end;
   {Translate the hash data to data structure of the linker}
   tempnum1:=Pdword(HashPointer)^;
   Result.InterpreterHashTable.BucketCount:=tempnum1;
   SetLength(Result.InterpreterHashTable.BucketItem,tempnum1);
   SetLength(Result.InterpreterHashTable.BucketHash,tempnum1);
   tempnum2:=Pdword(HashPointer+4)^;
   Result.InterpreterHashTable.ChainCount:=tempnum2;
   SetLength(Result.InterpreterHashTable.ChainItem,tempnum2);
   SetLength(Result.InterpreterHashTable.ChainHash,tempnum2);
   SetLength(Result.InterpreterSymbolHash,tempnum2);
   for i:=2 to tempnum1 do
    begin
     Result.InterpreterSymbolHash[i-1]:=
     unifile_elf_hash(PChar(DynamicStringPointer+
     Pelf64_symbol_table_entry(DynamicSymbolPointer+(i-1)*sizeof(elf64_symbol_table_entry))^.symbol_name));
    end;
   for i:=1 to Result.InterpreterHashTable.BucketCount do
    begin
     Result.InterpreterHashTable.BucketItem[i-1]:=Pdword(HashPointer+4+i*4)^;
     Result.InterpreterHashTable.BucketHash[i-1]:=
     Result.InterpreterSymbolHash[Pdword(HashPointer+i*4)^];
    end;
   for i:=1 to Result.InterpreterHashTable.ChainCount do
    begin
     Result.InterpreterHashTable.ChainItem[i-1]:=Pdword(HashPointer+4+tempnum1*4+i*4)^;
     Result.InterpreterHashTable.ChainHash[i-1]:=
     Result.InterpreterSymbolHash[Pdword(HashPointer+4+tempnum1*4+i*4)^];
    end;
   DynamicSymbolCount:=Result.InterpreterHashTable.ChainCount;
   FunctionIndex:=unifile_search_for_interpreter_hash_table(
   Result.InterpreterHashTable,SearchFunctionHash);
   if(FunctionIndex=0) then
    begin
     FreeMem(InterpreterContent);
     writeln('ERROR:Needed Function '+basescript.InterpreterDynamicLinkFunction
     + 'not found in interpreter.');
     readln;
     halt;
    end;
   Result.DynamicLibraryResolveOffset:=
   Pelf64_symbol_table_entry(DynamicSymbolPointer+(
   FunctionIndex-1)*sizeof(elf64_symbol_table_entry))^.symbol_value;
  end;
 FreeMem(InterpreterContent);
end;
function unifile_read_elf_file(fn:string):unifile_elf_object_file;
var fs:TFileStream;
    OriginalContent:Pointer;
    i,j:SizeUint;
    {For Section Analysis}
    SectionCount:word;
    SectionOffset:SizeUint;
    SectionPointer:Pointer;
    SectionDataPointer:Pointer;
    StringTableIndex:word;
    StringTablePointer:PChar;
    StrTabIndex:word;
    StrTabPointer:PChar;
    SymbolCount:SizeUInt;
    {For Section Symbols}
    SectionIndex:word;
    SectionPointerForSymbol:Pointer;
begin
 {Read the elf object file in disk}
 if(not FileExists(fn)) then
  begin
   writeln('ERROR:'+fn+' does not exist.');
   readln;
   halt;
  end;
 fs:=TFileStream.Create(fn,fmOpenRead);
 OriginalContent:=allocmem(fs.Size);
 fs.Read(OriginalContent^,fs.Size);
 fs.Free;
 {Get the File Data Pointer of the file}
 Result.FilePointer:=OriginalContent;
 {Then Check the elf file}
 if(elf_check_signature(Pelf32_header(OriginalContent)^.elf_id)=false) then
  begin
   FreeMem(OriginalContent);
   writeln('ERROR:File '+fn+' is not a vaild elf file.');
   readln;
   halt;
  end;
 if(Pelf32_header(OriginalContent)^.elf_id[elf_class_position]=elf_class_32) then
 Result.Bits:=unifile_bit_32
 else if(Pelf32_header(OriginalContent)^.elf_id[elf_class_position]=elf_class_64) then
 Result.Bits:=unifile_bit_64
 else
  begin
   FreeMem(OriginalContent);
   writeln('ERROR:File '+fn+' elf file class is invaild.');
   readln;
   halt;
  end;
 if(Result.Bits=32) then
  begin
   Result.Architecture:=Pelf32_header(OriginalContent)^.elf_machine;
   if(Pelf32_header(OriginalContent)^.elf_type>elf_type_relocatable) then
    begin
     FreeMem(OriginalContent);
     writeln('ERROR:File'+fn+' is not untyped or relocatable file,cannot be linked.');
     readln;
     halt;
    end;
  end
 else if(Result.Bits=64) then
  begin
   Result.Architecture:=Pelf64_header(OriginalContent)^.elf_machine;
   if(Pelf64_header(OriginalContent)^.elf_type>elf_type_relocatable) then
    begin
     FreeMem(OriginalContent);
     writeln('ERROR:File'+fn+' is not untyped or relocatable file,cannot be linked.');
     readln;
     halt;
    end;
  end;
 {After that,parse the elf file}
 SectionCount:=0; Result.RelocationCount:=0;
 if(Result.Bits=32) then
  begin
   SectionOffset:=Pelf32_header(OriginalContent)^.elf_section_header_offset;
   Result.FileFlag:=Pelf32_header(OriginalContent)^.elf_flags;
   StringTableIndex:=Pelf32_header(OriginalContent)^.elf_section_header_string_table_index;
   StringTablePointer:=
   PChar(OriginalContent+Pelf32_section_header(OriginalContent+SectionOffset+
   StringTableIndex*sizeof(elf32_section_header))^.section_header_offset);
   SectionCount:=Pelf32_header(OriginalContent)^.elf_section_header_number;
   Result.SectionCount:=SectionCount;
   SetLength(Result.SectionAlign,SectionCount);
   SetLength(Result.SectionType,SectionCount);
   SetLength(Result.SectionName,SectionCount);
   SetLength(Result.SectionInfo,SectionCount);
   SetLength(Result.SectionFlag,SectionCount);
   SetLength(Result.SectionLink,SectionCount);
   SetLength(Result.SectionContent,SectionCount);
   SetLength(Result.SectionSize,SectionCount);
   for i:=2 to SectionCount do
    begin
     SectionPointer:=OriginalContent+SectionOffset+(i-1)*sizeof(elf32_section_header);
     if(Pelf32_section_header(SectionPointer)^.section_header_type=elf_section_type_symtab) then
      begin
       Result.SymbolTable.SymbolCount:=0;
       SectionDataPointer:=OriginalContent+Pelf32_section_header(SectionPointer)^.section_header_offset;
       StrTabIndex:=Pelf32_section_header(SectionPointer)^.section_header_link;
       StrTabPointer:=PChar(OriginalContent+
       Pelf32_section_header(OriginalContent+SectionOffset+
       sizeof(elf32_section_header)*StrTabIndex)^.section_header_offset);
       SymbolCount:=Pelf32_section_header(SectionPointer)^.section_header_size div
       sizeof(elf32_symbol_table_entry);
       Result.SymbolTable.SymbolCount:=SymbolCount;
       SetLength(Result.SymbolTable.SymbolName,SymbolCount);
       SetLength(Result.SymbolTable.SymbolSectionIndex,SymbolCount);
       SetLength(Result.SymbolTable.SymbolSize,SymbolCount);
       SetLength(Result.SymbolTable.SymbolType,SymbolCount);
       SetLength(Result.SymbolTable.SymbolBinding,SymbolCount);
       SetLength(Result.SymbolTable.SymbolValue,SymbolCount);
       SetLength(Result.SymbolTable.SymbolVisibility,SymbolCount);
       for j:=1 to SymbolCount-1 do
        begin
         Result.SymbolTable.SymbolName[j]:=
         StrTabPointer+
         Pelf32_symbol_table_entry(SectionDataPointer+j*sizeof(elf32_symbol_table_entry))^.symbol_name;
         Result.SymbolTable.SymbolSectionIndex[j]:=
         Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_section_index;
         Result.SymbolTable.SymbolValue[j]:=
         Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_value;
         Result.SymbolTable.SymbolSize[j]:=
         Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_size;
         Result.SymbolTable.SymbolType[j]:=
         elf_symbol_type_type(Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_info);
         Result.SymbolTable.SymbolBinding[j]:=
         elf_symbol_type_bind(Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_info);
         Result.SymbolTable.SymbolVisibility[j]:=
         Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_other;
         if(Result.SymbolTable.SymbolType[j]=elf_symbol_type_section) then
          begin
           SectionIndex:=Result.SymbolTable.SymbolSectionIndex[j];
           SectionPointerForSymbol:=OriginalContent+SectionOffset+
           SectionIndex*sizeof(elf32_section_header);
           Result.SymbolTable.SymbolName[j]:=
           PChar(StringTablePointer+Pelf32_section_header(SectionPointerForSymbol)^.section_header_name);
          end;
        end;
      end;
     if(Pelf32_section_header(SectionPointer)^.section_header_type=elf_section_type_rela)
     or(Pelf32_section_header(SectionPointer)^.section_header_type=elf_section_type_reloc) then
      begin
       inc(Result.RelocationCount);
      end;
     Result.SectionAlign[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_address_align;
     Result.SectionType[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_type;
     Result.SectionSize[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_size;
     Result.SectionLink[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_link;
     Result.SectionInfo[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_info;
     Result.SectionFlag[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_flags;
     Result.SectionName[i-1]:=StringTablePointer+
     Pelf32_section_header(SectionPointer)^.section_header_name;
     SectionDataPointer:=OriginalContent+Pelf32_section_header(SectionPointer)^.section_header_offset;
     if(Result.SectionType[i-1]<>elf_section_type_nobit)
     and(Result.SectionType[i-1]<>elf_section_type_null) then
     Result.SectionContent[i-1]:=SectionDataPointer;
    end;
  end
 else if(Result.Bits=64) then
  begin
   SectionOffset:=Pelf64_header(OriginalContent)^.elf_section_header_offset;
   Result.FileFlag:=Pelf64_header(OriginalContent)^.elf_flags;
   StringTableIndex:=Pelf64_header(OriginalContent)^.elf_section_header_string_table_index;
   StringTablePointer:=
   PChar(OriginalContent+Pelf64_section_header(OriginalContent+SectionOffset+
   StringTableIndex*sizeof(elf64_section_header))^.section_header_offset);
   SectionCount:=Pelf64_header(OriginalContent)^.elf_section_header_number;
   Result.SectionCount:=SectionCount;
   SetLength(Result.SectionAlign,SectionCount);
   SetLength(Result.SectionType,SectionCount);
   SetLength(Result.SectionName,SectionCount);
   SetLength(Result.SectionInfo,SectionCount);
   SetLength(Result.SectionFlag,SectionCount);
   SetLength(Result.SectionLink,SectionCount);
   SetLength(Result.SectionContent,SectionCount);
   SetLength(Result.SectionSize,SectionCount);
   for i:=2 to SectionCount do
    begin
     SectionPointer:=OriginalContent+SectionOffset+(i-1)*sizeof(elf64_section_header);
     if(Pelf64_section_header(SectionPointer)^.section_header_type=elf_section_type_symtab) then
      begin
       Result.SymbolTable.SymbolCount:=0;
       SectionDataPointer:=OriginalContent+Pelf64_section_header(SectionPointer)^.section_header_offset;
       StrTabIndex:=Pelf64_section_header(SectionPointer)^.section_header_link;
       StrTabPointer:=PChar(OriginalContent+
       Pelf64_section_header(OriginalContent+SectionOffset+
       sizeof(elf64_section_header)*StrTabIndex)^.section_header_offset);
       SymbolCount:=Pelf64_section_header(SectionPointer)^.section_header_size div
       sizeof(elf64_symbol_table_entry);
       Result.SymbolTable.SymbolCount:=SymbolCount;
       SetLength(Result.SymbolTable.SymbolName,SymbolCount);
       SetLength(Result.SymbolTable.SymbolSectionIndex,SymbolCount);
       SetLength(Result.SymbolTable.SymbolSize,SymbolCount);
       SetLength(Result.SymbolTable.SymbolType,SymbolCount);
       SetLength(Result.SymbolTable.SymbolBinding,SymbolCount);
       SetLength(Result.SymbolTable.SymbolValue,SymbolCount);
       SetLength(Result.SymbolTable.SymbolVisibility,SymbolCount);
       for j:=1 to SymbolCount-1 do
        begin
         Result.SymbolTable.SymbolName[j]:=
         StrTabPointer+
         Pelf64_symbol_table_entry(SectionDataPointer+j*sizeof(elf64_symbol_table_entry))^.symbol_name;
         Result.SymbolTable.SymbolSectionIndex[j]:=
         Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_section_index;
         Result.SymbolTable.SymbolValue[j]:=
         Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_value;
         Result.SymbolTable.SymbolSize[j]:=
         Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_size;
         Result.SymbolTable.SymbolType[j]:=
         elf_symbol_type_type(Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_info);
         Result.SymbolTable.SymbolBinding[j]:=
         elf_symbol_type_bind(Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_info);
         Result.SymbolTable.SymbolVisibility[j]:=
         Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_other;
         if(Result.SymbolTable.SymbolType[j]=elf_symbol_type_section) then
          begin
           SectionIndex:=Result.SymbolTable.SymbolSectionIndex[j];
           SectionPointerForSymbol:=OriginalContent+SectionOffset+
           SectionIndex*sizeof(elf64_section_header);
           Result.SymbolTable.SymbolName[j]:=
           PChar(StringTablePointer+Pelf64_section_header(SectionPointerForSymbol)^.section_header_name);
          end;
        end;
      end;
     if(Pelf64_section_header(SectionPointer)^.section_header_type=elf_section_type_rela)
     or(Pelf64_section_header(SectionPointer)^.section_header_type=elf_section_type_reloc) then
     inc(Result.RelocationCount);
     Result.SectionAlign[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_address_align;
     Result.SectionType[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_type;
     Result.SectionSize[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_size;
     Result.SectionLink[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_link;
     Result.SectionInfo[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_info;
     Result.SectionFlag[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_flags;
     Result.SectionName[i-1]:=StringTablePointer+
     Pelf64_section_header(SectionPointer)^.section_header_name;
     SectionDataPointer:=OriginalContent+Pelf64_section_header(SectionPointer)^.section_header_offset;
     if(Result.SectionType[i-1]<>elf_section_type_nobit)
     and(Result.SectionType[i-1]<>elf_section_type_null) then
     Result.SectionContent[i-1]:=SectionDataPointer;
    end;
  end;
 Result.SectionCount:=SectionCount;
end;
function unifile_read_elf_file_from_memory(Ptr:Pointer;fn:string):unifile_elf_object_file;
var OriginalContent:Pointer;
    i,j:SizeUint;
    {For Section Analysis}
    SectionCount:word;
    SectionOffset:SizeUint;
    SectionPointer:Pointer;
    SectionDataPointer:Pointer;
    StringTableIndex:word;
    StringTablePointer:PChar;
    StrTabIndex:word;
    StrTabPointer:PChar;
    SymbolCount:SizeUInt;
    {For Section Symbols}
    SectionIndex:word;
    SectionPointerForSymbol:Pointer;
begin
 OriginalContent:=Ptr;
 {Then Check the elf file}
 if(elf_check_signature(Pelf32_header(OriginalContent)^.elf_id)=false) then
  begin
   writeln('ERROR:File '+fn+' is not a vaild elf file.');
   readln;
   halt;
  end;
 if(Pelf32_header(OriginalContent)^.elf_id[elf_class_position]=elf_class_32) then
 Result.Bits:=unifile_bit_32
 else if(Pelf32_header(OriginalContent)^.elf_id[elf_class_position]=elf_class_64) then
 Result.Bits:=unifile_bit_64
 else
  begin
   writeln('ERROR:File '+fn+' elf file class is invaild.');
   readln;
   halt;
  end;
 if(Result.Bits=32) then
  begin
   Result.Architecture:=Pelf32_header(OriginalContent)^.elf_machine;
   if(Pelf32_header(OriginalContent)^.elf_type>elf_type_relocatable) then
    begin
     FreeMem(OriginalContent);
     writeln('ERROR:File'+fn+' is not untyped or relocatable file,cannot be linked.');
     readln;
     halt;
    end;
  end
 else if(Result.Bits=64) then
  begin
   Result.Architecture:=Pelf64_header(OriginalContent)^.elf_machine;
   if(Pelf64_header(OriginalContent)^.elf_type>elf_type_relocatable) then
    begin
     FreeMem(OriginalContent);
     writeln('ERROR:File'+fn+' is not untyped or relocatable file,cannot be linked.');
     readln;
     halt;
    end;
  end;
 SectionCount:=0; Result.RelocationCount:=0;
 {After that,parse the elf file}
 if(Result.Bits=32) then
  begin
   SectionOffset:=Pelf32_header(OriginalContent)^.elf_section_header_offset;
   Result.FileFlag:=Pelf32_header(OriginalContent)^.elf_flags;
   StringTableIndex:=Pelf32_header(OriginalContent)^.elf_section_header_string_table_index;
   StringTablePointer:=PChar(OriginalContent+Pelf32_section_header(OriginalContent+SectionOffset+
   StringTableIndex*sizeof(elf32_section_header))^.section_header_offset);
   SectionCount:=Pelf32_header(OriginalContent)^.elf_section_header_number;
   Result.SectionCount:=SectionCount;
   SetLength(Result.SectionAlign,SectionCount);
   SetLength(Result.SectionType,SectionCount);
   SetLength(Result.SectionName,SectionCount);
   SetLength(Result.SectionInfo,SectionCount);
   SetLength(Result.SectionFlag,SectionCount);
   SetLength(Result.SectionLink,SectionCount);
   SetLength(Result.SectionContent,SectionCount);
   SetLength(Result.SectionSize,SectionCount);
   for i:=2 to SectionCount do
    begin
     SectionPointer:=OriginalContent+SectionOffset+(i-1)*sizeof(elf32_section_header);
     if(Pelf32_section_header(SectionPointer)^.section_header_type=elf_section_type_symtab) then
      begin
       Result.SymbolTable.SymbolCount:=0;
       SectionDataPointer:=OriginalContent+Pelf32_section_header(SectionPointer)^.section_header_offset;
       StrTabIndex:=Pelf32_section_header(SectionPointer)^.section_header_link;
       StrTabPointer:=PChar(OriginalContent+
       Pelf32_section_header(OriginalContent+SectionOffset+
       sizeof(elf32_section_header)*StrTabIndex)^.section_header_offset);
       SymbolCount:=Pelf32_section_header(SectionPointer)^.section_header_size div
       sizeof(elf32_symbol_table_entry);
       Result.SymbolTable.SymbolCount:=SymbolCount;
       SetLength(Result.SymbolTable.SymbolName,SymbolCount);
       SetLength(Result.SymbolTable.SymbolSectionIndex,SymbolCount);
       SetLength(Result.SymbolTable.SymbolSize,SymbolCount);
       SetLength(Result.SymbolTable.SymbolType,SymbolCount);
       SetLength(Result.SymbolTable.SymbolBinding,SymbolCount);
       SetLength(Result.SymbolTable.SymbolValue,SymbolCount);
       SetLength(Result.SymbolTable.SymbolVisibility,SymbolCount);
       for j:=1 to SymbolCount-1 do
        begin
         Result.SymbolTable.SymbolName[j]:=
         StrTabPointer+
         Pelf32_symbol_table_entry(SectionDataPointer+j*sizeof(elf32_symbol_table_entry))^.symbol_name;
         Result.SymbolTable.SymbolSectionIndex[j]:=
         Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_section_index;
         Result.SymbolTable.SymbolValue[j]:=
         Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_value;
         Result.SymbolTable.SymbolSize[j]:=
         Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_size;
         Result.SymbolTable.SymbolType[j]:=
         elf_symbol_type_type(Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_info);
         Result.SymbolTable.SymbolBinding[j]:=
         elf_symbol_type_bind(Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_info);
         Result.SymbolTable.SymbolVisibility[j]:=
         Pelf32_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf32_symbol_table_entry))^.symbol_other;
         if(Result.SymbolTable.SymbolType[j]=elf_symbol_type_section) then
          begin
           SectionIndex:=Result.SymbolTable.SymbolSectionIndex[j];
           SectionPointerForSymbol:=OriginalContent+SectionOffset+
           SectionIndex*sizeof(elf32_section_header);
           Result.SymbolTable.SymbolName[j]:=
           PChar(StringTablePointer+Pelf32_section_header(SectionPointerForSymbol)^.section_header_name);
          end;
        end;
      end;
     if(Pelf32_section_header(SectionPointer)^.section_header_type=elf_section_type_rela)
     or(Pelf32_section_header(SectionPointer)^.section_header_type=elf_section_type_reloc) then
     inc(Result.RelocationCount);
     Result.SectionAlign[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_address_align;
     Result.SectionType[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_type;
     Result.SectionSize[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_size;
     Result.SectionLink[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_link;
     Result.SectionInfo[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_info;
     Result.SectionFlag[i-1]:=Pelf32_section_header(SectionPointer)^.section_header_flags;
     Result.SectionName[i-1]:=StringTablePointer+
     Pelf32_section_header(SectionPointer)^.section_header_name;
     SectionDataPointer:=OriginalContent+Pelf32_section_header(SectionPointer)^.section_header_offset;
     if(Result.SectionType[i-1]<>elf_section_type_nobit)
     and(Result.SectionType[i-1]<>elf_section_type_null) then
     Result.SectionContent[i-1]:=SectionDataPointer;
    end;
  end
 else if(Result.Bits=64) then
  begin
   SectionOffset:=Pelf64_header(OriginalContent)^.elf_section_header_offset;
   StringTableIndex:=Pelf64_header(OriginalContent)^.elf_section_header_string_table_index;
   Result.FileFlag:=Pelf64_header(OriginalContent)^.elf_flags;
   StringTablePointer:=PChar(OriginalContent+Pelf64_section_header(OriginalContent+SectionOffset+
   StringTableIndex*sizeof(elf64_section_header))^.section_header_offset);
   SectionCount:=Pelf64_header(OriginalContent)^.elf_section_header_number;
   Result.SectionCount:=SectionCount;
   SetLength(Result.SectionAlign,SectionCount);
   SetLength(Result.SectionType,SectionCount);
   SetLength(Result.SectionName,SectionCount);
   SetLength(Result.SectionInfo,SectionCount);
   SetLength(Result.SectionFlag,SectionCount);
   SetLength(Result.SectionLink,SectionCount);
   SetLength(Result.SectionContent,SectionCount);
   SetLength(Result.SectionSize,SectionCount);
   for i:=2 to SectionCount do
    begin
     SectionPointer:=OriginalContent+SectionOffset+(i-1)*sizeof(elf64_section_header);
     if(Pelf64_section_header(SectionPointer)^.section_header_type=elf_section_type_symtab) then
      begin
       Result.SymbolTable.SymbolCount:=0;
       SectionDataPointer:=OriginalContent+Pelf64_section_header(SectionPointer)^.section_header_offset;
       StrTabIndex:=Pelf64_section_header(SectionPointer)^.section_header_link;
       StrTabPointer:=PChar(OriginalContent+
       Pelf64_section_header(OriginalContent+SectionOffset+
       sizeof(elf64_section_header)*StrTabIndex)^.section_header_offset);
       SymbolCount:=Pelf64_section_header(SectionPointer)^.section_header_size div
       sizeof(elf64_symbol_table_entry);
       Result.SymbolTable.SymbolCount:=SymbolCount;
       SetLength(Result.SymbolTable.SymbolName,SymbolCount);
       SetLength(Result.SymbolTable.SymbolSectionIndex,SymbolCount);
       SetLength(Result.SymbolTable.SymbolSize,SymbolCount);
       SetLength(Result.SymbolTable.SymbolType,SymbolCount);
       SetLength(Result.SymbolTable.SymbolBinding,SymbolCount);
       SetLength(Result.SymbolTable.SymbolValue,SymbolCount);
       SetLength(Result.SymbolTable.SymbolVisibility,SymbolCount);
       for j:=1 to SymbolCount-1 do
        begin
         Result.SymbolTable.SymbolName[j]:=
         StrTabPointer+
         Pelf64_symbol_table_entry(SectionDataPointer+j*sizeof(elf64_symbol_table_entry))^.symbol_name;
         Result.SymbolTable.SymbolSectionIndex[j]:=
         Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_section_index;
         Result.SymbolTable.SymbolValue[j]:=
         Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_value;
         Result.SymbolTable.SymbolSize[j]:=
         Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_size;
         Result.SymbolTable.SymbolType[j]:=
         elf_symbol_type_type(Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_info);
         Result.SymbolTable.SymbolBinding[j]:=
         elf_symbol_type_bind(Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_info);
         Result.SymbolTable.SymbolVisibility[j]:=
         Pelf64_symbol_table_entry(SectionDataPointer+
         j*sizeof(elf64_symbol_table_entry))^.symbol_other;
         if(Result.SymbolTable.SymbolType[j]=elf_symbol_type_section) then
          begin
           SectionIndex:=Result.SymbolTable.SymbolSectionIndex[j];
           SectionPointerForSymbol:=OriginalContent+SectionOffset+
           SectionIndex*sizeof(elf64_section_header);
           Result.SymbolTable.SymbolName[j]:=
           PChar(StringTablePointer+Pelf64_section_header(SectionPointerForSymbol)^.section_header_name);
          end;
        end;
      end;
     if(Pelf64_section_header(SectionPointer)^.section_header_type=elf_section_type_rela)
     or(Pelf64_section_header(SectionPointer)^.section_header_type=elf_section_type_reloc) then
     inc(Result.RelocationCount);
     Result.SectionAlign[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_address_align;
     Result.SectionType[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_type;
     Result.SectionSize[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_size;
     Result.SectionLink[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_link;
     Result.SectionInfo[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_info;
     Result.SectionFlag[i-1]:=Pelf64_section_header(SectionPointer)^.section_header_flags;
     Result.SectionName[i-1]:=StringTablePointer+
     Pelf64_section_header(SectionPointer)^.section_header_name;
     SectionDataPointer:=OriginalContent+Pelf64_section_header(SectionPointer)^.section_header_offset;
     if(Result.SectionType[i-1]<>elf_section_type_nobit)
     and(Result.SectionType[i-1]<>elf_section_type_null) then
     Result.SectionContent[i-1]:=SectionDataPointer;
    end;
  end;
end;
function unifile_read_archive_file(fn:string):unifile_elf_archive_file;
var fs:TFileStream;
    OriginalContent:Pointer;
    i,j,offset1,offset2:SizeUint;
    {For Archive Files Only}
    ArchiveTotalSize:SizeUint;
    ArchivePortionSize:SizeUint;
    ArchiveFileHeader:elf_archive_file_header;
    ArchiveFileName:string;
    ArchiveFileNameLength:SizeUint;
begin
 {Read the elf object file in disk}
 if(not FileExists(fn)) then
  begin
   writeln('ERROR:'+fn+' does not exist.');
   readln;
   halt;
  end;
 fs:=TFileStream.Create(fn,fmOpenRead);
 OriginalContent:=allocmem(fs.Size);
 fs.Read(OriginalContent^,fs.Size);
 {Get the Archive File Content Pointer}
 Result.MainPointer:=OriginalContent;
 {Then Parse the Archive File}
 if(elf_check_archive_signature(OriginalContent)=false) then
  begin
   FreeMem(OriginalContent);
   writeln('ERROR:File '+fn+ 'is not an elf archive file.');
   readln;
   halt;
  end;
 ArchiveTotalSize:=fs.Size;
 fs.Free;
 {After that,extract all elf object file from the Archive file}
 offset1:=8; offset2:=0; Result.ObjectCount:=0;
 while(offset1<=ArchiveTotalSize)do
  begin
   ArchiveFileHeader:=Pelf_archive_file_header(OriginalContent+offset1)^;
   ArchiveFileName:='';
   for i:=1 to 16 do
    begin
     if(ArchiveFileHeader.ArchiveName[i]=' ') then break;
     ArchiveFileName:=ArchiveFileName+ArchiveFileHeader.ArchiveName[i];
    end;
   ArchivePortionSize:=0;
   for i:=1 to 10 do
    begin
     ArchivePortionSize:=ArchivePortionSize*10+
     Byte(Pelf_archive_file_header(OriginalContent+offset1)^.ArchiveSize[i])-Byte('0');
    end;
   if(ArchiveFileName='/') or (ArchiveFileName='//') then
    begin
     inc(offset1,sizeof(ArchiveFileHeader)+ArchivePortionSize); continue;
    end
   else if(Copy(ArchiveFileName,1,3)='#1/') then
    begin
     ArchiveFileName:='';
     ArchiveFileNameLength:=unifile_string_to_integer(Copy(ArchiveFileName,4,length(ArchiveFileName)-3));
     inc(offset1,sizeof(ArchiveFileHeader));
     offset2:=offset1;
     for i:=1 to ArchiveFileNameLength do
      begin
       ArchiveFileName:=ArchiveFileName+PChar(OriginalContent+offset2+i-1)^;
      end;
     inc(offset1,ArchiveFileNameLength);
     inc(Result.ObjectCount);
     SetLength(Result.Objects,Result.ObjectCount);
     Result.Objects[Result.ObjectCount-1]:=
     unifile_read_elf_file_from_memory(OriginalContent+offset1,ArchiveFileName);
     inc(offset1,ArchivePortionSize);
    end
   else
    begin
     inc(offset1,sizeof(ArchiveFileHeader));
     inc(Result.ObjectCount);
     SetLength(Result.Objects,Result.ObjectCount);
     Result.Objects[Result.ObjectCount-1]:=
     unifile_read_elf_file_from_memory(OriginalContent+offset1,ArchiveFileName);
     inc(offset1,ArchivePortionSize);
    end;
  end;
end;
procedure unifile_total_file_initialize(var totalfile:unifile_elf_object_file_total);
begin
 totalfile.ObjectCount:=0;
 totalfile.ObjectPointerCount:=0;
 totalfile.ObjectSectionCount:=0;
 totalfile.ObjectRelocationCount:=0;
 totalfile.ObjectSymbolCount:=0;
end;
procedure unifile_total_add_file(var totalfile:unifile_elf_object_file_total;
objectfile:unifile_elf_object_file);
begin
 inc(totalfile.ObjectPointerCount);
 SetLength(totalfile.ObjectPointer,totalfile.ObjectPointerCount);
 totalfile.ObjectPointer[totalfile.ObjectPointerCount-1]:=objectfile.FilePointer;
 inc(totalfile.ObjectCount);
 SetLength(totalfile.Objects,totalfile.ObjectCount);
 totalfile.Objects[totalfile.ObjectCount-1]:=objectfile;
 inc(totalfile.ObjectSectionCount,objectfile.SectionCount);
 inc(totalfile.ObjectRelocationCount,objectfile.RelocationCount);
 inc(totalfile.ObjectSymbolCount,objectfile.SymbolTable.SymbolCount);
end;
procedure unifile_total_add_archive_file(var totalfile:unifile_elf_object_file_total;
archivefile:unifile_elf_archive_file);
var i:SizeUint;
begin
 inc(totalfile.ObjectPointerCount);
 SetLength(totalfile.ObjectPointer,totalfile.ObjectPointerCount);
 totalfile.ObjectPointer[totalfile.ObjectPointerCount-1]:=archivefile.MainPointer;
 for i:=1 to archivefile.ObjectCount do
  begin
   inc(totalfile.ObjectCount);
   SetLength(totalfile.Objects,totalfile.ObjectCount);
   totalfile.Objects[totalfile.ObjectCount-1]:=archivefile.Objects[i-1];
   inc(totalfile.ObjectSectionCount,archivefile.Objects[i-1].SectionCount);
   inc(totalfile.ObjectRelocationCount,archivefile.Objects[i-1].RelocationCount);
   inc(totalfile.ObjectSymbolCount,archivefile.Objects[i-1].SymbolTable.SymbolCount);
  end;
end;
procedure unifile_total_free(var totalfile:unifile_elf_object_file_total);
var i:SizeUint;
begin
 totalfile.ObjectCount:=0;
 for i:=1 to totalfile.ObjectPointerCount do
  begin
   if(totalfile.ObjectPointer[i-1]<>nil) then
   FreeMem(totalfile.ObjectPointer[i-1]);
  end;
 totalfile.ObjectPointerCount:=0;
end;
function unifile_total_check_bits(totalfile:unifile_elf_object_file_total;Bits:byte):boolean;
var i:SizeUint;
begin
 i:=1;
 for i:=1 to totalfile.ObjectCount do
  begin
   if(totalfile.Objects[i-1].Bits<>Bits) then exit(false);
  end;
 unifile_total_check_bits:=true;
end;
function unifile_total_check(totalfile:unifile_elf_object_file_total;Architecture:byte;Bits:byte):boolean;
var i:SizeUint;
begin
 i:=1;
 for i:=1 to totalfile.ObjectCount do
  begin
   if(totalfile.Objects[i-1].Architecture<>Architecture) or
   (totalfile.Objects[i-1].Bits<>Bits) then exit(false);
  end;
 unifile_total_check:=true;
end;
function unifile_parse(var totalfile:unifile_elf_object_file_total):unifile_elf_object_file_parsed;
var i,j,k,m:SizeUInt;
    {For Relative or Relocation}
    ContentPointer:Pointer;
    ContentSize:SizeUint;
    {For Temporary Strings}
    tempstr:string;
begin
 i:=1; j:=1; k:=0; m:=0; Result.SectionCount:=0; Result.Bits:=0;
 Result.SectionRelocationCount:=0; Result.SectionSymbolTable.SymbolCount:=0;
 Result.FileFlag:=0;
 {Initialize the Parsed file Information}
 SetLength(Result.SectionSymbolTable.SymbolName,totalfile.ObjectSymbolCount);
 SetLength(Result.SectionSymbolTable.SymbolNameHash,totalfile.ObjectSymbolCount);
 SetLength(Result.SectionSymbolTable.SymbolSectionName,totalfile.ObjectSymbolCount);
 SetLength(Result.SectionSymbolTable.SymbolSectionNameHash,totalfile.ObjectSymbolCount);
 SetLength(Result.SectionSymbolTable.SymbolType,totalfile.ObjectSymbolCount);
 SetLength(Result.SectionSymbolTable.SymbolValue,totalfile.ObjectSymbolCount);
 SetLength(Result.SectionSymbolTable.SymbolBinding,totalfile.ObjectSymbolCount);
 SetLength(Result.SectionSymbolTable.SymbolVisibility,totalfile.ObjectSymbolCount);
 SetLength(Result.SectionSymbolTable.SymbolSize,totalfile.ObjectSymbolCount);
 SetLength(Result.SectionName,totalfile.ObjectSectionCount);
 SetLength(Result.SectionAlign,totalfile.ObjectSectionCount);
 SetLength(Result.SectionNameHash,totalfile.ObjectSectionCount);
 SetLength(Result.SectionFlag,totalfile.ObjectSectionCount);
 SetLength(Result.SectionType,totalfile.ObjectSectionCount);
 SetLength(Result.SectionUsed,totalfile.ObjectSectionCount);
 SetLength(Result.SectionContent,totalfile.ObjectSectionCount);
 SetLength(Result.SectionSize,totalfile.ObjectSectionCount);
 SetLength(Result.SectionRelocation,totalfile.ObjectRelocationCount);
 {Then parse the file}
 while(i<=totalfile.ObjectCount)do
  begin
   Result.FileFlag:=Result.FileFlag or totalfile.Objects[i-1].FileFlag;
   if(totalfile.Objects[i-1].Bits>Result.Bits) then Result.Bits:=totalfile.Objects[i-1].Bits;
   Result.Architecture:=totalfile.Objects[i-1].Architecture;
   j:=2;
   while(j<=totalfile.Objects[i-1].SymbolTable.SymbolCount)do
    begin
     if(totalfile.Objects[i-1].SymbolTable.SymbolName[j-1]='')then
      begin
       inc(j); continue;
      end;
     inc(m);
     tempstr:=totalfile.Objects[i-1].SymbolTable.SymbolName[j-1];
     Result.SectionSymbolTable.SymbolName[m-1]:=tempstr;
     if(length(tempstr)>1) and (tempstr[1]='.') then
      begin
       if(totalfile.Objects[i-1].SymbolTable.SymbolType[j-1]=elf_symbol_type_no_type) then
        begin
         tempstr:=tempstr+unifile_generate_index(i-1,j-1,true);
        end
       else
        begin
         tempstr:=tempstr+unifile_generate_index(i-1,0);
        end;
      end;
     Result.SectionSymbolTable.SymbolNameHash[m-1]:=unihash_generate_value(tempstr,false);
     tempstr:='';
     if(totalfile.Objects[i-1].SymbolTable.SymbolSectionIndex[j-1]<>0)
     and(totalfile.Objects[i-1].SymbolTable.SymbolSectionIndex[j-1]<
     totalfile.Objects[i-1].SectionCount) then
      begin
       tempstr:=
       totalfile.Objects[i-1].SectionName[totalfile.Objects[i-1].SymbolTable.SymbolSectionIndex[j-1]];
       Result.SectionSymbolTable.SymbolSectionName[m-1]:=tempstr;
       tempstr:=Result.SectionSymbolTable.SymbolSectionName[m-1]+
       unifile_generate_index(i-1,0);
       Result.SectionSymbolTable.SymbolSectionNameHash[m-1]:=
       unihash_generate_value(tempstr,true);
      end;
     Result.SectionSymbolTable.SymbolType[m-1]:=totalfile.Objects[i-1].SymbolTable.SymbolType[j-1];
     Result.SectionSymbolTable.SymbolSize[m-1]:=totalfile.Objects[i-1].SymbolTable.SymbolSize[j-1];
     Result.SectionSymbolTable.SymbolValue[m-1]:=totalfile.Objects[i-1].SymbolTable.SymbolValue[j-1];
     Result.SectionSymbolTable.SymbolVisibility[m-1]:=
     totalfile.Objects[i-1].SymbolTable.SymbolVisibility[j-1];
     inc(j);
    end;
   j:=1;
   tempstr:='';
   while(j<=totalfile.Objects[i-1].SectionCount)do
    begin
     ContentPointer:=totalfile.Objects[i-1].SectionContent[j-1];
     ContentSize:=totalfile.Objects[i-1].SectionSize[j-1];
     if(totalfile.Objects[i-1].SectionType[j-1]=elf_section_type_rela) then
      begin
       inc(Result.SectionRelocationCount);
       if(Result.Bits=32) then
        begin
         tempstr:=totalfile.Objects[i-1].SectionName[totalfile.Objects[i-1].SectionInfo[j-1]];
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSection:=tempstr;
         tempstr:=tempstr+unifile_generate_index(i-1,0);
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSectionHash:=
         unihash_generate_value(tempstr,true);
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationCount:=ContentSize div 12;
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationOffset,
         ContentSize div 12);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbol,
         ContentSize div 12);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbolHash,
         ContentSize div 12);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationType,
         ContentSize div 12);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationClass,
         ContentSize div 12);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationAddend,
         ContentSize div 12);
         for k:=1 to ContentSize div 12 do
          begin
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationClass[k-1]:=true;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationOffset[k-1]:=
           Pelf32_rela(ContentPointer+(k-1)*12)^.Offset;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationAddend[k-1]:=
           Pelf32_rela(ContentPointer+(k-1)*12)^.Addend;
           tempstr:='';
           if(elf32_reloc_symbol(Pelf32_rela(ContentPointer+(k-1)*12)^.Info)<>0) then
            begin
             tempstr:=totalfile.Objects[i-1].SymbolTable.SymbolName[
             elf32_reloc_symbol(Pelf32_rela(ContentPointer+(k-1)*12)^.Info)];
             Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbol[k-1]:=tempstr;
             if(length(tempstr)>1) and (tempstr[1]='.') then
              begin
               if(totalfile.Objects[i-1].SymbolTable.SymbolType[
               elf32_reloc_symbol(Pelf32_rela(ContentPointer+(k-1)*12)^.Info)]=
               elf_symbol_type_no_type) then
               tempstr:=tempstr+unifile_generate_index(i-1,
               elf32_reloc_symbol(Pelf32_rela(ContentPointer+(k-1)*12)^.Info),true)
               else
               tempstr:=tempstr+unifile_generate_index(i-1,0);
              end;
            end;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbolHash[k-1]:=
           unihash_generate_value(tempstr,false);
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationType[k-1]:=
           elf32_reloc_type(Pelf32_rela(ContentPointer+(k-1)*12)^.Info);
          end;
        end
       else
        begin
         tempstr:=totalfile.Objects[i-1].SectionName[totalfile.Objects[i-1].SectionInfo[j-1]];
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSection:=tempstr;
         tempstr:=tempstr+unifile_generate_index(i-1,0);
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSectionHash:=
         unihash_generate_value(tempstr,true);
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationCount:=ContentSize div 24;
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationOffset,
         ContentSize div 24);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbol,
         ContentSize div 24);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbolHash,
         ContentSize div 24);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationType,
         ContentSize div 24);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationClass,
         ContentSize div 24);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationAddend,
         ContentSize div 24);
         for k:=1 to ContentSize div 24 do
          begin
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationClass[k-1]:=true;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationOffset[k-1]:=
           Pelf64_rela(ContentPointer+(k-1)*24)^.Offset;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationAddend[k-1]:=
           Pelf64_rela(ContentPointer+(k-1)*24)^.Addend;
           tempstr:='';
           if(elf64_reloc_symbol(Pelf64_rela(ContentPointer+(k-1)*24)^.Info)<>0) then
            begin
             tempstr:=totalfile.Objects[i-1].SymbolTable.SymbolName[
             elf64_reloc_symbol(Pelf64_rela(ContentPointer+(k-1)*24)^.Info)];
             Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbol[k-1]:=tempstr;
             if(length(tempstr)>1) and (tempstr[1]='.') then
              begin
               if(totalfile.Objects[i-1].SymbolTable.SymbolType[
               elf64_reloc_symbol(Pelf64_rela(ContentPointer+(k-1)*24)^.Info)]=
               elf_symbol_type_no_type) then
                begin
                 tempstr:=tempstr+unifile_generate_index(i-1,
                 elf64_reloc_symbol(Pelf64_rela(ContentPointer+(k-1)*24)^.Info),true);
                end
               else tempstr:=tempstr+unifile_generate_index(i-1,0);
              end;
            end;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbolHash[k-1]:=
           unihash_generate_value(tempstr,false);
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationType[k-1]:=
           elf64_reloc_type(Pelf64_rela(ContentPointer+(k-1)*24)^.Info);
          end;
        end;
       totalfile.Objects[i-1].SectionType[j-1]:=0;
       totalfile.Objects[i-1].SectionContent[j-1]:=nil;
       inc(j); continue;
      end
     else if(totalfile.Objects[i-1].SectionType[j-1]=elf_section_type_reloc) then
      begin
       inc(Result.SectionRelocationCount);
       if(Result.Bits=32) then
        begin
         tempstr:=totalfile.Objects[i-1].SectionName[totalfile.Objects[i-1].SectionInfo[j-1]];
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSection:=tempstr;
         tempstr:=tempstr+unifile_generate_index(i-1,0);
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSectionHash:=
         unihash_generate_value(tempstr,true);
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationCount:=ContentSize div 8;
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationOffset,
         ContentSize div 8);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbol,
         ContentSize div 8);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbolHash,
         ContentSize div 8);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationType,
         ContentSize div 8);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationClass,
         ContentSize div 8);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationAddend,
         ContentSize div 8);
         for k:=1 to ContentSize div 8 do
          begin
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationClass[k-1]:=true;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationOffset[k-1]:=
           Pelf32_rel(ContentPointer+(k-1)*8)^.Offset;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationAddend[k-1]:=0;
           tempstr:='';
           if(elf32_reloc_symbol(Pelf32_rel(ContentPointer+(k-1)*8)^.Info)<>0) then
            begin
             tempstr:=totalfile.Objects[i-1].SymbolTable.SymbolName[
             elf32_reloc_symbol(Pelf32_rel(ContentPointer+(k-1)*8)^.Info)];
             Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbol[k-1]:=tempstr;
             if(length(tempstr)>1) and (tempstr[1]='.') then
              begin
               if(totalfile.Objects[i-1].SymbolTable.SymbolType[
               elf32_reloc_symbol(Pelf32_rel(ContentPointer+(k-1)*8)^.Info)]=
               elf_symbol_type_no_type) then
               tempstr:=tempstr+unifile_generate_index(i-1,
               elf32_reloc_symbol(Pelf32_rel(ContentPointer+(k-1)*8)^.Info),true)
               else
               tempstr:=tempstr+unifile_generate_index(i-1,0);
              end;
            end;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbolHash[k-1]:=
           unihash_generate_value(tempstr,false);
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationType[k-1]:=
           elf32_reloc_type(Pelf32_rel(ContentPointer+(k-1)*8)^.Info);
          end;
        end
       else
        begin
         tempstr:=totalfile.Objects[i-1].SectionName[totalfile.Objects[i-1].SectionInfo[j-1]];
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSection:=tempstr;
         tempstr:=tempstr+unifile_generate_index(i-1,0);
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSectionHash:=
         unihash_generate_value(tempstr,true);
         Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationCount:=ContentSize div 16;
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationOffset,
         ContentSize div 16);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbol,
         ContentSize div 16);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbolHash,
         ContentSize div 16);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationType,
         ContentSize div 16);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationClass,
         ContentSize div 16);
         SetLength(Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationAddend,
         ContentSize div 16);
         for k:=1 to ContentSize div 16 do
          begin
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationClass[k-1]:=true;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationOffset[k-1]:=
           Pelf64_rel(ContentPointer+(k-1)*16)^.Offset;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationAddend[k-1]:=0;
           tempstr:='';
           if(elf64_reloc_symbol(Pelf64_rel(ContentPointer+(k-1)*16)^.Info)<>0) then
            begin
             tempstr:=totalfile.Objects[i-1].SymbolTable.SymbolName[
             elf64_reloc_symbol(Pelf64_rel(ContentPointer+(k-1)*16)^.Info)];
             Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbol[k-1]:=tempstr;
             if(length(tempstr)>1) and (tempstr[1]='.') then
              begin
               if(totalfile.Objects[i-1].SymbolTable.SymbolType[
               elf64_reloc_symbol(Pelf64_rel(ContentPointer+(k-1)*16)^.Info)]=
               elf_symbol_type_no_type) then
               tempstr:=tempstr+unifile_generate_index(
               i-1,elf64_reloc_symbol(Pelf64_rel(ContentPointer+(k-1)*16)^.Info),true)
               else
               tempstr:=tempstr+unifile_generate_index(i-1,0);
              end;
            end;
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationSymbolHash[k-1]:=
           unihash_generate_value(tempstr,false);
           Result.SectionRelocation[Result.SectionRelocationCount-1].RelocationType[k-1]:=
           elf64_reloc_type(Pelf64_rel(ContentPointer+(k-1)*16)^.Info);
          end;
        end;
       totalfile.Objects[i-1].SectionType[j-1]:=0;
       totalfile.Objects[i-1].SectionContent[j-1]:=nil;
       inc(j); continue;
      end
     else if(totalfile.Objects[i-1].SectionType[j-1]=elf_section_type_symtab)
     or(totalfile.Objects[i-1].SectionType[j-1]=elf_section_type_strtab) then
      begin
       totalfile.Objects[i-1].SectionType[j-1]:=0;
       totalfile.Objects[i-1].SectionContent[j-1]:=nil;
       inc(j); continue;
      end
     else if(totalfile.Objects[i-1].SectionType[j-1]<>elf_section_type_null) then
      begin
       inc(Result.SectionCount);
       tempstr:=totalfile.Objects[i-1].SectionName[j-1];
       Result.SectionName[Result.SectionCount-1]:=tempstr;
       tempstr:=tempstr+unifile_generate_index(i-1,0);
       Result.SectionNameHash[Result.SectionCount-1]:=unihash_generate_value(tempstr,true);
       Result.SectionFlag[Result.SectionCount-1]:=totalfile.Objects[i-1].SectionFlag[j-1];
       Result.SectionType[Result.SectionCount-1]:=totalfile.Objects[i-1].SectionType[j-1];
       Result.SectionSize[Result.SectionCount-1]:=totalfile.Objects[i-1].SectionSize[j-1];
       Result.SectionAlign[Result.SectionCount-1]:=totalfile.Objects[i-1].SectionAlign[j-1];
       tempstr:='';
       if(totalfile.Objects[i-1].SectionType[j-1]<>elf_section_type_nobit) then
       Result.SectionContent[Result.SectionCount-1]:=totalfile.Objects[i-1].SectionContent[j-1];
      end;
     inc(j);
    end;
   inc(i);
  end;
 Result.SectionSymbolTable.SymbolCount:=m;
end;
function unifile_search_for_hash_table(HashTable:unifile_temporary_hash_table;
HashGoal:SizeUint):SizeUint;
var index:SizeUint;
begin
 if(HashTable.BucketCount=0) then exit(0);
 Index:=HashGoal mod HashTable.BucketCount+1;
 if(HashTable.BucketEnable[Index]) then
  begin
   if(HashTable.BucketHash[Index]=HashGoal) then Result:=HashTable.BucketItem[Index]
   else
    begin
     index:=HashTable.BucketItem[index];
     while(HashTable.ChainEnable[Index]) and (HashTable.ChainHash[Index]<>HashGoal) do
     index:=HashTable.ChainItem[index];
     if(HashTable.ChainHash[Index]=HashGoal) then Result:=HashTable.ChainItem[Index]
     else Result:=0;
    end;
  end
 else Result:=0;
end;
function unifile_search_for_hash_table_count(HashTable:unifile_temporary_hash_table;
HashGoal:SizeUint):SizeUint;
var index:SizeUint;
begin
 if(HashTable.BucketCount=0) then exit(0);
 Index:=HashGoal mod HashTable.BucketCount+1; Result:=0;
 if(HashTable.BucketEnable[Index]) then
  begin
   if(HashTable.BucketHash[Index]=HashGoal) then inc(Result);
   index:=HashTable.BucketItem[index];
   while(HashTable.ChainEnable[Index]) do
    begin
     if(HashTable.ChainHash[Index]=HashGoal) then inc(Result);
     index:=HashTable.ChainItem[index];
    end;
  end
 else Result:=0;
end;
function unifile_search_for_hash_table_list(HashTable:unifile_temporary_hash_table;
HashGoal:SizeUint):unifile_index_list;
var index,listlength:SizeUint;
begin
 SetLength(Result,0); listlength:=0;
 if(HashTable.BucketCount=0) then exit(Result);
 Index:=HashGoal mod HashTable.BucketCount+1;
 if(HashTable.BucketEnable[Index]) then
  begin
   if(HashTable.BucketHash[Index]=HashGoal) then
    Begin
     inc(listlength);
     SetLength(Result,listlength);
     Result[listlength-1]:=HashTable.BucketItem[index];
    end;
   index:=HashTable.BucketItem[index];
   while(HashTable.ChainEnable[Index]) do
    begin
     if(HashTable.ChainHash[Index]=HashGoal) then
      Begin
       inc(listlength);
       SetLength(Result,listlength);
       Result[listlength-1]:=HashTable.ChainItem[index];
      end;
     index:=HashTable.ChainItem[index];
    end;
  end;
end;
function unifile_get_smartlinking(SectionHash,SymbolHash,RelocationHash:unifile_temporary_hash_table;
SymbolList:unifile_elf_object_file_parsed_symbol_table;RelocationList:unifile_temporary_relocation_list;
var SectionVaild:unifile_temporary_vaild_list;FirstHash:SizeUint):SizeUint;
var IndexList:unifile_index_list;
    IndexListLen:SizeUInt;
    Index1,Index2,Index3,i:SizeUint;
begin
 if(FirstHash=0) then exit(0);
 IndexList:=unifile_search_for_hash_table_list(SymbolHash,FirstHash);
 IndexListLen:=Length(IndexList); i:=1;
 while(i<=IndexListLen)do
  Begin
   if(SymbolList.SymbolSectionNameHash[IndexList[i-1]-1]<>0) Then break;
   inc(i);
  end;
 if(i>IndexListLen) then exit(0);
 Index1:=IndexList[i-1];
 Index3:=unifile_search_for_hash_table(SectionHash,SymbolList.SymbolSectionNameHash[Index1-1]);
 if(Index3=0) then exit(0);
 if(SectionVaild.Enable[Index3-1]) then exit(0);
 SectionVaild.Enable[Index3-1]:=true;
 Index2:=unifile_search_for_hash_table(RelocationHash,SymbolList.SymbolSectionNameHash[Index1-1]);
 if(Index2<>0) then
  begin
   i:=1;
   while(i<=RelocationList.Relocation[Index2-1].RelocationCount)do
    begin
     if(RelocationList.Relocation[Index2-1].RelocationSymbolHash[i-1]=0) then
      begin
       inc(i); continue;
      end;
     unifile_get_smartlinking(SectionHash,SymbolHash,RelocationHash,
     SymbolList,RelocationList,SectionVaild,
     RelocationList.Relocation[Index2-1].RelocationSymbolHash[i-1]);
     inc(i);
    end;
  end;
 Result:=Index1;
end;
function unifile_parsed_to_first_stage(var basefile:unifile_elf_object_file_parsed;
var basescript:unild_script;SmartLinking:boolean):unifile_linked_file_stage;
var i,j,k,m,n,a,b,c,d,e,f,g,h:SizeInt;
    attributedata:byte;
    InternalOffset,InternalOffsetAlterNative:SizeUint;
    tempbool:Boolean;
    tempstr:string;
    {For Not in File Sections}
    NotInFileBool:boolean;
    NoAttribute:boolean;
    {For Hash Table to the basefile}
    SectionHash,RelocationHash,SymbolHash:unifile_temporary_hash_table;
    SymbolClear:array of Byte;
    SectionVaild:unifile_temporary_vaild_list;
    RelocationList:unifile_temporary_relocation_list;
    {For Entry Hash}
    EntryHash:SizeUint;
    EntryIndex:byte=1;
    EntrySectionEstimatedIndex:SizeUint;
    {For Hash Table of the Vaild Section}
    AdjustHashTable:unifile_temporary_hash_table;
    AdjustVaildIndex:array of SizeUint;
    AdjustVaildCount:SizeUint;
    {For Checking the Vaild Symbols}
    VaildList:unifile_index_list;
    VaildLen,VaildLenInVaild,VaildLenVaild:SizeUInt;
    {For Section Content Pointer}
    ContentPointer:SizeUint;
    ContentStartIndex:SizeUint;
    ContentCount:SizeUint;
Label JumpToAutoSection;
begin
 {Initialize the First Stage}
 Result.Architecture:=basefile.Architecture; Result.ExternalNeeded:=false;
 Result.Bits:=basefile.Bits; Result.FileNameCount:=0;
 {Generate the Vaild Table}
 SectionVaild.ItemCount:=basefile.SectionCount;
 SetLength(SectionVaild.Enable,SectionVaild.ItemCount);
 {Generate the Section Hash Table for the base file}
 i:=1;
 SectionHash.BucketCount:=unifile_hash_table_bucket_count(basefile.SectionCount);
 SetLength(SectionHash.BucketItem,SectionHash.BucketCount+1);
 SetLength(SectionHash.BucketEnable,SectionHash.BucketCount+1);
 SetLength(SectionHash.BucketHash,SectionHash.BucketCount+1);
 SectionHash.ChainCount:=basefile.SectionCount;
 SetLength(SectionHash.ChainItem,SectionHash.ChainCount+1);
 SetLength(SectionHash.ChainEnable,SectionHash.ChainCount+1);
 SetLength(SectionHash.ChainHash,SectionHash.ChainCount+1);
 while(i<=basefile.SectionCount)do
  begin
   if(basefile.SectionNameHash[i-1]=0) then
    begin
     inc(i); continue;
    end;
   k:=basefile.SectionNameHash[i-1] mod SectionHash.BucketCount+1;
   if(SectionHash.BucketEnable[k]=false) then
    begin
     SectionHash.BucketEnable[k]:=true;
     SectionHash.BucketItem[k]:=i;
     SectionHash.BucketHash[k]:=basefile.SectionNameHash[i-1];
    end
   else
    begin
     k:=SectionHash.BucketItem[k];
     while(SectionHash.ChainEnable[k]) do k:=SectionHash.ChainItem[k];
     SectionHash.ChainEnable[k]:=true;
     SectionHash.ChainItem[k]:=i;
     SectionHash.ChainHash[k]:=basefile.SectionNameHash[i-1];
    end;
   inc(i);
  end;
 {Generate the Symbol Hash Table for the base file}
 i:=1;
 SymbolHash.BucketCount:=unifile_hash_table_bucket_count(basefile.SectionSymbolTable.SymbolCount);
 SetLength(SymbolHash.BucketItem,SymbolHash.BucketCount+1);
 SetLength(SymbolHash.BucketEnable,SymbolHash.BucketCount+1);
 SetLength(SymbolHash.BucketHash,SymbolHash.BucketCount+1);
 SymbolHash.ChainCount:=basefile.SectionSymbolTable.SymbolCount;
 SetLength(SymbolHash.ChainItem,SymbolHash.ChainCount+1);
 SetLength(SymbolHash.ChainEnable,SymbolHash.ChainCount+1);
 SetLength(SymbolHash.ChainHash,SymbolHash.ChainCount+1);
 SetLength(SymbolClear,basefile.SectionSymbolTable.SymbolCount);
 while(i<=basefile.SectionSymbolTable.SymbolCount)do
  begin
   if(basefile.SectionSymbolTable.SymbolSectionNameHash[i-1]=0)
   and(basefile.SectionSymbolTable.SymbolType[i-1]=0) then
    begin
     SymbolClear[i-1]:=1;
     inc(i); continue;
    end
   else if(basefile.SectionSymbolTable.SymbolType[i-1]=elf_symbol_type_file)
   and(basefile.SectionSymbolTable.SymbolBinding[i-1]=elf_symbol_bind_local) then
    begin
     if(basescript.EnableFileInformation) then
      begin
       inc(Result.FileNameCount);
       SetLength(Result.FileName,Result.FileNameCount);
       Result.FileName[Result.FileNameCount-1]:=basefile.SectionSymbolTable.SymbolName[i-1];
      end;
     SymbolClear[i-1]:=1;
     inc(i); continue;
    end;
   k:=basefile.SectionSymbolTable.SymbolNameHash[i-1] mod SymbolHash.BucketCount+1;
   if(SymbolHash.BucketEnable[k]=false) then
    begin
     SymbolHash.BucketEnable[k]:=true;
     SymbolHash.BucketItem[k]:=i;
     SymbolHash.BucketHash[k]:=basefile.SectionSymbolTable.SymbolNameHash[i-1];
    end
   else
    begin
     k:=SymbolHash.BucketItem[k];
     while(SymbolHash.ChainEnable[k]) do k:=SymbolHash.ChainItem[k];
     SymbolHash.ChainEnable[k]:=true;
     SymbolHash.ChainItem[k]:=i;
     SymbolHash.ChainHash[k]:=basefile.SectionSymbolTable.SymbolNameHash[i-1];
    end;
   inc(i);
  end;
 {Generate the Relocation Hash Table for the base file}
 i:=1;
 RelocationHash.BucketCount:=unifile_hash_table_bucket_count(basefile.SectionRelocationCount);
 SetLength(RelocationHash.BucketItem,RelocationHash.BucketCount+1);
 SetLength(RelocationHash.BucketEnable,RelocationHash.BucketCount+1);
 SetLength(RelocationHash.BucketHash,RelocationHash.BucketCount+1);
 RelocationHash.ChainCount:=basefile.SectionRelocationCount;
 SetLength(RelocationHash.ChainItem,RelocationHash.ChainCount+1);
 SetLength(RelocationHash.ChainEnable,RelocationHash.ChainCount+1);
 SetLength(RelocationHash.ChainHash,RelocationHash.ChainCount+1);
 while(i<=basefile.SectionRelocationCount)do
  begin
   if(basefile.SectionRelocation[i-1].RelocationSectionHash=0) then
    begin
     inc(i); continue;
    end;
   k:=basefile.SectionRelocation[i-1].RelocationSectionHash mod RelocationHash.BucketCount+1;
   if(RelocationHash.BucketEnable[k]=false) then
    begin
     RelocationHash.BucketEnable[k]:=true;
     RelocationHash.BucketItem[k]:=i;
     RelocationHash.BucketHash[k]:=basefile.SectionRelocation[i-1].RelocationSectionHash;
    end
   else
    begin
     k:=RelocationHash.BucketItem[k];
     while(RelocationHash.ChainEnable[k]) do k:=RelocationHash.ChainItem[k];
     RelocationHash.ChainEnable[k]:=true;
     RelocationHash.ChainItem[k]:=i;
     RelocationHash.ChainHash[k]:=basefile.SectionRelocation[i-1].RelocationSectionHash;
    end;
   inc(i);
  end;
 {Then Check the Vaild Content}
 EntryHash:=unihash_generate_value(basescript.EntryName,false);
 RelocationList.RelocationCount:=basefile.SectionRelocationCount;
 RelocationList.Relocation:=basefile.SectionRelocation;
 c:=unifile_get_smartlinking(SectionHash,SymbolHash,RelocationHash,basefile.SectionSymbolTable,
 RelocationList,SectionVaild,EntryHash);
 if(c=0) then
  begin
   writeln('ERROR:Entry '+basescript.EntryName+' not found.');
   readln;
   halt;
  end;
 Result.EntryName:=basescript.EntryName; Result.EntryHash:=EntryHash;
 Result.EntrySection:=basefile.SectionSymbolTable.SymbolSectionName[c-1];
 Result.EntrySectionHash:=basefile.SectionSymbolTable.SymbolSectionNameHash[c-1];
 Result.EntrySectionIndex:=0; c:=0;
 {If EntryAsStartSection Needs,Find the Real Section Index of the linker-generated section.}
 if(basescript.EntryAsStartOfSection) then
  begin
   while(i<=basescript.SectionCount)do
    begin
     j:=1;
     while(j<=basescript.Section[i-1].SectionItemCount)do
      begin
       if(basescript.Section[i-1].SectionItem[j-1].ItemClass=unild_item_filter) then
        begin
         while(k<=basescript.Section[i-1].SectionItem[j-1].ItemCount)do
          begin
           if(unild_script_match_mask(Result.EntrySection,
           basescript.Section[i-1].SectionItem[j-1].ItemFilter[k-1])) then break;
           inc(k);
          end;
         if(k<=basescript.Section[i-1].SectionItem[j-1].ItemCount) then break;
        end;
       inc(j);
      end;
     if(j<=basescript.Section[i-1].SectionItemCount) then break;
     inc(i);
    end;
   EntrySectionEstimatedIndex:=i;
  end;
 {Then Generate the First stage file}
 Result.Architecture:=basefile.Architecture; Result.Bits:=basefile.Bits;
 Result.SectionCount:=basescript.SectionCount;
 SetLength(Result.SectionName,basescript.SectionCount);
 SetLength(Result.SectionNameHash,basescript.SectionCount);
 SetLength(Result.SectionVaild,basescript.SectionCount);
 SetLength(Result.SectionAddress,basescript.SectionCount);
 SetLength(Result.SectionAlign,basescript.SectionCount);
 SetLength(Result.SectionAttribute,basescript.SectionCount);
 SetLength(Result.SectionContentInfo,basescript.SectionCount);
 SetLength(Result.SectionContent,basefile.SectionCount);
 i:=1; ContentPointer:=0;
 while(i<=basescript.SectionCount)do
  begin
   InternalOffsetAlternative:=0;
   Result.SectionName[i-1]:=basescript.Section[i-1].SectionName;
   Result.SectionNameHash[i-1]:=unihash_generate_value(Result.SectionName[i-1],true);
   InternalOffsetAlterNative:=0; j:=1; AttributeData:=0; NoAttribute:=false;
   while(j<=basescript.Section[i-1].SectionAttributeCount)do
    begin
     tempstr:=basescript.Section[i-1].SectionAttribute[j-1];
     if(tempstr='write') or(tempstr='w') then
     AttributeData:=AttributeData or unifile_attribute_write
     else if(tempstr='alloc') or(tempstr='a') or(tempstr='read') or(tempstr='r') then
     AttributeData:=AttributeData or unifile_attribute_alloc
     else if(tempstr='execute') or(tempstr='e') or(tempstr='x') then
     AttributeData:=AttributeData or unifile_attribute_execute
     else if(tempstr='info') or(tempstr='i') or(tempstr='information') then
     AttributeData:=AttributeData or unifile_attribute_information
     else if(tempstr='nobits') or(tempstr='nobit') or(tempstr='notinfile')then
     AttributeData:=AttributeData or unifile_attribute_not_in_file
     else if(tempstr='tls') or(tempstr='threadlocalstorage')then
     AttributeData:=AttributeData or unifile_attribute_thread_local_storage
     else if(tempstr='note') or(tempstr='n')then
     AttributeData:=AttributeData or unifile_attribute_note
     else if(tempstr='noattribute') then
      begin
       AttributeData:=0; NoAttribute:=true; break;
      end;
     inc(j);
    end;
   Result.SectionAddress[i-1]:=basescript.Section[i-1].SectionAddress;
   if(basescript.Section[i-1].SectionAlign<>0) then
   Result.SectionAlign[i-1]:=basescript.Section[i-1].SectionAlign
   else
    begin
     if(Result.Bits=32) then Result.SectionAlign[i-1]:=4 else Result.SectionAlign[i-1]:=8;
    end;
   Result.SectionName[i-1]:=basescript.Section[i-1].SectionName;
   Result.SectionVaild[i-1]:=true;
   Result.SectionContentInfo[i-1].ContentStartIndex:=ContentPointer+1;
   ContentStartIndex:=ContentPointer+1;
   NotInFileBool:=true; k:=1; InternalOffset:=0;
   while(k<=basescript.Section[i-1].SectionItemCount)do
    begin
     if(basescript.Section[i-1].SectionItem[k-1].ItemClass=unild_item_offset) then
      begin
       InternalOffset:=basescript.Section[i-1].SectionItem[k-1].ItemOffset;
       InternalOffsetAlternative:=InternalOffset;
      end
     else if(basescript.Section[i-1].SectionItem[k-1].ItemClass=unild_item_relativeoffset) then
      begin
       inc(InternalOffset,basescript.Section[i-1].SectionItem[k-1].ItemRelativeOffset);
       InternalOffsetAlternative:=InternalOffset;
      end
     else if(basescript.Section[i-1].SectionItem[k-1].ItemClass=unild_item_align) then
      begin
       InternalOffset:=unifile_align(InternalOffset,basescript.Section[i-1].SectionItem[k-1].ItemAlign);
       InternalOffsetAlternative:=InternalOffset;
      end
     else
      begin
       InternalOffsetAlternative:=InternalOffset;
       j:=1; n:=1; m:=basescript.Section[i-1].SectionItem[k-1].ItemCount;
       while(n<=basefile.SectionCount)do
        begin
         if(basefile.SectionUsed[n-1]) then
          begin
           inc(n); continue;
          end
         else if(SmartLinking) and (basescript.Section[i-1].SectionItem[k-1].ItemKeep=false) and
         (SectionVaild.Enable[n-1]=false) then
          begin
           inc(n); continue;
          end
         else if(basescript.Section[i-1].SectionItem[k-1].ItemSmart)
         and(SectionVaild.Enable[n-1]=false) then
          begin
           inc(n); continue;
          end;
         j:=1;
         while(j<=m)do
          begin
           if(unild_script_match_mask(basefile.SectionName[n-1],
           basescript.Section[i-1].SectionItem[k-1].ItemFilter[j-1])) then break;
           inc(j);
          end;
         if(j<=m) then
          begin
           if(basefile.SectionAlign[n-1]<Result.SectionAlign[i-1])and(basefile.SectionAlign[n-1]>0) then
           Result.SectionAlign[i-1]:=basefile.SectionAlign[n-1];
           if(NoAttribute=false) then
            begin
             if(basefile.SectionFlag[n-1] and elf_section_flag_write=elf_section_flag_write) then
             AttributeData:=AttributeData or unifile_attribute_write;
             if(basefile.SectionFlag[n-1] and elf_section_flag_alloc=elf_section_flag_alloc) then
             AttributeData:=AttributeData or unifile_attribute_alloc;
             if(basefile.SectionFlag[n-1] and elf_section_flag_executable=elf_section_flag_executable) then
             AttributeData:=AttributeData or unifile_attribute_execute;
             if(basefile.SectionFlag[n-1] and elf_section_flag_info_link=elf_section_flag_info_link) then
             AttributeData:=AttributeData or unifile_attribute_information;
             if(basefile.SectionFlag[n-1] and elf_section_flag_tls=elf_section_flag_tls)
             then AttributeData:=AttributeData or unifile_attribute_thread_local_storage;
            end;
           if(basefile.SectionContent[n-1]<>nil) and (NotInFileBool) then NotInFileBool:=false;
           if(basescript.EntryAsStartOfSection) then
            begin
             inc(ContentPointer);
             if(Result.EntrySectionIndex=0) and (basefile.SectionNameHash[n-1]=Result.EntrySectionHash)
             and(EntrySectionEstimatedIndex=i) then
              begin
               Result.EntrySectionIndex:=i; Result.EntryOffset:=InternalOffsetAlternative;
               Result.SectionContent[ContentStartIndex-1].Name:=basefile.SectionName[n-1];
               Result.SectionContent[ContentStartIndex-1].NameHash:=basefile.SectionNameHash[n-1];
               Result.SectionContent[ContentStartIndex-1].Index:=i;
               Result.SectionContent[ContentStartIndex-1].Offset:=InternalOffsetAlternative;
               Result.SectionContent[ContentStartIndex-1].Size:=basefile.SectionSize[n-1];
               if(AttributeData and unifile_attribute_not_in_file=0) or
               (basefile.SectionType[n-1]<>elf_section_type_nobit) then
               Result.SectionContent[ContentStartIndex-1].Memory:=basefile.SectionContent[n-1];
               a:=ContentStartIndex+1;
               while(a<=ContentPointer)do
                begin
                 inc(Result.SectionContent[a-1].Offset,basefile.SectionSize[n-1]);
                 inc(a);
                end;
               EntryIndex:=0;
              end
             else if(EntrySectionEstimatedIndex=i) then
              begin
               Result.SectionContent[ContentPointer+EntryIndex-1].Name:=basefile.SectionName[n-1];
               Result.SectionContent[ContentPointer+EntryIndex-1].NameHash:=basefile.SectionNameHash[n-1];
               Result.SectionContent[ContentPointer+EntryIndex-1].Index:=i;
               Result.SectionContent[ContentPointer+EntryIndex-1].Offset:=InternalOffset;
               Result.SectionContent[ContentPointer+EntryIndex-1].Size:=basefile.SectionSize[n-1];
               if(AttributeData and unifile_attribute_not_in_file=0) and
               (basefile.SectionType[n-1]<>elf_section_type_nobit) then
                begin
                 Result.SectionContent[ContentPointer+EntryIndex-1].Memory:=
                 basefile.SectionContent[n-1];
                end;
              end
             else
              begin
               Result.SectionContent[ContentPointer-1].Name:=basefile.SectionName[n-1];
               Result.SectionContent[ContentPointer-1].NameHash:=basefile.SectionNameHash[n-1];
               Result.SectionContent[ContentPointer-1].Index:=i;
               Result.SectionContent[ContentPointer-1].Offset:=InternalOffset;
               Result.SectionContent[ContentPointer-1].Size:=basefile.SectionSize[n-1];
               if(AttributeData and unifile_attribute_not_in_file=0) and
               (basefile.SectionType[n-1]<>elf_section_type_nobit) then
                begin
                 Result.SectionContent[ContentPointer-1].Memory:=basefile.SectionContent[n-1];
                end;
              end;
            end
           else
            begin
             inc(ContentPointer);
             Result.SectionContent[ContentPointer-1].Name:=basefile.SectionName[n-1];
             Result.SectionContent[ContentPointer-1].NameHash:=basefile.SectionNameHash[n-1];
             Result.SectionContent[ContentPointer-1].Index:=i;
             Result.SectionContent[ContentPointer-1].Offset:=InternalOffset;
             Result.SectionContent[ContentPointer-1].Size:=basefile.SectionSize[n-1];
             if(AttributeData and unifile_attribute_not_in_file=0) and
             (basefile.SectionType[n-1]<>elf_section_type_nobit) then
              begin
               Result.SectionContent[ContentPointer-1].Memory:=basefile.SectionContent[n-1];
              end;
             if(Result.EntrySectionIndex=0) and
             (basefile.SectionNameHash[n-1]=Result.EntrySectionHash) then
              begin
               Result.EntrySectionIndex:=i; Result.EntryOffset:=InternalOffset;
              end;
            end;
           inc(InternalOffset,basefile.SectionSize[n-1]);
           basefile.SectionUsed[n-1]:=true;
          end;
         inc(n);
        end;
      end;
     inc(k);
    end;
   if(NotInFileBool) then AttributeData:=AttributeData or unifile_attribute_not_in_file;
   Result.SectionAttribute[i-1]:=AttributeData;
   if(Result.SectionContentInfo[i-1].ContentStartIndex>ContentPointer)or(InternalOffset=0)then
    begin
     Result.SectionContentInfo[i-1].ContentStartIndex:=0;
     Result.SectionVaild[i-1]:=false;
    end
   else
    begin
     Result.SectionContentInfo[i-1].ContentCount:=ContentPointer-
     Result.SectionContentInfo[i-1].ContentStartIndex+1;
     Result.SectionContentInfo[i-1].ContentSize:=InternalOffset;
    end;
   inc(i);
  end;
 {Then Generate the Content Assistance}
 i:=1; ContentCount:=ContentPointer;
 Result.SectionContentAssist.BucketCount:=unifile_hash_table_bucket_count(ContentCount);
 SetLength(Result.SectionContentAssist.BucketEnable,Result.SectionContentAssist.BucketCount+1);
 SetLength(Result.SectionContentAssist.BucketHash,Result.SectionContentAssist.BucketCount+1);
 SetLength(Result.SectionContentAssist.BucketItem,Result.SectionContentAssist.BucketCount+1);
 Result.SectionContentAssist.ChainCount:=ContentCount;
 SetLength(Result.SectionContentAssist.ChainEnable,Result.SectionContentAssist.ChainCount+1);
 SetLength(Result.SectionContentAssist.ChainHash,Result.SectionContentAssist.ChainCount+1);
 SetLength(Result.SectionContentAssist.ChainItem,Result.SectionContentAssist.ChainCount+1);
 while(i<=ContentCount)do
  begin
   j:=Result.SectionContent[i-1].NameHash mod Result.SectionContentAssist.BucketCount+1;
   if(Result.SectionContentAssist.BucketEnable[j]=false) then
    begin
     Result.SectionContentAssist.BucketEnable[j]:=true;
     Result.SectionContentAssist.BucketItem[j]:=i;
     Result.SectionContentAssist.BucketHash[j]:=Result.SectionContent[i-1].NameHash;
    end
   else
    begin
     j:=Result.SectionContentAssist.BucketItem[j];
     while(Result.SectionContentAssist.ChainEnable[j])do
     j:=Result.SectionContentAssist.ChainItem[j];
     Result.SectionContentAssist.ChainEnable[j]:=true;
     Result.SectionContentAssist.ChainItem[j]:=i;
     Result.SectionContentAssist.ChainHash[j]:=Result.SectionContent[i-1].NameHash;
    end;
   inc(i);
  end;
 {Then Generate the Symbol Table}
 i:=1; k:=0;
 Result.SymbolTable.SymbolCount:=0;
 SetLength(Result.SymbolTable.SymbolName,
 basefile.SectionSymbolTable.SymbolCount+basescript.SectionCountExtra);
 SetLength(Result.SymbolTable.SymbolNameHash,
 basefile.SectionSymbolTable.SymbolCount+basescript.SectionCountExtra);
 SetLength(Result.SymbolTable.SymbolSectionName,
 basefile.SectionSymbolTable.SymbolCount+basescript.SectionCountExtra);
 SetLength(Result.SymbolTable.SymbolSectionNameHash,
 basefile.SectionSymbolTable.SymbolCount+basescript.SectionCountExtra);
 SetLength(Result.SymbolTable.SymbolBinding,
 basefile.SectionSymbolTable.SymbolCount+basescript.SectionCountExtra);
 SetLength(Result.SymbolTable.SymbolSize,
 basefile.SectionSymbolTable.SymbolCount+basescript.SectionCountExtra);
 SetLength(Result.SymbolTable.SymbolValue,
 basefile.SectionSymbolTable.SymbolCount+basescript.SectionCountExtra);
 SetLength(Result.SymbolTable.SymbolType,
 basefile.SectionSymbolTable.SymbolCount+basescript.SectionCountExtra);
 SetLength(Result.SymbolTable.SymbolVisibility,
 basefile.SectionSymbolTable.SymbolCount+basescript.SectionCountExtra);
 Result.DynamicSymbolCount:=0; Result.SymbolCount:=0;
 if(basescript.SectionCountExtra>0) then
  begin
   if(basescript.GlobalOffsetTableSectionEnable) then
    begin
     inc(k);
     Result.SymbolTable.SymbolName[k-1]:=basescript.GlobalOffsetTableAlias;
     Result.SymbolTable.SymbolNameHash[k-1]:=
     unihash_generate_value(basescript.GlobalOffsetTableAlias,false);
     Result.SymbolTable.SymbolSectionName[k-1]:='.got';
     Result.SymbolTable.SymbolSectionNameHash[k-1]:=unihash_generate_value('.got',true);
     Result.SymbolTable.SymbolBinding[k-1]:=elf_symbol_bind_local;
     Result.SymbolTable.SymbolSize[k-1]:=0;
     Result.SymbolTable.SymbolValue[k-1]:=0;
     Result.SymbolTable.SymbolType[k-1]:=elf_symbol_type_object;
     Result.SymbolTable.SymbolVisibility[k-1]:=elf_symbol_visibility_default;
    end;
   if(basescript.DynamicSectionEnable) then
    begin
     inc(k);
     Result.SymbolTable.SymbolName[k-1]:=basescript.DynamicSectionAlias;
     Result.SymbolTable.SymbolNameHash[k-1]:=
     unihash_generate_value(basescript.DynamicSectionAlias,false);
     Result.SymbolTable.SymbolSectionName[k-1]:='.dynamic';
     Result.SymbolTable.SymbolSectionNameHash[k-1]:=unihash_generate_value('.dynamic',true);
     Result.SymbolTable.SymbolBinding[k-1]:=elf_symbol_bind_local;
     Result.SymbolTable.SymbolSize[k-1]:=0;
     Result.SymbolTable.SymbolValue[k-1]:=0;
     Result.SymbolTable.SymbolType[k-1]:=elf_symbol_type_object;
     Result.SymbolTable.SymbolVisibility[k-1]:=elf_symbol_visibility_default;
    end;
  end;
 while(i<=basefile.SectionSymbolTable.SymbolCount)do
  begin
   if(basefile.SectionSymbolTable.SymbolType[i-1]=0)
   and(basefile.SectionSymbolTable.SymbolSectionNameHash[i-1]=0)then
    begin
     inc(i); continue;
    end
   else if(SymbolClear[i-1]=1) then
    begin
     inc(i); continue;
    end;
   if(SymbolClear[i-1]=0) then
    begin
     VaildList:=unifile_search_for_hash_table_list(SymbolHash,
     basefile.SectionSymbolTable.SymbolNameHash[i-1]);
     VaildLen:=Length(VaildList);
     if(VaildLen>1) Then
      begin
       j:=1;
       VaildLenInVaild:=0; VaildLenVaild:=0;
       while(j<=VaildLen)do
        begin
         if(basefile.SectionSymbolTable.SymbolSectionNameHash[VaildList[j-1]-1]=0) Then
         inc(VaildLenInVaild) else inc(VaildLenVaild);
         inc(j);
        end;
      if(VaildLenVaild>1) Then
       Begin
        WriteLn('ERROR:Multiple Definition of the Symbol ',basefile.SectionSymbolTable.SymbolName[i-1]);
        ReadLn;
        Halt;
       end
      else if(VaildLenVaild=1) Then
       Begin
        j:=1;
        while(j<=VaildLen)do
         begin
          if(basefile.SectionSymbolTable.SymbolSectionNameHash[VaildList[j-1]-1]=0) Then
          SymbolClear[VaildList[j-1]-1]:=1 else SymbolClear[VaildList[j-1]-1]:=2;
          inc(j);
         end;
       end;
      end;
    end;
   if(basefile.SectionSymbolTable.SymbolSectionNameHash[i-1]=0)
   or(basefile.SectionSymbolTable.SymbolBinding[i-1]=elf_symbol_bind_global) then
   inc(Result.DynamicSymbolCount);
   inc(k);
   Result.SymbolTable.SymbolName[k-1]:=basefile.SectionSymbolTable.SymbolName[i-1];
   Result.SymbolTable.SymbolNameHash[k-1]:=basefile.SectionSymbolTable.SymbolNameHash[i-1];
   Result.SymbolTable.SymbolSectionName[k-1]:=basefile.SectionSymbolTable.SymbolSectionName[i-1];
   Result.SymbolTable.SymbolSectionNameHash[k-1]:=basefile.SectionSymbolTable.SymbolSectionNameHash[i-1];
   Result.SymbolTable.SymbolBinding[k-1]:=basefile.SectionSymbolTable.SymbolBinding[i-1];
   Result.SymbolTable.SymbolSize[k-1]:=basefile.SectionSymbolTable.SymbolSize[i-1];
   Result.SymbolTable.SymbolValue[k-1]:=basefile.SectionSymbolTable.SymbolValue[i-1];
   Result.SymbolTable.SymbolType[k-1]:=basefile.SectionSymbolTable.SymbolType[i-1];
   Result.SymbolTable.SymbolVisibility[k-1]:=basefile.SectionSymbolTable.SymbolVisibility[i-1];
   inc(i);
  end;
 Result.SymbolTable.SymbolCount:=k; Result.SymbolCount:=k;
 {Then Generate the Symbol Assistance Table}
 Result.SymbolTableAssist.BucketCount:=unifile_hash_table_bucket_count(Result.SymbolTable.SymbolCount);
 SetLength(Result.SymbolTableAssist.BucketItem,Result.SymbolTableAssist.BucketCount+1);
 SetLength(Result.SymbolTableAssist.BucketHash,Result.SymbolTableAssist.BucketCount+1);
 SetLength(Result.SymbolTableAssist.BucketEnable,Result.SymbolTableAssist.BucketCount+1);
 Result.SymbolTableAssist.ChainCount:=Result.SymbolTable.SymbolCount;
 SetLength(Result.SymbolTableAssist.ChainItem,Result.SymbolTableAssist.ChainCount+1);
 SetLength(Result.SymbolTableAssist.ChainHash,Result.SymbolTableAssist.ChainCount+1);
 SetLength(Result.SymbolTableAssist.ChainEnable,Result.SymbolTableAssist.ChainCount+1);
 i:=1;
 while(i<=Result.SymbolTable.SymbolCount)do
  begin
   j:=Result.SymbolTable.SymbolNameHash[i-1] mod Result.SymbolTableAssist.BucketCount+1;
   if(Result.SymbolTableAssist.BucketEnable[j]=false) then
    begin
     Result.SymbolTableAssist.BucketItem[j]:=i;
     Result.SymbolTableAssist.BucketEnable[j]:=true;
     Result.SymbolTableAssist.BucketHash[j]:=Result.SymbolTable.SymbolNameHash[i-1];
    end
   else
    begin
     j:=Result.SymbolTableAssist.BucketItem[j];
     while(Result.SymbolTableAssist.ChainEnable[j]) do j:=Result.SymbolTableAssist.ChainItem[j];
     Result.SymbolTableAssist.ChainItem[j]:=i;
     Result.SymbolTableAssist.ChainEnable[j]:=true;
     Result.SymbolTableAssist.ChainHash[j]:=Result.SymbolTable.SymbolNameHash[i-1];
    end;
   inc(i);
  end;
 {Now Generate the Adjust Table}
 Result.AdjustTable.Count:=0;
 i:=1; j:=0;
 while(i<=basefile.SectionRelocationCount)do
  begin
   j:=j+basefile.SectionRelocation[i-1].RelocationCount; inc(i);
  end;
 Result.AdjustTable.Count:=0;
 SetLength(Result.AdjustTable.OriginalSectionIndex,j);
 SetLength(Result.AdjustTable.OriginalOffset,j);
 SetLength(Result.AdjustTable.GoalSectionIndex,j);
 SetLength(Result.AdjustTable.GoalOffset,j);
 SetLength(Result.AdjustTable.AdjustAddend,j);
 SetLength(Result.AdjustTable.AdjustFunc,j);
 SetLength(Result.AdjustTable.AdjustType,j);
 SetLength(Result.AdjustTable.AdjustSize,j);
 SetLength(Result.AdjustTable.AdjustName,j);
 SetLength(Result.AdjustTable.AdjustHash,j);
 if(basefile.Architecture=elf_machine_riscv) then
 SetLength(Result.AdjustTable.AdjustRiscVType,j);
 if(basescript.elfclass=unild_class_relocatable) and
 (basescript.IsEFIFile=false) and (basescript.IsUntypedBinary=false) then
 SetLength(AdjustVaildIndex,j);
 AdjustVaildCount:=0;
 i:=1; n:=1;
 while(i<=basefile.SectionRelocationCount)do
  begin
   j:=1; k:=Result.SectionCount; m:=0;
   m:=unifile_search_for_hash_table(Result.SectionContentAssist,
   basefile.SectionRelocation[i-1].RelocationSectionHash);
   if(m=0) then
    begin
     inc(i); continue;
    end;
   j:=Result.SectionContent[m-1].Index;
   a:=1; b:=basefile.SectionRelocation[i-1].RelocationCount;
   while(a<=b)do
    begin
     Result.AdjustTable.OriginalSectionIndex[n-1]:=j;
     Result.AdjustTable.OriginalOffset[n-1]:=
     Result.SectionContent[m-1].Offset+basefile.SectionRelocation[i-1].RelocationOffset[a-1];
     c:=unifile_search_for_hash_table(Result.SymbolTableAssist,
     basefile.SectionRelocation[i-1].RelocationSymbolHash[a-1]);
     if(c=0) then
      begin
       inc(a); continue;
      end;
     d:=0; f:=0;
     if(basescript.SectionCountExtra>0) and
     (((basescript.DynamicSectionEnable) and (c=basescript.DynamicSectionIndex)) or
     ((basescript.GlobalOffsetTableSectionEnable) and (c=basescript.GlobalOffsetTableSectionIndex))) then
      begin
       goto JumpToAutoSection;
      end;
     h:=unifile_search_for_hash_table_count(Result.SymbolTableAssist,
     basefile.SectionRelocation[i-1].RelocationSymbolHash[a-1]);
     if(h>1) then
      begin
       writeln('ERROR:Multiple Definition of '+
       basefile.SectionRelocation[i-1].RelocationSymbol[a-1]+',cannot be linked.');
       readln;
       halt;
      end;
     e:=Result.SectionCount;
     f:=unifile_search_for_hash_table(Result.SectionContentAssist,
     Result.SymbolTable.SymbolSectionNameHash[c-1]);
     if(f<>0) then d:=Result.SectionContent[f-1].Index;
     JumpToAutoSection:
     if(basescript.SectionCountExtra>0) then
      begin
       if(basescript.DynamicSectionEnable) and (c=basescript.DynamicSectionIndex) then
       d:=e+basescript.DynamicSectionIndex
       else if(basescript.GlobalOffsetTableSectionEnable)
       and (c=basescript.GlobalOffsetTableSectionIndex) then
       d:=e+basescript.GlobalOffsetTableSectionIndex;
      end;
     Result.AdjustTable.GoalSectionIndex[n-1]:=d;
     if(f<>0) then
     Result.AdjustTable.GoalOffset[n-1]:=
     Result.SectionContent[f-1].Offset+Result.SymbolTable.SymbolValue[c-1]
     else Result.AdjustTable.GoalOffset[n-1]:=0;
     if(Result.SymbolTable.SymbolType[c-1]=elf_symbol_type_function) then
     Result.AdjustTable.AdjustFunc[n-1]:=true;
     Result.AdjustTable.AdjustName[n-1]:=Result.SymbolTable.SymbolName[c-1];
     Result.AdjustTable.AdjustHash[n-1]:=Result.SymbolTable.SymbolNameHash[c-1];
     Result.AdjustTable.AdjustType[n-1]:=basefile.SectionRelocation[i-1].RelocationType[a-1];
     Result.AdjustTable.AdjustSize[n-1]:=Result.SymbolTable.SymbolSize[c-1];
     Result.AdjustTable.AdjustAddend[n-1]:=basefile.SectionRelocation[i-1].RelocationAddend[a-1];
     if(basefile.Architecture=elf_machine_riscv) and (n>1) then
      begin
       g:=n-1;
       if((Result.AdjustTable.AdjustType[g-1]=elf_reloc_riscv_got_high_20bit)
       or(Result.AdjustTable.AdjustType[g-1]=elf_reloc_riscv_pc_relative_high_20bit))
       and((Result.AdjustTable.AdjustType[n-1]=elf_reloc_riscv_pc_relative_low_12bit)
       or(Result.AdjustTable.AdjustType[n-1]=elf_reloc_riscv_pc_relative_low_12bit_store)) then
        begin
         if(Result.AdjustTable.AdjustHash[n-1]<>Result.AdjustTable.AdjustHash[g-1]) then
          begin
           Result.AdjustTable.GoalSectionIndex[n-1]:=Result.AdjustTable.GoalSectionIndex[g-1];
           Result.AdjustTable.GoalOffset[n-1]:=Result.AdjustTable.GoalOffset[g-1];
           Result.AdjustTable.AdjustName[n-1]:=Result.AdjustTable.AdjustName[g-1];
           Result.AdjustTable.AdjustHash[n-1]:=Result.AdjustTable.AdjustHash[g-1];
           Result.AdjustTable.AdjustFunc[n-1]:=Result.AdjustTable.AdjustFunc[g-1];
          end;
         inc(Result.AdjustTable.AdjustAddend[n-1],Result.AdjustTable.OriginalOffset[n-1]-
         Result.AdjustTable.OriginalOffset[g-1]);
         if(Result.AdjustTable.AdjustType[g-1]=elf_reloc_riscv_got_high_20bit) then
         Result.AdjustTable.AdjustRiscVType[n-1]:=unifile_riscv_got;
        end;
      end;
     if(basescript.elfclass=unild_class_relocatable) and (basescript.IsEFIFile=false)
     and(basescript.IsUntypedBinary=false) and (d=0) then
      begin
       inc(AdjustVaildCount);
       AdjustVaildIndex[AdjustVaildCount-1]:=n;
      end
     else if(basescript.NoExternalLibrary) and (d=0) then
      begin
       writeln('ERROR:'+basefile.SectionRelocation[i-1].RelocationSymbol[a-1]+' not found.');
       writeln('Check all the object files which comprises this symbol.');
       readln;
       halt;
      end
     else if(basescript.IsEFIFile=false) and (basescript.IsUntypedBinary=false) and (d=0) then
     Result.ExternalNeeded:=true;
     inc(Result.AdjustTable.Count);
     inc(n); inc(a);
    end;
   inc(i);
  end;
 {Generate the Adjust Hash Table}
 Result.AdjustVaildCount:=0;
 if(basescript.elfclass=unild_class_relocatable) and (basescript.IsEFIFile=false)
 and(basescript.IsUntypedBinary=false) then
  begin
   i:=1;
   SetLength(Result.AdjustVaildIndex,AdjustVaildCount);
   SetLength(Result.AdjustVaildReflect,AdjustVaildCount);
   AdjustHashTable.BucketCount:=AdjustVaildCount*8 div 7;
   SetLength(AdjustHashTable.BucketEnable,AdjustHashTable.BucketCount+1);
   SetLength(AdjustHashTable.BucketItem,AdjustHashTable.BucketCount+1);
   SetLength(AdjustHashTable.BucketHash,AdjustHashTable.BucketCount+1);
   AdjustHashTable.ChainCount:=AdjustVaildCount;
   SetLength(AdjustHashTable.ChainEnable,AdjustHashTable.ChainCount+1);
   SetLength(AdjustHashTable.ChainItem,AdjustHashTable.ChainCount+1);
   SetLength(AdjustHashTable.ChainHash,AdjustHashTable.ChainCount+1);
   while(i<=AdjustVaildCount)do
    begin
     j:=Result.AdjustTable.AdjustHash[AdjustVaildIndex[i-1]-1] mod AdjustHashTable.BucketCount+1;
     tempbool:=false;
     if(AdjustHashTable.BucketEnable[j]=false) then
      begin
       AdjustHashTable.BucketEnable[j]:=true;
       AdjustHashTable.BucketHash[j]:=Result.AdjustTable.AdjustHash[AdjustVaildIndex[i-1]-1];
       AdjustHashTable.BucketItem[j]:=i;
      end
     else
      begin
       if(AdjustHashTable.BucketHash[j]=Result.AdjustTable.AdjustHash[AdjustVaildIndex[i-1]-1]) then
       tempbool:=true;
       j:=AdjustHashTable.BucketItem[j];
       while(AdjustHashTable.ChainEnable[j])do
        begin
         if(AdjustHashTable.ChainHash[j]=Result.AdjustTable.AdjustHash[AdjustVaildIndex[i-1]-1]) then
         tempbool:=true;
         j:=AdjustHashTable.ChainItem[j];
        end;
       AdjustHashTable.ChainEnable[j]:=true;
       AdjustHashTable.ChainHash[j]:=Result.AdjustTable.AdjustHash[AdjustVaildIndex[i-1]-1];
       AdjustHashTable.ChainItem[j]:=i;
      end;
     if(tempbool=false) then
      begin
       inc(Result.AdjustVaildCount);
       Result.AdjustVaildIndex[Result.AdjustVaildCount-1]:=AdjustVaildIndex[i-1];
       tempbool:=false;
      end;
     Result.AdjustVaildReflect[i-1]:=Result.AdjustVaildCount;
     inc(i);
    end;
  end;
 basefile.SectionCount:=0;
end;
function unifile_calculate_comple(value:SizeInt;bit:byte;ValueSigned:boolean=true):SizeUint;
var mask:SizeUint;
    i:byte;
    tempnum:SizeUint;
begin
 if(value>=0) then exit(value);
 if(ValueSigned) then
  begin
   mask:=0;
   for i:=1 to bit-1 do mask:=mask shl 1+1;
   tempnum:=-value;
   tempnum:=(not (tempnum and mask)) and mask+1;
   if(tempnum>mask) then tempnum:=tempnum and mask;
   if(bit=64) then tempnum:=SizeUint($8000000000000000)+tempnum
   else if(bit=32) then tempnum:=SizeUint($80000000)+tempnum
   else tempnum:=SizeUInt(1) shl (bit-1)+tempnum;
   Result:=tempnum;
  end
 else exit(SizeUint(-value));
end;
function unifile_check_relocation(RelocationArchitecture:word;RelocationBits:byte;
RelocationType:SizeUint;GoalBool:boolean=true):unifile_check_result;
begin
 Result.GotBool:=false; Result.NeedRelocationBits:=0;
 case RelocationArchitecture of
 elf_machine_386:
  begin
   case RelocationType of
   elf_reloc_i386_32bit:Result.NeedRelocationBits:=32;
   elf_reloc_i386_16bit:Result.NeedRelocationBits:=16;
   elf_reloc_i386_got32,elf_reloc_i386_got_offset:Result.GotBool:=true;
   elf_reloc_i386_got_relaxable:Result.GotBool:=GoalBool;
   end;
  end;
 elf_machine_arm:
  begin
   case RelocationType of
   elf_reloc_arm_absolute_32bit:Result.NeedRelocationBits:=32;
   elf_reloc_arm_absolute_16bit:Result.NeedRelocationBits:=16;
   elf_reloc_arm_got_absolute,elf_reloc_arm_got_pc_relative,elf_reloc_arm_got_relative_to_got_origin,
   elf_reloc_arm_got_offset_12bit:Result.GotBool:=true;
   end;
  end;
 elf_machine_x86_64:
  begin
   case RelocationType of
   elf_reloc_x86_64_64bit:Result.NeedRelocationBits:=64;
   elf_reloc_x86_64_32bit,elf_reloc_x86_64_32bit_sign:Result.NeedRelocationBits:=32;
   elf_reloc_x86_64_16bit:Result.NeedRelocationBits:=16;
   elf_reloc_x86_64_got_32bit,elf_reloc_x86_64_got_offset64,elf_reloc_x86_64_got_pc32,
   elf_reloc_x86_64_got64,elf_reloc_x86_64_got_pc64,
   elf_reloc_x86_64_got_pc_relative,
   elf_reloc_x86_64_got_plt64,elf_reloc_x86_64_plt_offset64:Result.GotBool:=true;
   elf_reloc_x86_64_pc_relative_offset_got,
   elf_reloc_x86_64_got_pc_relative_without_rex,elf_reloc_x86_64_got_pc_relative_with_rex:
   Result.GotBool:=not GoalBool;
   end;
  end;
 elf_machine_aarch64:
  begin
   case RelocationType of
   elf_reloc_aarch64_32bit_absolute,elf_reloc_aarch64_absolute_32bit:Result.NeedRelocationBits:=32;
   elf_reloc_aarch64_absolute_64bit:Result.NeedRelocationBits:=64;
   elf_reloc_aarch64_absolute_16bit:Result.NeedRelocationBits:=16;
   elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit15_0,elf_reloc_aarch64_got_rel_offset_movk_imm_bit15_0,
   elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit31_16,
   elf_reloc_aarch64_got_rel_offset_movk_imm_bit31_16,
   elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit47_32,
   elf_reloc_aarch64_got_rel_offset_movk_imm_bit47_32,
   elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit63_48,
   elf_reloc_aarch64_pc_relative_got_offset32,
   elf_reloc_aarch64_pc_rel_got_offset,
   elf_reloc_aarch64_got_rel_offset_ld_st_imm_bit14_3,
   elf_reloc_aarch64_page_rel_adrp_bit32_12,
   elf_reloc_aarch64_dir_got_offset_ld_st_imm_bit11_3,
   elf_reloc_aarch64_got_page_rel_got_offset_ld_st_bit14_3,
   elf_reloc_aarch64_pc_relative_adr_imm_bit20_0,
   elf_reloc_aarch64_page_relative_adr_imm_bit32_12,
   elf_reloc_aarch64_direct_add_imm_bit11_0,
   elf_reloc_aarch64_got_rel_movn_z_bit31_16,
   elf_reloc_aarch64_got_rel_movk_imm_bit15_0,
   elf_reloc_aarch64_adr_pc_relative_21bit,
   elf_reloc_aarch64_direct_add_low_bit11_0,
   elf_reloc_aarch64_got_rel_movn_z_bit31_16_local_dynamic_model,
   elf_reloc_aarch64_got_rel_movk_imm_bit15_0_local_dynamic_model,
   elf_reloc_aarch64_new_global_entry,elf_reloc_aarch64_new_plt_entry,
   elf_reloc_aarch64_relative:Result.GotBool:=true;
   end;
  end;
 elf_machine_riscv:
  begin
   case RelocationType of
   elf_reloc_riscv_32bit:Result.NeedRelocationBits:=32;
   elf_reloc_riscv_64bit:Result.NeedRelocationBits:=64;
   elf_reloc_riscv_got_high_20bit:Result.GotBool:=true;
   end;
  end;
 elf_machine_loongarch:
  begin
   case RelocationType of
   elf_reloc_loongarch_32bit:Result.NeedRelocationBits:=32;
   elf_reloc_loongarch_64bit:Result.NeedRelocationBits:=64;
   elf_reloc_loongarch_got_pc_high_20bit,
   elf_reloc_loongarch_got_pc_low_12bit,
   elf_reloc_loongarch_got64_pc_low_20bit,elf_reloc_loongarch_got64_pc_high_12bit,
   elf_reloc_loongarch_got_high_20bit,elf_reloc_loongarch_got_low_12bit,
   elf_reloc_loongarch_got64_low_20bit,elf_reloc_loongarch_got64_high_12bit:Result.GotBool:=true;
   end;
  end;
 end;
end;
function unifile_calculate_relocation(RelocationArchitecture:word;RelocationBits:byte;
RelocationType:SizeUint;GotType:byte;RelocationData:array of SizeInt;GoalBool:boolean=true;
RiscvSpecial:byte=0):unifile_result;
begin
 Result.GotType:=0; Result.Bits:=0; Result.AdjustValue:=0; Result.SpecialBool:=false;
 Result.RiscvType:=0; Result.ConvertToRelocationBits:=0;
 case RelocationArchitecture of
 elf_machine_386:
  begin
   Result.Bits:=32;
   {Data Sequence:S,A,B,P,L,GOT,G}
   case RelocationType of
   elf_reloc_i386_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.ConvertToRelocationBits:=32;
    end;
   elf_reloc_i386_pc32:Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3];
   elf_reloc_i386_got32:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[1]; Result.GotType:=GotType;
    end;
   elf_reloc_i386_plt32:Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[4];
   elf_reloc_i386_new_got_entry:Result.AdjustValue:=RelocationData[0];
   elf_reloc_i386_new_plt_entry:Result.AdjustValue:=RelocationData[0];
   elf_reloc_i386_relative:Result.AdjustValue:=RelocationData[2]+RelocationData[1];
   elf_reloc_i386_got_offset:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[5]; Result.GotType:=GotType;
    end;
   elf_reloc_i386_32bit_pc_relative_offset:
   Result.AdjustValue:=RelocationData[5]+RelocationData[1]-RelocationData[3];
   elf_reloc_i386_32plt:Result.AdjustValue:=RelocationData[4]+RelocationData[1];
   elf_reloc_i386_16bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=16;
     Result.ConvertToRelocationBits:=16;
    end;
   elf_reloc_i386_pc16bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=16;
    end;
   elf_reloc_i386_8bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=8;
    end;
   elf_reloc_i386_pc8bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=8;
    end;
   elf_reloc_i386_got_relaxable:
    begin
     Result.SpecialBool:=GoalBool;
     if(GoalBool=false) then
     Result.AdjustValue:=RelocationData[5]+RelocationData[6]+RelocationData[1]-RelocationData[3]
     else
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3];
     Result.Bits:=32;
    end
   else exit(Result);
   end;
  end;
 elf_machine_arm:
  begin
   Result.Bits:=32;
   {Data Sequence:S,A,B,T,P,Pa,PLT,GOT_ORG,GOT}
   case RelocationType of
   elf_reloc_arm_pc_relative_26bit_branch:
    begin
     Result.AdjustValue:=((RelocationData[0]+RelocationData[1]) or RelocationData[3])-RelocationData[4];
     Result.Bits:=26;
    end;
   elf_reloc_arm_absolute_32bit:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3];
     Result.ConvertToRelocationBits:=32;
    end;
   elf_reloc_arm_pc_relative_32bit:
   Result.AdjustValue:=((RelocationData[0]+RelocationData[1]) or RelocationData[3])-RelocationData[4];
   elf_reloc_arm_pc_relative_13bit_branch:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[4];
     Result.Bits:=13;
    end;
   elf_reloc_arm_absolute_16bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=16;
     Result.ConvertToRelocationBits:=16;
    end;
   elf_reloc_arm_absolute_12bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=12;
    end;
   elf_reloc_arm_thumb_absolute_5bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=5;
    end;
   elf_reloc_arm_absolute_8bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=8;
    end;
   elf_reloc_arm_sb_reloc_32bit:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-
     (RelocationData[2]+RelocationData[0]); Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_pc_22bit:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=22;
    end;
   elf_reloc_arm_thumb_pc_8bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[5]; Result.Bits:=8;
    end;
   elf_reloc_arm_new_got_entry:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]; Result.Bits:=32;
    end;
   elf_reloc_arm_new_plt_entry:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]; Result.Bits:=32;
    end;
   elf_reloc_arm_relative:
    begin
     Result.AdjustValue:=RelocationData[2]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_arm_got_offset:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]
     -RelocationData[7]; Result.Bits:=32; Result.GotType:=GotType;
    end;
   elf_reloc_arm_pc_relative_got_offset:
    begin
     Result.AdjustValue:=RelocationData[2]+RelocationData[1]-RelocationData[4]; Result.Bits:=32;
    end;
   elf_reloc_arm_got_entry_32bit:
    begin
     Result.AdjustValue:=RelocationData[7]+RelocationData[1]-RelocationData[6]; Result.Bits:=32;
     Result.GotType:=GotType;
    end;
   elf_reloc_arm_plt_address_32bit:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=32;
    end;
   elf_reloc_arm_call:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=24;
    end;
   elf_reloc_arm_pc_relative_24bit:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=24;
    end;
   elf_reloc_arm_thumb_pc_relative_24bit:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=24;
    end;
   elf_reloc_arm_base_absolute:
    begin
     Result.AdjustValue:=RelocationData[2]+RelocationData[1];
     Result.Bits:=32;
    end;
   elf_reloc_arm_ldr_sbrel_bit11_0:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2];
     Result.Bits:=12;
    end;
   elf_reloc_arm_alu_sbrel_bit19_12:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2];
     Result.Bits:=8;
    end;
   elf_reloc_arm_alu_sbrel_bit27_20:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2];
     Result.Bits:=8;
    end;
   elf_reloc_arm_target1:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3];
     Result.Bits:=32;
    end;
   elf_reloc_arm_program_base_relative:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3];
     Result.Bits:=32;
    end;
   elf_reloc_arm_31bit_pc_relative:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=31;
    end;
   elf_reloc_arm_movw_absolute_16bit:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3];
     Result.Bits:=16;
    end;
   elf_reloc_arm_movt_absolute:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_arm_movw_pc_relative:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=16;
    end;
   elf_reloc_arm_thumb_movw_absolute:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3];
     Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_movt_absolute:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1];
     Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_movw_pc_relative:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_movt_pc_relative:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[4];
     Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_pc_relative_20bit_b:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[5];
     Result.Bits:=20;
    end;
   elf_reloc_arm_thumb_pc_relative_6bit_b:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[5];
     Result.Bits:=6;
    end;
   elf_reloc_arm_thumb_alu_pc_relative_bit11_0:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[5];
     Result.Bits:=12;
    end;
   elf_reloc_arm_thumb_pc_12bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[5];
     Result.Bits:=12;
    end;
   elf_reloc_arm_absolute_32bit_no_interrupt:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_arm_pc_relative_32bit_no_interrupt:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[4];
     Result.Bits:=32;
    end;
   elf_reloc_arm_alu_pc_relative_g0_no_check,elf_reloc_arm_alu_pc_relative_g0,
   elf_reloc_arm_alu_pc_relative_g1_no_check,elf_reloc_arm_alu_pc_relative_g1,
   elf_reloc_arm_alu_pc_relative_g2:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=32;
    end;
   elf_reloc_arm_ldr_str_ldrb_strb_pc_relative_g1,elf_reloc_arm_ldr_str_ldrb_strb_pc_relative_g2,
   elf_reloc_arm_ldr_str_pc_relative_g0,elf_reloc_arm_ldr_str_pc_relative_g1,
   elf_reloc_arm_ldr_str_pc_relative_g2,elf_reloc_arm_ldc_stc_pc_relative_g0,
   elf_reloc_arm_ldc_stc_pc_relative_g1,elf_reloc_arm_ldc_stc_pc_relative_g2:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[4];
     Result.Bits:=32;
    end;
   elf_reloc_arm_alu_program_base_relative_add_sub_g0_no_check,
   elf_reloc_arm_alu_program_base_relative_add_sub_g0,
   elf_reloc_arm_alu_program_base_relative_add_sub_g1_no_check,
   elf_reloc_arm_alu_program_base_relative_add_sub_g1,
   elf_reloc_arm_alu_program_base_relative_add_sub_g2:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[2];
     Result.Bits:=32;
    end;
   elf_reloc_arm_program_base_relative_ldr_str_ldrb_strb_g0,
   elf_reloc_arm_program_base_relative_ldr_str_ldrb_strb_g1,
   elf_reloc_arm_program_base_relative_ldr_str_ldrb_strb_g2,
   elf_reloc_arm_program_base_relative_ldrs_g0,
   elf_reloc_arm_program_base_relative_ldrs_g1,
   elf_reloc_arm_program_base_relative_ldrs_g2,
   elf_reloc_arm_ldc_base_relative_g0,elf_reloc_arm_ldc_base_relative_g1,
   elf_reloc_arm_ldc_base_relative_g2:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2]; Result.Bits:=32;
    end;
   elf_reloc_arm_movw_base_relative_no_check:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[2];
     Result.Bits:=16;
    end;
   elf_reloc_arm_movt_base_relative:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2]; Result.Bits:=32;
    end;
   elf_reloc_arm_movw_base_relative:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[2];
     Result.Bits:=16;
    end;
   elf_reloc_arm_thumb_movw_base_relative_no_check:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[2];
     Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_movt_base_relative:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2]; Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_movw_base_relative:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[2];
     Result.Bits:=32;
    end;
   elf_reloc_arm_absolute_plt32:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_arm_got_absolute:
    begin
     Result.AdjustValue:=RelocationData[8]+RelocationData[1]; Result.GotType:=GotType;
     Result.Bits:=32;
    end;
   elf_reloc_arm_got_pc_relative:
    begin
     Result.AdjustValue:=RelocationData[8]+RelocationData[1]-RelocationData[4]; Result.GotType:=GotType;
     Result.Bits:=32;
    end;
   elf_reloc_arm_got_relative_to_got_origin:
    begin
     Result.AdjustValue:=RelocationData[8]+RelocationData[1]-RelocationData[7]; Result.GotType:=GotType;
     Result.Bits:=12;
    end;
   elf_reloc_arm_got_offset_12bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[7];
     Result.Bits:=12;
    end;
   elf_reloc_arm_thumb_pc_11bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[4]; Result.Bits:=11;
    end;
   elf_reloc_arm_thumb_pc_9bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[4]; Result.Bits:=9;
    end;
   elf_reloc_arm_thumb_got_entry_relative_to_got_origin:
    begin
     Result.AdjustValue:=RelocationData[8]+RelocationData[1]-RelocationData[7]; Result.Bits:=12;
    end;
   elf_reloc_arm_thumb_alu_abs_g0_no_check:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]; Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_alu_abs_g1_no_check:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_alu_abs_g2_no_check:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_alu_abs_g3:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_arm_thumb_bf16:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=16;
    end;
   elf_reloc_arm_thumb_bf12:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=12;
    end;
   elf_reloc_arm_thumb_bf18:
    begin
     Result.AdjustValue:=(RelocationData[0]+RelocationData[1]) or RelocationData[3]-RelocationData[4];
     Result.Bits:=18;
    end;
   else exit(Result);
   end;
  end;
 elf_machine_x86_64:
  begin
   Result.Bits:=64;
   {Data Sequence:S,A,B,P,L,GOT,G,Z}
   case RelocationType of
   elf_reloc_x86_64_64bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.ConvertToRelocationBits:=64;
    end;
   elf_reloc_x86_64_pc_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=32;
    end;
   elf_reloc_x86_64_got_32bit:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[1]; Result.Bits:=32; Result.GotType:=GotType;
    end;
   elf_reloc_x86_64_plt_32bit:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[1]-RelocationData[3]; Result.Bits:=32;
    end;
   elf_reloc_x86_64_new_got_entry,elf_reloc_x86_64_new_plt_entry:
    begin
     Result.AdjustValue:=RelocationData[0];
    end;
   elf_reloc_x86_64_relative:
    begin
     Result.AdjustValue:=RelocationData[2]+RelocationData[1];
    end;
   elf_reloc_x86_64_pc_relative_offset_got:
    begin
     Result.SpecialBool:=GoalBool;
     if(GoalBool=false) then
      begin
       Result.AdjustValue:=RelocationData[6]+RelocationData[5]+RelocationData[1]-RelocationData[3];
       Result.Bits:=32; Result.GotType:=GotType;
      end
     else
      begin
       Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3];
       Result.Bits:=32;
      end;
    end;
   elf_reloc_x86_64_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
     Result.ConvertToRelocationBits:=32;
    end;
   elf_reloc_x86_64_16bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=16;
     Result.ConvertToRelocationBits:=16;
    end;
   elf_reloc_x86_64_pc_16bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=16;
    end;
   elf_reloc_x86_64_8bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=8;
    end;
   elf_reloc_x86_64_pc_8bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=8;
    end;
   elf_reloc_x86_64_pc64:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=64;
    end;
   elf_reloc_x86_64_got_offset64:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[5];
     Result.Bits:=64; Result.GotType:=GotType;
    end;
   elf_reloc_x86_64_got_pc32:
    begin
     Result.AdjustValue:=RelocationData[5]+RelocationData[1]-RelocationData[3]; Result.Bits:=32;
     Result.GotType:=GotType;
    end;
   elf_reloc_x86_64_got64:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[1]; Result.Bits:=64;
     Result.GotType:=GotType;
    end;
   elf_reloc_x86_64_got_pc_relative:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[5]+RelocationData[1]-RelocationData[3];
     Result.Bits:=64; Result.GotType:=GotType;
    end;
   elf_reloc_x86_64_got_pc64:
    begin
     Result.AdjustValue:=RelocationData[5]+RelocationData[1]-RelocationData[3]; Result.Bits:=64;
     Result.GotType:=GotType;
    end;
   elf_reloc_x86_64_got_plt64:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[1]; Result.Bits:=64;
     Result.GotType:=GotType;
    end;
   elf_reloc_x86_64_plt_offset64:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[1]-RelocationData[5]; Result.Bits:=64;
     Result.GotType:=GotType;
    end;
   elf_reloc_x86_64_size32:
    begin
     Result.AdjustValue:=RelocationData[7]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_x86_64_size64:
    begin
     Result.AdjustValue:=RelocationData[7]+RelocationData[1]; Result.Bits:=64;
    end;
   elf_reloc_x86_64_indirect_relative,elf_reloc_x86_64_relative_64:
    begin
     Result.AdjustValue:=RelocationData[2]+RelocationData[1]; Result.Bits:=64;
    end;
   elf_reloc_x86_64_got_pc_relative_without_rex,elf_reloc_x86_64_got_pc_relative_with_rex:
    begin
     Result.SpecialBool:=GoalBool; Result.Bits:=32;
     if(GoalBool=false) then
     Result.AdjustValue:=RelocationData[5]+RelocationData[6]+RelocationData[1]-RelocationData[3]
     else
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3];
    end
   else exit(Result);
   end;
  end;
 elf_machine_aarch64:
  begin
   Result.Bits:=64;
   {Data Sequence:S,A,Delta,P,GDAT,GOT,G,B}
   case RelocationType of
   elf_reloc_aarch64_32bit_absolute:
    begin
     Result.AdjustValue:=RelocationData[0]; Result.Bits:=32;
     Result.ConvertToRelocationBits:=32;
    end;
   elf_reloc_aarch64_32bit_new_got_entry,elf_reloc_aarch64_32bit_new_plt_entry:
    begin
     Result.AdjustValue:=RelocationData[0]; Result.Bits:=32;
    end;
   elf_reloc_aarch64_32bit_relative:
    begin
     Result.AdjustValue:=RelocationData[7]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_aarch64_absolute_64bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=64;
     Result.ConvertToRelocationBits:=64;
    end;
   elf_reloc_aarch64_absolute_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
     Result.ConvertToRelocationBits:=32;
    end;
   elf_reloc_aarch64_absolute_16bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=16;
     Result.ConvertToRelocationBits:=16;
    end;
   elf_reloc_aarch64_absolute_pc_relative_64bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=64;
    end;
   elf_reloc_aarch64_absolute_pc_relative_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=32;
    end;
   elf_reloc_aarch64_absolute_pc_relative_16bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=16;
    end;
   elf_reloc_aarch64_plt_32:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=32;
    end;
   elf_reloc_aarch64_movz_imm_bit15_0,elf_reloc_aarch64_movk_imm_bit15_0,
   elf_reloc_aarch64_movz_imm_bit31_16,elf_reloc_aarch64_movk_imm_bit31_16,
   elf_reloc_aarch64_movz_imm_bit47_32,elf_reloc_aarch64_movk_imm_bit47_32,
   elf_reloc_aarch64_movk_z_imm_bit64_48,elf_reloc_aarch64_movn_z_imm_bit15_0,
   elf_reloc_aarch64_movn_z_imm_bit31_16,elf_reloc_aarch64_movn_z_imm_bit47_32:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=16;
    end;
   elf_reloc_aarch64_ldr_literal_pc_rel_low19bit,elf_reloc_aarch64_adr_pc_rel_low21bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=20;
    end;
   elf_reloc_aarch64_adrp_page_rel_bit32_12,elf_reloc_aarch64_adrp_page_rel_bit32_12_no_check:
    begin
     Result.AdjustValue:=unifile_align_relocation(RelocationData[0]+RelocationData[1]+$800,4096)
     -unifile_align_relocation(RelocationData[3],4096); Result.Bits:=20;
    end;
   elf_reloc_aarch64_add_absolute_low12bit,elf_reloc_aarch64_ld_or_st_absolute_low12bit,
   elf_reloc_aarch64_add_bit16_imm_bit11_1,elf_reloc_aarch64_add_bit32_imm_bit11_2,
   elf_reloc_aarch64_add_bit64_imm_bit11_3,elf_reloc_aarch64_add_bit128_imm_from_bit11_4:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=12;
    end;
   elf_reloc_aarch64_pc_rel_tbz_bit15_2:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=14;
    end;
   elf_reloc_aarch64_pc_rel_cond_or_br_bit20_2:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=19;
    end;
   elf_reloc_aarch64_pc_rel_jump_bit27_2,elf_reloc_aarch64_pc_rel_call_bit27_2:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=26;
    end;
   elf_reloc_aarch64_pc_rel_movn_z_imm_bit15_0,elf_reloc_aarch64_pc_rel_movk_imm_bit15_0,
   elf_reloc_aarch64_pc_rel_movn_z_imm_bit31_16,elf_reloc_aarch64_pc_rel_movk_imm_bit31_16,
   elf_reloc_aarch64_pc_rel_movn_z_imm_bit47_32,elf_reloc_aarch64_pc_rel_movk_imm_bit47_32,
   elf_reloc_aarch64_pc_rel_movn_z_imm_bit63_48:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=16;
    end;
   elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit15_0,elf_reloc_aarch64_got_rel_offset_movk_imm_bit15_0,
   elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit31_16,
   elf_reloc_aarch64_got_rel_offset_movk_imm_bit31_16,
   elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit47_32,
   elf_reloc_aarch64_got_rel_offset_movk_imm_bit47_32,
   elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit63_48:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[4]-RelocationData[5]; Result.Bits:=16;
     Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_got_relative_64bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[5]; Result.Bits:=64;
    end;
   elf_reloc_aarch64_got_relative_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[5]; Result.Bits:=32;
    end;
   elf_reloc_aarch64_pc_relative_got_offset32:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[4]-RelocationData[5]; Result.Bits:=32;
     Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_pc_rel_got_offset:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[4]-RelocationData[3]; Result.Bits:=32;
     Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_got_rel_offset_ld_st_imm_bit14_3:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[4]-RelocationData[5]; Result.Bits:=32;
     Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_page_rel_adrp_bit32_12:
    begin
     Result.AdjustValue:=unifile_align_relocation(RelocationData[6]+RelocationData[4]+$800,4096)-
     unifile_align_relocation(RelocationData[3],4096); Result.Bits:=32; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_dir_got_offset_ld_st_imm_bit11_3:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[4];
     Result.Bits:=12; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_got_page_rel_got_offset_ld_st_bit14_3:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[4]-
     unifile_align_relocation(RelocationData[5],4096);
     Result.Bits:=15; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_pc_relative_adr_imm_bit20_0:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[0]+RelocationData[1]-RelocationData[3];
     Result.Bits:=21; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_page_relative_adr_imm_bit32_12:
    begin
     Result.AdjustValue:=
     unifile_align_relocation(RelocationData[6]+RelocationData[0]+RelocationData[1]+$800,4096)-
     unifile_align_relocation(RelocationData[3],4096); Result.Bits:=32; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_direct_add_imm_bit11_0:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[0]+RelocationData[1];
     Result.Bits:=12; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_got_rel_movn_z_bit31_16:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[0]+RelocationData[1]-RelocationData[5];
     Result.Bits:=16; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_got_rel_movk_imm_bit15_0:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[0]+RelocationData[1]-RelocationData[5];
     Result.Bits:=16; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_adr_pc_relative_21bit:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[0]-RelocationData[3];
     Result.Bits:=21; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_adr_page_relative_21bit:
    begin
     Result.AdjustValue:=unifile_align_relocation(RelocationData[6]+RelocationData[0]+$800,4096)-
     unifile_align_relocation(RelocationData[3],4096); Result.Bits:=21; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_direct_add_low_bit11_0:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[0];
     Result.Bits:=12; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_got_rel_movn_z_bit31_16_local_dynamic_model:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[0]-RelocationData[5];
     Result.Bits:=16; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_got_rel_movk_imm_bit15_0_local_dynamic_model:
    begin
     Result.AdjustValue:=RelocationData[6]+RelocationData[0]-RelocationData[5];
     Result.Bits:=16; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_new_global_entry,elf_reloc_aarch64_new_plt_entry:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1];
     Result.Bits:=64; Result.GotType:=GotType;
    end;
   elf_reloc_aarch64_relative:
    begin
     Result.AdjustValue:=RelocationData[7]+RelocationData[1];
     Result.Bits:=64; Result.GotType:=GotType;
    end;
   else exit(Result);
   end;
  end;
 elf_machine_riscv:
  begin
   Result.Bits:=RelocationBits;
   {Data sequence:S,A,Delta,P,V,G,GOT,B}
   case RelocationType of
   elf_reloc_riscv_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
     Result.ConvertToRelocationBits:=32;
    end;
   elf_reloc_riscv_64bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=64;
     Result.ConvertToRelocationBits:=64;
    end;
   elf_reloc_riscv_relative:
    begin
     Result.AdjustValue:=RelocationData[7]+RelocationData[1]; Result.Bits:=RelocationBits;
    end;
   elf_reloc_riscv_jump_slot:
    begin
     Result.AdjustValue:=RelocationData[0]; Result.Bits:=RelocationBits;
    end;
   elf_reloc_riscv_branch:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=13;
     Result.RiscvType:=elf_riscv_b_type;
    end;
   elf_reloc_riscv_jal:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=21;
     Result.RiscvType:=elf_riscv_j_type;
    end;
   elf_reloc_riscv_call:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=32;
     Result.RiscvType:=elf_riscv_u_i_type;
    end;
   elf_reloc_riscv_call_plt:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=32;
     Result.RiscvType:=elf_riscv_u_i_type;
    end;
   elf_reloc_riscv_got_high_20bit:
    begin
     Result.AdjustValue:=RelocationData[5]+RelocationData[6]+RelocationData[1]-RelocationData[3];
     Result.Bits:=32; Result.GotType:=GotType; Result.RiscvType:=elf_riscv_u_type;
    end;
   elf_reloc_riscv_pc_relative_high_20bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3];
     Result.Bits:=32; Result.RiscvType:=elf_riscv_u_type;
    end;
   elf_reloc_riscv_pc_relative_low_12bit,elf_reloc_riscv_pc_relative_low_12bit_store:
    begin
     if(RiscVSpecial=unifile_riscv_got) then
     Result.AdjustValue:=RelocationData[5]+RelocationData[6]+RelocationData[1]-RelocationData[3]
     else
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3];
     if(RelocationType=elf_reloc_riscv_pc_relative_low_12bit) then
      begin
       Result.RiscvType:=elf_riscv_i_type; Result.Bits:=12;
      end
     else
      begin
       Result.RiscvType:=elf_riscv_s_type; Result.Bits:=12;
      end;
    end;
   elf_reloc_riscv_high_20bit,elf_reloc_riscv_low_12bit,elf_reloc_riscv_low_12bit_store:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1];
     if(RelocationType=elf_reloc_riscv_high_20bit) then
      begin
       Result.RiscvType:=elf_riscv_u_type; Result.Bits:=32;
      end
     else if(RelocationType=elf_reloc_riscv_low_12bit) then
      begin
       Result.RiscvType:=elf_riscv_i_type; Result.Bits:=12;
      end
     else
      begin
       Result.RiscvType:=elf_riscv_s_type; Result.Bits:=12;
      end;
    end;
   elf_reloc_riscv_add_8bit:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[0]+RelocationData[1]; Result.Bits:=8;
    end;
   elf_reloc_riscv_add_16bit:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[0]+RelocationData[1]; Result.Bits:=16;
    end;
   elf_reloc_riscv_add_32bit:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[0]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_riscv_add_64bit:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[0]+RelocationData[1]; Result.Bits:=64;
    end;
   elf_reloc_riscv_sub_8bit:
    begin
     Result.AdjustValue:=RelocationData[4]-RelocationData[0]-RelocationData[1]; Result.Bits:=8;
    end;
   elf_reloc_riscv_sub_16bit:
    begin
     Result.AdjustValue:=RelocationData[4]-RelocationData[0]-RelocationData[1]; Result.Bits:=16;
    end;
   elf_reloc_riscv_sub_32bit:
    begin
     Result.AdjustValue:=RelocationData[4]-RelocationData[0]-RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_riscv_sub_64bit:
    begin
     Result.AdjustValue:=RelocationData[4]-RelocationData[0]-RelocationData[1]; Result.Bits:=64;
    end;
   elf_reloc_riscv_got_32_pc_relative:
    begin
     Result.AdjustValue:=RelocationData[5]+RelocationData[6]+RelocationData[1]-RelocationData[3];
     Result.Bits:=32;
    end;
   elf_reloc_riscv_rvc_branch:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3];
     Result.Bits:=9; Result.RiscvType:=elf_riscv_cb_type;
    end;
   elf_reloc_riscv_rvc_jump:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3];
     Result.Bits:=12; Result.RiscvType:=elf_riscv_cj_type;
    end;
   elf_reloc_riscv_sub_6:
    begin
     Result.AdjustValue:=RelocationData[4]-RelocationData[0]-RelocationData[1]; Result.Bits:=6;
    end;
   elf_reloc_riscv_set_6:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=6;
    end;
   elf_reloc_riscv_set_8:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=8;
    end;
   elf_reloc_riscv_set_16:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=16;
    end;
   elf_reloc_riscv_set_32:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_riscv_32_pcrel,elf_reloc_riscv_plt_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[3]; Result.Bits:=32;
    end;
   elf_reloc_riscv_sub_uleb128:
    begin
     Result.AdjustValue:=RelocationData[4]-RelocationData[0]-RelocationData[1]; Result.Bits:=128;
    end;
   elf_reloc_riscv_set_uleb128:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=128;
    end;
   else exit(Result);
   end;
  end;
 elf_machine_loongarch:
  begin
   Result.Bits:=RelocationBits;
   {Data sequence:S,A,PC,B,GP,G}
   case RelocationType of
   elf_reloc_loongarch_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
     Result.ConvertToRelocationBits:=32;
    end;
   elf_reloc_loongarch_64bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=64;
     Result.ConvertToRelocationBits:=64;
    end;
   elf_reloc_loongarch_relative:Result.AdjustValue:=RelocationData[3]+RelocationData[1];
   elf_reloc_loongarch_jump_slot:Result.AdjustValue:=RelocationData[0];
   elf_reloc_loongarch_add_8bit,elf_reloc_loongarch_sub_8bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=8;
    end;
   elf_reloc_loongarch_add_16bit,elf_reloc_loongarch_sub_16bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=16;
    end;
   elf_reloc_loongarch_add_24bit,elf_reloc_loongarch_sub_24bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=24;
    end;
   elf_reloc_loongarch_add_32bit,elf_reloc_loongarch_sub_32bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_loongarch_add_64bit,elf_reloc_loongarch_sub_64bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=64;
    end;
   elf_reloc_loongarch_b16:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2]; Result.Bits:=18;
    end;
   elf_reloc_loongarch_b21:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2]; Result.Bits:=23;
    end;
   elf_reloc_loongarch_b26:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2]; Result.Bits:=28;
    end;
   elf_reloc_loongarch_absolute_high_20bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=32;
    end;
   elf_reloc_loongarch_absolute_low_12bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=12;
    end;
   elf_reloc_loongarch_absolute_64bit_low_20bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=52;
    end;
   elf_reloc_loongarch_absolute_64bit_high_12bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=64;
    end;
   elf_reloc_loongarch_pcala_high_20bit:
    begin
     Result.AdjustValue:=unifile_align_relocation(RelocationData[0]+RelocationData[1]+$800,$1000)-
     unifile_align_relocation(RelocationData[2],$1000); Result.Bits:=32;
    end;
   elf_reloc_loongarch_pcala_low_12bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]; Result.Bits:=12;
    end;
   elf_reloc_loongarch_pcala64_low_20bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]
     -unifile_align_relocation(RelocationData[2],$100000000); Result.Bits:=52;
    end;
   elf_reloc_loongarch_pcala64_high_12bit:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]
     -unifile_align_relocation(RelocationData[2],$100000000); Result.Bits:=64;
    end;
   elf_reloc_loongarch_got_pc_high_20bit:
    begin
     Result.AdjustValue:=unifile_align_relocation(RelocationData[4]+RelocationData[5]+$800,$1000)-
     unifile_align_relocation(RelocationData[2],$1000); Result.Bits:=32; Result.GotType:=GotType;
    end;
   elf_reloc_loongarch_got_pc_low_12bit:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[5]; Result.Bits:=12; Result.GotType:=GotType;
    end;
   elf_reloc_loongarch_got64_pc_low_20bit,elf_reloc_loongarch_got64_pc_high_12bit:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[5]-
     unifile_align_relocation(RelocationData[2],$100000000);
     if(RelocationType=elf_reloc_loongarch_got64_pc_low_20bit) then
     Result.Bits:=52 else Result.Bits:=64;
     Result.GotType:=GotType;
    end;
   elf_reloc_loongarch_got_high_20bit,elf_reloc_loongarch_got_low_12bit:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[5];
     if(RelocationType=elf_reloc_loongarch_got_high_20bit) then
     Result.Bits:=32 else Result.Bits:=12;
     Result.GotType:=GotType;
    end;
   elf_reloc_loongarch_got64_low_20bit,elf_reloc_loongarch_got64_high_12bit:
    begin
     Result.AdjustValue:=RelocationData[4]+RelocationData[5];
     if(RelocationType=elf_reloc_loongarch_got64_low_20bit) then
     Result.Bits:=52 else Result.Bits:=64;
     Result.GotType:=GotType;
    end;
   elf_reloc_loongarch_32_pc_relative:
    begin
     Result.AdjustValue:=RelocationData[0]+RelocationData[1]-RelocationData[2];
     Result.Bits:=32; Result.GotType:=GotType;
    end;
   else exit(Result);
   end;
  end;
 end;
end;
function unifile_calculate_timestamp:Dword;
begin
 unifile_calculate_timestamp:=DateTimeToFileDate(Now);
end;
procedure unifile_quick_sort(SymbolTable:unifile_file_symbol_table;
var SymbolIndex:unifile_index_list;left,right:SizeUint);
var i,j,x,y:SizeUint;
begin
 i:=left; j:=right; x:=(left+right) div 2;
 repeat
  while(SymbolTable.SymbolBinding[SymbolIndex[i-1]-1]<SymbolTable.SymbolBinding[SymbolIndex[x-1]-1])
  do inc(i);
  while(SymbolTable.SymbolBinding[SymbolIndex[j-1]-1]>SymbolTable.SymbolBinding[SymbolIndex[x-1]-1])
  do dec(j);
  if(i<=j) then
   begin
    if(i<>j) and
    (SymbolTable.SymbolBinding[SymbolIndex[i-1]-1]<>SymbolTable.SymbolBinding[SymbolIndex[j-1]-1])then
     begin
      y:=SymbolIndex[i-1];
      SymbolIndex[i-1]:=SymbolIndex[j-1];
      SymbolIndex[j-1]:=y;
     end;
    inc(i); dec(j);
   end;
 until (i>j);
 if(i<right) then unifile_quick_sort(SymbolTable,SymbolIndex,i,right);
 if(j>left) then unifile_quick_sort(SymbolTable,SymbolIndex,left,j);
end;
procedure unifile_output_final_file(outputfile:unifile_file_final;var basescript:unild_script;
filename:string;fileclass:byte);
var fs:TFileStream;
    Content:Pointer;
    PartAlign,PartAttribute:Dword;
    WritePointer,WritePointer2:SizeUint;
    StartOffset,EndOffset,StartAddress,EndAddress:SizeUint;
    i:SizeUint;
    ELFBool:boolean=false;
begin
 Content:=allocmem(outputfile.FinalFileSize);
 StartOffset:=0; StartAddress:=basescript.BaseAddress; EndOffset:=0; EndAddress:=0;
 PartAlign:=0; WritePointer:=0; WritePointer2:=0;
 if(fileclass=unifile_class_elf_file) then
  begin
   if(outputfile.Bits=32) then
    begin
     Move(elf_magic,Pelf32_header(Content)^.elf_id,4);
     Pelf32_header(Content)^.elf_id[elf_class_position]:=elf_class_32;
     Pelf32_header(Content)^.elf_id[elf_data_position]:=elf_data_lsb;
     Pelf32_header(Content)^.elf_id[elf_file_version_position]:=elf_file_version_current;
     Pelf32_header(Content)^.elf_id[elf_os_abi_position]:=basescript.SystemIndex*3;
     Pelf32_header(Content)^.elf_id[elf_abi_version_position]:=0;
     if(basescript.elfclass=unild_class_relocatable) then
     Pelf32_header(Content)^.elf_type:=elf_type_relocatable
     else if(basescript.elfclass=unild_class_sharedobject) then
     Pelf32_header(Content)^.elf_type:=elf_type_dynamic
     else if(basescript.elfclass=unild_class_executable) and (basescript.NoFixedAddress) then
     Pelf32_header(Content)^.elf_type:=elf_type_dynamic
     else if(basescript.elfclass=unild_class_executable) then
     Pelf32_header(Content)^.elf_type:=elf_type_executable
     else if(basescript.elfclass=unild_class_core) then
     Pelf32_header(Content)^.elf_type:=elf_type_core;
     Pelf32_header(Content)^.elf_machine:=outputfile.Architecture;
     Pelf32_header(Content)^.elf_version:=1;
     if(basescript.elfclass<>unild_class_relocatable) then
     Pelf32_header(Content)^.elf_program_header_offset:=sizeof(elf32_header)
     else
     Pelf32_header(Content)^.elf_program_header_offset:=0;
     Pelf32_header(Content)^.elf_section_header_offset:=outputfile.FinalSectionOffset;
     Pelf32_header(Content)^.elf_flags:=outputfile.FileFlag;
     Pelf32_header(Content)^.elf_entry:=outputfile.EntryAddress;
     Pelf32_header(Content)^.elf_header_size:=sizeof(elf32_header);
     if(basescript.elfclass<>unild_class_relocatable) then
      begin
       Pelf32_header(Content)^.elf_program_header_number:=outputfile.FileProgramCount;
       Pelf32_header(Content)^.elf_program_header_size:=sizeof(elf32_program_header);
      end
     else
      begin
       Pelf32_header(Content)^.elf_program_header_number:=0;
       Pelf32_header(Content)^.elf_program_header_size:=sizeof(elf32_program_header);
      end;
     Pelf32_header(Content)^.elf_section_header_number:=outputfile.SectionCount+1;
     Pelf32_header(Content)^.elf_section_header_size:=sizeof(elf32_section_header);
     Pelf32_header(Content)^.elf_section_header_string_table_index:=outputfile.StringTableIndex;
     WritePointer:=sizeof(elf32_header);
     Pelf32_program_header(Content+WritePointer)^.program_offset:=sizeof(elf32_header);
     Pelf32_program_header(Content+WritePointer)^.program_physical_address:=
     outputfile.BaseAddress+sizeof(elf32_header);
     Pelf32_program_header(Content+WritePointer)^.program_file_size:=
     outputfile.FileProgramCount*sizeof(elf32_program_header);
     Pelf32_program_header(Content+WritePointer)^.program_memory_size:=
     outputfile.FileProgramCount*sizeof(elf32_program_header);
     Pelf32_program_header(Content+WritePointer)^.program_align:=4;
     Pelf32_program_header(Content+WritePointer)^.program_virtual_address:=
     outputfile.BaseAddress+sizeof(elf32_header);
     Pelf32_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc;
     Pelf32_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_self;
     inc(WritePointer,sizeof(elf32_program_header));
     if(outputfile.FileProgramCount>0) then
      begin
       i:=1;
       if(outputfile.FileStartAddress<=outputfile.SectionAddress[0]) then
       StartOffset:=outputfile.SectionAddress[0]-outputfile.FileStartAddress
       else
        begin
         writeln('ERROR:Cannot Generate the Program Header for the file '+filename+'.');
         readln;
         halt;
        end;
       StartAddress:=outputfile.BaseAddress; StartOffset:=0;
       PartAlign:=0; PartAttribute:=0;
       while(i<=outputfile.SectionCount)do
        begin
         if(outputfile.FileAlign=0) then
          begin
           if(PartAlign=0) then PartAlign:=outputfile.SectionAlign[i-1]
           else if(outputfile.SectionAlign[i-1]<PartAlign) then PartAlign:=outputfile.SectionAlign[i-1];
          end
         else PartAlign:=outputfile.FileAlign;
         PartAttribute:=(PartAttribute or outputfile.SectionAttribute[i-1])
         and (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage);
         if(ELFBool) and
         (outputfile.SectionAttribute[i-1]<>0) and
         (StartAddress=outputfile.BaseAddress) and (StartOffset=0) then
          begin
           StartAddress:=outputfile.SectionAddress[i-1]; StartOffset:=outputfile.SectionOffset[i-1];
          end;
         if(outputfile.SectionAttribute[i-1]<>0) then
          begin
           EndAddress:=outputfile.SectionAddress[i-1]+outputfile.SectionSize[i-1];
           if(outputfile.SectionAttribute[i-1] and unifile_attribute_not_in_file=0) then
           EndOffset:=outputfile.SectionOffset[i-1]+outputfile.SectionSize[i-1]
           else
           EndOffset:=outputfile.SectionOffset[i-1];
          end;
         if(i<outputfile.SectionCount)
         and (outputfile.SectionAttribute[i-1] and
         (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)<>outputfile.SectionAttribute[i]
         and (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)) and
         (outputfile.SectionAttribute[i-1] and
         (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)<>0) then
          begin
           Pelf32_program_header(Content+WritePointer)^.program_offset:=StartOffset;
           Pelf32_program_header(Content+WritePointer)^.program_physical_address:=StartAddress;
           Pelf32_program_header(Content+WritePointer)^.program_file_size:=EndOffset-StartOffset;
           Pelf32_program_header(Content+WritePointer)^.program_memory_size:=EndAddress-StartAddress;
           Pelf32_program_header(Content+WritePointer)^.program_align:=PartAlign;
           Pelf32_program_header(Content+WritePointer)^.program_virtual_address:=StartAddress;
           if(PartAttribute and unifile_attribute_alloc=unifile_attribute_alloc) then
           Pelf32_program_header(Content+WritePointer)^.program_flags:=
           Pelf32_program_header(Content+WritePointer)^.program_flags
           or elf_program_header_alloc;
           if(PartAttribute and unifile_attribute_execute=unifile_attribute_execute) then
           Pelf32_program_header(Content+WritePointer)^.program_flags:=
           Pelf32_program_header(Content+WritePointer)^.program_flags
           or elf_program_header_execute;
           if(PartAttribute and unifile_attribute_write=unifile_attribute_write) then
           Pelf32_program_header(Content+WritePointer)^.program_flags:=
           Pelf32_program_header(Content+WritePointer)^.program_flags
           or elf_program_header_write;
           if(PartAttribute and unifile_attribute_thread_local_storage=
           unifile_attribute_thread_local_storage) then
           Pelf32_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_tls
           else
           Pelf32_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_load;
           inc(WritePointer,sizeof(elf32_program_header));
           StartAddress:=outputfile.BaseAddress;
           StartOffset:=0; PartAttribute:=0; PartAlign:=0; ELFBool:=true;
          end
         else if(i<outputfile.SectionCount) and (outputfile.SectionAttribute[i-1] and
         (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)<>outputfile.SectionAttribute[i]
         and (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)) and
         (outputfile.SectionAttribute[i-1] and
          (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
          or unifile_attribute_thread_local_storage)=0) then
          begin
           StartAddress:=outputfile.BaseAddress;
           StartOffset:=0;
           PartAttribute:=0; PartAlign:=0;
          end;
         if(outputfile.SectionName[i-1]='.interp') then
          begin
           Pelf32_program_header(Content+WritePointer)^.program_offset:=
           outputfile.SectionOffset[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_physical_address:=
           outputfile.SectionAddress[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_file_size:=
           outputfile.SectionSize[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_memory_size:=
           outputfile.SectionSize[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_align:=1;
           Pelf32_program_header(Content+WritePointer)^.program_virtual_address:=
           outputfile.SectionAddress[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc;
           Pelf32_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_interp;
           inc(WritePointer,sizeof(elf32_program_header));
          end;
         if(outputfile.SectionName[i-1]='.dynamic') then
          begin
           Pelf32_program_header(Content+WritePointer)^.program_offset:=
           outputfile.SectionOffset[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_physical_address:=
           outputfile.SectionAddress[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_file_size:=
           outputfile.SectionSize[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_memory_size:=
           outputfile.SectionSize[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_align:=4;
           Pelf32_program_header(Content+WritePointer)^.program_virtual_address:=
           outputfile.SectionAddress[i-1];
           Pelf32_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc;
           Pelf32_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_dynamic;
           inc(WritePointer,sizeof(elf32_program_header));
          end;
         inc(i);
        end;
       Pelf32_program_header(Content+WritePointer)^.program_offset:=0;
       Pelf32_program_header(Content+WritePointer)^.program_physical_address:=0;
       Pelf32_program_header(Content+WritePointer)^.program_file_size:=0;
       Pelf32_program_header(Content+WritePointer)^.program_memory_size:=0;
       Pelf32_program_header(Content+WritePointer)^.program_align:=4;
       Pelf32_program_header(Content+WritePointer)^.program_virtual_address:=0;
       Pelf32_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc
       or elf_program_header_write;
       if(basescript.NoExecutableStack=false) then
       Pelf32_program_header(Content+WritePointer)^.program_flags:=
       Pelf32_program_header(Content+WritePointer)^.program_flags or elf_program_header_execute;
       Pelf32_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_gnu_stack;
       inc(WritePointer,sizeof(elf32_program_header));
       if(basescript.GotAuthority>0) and (outputfile.GotIndex>0) then
        begin
         Pelf32_program_header(Content+WritePointer)^.program_offset:=
         outputfile.SectionOffset[outputfile.GotIndex-1];
         Pelf32_program_header(Content+WritePointer)^.program_physical_address:=
         outputfile.SectionAddress[outputfile.GotIndex-1];
         Pelf32_program_header(Content+WritePointer)^.program_file_size:=
         outputfile.SectionSize[outputfile.GotIndex-1];
         Pelf32_program_header(Content+WritePointer)^.program_memory_size:=
         outputfile.SectionSize[outputfile.GotIndex-1];
         Pelf32_program_header(Content+WritePointer)^.program_align:=4;
         Pelf32_program_header(Content+WritePointer)^.program_virtual_address:=
         outputfile.SectionAddress[outputfile.GotIndex-1];
         Pelf32_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc;
         if(basescript.GotAuthority=1) then
         Pelf32_program_header(Content+WritePointer)^.program_flags:=
         Pelf32_program_header(Content+WritePointer)^.program_flags or elf_program_header_write;
         Pelf32_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_gnu_relro;
         inc(WritePointer,sizeof(elf32_program_header));
        end;
      end;
     i:=1; WritePointer2:=outputfile.FinalSectionOffset+sizeof(elf32_section_header);
     for i:=1 to outputfile.SectionCount do
      begin
       Pelf32_section_header(Content+WritePointer2)^.section_header_name:=
       outputfile.SectionNameIndex[i-1];
       Pelf32_section_header(Content+WritePointer2)^.section_header_address:=
       outputfile.SectionAddress[i-1];
       Pelf32_section_header(Content+WritePointer2)^.section_header_address_align:=
       outputfile.SectionAlign[i-1];
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_alloc=unifile_attribute_alloc) then
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_alloc;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_execute=unifile_attribute_execute) then
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_executable;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_write=unifile_attribute_write) then
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_write;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_thread_local_storage=
       unifile_attribute_thread_local_storage) then
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_tls;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_information=
       unifile_attribute_information) then
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf32_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_info_link;
       if(outputfile.SectionName[i-1]='.rela') or (outputfile.SectionName[i-1]='.rela.dyn') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_entry_size:=24
       else if(outputfile.SectionName[i-1]='.rel') or (outputfile.SectionName[i-1]='.rel.dyn') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_entry_size:=16
       else if(outputfile.SectionName[i-1]='.dynsym') or (outputfile.SectionName[i-1]='.symtab')
       or(outputfile.SectionName[i-1]='.gnu_version') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_entry_size:=
       sizeof(elf32_symbol_table_entry)
       else if(outputfile.SectionName[i-1]='.init_array')
       or(outputfile.SectionName[i-1]='.preinit_array')or(outputfile.SectionName[i-1]='.fini_array') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_entry_size:=8
       else if(outputfile.SectionName[i-1]='.dynamic') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_entry_size:=16
       else if(outputfile.SectionName[i-1]='.gnu_version.d') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_entry_size:=
       sizeof(elf32_version_definition_section)
       else if(outputfile.SectionName[i-1]='.gnu_version.r') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_entry_size:=
       sizeof(elf32_version_needed_section)
       else
       Pelf32_section_header(Content+WritePointer2)^.section_header_entry_size:=0;
       Pelf32_section_header(Content+WritePointer2)^.section_header_size:=outputfile.SectionSize[i-1];
       Pelf32_section_header(Content+WritePointer2)^.section_header_offset:=outputfile.SectionOffset[i-1];
       if(outputfile.SectionName[i-1]='.bss') or (outputfile.SectionName[i-1]='.tbss')
       or(outputfile.SectionAttribute[i-1] and
       unifile_attribute_not_in_file=unifile_attribute_not_in_file) then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_nobit
       else if(outputfile.SectionName[i-1]='.init_array') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_init_array
       else if(outputfile.SectionName[i-1]='.fini_array') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_fini_array
       else if(outputfile.SectionName[i-1]='.preinit_array') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_preinit_array
       else if(outputfile.SectionName[i-1]='.note') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_note
       else if(outputfile.SectionName[i-1]='.rel') or (outputfile.SectionName[i-1]='.rel.dyn') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_reloc
       else if(outputfile.SectionName[i-1]='.rela') or (outputfile.SectionName[i-1]='.rela.dyn') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_rela
       else if(outputfile.SectionName[i-1]='.dynsym') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_dynsym
       else if(outputfile.SectionName[i-1]='.symtab') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_symtab
       else if(outputfile.SectionName[i-1]='.dynstr') or (outputfile.SectionName[i-1]='.strtab')
       or (outputfile.SectionName[i-1]='.shstrtab') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_strtab
       else if(outputfile.SectionName[i-1]='.hash') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_hash
       else if(outputfile.SectionName[i-1]='.gnu.hash') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_gnu_hash
       else if(outputfile.SectionName[i-1]='.dynamic') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_dynamic
       else if(outputfile.SectionName[i-1]='.gnu_version') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=
       elf_section_type_gnu_version_symbol
       else if(outputfile.SectionName[i-1]='.gnu_version.r') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=
       elf_section_type_gnu_version_need
       else if(outputfile.SectionName[i-1]='.gnu_version.d') then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=
       elf_section_type_gnu_version_define
       else if(outputfile.SectionAttribute[i-1] and unifile_attribute_note=unifile_attribute_note) then
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_note
       else
       Pelf32_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_progbit;
       if(outputfile.SectionName[i-1]='.dynamic') then
        begin
         Pelf32_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.DynamicStringTableIndex;
        end
       else if(outputfile.SectionName[i-1]='.rela.dyn')
       or(outputfile.SectionName[i-1]='.rel.dyn') then
        begin
         Pelf32_section_header(Content+WritePointer2)^.section_header_info:=
         outputfile.GotIndex;
         Pelf32_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.DynamicSymbolIndex;
        end
       else if(Copy(outputfile.SectionName[i-1],1,6)='.rela.')
       or(Copy(outputfile.SectionName[i-1],1,5)='.rel.') then
        begin
         Pelf32_section_header(Content+WritePointer2)^.section_header_info:=i-1;
         Pelf32_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.SymbolTableIndex;
        end
       else if(outputfile.SectionName[i-1]='.dynsym') then
        begin
         Pelf32_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.DynamicStringTableIndex;
         Pelf32_section_header(Content+WritePointer2)^.section_header_info:=1;
        end
       else if(outputfile.SectionName[i-1]='.symtab') then
        begin
         Pelf32_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.SymbolStringTableIndex;
         Pelf32_section_header(Content+WritePointer2)^.section_header_info:=
         outputfile.SymbolTableLocalCount+1;
        end
       else if(outputfile.SectionName[i-1]='.hash') then
        begin
         Pelf32_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.DynamicSymbolIndex;
        end;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_not_in_file=0) then
        begin
         Move(outputfile.SectionContent[i-1]^,
         (Content+outputfile.SectionOffset[i-1])^,outputfile.SectionSize[i-1]);
        end;
       inc(WritePointer2,sizeof(elf32_section_header));
      end;
    end
   else
    begin
     Move(elf_magic,Pelf64_header(Content)^.elf_id,4);
     Pelf64_header(Content)^.elf_id[elf_class_position]:=elf_class_64;
     Pelf64_header(Content)^.elf_id[elf_data_position]:=elf_data_lsb;
     Pelf64_header(Content)^.elf_id[elf_file_version_position]:=elf_file_version_current;
     Pelf64_header(Content)^.elf_id[elf_os_abi_position]:=basescript.SystemIndex*3;
     Pelf64_header(Content)^.elf_id[elf_abi_version_position]:=0;
     if(basescript.elfclass=unild_class_relocatable) then
     Pelf64_header(Content)^.elf_type:=elf_type_relocatable
     else if(basescript.elfclass=unild_class_sharedobject) then
     Pelf64_header(Content)^.elf_type:=elf_type_dynamic
     else if(basescript.elfclass=unild_class_executable) and (basescript.NoFixedAddress) then
     Pelf64_header(Content)^.elf_type:=elf_type_dynamic
     else if(basescript.elfclass=unild_class_executable) then
     Pelf64_header(Content)^.elf_type:=elf_type_executable
     else if(basescript.elfclass=unild_class_core) then
     Pelf64_header(Content)^.elf_type:=elf_type_core;
     Pelf64_header(Content)^.elf_machine:=outputfile.Architecture;
     Pelf64_header(Content)^.elf_version:=1;
     if(basescript.elfclass<>unild_class_relocatable) then
     Pelf64_header(Content)^.elf_program_header_offset:=sizeof(elf64_header)
     else
     Pelf64_header(Content)^.elf_program_header_offset:=0;
     Pelf64_header(Content)^.elf_section_header_offset:=outputfile.FinalSectionOffset;
     Pelf64_header(Content)^.elf_flags:=outputfile.FileFlag;
     Pelf64_header(Content)^.elf_entry:=outputfile.EntryAddress;
     Pelf64_header(Content)^.elf_header_size:=sizeof(elf64_header);
     if(basescript.elfclass<>unild_class_relocatable) then
      begin
       Pelf64_header(Content)^.elf_program_header_number:=outputfile.FileProgramCount;
       Pelf64_header(Content)^.elf_program_header_size:=sizeof(elf64_program_header);
      end
     else
      begin
       Pelf64_header(Content)^.elf_program_header_number:=0;
       Pelf64_header(Content)^.elf_program_header_size:=sizeof(elf64_program_header);
      end;
     Pelf64_header(Content)^.elf_section_header_number:=outputfile.SectionCount+1;
     Pelf64_header(Content)^.elf_section_header_size:=sizeof(elf64_section_header);
     Pelf64_header(Content)^.elf_section_header_string_table_index:=outputfile.StringTableIndex;
     WritePointer:=sizeof(elf64_header);
     Pelf64_program_header(Content+WritePointer)^.program_offset:=sizeof(elf64_header);
     Pelf64_program_header(Content+WritePointer)^.program_physical_address:=
     outputfile.BaseAddress+sizeof(elf64_header);
     Pelf64_program_header(Content+WritePointer)^.program_file_size:=
     outputfile.FileProgramCount*sizeof(elf64_program_header);
     Pelf64_program_header(Content+WritePointer)^.program_memory_size:=
     outputfile.FileProgramCount*sizeof(elf64_program_header);
     Pelf64_program_header(Content+WritePointer)^.program_align:=8;
     Pelf64_program_header(Content+WritePointer)^.program_virtual_address:=
     outputfile.BaseAddress+sizeof(elf64_header);
     Pelf64_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc;
     Pelf64_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_self;
     inc(WritePointer,sizeof(elf64_program_header));
     if(outputfile.FileProgramCount>0) then
      begin
       i:=1;
       if(outputfile.FileStartAddress<=outputfile.SectionAddress[0]) then
       StartOffset:=outputfile.SectionAddress[0]-outputfile.FileStartAddress
       else
        begin
         writeln('ERROR:Cannot Generate the Program Header for the file '+filename+'.');
         readln;
         halt;
        end;
       StartAddress:=outputfile.BaseAddress; StartOffset:=0;
       PartAlign:=0; PartAttribute:=0;
       while(i<=outputfile.SectionCount)do
        begin
         if(outputfile.FileAlign=0) then
          begin
           if(PartAlign=0) then PartAlign:=outputfile.SectionAlign[i-1]
           else if(outputfile.SectionAlign[i-1]<PartAlign) then PartAlign:=outputfile.SectionAlign[i-1];
          end
         else PartAlign:=outputfile.FileAlign;
         PartAttribute:=(PartAttribute or outputfile.SectionAttribute[i-1])
         and (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage);
         if(ELFBool) and (outputfile.SectionAttribute[i-1]<>0) and
         (StartAddress=outputfile.BaseAddress) and (StartOffset=0) then
          begin
           StartAddress:=outputfile.SectionAddress[i-1];
           StartOffset:=outputfile.SectionOffset[i-1];
          end;
         if(outputfile.SectionAttribute[i-1]<>0) then
          begin
           EndAddress:=outputfile.SectionAddress[i-1]+outputfile.SectionSize[i-1];
           if(outputfile.SectionAttribute[i-1] and unifile_attribute_not_in_file=0) then
           EndOffset:=outputfile.SectionOffset[i-1]+outputfile.SectionSize[i-1]
           else
           EndOffset:=outputfile.SectionOffset[i-1];
          end;
         if(i<outputfile.SectionCount) and
         (outputfile.SectionAttribute[i-1] and
         (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)<>outputfile.SectionAttribute[i]
         and (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)) and
         (outputfile.SectionAttribute[i-1] and
         (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)<>0)then
          begin
           Pelf64_program_header(Content+WritePointer)^.program_offset:=StartOffset;
           Pelf64_program_header(Content+WritePointer)^.program_physical_address:=StartAddress;
           Pelf64_program_header(Content+WritePointer)^.program_file_size:=EndOffset-StartOffset;
           Pelf64_program_header(Content+WritePointer)^.program_memory_size:=EndAddress-StartAddress;
           Pelf64_program_header(Content+WritePointer)^.program_align:=PartAlign;
           Pelf64_program_header(Content+WritePointer)^.program_virtual_address:=StartAddress;
           if(PartAttribute and unifile_attribute_alloc=unifile_attribute_alloc) then
           Pelf64_program_header(Content+WritePointer)^.program_flags:=
           Pelf64_program_header(Content+WritePointer)^.program_flags
           or elf_program_header_alloc;
           if(PartAttribute and unifile_attribute_execute=unifile_attribute_execute) then
           Pelf64_program_header(Content+WritePointer)^.program_flags:=
           Pelf64_program_header(Content+WritePointer)^.program_flags
           or elf_program_header_execute;
           if(PartAttribute and unifile_attribute_write=unifile_attribute_write) then
           Pelf64_program_header(Content+WritePointer)^.program_flags:=
           Pelf64_program_header(Content+WritePointer)^.program_flags
           or elf_program_header_write;
           if(PartAttribute and unifile_attribute_thread_local_storage=
           unifile_attribute_thread_local_storage) then
           Pelf64_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_tls
           else
           Pelf64_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_load;
           inc(WritePointer,sizeof(elf64_program_header));
           StartAddress:=outputfile.BaseAddress;
           StartOffset:=0; PartAttribute:=0; PartAlign:=0; ELFBool:=true;
          end
         else if(i<outputfile.SectionCount) and (outputfile.SectionAttribute[i-1] and
         (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)<>outputfile.SectionAttribute[i]
         and (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage))
         and (outputfile.SectionAttribute[i-1] and
         (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
         or unifile_attribute_thread_local_storage)=0) then
          begin
           StartAddress:=outputfile.BaseAddress;
           StartOffset:=0;
           PartAttribute:=0; PartAlign:=0;
          end;
         if(outputfile.SectionName[i-1]='.interp') then
          begin
           Pelf64_program_header(Content+WritePointer)^.program_offset:=
           outputfile.SectionOffset[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_physical_address:=
           outputfile.SectionAddress[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_file_size:=
           outputfile.SectionSize[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_memory_size:=
           outputfile.SectionSize[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_align:=1;
           Pelf64_program_header(Content+WritePointer)^.program_virtual_address:=
           outputfile.SectionAddress[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc;
           Pelf64_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_interp;
           inc(WritePointer,sizeof(elf64_program_header));
          end;
         if(outputfile.SectionName[i-1]='.dynamic') then
          begin
           Pelf64_program_header(Content+WritePointer)^.program_offset:=
           outputfile.SectionOffset[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_physical_address:=
           outputfile.SectionAddress[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_file_size:=
           outputfile.SectionSize[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_memory_size:=
           outputfile.SectionSize[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_align:=4;
           Pelf64_program_header(Content+WritePointer)^.program_virtual_address:=
           outputfile.SectionAddress[i-1];
           Pelf64_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc;
           Pelf64_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_dynamic;
           inc(WritePointer,sizeof(elf64_program_header));
          end;
         inc(i);
        end;
       Pelf64_program_header(Content+WritePointer)^.program_offset:=0;
       Pelf64_program_header(Content+WritePointer)^.program_physical_address:=0;
       Pelf64_program_header(Content+WritePointer)^.program_file_size:=0;
       Pelf64_program_header(Content+WritePointer)^.program_memory_size:=0;
       Pelf64_program_header(Content+WritePointer)^.program_align:=8;
       Pelf64_program_header(Content+WritePointer)^.program_virtual_address:=0;
       Pelf64_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc
       or elf_program_header_write;
       if(basescript.NoExecutableStack=false) then
       Pelf64_program_header(Content+WritePointer)^.program_flags:=
       Pelf64_program_header(Content+WritePointer)^.program_flags or elf_program_header_execute;
       Pelf64_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_gnu_stack;
       inc(WritePointer,sizeof(elf64_program_header));
       if(basescript.GotAuthority>0) and (outputfile.GotIndex>0) then
        begin
         Pelf64_program_header(Content+WritePointer)^.program_offset:=
         outputfile.SectionOffset[outputfile.GotIndex-1];
         Pelf64_program_header(Content+WritePointer)^.program_physical_address:=
         outputfile.SectionAddress[outputfile.GotIndex-1];
         Pelf64_program_header(Content+WritePointer)^.program_file_size:=
         outputfile.SectionSize[outputfile.GotIndex-1];
         Pelf64_program_header(Content+WritePointer)^.program_memory_size:=
         outputfile.SectionSize[outputfile.GotIndex-1];
         Pelf64_program_header(Content+WritePointer)^.program_align:=8;
         Pelf64_program_header(Content+WritePointer)^.program_virtual_address:=
         outputfile.SectionAddress[outputfile.GotIndex-1];
         Pelf64_program_header(Content+WritePointer)^.program_flags:=elf_program_header_alloc;
         if(basescript.GotAuthority=1) then
         Pelf64_program_header(Content+WritePointer)^.program_flags:=
         Pelf64_program_header(Content+WritePointer)^.program_flags or elf_program_header_write;
         Pelf64_program_header(Content+WritePointer)^.program_type:=elf_program_header_type_gnu_relro;
         inc(WritePointer,sizeof(elf64_program_header));
        end;
      end;
     i:=1; WritePointer2:=outputfile.FinalSectionOffset+sizeof(elf64_section_header);
     for i:=1 to outputfile.SectionCount do
      begin
       Pelf64_section_header(Content+WritePointer2)^.section_header_name:=
       outputfile.SectionNameIndex[i-1];
       Pelf64_section_header(Content+WritePointer2)^.section_header_address:=
       outputfile.SectionAddress[i-1];
       Pelf64_section_header(Content+WritePointer2)^.section_header_address_align:=
       outputfile.SectionAlign[i-1];
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_alloc=unifile_attribute_alloc) then
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_alloc;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_execute=unifile_attribute_execute) then
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_executable;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_write=unifile_attribute_write) then
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_write;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_thread_local_storage=
       unifile_attribute_thread_local_storage) then
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_tls;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_information=
       unifile_attribute_information) then
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags:=
       Pelf64_section_header(Content+WritePointer2)^.section_header_flags or elf_section_flag_info_link;
       if(outputfile.SectionName[i-1]='.rela') or (outputfile.SectionName[i-1]='.rela.dyn') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_entry_size:=24
       else if(outputfile.SectionName[i-1]='.rel') or (outputfile.SectionName[i-1]='.rel.dyn') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_entry_size:=16
       else if(outputfile.SectionName[i-1]='.dynsym') or (outputfile.SectionName[i-1]='.symtab')
       or(outputfile.SectionName[i-1]='.gnu_version') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_entry_size:=
       sizeof(elf64_symbol_table_entry)
       else if(outputfile.SectionName[i-1]='.init_array')
       or(outputfile.SectionName[i-1]='.preinit_array')or(outputfile.SectionName[i-1]='.fini_array') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_entry_size:=8
       else if(outputfile.SectionName[i-1]='.dynamic') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_entry_size:=16
       else if(outputfile.SectionName[i-1]='.gnu_version.d') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_entry_size:=
       sizeof(elf64_version_definition_section)
       else if(outputfile.SectionName[i-1]='.gnu_version.r') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_entry_size:=
       sizeof(elf64_version_needed_section)
       else
       Pelf64_section_header(Content+WritePointer2)^.section_header_entry_size:=0;
       Pelf64_section_header(Content+WritePointer2)^.section_header_size:=outputfile.SectionSize[i-1];
       Pelf64_section_header(Content+WritePointer2)^.section_header_offset:=outputfile.SectionOffset[i-1];
       if(outputfile.SectionName[i-1]='.bss') or (outputfile.SectionName[i-1]='.tbss')
       or(outputfile.SectionAttribute[i-1] and
       unifile_attribute_not_in_file=unifile_attribute_not_in_file) then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_nobit
       else if(outputfile.SectionName[i-1]='.init_array') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_init_array
       else if(outputfile.SectionName[i-1]='.fini_array') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_fini_array
       else if(outputfile.SectionName[i-1]='.preinit_array') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_preinit_array
       else if(outputfile.SectionName[i-1]='.note') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_note
       else if(outputfile.SectionName[i-1]='.rel') or (outputfile.SectionName[i-1]='.rel.dyn') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_reloc
       else if(outputfile.SectionName[i-1]='.rela') or (outputfile.SectionName[i-1]='.rela.dyn') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_rela
       else if(outputfile.SectionName[i-1]='.dynsym') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_dynsym
       else if(outputfile.SectionName[i-1]='.symtab') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_symtab
       else if(outputfile.SectionName[i-1]='.dynstr') or (outputfile.SectionName[i-1]='.strtab')
       or (outputfile.SectionName[i-1]='.shstrtab') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_strtab
       else if(outputfile.SectionName[i-1]='.hash') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_hash
       else if(outputfile.SectionName[i-1]='.gnu.hash') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_gnu_hash
       else if(outputfile.SectionName[i-1]='.dynamic') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_dynamic
       else if(outputfile.SectionName[i-1]='.gnu_version') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=
       elf_section_type_gnu_version_symbol
       else if(outputfile.SectionName[i-1]='.gnu_version.r') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=
       elf_section_type_gnu_version_need
       else if(outputfile.SectionName[i-1]='.gnu_version.d') then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=
       elf_section_type_gnu_version_define
       else if(outputfile.SectionAttribute[i-1] and unifile_attribute_note=unifile_attribute_note) then
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_note
       else
       Pelf64_section_header(Content+WritePointer2)^.section_header_type:=elf_section_type_progbit;
       if(outputfile.SectionName[i-1]='.dynamic') then
        begin
         Pelf64_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.DynamicStringTableIndex;
        end
       else if(outputfile.SectionName[i-1]='.rela.dyn')
       or(outputfile.SectionName[i-1]='.rel.dyn') then
        begin
         Pelf64_section_header(Content+WritePointer2)^.section_header_info:=
         outputfile.GotIndex;
         Pelf64_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.DynamicSymbolIndex;
        end
       else if(Copy(outputfile.SectionName[i-1],1,6)='.rela.')
       or(Copy(outputfile.SectionName[i-1],1,5)='.rel.') then
        begin
         Pelf64_section_header(Content+WritePointer2)^.section_header_info:=i-1;
         Pelf64_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.SymbolTableIndex;
        end
       else if(outputfile.SectionName[i-1]='.dynsym') then
        begin
         Pelf64_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.DynamicStringTableIndex;
         Pelf64_section_header(Content+WritePointer2)^.section_header_info:=1;
        end
       else if(outputfile.SectionName[i-1]='.symtab') then
        begin
         Pelf64_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.SymbolStringTableIndex;
         Pelf64_section_header(Content+WritePointer2)^.section_header_info:=
         outputfile.SymbolTableLocalCount+1;
        end
       else if(outputfile.SectionName[i-1]='.hash') then
        begin
         Pelf64_section_header(Content+WritePointer2)^.section_header_link:=
         outputfile.DynamicSymbolIndex;
        end;
       if(outputfile.SectionAttribute[i-1] and unifile_attribute_not_in_file=0) then
        begin
         Move(outputfile.SectionContent[i-1]^,
         (Content+outputfile.SectionOffset[i-1])^,outputfile.SectionSize[i-1]);
        end;
       inc(WritePointer2,sizeof(elf64_section_header));
      end;
    end;
  end
 else if(fileclass=unifile_class_pe_file) then
  begin
   if(outputfile.Bits=32) then
    begin
     Ppe_dos_header(Content)^.MagicNumber:='MZ';
     Ppe_dos_header(Content)^.FileAddressOfNewExeHeader:=sizeof(pe_dos_header)+64;
     Move(pe_dos_code,Pbyte(Content+sizeof(pe_dos_header))^,64);
     inc(WritePointer,sizeof(pe_dos_header)+64);
     Ppe_image_header(Content+WritePointer)^.signature:='PE';
     if(outputfile.Architecture=elf_machine_386) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Machine:=pe_image_file_machine_i386
     else if(outputfile.Architecture=elf_machine_arm) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Machine:=pe_image_file_machine_arm
     else if(outputfile.Architecture=elf_machine_riscv) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Machine:=pe_image_file_machine_riscv64
     else if(outputfile.Architecture=elf_machine_loongarch) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Machine:=pe_image_file_machine_loongarch64;
     if(basescript.NoSymbol) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Characteristics:=
     pe_image_file_characteristics_executable_image or pe_image_file_characteristics_debug_stripped
     or pe_image_file_characteristics_symbol_stripped
     else
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Characteristics:=
     pe_image_file_characteristics_executable_image or pe_image_file_characteristics_debug_stripped
     or pe_image_file_characteristics_symbol_stripped;
     Ppe_image_header(Content+WritePointer)^.ImageHeader.NumberOfSections:=outputfile.SectionCount;
     Ppe_image_header(Content+WritePointer)^.ImageHeader.TimeDateStamp:=unifile_calculate_timestamp;
     Ppe_image_header(Content+WritePointer)^.ImageHeader.PointerToSymbolTable:=
     outputfile.FinalSectionOffset;
     Ppe_image_header(Content+WritePointer)^.ImageHeader.NumberOfSymbols:=
     outputfile.CoffSymbolTableSize div sizeof(coff_symbol_table_item);
     Ppe_image_header(Content+WritePointer)^.ImageHeader.SizeOfOptionalHeader:=
     sizeof(coff_optional_image_header32)+6*sizeof(pe_data_directory);
     if(basescript.EFIFileIndex=unild_class_rom) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.MagicNumber:=pe_image_rom
     else
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.MagicNumber:=pe_image_pe32;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.AddressOfEntryPoint:=
     outputfile.EntryAddress;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.ImageBase:=
     basescript.BaseAddress;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.BaseOfCode:=
     outputfile.BaseOfCode;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.BaseOfData:=
     outputfile.BaseOfData;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SizeOfCode:=
     outputfile.SizeofCode;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SizeOfInitializedData:=
     outputfile.SizeofInitializedData;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SizeOfUnInitializedData:=
     outputfile.SizeofUninitializedData;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.MinorLinkerVersion:=3;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.MinorImageVersion:=1;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.MinorOperatingSystemVersion:=1;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.MinorSubSystemVersion:=1;
     if(basescript.EFIFileIndex=unild_class_application) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SubSystem:=
     pe_image_subsystem_efi_application
     else if(basescript.EFIFileIndex=unild_class_bootdriver) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SubSystem:=
     pe_image_subsystem_efi_boot_service_driver
     else if(basescript.EFIFileIndex=unild_class_runtimedriver) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SubSystem:=
     pe_image_subsystem_efi_runtime_service_driver
     else if(basescript.EFIFileIndex=unild_class_rom) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SubSystem:=
     pe_image_subsystem_efi_rom;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.DLLCharacteristics:=
     pe_image_dll_characteristics_dynamic_base;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.FileAlignment:=outputfile.FileAlign;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SectionAlignment:=outputfile.FileAlign;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SizeOfHeaders:=
     unifile_align(sizeof(pe_dos_header)+$40+4+
     sizeof(coff_image_header)+sizeof(coff_optional_image_header32)+
     sizeof(pe_data_directory)*6,basescript.FileAlign);
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.SizeOfImage:=
     outputfile.FinalFileSize;
     inc(WritePointer,4+sizeof(coff_image_header)+sizeof(coff_optional_image_header32)+
     sizeof(pe_data_directory)*5);
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.NumberOfRvaAndSizes:=6;
     Ppe_data_directory(Content+WritePointer)^.Size:=
     outputfile.SectionSize[outputfile.RelocationIndex-1];
     Ppe_data_directory(Content+WritePointer)^.VirtualAddress:=
     outputfile.SectionAddress[outputfile.RelocationIndex-1]-basescript.BaseAddress;
     inc(WritePointer,sizeof(pe_data_directory));
     for i:=1 to outputfile.SectionCount do
      begin
       Ppe_image_section_header(Content+WritePointer)^.Name:=
       outputfile.SectionName[i-1];
       Ppe_image_section_header(Content+WritePointer)^.VirtualAddress:=
       outputfile.SectionAddress[i-1]-basescript.BaseAddress;
       Ppe_image_section_header(Content+WritePointer)^.VirtualSize:=
       outputfile.SectionSize[i-1];
       Ppe_image_section_header(Content+WritePointer)^.PointerToRawData:=
       outputfile.SectionOffset[i-1];
       if(outputfile.SectionAttribute[i-1]
       and unifile_attribute_not_in_file=
       unifile_attribute_not_in_file) then
       Ppe_image_section_header(Content+WritePointer)^.SizeOfRawData:=0
       else
       Ppe_image_section_header(Content+WritePointer)^.SizeOfRawData:=
       outputfile.SectionSize[i-1];
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_alloc=unifile_attribute_alloc) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_memory_read;
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_execute=unifile_attribute_execute) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_memory_execute;
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_write=unifile_attribute_write) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_memory_write;
       if(outputfile.SectionAttribute[i-1] and
       (unifile_attribute_alloc or unifile_attribute_execute)=
       (unifile_attribute_alloc or unifile_attribute_execute)) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_type_code;
       if(outputfile.SectionAttribute[i-1] and
       (unifile_attribute_alloc or unifile_attribute_write)=
       (unifile_attribute_alloc or unifile_attribute_write)) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_initialized_data;
       if(outputfile.SectionName[i-1]='.reloc') then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_initialized_data or
       pe_image_section_characteristics_memory_discardable;
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_not_in_file=
       unifile_attribute_not_in_file) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_uninitialized_data;
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_not_in_file=0) then
       Move(outputfile.SectionContent[i-1]^,
       (Content+outputfile.SectionOffset[i-1])^,
       outputfile.SectionSize[i-1]);
       inc(WritePointer,sizeof(pe_image_section_header));
      end;
     Move(outputfile.CoffSymbolTableContent^,
     Pbyte(Content+outputfile.FinalSectionOffset)^,outputfile.CoffSymbolTableSize);
     Move(outputfile.CoffStringTableContent^,
     Pbyte(Content+outputfile.FinalSectionOffset+outputfile.CoffSymbolTableSize)^,
     outputfile.CoffStringTableSize);
     WritePointer:=sizeof(pe_dos_header)+64;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader32.CheckSum:=
     pe_calculate_checksum(Content,outputfile.FinalFileSize);
    end
   else
    begin
     Ppe_dos_header(Content)^.MagicNumber:='MZ';
     Ppe_dos_header(Content)^.FileAddressOfNewExeHeader:=sizeof(pe_dos_header)+64;
     Move(pe_dos_code,Pbyte(Content+sizeof(pe_dos_header))^,64);
     inc(WritePointer,sizeof(pe_dos_header)+64);
     Ppe_image_header(Content+WritePointer)^.signature:='PE';
     if(outputfile.Architecture=elf_machine_x86_64) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Machine:=pe_image_file_machine_amd64
     else if(outputfile.Architecture=elf_machine_aarch64) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Machine:=pe_image_file_machine_arm64
     else if(outputfile.Architecture=elf_machine_riscv) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Machine:=pe_image_file_machine_riscv64
     else if(outputfile.Architecture=elf_machine_loongarch) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Machine:=pe_image_file_machine_loongarch64;
     if(basescript.NoSymbol) then
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Characteristics:=
     pe_image_file_characteristics_executable_image
     or pe_image_file_characteristics_line_number_stripped
     or pe_image_file_characteristics_debug_stripped
     or pe_image_file_characteristics_symbol_stripped
     or pe_image_file_characteristics_large_address_aware
     else
     Ppe_image_header(Content+WritePointer)^.ImageHeader.Characteristics:=
     pe_image_file_characteristics_executable_image
     or pe_image_file_characteristics_line_number_stripped
     or pe_image_file_characteristics_debug_stripped
     or pe_image_file_characteristics_large_address_aware;
     Ppe_image_header(Content+WritePointer)^.ImageHeader.NumberOfSections:=outputfile.SectionCount;
     Ppe_image_header(Content+WritePointer)^.ImageHeader.TimeDateStamp:=unifile_calculate_timestamp;
     Ppe_image_header(Content+WritePointer)^.ImageHeader.PointerToSymbolTable:=
     outputfile.FinalSectionOffset;
     Ppe_image_header(Content+WritePointer)^.ImageHeader.NumberOfSymbols:=
     outputfile.CoffSymbolTableSize div sizeof(coff_symbol_table_item);
     Ppe_image_header(Content+WritePointer)^.ImageHeader.SizeOfOptionalHeader:=
     sizeof(coff_optional_image_header64)+6*sizeof(pe_data_directory);
     if(basescript.EFIFileIndex=unild_class_rom) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.MagicNumber:=pe_image_rom
     else
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.MagicNumber:=pe_image_pe32plus;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.AddressOfEntryPoint:=
     outputfile.EntryAddress;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.ImageBase:=
     basescript.BaseAddress;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.BaseOfCode:=
     outputfile.BaseOfCode;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SizeOfCode:=
     outputfile.SizeofCode;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SizeOfInitializedData:=
     outputfile.SizeofInitializedData;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SizeOfUnInitializedData:=
     outputfile.SizeofUninitializedData;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.MinorLinkerVersion:=3;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.MinorImageVersion:=1;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.MinorOperatingSystemVersion:=1;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.MinorSubSystemVersion:=1;
     if(basescript.EFIFileIndex=unild_class_application) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SubSystem:=
     pe_image_subsystem_efi_application
     else if(basescript.EFIFileIndex=unild_class_bootdriver) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SubSystem:=
     pe_image_subsystem_efi_boot_service_driver
     else if(basescript.EFIFileIndex=unild_class_runtimedriver) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SubSystem:=
     pe_image_subsystem_efi_runtime_service_driver
     else if(basescript.EFIFileIndex=unild_class_rom) then
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SubSystem:=
     pe_image_subsystem_efi_rom;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.DLLCharacteristics:=
     pe_image_dll_characteristics_dynamic_base or
     pe_image_dll_characteristics_high_entropy_virtual_address;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.FileAlignment:=outputfile.FileAlign;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SectionAlignment:=outputfile.FileAlign;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SizeOfHeaders:=
     unifile_align(sizeof(pe_dos_header)+$40+4+
     sizeof(coff_image_header)+sizeof(coff_optional_image_header64)+
     sizeof(pe_data_directory)*6,basescript.FileAlign);
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.NumberOfRvaAndSizes:=6;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.SizeOfImage:=
     outputfile.FinalFileSize;
     inc(WritePointer,4+sizeof(coff_image_header)+sizeof(coff_optional_image_header64)+
     sizeof(pe_data_directory)*5);
     Ppe_data_directory(Content+WritePointer)^.Size:=
     outputfile.SectionSize[outputfile.RelocationIndex-1];
     Ppe_data_directory(Content+WritePointer)^.VirtualAddress:=
     outputfile.SectionAddress[outputfile.RelocationIndex-1]-basescript.BaseAddress;
     inc(WritePointer,sizeof(pe_data_directory));
     for i:=1 to outputfile.SectionCount do
      begin
       Ppe_image_section_header(Content+WritePointer)^.Name:=
       outputfile.SectionName[i-1];
       Ppe_image_section_header(Content+WritePointer)^.VirtualAddress:=
       outputfile.SectionAddress[i-1]-basescript.BaseAddress;
       if(outputfile.SectionName[i-1]<>'.reloc') then
       Ppe_image_section_header(Content+WritePointer)^.VirtualSize:=
       unifile_align(outputfile.SectionSize[i-1],outputfile.FileAlign)
       else
       Ppe_image_section_header(Content+WritePointer)^.VirtualSize:=outputfile.SectionSize[i-1];
       Ppe_image_section_header(Content+WritePointer)^.PointerToRawData:=
       outputfile.SectionOffset[i-1];
       if(outputfile.SectionAttribute[i-1]
       and unifile_attribute_not_in_file=
       unifile_attribute_not_in_file) then
       Ppe_image_section_header(Content+WritePointer)^.SizeOfRawData:=0
       else
       Ppe_image_section_header(Content+WritePointer)^.SizeOfRawData:=
       outputfile.SectionSize[i-1];
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_alloc=unifile_attribute_alloc) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_memory_read;
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_execute=unifile_attribute_execute) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_memory_execute;
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_write=unifile_attribute_write) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_memory_write;
       if(outputfile.SectionAttribute[i-1] and
       (unifile_attribute_alloc or unifile_attribute_execute)=
       (unifile_attribute_alloc or unifile_attribute_execute)) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_type_code;
       if(outputfile.SectionAttribute[i-1] and
       (unifile_attribute_alloc or unifile_attribute_write)=
       (unifile_attribute_alloc or unifile_attribute_write)) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_initialized_data;
       if(outputfile.SectionName[i-1]='.reloc') then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_initialized_data or
       pe_image_section_characteristics_memory_discardable;
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_not_in_file=
       unifile_attribute_not_in_file) then
       Ppe_image_section_header(Content+WritePointer)^.Characteristics:=
       Ppe_image_section_header(Content+WritePointer)^.Characteristics or
       pe_image_section_characteristics_uninitialized_data;
       if(outputfile.SectionAttribute[i-1] and
       unifile_attribute_not_in_file=0) then
       Move(outputfile.SectionContent[i-1]^,
       (Content+outputfile.SectionOffset[i-1])^,outputfile.SectionSize[i-1]);
       inc(WritePointer,sizeof(pe_image_section_header));
      end;
     Move(outputfile.CoffSymbolTableContent^,
     Pbyte(Content+outputfile.FinalSectionOffset)^,outputfile.CoffSymbolTableSize);
     Move(outputfile.CoffStringTableContent^,
     Pbyte(Content+outputfile.FinalSectionOffset+outputfile.CoffSymbolTableSize)^,
     outputfile.CoffStringTableSize);
     WritePointer:=sizeof(pe_dos_header)+64;
     Ppe_image_header(Content+WritePointer)^.OptionalHeader64.CheckSum:=
     pe_calculate_checksum(Content,outputfile.FinalFileSize);
    end;
  end
 else if(fileclass=unifile_class_binary_file) then
  begin
   for i:=1 to outputfile.SectionCount do
    begin
     if(outputfile.SectionSize[i-1]<>0) then
     Move(outputfile.SectionContent[i-1]^,
     (Content+outputfile.SectionOffset[i-1])^,outputfile.SectionSize[i-1]);
    end;
  end;
 if(FileExists(filename)) then DeleteFile(filename);
 fs:=TFileStream.Create(filename,fmCreate);
 fs.Write(Content^,outputfile.FinalFileSize);
 fs.Free;
 FreeMem(content);
end;
procedure unifile_convert_file_to_final(var basefile:unifile_linked_file_stage;
var basescript:unild_script;filename:string;fileclass:byte);
var finalfile:unifile_file_final;
    {For Handle the file}
    i,j,k,m,n,a,b,c,d,e:SizeUint;
    tempstr1:string;
    InclineSwitch:boolean;
    {For ELF File}
    DynamicCount:SizeUint;
    DynamicBool,GotBool,InitialBool,InitialArrayBool,FinalBool,FinalArrayBool:boolean;
    SymbolVersionBool:boolean;
    PreInitialArrayBool:boolean;
    GotPltOffset:byte;
    tempstr:string;
    DynamicStringTableSize,WritePointer1,WritePointer2:SizeUint;
    HashTableItem:Dword;
    HashTable:unifile_file_hash_table;
    StringTableSize:SizeUint;
    StartOffset:SizeUint;
    ProgramHeaderCount:word;
    Address:SizeUint;
    Offset:SizeUint;
    RelocatableFileRelaCount:SizeUint;
    RelocationSwitch:boolean;
    GotInternalIndex:SizeUint;
    {For Part Segment}
    SegmentIndex:array of SizeUint;
    SegmentAlter:array of boolean;
    SegmentAlterSignal:boolean;
    SegmentCount:SizeUint;
    {For Base File Index to Final File Index}
    SectionIndex:array of word;
    {For PE Relocation Only}
    PEBaseAddress:SizeUint;
    PERelocationSize:SizeUint;
    {For Relocation Parameters}
    OriginalAddress,GoalAddress:SizeUint;
    {For Relocation Only}
    ChangePointer:Pointer;
    ChangeValue:SizeInt;
    d1,d2,d3,d4,d5,d6,d7,d8,d9,d10:dword;
    q1:qword;
    {For Relocation in Relocatable File Only}
    AllSectionOffset:array of SizeUint;
    {For Additional Symbols}
    SectionStart,SectionCount:SizeUint;
    {For Interpreter Information}
    InterpreterInfo:unifile_elf_interpreter;
    {For Got Alias Symbol Index and Dynamic Alias Symbol Index}
    GOTSymbolIndex,DynamicSymbolIndex:SizeUint;
    {For Dynamic Library}
    NeedDynamicLibraryTotal:boolean=false;
    DynamicLibraryTotal:unifile_elf_dynamic_library_total;
    {For GOT Address}
    GotAddress:SizeUint;
    GotProtect:byte=1;
    {For Temporary Results}
    FileValue:unifile_check_result;
    FileResult:unifile_result;
    FileList:unifile_check_needed_list;
label SkipGot;
begin
 {Initialization of the software}
 DynamicBool:=false; GotBool:=false; GotPltOffset:=0;
 SectionStart:=0; SectionCount:=0; GotSymbolIndex:=0; DynamicSymbolIndex:=0;
 finalfile.CoffSymbolTableContent:=nil; finalfile.CoffStringTableContent:=nil; FileList.NeedCount:=0;
 {Check the interpreter vaild}
 if(basescript.Interpreter<>'') then
 InterpreterInfo:=unifile_check_interpreter(basescript.Interpreter,basefile.Bits,basefile.Architecture,
 basescript);
 {Initialize the Final File}
 finalfile.SectionCount:=0; finalfile.FileFlag:=basefile.FileFlag;
 finalfile.Architecture:=basefile.Architecture; finalfile.Bits:=basefile.Bits;
 finalfile.SymbolTable.SymbolCount:=0; finalfile.DynamicSymbolTable.SymbolCount:=0;
 finalfile.GotTableList.GotCount:=0; finalfile.GotTableList.GotCountOriginal:=0;
 finalfile.CoffListCount:=0; finalfile.CoffListSpecialize:=false; finalfile.RelocationIndex:=0;
 RelocatableFileRelaCount:=0;
 if(fileclass=unifile_class_elf_file) and (basescript.elfclass=unild_class_relocatable) then goto SkipGot;
 {Then Check the Got Table}
 i:=1;
 while(i<=basefile.AdjustTable.Count)do
  begin
   FileValue:=unifile_check_relocation(basefile.Architecture,basefile.Bits,
   basefile.AdjustTable.AdjustType[i-1],basefile.AdjustTable.GoalSectionIndex[i-1]<>0);
   if(FileValue.GotBool) then inc(finalfile.GotTableList.GotCountOriginal);
   if((FileValue.NeedRelocationBits=finalfile.Bits) and (basescript.NoFixedAddress)
   and(basefile.SectionAttribute[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]<>0) and
   (fileclass=unifile_class_elf_file) and (basescript.elfclass<>unild_class_relocatable))
   or((FileValue.NeedRelocationBits>0) and (fileclass=unifile_class_pe_file))
   then inc(FileList.NeedCount);
   inc(i);
  end;
 SetLength(FileList.NeedAddress,FileList.NeedCount);
 SetLength(FileList.NeedBits,FileList.NeedCount);
 SetLength(finalfile.GotTableList.GotHashList,finalfile.GotTableList.GotCountOriginal);
 {Initialize the Original Got Table}
 finalfile.GotTableList.GotHashOriginal.BucketCount:=
 unifile_hash_table_bucket_count(finalfile.GotTableList.GotCountOriginal);
 SetLength(finalfile.GotTableList.GotHashOriginal.BucketEnable,
 finalfile.GotTableList.GotHashOriginal.BucketCount+1);
 SetLength(finalfile.GotTableList.GotHashOriginal.BucketItem,
 finalfile.GotTableList.GotHashOriginal.BucketCount+1);
 SetLength(finalfile.GotTableList.GotHashOriginal.BucketHash,
 finalfile.GotTableList.GotHashOriginal.BucketCount+1);
 finalfile.GotTableList.GotHashOriginal.ChainCount:=finalfile.GotTableList.GotCountOriginal;
 SetLength(finalfile.GotTableList.GotHashOriginal.ChainEnable,
 finalfile.GotTableList.GotHashOriginal.ChainCount+1);
 SetLength(finalfile.GotTableList.GotHashOriginal.ChainItem,
 finalfile.GotTableList.GotHashOriginal.ChainCount+1);
 SetLength(finalfile.GotTableList.GotHashOriginal.ChainHash,
 finalfile.GotTableList.GotHashOriginal.ChainCount+1);
 {Then Generate the Original Got Table}
 i:=1; k:=1; m:=1;
 while(i<=basefile.AdjustTable.Count)do
  begin
   FileValue:=unifile_check_relocation(basefile.Architecture,basefile.Bits,
   basefile.AdjustTable.AdjustType[i-1],basefile.AdjustTable.GoalSectionIndex[i-1]<>0);
   if(FileValue.GotBool) then
    begin
     InclineSwitch:=false;
     j:=basefile.AdjustTable.AdjustHash[i-1] mod finalfile.GotTableList.GotHashOriginal.BucketCount+1;
     if(finalfile.GotTableList.GotHashOriginal.BucketEnable[j]=false) then
      begin
       finalfile.GotTableList.GotHashOriginal.BucketEnable[j]:=true;
       finalfile.GotTableList.GotHashOriginal.BucketItem[j]:=m;
       finalfile.GotTableList.GotHashOriginal.BucketHash[j]:=basefile.AdjustTable.AdjustHash[i-1];
       InclineSwitch:=true;
      end
     else
      begin
       k:=0;
       if(finalfile.GotTableList.GotHashOriginal.BucketHash[j]=basefile.AdjustTable.AdjustHash[i-1])
       then k:=1;
       j:=finalfile.GotTableList.GotHashOriginal.BucketItem[j];
       while(finalfile.GotTableList.GotHashOriginal.ChainEnable[j])do
        begin
         if(finalfile.GotTableList.GotHashOriginal.ChainHash[j]=basefile.AdjustTable.AdjustHash[i-1])
         then k:=1;
         j:=finalfile.GotTableList.GotHashOriginal.ChainItem[j];
        end;
       if(k=0) then InclineSwitch:=true;
       finalfile.GotTableList.GotHashOriginal.ChainEnable[j]:=true;
       finalfile.GotTableList.GotHashOriginal.ChainItem[j]:=m;
       finalfile.GotTableList.GotHashOriginal.ChainHash[j]:=basefile.AdjustTable.AdjustHash[i-1];
      end;
     if(InclineSwitch) then inc(finalfile.GotTableList.GotCount);
     finalfile.GotTableList.GotHashList[m-1]:=basefile.AdjustTable.AdjustHash[i-1];
     inc(m);
    end;
   inc(i);
  end;
 SetLength(finalfile.GotTableList.GotEnable,finalfile.GotTableList.GotCountOriginal);
 {Initialize the GOT Table}
 finalfile.GotTableList.GotHashTable.BucketCount:=
 unifile_hash_table_bucket_count(finalfile.GotTableList.GotCount);
 SetLength(finalfile.GotTableList.GotHashTable.BucketEnable,
 finalfile.GotTableList.GotHashTable.BucketCount+1);
 SetLength(finalfile.GotTableList.GotHashTable.BucketItem,
 finalfile.GotTableList.GotHashTable.BucketCount+1);
 SetLength(finalfile.GotTableList.GotHashTable.BucketHash,
 finalfile.GotTableList.GotHashTable.BucketCount+1);
 finalfile.GotTableList.GotHashTable.ChainCount:=finalfile.GotTableList.GotCount;
 SetLength(finalfile.GotTableList.GotHashTable.ChainEnable,
 finalfile.GotTableList.GotHashTable.ChainCount+1);
 SetLength(finalfile.GotTableList.GotHashTable.ChainItem,
 finalfile.GotTableList.GotHashTable.ChainCount+1);
 SetLength(finalfile.GotTableList.GotHashTable.ChainHash,
 finalfile.GotTableList.GotHashTable.ChainCount+1);
 {Now generate the final GOT table}
 SetLength(finalfile.GotTableList.GotHash,finalfile.GotTableList.GotCount);
 i:=1; j:=1; m:=1; n:=1;
 while(i<=finalfile.GotTableList.GotCountOriginal)do
  begin
   k:=unifile_search_for_hash_table(finalfile.GotTableList.GotHashOriginal,
   finalfile.GotTableList.GotHashList[i-1]);
   if(finalfile.GotTableList.GotEnable[k-1]=false) then
    begin
     finalfile.GotTableList.GotEnable[k-1]:=true;
     finalfile.GotTableList.GotHash[j-1]:=finalfile.GotTableList.GotHashList[i-1];
     m:=finalfile.GotTableList.GotHashList[i-1] mod finalfile.GotTableList.GotHashTable.BucketCount+1;
     if(finalfile.GotTableList.GotHashTable.BucketEnable[m]=false) then
      begin
       finalfile.GotTableList.GotHashTable.BucketEnable[m]:=true;
       finalfile.GotTableList.GotHashTable.BucketItem[m]:=j;
       finalfile.GotTableList.GotHashTable.BucketHash[m]:=finalfile.GotTableList.GotHash[j-1];
      end
     else
      begin
       m:=finalfile.GotTableList.GotHashTable.BucketItem[m];
       while(finalfile.GotTableList.GotHashTable.ChainEnable[m])do
       m:=finalfile.GotTableList.GotHashTable.ChainItem[m];
       finalfile.GotTableList.GotHashTable.ChainEnable[m]:=true;
       finalfile.GotTableList.GotHashTable.ChainItem[m]:=j;
       finalfile.GotTableList.GotHashTable.ChainHash[m]:=finalfile.GotTableList.GotHash[j-1];
      end;
     inc(j);
    end;
   inc(i);
  end;
 SetLength(finalfile.GotTableList.GotHashEnable,finalfile.GotTableList.GotCount);
 SkipGot:
 if(finalfile.GotTableList.GotCount>0) then GotProtect:=0;
 {Then Generate the Sections Now}
 finalfile.DynamicIndex:=0; finalfile.DynamicStringTableIndex:=0;
 finalfile.InterpreterIndex:=0; finalfile.DynamicSymbolIndex:=0;
 finalfile.RelocationDynamicTableIndex:=0; finalfile.HashTableIndex:=0; finalfile.GotIndex:=0;
 finalfile.SymbolTableIndex:=0; finalfile.SymbolStringTableIndex:=0; finalfile.StringTableIndex:=0;
 i:=1; j:=1; SegmentCount:=0; SegmentAlterSignal:=false;
 SetLength(SegmentIndex,basefile.SectionCount);
 SetLength(SegmentAlter,basefile.SectionCount);
 while(i<=basefile.SectionCount)do
  begin
   if(basefile.SectionVaild[i-1]) then
    begin
     inc(SegmentCount);
     SegmentIndex[SegmentCount-1]:=i;
     SegmentAlter[SegmentCount-1]:=i=basefile.SectionCount;
     SegmentAlterSignal:=true;
     if(SegmentCount>1) and (basefile.SectionAttribute[SegmentIndex[SegmentCount-2]-1]<>
     basefile.SectionAttribute[i-1]) then SegmentAlter[SegmentCount-2]:=true;
    end
   else if(SegmentAlterSignal) then
    begin
     SegmentAlter[SegmentCount-1]:=true;
     SegmentAlterSignal:=false;
    end;
   inc(i);
  end;
 {Then generate the Empty Section}
 i:=1; j:=1; k:=1; a:=1; finalfile.SectionCount:=0;
 SetLength(SectionIndex,basefile.SectionCount+basescript.SectionCountExtra);
 while(i<=basefile.SectionCount)do
  begin
   if(i=1) and (fileclass=unifile_class_elf_file) and (basescript.Interpreter<>'') then
    begin
     SetLength(finalfile.SectionName,j);
     finalfile.SectionName[j-1]:='.interp';
     SetLength(finalfile.SectionAttribute,j);
     finalfile.SectionAttribute[j-1]:=unifile_attribute_alloc;
     SetLength(finalfile.SectionAddress,j);
     finalfile.SectionAddress[j-1]:=0;
     SetLength(finalfile.SectionAlign,j);
     finalfile.SectionAlign[j-1]:=1;
     SetLength(finalfile.SectionContent,j);
     finalfile.SectionContent[j-1]:=allocmem(length(basescript.Interpreter)+1);
     m:=1;
     while(m<=length(basescript.Interpreter))do
      begin
       PChar(finalfile.SectionContent[j-1]+m-1)^:=basescript.Interpreter[m];
       inc(m);
      end;
     SetLength(finalfile.SectionSize,j);
     finalfile.SectionSize[j-1]:=length(basescript.Interpreter)+1;
     finalfile.SectionCount:=j;
     finalfile.InterpreterIndex:=j;
     inc(j);
    end;
   if(i=1) and (fileclass=unifile_class_elf_file) and (basescript.elfclass<>unild_class_relocatable)
   and(basescript.NoFixedAddress) then
    begin
     SetLength(finalfile.SectionName,j);
     finalfile.SectionName[j-1]:='.hash';
     SetLength(finalfile.SectionAttribute,j);
     finalfile.SectionAttribute[j-1]:=unifile_attribute_alloc;
     SetLength(finalfile.SectionAddress,j);
     finalfile.SectionAddress[j-1]:=0;
     SetLength(finalfile.SectionAlign,j);
     if(finalfile.Bits=32) then finalfile.SectionAlign[j-1]:=4 else finalfile.SectionAlign[j-1]:=8;
     SetLength(finalfile.SectionContent,j);
     finalfile.SectionContent[j-1]:=nil;
     SetLength(finalfile.SectionSize,j);
     finalfile.SectionSize[j-1]:=0;
     finalfile.SectionCount:=j;
     finalfile.HashTableIndex:=j;
     inc(j);
    end;
   if(basefile.SectionVaild[i-1]) then
    begin
     SetLength(finalfile.SectionAlign,j);
     if(basescript.Section[i-1].SectionAlign=0) and (basefile.SectionAlign[i-1]=0) then
      begin
       if(finalfile.Bits=32) then finalfile.SectionAlign[j-1]:=4 else finalfile.SectionAlign[j-1]:=8;
      end
     else if(basescript.Section[i-1].SectionAlign>=basefile.SectionAlign[i-1]) then
     finalfile.SectionAlign[j-1]:=basescript.Section[i-1].SectionAlign
     else if(basefile.SectionAlign[i-1]>basescript.Section[i-1].SectionAlign) then
     finalfile.SectionAlign[j-1]:=basefile.SectionAlign[i-1];
     SetLength(finalfile.SectionName,j);
     finalfile.SectionName[j-1]:=basefile.SectionName[i-1];
     SetLength(finalfile.SectionAttribute,j);
     finalfile.SectionAttribute[j-1]:=basefile.SectionAttribute[i-1];
     SetLength(finalfile.SectionAddress,j);
     if(basescript.Section[i-1].SectionAddress<>0) then
     finalfile.SectionAddress[j-1]:=basescript.Section[i-1].SectionAddress
     else
     finalfile.SectionAddress[j-1]:=0;
     SetLength(finalfile.SectionSize,j);
     finalfile.SectionSize[j-1]:=basefile.SectionContentInfo[i-1].ContentSize;
     SetLength(finalfile.SectionContent,j);
     finalfile.SectionContent[j-1]:=allocmem(finalfile.SectionSize[j-1]);
     SectionIndex[i-1]:=j;
     if(basefile.SectionAttribute[i-1] and unifile_attribute_not_in_file=0) then
      begin
       m:=1; e:=basefile.SectionContentInfo[i-1].ContentStartIndex;
       while(m<=basefile.SectionContentInfo[i-1].ContentCount)do
        begin
         if(basefile.SectionContent[e+m-2].Size>0) and
         (basefile.SectionContent[e+m-2].Memory<>nil) then
          begin
           Move(basefile.SectionContent[e+m-2].Memory^,
           (finalfile.SectionContent[j-1]+basefile.SectionContent[e+m-2].Offset)^,
           basefile.SectionContent[e+m-2].Size);
          end;
         inc(m);
        end;
      end;
     inc(j);
    end;
   if(basefile.SectionVaild[i-1]) and
   (basefile.SectionAttribute[i-1]=unifile_attribute_alloc or unifile_attribute_execute) and
   (basescript.elfclass=unild_class_relocatable) and (fileclass=unifile_class_elf_file) then
    begin
     SetLength(finalfile.SectionAlign,j+1);
     if(finalfile.Bits=32) then finalfile.SectionAlign[j-1]:=4 else finalfile.SectionAlign[j-1]:=8;
     SetLength(finalfile.SectionName,j+1);
     finalfile.SectionName[j-1]:='.rela'+basefile.SectionName[i-1];
     SetLength(finalfile.SectionAttribute,j+1);
     finalfile.SectionAttribute[j-1]:=unifile_attribute_information;
     SetLength(finalfile.SectionAddress,j+1);
     finalfile.SectionAddress[j-1]:=0;
     SetLength(finalfile.SectionSize,j+1);
     k:=1; RelocatableFileRelaCount:=0;
     while(k<=basefile.AdjustTable.Count)do
      begin
       if(basefile.AdjustTable.OriginalSectionIndex[k-1]=i) and
       (basefile.AdjustTable.OriginalSectionIndex[k-1]<>basefile.AdjustTable.GoalSectionIndex[k-1]) then
       inc(RelocatableFileRelaCount);
       inc(k);
      end;
     if(RelocatableFileRelaCount>0) then
      begin
       if(finalfile.Bits=32) then
       finalfile.SectionSize[j-1]:=RelocatableFileRelaCount*sizeof(elf32_rela)
       else
       finalfile.SectionSize[j-1]:=RelocatableFileRelaCount*sizeof(elf64_rela);
       SetLength(finalfile.SectionContent,j+1);
       finalfile.SectionContent[j-1]:=allocmem(finalfile.SectionSize[j-1]);
       finalfile.SectionCount:=j;
       inc(j);
      end
     else dec(j);
    end;
   if(a<=SegmentCount) and (i=SegmentIndex[a-1]) and (SegmentAlter[a-1]) then
    begin
     if(basefile.SectionAttribute[i-1]=unifile_attribute_alloc or unifile_attribute_execute)
     and(fileclass=unifile_class_elf_file) and (DynamicBool=false)
     and(basescript.elfclass<>unild_class_relocatable) and (basescript.NoFixedAddress) then
      begin
       DynamicBool:=true;
       if(finalfile.GotTableList.GotCount>0) or (FileList.NeedCount>0) then
        begin
         finalfile.DynamicIndex:=j;
         if(basescript.DynamicSectionEnable) then
         SectionIndex[basefile.SectionCount+basescript.DynamicSectionIndex-1]:=j;
         finalfile.DynamicStringTableIndex:=j+1;
         finalfile.DynamicSymbolIndex:=j+2;
         finalfile.RelocationDynamicTableIndex:=j+3;
         SetLength(finalfile.SectionAlign,j+3);
         if(finalfile.Bits=32) then finalfile.SectionAlign[j-1]:=4 else finalfile.SectionAlign[j-1]:=8;
         finalfile.SectionAlign[j]:=1;
         if(finalfile.Bits=32) then finalfile.SectionAlign[j+1]:=4 else finalfile.SectionAlign[j+1]:=8;
         if(finalfile.Bits=32) then finalfile.SectionAlign[j+2]:=4 else finalfile.SectionAlign[j+2]:=8;
         SetLength(finalfile.SectionName,j+3);
         finalfile.SectionName[j-1]:='.dynamic';
         finalfile.SectionName[j]:='.dynstr';
         finalfile.SectionName[j+1]:='.dynsym';
         finalfile.SectionName[j+2]:='.rela.dyn';
         SetLength(finalfile.SectionAttribute,j+3);
         finalfile.SectionAttribute[j-1]:=unifile_attribute_alloc;
         finalfile.SectionAttribute[j]:=unifile_attribute_alloc;
         finalfile.SectionAttribute[j+1]:=unifile_attribute_alloc;
         finalfile.SectionAttribute[j+2]:=unifile_attribute_alloc;
         SetLength(finalfile.SectionAddress,j+3);
         finalfile.SectionAddress[j-1]:=0;
         finalfile.SectionAddress[j]:=0;
         finalfile.SectionAddress[j+1]:=0;
         finalfile.SectionAddress[j+2]:=0;
         SetLength(finalfile.SectionContent,j+3);
         finalfile.SectionContent[j-1]:=nil;
         finalfile.SectionContent[j]:=nil;
         finalfile.SectionContent[j+1]:=nil;
         finalfile.SectionContent[j+2]:=nil;
         SetLength(finalfile.SectionSize,j+3);
         finalfile.SectionSize[j-1]:=0;
         finalfile.SectionSize[j]:=0;
         finalfile.SectionSize[j+1]:=0;
         finalfile.SectionSize[j+2]:=0;
         finalfile.SectionCount:=j+3;
         inc(j,4);
        end
       else
        begin
         finalfile.DynamicIndex:=j;
         if(basescript.DynamicSectionEnable) then
         SectionIndex[basefile.SectionCount+basescript.DynamicSectionIndex-1]:=j;
         finalfile.DynamicStringTableIndex:=j+1;
         finalfile.DynamicSymbolIndex:=j+2;
         finalfile.RelocationDynamicTableIndex:=0;
         SetLength(finalfile.SectionAlign,j+2);
         if(finalfile.Bits=32) then finalfile.SectionAlign[j-1]:=4 else finalfile.SectionAlign[j-1]:=8;
         finalfile.SectionAlign[j]:=1;
         if(finalfile.Bits=32) then finalfile.SectionAlign[j+1]:=4 else finalfile.SectionAlign[j+1]:=8;
         SetLength(finalfile.SectionName,j+2);
         finalfile.SectionName[j-1]:='.dynamic';
         finalfile.SectionName[j]:='.dynstr';
         finalfile.SectionName[j+1]:='.dynsym';
         SetLength(finalfile.SectionAttribute,j+2);
         finalfile.SectionAttribute[j-1]:=unifile_attribute_alloc;
         finalfile.SectionAttribute[j]:=unifile_attribute_alloc;
         finalfile.SectionAttribute[j+1]:=unifile_attribute_alloc;
         SetLength(finalfile.SectionAddress,j+2);
         finalfile.SectionAddress[j-1]:=0;
         finalfile.SectionAddress[j]:=0;
         finalfile.SectionAddress[j+1]:=0;
         SetLength(finalfile.SectionContent,j+2);
         finalfile.SectionContent[j-1]:=nil;
         finalfile.SectionContent[j]:=nil;
         finalfile.SectionContent[j+1]:=nil;
         SetLength(finalfile.SectionSize,j+2);
         finalfile.SectionSize[j-1]:=0;
         finalfile.SectionSize[j]:=0;
         finalfile.SectionSize[j+1]:=0;
         finalfile.SectionCount:=j+2;
         inc(j,3);
        end;
      end
     else if(basefile.SectionAttribute[i-1]=unifile_attribute_alloc or unifile_attribute_write)
     and(GotBool=false) and
     (not ((fileclass=unifile_class_elf_file) and (basescript.elfclass=unild_class_relocatable))) and
     (finalfile.GotTableList.GotCount>0) then
      begin
       GotBool:=true;
       SetLength(finalfile.SectionAlign,j+1);
       if(finalfile.Bits=32) then finalfile.SectionAlign[j-1]:=4 else finalfile.SectionAlign[j-1]:=8;
       SetLength(finalfile.SectionName,j+1);
       finalfile.SectionName[j-1]:='.got';
       SetLength(finalfile.SectionAttribute,j+1);
       finalfile.SectionAttribute[j-1]:=unifile_attribute_alloc or unifile_attribute_write;
       SetLength(finalfile.SectionAddress,j+1);
       finalfile.SectionAddress[j-1]:=0;
       SetLength(finalfile.SectionSize,j+1);
       if(basefile.ExternalNeeded) then
        begin
         if(finalfile.Bits=32) then
         finalfile.SectionSize[j-1]:=(finalfile.GotTableList.GotCount+3)*4
         else
         finalfile.SectionSize[j-1]:=(finalfile.GotTableList.GotCount+3)*8;
        end
       else
        begin
         if(finalfile.Bits=32) then
         finalfile.SectionSize[j-1]:=finalfile.GotTableList.GotCount*4
         else
         finalfile.SectionSize[j-1]:=finalfile.GotTableList.GotCount*8;
        end;
       SetLength(finalfile.SectionContent,j+1);
       finalfile.SectionContent[j-1]:=allocmem(finalfile.SectionSize[j-1]);
       finalfile.SectionCount:=j;
       finalfile.GotIndex:=j;
       if(basescript.GlobalOffsetTableSectionEnable) then
       SectionIndex[basefile.SectionCount+basescript.GlobalOffsetTableSectionIndex-1]:=j;
       inc(j);
      end;
    end;
   if(a<=SegmentCount) and (i=SegmentIndex[a-1]) then inc(a);
   if(i=basefile.SectionCount) and (fileclass=unifile_class_elf_file) and
   (basescript.NoSymbol=false) then
    begin
     finalfile.SymbolTableIndex:=j;
     finalfile.SymbolStringTableIndex:=j+1;
     finalfile.StringTableIndex:=j+2;
     SetLength(finalfile.SectionAlign,j+2);
     if(finalfile.Bits=32) then finalfile.SectionAlign[j-1]:=4 else finalfile.SectionAlign[j-1]:=8;
     finalfile.SectionAlign[j]:=1;
     finalfile.SectionAlign[j+1]:=1;
     SetLength(finalfile.SectionName,j+2);
     finalfile.SectionName[j-1]:='.symtab';
     finalfile.SectionName[j]:='.strtab';
     finalfile.SectionName[j+1]:='.shstrtab';
     SetLength(finalfile.SectionAttribute,j+2);
     finalfile.SectionAttribute[j-1]:=0;
     finalfile.SectionAttribute[j]:=0;
     finalfile.SectionAttribute[j+1]:=0;
     SetLength(finalfile.SectionAddress,j+2);
     finalfile.SectionAddress[j-1]:=0;
     finalfile.SectionAddress[j]:=0;
     finalfile.SectionAddress[j+1]:=0;
     SetLength(finalfile.SectionContent,j+2);
     finalfile.SectionContent[j-1]:=nil;
     finalfile.SectionContent[j]:=nil;
     finalfile.SectionContent[j+1]:=nil;
     SetLength(finalfile.SectionSize,j+2);
     finalfile.SectionSize[j-1]:=0;
     finalfile.SectionSize[j]:=0;
     finalfile.SectionSize[j+1]:=0;
     finalfile.SectionCount:=j+2;
     inc(j,3);
    end
   else if(i=basefile.SectionCount) and (fileclass=unifile_class_elf_file) and
   (basescript.NoSymbol) then
    begin
     finalfile.StringTableIndex:=j;
     SetLength(finalfile.SectionAlign,j);
     finalfile.SectionAlign[j-1]:=1;
     SetLength(finalfile.SectionName,j);
     finalfile.SectionName[j-1]:='.shstrtab';
     SetLength(finalfile.SectionAttribute,j+2);
     finalfile.SectionAttribute[j-1]:=0;
     SetLength(finalfile.SectionAddress,j+2);
     finalfile.SectionAddress[j-1]:=0;
     SetLength(finalfile.SectionContent,j+2);
     finalfile.SectionContent[j-1]:=nil;
     SetLength(finalfile.SectionSize,j+2);
     finalfile.SectionSize[j-1]:=0;
     finalfile.SectionCount:=j;
     inc(j,1);
    end
   else if(i=basefile.SectionCount) and (fileclass=unifile_class_pe_file) then
    begin
     SetLength(finalfile.SectionAlign,j);
     if(finalfile.Bits=32) then finalfile.SectionAlign[j-1]:=4 else finalfile.SectionAlign[j-1]:=8;
     SetLength(finalfile.SectionName,j);
     finalfile.SectionName[j-1]:='.reloc';
     SetLength(finalfile.SectionAttribute,j);
     finalfile.SectionAttribute[j-1]:=unifile_attribute_alloc;
     SetLength(finalfile.SectionAddress,j);
     finalfile.SectionAddress[j-1]:=0;
     b:=1;
     if(finalfile.Bits=32) then
      begin
       k:=finalfile.GotTableList.GotCount*2; m:=0; n:=0;
       while(k shr 10>=1)do
        begin
         dec(k,1 shl 10); inc(n,8+1024); inc(m);
        end;
       if(k>0) then
        begin
         inc(n,8+k); inc(m);
        end;
       if(FileList.NeedCount=0) then n:=unifile_align(n,4);
      end
     else
      begin
       k:=finalfile.GotTableList.GotCount*2; m:=0; n:=0;
       while(k shr 9>=1)do
        begin
         dec(k,1 shl 9); inc(n,8+512); inc(m);
        end;
       if(k>0) then
        begin
         inc(n,8+k); inc(m);
        end;
       if(FileList.NeedCount=0) then n:=unifile_align(n,8);
      end;
     SetLength(finalfile.CoffList,m);
     finalfile.CoffListCount:=m;
     while(b<=m)do
      begin
       if(b=m) and (k>0) then
        begin
         SetLength(finalfile.CoffList[b-1].Item,k shr 1);
         if(finalfile.Bits=32) then a:=unifile_align(8+k,4)
         else a:=unifile_align(8+k,8);
         finalfile.CoffList[b-1].ItemCount:=k shr 1;
         finalfile.CoffList[b-1].SizeOfBlock:=a;
        end
       else
        begin
         if(finalfile.Bits=32) then
          begin
           SetLength(finalfile.CoffList[b-1].Item,1024);
           finalfile.CoffList[b-1].ItemCount:=1024;
           finalfile.CoffList[b-1].SizeOfBlock:=8+1024*2;
          end
         else
          begin
           SetLength(finalfile.CoffList[b-1].Item,512);
           finalfile.CoffList[b-1].ItemCount:=512;
           finalfile.CoffList[b-1].SizeOfBlock:=8+512*2;
          end;
        end;
       inc(b);
      end;
     if(m=0) and (FileList.NeedCount=0) then
      begin
       finalfile.CoffListSpecialize:=true;
       n:=12;
      end;
     SetLength(finalfile.SectionContent,j);
     finalfile.SectionContent[j-1]:=allocmem(n);
     SetLength(finalfile.SectionSize,j);
     finalfile.SectionSize[j-1]:=n;
     finalfile.RelocationIndex:=j;
     finalfile.SectionCount:=j;
     inc(j);
    end;
   inc(i);
  end;
 if(basefile.ExternalNeeded) and (finalfile.GotTableList.GotCount>0) then GotPltOffset:=3;
 SetLength(finalfile.SectionOffset,finalfile.SectionCount);
 if(fileclass=unifile_class_elf_file) then
  begin
   SetLength(AllSectionOffset,finalfile.SectionCount);
   for i:=1 to finalfile.SectionCount do AllSectionOffset[i-1]:=1;
  end;
 {Then Generate the Dynamic Symbol Table and Symbol Table}
 i:=1; j:=0; k:=0;
 finalfile.SymbolTable.SymbolCount:=basefile.SymbolCount;
 if(basefile.FileNameCount>0) and (basescript.EnableFileInformation) then
  begin
   inc(finalfile.SymbolTable.SymbolCount,basefile.FileNameCount);
  end;
 if(basefile.SectionCount>0) and (basescript.EnableSectionInformation) then
  begin
   inc(finalfile.SymbolTable.SymbolCount,basefile.SectionCount);
  end;
 SetLength(finalfile.SymbolTable.SymbolSectionIndex,
 finalfile.SymbolTable.SymbolCount+basefile.AdjustVaildCount+basescript.SectionCountExtra);
 SetLength(finalfile.SymbolTable.SymbolName,
 finalfile.SymbolTable.SymbolCount+basefile.AdjustVaildCount+basescript.SectionCountExtra);
 SetLength(finalfile.SymbolTable.SymbolNameHash,
 finalfile.SymbolTable.SymbolCount+basefile.AdjustVaildCount+basescript.SectionCountExtra);
 SetLength(finalfile.SymbolTable.SymbolBinding,
 finalfile.SymbolTable.SymbolCount+basefile.AdjustVaildCount+basescript.SectionCountExtra);
 SetLength(finalfile.SymbolTable.SymbolSize,
 finalfile.SymbolTable.SymbolCount+basefile.AdjustVaildCount+basescript.SectionCountExtra);
 SetLength(finalfile.SymbolTable.SymbolType,
 finalfile.SymbolTable.SymbolCount+basefile.AdjustVaildCount+basescript.SectionCountExtra);
 SetLength(finalfile.SymbolTable.SymbolValue,
 finalfile.SymbolTable.SymbolCount+basefile.AdjustVaildCount+basescript.SectionCountExtra);
 SetLength(finalfile.SymbolTable.SymbolVisibility,
 finalfile.SymbolTable.SymbolCount+basefile.AdjustVaildCount+basescript.SectionCountExtra);
 {Then Stab the File and Section to the file}
 if(basefile.FileNameCount>0) and (basescript.EnableFileInformation) then
  begin
   a:=1;
   while(a<=basefile.FileNameCount)do
    begin
     inc(j);
     finalfile.SymbolTable.SymbolSectionIndex[j-1]:=elf_symbol_other_absolute;
     finalfile.SymbolTable.SymbolName[j-1]:=basefile.FileName[a-1];
     finalfile.SymbolTable.SymbolNameHash[j-1]:=
     unihash_generate_value(basefile.FileName[a-1],false);
     finalfile.SymbolTable.SymbolBinding[j-1]:=elf_symbol_bind_local;
     finalfile.SymbolTable.SymbolSize[j-1]:=0;
     finalfile.SymbolTable.SymbolType[j-1]:=elf_symbol_type_file;
     finalfile.SymbolTable.SymbolValue[j-1]:=0;
     finalfile.SymbolTable.SymbolVisibility[j-1]:=elf_symbol_visibility_default;
     inc(a);
    end;
  end;
 if(basefile.SectionCount>0) and (basescript.EnableSectionInformation) then
  begin
   a:=1; SectionStart:=j+1; SectionCount:=finalfile.SectionCount;
   while(a<=finalfile.SectionCount)do
    begin
     inc(j);
     finalfile.SymbolTable.SymbolSectionIndex[j-1]:=a;
     finalfile.SymbolTable.SymbolName[j-1]:=finalfile.SectionName[a-1];
     finalfile.SymbolTable.SymbolNameHash[j-1]:=
     unihash_generate_value(finalfile.SectionName[a-1],false);
     finalfile.SymbolTable.SymbolBinding[j-1]:=elf_symbol_bind_local;
     finalfile.SymbolTable.SymbolSize[j-1]:=0;
     finalfile.SymbolTable.SymbolType[j-1]:=elf_symbol_type_section;
     finalfile.SymbolTable.SymbolValue[j-1]:=0;
     finalfile.SymbolTable.SymbolVisibility[j-1]:=elf_symbol_visibility_default;
     inc(a);
    end;
  end;
 i:=1;
 if(basescript.SectionCountExtra>0) then
  begin
   c:=j;
   if(basescript.GlobalOffsetTableSectionEnable) and (finalfile.GotIndex>0) then
    begin
     GotSymbolIndex:=c+basescript.GlobalOffsetTableSectionIndex; inc(j);
    end
   else if(basescript.GlobalOffsetTableSectionEnable) then inc(i);
   if(basescript.DynamicSectionEnable) and (finalfile.DynamicIndex>0) and
   (not ((basescript.elfclass=unild_class_relocatable) and (fileclass=unifile_class_elf_file))) then
    begin
     DynamicSymbolIndex:=c+basescript.DynamicSectionIndex; inc(j);
    end
   else if(basescript.DynamicSectionEnable) then inc(i);
  end;
 while(i<=basefile.SymbolTable.SymbolCount)do
  begin
   if(basefile.SymbolTable.SymbolType[i-1]=elf_symbol_type_section) then
    begin
     inc(i); continue;
    end;
   if(basescript.elfclass=unild_class_relocatable) and (fileclass=unifile_class_elf_file) then
    begin
     m:=1; n:=0;
     n:=unifile_search_for_hash_table(basefile.SectionContentAssist,
     basefile.SymbolTable.SymbolSectionNameHash[i-1]);
     if(n=0) then m:=0 else m:=basefile.SectionContent[n-1].Index;
     inc(j);
     if(m<>0) then
      begin
       finalfile.SymbolTable.SymbolSectionIndex[j-1]:=SectionIndex[m-1];
       finalfile.SymbolTable.SymbolName[j-1]:=basefile.SymbolTable.SymbolName[i-1];
       finalfile.SymbolTable.SymbolNameHash[j-1]:=basefile.SymbolTable.SymbolNameHash[i-1];
       finalfile.SymbolTable.SymbolBinding[j-1]:=basefile.SymbolTable.SymbolBinding[i-1];
       finalfile.SymbolTable.SymbolSize[j-1]:=basefile.SymbolTable.SymbolSize[i-1];
       finalfile.SymbolTable.SymbolType[j-1]:=basefile.SymbolTable.SymbolType[i-1];
       finalfile.SymbolTable.SymbolValue[j-1]:=basefile.SectionContent[n-1].Offset
       +basefile.SymbolTable.SymbolValue[i-1];
       finalfile.SymbolTable.SymbolVisibility[j-1]:=basefile.SymbolTable.SymbolVisibility[i-1];
      end
     else
      begin
       finalfile.SymbolTable.SymbolSectionIndex[j-1]:=0;
       finalfile.SymbolTable.SymbolName[j-1]:=basefile.SymbolTable.SymbolName[i-1];
       finalfile.SymbolTable.SymbolNameHash[j-1]:=basefile.SymbolTable.SymbolNameHash[i-1];
       finalfile.SymbolTable.SymbolBinding[j-1]:=basefile.SymbolTable.SymbolBinding[i-1];
       finalfile.SymbolTable.SymbolSize[j-1]:=basefile.SymbolTable.SymbolSize[i-1];
       finalfile.SymbolTable.SymbolType[j-1]:=basefile.SymbolTable.SymbolType[i-1];
       finalfile.SymbolTable.SymbolValue[j-1]:=0;
       finalfile.SymbolTable.SymbolVisibility[j-1]:=basefile.SymbolTable.SymbolVisibility[i-1];
      end;
    end
   else if(basefile.SymbolTable.SymbolSectionNameHash[i-1]=0) then
    begin
     if(fileclass=unifile_class_pe_file) then
      begin
       writeln('ERROR: Symbol '+basefile.SymbolTable.SymbolName[i-1]+' not found in EFI file structure.');
       readln;
       halt;
      end
     else if(fileclass=unifile_class_elf_file) and
     (basescript.NoFixedAddress=false) and (basescript.elfclass=unild_class_executable) then
      begin
       writeln('ERROR: Symbol '+basefile.SymbolTable.SymbolName[i-1]+' not found in ELF'+
       ' format executable in Fixed Address.');
       readln;
       halt;
      end;
     inc(k); inc(j);
     NeedDynamicLibraryTotal:=true;
     finalfile.DynamicSymbolTable.SymbolSectionIndex[k-1]:=0;
     finalfile.DynamicSymbolTable.SymbolName[k-1]:=basefile.SymbolTable.SymbolName[i-1];
     finalfile.DynamicSymbolTable.SymbolNameHash[k-1]:=basefile.SymbolTable.SymbolNameHash[i-1];
     finalfile.DynamicSymbolTable.SymbolBinding[k-1]:=basefile.SymbolTable.SymbolBinding[i-1];
     finalfile.DynamicSymbolTable.SymbolSize[k-1]:=0;
     finalfile.DynamicSymbolTable.SymbolType[k-1]:=basefile.SymbolTable.SymbolType[i-1];
     finalfile.DynamicSymbolTable.SymbolValue[k-1]:=0;
     finalfile.DynamicSymbolTable.SymbolVisibility[k-1]:=basefile.SymbolTable.SymbolVisibility[i-1];
     finalfile.SymbolTable.SymbolSectionIndex[j-1]:=0;
     finalfile.SymbolTable.SymbolName[j-1]:=basefile.SymbolTable.SymbolName[i-1];
     finalfile.SymbolTable.SymbolNameHash[j-1]:=basefile.SymbolTable.SymbolNameHash[i-1];
     finalfile.SymbolTable.SymbolBinding[j-1]:=basefile.SymbolTable.SymbolBinding[i-1];
     finalfile.SymbolTable.SymbolSize[j-1]:=0;
     finalfile.SymbolTable.SymbolType[j-1]:=basefile.SymbolTable.SymbolType[i-1];
     finalfile.SymbolTable.SymbolValue[j-1]:=0;
     finalfile.SymbolTable.SymbolVisibility[j-1]:=basefile.SymbolTable.SymbolVisibility[i-1];
    end
   else if(basescript.elfclass=unild_class_sharedobject) then
    begin
     n:=unifile_search_for_hash_table(basefile.SectionContentAssist,
     basefile.SymbolTable.SymbolSectionNameHash[i-1]);
     if(n=0) then
      begin
       inc(i); continue;
      end;
     m:=basefile.SectionContent[n-1].Index;
     if(m<>0) then
      begin
       if(basefile.SymbolTable.SymbolBinding[i-1]=elf_symbol_bind_global) then
        begin
         inc(k);
         finalfile.DynamicSymbolTable.SymbolSectionIndex[k-1]:=SectionIndex[m-1];
         finalfile.DynamicSymbolTable.SymbolName[k-1]:=basefile.SymbolTable.SymbolName[i-1];
         finalfile.DynamicSymbolTable.SymbolNameHash[k-1]:=basefile.SymbolTable.SymbolNameHash[i-1];
         finalfile.DynamicSymbolTable.SymbolBinding[k-1]:=basefile.SymbolTable.SymbolBinding[i-1];
         finalfile.DynamicSymbolTable.SymbolSize[k-1]:=basefile.SymbolTable.SymbolSize[i-1];
         finalfile.DynamicSymbolTable.SymbolType[k-1]:=basefile.SymbolTable.SymbolType[i-1];
         finalfile.DynamicSymbolTable.SymbolValue[k-1]:=basefile.SectionContent[n-1].Offset
         +basefile.SymbolTable.SymbolValue[i-1];
         finalfile.DynamicSymbolTable.SymbolVisibility[k-1]:=basefile.SymbolTable.SymbolVisibility[i-1];
        end;
       inc(j);
       finalfile.SymbolTable.SymbolSectionIndex[j-1]:=SectionIndex[m-1];
       finalfile.SymbolTable.SymbolName[j-1]:=basefile.SymbolTable.SymbolName[i-1];
       finalfile.SymbolTable.SymbolNameHash[j-1]:=basefile.SymbolTable.SymbolNameHash[i-1];
       finalfile.SymbolTable.SymbolBinding[j-1]:=basefile.SymbolTable.SymbolBinding[i-1];
       finalfile.SymbolTable.SymbolSize[j-1]:=basefile.SymbolTable.SymbolSize[i-1];
       finalfile.SymbolTable.SymbolType[j-1]:=basefile.SymbolTable.SymbolType[i-1];
       finalfile.SymbolTable.SymbolValue[j-1]:=basefile.SectionContent[n-1].Offset
       +basefile.SymbolTable.SymbolValue[i-1];
       finalfile.SymbolTable.SymbolVisibility[j-1]:=basefile.SymbolTable.SymbolVisibility[i-1];
      end
     else
      begin
       writeln('ERROR:Symbol '+basefile.SymbolTable.SymbolName[i-1]+' is invaild.');
       readln;
       halt;
      end;
    end
   else
    begin
     m:=1; n:=unifile_search_for_hash_table(basefile.SectionContentAssist,
     basefile.SymbolTable.SymbolSectionNameHash[i-1]);
     if(n=0) then
      begin
       inc(i); continue;
      end;
     m:=basefile.SectionContent[n-1].Index;
     inc(j);
     finalfile.SymbolTable.SymbolSectionIndex[j-1]:=SectionIndex[m-1];
     finalfile.SymbolTable.SymbolName[j-1]:=basefile.SymbolTable.SymbolName[i-1];
     finalfile.SymbolTable.SymbolNameHash[j-1]:=basefile.SymbolTable.SymbolNameHash[i-1];
     finalfile.SymbolTable.SymbolBinding[j-1]:=basefile.SymbolTable.SymbolBinding[i-1];
     finalfile.SymbolTable.SymbolSize[j-1]:=basefile.SymbolTable.SymbolSize[i-1];
     finalfile.SymbolTable.SymbolType[j-1]:=basefile.SymbolTable.SymbolType[i-1];
     finalfile.SymbolTable.SymbolValue[j-1]:=basefile.SectionContent[n-1].Offset
     +basefile.SymbolTable.SymbolValue[i-1];
     finalfile.SymbolTable.SymbolVisibility[j-1]:=basefile.SymbolTable.SymbolVisibility[i-1];
    end;
   inc(i);
  end;
 if(basescript.elfclass=unild_class_relocatable) and (fileclass=unifile_class_elf_file) then
  begin
   i:=1;
   while(i<=basefile.AdjustVaildCount)do
    begin
     inc(j);
     finalfile.SymbolTable.SymbolSectionIndex[j-1]:=0;
     finalfile.SymbolTable.SymbolName[j-1]:=basefile.AdjustTable.AdjustName[
     basefile.AdjustVaildIndex[i-1]-1];
     finalfile.SymbolTable.SymbolNameHash[j-1]:=basefile.AdjustTable.AdjustHash[
     basefile.AdjustVaildIndex[i-1]-1];
     finalfile.SymbolTable.SymbolBinding[j-1]:=elf_symbol_bind_global;
     finalfile.SymbolTable.SymbolSize[j-1]:=0;
     if(basefile.AdjustTable.AdjustFunc[i-1]) then
     finalfile.SymbolTable.SymbolType[j-1]:=elf_symbol_type_function
     else
     finalfile.SymbolTable.SymbolType[j-1]:=elf_symbol_type_object;
     finalfile.SymbolTable.SymbolValue[j-1]:=0;
     finalfile.SymbolTable.SymbolVisibility[j-1]:=0;
     inc(i);
    end;
  end;
 finalfile.SymbolTable.SymbolCount:=j; finalfile.DynamicSymbolTable.SymbolCount:=k;
 finalfile.SymbolTableLocalCount:=0;
 {Then Generate the Symbol Table Assist}
 finalfile.SymbolTableAssist.BucketCount:=
 unifile_hash_table_bucket_count(finalfile.SymbolTable.SymbolCount);
 SetLength(finalfile.SymbolTableAssist.BucketEnable,finalfile.SymbolTableAssist.BucketCount+1);
 SetLength(finalfile.SymbolTableAssist.BucketHash,finalfile.SymbolTableAssist.BucketCount+1);
 SetLength(finalfile.SymbolTableAssist.BucketItem,finalfile.SymbolTableAssist.BucketCount+1);
 finalfile.SymbolTableAssist.ChainCount:=finalfile.SymbolTable.SymbolCount;
 SetLength(finalfile.SymbolTableAssist.ChainEnable,finalfile.SymbolTableAssist.ChainCount+1);
 SetLength(finalfile.SymbolTableAssist.ChainHash,finalfile.SymbolTableAssist.ChainCount+1);
 SetLength(finalfile.SymbolTableAssist.ChainItem,finalfile.SymbolTableAssist.ChainCount+1);
 SetLength(finalfile.SymbolTableNewIndex,finalfile.SymbolTable.SymbolCount);
 i:=1;
 while(i<=finalfile.SymbolTable.SymbolCount)do
  begin
   finalfile.SymbolTableNewIndex[i-1]:=i;
   if(finalfile.SymbolTable.SymbolBinding[i-1]=elf_symbol_bind_local) then
   inc(finalfile.SymbolTableLocalCount);
   j:=finalfile.SymbolTable.SymbolNameHash[i-1] mod finalfile.SymbolTableAssist.BucketCount+1;
   if(finalfile.SymbolTableAssist.BucketEnable[j]=false) then
    begin
     finalfile.SymbolTableAssist.BucketEnable[j]:=true;
     finalfile.SymbolTableAssist.BucketHash[j]:=finalfile.SymbolTable.SymbolNameHash[i-1];
     finalfile.SymbolTableAssist.BucketItem[j]:=i;
    end
   else
    begin
     j:=finalfile.SymbolTableAssist.BucketItem[j];
     while(finalfile.SymbolTableAssist.ChainEnable[j])do j:=finalfile.SymbolTableAssist.ChainItem[j];
     finalfile.SymbolTableAssist.ChainEnable[j]:=true;
     finalfile.SymbolTableAssist.ChainHash[j]:=finalfile.SymbolTable.SymbolNameHash[i-1];
     finalfile.SymbolTableAssist.ChainItem[j]:=i;
    end;
   inc(i);
  end;
 {Then Generate the External Dynamic Symbol Table of the output file}
 unifile_dynamic_library_total_initialize(DynamicLibraryTotal);
 if(basescript.DynamicLibraryPathNameCount>0) and (NeedDynamicLibraryTotal) then
  begin
   for i:=1 to basescript.DynamicLibraryPathNameCount do
    begin
     unifile_add_elf_dynamic_library_to_total(DynamicLibraryTotal,
     unifile_read_elf_dynamic_library(basescript.DynamicLibraryPathName[i-1],
     finalfile.Architecture,finalfile.Bits));
    end;
   unifile_elf_dynamic_library_total_generate_hash_table(DynamicLibraryTotal);
  end;
 {Then Generate the Dynamic Symbol Table Assist}
 finalfile.DynamicSymbolTableAssist.BucketCount:=
 unifile_hash_table_bucket_count(finalfile.DynamicSymbolTable.SymbolCount);
 SetLength(finalfile.DynamicSymbolTableAssist.BucketEnable,finalfile.DynamicSymbolTableAssist.BucketCount+1);
 SetLength(finalfile.DynamicSymbolTableAssist.BucketHash,finalfile.DynamicSymbolTableAssist.BucketCount+1);
 SetLength(finalfile.DynamicSymbolTableAssist.BucketItem,finalfile.DynamicSymbolTableAssist.BucketCount+1);
 finalfile.DynamicSymbolTableAssist.ChainCount:=finalfile.DynamicSymbolTable.SymbolCount;
 SetLength(finalfile.DynamicSymbolTableAssist.ChainEnable,finalfile.DynamicSymbolTableAssist.ChainCount+1);
 SetLength(finalfile.DynamicSymbolTableAssist.ChainHash,finalfile.DynamicSymbolTableAssist.ChainCount+1);
 SetLength(finalfile.DynamicSymbolTableAssist.ChainItem,finalfile.DynamicSymbolTableAssist.ChainCount+1);
 SetLength(finalfile.DynamicSymbolTableNewIndex,finalfile.DynamicSymbolTable.SymbolCount);
 i:=1;
 while(i<=finalfile.DynamicSymbolTable.SymbolCount)do
  begin
   finalfile.DynamicSymbolTableNewIndex[i-1]:=i;
   if(finalfile.DynamicSymbolTable.SymbolSectionIndex[i-1]=0) and
   (unifile_elf_dynamic_library_total_search_for_hash_table(DynamicLibraryTotal,
   finalfile.DynamicSymbolTable.SymbolNameHash[i-1])=false) then
    begin
     writeln('ERROR:External Dynamic Symbol '+finalfile.DynamicSymbolTable.SymbolName[i-1]+' not found '+
     'in the Linked Dynamic Symbol File.');
     readln;
     halt;
    end;
   j:=finalfile.DynamicSymbolTable.SymbolNameHash[i-1] mod finalfile.DynamicSymbolTableAssist.BucketCount+1;
   if(finalfile.DynamicSymbolTableAssist.BucketEnable[j]=false) then
    begin
     finalfile.DynamicSymbolTableAssist.BucketEnable[j]:=true;
     finalfile.DynamicSymbolTableAssist.BucketHash[j]:=finalfile.DynamicSymbolTable.SymbolNameHash[i-1];
     finalfile.DynamicSymbolTableAssist.BucketItem[j]:=i;
    end
   else
    begin
     j:=finalfile.DynamicSymbolTableAssist.BucketItem[j];
     while(finalfile.DynamicSymbolTableAssist.ChainEnable[j])do
     j:=finalfile.DynamicSymbolTableAssist.ChainItem[j];
     finalfile.DynamicSymbolTableAssist.ChainEnable[j]:=true;
     finalfile.DynamicSymbolTableAssist.ChainHash[j]:=finalfile.DynamicSymbolTable.SymbolNameHash[i-1];
     finalfile.DynamicSymbolTableAssist.ChainItem[j]:=i;
    end;
   inc(i);
  end;
 {Then Sort the Symbols of Static Symbol}
 if(finalfile.SymbolTable.SymbolCount>0) then
 unifile_quick_sort(finalfile.SymbolTable,
 finalfile.SymbolTableNewIndex,basefile.FileNameCount+finalfile.SectionCount+1
 ,finalfile.SymbolTable.SymbolCount);
 {Then Sort the Symbols of Dynamic Symbol}
 if(finalfile.DynamicSymbolTable.SymbolCount>0) then
 unifile_quick_sort(finalfile.DynamicSymbolTable,
 finalfile.DynamicSymbolTableNewIndex,1,finalfile.DynamicSymbolTable.SymbolCount);
 {If Hash Table exists,set the Hash Table Empty Section}
 if(finalfile.HashTableIndex>0) then
  begin
   finalfile.SectionSize[finalfile.HashTableIndex-1]:=
   ((finalfile.DynamicSymbolTable.SymbolCount+1)*3+3)*sizeof(dword);
  end;
 {Then Obtain Implicit Section Addresses}
 if(basescript.ImplicitCount>0) then
  begin
   for i:=1 to finalfile.SectionCount do
    begin
     j:=1;
     while(j<=basescript.ImplicitCount)do
      begin
       if(basescript.ImplicitName[j-1]='') and
       (basescript.ImplicitName[j-1]=finalfile.SectionName[i-1]) then
        begin
         finalfile.SectionAddress[i-1]:=basescript.ImplicitAddress[j-1];
         basescript.ImplicitName[j-1]:='';
         break;
        end;
       inc(j);
      end;
    end;
  end;
 {Then Generate the Dynamic Table}
 DynamicCount:=0;
 InitialBool:=false; InitialArrayBool:=false; SymbolVersionBool:=false;
 FinalBool:=false; FinalArrayBool:=false; PreInitialArrayBool:=false;
 if(fileclass=unifile_class_elf_file) and (finalfile.DynamicIndex<>0) then
  begin
   if(basescript.SharedLibraryName<>'') and (basescript.elfclass=unild_class_sharedobject) then
    begin
     inc(DynamicCount);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_shared_object_name;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=0;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicString:=basescript.SharedLibraryName;
    end;
   for j:=1 to basescript.DynamicCount do
    begin
     inc(DynamicCount);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_needed;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=0;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicString:=
     ExtractFileName(basescript.DynamicLibrary[j-1]);
    end;
   if(basescript.DynamicPathCount>0) then
    begin
     inc(DynamicCount);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_run_path;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=0;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     tempstr1:='';
     for j:=1 to basescript.DynamicPathCount do
      begin
       tempstr1:=tempstr1+basescript.DynamicLibrary[j-1]+':';
      end;
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicString:=tempstr1;
    end;
   if(finalfile.HashTableIndex<>0) then
    begin
     inc(DynamicCount);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_hash;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_section;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicSection:='.hash';
    end;
   if(finalfile.DynamicStringTableIndex<>0) then
    begin
     inc(DynamicCount,2);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-2]:=elf_dynamic_type_String_table;
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_String_table_size;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-2]:=unifile_dynamic_class_section;
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_section;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-2].DynamicSection:='.dynstr';
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicSection:='.dynstr';
    end;
   if(finalfile.DynamicSymbolIndex<>0) then
    begin
     inc(DynamicCount,2);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-2]:=elf_dynamic_type_symbol_table;
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_symbol_table_entry;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-2]:=unifile_dynamic_class_section;
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_value;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-2].DynamicSection:='.dynsym';
     if(finalfile.Bits=32) then
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue:=sizeof(elf32_symbol_table_entry)
     else
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue:=sizeof(elf64_symbol_table_entry);
    end;
   if(finalfile.RelocationDynamicTableIndex<>0) then
    begin
     inc(DynamicCount,4);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-4]:=elf_dynamic_type_rela;
     finalfile.DynamicList.DynamicType[DynamicCount-3]:=elf_dynamic_type_rela_size;
     finalfile.DynamicList.DynamicType[DynamicCount-2]:=elf_dynamic_type_rela_entry;
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_rela_count;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-4]:=unifile_dynamic_class_section;
     finalfile.DynamicList.DynamicSubType[DynamicCount-3]:=unifile_dynamic_class_section;
     finalfile.DynamicList.DynamicSubType[DynamicCount-2]:=unifile_dynamic_class_value;
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_section;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-4].DynamicSection:='.rela.dyn';
     finalfile.DynamicList.DynamicItem[DynamicCount-3].DynamicSection:='.rela.dyn';
     if(basefile.Bits=32) then finalfile.DynamicList.DynamicItem[DynamicCount-2].DynamicValue:=12
     else finalfile.DynamicList.DynamicItem[DynamicCount-2].DynamicValue:=24;
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicSection:='.rela.dyn';
    end;
   if(finalfile.GotIndex<>0) and (finalfile.DynamicSymbolTable.SymbolCount>0) then
    begin
     inc(DynamicCount);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_pltgot;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_section;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicSection:='.got';
    end;
   if(basescript.DebugSwitch) then
    begin
     inc(DynamicCount);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_debug;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_value;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue:=0;
    end;
   for i:=1 to finalfile.SectionCount do
    begin
     if(finalfile.SectionName[i-1]='.init') then InitialBool:=true
     else if(finalfile.SectionName[i-1]='.init_array') then InitialArrayBool:=true
     else if(finalfile.SectionName[i-1]='.fini') then FinalBool:=true
     else if(finalfile.SectionName[i-1]='.fini_array') then FinalArrayBool:=true
     else if(finalfile.SectionName[i-1]='.preinit_array') then PreInitialArrayBool:=true
     else if(finalfile.SectionName[i-1]='.gnu_version') then SymbolVersionBool:=true;
    end;
   if(InitialBool) then
    begin
     inc(DynamicCount);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_initialization;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_section;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicSection:='.init';
    end;
   if(InitialArrayBool) then
    begin
     inc(DynamicCount,2);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-2]:=elf_dynamic_type_initialize_array;
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_initialize_array_size;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-2]:=unifile_dynamic_class_section;
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_section;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-2].DynamicSection:='.init_array';
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicSection:='.init_array';
    end;
   if(FinalBool) then
    begin
     inc(DynamicCount);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_finalization;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_section;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicSection:='.fini';
    end;
   if(FinalArrayBool) then
    begin
     inc(DynamicCount,2);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-2]:=elf_dynamic_type_finalize_array;
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_finalize_array_size;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-2]:=unifile_dynamic_class_section;
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_section;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-2].DynamicSection:='.fini_array';
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicSection:='.fini_array';
    end;
   if(PreInitialArrayBool) then
    begin
     inc(DynamicCount,2);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-2]:=elf_dynamic_type_preinitialize_array;
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_preinitialize_array_size;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-2]:=unifile_dynamic_class_section;
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_section;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-2].DynamicSection:='.preinit_array';
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicSection:='.preinit_array';
    end;
   if(SymbolVersionBool) then
    begin
     inc(DynamicCount,3);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-3]:=elf_dynamic_type_version_symbol;
     finalfile.DynamicList.DynamicType[DynamicCount-2]:=elf_dynamic_type_symbol_info_size;
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_symbol_info_entry;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-3]:=unifile_dynamic_class_section;
     finalfile.DynamicList.DynamicSubType[DynamicCount-2]:=unifile_dynamic_class_section;
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_value;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-3].DynamicSection:='.gnu_version';
     finalfile.DynamicList.DynamicItem[DynamicCount-2].DynamicSection:='.gnu_version';
     if(basefile.Bits=32) then
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue:=sizeof(elf32_symbol_table_entry)
     else
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue:=sizeof(elf64_symbol_table_entry);
    end;
   inc(DynamicCount,2);
   finalfile.DynamicList.DynamicCount:=DynamicCount;
   SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
   finalfile.DynamicList.DynamicType[DynamicCount-2]:=elf_dynamic_type_bind_now;
   finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_flags_1;
   SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
   finalfile.DynamicList.DynamicSubType[DynamicCount-2]:=0;
   finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=0;
   SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
   finalfile.DynamicList.DynamicItem[DynamicCount-2].DynamicValue:=0;
   if(basescript.NoFixedAddress) and (basescript.elfclass=unild_class_executable) then
   finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue:=elf_dynamic_flag_1_pie
   else
   finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue:=0;
   if(basescript.NoDefaultLibrary) then
    begin
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue:=
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue or elf_dynamic_flag_1_nodeflib;
    end;
   if(basescript.Symbolic) then
    begin
     inc(DynamicCount);
     finalfile.DynamicList.DynamicCount:=DynamicCount;
     SetLength(finalfile.DynamicList.DynamicType,DynamicCount);
     finalfile.DynamicList.DynamicType[DynamicCount-1]:=elf_dynamic_type_flags;
     SetLength(finalfile.DynamicList.DynamicSubType,DynamicCount);
     finalfile.DynamicList.DynamicSubType[DynamicCount-1]:=unifile_dynamic_class_value;
     SetLength(finalfile.DynamicList.DynamicItem,DynamicCount);
     finalfile.DynamicList.DynamicItem[DynamicCount-1].DynamicValue:=elf_dynamic_flag_symbolic;
    end;
   if(finalfile.Bits=32) then
   finalfile.SectionSize[finalfile.DynamicIndex-1]:=dynamicCount*8
   else
   finalfile.SectionSize[finalfile.DynamicIndex-1]:=dynamicCount*16;
   finalfile.SectionContent[finalfile.DynamicIndex-1]:=
   allocmem(finalfile.SectionSize[finalfile.DynamicIndex-1]);
   {Generate the .dynstr and .dynsym section content}
   DynamicStringTableSize:=1;
   for i:=1 to finalfile.DynamicList.DynamicCount do
    begin
     if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_shared_object_name)
     or(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_library_search_path) then
     inc(DynamicStringTableSize,length(finalfile.DynamicList.DynamicItem[i-1].DynamicString)+1);
    end;
   if(finalfile.Bits=32) then
   finalfile.SectionSize[finalfile.DynamicSymbolIndex-1]:=
   (finalfile.DynamicSymbolTable.SymbolCount+1)*sizeof(elf32_symbol_table_entry)
   else
   finalfile.SectionSize[finalfile.DynamicSymbolIndex-1]:=
   (finalfile.DynamicSymbolTable.SymbolCount+1)*sizeof(elf64_symbol_table_entry);
   finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]:=
   allocmem(finalfile.SectionSize[finalfile.DynamicSymbolIndex-1]);
   for i:=1 to finalfile.DynamicSymbolTable.SymbolCount do
    begin
     inc(DynamicStringTableSize,length(finalfile.DynamicSymbolTable.SymbolName[i-1])+1);
    end;
   finalfile.SectionSize[finalfile.DynamicStringTableIndex-1]:=DynamicStringTableSize;
   finalfile.SectionContent[finalfile.DynamicStringTableIndex-1]:=allocmem(DynamicStringTableSize);
  end;
 {For Generate the empty symbol Table and String Table}
 if(fileclass=unifile_class_elf_file) and (basescript.NoSymbol=false) then
  begin
   if(finalfile.Bits=32) then
   finalfile.SectionSize[finalfile.SymbolTableIndex-1]:=
   (finalfile.SymbolTable.SymbolCount+1)*sizeof(elf32_symbol_table_entry)
   else
   finalfile.SectionSize[finalfile.SymbolTableIndex-1]:=
   (finalfile.SymbolTable.SymbolCount+1)*sizeof(elf64_symbol_table_entry);
   finalfile.SectionContent[finalfile.SymbolTableIndex-1]:=
   allocmem(finalfile.SectionSize[finalfile.SymbolTableIndex-1]);
   StringTableSize:=1;
   for i:=1 to finalfile.SymbolTable.SymbolCount do
    begin
     if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]<>
     elf_symbol_type_section) then
     inc(StringTableSize,length(finalfile.SymbolTable.SymbolName[
     finalfile.SymbolTableNewIndex[i-1]-1])+1);
    end;
   finalfile.SectionSize[finalfile.SymbolStringTableIndex-1]:=StringTableSize;
   finalfile.SectionContent[finalfile.SymbolStringTableIndex-1]:=allocmem(StringTableSize);
  end;
 if(fileclass=unifile_class_elf_file) then
  begin
   StringTableSize:=1;
   for i:=1 to finalfile.SectionCount do
    begin
     inc(StringTableSize,length(finalfile.SectionName[i-1])+1);
    end;
   finalfile.SectionSize[finalfile.StringTableIndex-1]:=StringTableSize;
   finalfile.SectionContent[finalfile.StringTableIndex-1]:=allocmem(StringTableSize);
  end;
 {For Generate the empty .rela.dyn section}
 if(finalfile.RelocationDynamicTableIndex<>0) then
  begin
   if(finalfile.Bits=32) then
    begin
     finalfile.SectionSize[finalfile.RelocationDynamicTableIndex-1]:=sizeof(elf32_rela)*
     (finalfile.GotTableList.GotCount+GotPltOffset+FileList.NeedCount);
     finalfile.SectionContent[finalfile.RelocationDynamicTableIndex-1]:=
     allocmem(finalfile.SectionSize[finalfile.RelocationDynamicTableIndex-1]);
    end
   else
    begin
     finalfile.SectionSize[finalfile.RelocationDynamicTableIndex-1]:=sizeof(elf64_rela)*
     (finalfile.GotTableList.GotCount+GotPltOffset+FileList.NeedCount);
     finalfile.SectionContent[finalfile.RelocationDynamicTableIndex-1]:=
     allocmem(finalfile.SectionSize[finalfile.RelocationDynamicTableIndex-1]);
    end;
  end;
 {Distributing the Address of the Sections}
 StartOffset:=0; ProgramHeaderCount:=0;
 if(fileclass=unifile_class_elf_file) and (basescript.elfclass<>unild_class_relocatable) then
  begin
   ProgramHeaderCount:=2;
   if(basescript.GotAuthority>0) and (finalfile.GotIndex>0) then inc(ProgramHeaderCount);
   if(finalfile.Bits=32) then
    begin
     inc(StartOffset,sizeof(elf32_header));
     for i:=1 to finalfile.SectionCount do
      begin
       if(i<finalfile.SectionCount) and (
       finalfile.SectionAttribute[i-1] and
       (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
       or unifile_attribute_thread_local_storage)<>
       finalfile.SectionAttribute[i] and
       (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
       or unifile_attribute_thread_local_storage))
       and(finalfile.SectionAttribute[i-1] and
       (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
       or unifile_attribute_thread_local_storage)<>0) then inc(ProgramHeaderCount);
       if(finalfile.SectionName[i-1]='.dynamic') then inc(ProgramHeaderCount);
       if(finalfile.SectionName[i-1]='.interp') then inc(ProgramHeaderCount);
      end;
     finalfile.FileStartAddress:=StartOffset+ProgramHeaderCount*sizeof(elf32_program_header);
    end
   else
    begin
     inc(StartOffset,sizeof(elf64_header));
     for i:=1 to finalfile.SectionCount do
      begin
       if(i<finalfile.SectionCount) and (
       finalfile.SectionAttribute[i-1] and
       (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
       or unifile_attribute_thread_local_storage)<>
       finalfile.SectionAttribute[i] and
       (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
       or unifile_attribute_thread_local_storage))
       and(finalfile.SectionAttribute[i-1] and
       (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
       or unifile_attribute_thread_local_storage)<>0) then inc(ProgramHeaderCount);
       if(finalfile.SectionName[i-1]='.dynamic') then inc(ProgramHeaderCount);
       if(finalfile.SectionName[i-1]='.interp') then inc(ProgramHeaderCount);
      end;
     finalfile.FileStartAddress:=StartOffset+ProgramHeaderCount*sizeof(elf64_program_header);
    end;
   finalfile.FileProgramCount:=ProgramHeaderCount;
  end
 else if(fileclass=unifile_class_elf_file) then
  begin
   if(finalfile.Bits=32) then inc(StartOffset,sizeof(elf32_header))
   else inc(StartOffset,sizeof(elf64_header));
   finalfile.FileProgramCount:=0;
  end
 else if(fileclass=unifile_class_pe_file) then
  begin
   if(finalfile.Bits=32) then
    begin
     inc(StartOffset,sizeof(pe_dos_header)+64+4+sizeof(coff_image_header)+
     sizeof(coff_optional_image_header32)+sizeof(pe_data_directory)*6+
     sizeof(pe_image_section_header)*finalfile.SectionCount);
    end
   else
    begin
     inc(StartOffset,sizeof(pe_dos_header)+64+4+sizeof(coff_image_header)+
     sizeof(coff_optional_image_header64)+sizeof(pe_data_directory)*6+
     sizeof(pe_image_section_header)*finalfile.SectionCount);
    end;
   finalfile.FileStartAddress:=StartOffset;
  end
 else if(fileclass=unifile_class_binary_file) then finalfile.FileStartAddress:=0;
 if(basescript.BaseAddress<>0) and (not (basescript.elfclass=unild_class_relocatable)
 and (fileclass=unifile_class_elf_file)) then
 Address:=basescript.BaseAddress+finalfile.FileStartAddress else Address:=finalfile.FileStartAddress;
 if(basescript.BaseAddress<>0) then
 finalfile.BaseAddress:=basescript.BaseAddress;
 if(basescript.IsUntypedBinary) and (basescript.UntypedBinaryAddressable) then Offset:=Address
 else Offset:=finalfile.FileStartAddress;
 if(fileclass=unifile_class_pe_file) then
  begin
   finalfile.BaseOfCode:=0; finalfile.BaseOfData:=0;
   finalfile.SizeofCode:=0; finalfile.SizeofInitializedData:=0;
   finalfile.SizeofUninitializedData:=0;
  end;
 if(fileclass<>unifile_class_binary_file) then
  begin
   finalfile.FileAlign:=basescript.FileAlign; j:=1;
   for i:=1 to finalfile.SectionCount do
    begin
     if(FileClass=unifile_class_pe_file) or
     ((i>1) and (finalfile.SectionAttribute[i-2]
      and (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
      or unifile_attribute_thread_local_storage)<>finalfile.SectionAttribute[i-1]
      and (unifile_attribute_alloc or unifile_attribute_execute or unifile_attribute_write
      or unifile_attribute_thread_local_storage))) then
      begin
       Address:=unifile_align(Address,FinalFile.FileAlign);
       Offset:=unifile_align(Offset,FinalFile.FileAlign);
      end
     else
      begin
       Address:=unifile_align(Address,finalfile.SectionAlign[i-1]);
       Offset:=unifile_align(Offset,finalfile.SectionAlign[i-1]);
      end;
     if(finalfile.SectionAddress[i-1]<=Address) and (finalfile.SectionAttribute[i-1]<>0)
     then finalfile.SectionAddress[i-1]:=Address
     else if(finalfile.SectionAttribute[i-1]<>0) then
     Address:=finalfile.SectionAddress[i-1];
     finalfile.SectionOffset[i-1]:=Offset;
     if(fileclass=unifile_class_pe_file) and (finalfile.SectionAttribute[i-1] and
     (unifile_attribute_alloc or unifile_attribute_execute)=
     (unifile_attribute_alloc or unifile_attribute_execute)) then
      begin
       if(finalfile.BaseOfCode=0) then
       finalfile.BaseOfCode:=Address-basescript.BaseAddress;
       inc(finalfile.SizeofCode,finalfile.SectionSize[i-1]);
      end;
     if(fileclass=unifile_class_pe_file) and (finalfile.SectionAttribute[i-1] and
     (unifile_attribute_alloc or unifile_attribute_write)=
     (unifile_attribute_alloc or unifile_attribute_write)) then
      begin
       if(finalfile.BaseOfData=0) then
       finalfile.BaseOfData:=Address-basescript.BaseAddress;
       inc(finalfile.SizeofInitializedData,finalfile.SectionSize[i-1]);
      end;
     if(fileclass=unifile_class_pe_file) and (finalfile.SectionAttribute[i-1] and
     unifile_attribute_not_in_file=unifile_attribute_not_in_file) then
      begin
       inc(finalfile.SizeofUnInitializedData,finalfile.SectionSize[i-1]);
      end;
     if(finalfile.SectionAttribute[i-1]<>0) then inc(Address,finalfile.SectionSize[i-1]);
     if(finalfile.SectionAttribute[i-1] and
     unifile_attribute_not_in_file<>unifile_attribute_not_in_file) then
     inc(Offset,finalfile.SectionSize[i-1]);
    end;
  end
 else
  begin
   for i:=1 to finalfile.SectionCount do
    begin
     if(basescript.UntypedBinaryAlign=0) then
      begin
       Address:=unifile_align(Address,finalfile.SectionAlign[i-1]);
       Offset:=unifile_align(Offset,finalfile.SectionAlign[i-1]);
      end
     else
      begin
       Address:=unifile_align(Address,basescript.UntypedBinaryAlign);
       Offset:=unifile_align(Offset,basescript.UntypedBinaryAlign);
      end;
     if(basescript.UntypedBinaryAddressable) then
      begin
       if(finalfile.SectionAddress[i-1]<=Address) then finalfile.SectionAddress[i-1]:=Address
       else Address:=finalfile.SectionAddress[i-1];
       Offset:=Address;
       finalfile.SectionOffset[i-1]:=Address;
      end
     else
      begin
       if(finalfile.SectionAddress[i-1]<=Address) then finalfile.SectionAddress[i-1]:=Address
       else Address:=finalfile.SectionAddress[i-1];
       finalfile.SectionOffset[i-1]:=Offset;
      end;
     inc(Address,finalfile.SectionSize[i-1]);
     inc(Offset,finalfile.SectionSize[i-1]);
    end;
  end;
 {Get the Section Address and Size of the .got or .dynamic Symbol if specified}
 if(not ((basescript.elfclass=unild_class_relocatable) and (fileclass=unifile_class_elf_file))) and
 (basescript.GlobalOffsetTableSectionEnable) and (finalfile.GotIndex>0) then
  begin
   finalfile.SymbolTable.SymbolValue[GotSymbolIndex-1]:=finalfile.SectionAddress[finalfile.GotIndex-1];
   finalfile.SymbolTable.SymbolSize[GotSymbolIndex-1]:=finalfile.SectionSize[finalfile.GotIndex-1];
  end;
 if(fileclass=unifile_class_elf_file) and (basescript.elfclass<>unild_class_relocatable) and
 (basescript.DynamicSectionEnable) and (finalfile.DynamicIndex>0) then
  begin
   finalfile.SymbolTable.SymbolValue[DynamicSymbolIndex-1]:=
   finalfile.SectionAddress[finalfile.DynamicIndex-1];
   finalfile.SymbolTable.SymbolSize[DynamicSymbolIndex-1]:=
   finalfile.SectionSize[finalfile.DynamicIndex-1];
  end;
 {Generate the empty PE Symbol Table}
 if(fileclass=unifile_class_pe_file) and (basescript.NoSymbol=false) then
  begin
   finalfile.CoffStringTableSize:=4;
   finalfile.CoffSymbolTableSize:=0;
   i:=1;
   while(i<=finalfile.SymbolTable.SymbolCount)do
    begin
     if(length(finalfile.SymbolTable.SymbolName[
     finalfile.SymbolTableNewIndex[i-1]-1])>8) then
      begin
       inc(finalfile.CoffStringTableSize,length(finalfile.SymbolTable.SymbolName[
       finalfile.SymbolTableNewIndex[i-1]-1])+1);
      end;
     inc(i);
    end;
   finalfile.CoffSymbolTableSize:=sizeof(coff_symbol_table_item)*finalfile.SymbolTable.SymbolCount;
   finalfile.CoffStringTableContent:=allocmem(finalfile.CoffStringTableSize);
   finalfile.CoffSymbolTableContent:=allocmem(finalfile.CoffSymbolTableSize);
   Pdword(finalfile.CoffStringTableContent)^:=finalfile.CoffStringTableSize;
   i:=1; j:=4; m:=1; n:=1;
   while(i<=finalfile.SymbolTable.SymbolCount)do
    begin
     if(length(finalfile.SymbolTable.SymbolName[
     finalfile.SymbolTableNewIndex[i-1]-1])>8) then
      begin
       Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.Name.Offset:=j;
       k:=1;
       while(k<=length(finalfile.SymbolTable.SymbolName[
       finalfile.SymbolTableNewIndex[i-1]-1]))do
        begin
         (finalfile.CoffStringTableContent+j+k-1)^:=
         finalfile.SymbolTable.SymbolName[finalfile.SymbolTableNewIndex[i-1]-1][k];
         inc(k);
        end;
       inc(j,length(finalfile.SymbolTable.SymbolName[finalfile.SymbolTableNewIndex[i-1]-1])+1);
       Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.Name.Reserved:=0;
      end
     else
      begin
       m:=1;
       while(m<=length(finalfile.SymbolTable.SymbolName[finalfile.SymbolTableNewIndex[i-1]-1]))do
        begin
         Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.Name.Name[m]:=
         finalfile.SymbolTable.SymbolName[finalfile.SymbolTableNewIndex[i-1]-1][m];
         inc(m);
        end;
      end;
     if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]=
     elf_symbol_type_file) then
     Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.SectionNumber:=
     coff_image_symbol_absolute
     else
     Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.SectionNumber:=
     finalfile.SymbolTable.SymbolSectionIndex[finalfile.SymbolTableNewIndex[i-1]-1];
     if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]=
     elf_symbol_type_file) then
     Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.Address:=0
     else if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]=
     elf_symbol_type_section) then
     Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.Address:=
     finalfile.SectionAddress[finalfile.SymbolTable.SymbolSectionIndex[
     finalfile.SymbolTableNewIndex[i-1]-1]-1]-basescript.BaseAddress
     else
     Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.Address:=
     finalfile.SectionAddress[finalfile.SymbolTable.SymbolSectionIndex[
     finalfile.SymbolTableNewIndex[i-1]-1]-1]+
     finalfile.SymbolTable.SymbolValue[finalfile.SymbolTableNewIndex[i-1]-1]-basescript.BaseAddress;
     if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]=
     elf_symbol_type_function) or
     (finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]=
     elf_symbol_type_object) then
      begin
       Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.StorageClass:=
       coff_image_symbol_class_function;
       Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.SymbolType:=
       coff_image_symbol_high_type_function shl 4;
      end
     else if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]=
     elf_symbol_type_section) then
      begin
       Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.StorageClass:=
       coff_image_symbol_class_section;
       Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.SymbolType:=0;
      end
     else if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]=
     elf_symbol_type_file) then
      begin
       Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.StorageClass:=
       coff_image_symbol_class_file;
       Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.SymbolType:=0;
      end;
     Pcoff_symbol_table_item(finalfile.CoffSymbolTableContent+i-1)^.NumberOfAuxSymbols:=0;
     inc(i);
    end;
  end;
 {Calculate the File Size of the Output File}
 finalfile.FinalSectionOffset:=0; finalfile.FinalFileSize:=0;
 if(fileclass=unifile_class_pe_file) then
  begin
   finalfile.FinalSectionOffset:=unifile_align(Offset,finalfile.FileAlign);
   finalfile.FinalFileSize:=
   unifile_align(finalfile.FinalSectionOffset
   +finalfile.CoffStringTableSize+finalfile.CoffSymbolTableSize,finalfile.FileAlign);
  end
 else if(fileclass=unifile_class_elf_file) then
  begin
   finalfile.FinalSectionOffset:=Offset;
   if(finalfile.Bits=32) then
   finalfile.FinalFileSize:=Offset+sizeof(elf32_section_header)*(finalfile.SectionCount+1)
   else
   finalfile.FinalFileSize:=Offset+sizeof(elf64_section_header)*(finalfile.SectionCount+1);
  end
 else
  begin
   finalfile.FinalFileSize:=Offset;
   finalfile.FinalSectionOffset:=Offset;
  end;
 {For Deciding the Entry Address}
 if(fileclass=unifile_class_pe_file) then
 finalfile.EntryAddress:=finalfile.SectionAddress[SectionIndex[basefile.EntrySectionIndex-1]-1]+
 basefile.EntryOffset-basescript.BaseAddress
 else
 finalfile.EntryAddress:=finalfile.SectionAddress[SectionIndex[basefile.EntrySectionIndex-1]-1]+
 basefile.EntryOffset;
 {For Adjust of Relocation Table to the file}
 RelocationSwitch:=false; j:=1; k:=1; m:=1;
 if(basescript.elfclass<>unild_class_relocatable) or (fileclass=unifile_class_pe_file) then
 RelocationSwitch:=true;
 FileResult.AdjustValue:=0; FileResult.RiscvType:=0; FileResult.Bits:=0;
 FileResult.GotType:=0; FileResult.SpecialBool:=false;
 if(finalfile.GotTableList.GotCount>0) then
 GotAddress:=finalfile.SectionAddress[finalfile.GotIndex-1] else GotAddress:=0;
 for i:=1 to basefile.AdjustTable.Count do
  begin
   OriginalAddress:=finalfile.SectionAddress
   [SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]-1]+
   basefile.AdjustTable.OriginalOffset[i-1];
   if(basefile.AdjustTable.GoalSectionIndex[i-1]<>0) then
   GoalAddress:=finalfile.SectionAddress[
   SectionIndex[basefile.AdjustTable.GoalSectionIndex[i-1]-1]-1]+basefile.AdjustTable.GoalOffset[i-1]
   else GoalAddress:=0;
   if(finalfile.Architecture=elf_machine_386) then
    begin
     {Data Sequence:S,A,B,P,L,GOT,G}
     if(RelocationSwitch=false) and ((basefile.AdjustTable.GoalSectionIndex[i-1]<>
     basefile.AdjustTable.OriginalSectionIndex[i-1])
     or (basefile.AdjustTable.GoalSectionIndex[i-1]=0)) then
      begin
       Pelf32_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf32_rela))^.Offset:=basefile.AdjustTable.OriginalOffset[i-1];
       Pelf32_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf32_rela))^.Addend:=
       basefile.AdjustTable.AdjustAddend[i-1];
       n:=finalfile.SymbolTableNewIndex[unifile_search_for_hash_table(finalfile.SymbolTableAssist,basefile.AdjustTable.AdjustHash[i-1])-1];
       Pelf32_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf32_rela))^.Info:=
       elf32_reloc_info(n,basefile.AdjustTable.AdjustType[i-1]);
       inc(AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]);
      end
     else if(basefile.AdjustTable.GoalSectionIndex[i-1]=0) then
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got_plt,
       [0,basefile.AdjustTable.AdjustAddend[i-1],0,
       OriginalAddress,OriginalAddress,GotAddress,(GotInternalIndex+2)*4],false);
       n:=unifile_search_for_hash_table(finalfile.DynamicSymbolTableAssist,
       basefile.AdjustTable.AdjustHash[i-1]);
       if(GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false)
       and(finalfile.RelocationDynamicTableIndex<>0)then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         Pelf32_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf32_rela))^.Offset:=
         GotAddress+(GotInternalIndex+2)*4;
         Pelf32_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf32_rela))^.Addend:=
         basefile.AdjustTable.AdjustAddend[i-1];
         Pelf32_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(n,elf_reloc_i386_32bit);
         inc(j);
        end;
      end
     else
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got,
       [GoalAddress,basefile.AdjustTable.AdjustAddend[i-1],0,
       OriginalAddress,OriginalAddress,
       GotAddress,(GotInternalIndex+GotPltOffset+GotProtect-1)*4]);
       if(FileResult.GotType<>0) and
       (GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false) then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0) then
          begin
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Offset:=
           GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4;
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Addend:=
           GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(0,elf_reloc_i386_relative);
           inc(AllSectionOffset[finalfile.RelocationDynamicTableIndex-1]);
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           if(m=1) then
            begin
             finalfile.CoffList[k-1].VirtualAddress:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4
             -basescript.BaseAddress;
             finalfile.CoffList[k-1].Item[m-1].Offset:=0;
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_highlow;
             inc(m);
            end
           else
            begin
             finalfile.CoffList[k-1].Item[m-1].Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4
             -basescript.BaseAddress-finalfile.CoffList[k-1].VirtualAddress;
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_highlow;
             inc(m);
             if(m=1025) then
              begin
               m:=1; inc(k);
              end;
            end;
          end;
         Pdword(finalfile.SectionContent[finalfile.GotIndex-1]+
         (GotInternalIndex+GotPltOffset+GotProtect-1)*4)^:=GoalAddress
         +basefile.AdjustTable.AdjustAddend[i-1];
        end
       else if(FileResult.ConvertToRelocationBits>0) and (FileList.NeedCount>0)
       and(basefile.SectionAttribute[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]<>0) then
        begin
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0)
         and(FileResult.ConvertToRelocationBits=finalfile.Bits) then
          begin
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Offset:=OriginalAddress;
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Addend:=
           GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(0,elf_reloc_i386_relative);
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           FileList.NeedBits[j-1]:=FileResult.ConvertToRelocationBits;
           FileList.NeedAddress[j-1]:=OriginalAddress;
           inc(j);
          end;
        end;
      end;
     ChangePointer:=
     finalfile.SectionContent[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]-1]+
     basefile.AdjustTable.OriginalOffset[i-1];
     ChangeValue:=unifile_calculate_comple(FileResult.AdjustValue,FileResult.Bits,
     FileResult.AdjustValue<0);
     if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_i386_got_relaxable)
     and (not ((RelocationSwitch=false) and ((basefile.AdjustTable.GoalSectionIndex[i-1]<>
     basefile.AdjustTable.OriginalSectionIndex[i-1])
     or (basefile.AdjustTable.GoalSectionIndex[i-1]=0)) or
     ((RelocationSwitch) and (basefile.AdjustTable.GoalSectionIndex[i-1]=0)))) then
      begin
       if(Pbyte(ChangePointer-2)^=$8B) then Pbyte(ChangePointer-2)^:=$8D;
      end;
     if(FileResult.Bits=32) then
      begin
       Pdword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=16) then
      begin
       Pword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=8) then
      begin
       Pbyte(ChangePointer)^:=ChangeValue;
      end;
    end
   else if(finalfile.Architecture=elf_machine_arm) then
    begin
     {Data Sequence:S,A,B,T,P,Pa,PLT,GOT_ORG,GOT}
     if(RelocationSwitch=false) and ((basefile.AdjustTable.GoalSectionIndex[i-1]<>
     basefile.AdjustTable.OriginalSectionIndex[i-1]) or
     (basefile.AdjustTable.GoalSectionIndex[i-1]=0)) then
      begin
       Pelf32_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf32_rela))^.Offset:=basefile.AdjustTable.OriginalOffset[i-1];
       Pelf32_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf32_rela))^.Addend:=
       basefile.AdjustTable.AdjustAddend[i-1];
       n:=finalfile.SymbolTableNewIndex[unifile_search_for_hash_table(finalfile.SymbolTableAssist,basefile.AdjustTable.AdjustHash[i-1])-1];
       Pelf32_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf32_rela))^.Info:=
       elf32_reloc_info(n,basefile.AdjustTable.AdjustType[i-1]);
       inc(AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]);
      end
     else if(basefile.AdjustTable.GoalSectionIndex[i-1]=0) then
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got_plt,
       [0,basefile.AdjustTable.AdjustAddend[i-1],0,Byte(basefile.AdjustTable.AdjustFunc[i-1]),
       OriginalAddress,OriginalAddress,OriginalAddress,GotAddress,
       GotAddress+(GotInternalIndex+2)*4]);
       n:=unifile_search_for_hash_table(finalfile.DynamicSymbolTableAssist,
       basefile.AdjustTable.AdjustHash[i-1]);
       if(GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false)
       and(finalfile.RelocationDynamicTableIndex<>0)then
        begin
         j:=AllSectionOffset[finalfile.RelocationDynamicTableIndex-1];
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         Pelf32_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf32_rela))^.Offset:=
         GotAddress+(GotInternalIndex+2)*4;
         Pelf32_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf32_rela))^.Addend:=
         basefile.AdjustTable.AdjustAddend[i-1];
         Pelf32_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(n,elf_reloc_arm_absolute_32bit);
         inc(AllSectionOffset[finalfile.RelocationDynamicTableIndex-1]);
        end;
      end
     else
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got,
       [GoalAddress,basefile.AdjustTable.AdjustAddend[i-1],0,
       Byte(basefile.AdjustTable.AdjustFunc[i-1]),
       OriginalAddress,OriginalAddress,GoalAddress,GotAddress,
       GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4]);
       if(FileResult.GotType<>0) and
       (GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false) then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0)
         and(FileResult.ConvertToRelocationBits=finalfile.Bits) then
          begin
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Offset:=
           GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4;
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Addend:=
           GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(0,elf_reloc_arm_relative);
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           if(m=1) then
            begin
             finalfile.CoffList[k-1].VirtualAddress:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4
             -basescript.BaseAddress;
             finalfile.CoffList[k-1].Item[m-1].Offset:=0;
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_highlow;
             inc(m);
            end
           else
            begin
             finalfile.CoffList[k-1].Item[m-1].Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4
             -basescript.BaseAddress-finalfile.CoffList[k-1].VirtualAddress;
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_highlow;
             inc(m);
             if(m=1025) then
              begin
               m:=1; inc(k);
              end;
            end;
          end;
         Pdword(finalfile.SectionContent[finalfile.GotIndex-1]+
         (GotInternalIndex+GotPltOffset+GotProtect-1)*4)^:=
         GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
        end
       else if(FileResult.ConvertToRelocationBits>0) and (FileList.NeedCount>0)
       and(basefile.SectionAttribute[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]<>0) then
        begin
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0) then
          begin
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Offset:=OriginalAddress;
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Addend:=
           GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(0,elf_reloc_arm_relative);
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           FileList.NeedBits[j-1]:=FileResult.ConvertToRelocationBits;
           FileList.NeedAddress[j-1]:=OriginalAddress;
           inc(j);
          end;
        end;
      end;
     ChangePointer:=finalfile.SectionContent[SectionIndex[basefile.AdjustTable.
     OriginalSectionIndex[i-1]-1]-1]+basefile.AdjustTable.OriginalOffset[i-1];
     ChangeValue:=unifile_calculate_comple(FileResult.AdjustValue,FileResult.Bits,
     FileResult.AdjustValue<0);
     if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_pc_relative_13bit_branch)or
     ((basefile.AdjustTable.AdjustType[i-1]>=elf_reloc_arm_ldr_str_ldrb_strb_pc_relative_g1)
     and (basefile.AdjustTable.AdjustType[i-1]<=elf_reloc_arm_ldr_str_pc_relative_g2))
     or ((basefile.AdjustTable.AdjustType[i-1]>=elf_reloc_arm_program_base_relative_ldr_str_ldrb_strb_g0)
     and (basefile.AdjustTable.AdjustType[i-1]<=elf_reloc_arm_program_base_relative_ldrs_g2)) then
      begin
       d1:=0;
       if(FileResult.AdjustValue>=0) then d1:=1 shl 23;
       d1:=d1 or ChangeValue;
       d2:=1 shl 23+$FFF; d2:=Pdword(changePointer)^ and (not d2);
       d3:=d1+d2;
       Pdword(changePointer)^:=d3;
      end
     else if((basefile.AdjustTable.AdjustType[i-1]>=elf_reloc_arm_ldc_stc_pc_relative_g0) and
     (basefile.AdjustTable.AdjustType[i-1]<=elf_reloc_arm_ldc_stc_pc_relative_g2))
     or((basefile.AdjustTable.AdjustType[i-1]>=elf_reloc_arm_ldc_base_relative_g0) and
     (basefile.AdjustTable.AdjustType[i-1]<=elf_reloc_arm_ldc_base_relative_g2)) then
      begin
       d1:=0;
       if(FileResult.AdjustValue>=0) then d1:=1 shl 23;
       d1:=d1 or ChangeValue;
       d2:=1 shl 23+$FFF; d2:=Pdword(ChangePointer)^ and (not d2);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_absolute_5bit) then
      begin
       d1:=(ChangeValue shr 2) and $7C0;
       d2:=Pdword(ChangePointer)^ and (not $000007C0);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_pc_8bit) then
      begin
       d1:=(ChangeValue shr 2) and $FF;
       d2:=Pdword(ChangePointer)^ and (not $000000FF);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_pc_relative_6bit_b) then
      begin
       d1:=(ChangeValue shr 6) and 1 shl 9+(ChangeValue shr 1) and $1F;
       d2:=Pdword(ChangePointer)^ and (not $000002FF);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_pc_11bit) then
      begin
       d1:=(ChangeValue shr 1) and $3FF;
       d2:=Pdword(ChangePointer)^ and (not $000003FF);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_pc_9bit) then
      begin
       d1:=(ChangeValue shr 1) and $FF;
       d2:=Pdword(ChangePointer)^ and (not $000000FF);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_alu_abs_g0_no_check) then
      begin
       d1:=ChangeValue and $FF;
       d2:=Pdword(ChangePointer)^ and (not $000000FF);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_alu_abs_g1_no_check) then
      begin
       d1:=(ChangeValue shr 8) and $FF;
       d2:=Pdword(ChangePointer)^ and (not $000000FF);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_alu_abs_g2_no_check) then
      begin
       d1:=(ChangeValue shr 16) and $FF;
       d2:=Pdword(ChangePointer)^ and (not $000000FF);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_alu_abs_g3) then
      begin
       d1:=(ChangeValue shr 24) and $FF;
       d2:=Pdword(ChangePointer)^ and (not $000000FF);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_pc_22bit) then
      begin
       d1:=ChangeValue and $003FFFFF;
       d2:=Pdword(ChangePointer)^ and (not $003FFFFF);
       d3:=d1+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_pc_relative_24bit) then
      begin
       d2:=ChangeValue and $7FF;
       d3:=ChangeValue shr 11 and $3FF;
       d2:=d2+d3 shl 16;
       d4:=Pdword(ChangePointer)^ and (not ($000003FF shl 16+$000007FF));
       d4:=d4+d2;
       Pdword(ChangePointer)^:=d4;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_movw_absolute)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_movw_pc_relative)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_movw_base_relative_no_check)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_movw_base_relative) then
      begin
       d1:=ChangeValue and $FF;
       d2:=ChangeValue shr 12;
       d3:=ChangeValue shr 8 and $7;
       d4:=ChangeValue shr 11 and $1;
       d5:=Pdword(ChangePointer)^ and (not ($000000FF+$00000007 shl 12+$00000001 shl 26+$0000000F shl 16));
       d6:=d5+d1+d2 shl 16+d4 shl 26+d3 shl 12;
       Pdword(ChangePointer)^:=d6;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_movt_absolute)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_movt_pc_relative)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_movt_base_relative) then
      begin
       d1:=(ChangeValue shr 16) and $FF;
       d2:=ChangeValue shr 28;
       d3:=ChangeValue shr 24 and $7;
       d4:=ChangeValue shr 27 and $1;
       d5:=Pdword(ChangePointer)^ and (not ($000000FF+$00000007 shl 12+$00000001 shl 26+$0000000F shl 16));
       d6:=d5+d1+d2 shl 16+d4 shl 26+d3 shl 12;
       Pdword(ChangePointer)^:=d6;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_pc_relative_20bit_b) then
      begin
       d1:=ChangeValue and $7FF;
       d2:=ChangeValue shr 11 and $3F;
       d2:=d2 shl 16+d1;
       d3:=Pdword(ChangePointer)^ and (not ($000007FF+$0000003F shl 16));
       d3:=d3+d2;
       Pdword(ChangePointer)^:=d3;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_alu_pc_relative_bit11_0) then
      begin
       d1:=ChangeValue shr 11;
       d2:=ChangeValue shr 8 and $7;
       d3:=ChangeValue and $FF;
       d4:=d1 shl 26+d2 shl 12+d3;
       d5:=Pdword(ChangePointer)^ and (not (1 shl 26+$7 shl 12+$FF));
       d5:=d5+d4;
       Pdword(ChangePointer)^:=d5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_pc_12bit) then
      begin
       d1:=0;
       if(FileResult.AdjustValue>=0) then d1:=1 shl 23;
       d1:=d1 or ChangeValue;
       d2:=1 shl 23+$FFF; d2:=Pdword(ChangePointer)^ and (not d2);
       d1:=d1+d2;
       Pdword(ChangePointer)^:=d1;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_got_entry_relative_to_got_origin) then
      begin
       d1:=Pdword(ChangePointer)^ and (not (1 shl 23+$FFF));
       d1:=d1+ChangeValue;
       Pdword(ChangePointer)^:=d1;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_bf16) then
      begin
       d1:=ChangeValue shr 2 and $000003FF;
       d2:=ChangeValue shr 1 and 1;
       d3:=ChangeValue shr 12;
       d4:=d1 shl 1+d2 shl 11+d3 shl 16;
       d2:=Pdword(ChangePointer)^ and (not ($000003FF shl 1+$00000001 shl 11+$0000001F shl 16));
       d4:=d4+d2;
       Pdword(ChangePointer)^:=d4;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_bf12) then
      begin
       d1:=ChangeValue shr 2 and $000003FF;
       d2:=ChangeValue shr 1 and 1;
       d3:=ChangeValue shr 12;
       d4:=d1 shl 1+d2 shl 11+d3 shl 16;
       d2:=Pdword(ChangePointer)^ and (not ($000003FF shl 1+$00000001 shl 11+$00000001 shl 16));
       d4:=d4+d2;
       Pdword(ChangePointer)^:=d4;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_arm_thumb_bf18) then
      begin
       d1:=ChangeValue shr 2 and $000003FF;
       d2:=ChangeValue shr 1 and 1;
       d3:=ChangeValue shr 12;
       d4:=d1 shl 1+d2 shl 11+d3 shl 16;
       d2:=Pdword(ChangePointer)^ and (not ($000003FF shl 1+$00000001 shl 11+$0000007F shl 16));
       d4:=d4+d2;
       Pdword(ChangePointer)^:=d4;
      end
     else if(FileResult.Bits=32) then
      begin
       PInteger(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=16) then
      begin
       PShortint(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=8) then
      begin
       PSmallint(ChangePointer)^:=ChangeValue;
      end;
    end
   else if(finalfile.Architecture=elf_machine_x86_64) then
    begin
     {Data Sequence:S,A,B,P,L,GOT,G,Z}
     if(RelocationSwitch=false) and ((basefile.AdjustTable.GoalSectionIndex[i-1]<>
     basefile.AdjustTable.OriginalSectionIndex[i-1]) or
     (basefile.AdjustTable.GoalSectionIndex[i-1]=0)) then
      begin
       Pelf64_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf64_rela))^.Offset:=basefile.AdjustTable.OriginalOffset[i-1];
       Pelf64_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf64_rela))^.Addend:=
       basefile.AdjustTable.AdjustAddend[i-1];
       n:=finalfile.SymbolTableNewIndex[unifile_search_for_hash_table(finalfile.SymbolTableAssist,basefile.AdjustTable.AdjustHash[i-1])-1];
       Pelf64_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf64_rela))^.Info:=
       elf64_reloc_info(n,basefile.AdjustTable.AdjustType[i-1]);
       inc(AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]);
      end
     else if(basefile.AdjustTable.GoalSectionIndex[i-1]=0) then
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got_plt,
       [0,basefile.AdjustTable.AdjustAddend[i-1],0,
       OriginalAddress,GoalAddress,GotAddress,(GotInternalIndex+2)*8,
       basefile.AdjustTable.AdjustSize[i-1]],false);
       n:=unifile_search_for_hash_table(finalfile.DynamicSymbolTableAssist,
       basefile.AdjustTable.AdjustHash[i-1]);
       if(GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false)
       and(finalfile.RelocationDynamicTableIndex<>0) then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         Pelf64_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf64_rela))^.Offset:=
         GotAddress+(GotInternalIndex+2)*8;
         Pelf64_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf64_rela))^.Addend:=
         basefile.AdjustTable.AdjustAddend[i-1];
         Pelf64_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(n,elf_reloc_x86_64_64bit);
         inc(j);
        end;
      end
     else
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got,
       [GoalAddress,basefile.AdjustTable.AdjustAddend[i-1],0,OriginalAddress,GoalAddress,
       GotAddress,(GotInternalIndex+GotPltOffset+GotProtect-1)*8,
       basefile.AdjustTable.AdjustSize[i-1]]);
       if(FileResult.GotType<>0) and
       (GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false) then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0) then
          begin
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Offset:=
           GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4;
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Addend:=
           GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(0,elf_reloc_x86_64_relative);
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           if(m=1) then
            begin
             finalfile.CoffList[k-1].VirtualAddress:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8
             -basescript.BaseAddress;
             finalfile.CoffList[k-1].Item[m-1].Offset:=0;
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_dir64;
             inc(m);
            end
           else
            begin
             finalfile.CoffList[k-1].Item[m-1].Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8
             -basescript.BaseAddress-finalfile.CoffList[k-1].VirtualAddress;
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_dir64;
             inc(m);
             if(m=513) then
              begin
               m:=1; inc(k);
              end;
            end;
          end;
         Pqword(finalfile.SectionContent[finalfile.GotIndex-1]+(GotInternalIndex+GotPltOffset+GotProtect-1)*8)^:=
         GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
        end
       else if(FileResult.ConvertToRelocationBits>0) and (FileList.NeedCount>0)
       and(basefile.SectionAttribute[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]<>0) then
        begin
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0)
         and(FileResult.ConvertToRelocationBits=finalfile.Bits) then
          begin
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Offset:=OriginalAddress;
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Addend:=
           GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(0,elf_reloc_x86_64_relative);
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           FileList.NeedBits[j-1]:=FileResult.ConvertToRelocationBits;
           FileList.NeedAddress[j-1]:=OriginalAddress;
           inc(j);
          end;
        end;
      end;
     ChangePointer:=
     finalfile.SectionContent[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]-1]+
     basefile.AdjustTable.OriginalOffset[i-1];
     ChangeValue:=unifile_calculate_comple(FileResult.AdjustValue,FileResult.Bits,
     FileResult.AdjustValue<0);
     if(not ((RelocationSwitch=false) and ((basefile.AdjustTable.GoalSectionIndex[i-1]<>
     basefile.AdjustTable.OriginalSectionIndex[i-1])
     or (basefile.AdjustTable.GoalSectionIndex[i-1]=0)) or
     ((RelocationSwitch) and (basefile.AdjustTable.GoalSectionIndex[i-1]=0)))) then
      begin
       if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_x86_64_got_pc_relative_without_rex) then
        begin
         case Pbyte(ChangePointer-1)^ of
         $15:Pword(ChangePointer-2)^:=$E840;
         $25:Pword(ChangePointer-2)^:=$E940;
         end;
        end
       else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_x86_64_got_pc_relative_with_rex)
       or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_x86_64_pc_relative_offset_got)then
       Pbyte(ChangePointer-2)^:=$8D;
      end;
     if(FileResult.Bits=64) then
      begin
       Pqword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=32) then
      begin
       Pdword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=16) then
      begin
       Pword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=8) then
      begin
       Pbyte(ChangePointer)^:=ChangeValue;
      end;
    end
   else if(finalfile.Architecture=elf_machine_aarch64) then
    begin
     {Data Sequence:S,A,Delta,P,GDAT,GOT,G,B}
     if(RelocationSwitch=false) and ((basefile.AdjustTable.GoalSectionIndex[i-1]<>
     basefile.AdjustTable.OriginalSectionIndex[i-1]) or
     (basefile.AdjustTable.GoalSectionIndex[i-1]=0)) then
      begin
       Pelf64_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf64_rela))^.Offset:=basefile.AdjustTable.OriginalOffset[i-1];
       Pelf64_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf64_rela))^.Addend:=
       basefile.AdjustTable.AdjustAddend[i-1];
       n:=finalfile.SymbolTableNewIndex[unifile_search_for_hash_table(finalfile.SymbolTableAssist,basefile.AdjustTable.AdjustHash[i-1])-1];
       Pelf64_rela(finalfile.SectionContent[
       SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
       ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
       *sizeof(elf64_rela))^.Info:=
       elf64_reloc_info(n,basefile.AdjustTable.AdjustType[i-1]);
       inc(AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]);
      end
     else if(basefile.AdjustTable.GoalSectionIndex[i-1]=0) then
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got_plt,
       [0,basefile.AdjustTable.AdjustAddend[i-1],0,
       OriginalAddress,(GotInternalIndex+2)*8,GotAddress,GotAddress,0]);
       n:=unifile_search_for_hash_table(finalfile.DynamicSymbolTableAssist,
       basefile.AdjustTable.AdjustHash[i-1]);
       if(GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false)
       and (finalfile.RelocationDynamicTableIndex<>0)then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         Pelf64_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf64_rela))^.Offset:=
         GotAddress+(GotInternalIndex+2)*8;
         Pelf64_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf64_rela))^.Addend:=
         basefile.AdjustTable.AdjustAddend[i-1];
         Pelf64_rela(finalfile.SectionContent[
         finalfile.RelocationDynamicTableIndex-1
         ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(n,elf_reloc_aarch64_absolute_64bit);
         inc(j);
        end;
      end
     else
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got,
       [GoalAddress,basefile.AdjustTable.AdjustAddend[i-1],0,
       OriginalAddress,(GotInternalIndex+GotPltOffset+GotProtect-1)*8,
       GotAddress,GotAddress,0]);
       if(FileResult.GotType<>0) and
       (GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false) then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0) then
          begin
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Offset:=
           GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8;
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Addend:=
           GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(0,elf_reloc_aarch64_relative);
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           if(m=1) then
            begin
             finalfile.CoffList[k-1].VirtualAddress:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8
             -basescript.BaseAddress;
             finalfile.CoffList[k-1].Item[m-1].Offset:=0;
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_dir64;
             inc(m);
            end
           else
            begin
             finalfile.CoffList[k-1].Item[m-1].Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8
             -basescript.BaseAddress-finalfile.CoffList[k-1].VirtualAddress;
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_dir64;
             inc(m);
             if(m=513) then
              begin
               m:=1; inc(k);
              end;
            end;
          end;
         Pqword(finalfile.SectionContent[finalfile.GotIndex-1]+(GotInternalIndex+GotPltOffset+GotProtect-1)*8)^:=
         GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
        end
       else if(FileResult.ConvertToRelocationBits>0) and (FileList.NeedCount>0)
       and(basefile.SectionAttribute[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]<>0) then
        begin
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0)
         and(FileResult.ConvertToRelocationBits=finalfile.Bits) then
          begin
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Offset:=OriginalAddress;
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Addend:=GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(0,elf_reloc_aarch64_relative);
           inc(AllSectionOffset[finalfile.RelocationDynamicTableIndex-1]);
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           FileList.NeedBits[j-1]:=FileResult.ConvertToRelocationBits;
           FileList.NeedAddress[j-1]:=OriginalAddress;
           inc(j);
          end;
        end;
      end;
     ChangePointer:=
     finalfile.SectionContent[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]-1]+
     basefile.AdjustTable.OriginalOffset[i-1];
     ChangeValue:=unifile_calculate_comple(FileResult.AdjustValue,FileResult.Bits,
     FileResult.AdjustValue<0);
     if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_movz_imm_bit15_0)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_movk_imm_bit15_0)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_movk_imm_bit15_0)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_rel_offset_movk_imm_bit15_0) then
      begin
       d1:=ChangeValue and $FFFF;
       d2:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 5));
       d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_movz_imm_bit31_16)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_movk_imm_bit31_16)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_movk_imm_bit31_16)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_rel_offset_movk_imm_bit31_16)then
      begin
       d1:=(ChangeValue shr 16) and $FFFF;
       d2:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 5));
       d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_movz_imm_bit47_32)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_movk_imm_bit47_32)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_movk_imm_bit47_32)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_rel_offset_movk_imm_bit47_32)then
      begin
       d1:=(ChangeValue shr 32) and $FFFF;
       d2:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 5));
       d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_movn_z_imm_bit15_0)
     or (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_movn_z_imm_bit15_0)
     or (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit15_0)then
      begin
       if(FileResult.AdjustValue>=0) then d1:=1 shl 30 else d1:=0;
       d2:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 5+1 shl 30));
       if(FileResult.AdjustValue>=0) then d1:=d1+ChangeValue and $FFFF
       else d1:=d1+not Word(ChangeValue and $FFFF);
       d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_movn_z_imm_bit31_16)
     or (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_movn_z_imm_bit31_16)
     or (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit31_16)then
      begin
       if(FileResult.AdjustValue>=0) then d1:=1 shl 30 else d1:=0;
       d2:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 5+1 shl 30));
       if(FileResult.AdjustValue>=0) then d1:=d1+(ChangeValue shr 16) and $FFFF else
       d1:=d1+not Word((ChangeValue shr 16) and $FFFF);
       d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_movn_z_imm_bit47_32)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_movn_z_imm_bit47_32)
     or (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit47_32)then
      begin
       if(FileResult.AdjustValue>=0) then d1:=1 shl 30 else d1:=0;
       d2:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 5+1 shl 30));
       if(FileResult.AdjustValue>=0) then d1:=d1+(ChangeValue shr 32) and $FFFF
       else d1:=d1+not Word((ChangeValue shr 32) and $FFFF);
       d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_movn_z_imm_bit63_48)
     or (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_rel_offset_movn_z_imm_bit63_48) then
      begin
       if(FileResult.AdjustValue>=0) then d1:=1 shl 30 else d1:=0;
       d2:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 5+1 shl 30));
       if(FileResult.AdjustValue>=0) then d1:=d1+(ChangeValue shr 48) and $FFFF else
       d1:=d1+not Word((ChangeValue shr 48) and $FFFF);
       d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_ldr_literal_pc_rel_low19bit)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_got_offset) then
      begin
       d1:=(ChangeValue shr 2) and $0007FFFF;
       d2:=Pdword(ChangePointer)^ and (not ($0007FFFF shl 5));
       if(FileResult.AdjustValue<0) then d2:=d2+d1 shl 5+1 shl 23 else d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_adr_pc_rel_low21bit) then
      begin
       d1:=ChangeValue and $001FFFFF;
       d2:=d1 and 3; d3:=(d1 shr 2) and $7FFFF;
       d4:=Pdword(ChangePointer)^ and (not ($0007FFFF shl 5+$00000003 shl 29));
       d4:=d4+d2 shl 29+d3 shl 5;
       Pdword(ChangePointer)^:=d4;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_adrp_page_rel_bit32_12)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_adrp_page_rel_bit32_12_no_check)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_page_rel_adrp_bit32_12)then
      begin
       d1:=(ChangeValue shr 12) and $001FFFFF;
       d2:=d1 and 3; d3:=(d1 shr 2) and $7FFFF;
       d4:=Pdword(ChangePointer)^ and (not ($0007FFFF shl 5+$00000003 shl 29));
       d4:=d4+d2 shl 29+d3 shl 5;
       Pdword(ChangePointer)^:=d4;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_add_absolute_low12bit) then
      begin
       d1:=ChangeValue and $00000FFF;
       d2:=Pdword(ChangePointer)^ and (not ($00000FFF shl 10));
       d2:=d2+d1 shl 10;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_ld_or_st_absolute_low12bit) then
      begin
       d1:=ChangeValue and $00000FFF;
       d2:=Pdword(ChangePointer)^ and (not ($00000FFF shl 10));
       d2:=d2+d1 shl 10;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_add_bit16_imm_bit11_1) then
      begin
       d1:=(ChangeValue shr 1) and $7FF;
       d2:=Pdword(ChangePointer)^ and (not ($00000FFF shl 10));
       d2:=d2+d1 shl 11;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_add_bit32_imm_bit11_2) then
      begin
       d1:=(ChangeValue shr 2) and $3FF;
       d2:=Pdword(ChangePointer)^ and (not ($000003FF shl 10));
       d2:=d2+d1 shl 12;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_add_bit64_imm_bit11_3) then
      begin
       d1:=(ChangeValue shr 3) and $1FF;
       d2:=Pdword(ChangePointer)^ and (not ($00000FFF shl 10));
       d2:=d2+d1 shl 13;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_add_bit128_imm_from_bit11_4) then
      begin
       d1:=(ChangeValue shr 4) and $7F;
       d2:=Pdword(ChangePointer)^ and (not ($00000FFF shl 10));
       d2:=d2+d1 shl 10;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_tbz_bit15_2) then
      begin
       d1:=(ChangeValue shr 2) and $1FFF;
       d2:=Pdword(ChangePointer)^ and (not ($00003FFF shl 5));
       d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_cond_or_br_bit20_2) then
      begin
       d1:=(ChangeValue shr 2) and $7FFFF;
       d2:=Pdword(ChangePointer)^ and (not ($0007FFFF shl 5));
       d2:=d2+d1 shl 5;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_jump_bit27_2) or
     (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_rel_call_bit27_2)then
      begin
       d1:=(ChangeValue shr 2) and $03FFFFFF;
       d2:=Pdword(ChangePointer)^ and (not $03FFFFFF);
       d2:=d2+d1;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_rel_offset_ld_st_imm_bit14_3)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_page_rel_got_offset_ld_st_bit14_3) then
      begin
       d1:=(ChangeValue shr 3) and $FFF;
       d2:=Pdword(ChangePointer)^ and (not ($00000FFF shl 10));
       d2:=d2+d1 shl 10;
       Pdword(ChangePointer)^:=d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_dir_got_offset_ld_st_imm_bit11_3) then
      begin
       if(ChangeValue>$1FF) and (FileResult.AdjustValue>=0) then
        begin
         d1:=(ChangeValue shr 3) and $FFF;
         d2:=Pdword(ChangePointer)^ and (not ($000001FF shl 12+$00000001 shl 11+$00000001 shl 24));
         d2:=d2+d1 shl 10+1 shl 24;
         Pdword(ChangePointer)^:=d2;
        end
       else
        begin
         d1:=(ChangeValue shr 3) and $1FF;
         d2:=Pdword(ChangePointer)^ and (not ($000001FF shl 12));
         d2:=d2+d1 shl 12;
         Pdword(ChangePointer)^:=d2;
        end;
      end
     else if(FileResult.Bits=64) or
     (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_relative_64bit) then
      begin
       Pqword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=32)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_got_relative_32bit)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_aarch64_pc_relative_got_offset32) then
      begin
       Pdword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=16) then
      begin
       Pword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=8) then
      begin
       Pbyte(ChangePointer)^:=ChangeValue;
      end;
    end
   else if(finalfile.Architecture=elf_machine_riscv) then
    begin
     {Get the Virtual Address(V)}
     ChangePointer:=
     finalfile.SectionContent[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]-1]+
     basefile.AdjustTable.OriginalOffset[i-1];
     q1:=0;
     if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_riscv_add_8bit)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_riscv_sub_8bit) then
      begin
       q1:=Pbyte(ChangePointer)^;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_riscv_add_16bit)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_riscv_sub_16bit) then
      begin
       q1:=Pword(ChangePointer)^;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_riscv_add_32bit)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_riscv_sub_32bit) then
      begin
       q1:=Pdword(ChangePointer)^;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_riscv_add_64bit)
     or(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_riscv_sub_64bit) then
      begin
       q1:=Pqword(ChangePointer)^;
      end;
     {Data sequence:S,A,Delta,P,V,G,GOT,B}
     if(RelocationSwitch=false) and ((basefile.AdjustTable.GoalSectionIndex[i-1]<>
     basefile.AdjustTable.OriginalSectionIndex[i-1]) or
     (basefile.AdjustTable.GoalSectionIndex[i-1]=0)) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf32_rela))^.Offset:=basefile.AdjustTable.OriginalOffset[i-1];
         Pelf32_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf32_rela))^.Addend:=
         basefile.AdjustTable.AdjustAddend[i-1];
         n:=finalfile.SymbolTableNewIndex[unifile_search_for_hash_table(finalfile.SymbolTableAssist,basefile.AdjustTable.AdjustHash[i-1])-1];
         Pelf32_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf32_rela))^.Info:=
         elf32_reloc_info(n,basefile.AdjustTable.AdjustType[i-1]);
         inc(AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]);
        end
       else
        begin
         Pelf64_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf64_rela))^.Offset:=basefile.AdjustTable.OriginalOffset[i-1];
         Pelf64_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf64_rela))^.Addend:=
         basefile.AdjustTable.AdjustAddend[i-1];
         n:=finalfile.SymbolTableNewIndex[unifile_search_for_hash_table(finalfile.SymbolTableAssist,basefile.AdjustTable.AdjustHash[i-1])-1];
         Pelf64_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf64_rela))^.Info:=
         elf64_reloc_info(n,basefile.AdjustTable.AdjustType[i-1]);
         inc(AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]);
        end;
      end
     else if(basefile.AdjustTable.GoalSectionIndex[i-1]=0) then
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       if(basefile.Bits=32) then
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got_plt,
       [0,basefile.AdjustTable.AdjustAddend[i-1],0,
       finalfile.SectionAddress[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]-1]
       +basefile.AdjustTable.OriginalOffset[i-1],
       q1,(GotInternalIndex+2)*4,GotAddress,0],false,
       basefile.AdjustTable.AdjustRiscVType[i-1])
       else
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got_plt,
       [0,basefile.AdjustTable.AdjustAddend[i-1],0,
       OriginalAddress,q1,(GotInternalIndex+2)*8,GotAddress,0],false,
       basefile.AdjustTable.AdjustRiscVType[i-1]);
       n:=unifile_search_for_hash_table(finalfile.DynamicSymbolTableAssist,
       basefile.AdjustTable.AdjustHash[i-1]);
       if(GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false)
       and(finalfile.RelocationDynamicTableIndex<>0)then
        begin
         if(finalfile.Bits=32) then
          begin
           finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Offset:=
           GotAddress+(GotInternalIndex+2)*4;
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Addend:=
           basefile.AdjustTable.AdjustAddend[i-1];
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(n,elf_reloc_riscv_32bit);
          end
         else
          begin
           finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Offset:=
           GotAddress+(GotInternalIndex+2)*8;
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Addend:=
           basefile.AdjustTable.AdjustAddend[i-1];
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(n,elf_reloc_riscv_64bit);
          end;
         inc(j);
        end;
      end
     else
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       if(finalfile.Bits=32) then
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got,
       [GoalAddress,basefile.AdjustTable.AdjustAddend[i-1],0,
       OriginalAddress,q1,(GotInternalIndex+GotPltOffset+GotProtect-1)*4,GotAddress,0],
       false,basefile.AdjustTable.AdjustRiscVType[i-1])
       else
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got,
       [GoalAddress,basefile.AdjustTable.AdjustAddend[i-1],0,
       OriginalAddress,q1,(GotInternalIndex+GotPltOffset+GotProtect-1)*8,GotAddress,0],
       false,basefile.AdjustTable.AdjustRiscVType[i-1]);
       if(FileResult.GotType<>0) and
       (GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false) then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0) then
          begin
           if(finalfile.Bits=32) then
            begin
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4;
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Addend:=
             GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(0,elf_reloc_riscv_relative);
            end
           else
            begin
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8;
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Addend:=
             GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(0,elf_reloc_riscv_relative);
            end;
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           if(m=1) then
            begin
             if(finalfile.Bits=32) then
             finalfile.CoffList[k-1].VirtualAddress:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4
             -basescript.BaseAddress
             else
             finalfile.CoffList[k-1].VirtualAddress:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8
             -basescript.BaseAddress;
             finalfile.CoffList[k-1].Item[m-1].Offset:=0;
             if(finalfile.Bits=32) then
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_highlow
             else
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_dir64;
             inc(m);
            end
           else
            begin
             if(finalfile.Bits=32) then
             finalfile.CoffList[k-1].Item[m-1].Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4
             -basescript.BaseAddress-finalfile.CoffList[k-1].VirtualAddress
             else
             finalfile.CoffList[k-1].Item[m-1].Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8
             -basescript.BaseAddress-finalfile.CoffList[k-1].VirtualAddress;
             if(finalfile.Bits=32) then
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_highlow
             else
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_dir64;
             inc(m);
             if(m=513) and (finalfile.Bits=64) then
              begin
               m:=1; inc(k);
              end
             else if(m=1025) and (finalfile.Bits=32) then
              begin
               m:=1; inc(k);
              end;
            end;
          end;
         if(finalfile.Bits=32) then
         Pdword(finalfile.SectionContent[finalfile.GotIndex-1]+
         (GotInternalIndex+GotPltOffset+GotProtect-1)*4)^:=
         GoalAddress+basefile.AdjustTable.AdjustAddend[i-1]
         else
         Pqword(finalfile.SectionContent[finalfile.GotIndex-1]+
         (GotInternalIndex+GotPltOffset+GotProtect-1)*8)^:=
         GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
        end
       else if(FileResult.ConvertToRelocationBits>0) and (FileList.NeedCount>0)
       and(basefile.SectionAttribute[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]<>0) then
        begin
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0)
         and(FileResult.ConvertToRelocationBits=finalfile.Bits) then
          begin
           if(basefile.Bits=32) then
            begin
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Offset:=OriginalAddress;
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Addend:=
             GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(0,elf_reloc_riscv_relative);
             inc(AllSectionOffset[finalfile.RelocationDynamicTableIndex-1]);
            end
           else
            begin
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Offset:=OriginalAddress;
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Addend:=GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(0,elf_reloc_riscv_relative);
             inc(AllSectionOffset[finalfile.RelocationDynamicTableIndex-1]);
            end;
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           FileList.NeedBits[j-1]:=FileResult.ConvertToRelocationBits;
           FileList.NeedAddress[j-1]:=OriginalAddress;
           inc(j);
          end;
        end;
      end;
     ChangeValue:=unifile_calculate_comple(FileResult.AdjustValue,FileResult.Bits,
     FileResult.AdjustValue<0);
     if(FileResult.RiscvType=elf_riscv_cb_type) then
      begin
       d7:=ChangeValue shr 1;
       d1:=(d7 and $3); d2:=(d7 shr 2) and $3;
       d3:=(d7 shr 4) and $1; d4:=(d7 shr 5) and $3;
       d5:=(d7 shr 7) and $1;
       d6:=Pword(ChangePointer)^ and (not ($1F shl 2+$7 shl 10));
       d6:=d6+d1 shl 3+d2 shl 10+d3 shl 2+d4 shl 5+d5 shl 12;
       Pword(ChangePointer)^:=d6;
      end
     else if(FileResult.RiscvType=elf_riscv_cj_type) then
      begin
       d10:=ChangeValue;
       d1:=(d10 and $20) shr 5; d2:=(d10 and $E) shr 1;
       d3:=(d10 and $40) shr 7; d4:=(d10 and $20) shr 6;
       d5:=(d10 and $400) shr 10; d6:=(d10 and $300) shr 8;
       d7:=(d10 and $10) shr 4;
       d8:=(d10 and $800) shr 11;
       d9:=Pword(ChangePointer)^ and (not ($7FF shl 2));
       d9:=d9+d1 shl 2+d2 shl 3+d3 shl 6+d4 shl 7+d5 shl 8+d6 shl 9+d7 shl 11+d8 shl 12;
       Pword(ChangePointer)^:=d9;
      end
     else if(FileResult.RiscvType=elf_riscv_b_type) then
      begin
       d1:=ChangeValue shr 1;
       d2:=d1 and $F; d3:=(d1 shr 4) and $3F; d4:=(d1 shr 10) and $1;
       d5:=(d1 shr 11) and $1;
       d6:=Pdword(ChangePointer)^ and (not ($1F shl 7+$7F shl 25));
       d6:=d6+d2 shl 8+d3 shl 25+d4 shl 7+d5 shl 31;
       Pdword(ChangePointer)^:=d6;
      end
     else if(FileResult.RiscvType=elf_riscv_i_type) then
      begin
       d1:=ChangeValue and $FFF;
       d2:=Pdword(ChangePointer)^ and $000FFFFF;
       d2:=d2+d1 shl 20; Pdword(ChangePointer)^:=d2;
      end
     else if(FileResult.RiscvType=elf_riscv_s_type) then
      begin
       d5:=ChangeValue and $FFF;
       d1:=d5 and $1F; d2:=(d5 shr 5) and $7F;
       d4:=Pdword(ChangePointer)^ and (not ($1F shl 7+$7F shl 25));
       d4:=d4+d1 shl 7+d2 shl 25; Pdword(ChangePointer)^:=d4;
      end
     else if(FileResult.RiscvType=elf_riscv_u_type) then
      begin
       d2:=(ChangeValue+$800) shr 12 and $FFFFF;
       d1:=Pdword(ChangePointer)^ and $00000FFF;
       d1:=d1+d2 shl 12;
       Pdword(ChangePointer)^:=d1;
      end
     else if(FileResult.RiscvType=elf_riscv_j_type) then
      begin
       d1:=ChangeValue shr 1;
       d2:=d1 and $3FF; d3:=(d1 shr 10) and 1; d4:=(d1 shr 11) and $FF;
       d5:=(d1 shr 19) and $1;
       d6:=Pdword(ChangePointer)^ and $00000FFF;
       d6:=d6+d2 shl 21+d3 shl 20+d4 shl 12+d5 shl 31;
       Pdword(ChangePointer)^:=d6;
      end
     else if(FileResult.RiscvType=elf_riscv_u_i_type) then
      begin
       {Former is U Type}
       d2:=(ChangeValue+$800) shr 12 and $FFFFF;
       d1:=Pdword(ChangePointer)^ and $00000FFF;
       d1:=d1+d2 shl 12;
       Pdword(ChangePointer)^:=d1;
       {Latter is I type}
       d1:=ChangeValue and $FFF;
       d2:=Pdword(ChangePointer+4)^ and $000FFFFF;
       d2:=d2+d1 shl 20;
       Pdword(ChangePointer+4)^:=d2;
      end
     else if(FileResult.Bits=6) then
      begin
       d1:=Pbyte(ChangePointer)^ and $C0;
       d2:=ChangeValue and $3F;
       Pbyte(ChangePointer)^:=d1+d2;
      end
     else if(FileResult.Bits=8) then
      begin
       Pbyte(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=16) then
      begin
       Pword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=32) then
      begin
       Pdword(ChangePointer)^:=ChangeValue;
      end
     else if(FileResult.Bits=64) then
      begin
       Pqword(ChangePointer)^:=ChangeValue;
      end;
    end
   else if(finalfile.Architecture=elf_machine_loongarch) then
    begin
     {Data sequence:S,A,PC,B,GP,G}
     if(RelocationSwitch=false) and ((basefile.AdjustTable.GoalSectionIndex[i-1]<>
     basefile.AdjustTable.OriginalSectionIndex[i-1]) or
     (basefile.AdjustTable.GoalSectionIndex[i-1]=0)) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf32_rela))^.Offset:=basefile.AdjustTable.OriginalOffset[i-1];
         Pelf32_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf32_rela))^.Addend:=
         basefile.AdjustTable.AdjustAddend[i-1];
         n:=finalfile.SymbolTableNewIndex[unifile_search_for_hash_table(finalfile.SymbolTableAssist,basefile.AdjustTable.AdjustHash[i-1])-1];
         Pelf32_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf32_rela))^.Info:=
         elf32_reloc_info(n,basefile.AdjustTable.AdjustType[i-1]);
         inc(AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]);
        end
       else
        begin
         Pelf64_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf64_rela))^.Offset:=basefile.AdjustTable.OriginalOffset[i-1];
         Pelf64_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf64_rela))^.Addend:=
         basefile.AdjustTable.AdjustAddend[i-1];
         n:=finalfile.SymbolTableNewIndex[unifile_search_for_hash_table(finalfile.SymbolTableAssist,basefile.AdjustTable.AdjustHash[i-1])-1];
         Pelf64_rela(finalfile.SectionContent[
         SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]
         ]+AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]
         *sizeof(elf64_rela))^.Info:=
         elf64_reloc_info(n,basefile.AdjustTable.AdjustType[i-1]);
         inc(AllSectionOffset[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]]);
        end;
      end
     else if(basefile.AdjustTable.GoalSectionIndex[i-1]=0) then
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       if(basefile.Bits=32) then
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got_plt,
       [0,basefile.AdjustTable.AdjustAddend[i-1],
       OriginalAddress,0,GotAddress,(GotInternalIndex+2)*4])
       else
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got_plt,
       [0,basefile.AdjustTable.AdjustAddend[i-1],
       OriginalAddress,0,GotAddress,(GotInternalIndex+2)*8]);
       n:=unifile_search_for_hash_table(finalfile.DynamicSymbolTableAssist,
       basefile.AdjustTable.AdjustHash[i-1]);
       if(GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false)
       and(finalfile.RelocationDynamicTableIndex<>0)then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         if(finalfile.Bits=32) then
          begin
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Offset:=
           GotAddress+(GotInternalIndex+2)*4;
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Addend:=
           basefile.AdjustTable.AdjustAddend[i-1];
           Pelf32_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(n,elf_reloc_loongarch_32bit);
          end
         else
          begin
           finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Offset:=
           GotAddress+(GotInternalIndex+2)*8;
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Addend:=
           basefile.AdjustTable.AdjustAddend[i-1];
           Pelf64_rela(finalfile.SectionContent[
           finalfile.RelocationDynamicTableIndex-1
           ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(n,elf_reloc_loongarch_64bit);
          end;
         inc(j);
        end;
      end
     else
      begin
       GotInternalIndex:=unifile_search_for_hash_table(
       finalfile.GotTableList.GotHashTable,basefile.AdjustTable.AdjustHash[i-1]);
       if(finalfile.Bits=32) then
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got,
       [GoalAddress,basefile.AdjustTable.AdjustAddend[i-1],
       OriginalAddress,0,GotAddress,(GotInternalIndex+GotPltOffset+GotProtect-1)*4])
       else
       FileResult:=unifile_calculate_relocation(basefile.Architecture,
       basefile.Bits,basefile.AdjustTable.AdjustType[i-1],
       unifile_got_class_got,
       [GoalAddress,basefile.AdjustTable.AdjustAddend[i-1],
       OriginalAddress,0,GotAddress,(GotInternalIndex+GotPltOffset+GotProtect-1)*8]);
       if(FileResult.GotType<>0) and
       (GotInternalIndex>0) and (finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]=false) then
        begin
         finalfile.GotTableList.GotHashEnable[GotInternalIndex-1]:=true;
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0)
         and (FileResult.ConvertToRelocationBits=finalfile.Bits) then
          begin
           if(finalfile.Bits=32) then
            begin
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4;
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Addend:=
             GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(0,elf_reloc_loongarch_relative);
            end
           else
            begin
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8;
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Addend:=
             GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(0,elf_reloc_loongarch_relative);
            end;
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           if(m=1) then
            begin
             if(finalfile.Bits=32) then
             finalfile.CoffList[k-1].VirtualAddress:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4
             -basescript.BaseAddress
             else
             finalfile.CoffList[k-1].VirtualAddress:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8
             -basescript.BaseAddress;
             finalfile.CoffList[k-1].Item[m-1].Offset:=0;
             if(finalfile.Bits=32) then
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_highlow
             else
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_dir64;
             inc(m);
            end
           else
            begin
             if(finalfile.Bits=32) then
             finalfile.CoffList[k-1].Item[m-1].Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*4
             -basescript.BaseAddress-finalfile.CoffList[k-1].VirtualAddress
             else
             finalfile.CoffList[k-1].Item[m-1].Offset:=
             GotAddress+(GotInternalIndex+GotPltOffset+GotProtect-1)*8
             -basescript.BaseAddress-finalfile.CoffList[k-1].VirtualAddress;
             if(finalfile.Bits=32) then
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_highlow
             else
             finalfile.CoffList[k-1].Item[m-1].ItemType:=coff_image_base_relocation_dir64;
             inc(m);
             if(m=513) and (finalfile.Bits=64) then
              begin
               m:=1; inc(k);
              end
             else if(m=1025) and (finalfile.Bits=32) then
              begin
               m:=1; inc(k);
              end;
            end;
          end;
         if(finalfile.Bits=32) then
         Pdword(finalfile.SectionContent[finalfile.GotIndex-1]+(GotInternalIndex+GotPltOffset+GotProtect-1)*4)^:=
         GoalAddress+basefile.AdjustTable.AdjustAddend[i-1]
         else
         Pqword(finalfile.SectionContent[finalfile.GotIndex-1]+(GotInternalIndex+GotPltOffset+GotProtect-1)*8)^:=
         GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
        end
       else if(FileResult.ConvertToRelocationBits>0) and (FileList.NeedCount>0)
       and(basefile.SectionAttribute[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]<>0) then
        begin
         if(fileclass=unifile_class_elf_file) and (finalfile.RelocationDynamicTableIndex<>0)
         and(FileResult.ConvertToRelocationBits=finalfile.Bits) then
          begin
           if(basefile.Bits=32) then
            begin
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Offset:=OriginalAddress;
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Addend:=
             GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
             Pelf32_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf32_rela))^.Info:=elf32_reloc_info(0,elf_reloc_loongarch_relative);
             inc(AllSectionOffset[finalfile.RelocationDynamicTableIndex-1]);
            end
           else
            begin
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Offset:=OriginalAddress;
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Addend:=
             GoalAddress+basefile.AdjustTable.AdjustAddend[i-1];
             Pelf64_rela(finalfile.SectionContent[
             finalfile.RelocationDynamicTableIndex-1
             ]+(j-1)*sizeof(elf64_rela))^.Info:=elf64_reloc_info(0,elf_reloc_loongarch_relative);
             inc(AllSectionOffset[finalfile.RelocationDynamicTableIndex-1]);
            end;
           inc(j);
          end
         else if(fileclass=unifile_class_pe_file) and (finalfile.RelocationIndex>0) then
          begin
           FileList.NeedBits[j-1]:=FileResult.ConvertToRelocationBits;
           FileList.NeedAddress[j-1]:=OriginalAddress;
           inc(j);
          end;
        end;
      end;
     ChangeValue:=unifile_calculate_comple(FileResult.AdjustValue,FileResult.Bits,
     FileResult.AdjustValue<0);
     ChangePointer:=
     finalfile.SectionContent[SectionIndex[basefile.AdjustTable.OriginalSectionIndex[i-1]-1]-1]+
     basefile.AdjustTable.OriginalOffset[i-1];
     if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_add_8bit) or
     (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_sub_8bit) then
      begin
       Pbyte(ChangePointer)^:=ChangeValue;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_add_16bit) or
     (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_sub_16bit) then
      begin
       Pword(ChangePointer)^:=ChangeValue;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_add_32bit) or
     (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_sub_32bit) then
      begin
       Pdword(ChangePointer)^:=ChangeValue;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_add_64bit) or
     (basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_sub_64bit) then
      begin
       Pqword(ChangePointer)^:=ChangeValue;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_b16) then
      begin
       d1:=ChangeValue shr 2;
       d2:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 10));
       Pdword(ChangePointer)^:=d2+d1 shl 10;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_b21) then
      begin
       d1:=ChangeValue shr 2;
       d2:=(d1 shr 16) and $1F; d3:=d1 and $FFFF;
       d4:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 10+$1F));
       Pdword(ChangePointer)^:=d4+d3 shl 10+d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_b26) then
      begin
       d1:=ChangeValue shr 2;
       d2:=(d1 shr 16) and $3FF; d3:=d1 and $FFFF;
       d4:=Pdword(ChangePointer)^ and (not ($0000FFFF shl 10+$3FF));
       Pdword(ChangePointer)^:=d4+d3 shl 10+d2;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_absolute_high_20bit) then
      begin
       d1:=(ChangeValue shr 12) and $FFFFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFFFF shl 5));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_absolute_low_12bit) then
      begin
       d1:=ChangeValue and $FFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFF shl 10));
       Pdword(ChangePointer)^:=d2+d1 shl 10;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_absolute_64bit_low_20bit) then
      begin
       d1:=(ChangeValue shr 32) and $FFFFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFFFF shl 5));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_absolute_64bit_high_12bit) then
      begin
       d1:=ChangeValue shr 52;
       d2:=Pdword(ChangePointer)^ and (not ($FFF shl 10));
       Pdword(ChangePointer)^:=d2+d1 shl 10;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_pcala_high_20bit) then
      begin
       d1:=(ChangeValue shr 12) and $FFFFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFFFF shl 5));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_pcala_low_12bit) then
      begin
       d1:=ChangeValue and $FFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFF shl 10));
       Pdword(ChangePointer)^:=d2+d1 shl 10;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_pcala64_low_20bit) then
      begin
       d1:=(ChangeValue shr 32) and $FFFFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFFFF shl 5));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_pcala64_high_12bit) then
      begin
       d1:=(ChangeValue shr 52) and $FFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFF shl 10));
       Pdword(ChangePointer)^:=d2+d1 shl 10;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_got_pc_high_20bit) then
      begin
       d1:=(ChangeValue shr 12) and $FFFFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFFFF shl 5));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_got_pc_low_12bit) then
      begin
       d1:=ChangeValue and $FFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFF shl 10));
       Pdword(ChangePointer)^:=d2+d1 shl 10;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_got64_pc_low_20bit) then
      begin
       d1:=(ChangeValue shr 32) and $FFFFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFFFF shl 5));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_got64_pc_high_12bit) then
      begin
       d1:=(ChangeValue shr 52) and $FFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFF shl 10));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_got_high_20bit) then
      begin
       d1:=(ChangeValue shr 12) and $FFFFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFFFF shl 5));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_got_low_12bit) then
      begin
       d1:=ChangeValue and $FFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFF shl 10));
       Pdword(ChangePointer)^:=d2+d1 shl 10;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_got64_low_20bit) then
      begin
       d1:=(ChangeValue shr 32) and $FFFFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFFFF shl 5));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_got64_high_12bit) then
      begin
       d1:=(ChangeValue shr 52) and $FFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFF shl 10));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
      end
     else if(basefile.AdjustTable.AdjustType[i-1]=elf_reloc_loongarch_32_pc_relative) then
      begin
       d1:=(ChangeValue shr 12) and $FFFFF;
       d2:=Pdword(ChangePointer)^ and (not ($FFFFF shl 5));
       Pdword(ChangePointer)^:=d2+d1 shl 5;
       d1:=ChangeValue and $FFF;
       d2:=Pdword(ChangePointer+4)^ and (not ($FFF shl 10));
       Pdword(ChangePointer+4)^:=d2+d1 shl 10;
      end;
    end;
  end;
 {If the Convertion to Relocation Exists,PE .reloc should be reconstructed.}
 if(fileclass=unifile_class_pe_file) and (FileList.NeedCount>0) then
  begin
   i:=1; PEBaseAddress:=0;
   while(i<=FileList.NeedCount)do
    begin
     if(PEBaseAddress=0) then
      begin
       inc(finalfile.CoffListCount);
       SetLength(finalfile.CoffList,finalfile.CoffListCount);
       finalfile.CoffList[finalfile.CoffListCount-1].VirtualAddress:=
       FileList.NeedAddress[i-1]-basescript.BaseAddress;
       finalfile.CoffList[finalfile.CoffListCount-1].SizeOfBlock:=8;
       finalfile.CoffList[finalfile.CoffListCount-1].ItemCount:=0;
       PEBaseAddress:=FileList.NeedAddress[i-1];
      end
     else if(FileList.NeedAddress[i-1]<PEBaseAddress+$FFF) then
      begin
       inc(finalfile.CoffList[finalfile.CoffListCount-1].ItemCount);
       SetLength(finalfile.CoffList[finalfile.CoffListCount-1].Item,
       finalfile.CoffList[finalfile.CoffListCount-1].ItemCount);
       inc(finalfile.CoffList[finalfile.CoffListCount-1].SizeOfBlock,2);
       if(FileList.NeedBits[i-1]=16) then
       finalfile.CoffList[finalfile.CoffListCount-1].Item
       [finalfile.CoffList[finalfile.CoffListCount-1].ItemCount-1].
       ItemType:=coff_image_base_relocation_low
       else if(FileList.NeedBits[i-1]=32) then
       finalfile.CoffList[finalfile.CoffListCount-1].Item
       [finalfile.CoffList[finalfile.CoffListCount-1].ItemCount-1].
       ItemType:=coff_image_base_relocation_highlow
       else if(FileList.NeedBits[i-1]=64) then
       finalfile.CoffList[finalfile.CoffListCount-1].Item
       [finalfile.CoffList[finalfile.CoffListCount-1].ItemCount-1].
       ItemType:=coff_image_base_relocation_dir64;
       finalfile.CoffList[finalfile.CoffListCount-1].Item
       [finalfile.CoffList[finalfile.CoffListCount-1].ItemCount-1].Offset:=
       FileList.NeedAddress[i-1]-PEBaseAddress;
      end
     else
      begin
       inc(finalfile.CoffListCount);
       SetLength(finalfile.CoffList,finalfile.CoffListCount);
       finalfile.CoffList[finalfile.CoffListCount-1].VirtualAddress:=
       FileList.NeedAddress[i-1]-basescript.BaseAddress;
       finalfile.CoffList[finalfile.CoffListCount-1].SizeOfBlock:=8;
       finalfile.CoffList[finalfile.CoffListCount-1].ItemCount:=0;
       PEBaseAddress:=FileList.NeedAddress[i-1];
      end;
     inc(i);
    end;
   {Calculate the PE .reloc Address and then Regenerate the .reloc Empty Size}
   PERelocationSize:=0;
   for i:=1 to finalfile.CoffListCount do
    begin
     inc(PERelocationSize,finalfile.CoffList[i-1].SizeOfBlock);
     if(i=finalfile.CoffListCount) then
      begin
       if(finalfile.Bits=32) then
        begin
         finalfile.CoffList[i-1].SizeOfBlock:=
         unifile_align(PERelocationSize,4)-PERelocationSize+finalfile.CoffList[i-1].SizeOfBlock;
         PERelocationSize:=unifile_align(PERelocationSize,4);
        end
       else if(finalfile.Bits=64) then
        begin
         finalfile.CoffList[i-1].SizeOfBlock:=
         unifile_align(PERelocationSize,8)-PERelocationSize+finalfile.CoffList[i-1].SizeOfBlock;
         PERelocationSize:=unifile_align(PERelocationSize,8);
        end;
      end;
    end;
   ReallocMem(finalfile.SectionContent[finalfile.RelocationIndex-1],PERelocationSize);
   finalfile.SectionSize[finalfile.RelocationIndex-1]:=PERelocationSize;
   finalfile.FinalSectionOffset:=unifile_align(finalfile.SectionOffset[finalfile.RelocationIndex-1]
   +PERelocationSize,finalfile.FileAlign);
   finalfile.FinalFileSize:=unifile_align(finalfile.FinalSectionOffset
   +finalfile.CoffStringTableSize+finalfile.CoffSymbolTableSize,finalfile.FileAlign);
  end;
 {For PE .reloc section}
 if(fileclass=unifile_class_pe_file) then
  begin
   if(finalfile.CoffListSpecialize) then
    begin
     Ppe_image_base_relocation_block(finalfile.SectionContent[finalfile.RelocationIndex-1])^.
     VirtualAddress:=finalfile.SectionAddress[0];
     Ppe_image_base_relocation_block(finalfile.SectionContent[finalfile.RelocationIndex-1])^.
     SizeOfBlock:=12;
    end
   else
    begin
     WritePointer1:=0;
     for k:=1 to finalfile.CoffListCount do
      begin;
       Ppe_image_base_relocation_block(finalfile.SectionContent[finalfile.RelocationIndex-1]+
       WritePointer1)^.VirtualAddress:=finalfile.CoffList[k-1].VirtualAddress;
       Ppe_image_base_relocation_block(finalfile.SectionContent[finalfile.RelocationIndex-1]+
       WritePointer1)^.SizeOfBlock:=finalfile.CoffList[k-1].SizeOfBlock;
       inc(WritePointer1,8);
       for m:=1 to finalfile.CoffList[k-1].ItemCount do
        begin
         Ppe_image_base_relocation_item(
         finalfile.SectionContent[finalfile.RelocationIndex-1]+WritePointer1)^.Offset:=
         finalfile.CoffList[k-1].Item[m-1].Offset;
         Ppe_image_base_relocation_item(
         finalfile.SectionContent[finalfile.RelocationIndex-1]+WritePointer1)^.RelocationType:=
         finalfile.CoffList[k-1].Item[m-1].ItemType;
         inc(WritePointer1,2);
        end;
      end;
    end;
  end;
 {For .dynamic address of the .got}
 if(fileclass=unifile_class_elf_file) and (finalfile.GotTableList.GotCount>0) and
 (GotPltOffset>0) and (finalfile.DynamicIndex>0) then
  begin
   if(finalfile.Bits=32) then
   Pdword(finalfile.SectionContent[finalfile.GotIndex-1])^:=
   finalfile.SectionAddress[finalfile.DynamicIndex-1]
   else
   Pqword(finalfile.SectionContent[finalfile.GotIndex-1])^:=
   finalfile.SectionAddress[finalfile.DynamicIndex-1];
   if(basescript.Interpreter<>'') then
    begin
     if(finalfile.Bits=32) then
     Pdword(finalfile.SectionContent[finalfile.GotIndex-1]+2*sizeof(dword))^:=
     basescript.BaseAddress+InterpreterInfo.DynamicLibraryResolveOffset
     else
     Pqword(finalfile.SectionContent[finalfile.GotIndex-1]+2*sizeof(qword))^:=
     basescript.BaseAddress+InterpreterInfo.DynamicLibraryResolveOffset;
    end;
  end;
 {For Generate the Content of the Dynamic Contents}
 if(fileclass=unifile_class_elf_file) and (basescript.elfclass<>unild_class_relocatable)
 and(finalfile.DynamicIndex>0) then
  begin
   WritePointer1:=1; WritePointer2:=1;
   for i:=1 to finalfile.DynamicList.DynamicCount do
    begin
     if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_pltgot)
     and(finalfile.DynamicSymbolTable.SymbolCount>0) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.
         dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.
         dynamic_pointer:=GotAddress;
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.
         dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.
         dynamic_pointer:=GotAddress;
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_hash) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer:=
         finalfile.SectionAddress[finalfile.HashTableIndex-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer:=
         finalfile.SectionAddress[finalfile.HashTableIndex-1];
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_string_table) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer:=
         finalfile.SectionAddress[finalfile.DynamicStringTableIndex-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer:=
         finalfile.SectionAddress[finalfile.DynamicStringTableIndex-1];
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_symbol_table) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer:=
         finalfile.SectionAddress[finalfile.DynamicSymbolIndex-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer:=
         finalfile.SectionAddress[finalfile.DynamicSymbolIndex-1];
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_rela) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_pointer:=
         finalfile.SectionAddress[finalfile.RelocationDynamicTableIndex-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_pointer:=
         finalfile.SectionAddress[finalfile.RelocationDynamicTableIndex-1];
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_rela_size) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[finalfile.RelocationDynamicTableIndex-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[finalfile.RelocationDynamicTableIndex-1];
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_rela_count) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[finalfile.RelocationDynamicTableIndex-1] div sizeof(elf32_rela);
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[finalfile.RelocationDynamicTableIndex-1] div sizeof(elf64_rela);
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_String_table_size) then
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[finalfile.DynamicStringTableIndex-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[finalfile.DynamicStringTableIndex-1];
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_initialization)
     or(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_finalization)
     or(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_initialize_array)
     or(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_finalize_array)
     or(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_preinitialize_array)then
      begin
       j:=1;
       while(j<=finalfile.SectionCount)do
        begin
         if(finalfile.SectionName[j-1]=finalfile.DynamicList.DynamicItem[i-1].DynamicSection) then break;
         inc(j);
        end;
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+
         (i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+
         (i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value:=
         finalfile.SectionAddress[j-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value:=
         finalfile.SectionAddress[j-1];
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_needed) or
     (finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_shared_object_name) or
     (finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_run_path) then
      begin
       j:=1;
       tempstr:=finalfile.DynamicList.DynamicItem[i-1].DynamicString;
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value:=WritePointer1;
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value:=WritePointer1;
        end;
       inc(WritePointer1,length(tempstr)+1);
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_initialize_array_size)
     or(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_finalize_array_size)
     or(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_preinitialize_array_size) then
      begin
       j:=1;
       while(j<=finalfile.SectionCount)do
        begin
         if(finalfile.SectionName[j-1]=finalfile.DynamicList.DynamicItem[i-1].DynamicString) then break;
         inc(j);
        end;
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[j-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[j-1];
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_symbol_info_size) then
      begin
       j:=1;
       while(j<=finalfile.SectionCount)do
        begin
         if(finalfile.SectionName[j-1]=finalfile.DynamicList.DynamicItem[i-1].DynamicString) then break;
         inc(j);
        end;
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[j-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value:=
         finalfile.SectionSize[j-1];
        end;
      end
     else if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_version_symbol) then
      begin
       j:=1;
       while(j<=finalfile.SectionCount)do
        begin
         if(finalfile.SectionName[j-1]=finalfile.DynamicList.DynamicItem[i-1].DynamicString) then break;
         inc(j);
        end;
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value:=
         finalfile.SectionAddress[j-1];
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value:=
         finalfile.SectionAddress[j-1];
        end;
      end
     else
      begin
       if(finalfile.Bits=32) then
        begin
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf32_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf32_dynamic_entry))^.dynamic_value:=
         finalfile.DynamicList.DynamicItem[i-1].DynamicValue;
        end
       else
        begin
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_entry_type:=
         finalfile.DynamicList.DynamicType[i-1];
         Pelf64_dynamic_entry(finalfile.SectionContent[finalfile.DynamicIndex-1]+(i-1)*sizeof(elf64_dynamic_entry))^.dynamic_value:=
         finalfile.DynamicList.DynamicItem[i-1].DynamicValue;
        end;
      end;
    end;
   WritePointer1:=1;
   for i:=1 to finalfile.DynamicList.DynamicCount do
    begin
     if(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_needed)
     or(finalfile.DynamicList.DynamicType[i-1]=elf_dynamic_type_library_search_path) then
      begin
       for j:=1 to length(finalfile.DynamicList.DynamicItem[i-1].DynamicString) do
        begin
         PChar(finalfile.SectionContent[finalfile.DynamicStringTableIndex-1]+WritePointer1)^:=
         finalfile.DynamicList.DynamicItem[i-1].DynamicString[j];
         inc(WritePointer1);
        end;
       inc(WritePointer1);
      end;
    end;
   WritePointer2:=1;
   for i:=1 to finalfile.DynamicSymbolTable.SymbolCount do
    begin
     if(finalfile.Bits=32) then
      begin
       Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf32_symbol_table_entry))^.symbol_name:=WritePointer1;
       Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf32_symbol_table_entry))^.symbol_info:=
       elf_symbol_type_info(finalfile.DynamicSymbolTable.SymbolBinding[finalfile.DynamicSymbolTableNewIndex[i-1]-1],
       finalfile.DynamicSymbolTable.SymbolType[finalfile.DynamicSymbolTableNewIndex[i-1]-1]);
       Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf32_symbol_table_entry))^.symbol_other:=
       finalfile.DynamicSymbolTable.SymbolVisibility[finalfile.DynamicSymbolTableNewIndex[i-1]-1];
       Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf32_symbol_table_entry))^.symbol_section_index:=
       finalfile.DynamicSymbolTable.SymbolSectionIndex[finalfile.DynamicSymbolTableNewIndex[i-1]-1];
       Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf32_symbol_table_entry))^.symbol_value:=
       finalfile.SectionAddress[finalfile.DynamicSymbolTable.SymbolSectionIndex[finalfile.DynamicSymbolTableNewIndex[i-1]-1]-1]+
       finalfile.DynamicSymbolTable.SymbolValue[finalfile.DynamicSymbolTableNewIndex[i-1]-1];
      end
     else
      begin
       Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf64_symbol_table_entry))^.symbol_name:=WritePointer1;
       Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf64_symbol_table_entry))^.symbol_info:=
       elf_symbol_type_info(finalfile.DynamicSymbolTable.SymbolBinding[finalfile.DynamicSymbolTableNewIndex[i-1]-1],
       finalfile.DynamicSymbolTable.SymbolType[finalfile.DynamicSymbolTableNewIndex[i-1]-1]);
       Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf64_symbol_table_entry))^.symbol_other:=
       finalfile.DynamicSymbolTable.SymbolVisibility[finalfile.DynamicSymbolTableNewIndex[i-1]-1];
       Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf64_symbol_table_entry))^.symbol_section_index:=
       finalfile.DynamicSymbolTable.SymbolSectionIndex[finalfile.DynamicSymbolTableNewIndex[i-1]-1];
       Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.DynamicSymbolIndex-1]+WritePointer2*
       sizeof(elf64_symbol_table_entry))^.symbol_value:=
       finalfile.SectionAddress[finalfile.DynamicSymbolTable.SymbolSectionIndex[finalfile.DynamicSymbolTableNewIndex[i-1]-1]-1]+
       finalfile.DynamicSymbolTable.SymbolValue[finalfile.DynamicSymbolTableNewIndex[i-1]-1];
      end;
     for j:=1 to length(finalfile.DynamicSymbolTable.SymbolName[finalfile.SymbolTableNewIndex[i-1]-1]) do
      begin
       PChar(finalfile.SectionContent[finalfile.DynamicStringTableIndex-1]+WritePointer1)^:=
       finalfile.DynamicSymbolTable.SymbolName[finalfile.SymbolTableNewIndex[i-1]-1][j];
       inc(WritePointer1);
      end;
     inc(WritePointer1); inc(WritePointer2);
    end;
   {Generate the Hash Table}
   i:=1;
   HashTable.BucketCount:=(finalfile.DynamicSymbolTable.SymbolCount+1)*2+1;
   HashTable.ChainCount:=(finalfile.DynamicSymbolTable.SymbolCount+1);
   SetLength(HashTable.BucketItem,HashTable.BucketCount);
   SetLength(HashTable.ChainItem,HashTable.ChainCount);
   for i:=1 to finalfile.DynamicSymbolTable.SymbolCount do
    begin
     HashTableItem:=unifile_elf_hash(finalfile.DynamicSymbolTable.SymbolName[i-1]) mod
     HashTable.BucketCount;
     if(HashTable.BucketItem[HashTableItem]=0) then
      begin
       HashTable.BucketItem[HashTableItem]:=i;
      end
     else
      begin
       HashTableItem:=HashTable.ChainItem[HashTableItem];
       while(HashTable.ChainItem[HashTableItem]<>0)do HashTableItem:=HashTable.ChainItem[HashTableItem];
       HashTable.ChainItem[HashTableItem]:=i;
      end;
    end;
   finalfile.SectionContent[finalfile.HashTableIndex-1]:=
   allocmem((HashTable.BucketCount+HashTable.ChainCount+2)*4);
   finalfile.SectionSize[finalfile.HashTableIndex-1]:=(HashTable.BucketCount+HashTable.ChainCount+2)*4;
   Pdword(finalfile.SectionContent[finalfile.HashTableIndex-1])^:=HashTable.BucketCount;
   WritePointer1:=1;
   for i:=1 to HashTable.BucketCount do
    begin
     Pdword(finalfile.SectionContent[finalfile.HashTableIndex-1]+WritePointer1*4)^:=
     HashTable.BucketItem[i-1];
     inc(WritePointer1);
    end;
   Pdword(finalfile.SectionContent[finalfile.HashTableIndex-1]+WritePointer1*4)^:=HashTable.ChainCount;
   inc(WritePointer1);
   for i:=1 to HashTable.ChainCount do
    begin
     Pdword(finalfile.SectionContent[finalfile.HashTableIndex-1]+WritePointer1*4)^:=
     HashTable.ChainItem[i-1];
     inc(WritePointer1);
    end;
  end;
 {Generate the Content of the Symbol Table and String Table}
 if(fileclass=unifile_class_elf_file) then
  begin
   if(basescript.NoSymbol=false) then
    begin
     WritePointer1:=1; WritePointer2:=1;
     i:=1;
     while(i<=finalfile.SymbolTable.SymbolCount)do
      begin
       j:=1;
       if(finalfile.Bits=32) then
        begin
         if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]
         <>elf_symbol_type_section) then
         Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf32_symbol_table_entry))^.symbol_name:=WritePointer2;
         Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf32_symbol_table_entry))^.symbol_size:=
         finalfile.SymbolTable.SymbolSize[finalfile.SymbolTableNewIndex[i-1]-1];
         Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf32_symbol_table_entry))^.symbol_info:=
         elf_symbol_type_info(finalfile.SymbolTable.SymbolBinding[finalfile.SymbolTableNewIndex[i-1]-1],
         finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]);
         Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf32_symbol_table_entry))^.symbol_section_index:=
         finalfile.SymbolTable.SymbolSectionIndex[finalfile.SymbolTableNewIndex[i-1]-1];
         Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf32_symbol_table_entry))^.symbol_other:=
         finalfile.SymbolTable.SymbolVisibility[finalfile.SymbolTableNewIndex[i-1]-1];
         if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]
         =elf_symbol_type_section) then
         Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf32_symbol_table_entry))^.symbol_value:=0
         else if(basescript.elfclass<>unild_class_relocatable) and
         (finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]<>elf_symbol_type_file)
         then
         Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf32_symbol_table_entry))^.symbol_value:=
         finalfile.SectionAddress[finalfile.SymbolTable.SymbolSectionIndex[finalfile.SymbolTableNewIndex[i-1]-1]-1]+
         finalfile.SymbolTable.SymbolValue[finalfile.SymbolTableNewIndex[i-1]-1]
         else
         Pelf32_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf32_symbol_table_entry))^.symbol_value:=
         finalfile.SymbolTable.SymbolValue[finalfile.SymbolTableNewIndex[i-1]-1];
        end
       else if(finalfile.Bits=64) then
        begin
         if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]
         <>elf_symbol_type_section) then
         Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf64_symbol_table_entry))^.symbol_name:=WritePointer2;
         Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf64_symbol_table_entry))^.symbol_size:=
         finalfile.SymbolTable.SymbolSize[finalfile.SymbolTableNewIndex[i-1]-1];
         Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf64_symbol_table_entry))^.symbol_info:=
         elf_symbol_type_info(finalfile.SymbolTable.SymbolBinding[finalfile.SymbolTableNewIndex[i-1]-1],
         finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]);
         Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf64_symbol_table_entry))^.symbol_section_index:=
         finalfile.SymbolTable.SymbolSectionIndex[finalfile.SymbolTableNewIndex[i-1]-1];
         Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf64_symbol_table_entry))^.symbol_other:=
         finalfile.SymbolTable.SymbolVisibility[finalfile.SymbolTableNewIndex[i-1]-1];
         if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]
         =elf_symbol_type_section) then
         Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf64_symbol_table_entry))^.symbol_value:=0
         else if(basescript.elfclass<>unild_class_relocatable) and
         (finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]<>elf_symbol_type_file)
         then
         Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf64_symbol_table_entry))^.symbol_value:=
         finalfile.SectionAddress[finalfile.SymbolTable.SymbolSectionIndex[finalfile.SymbolTableNewIndex[i-1]-1]-1]+
         finalfile.SymbolTable.SymbolValue[finalfile.SymbolTableNewIndex[i-1]-1]
         else
         Pelf64_symbol_table_entry(finalfile.SectionContent[finalfile.SymbolTableIndex-1]+
         WritePointer1*sizeof(elf64_symbol_table_entry))^.symbol_value:=
         finalfile.SymbolTable.SymbolValue[finalfile.SymbolTableNewIndex[i-1]-1];
        end;
       if(finalfile.SymbolTable.SymbolType[finalfile.SymbolTableNewIndex[i-1]-1]
       <>elf_symbol_type_section) then
        begin
         while(j<=length(finalfile.SymbolTable.SymbolName[finalfile.SymbolTableNewIndex[i-1]-1]))do
          begin
           PChar(finalfile.SectionContent[finalfile.SymbolStringTableIndex-1]+WritePointer2)^:=
           finalfile.SymbolTable.SymbolName[finalfile.SymbolTableNewIndex[i-1]-1][j];
           inc(j); inc(WritePointer2);
          end;
         inc(WritePointer2);
        end;
       inc(WritePointer1);
       inc(i);
      end;
    end;
   {Summon the Content of the Section Header Name Table(ELF Only)}
   SetLength(finalfile.SectionNameIndex,finalfile.SectionCount);
   WritePointer1:=1; i:=1;
   while(i<=finalfile.SectionCount)do
    begin
     j:=1;
     finalfile.SectionNameIndex[i-1]:=WritePointer1;
     while(j<=length(finalfile.SectionName[i-1]))do
      begin
       PChar(finalfile.SectionContent[finalfile.StringTableIndex-1]+
       WritePointer1)^:=finalfile.SectionName[i-1][j];
       inc(j);
       inc(WritePointer1);
      end;
     inc(WritePointer1);
     inc(i);
    end;
  end;
 {Then Write the File with Writer}
 unifile_output_final_file(finalfile,basescript,filename,fileclass);
 {Then Free the Final File Data}
 for i:=1 to finalfile.SectionCount do
  begin
   if(finalfile.SectionContent[i-1]<>nil) then FreeMem(finalfile.SectionContent[i-1]);
  end;
 if(fileclass=unifile_class_pe_file) and (basescript.NoSymbol=false) then
  begin
   if(finalfile.CoffStringTableContent<>nil) then FreeMem(finalfile.CoffStringTableContent);
   if(finalfile.CoffSymbolTableContent<>nil) then FreeMem(finalfile.CoffSymbolTableContent);
  end;
end;

end.

