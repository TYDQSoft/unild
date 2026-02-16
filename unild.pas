program unild;

uses Sysutils,Classes,unifile,unildscript,unihash,binbase;

type unild_filelist=packed record
                    FilePath:array of string;
                    Count:SizeUInt;
                    end;

const ParamWait:boolean=false;

function unild_search_for_filelist(basepath:string;mask:string;IncludeSubDir:boolean):unild_filelist;
var SearchRec:TSearchRec;
    Signal:longint;
    i:SizeUint;
    templist:unild_filelist;
    ProcessBaseDir:string;
begin
 Result.Count:=0; Signal:=-1; ProcessBaseDir:=BasePath;
 if(length(ProcessBaseDir)>1) and
 ((ProcessBaseDir[length(ProcessBaseDir)]='\') or (ProcessBaseDir[length(ProcessBaseDir)]='/')) then
 ProcessBaseDir:=Copy(ProcessBaseDir,1,length(ProcessBaseDir)-1);
 if(includesubdir) then
  begin
   while(True)do
    begin
     if(signal<>0) then signal:=FindFirst(ProcessBaseDir,faDirectory,SearchRec)
     else signal:=FindNext(SearchRec);
     if(signal<>0) then break;
     if(SearchRec.Name='..') or (SearchRec.Name='.') then continue;
     templist:=unild_search_for_filelist(ProcessBaseDir+'/'+SearchRec.Name,mask,true);
     i:=1;
     while(i<=templist.count)do
      begin
       inc(Result.count);
       SetLength(Result.FilePath,Result.count);
       Result.filePath[Result.count-1]:=templist.filepath[i-1];
       inc(i);
      end;
    end;
   FindClose(SearchRec);
  end;
 signal:=-1;
 while(True)do
  begin
   if(signal<>0) then signal:=FindFirst(ProcessBaseDir+'/'+mask,faAnyFile,SearchRec)
   else signal:=FindNext(SearchRec);
   if(SearchRec.Name='..') or (SearchRec.Name='.') then continue;
   if(signal<>0) then break;
   inc(Result.count);
   SetLength(Result.FilePath,Result.count);
   Result.FilePath[Result.count-1]:=ProcessBaseDir+'/'+SearchRec.Name;
  end;
 FindClose(SearchRec);
end;
function unild_search_for_directorylist(basepath:string;IncludeSubDir:boolean):unild_filelist;
var SearchRec:TSearchRec;
    Signal:longint;
    i:SizeUint;
    templist:unild_filelist;
    ProcessBaseDir:string;
begin
 Result.Count:=0; Signal:=-1; ProcessBaseDir:=BasePath;
 if(length(ProcessBaseDir)>1) and
 ((ProcessBaseDir[length(ProcessBaseDir)]='\') or (ProcessBaseDir[length(ProcessBaseDir)]='/')) then
 ProcessBaseDir:=Copy(ProcessBaseDir,1,length(ProcessBaseDir)-1);
 if(includesubdir) then
  begin
   while(True)do
    begin
     if(signal<>0) then signal:=FindFirst(ProcessBaseDir,faDirectory,SearchRec)
     else signal:=FindNext(SearchRec);
     if(signal<>0) then break;
     if(SearchRec.Name='..') or (SearchRec.Name='.') then continue;
     templist:=unild_search_for_directorylist(ProcessBaseDir+'/'+SearchRec.Name,true);
     i:=1;
     while(i<=templist.count)do
      begin
       inc(Result.count);
       SetLength(Result.FilePath,Result.count);
       Result.filePath[Result.count-1]:=templist.filepath[i-1];
       inc(i);
      end;
    end;
   FindClose(SearchRec);
  end;
 signal:=-1;
 while(True)do
  begin
   if(signal<>0) then signal:=FindFirst(ProcessBaseDir,faDirectory,SearchRec)
   else signal:=FindNext(SearchRec);
   if(SearchRec.Name='..') or (SearchRec.Name='.') then continue;
   if(signal<>0) then break;
   inc(Result.count);
   SetLength(Result.FilePath,Result.count);
   Result.FilePath[Result.count-1]:=ProcessBaseDir+'/'+SearchRec.Name;
  end;
 FindClose(SearchRec);
end;
function unild_check_path(path:string):boolean;
var i,len:SizeUint;
    tempstr:string;
begin
 len:=length(path); i:=len; tempstr:='';
 while(i>0)do
  begin
   if(path[i]='/') or (path[i]='\') then
    begin
     tempstr:=Copy(path,1,i-1); break;
    end;
   dec(i);
  end;
 if(i=0) then exit(true)
 else exit(DirectoryExists(tempstr));
end;
procedure unild_param_raise_error(ParameterIndex:SizeUint;ParameterName:string;ErrorDetail:string);
begin
 writeln('ERROR advent when parsing the input command of Linker:');
 writeln('ERROR in parameter '+IntToStr(ParameterIndex)+' with Name '+ParameterName+':');
 writeln('ERROR Detail:'+ErrorDetail);
 writeln('Please check your passing parameters and look up the help for more information.');
 if(ParamWait) then readln;
 halt;
end;
procedure unild_init_raise_error(ErrorDetail:string;ErrorTip:string;LinkerSwitch:boolean);
begin
 writeln('ERROR emerged when initialization of the input file:');
 writeln('ERROR Detail:'+ErrorDetail);
 writeln(ErrorTip);
 if(LinkerSwitch) then readln;
 halt;
end;
procedure unild_help;
begin
 writeln('unild(universal linker editor) version 0.0.4');
 writeln('Commands:unild [parameters] '+
 '(Linking commands and command values are not case-sensitive,while the value,file name and path not)');
 writeln('Tips 1:Implicit section will not be auto-generated in the file,'
 +'cannot be linked in specified section.');
 writeln('Tips 2:Default is output an ELF Format File,but the ELF Format File Type should be specified'+
 'before the linking stage start.');
 writeln('Tips 3:Sign $ and Sign 0x/0X are specified that the value is hexdecimal value.');
 writeln('Available Commands:');
 writeln('--verbose,--cui,--console');
 writeln('  Enable the linking hint of the unild.');
 writeln('--untypedbinary,--binary,--untyped,--notype');
 writeln('  Set the output format type to untyped binary(pure binary).');
 writeln('--version,--linker-version,--linkerversion');
 writeln('  Show the version of the unild.');
 writeln('--smartlinking,--smart,--smartlink,--smart-linking,--smart-link');
 writeln('  Enable the smart linking of the unild(disable the linking all option).');
 writeln('--linkallsection,--linkallsect,--nosmartlinking,--linkall,--nosmart,--nosmartlinking'+
 '--no-smartlink,--no-smartlinking,--no-smart-linking');
 writeln('  Disable the smart linking of the unild(enable the linking all option).');
 writeln('--no-symbol,--discard-symbol,--strip-symbol,--delete-symbol');
 writeln('  Erase the static symbol of the output file(disable the keeping symbol option).');
 writeln('--symbolic,--keep-symbol,--maintain-symbol');
 writeln('  Maintain the static symbol of the output file(disable the deleting symbol option).');
 writeln('--no-executable-stack,--no-executablestack,--no-exec-stack,--no-execstack');
 writeln('  Check the executable stack(ELF Files Only)');
 writeln('--readonlygot,--readonly-got');
 writeln('  Disable the Writable Got(Global Offset Table) section(ELF Files Only).');
 writeln('--writablegot,--writable-got');
 writeln('  Enable the Writable Got(Global Offset Table) section(ELF Files Only,Default).');
 writeln('--uncheckedgot,--unchecked-got');
 writeln('  Enable the Unchecked Got(Global Offset Table) section(ELF Files Only,Default).');
 writeln('--interpreter,--interp');
 writeln('  Specify the path of the interpreter(ELF PIE only,Default is no interpreter).');
 writeln('--output-file-name,--output-filename,--outputfilename,--output');
 writeln('  Specify output file name(Cannot lack,otherwise a error will thrown).');
 writeln('--input-file,--inputfile,--input');
 writeln('  Specify the input file name(can be multiple).');
 writeln('--input-file-path,--input-filepath,--inputfilepath,--input-path,--inputpath');
 writeln('  Specify the path contains input file(without subdirectory).');
 writeln('--input-file-path-with-subdir,--input-filepath-with-subdir,--inputfilepath-with-subdir,'+
 '--input-file-path-withsubdir,--input-filepath-withsubdir,--inputfilepath-withsubdir,'+
 '--input-path-with-subdir,--input-path-withsubdir,--inputpath-withsubdir,--inputpathwithsubdir');
 writeln('  Specify the path contains input file(with subdirectory).');
 writeln('--dynamic-library,--dynamiclibrary,--shared-library,--sharedlibrary');
 writeln('  Specify the dynamic library name needed in output file.');
 writeln('--dynamic-library-search-path,--dynamiclibrary-search-path,--dynamiclibrary-searchpath,'+
 '--dynamiclibrarysearchpath,--shared-library-search-path,--sharedlibrary-search-path,'+
 '--sharedlibrary-searchpath,--sharedlibrarysearchpath');
 writeln('  Specify the dynamic library search path for dynamic library(Only available when '+
 'dynamic library specified).');
 writeln('--dynamic-library-search-path-with-subdir,--dynamic-library-searchpath-withsubdir,'+
 '--dynamic-library-searchpath-withsubdir,--dynamiclibrary-searchpath-withsubdir,'+
 '--dynamiclibrarysearchpath-withsubdir,--dynamiclibrarysearchpathwithsubdir,'+
 '--shared-object-search-path-with-subdir,--shared-object-searchpath-withsubdir,'+
 '--shared-object-searchpath-withsubdir,--sharedobject-searchpath-withsubdir,'+
 '--sharedobjectsearchpath-withsubdir,--sharedobjectsearchpathwithsubdir');
 writeln('  Specify the dynamic library search path for dynamic library with subdirectory'+
 '(Only available when dynamic library specified).');
 writeln('--baseaddress,--startaddress,--base-address,--start-address');
 writeln('  Specify the base address of the output file.');
 writeln('--filealign,--file-align');
 writeln('  Specify the file align of the output file(EFI File in Section,while ELF File in program '+
 'header,default is 4KiB(4096 bytes))');
 writeln('--nodeflib,--nodefaultlib,--no-deflib,--no-defaultlib,--nodeflibrary,'+
 '--nodefaultlibrary,--no-deflibrary,--no-defaultlibrary');
 writeln('  Disable the Default Library of the file(Only vaild in ELF Format File).');
 writeln('--noextlib,--noexternallib,--no-extlib,--no-extlib,--noextlibrary,'+
 '--noexternallibrary,--no-extlibrary,--no-externallibrary');
 writeln('  Disable the External Library of the file(ELF is optional while EFI is forced).');
 writeln('--bits,--file-bits,--filebits');
 writeln('  Specify the bits of the output file');
 writeln('--untypedbinaryalign,--untyped-binaryalign,--untyped-binary-align');
 writeln('  Specify the align of the untyped binary.');
 writeln('--untypedbinaryaddressable,--untypedbinary-addressable');
 writeln('  Enable the offset equal to the real address of the binary'+
 '(Must enable the untyped binary switch).');
 writeln('--relocatable');
 writeln('  Specify the relocatable type of ELF file(ELF Only)');
 writeln('--sharedobject,--sharedlink');
 writeln('  Specify the shared object(dynamic library) type of ELF file(ELF Only)');
 writeln('--executable');
 writeln('  Specify the executable type of ELF file(ELF Only)');
 writeln('--core-file,--corefile,--core');
 writeln('  Specify the Core type of ELF file(ELF Only)');
 writeln('--fixed-address,--fixedaddress,--fixed-addr,--fixedaddr');
 writeln('  Specify the fixed address option.');
 writeln('--pie,--positionindependentexecutable,--position-independent-executable');
 writeln('  Specify the PIE executable.');
 writeln('--static-pie,--staticpie,'+
 '--staticpositionindependentexecutable,--static-position-independent-executable');
 writeln('  Specify the Static PIE executable(Default in executable ELF file).');
 writeln('--efi-application,--uefi-application,--efiapplication,--uefiapplication,'+
 '--efi-app,--uefi-app,--efiapp,--uefiapp');
 writeln('  Specify the UEFI Application Type while set file type to EFI File.');
 writeln('--efi-bootdriver,--uefi-bootdriver,--efibootdriver,--uefibootdriver,'+
 '--efi-bootdrv,--uefi-bootdrv,--efibootdrv,--uefibootdrv');
 writeln('  Specify the UEFI Boot Driver Type while set file type to EFI File.');
 writeln('--efi-runtimedriver,--uefi-runtimedriver,--efiruntimedriver,--uefiruntimedriver,'+
 '--efi-rundrv,--uefi-rundrv,--efirundrv,--uefirundrv');
 writeln('  Specify the UEFI Runtime Driver Type while set file type to EFI File.');
 writeln('--efi-rom,--uefi-rom,--efirom,--uefirom');
 writeln('  Specify the UEFI Runtime Driver Type while set file type to EFI File.');
 writeln('--input-arch,--inputarch,--input-architecture,--inputarchitecture');
 writeln('  Specify the input architecture of the file.');
 writeln('  Vaild Options:i386/ia32,x86_64/x86/amd64,arm/arm32/aarch32,arm64/aarch64,'+
 'riscv32/rv32,riscv64/rv64,loongarch32/la32,loongarch64/la64');
 writeln('--output-arch,--outputarch,--output-architecture,--outputarchitecture');
 writeln('  Specify the output architecture of the file.');
 writeln('  Vaild Options:i386/ia32,x86_64/x86/amd64,arm/arm32/aarch32,arm64/aarch64,'+
 'riscv32/rv32,riscv64/rv64,loongarch32/la32,loongarch64/la64');
 writeln('--entry,--entryname,--entry-name,--entry-symbol,--entrysymbol');
 writeln('  Specify the entry name of the output file.');
 writeln('--script-path,--scriptpath,--linker-script-path,--linker-scriptpath,--linkerscriptpath'+
 ',--linker-script,--linkerscript');
 writeln('  Specify the Linker Script Path(Otherwise use the internal linker script).');
 writeln('--script-path-default,--scriptpath-default,'
 +'--linker-script-path-default,--linker-scriptpath-default,--linkerscriptpath-default'+
 ',--linker-script-default,--linkerscript-default');
 writeln('  Using the default linker script in internal program(if the linker script does not specified,'+
 'same as no command about linker script).');
 writeln('--gnu-linux,--gnulinux,--gnu,--linux');
 writeln('  Specify the ELF File Operating System to Linux(ELF File Only).');
 writeln('--application,--app');
 writeln('  Specify the EFI File Format to UEFI Application Type(EFI Type must be set for being vaild).');
 writeln('--boot-driver,--bootdriver,--boot-drv,--bootdrv');
 writeln('  Specify the EFI File Format to UEFI Boot Driver(EFI Type must be set for being vaild).');
 writeln('--runtime-driver,--runtimedriver,--run-drv,--rundrv');
 writeln('  Specify the EFI File Format to UEFI Runtime Driver(EFI Type must be set for being vaild).');
 writeln('--efi,--uefi');
 writeln('  Specify the output file is EFI File.');
 writeln('--untyped-binary-align,--untypedbinaryalign,--untypedbinary-align');
 writeln('  Specify the untyped binary file align with the following value.');
 writeln('--disablefilesymbol,--disable-filesymbol,--disable-file-symbol');
 writeln('  Disable the File Symbol of the Output File.');
 writeln('--disablesectionsymbol,--disable-sectionsymbol,--disable-section-symbol');
 writeln('  Disable the Section Symbol of the Output File.');
 writeln('--interpreter-need-function,--interpreter-needfunction,--interpreterneedfunction'+
 '--interpret-need-function,--interpret-needfunction,--interpretneedfunction');
 writeln('  Specify the Demanded Function in the interpreter to call(Default is _dl_runtime_resolve.');
 writeln('--gotenable,--got-enable');
 writeln('  Enable the GOT(Global Offset Table) Section as the symbol of the file.');
 writeln('--gotalias,--got-alias');
 writeln('  Set the GOT(Global Offset Table) Section Alias as a symbol(Must Enable the GOT Symbol).');
 writeln('  Default GOT Alias is _GLOBAL_OFFSET_TABLE_');
 writeln('--dynamicenable,--dynamic-enable');
 writeln('  Enable the Dynamic Section as the symbol of the file(Must in ELF File).');
 writeln('--dynamicalias,--dynamic-alias');
 writeln('  Set the Dynamic Section Alias as a symbol(Must Enable the Dynamic Symbol and in ELF File).');
 writeln('  Default Dynamic Alias is _DYNAMIC');
 writeln('--debug,--enable-debug,--enabledebug');
 writeln('  Set the Debug Mode of the Output File(When in ELF File Format it is vaild).');
 writeln('--shared-library-name,--shared-libraryname,--sharedlibraryname');
 writeln('  Set the ELF Format Shared Library Internal Name for Dynamic Linking(ELF Only)');
 writeln('--enable-ver,--enablever,--enable-version,--enableversion');
 writeln('  Enable the Version of the ELF Format Files.');
 writeln('--generate-version,--genversion');
 writeln('  Generate a version specified for the File(ELF File Format Only).');
 writeln('--generate-linker-sign,--gen-linker-sign');
 writeln('  Generate a sign of the linker(Automatically be unild version 0.0.4,ELF File Format Only)');
 writeln('--generate-custom-sign,--gen-custom-sign');
 writeln('  Generate a custom sign for the output file(ELF File Format Only)');
 writeln('--implicit-section-address,--implicitsection-address,--implicitsectionaddress');
 writeln('  Enable the Implicit Section Changes with Section Name and its Address(Such as '+
 '.hash,.gnu.hash,.dynsym,.dynstr,.dynamic,.got,.got.plt,any sort of .rela,.rel,.relr,'+
 'except .symtab,.strtab,.shstrtab cannot to be changed).');
 writeln('--implicit-section-maxsize,--implicitsection-maxsize,--implicitsectionmaxsize');
 writeln('  Enable the Implicit Section Changes with Section Name and its Maximum Size(Such as '+
 '.hash,.gnu.hash,.dynsym,.dynstr,.dynamic,.got,.got.plt,any sort of .rela,.rel,.relr,'+
 'except .symtab,.strtab,.shstrtab cannot to be changed).');
 writeln('--wait-when-error,--wait');
 writeln('  Enable the switch that when the linker encounter error,Linker will wait for next order.');
 writeln('--help');
 writeln('  Show the help of the unild.');
end;
procedure unild_parse_param;
var InputFileList:unifile_elf_object_file_total;
    ParseFileList:unifile_elf_object_file_parsed;
    LinkFileList:unifile_linked_file_stage;
    FileList:unild_filelist;
    {For Scanning}
    i,j,k:SizeUint;
    tempstr,tempstr2:string;
    tempvalue:SizeUint;
    TempHaveLibrary:boolean;
    {For Linking}
    LinkerScript:string='';
    InputArchitecture:word=0;
    InputBits:byte=0;
    OutputArchitecture:word=0;
    OutputBits:byte=0;
    OutputFileName:string='';
    Verbose:boolean=false;
begin
 i:=1;
 unild_initialize;
 while(i<=ParamCount)do
  begin
   if(LowerCase(ParamStr(i))='--wait-when-error') or (LowerCase(ParamStr(i))='--wait') then
    begin
     Script.LinkerWait:=true;
    end
   else if(LowerCase(ParamStr(i))='--verbose') or (LowerCase(ParamStr(i))='--cui')
   or(LowerCase(ParamStr(i))='--console') then
    begin
     Verbose:=true;
    end
   else if(LowerCase(ParamStr(i))='--untypedbinaryaddressable') or
   (LowerCase(ParamStr(i))='--untypedbinary-addressable') then
    begin
     Script.UntypedBinaryAddressable:=true;
    end
   else if(LowerCase(ParamStr(i))='--untypedbinary') or (LowerCase(ParamStr(i))='--binary')
   or(LowerCase(ParamStr(i))='--untyped') or(LowerCase(ParamStr(i))='--notype') then
    begin
     Script.IsUntypedBinary:=true;
    end
   else if(LowerCase(ParamStr(i))='--version') or (LowerCase(ParamStr(i))='--linker-version')
   or (LowerCase(ParamStr(i))='--linkerversion') then
    begin
     writeln('unild(universal linker editor) version 0.0.3');
     readln;
     halt;
    end
   else if(LowerCase(ParamStr(i))='--smartlinking') or (LowerCase(ParamStr(i))='--smart')
   or(LowerCase(ParamStr(i))='--smartlink') or(LowerCase(ParamStr(i))='--smart-link') or
   (LowerCase(ParamStr(i))='--smart-linking')then
    begin
     Script.SmartLinking:=true; Script.LinkAll:=false;
    end
   else if(LowerCase(ParamStr(i))='--disablefilesymbol') or
   (LowerCase(ParamStr(i))='--disable-filesymbol') or
   (LowerCase(ParamStr(i))='--disable-file-symbol') then
    begin
     Script.EnableFileInformation:=false;
    end
   else if(LowerCase(ParamStr(i))='--disablesectionsymbol') or
   (LowerCase(ParamStr(i))='--disable-sectionsymbol') or
   (LowerCase(ParamStr(i))='--disable-section-symbol') then
    begin
     Script.EnableSectionInformation:=false;
    end
   else if(LowerCase(ParamStr(i))='--linkallsection') or (LowerCase(ParamStr(i))='--linkallsect')
   or(LowerCase(ParamStr(i))='--nosmartlinking') or(LowerCase(ParamStr(i))='--linkall')
   or(LowerCase(ParamStr(i))='--nosmart') or (LowerCase(ParamStr(i))='--nosmartlink')
   or(LowerCase(ParamStr(i))='--no-smartlink') or (LowerCase(ParamStr(i))='--no-smartlinking')
   or(LowerCase(ParamStr(i))='--no-smart-linking') then
    begin
     Script.SmartLinking:=false; Script.LinkAll:=true;
    end
   else if(LowerCase(ParamStr(i))='--no-symbol') or (LowerCase(ParamStr(i))='--discard-symbol')
   or(LowerCase(ParamStr(i))='--strip-symbol') or (LowerCase(ParamStr(i))='--delete-symbol') then
    begin
     Script.NoSymbol:=true;
    end
   else if(LowerCase(ParamStr(i))='--symbolic') or (LowerCase(ParamStr(i))='--keep-symbol')
   or (LowerCase(ParamStr(i))='--maintain-symbol') then
    begin
     Script.Symbolic:=true; Script.NoSymbol:=false;
    end
   else if(LowerCase(ParamStr(i))='--no-executable-stack') or
   (LowerCase(ParamStr(i))='--no-executablestack') or
   (LowerCase(ParamStr(i))='--no-exec-stack') or (LowerCase(ParamStr(i))='--no-execstack') then
    begin
     Script.NoExecutableStack:=true;
    end
   else if(LowerCase(ParamStr(i))='--generate-version') or (LowerCase(ParamStr(i))='--genversion') then
    begin
     if(i+1>ParamCount) or (Copy(ParamStr(i+1),1,2)='--') then
      begin
       writeln('ERROR:Version Content not defined.');
       readln;
       halt;
      end;
     Script.GenerateVersion:=true; Script.VersionContent:=ParamStr(i+1); inc(i);
    end
   else if(LowerCase(ParamStr(i))='--generate-custom-sign') or
   (LowerCase(ParamStr(i))='--gen-custom-sign') then
    begin
     Script.GenerateCustomSign:=true;
     if(i+1>ParamCount) or (Copy(ParamStr(i+1),1,2)='--') then
      begin
       writeln('ERROR:Custom Sign Section Name not defined.');
       readln;
       halt;
      end;
     Script.CustomSignSectionName:=ParamStr(i+1);
     if(i+2>ParamCount) or (Copy(ParamStr(i+2),1,2)='--') then
      begin
       writeln('ERROR:Custom Sign Content not defined.');
       readln;
       halt;
      end;
     Script.CustomSignContent:=ParamStr(i+2);
     inc(i,2);
    end
   else if(LowerCase(ParamStr(i))='--generate-linker-sign') or
   (LowerCase(ParamStr(i))='--gen-linker-sign') then
    begin
     Script.GenerateLinkerSign:=true;
     Script.LinkerSignContent:='unild version 0.0.4';
    end
   else if(LowerCase(ParamStr(i))='--readonlygot') or (LowerCase(ParamStr(i))='--readonly-got') then
    begin
     Script.GotAuthority:=unild_readonly_got;
    end
   else if(LowerCase(ParamStr(i))='--writablegot') or (LowerCase(ParamStr(i))='--writable-got') then
    begin
     Script.GotAuthority:=unild_writable_got;
    end
   else if(LowerCase(ParamStr(i))='--uncheckedgot') or (LowerCase(ParamStr(i))='--unchecked-got') then
    begin
     Script.GotAuthority:=unild_unchecked_got;
    end
   else if(LowerCase(ParamStr(i))='--interpreter') or (LowerCase(ParamStr(i))='--interp') then
    begin
     j:=i+1;
     while(j<=ParamCount)do
      begin
       tempstr:=ParamStr(j);
       if(length(tempstr)>2) and (Copy(tempstr,1,2)='--') then break
       else if(length(tempstr)>2) then
        begin
         if(FileExists(tempstr)) and (Script.Interpreter='') then
         Script.Interpreter:=tempstr
         else
          begin
           inc(j); continue;
          end;
        end
       else break;
       inc(j);
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--output-file-name')
   or(LowerCase(ParamStr(i))='--output-filename')
   or(LowerCase(ParamStr(i))='--outputfilename') or (LowerCase(ParamStr(i))='--output') then
    begin
     OutputFileName:=ParamStr(i+1); inc(i);
    end
   else if(LowerCase(ParamStr(i))='--input-file') or (LowerCase(ParamStr(i))='--inputfile')
   or (LowerCase(ParamStr(i))='--input') then
    begin
     j:=i+1;
     while(j<=ParamCount) do
      begin
       tempstr:=ParamStr(j);
       if(length(tempstr)>2) and (Copy(tempstr,1,2)='--') then break
       else if(length(tempstr)>2) then
        begin
         if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
         ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
         tempstr:=Copy(tempstr,2,length(tempstr)-2);
         inc(Script.InputFileCount);
         SetLength(Script.InputFile,Script.InputFileCount);
         Script.InputFile[Script.InputFileCount-1]:=ParamStr(j);
        end
       else break;
       inc(j);
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--input-file-path') or (LowerCase(ParamStr(i))='--input-filepath')
   or(LowerCase(ParamStr(i))='--inputfilepath')
   or(LowerCase(ParamStr(i))='--input-path') or(LowerCase(ParamStr(i))='--inputpath')then
    begin
     j:=i+1;
     while(j<=ParamCount) do
      begin
       tempstr:=ParamStr(j);
       if(length(tempstr)>2) and (Copy(tempstr,1,2)='--') then break
       else if(length(tempstr)>2) then
        begin
         if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
         ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
         tempstr:=Copy(tempstr,2,length(tempstr)-2);
         inc(Script.InputFilePathCount);
         SetLength(Script.InputFilePath,Script.InputFilePathCount);
         SetLength(Script.InputFileHaveSubPath,Script.InputFilePathCount);
         Script.InputFilePath[Script.InputFilePathCount-1]:=tempstr;
         Script.InputFileHaveSubPath[Script.InputFilePathCount-1]:=false;
        end
       else break;
       inc(j);
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--input-file-path-with-subdir')
   or(LowerCase(ParamStr(i))='--input-filepath-with-subdir')
   or(LowerCase(ParamStr(i))='--inputfilepath-with-subdir')
   or(LowerCase(ParamStr(i))='--input-file-path-withsubdir')
   or(LowerCase(ParamStr(i))='--input-filepath-withsubdir')
   or(LowerCase(ParamStr(i))='--inputfilepath-withsubdir')
   or(LowerCase(ParamStr(i))='--input-path-with-subdir')
   or(LowerCase(ParamStr(i))='--input-path-withsubdir')
   or(LowerCase(ParamStr(i))='--inputpath-withsubdir')
   or(LowerCase(ParamStr(i))='--inputpathwithsubdir') then
    begin
     j:=i+1;
     while(j<=ParamCount) do
      begin
       tempstr:=ParamStr(j);
       if(length(tempstr)>2) and (Copy(tempstr,1,2)='--') then break
       else if(length(tempstr)>2) then
        begin
         if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
         ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
         tempstr:=Copy(tempstr,2,length(tempstr)-2);
         inc(Script.InputFilePathCount);
         SetLength(Script.InputFilePath,Script.InputFilePathCount);
         SetLength(Script.InputFileHaveSubPath,Script.InputFilePathCount);
         Script.InputFilePath[Script.InputFilePathCount-1]:=tempstr;
         Script.InputFileHaveSubPath[Script.InputFilePathCount-1]:=true;
        end
       else break;
       inc(j);
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--dynamic-library') or
   (LowerCase(ParamStr(i))='--dynamiclibrary') or
   (LowerCase(ParamStr(i))='--shared-library') or
   (LowerCase(ParamStr(i))='--sharedlibrary') then
    begin
     j:=i+1;
     while(j<=ParamCount) do
      begin
       tempstr:=ParamStr(j);
       if(length(tempstr)>2) and (Copy(tempstr,1,2)='--') then break
       else if(length(tempstr)>2) then
        begin
         if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
         ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
         tempstr:=Copy(tempstr,2,length(tempstr)-2);
         tempstr2:=ExtractFileName(tempstr);
         inc(Script.DynamicLibraryCount);
         SetLength(Script.DynamicLibrary,Script.DynamicLibraryCount);
         Script.DynamicLibrary[Script.DynamicLibraryCount-1]:=tempstr2;
         if(tempstr<>tempstr2) then
          begin
           tempstr:=Copy(tempstr,1,length(tempstr)-length(tempstr2)-1);
           if(tempstr='') then
            begin
             inc(j); continue;
            end;
           inc(Script.DynamicLibraryPathCount);
           SetLength(Script.DynamicLibraryPath,Script.DynamicLibraryPathCount);
           Script.DynamicLibraryPath[Script.DynamicLibraryPathCount-1]:=tempstr;
          end;
        end
       else break;
       inc(j);
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--dynamic-library-search-path') or
   (LowerCase(ParamStr(i))='--dynamiclibrary-search-path') or
   (LowerCase(ParamStr(i))='--dynamiclibrary-searchpath') or
   (LowerCase(ParamStr(i))='--dynamiclibrarysearchpath') or
   (LowerCase(ParamStr(i))='--shared-library-search-path') or
   (LowerCase(ParamStr(i))='--sharedlibrary-search-path') or
   (LowerCase(ParamStr(i))='--sharedlibrary-searchpath') or
   (LowerCase(ParamStr(i))='--sharedlibrarysearchpath')  then
    begin
     j:=i+1;
     while(j<=ParamCount) do
      begin
       tempstr:=ParamStr(j);
       if(length(tempstr)>2) and (Copy(tempstr,1,2)='--') then break
       else if(length(tempstr)>2) then
        begin
         if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
         ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
         tempstr:=Copy(tempstr,2,length(tempstr)-2);
         inc(Script.DynamicLibraryPathCount);
         SetLength(Script.DynamicLibraryPath,Script.DynamicLibraryPathCount);
         Script.DynamicLibraryPath[Script.DynamicLibraryPathCount-1]:=tempstr;
        end
       else break;
       inc(j);
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--dynamic-library-search-path-with-subdir') or
   (LowerCase(ParamStr(i))='--dynamic-library-searchpath-withsubdir') or
   (LowerCase(ParamStr(i))='--dynamic-library-searchpath-withsubdir') or
   (LowerCase(ParamStr(i))='--dynamiclibrary-searchpath-withsubdir') or
   (LowerCase(ParamStr(i))='--dynamiclibrarysearchpath-withsubdir') or
   (LowerCase(ParamStr(i))='--dynamiclibrarysearchpathwithsubdir') or
   (LowerCase(ParamStr(i))='--shared-object-search-path-with-subdir') or
   (LowerCase(ParamStr(i))='--shared-object-searchpath-withsubdir') or
   (LowerCase(ParamStr(i))='--shared-object-searchpath-withsubdir') or
   (LowerCase(ParamStr(i))='--sharedobject-searchpath-withsubdir') or
   (LowerCase(ParamStr(i))='--sharedobjectsearchpath-withsubdir') or
   (LowerCase(ParamStr(i))='--sharedobjectsearchpathwithsubdir') then
    begin
     j:=i+1;
     while(j<=ParamCount) do
      begin
       tempstr:=ParamStr(j);
       if(length(tempstr)>2) and (Copy(tempstr,1,2)='--') then break
       else if(length(tempstr)>2) then
        begin
         if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
         ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
         tempstr:=Copy(tempstr,2,length(tempstr)-2);
         inc(Script.DynamicPathWithSubDirectoryCount);
         SetLength(Script.DynamicPathWithSubDirectoryList,Script.DynamicPathWithSubDirectoryCount);
         Script.DynamicPathWithSubDirectoryList[Script.DynamicPathWithSubDirectoryCount-1]:=tempstr;
        end
       else break;
       inc(j);
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--baseaddress') or (LowerCase(ParamStr(i))='--startaddress')
   or(LowerCase(ParamStr(i))='--base-address') or (LowerCase(ParamStr(i))='--start-address') then
    begin
     if(unild_check_str_int(ParamStr(i+1))=false) then
      begin
       unild_param_raise_error(i+1,ParamStr(i+1),
       'Input Base Address of the output file does not vaild.');
      end;
     Script.BaseAddress:=unild_str_to_int(ParamStr(i+1));
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--filealign') or (LowerCase(ParamStr(i))='--file-align') then
    begin
     if(unild_check_str_int(ParamStr(i+1))=false) then
      begin
       unild_param_raise_error(i+1,ParamStr(i+1),
       'Input File Alignment of the output file does not vaild.');
      end;
     Script.FileAlign:=unild_str_to_int(ParamStr(i+1));
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--untyped-binary-align')
   or (LowerCase(ParamStr(i))='--untypedbinaryalign')
   or (LowerCase(ParamStr(i))='--untypedbinary-align')then
    begin
     if(unild_check_str_int(ParamStr(i+1))=false) then
      begin
       unild_param_raise_error(i+1,ParamStr(i+1),
       'Input Untyped Binary Alignment of the output file does not vaild.');
      end;
     Script.UntypedBinaryAlign:=unild_str_to_int(ParamStr(i+1));
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--nodeflib') or (LowerCase(ParamStr(i))='--nodefaultlib')
   or (LowerCase(ParamStr(i))='--no-deflib') or (LowerCase(ParamStr(i))='--no-defaultlib')
   or (LowerCase(ParamStr(i))='--nodeflibrary') or (LowerCase(ParamStr(i))='--nodefaultlibrary')
   or (LowerCase(ParamStr(i))='--no-deflibrary') or (LowerCase(ParamStr(i))='--no-defaultlibrary') then
    begin
     Script.NoDefaultLibrary:=true;
    end
   else if(LowerCase(ParamStr(i))='--noextlib') or (LowerCase(ParamStr(i))='--noexternallib')
   or (LowerCase(ParamStr(i))='--no-extlib') or (LowerCase(ParamStr(i))='--no-externallib')
   or (LowerCase(ParamStr(i))='--noextlibrary') or (LowerCase(ParamStr(i))='--noexternallibrary')
   or (LowerCase(ParamStr(i))='--no-extlibrary') or (LowerCase(ParamStr(i))='--no-externallibrary') then
    begin
     Script.NoExternalLibrary:=true;
    end
   else if(LowerCase(ParamStr(i))='--bits') or (LowerCase(ParamStr(i))='--file-bits') or
   (LowerCase(ParamStr(i))='--filebits') then
    begin
     if(unild_check_str_int(ParamStr(i+1))=false) then
      begin
       unild_param_raise_error(i+1,ParamStr(i+1),
       'Input File Bits is invaild as input is not a number.');
      end;
     Script.Bits:=unild_str_to_int(ParamStr(i+1));
     if(Script.Bits<>32) and (Script.Bits<>64) then
      begin
       unild_param_raise_error(i+1,ParamStr(i+1),
       'Input File Bits is invaild as input is not 32-bit or 64-bit.');
      end;
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--relocatable') then
    begin
     Script.elfclass:=unild_class_relocatable;
    end
   else if(LowerCase(ParamStr(i))='--sharedobject') or (LowerCase(ParamStr(i))='--sharedlink') then
    begin
     Script.elfclass:=unild_class_sharedobject;
    end
   else if(LowerCase(ParamStr(i))='--executable') then
    begin
     Script.elfclass:=unild_class_executable;
    end
   else if(LowerCase(ParamStr(i))='--core-file') or (LowerCase(ParamStr(i))='--corefile')
   or(LowerCase(ParamStr(i))='--core') then
    begin
     Script.elfclass:=unild_class_core;
    end
   else if(LowerCase(ParamStr(i))='--uefi') or (LowerCase(ParamStr(i))='--efi') then
    begin
     Script.IsEFIFile:=true;
    end
   else if(LowerCase(ParamStr(i))='--application') or (LowerCase(ParamStr(i))='--app') then
    begin
     Script.EFIFileIndex:=unild_class_application;
    end
   else if(LowerCase(ParamStr(i))='--boot-driver') or (LowerCase(ParamStr(i))='--bootdriver')
   or(LowerCase(ParamStr(i))='--boot-drv') or (LowerCase(ParamStr(i))='--bootdrv') then
    begin
     Script.EFIFileIndex:=unild_class_bootdriver;
    end
   else if(LowerCase(ParamStr(i))='--runtime-driver') or (LowerCase(ParamStr(i))='--runtimedriver')
   or(LowerCase(ParamStr(i))='--run-drv') or (LowerCase(ParamStr(i))='--rundrv') then
    begin
     Script.EFIFileIndex:=unild_class_runtimedriver;
    end
   else if(LowerCase(ParamStr(i))='--rom') then
    begin
     Script.EFIFileIndex:=unild_class_rom;
    end
   else if(LowerCase(ParamStr(i))='--fixed-address') or (LowerCase(ParamStr(i))='--fixedaddress')
   or(LowerCase(ParamStr(i))='--fixed-addr') or (LowerCase(ParamStr(i))='--fixedaddr') then
    begin
     Script.NoFixedAddress:=false;
    end
   else if(LowerCase(ParamStr(i))='--debug') or (LowerCase(ParamStr(i))='--enable-debug')
   or (LowerCase(ParamStr(i))='--enabledebug') then
    begin
     Script.DebugSwitch:=true;
    end
   else if(LowerCase(ParamStr(i))='--shared-library-name') or
   (LowerCase(ParamStr(i))='--shared-libraryname') or
   (LowerCase(ParamStr(i))='--sharedlibraryname') then
    begin
     Script.SharedLibraryName:=ParamStr(i+1); inc(i);
    end
   else if(LowerCase(ParamStr(i))='--pie') or
   (LowerCase(ParamStr(i))='--positionindependentexecutable') or
   (LowerCase(ParamStr(i))='--position-independent-executable') then
    begin
     Script.elfclass:=unild_class_executable; Script.NoFixedAddress:=true;
    end
   else if(LowerCase(ParamStr(i))='--staticpie') or (LowerCase(ParamStr(i))='--static-pie') or
   (LowerCase(ParamStr(i))='--staticpositionindependentexecutable') or
   (LowerCase(ParamStr(i))='--static-position-independent-executable') then
    begin
     Script.elfclass:=unild_class_executable; Script.NoFixedAddress:=true;
     Script.Interpreter:='';
    end
   else if(LowerCase(ParamStr(i))='--efi-application')
   or(LowerCase(ParamStr(i))='--uefi-application')
   or(LowerCase(ParamStr(i))='--efiapplication')
   or(LowerCase(ParamStr(i))='--uefiapplication')
   or(LowerCase(ParamStr(i))='--efi-app')
   or(LowerCase(ParamStr(i))='--uefi-app')
   or(LowerCase(ParamStr(i))='--efiapp')
   or(LowerCase(ParamStr(i))='--uefiapp')then
    begin
     Script.IsEFIFile:=true; Script.EFIFileIndex:=unild_class_application;
     Script.NoExternalLibrary:=true;
    end
   else if(LowerCase(ParamStr(i))='--efi-bootdriver')
   or(LowerCase(ParamStr(i))='--uefi-bootdriver')
   or(LowerCase(ParamStr(i))='--efibootdriver')
   or(LowerCase(ParamStr(i))='--uefibootdriver')
   or(LowerCase(ParamStr(i))='--efi-bootdrv')
   or(LowerCase(ParamStr(i))='--uefi-bootdrv')
   or(LowerCase(ParamStr(i))='--efibootdrv')
   or(LowerCase(ParamStr(i))='--uefibootdrv')then
    begin
     Script.IsEFIFile:=true; Script.EFIFileIndex:=unild_class_bootdriver;
     Script.NoExternalLibrary:=true;
    end
   else if(LowerCase(ParamStr(i))='--efi-runtimedriver')
   or(LowerCase(ParamStr(i))='--uefi-runtimedriver')
   or(LowerCase(ParamStr(i))='--efiruntimedriver')
   or(LowerCase(ParamStr(i))='--uefiruntimedriver')
   or(LowerCase(ParamStr(i))='--efi-rundrv')
   or(LowerCase(ParamStr(i))='--uefi-rundrv')
   or(LowerCase(ParamStr(i))='--efirundrv')
   or(LowerCase(ParamStr(i))='--uefirundrv')then
    begin
     Script.IsEFIFile:=true; Script.EFIFileIndex:=unild_class_runtimedriver;
     Script.NoExternalLibrary:=true;
    end
   else if(LowerCase(ParamStr(i))='--efi-rom')or(LowerCase(ParamStr(i))='--uefi-rom')
   or(LowerCase(ParamStr(i))='--efirom')or(LowerCase(ParamStr(i))='--uefirom')then
    begin
     Script.IsEFIFile:=true; Script.EFIFileIndex:=unild_class_rom;
     Script.NoExternalLibrary:=true;
    end
   else if(LowerCase(ParamStr(i))='--input-arch') or(LowerCase(ParamStr(i))='--inputarch')
   or(LowerCase(ParamStr(i))='--input-architecture')
   or(LowerCase(ParamStr(i))='--inputarchitecture') then
    begin
     tempstr:=LowerCase(ParamStr(i+1));
     if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
     ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
     tempstr:=Copy(tempstr,2,length(tempstr)-2);
     if(tempstr='i386') or (tempstr='ia32') then
      begin
       InputArchitecture:=elf_machine_386; InputBits:=32;
      end
     else if(tempstr='x86_64') or (tempstr='x86')
     or (tempstr='amd64') then
      begin
       InputArchitecture:=elf_machine_x86_64; InputBits:=64;
      end
     else if(tempstr='arm') or (tempstr='arm32') or
     (tempstr='aarch32') then
      begin
       InputArchitecture:=elf_machine_arm; InputBits:=32;
      end
     else if(tempstr='arm64') or (tempstr='aarch64') then
      begin
       InputArchitecture:=elf_machine_aarch64; InputBits:=64;
      end
     else if(tempstr='riscv32') or (tempstr='rv32') then
      begin
       InputArchitecture:=elf_machine_riscv; InputBits:=32;
      end
     else if(tempstr='riscv64') or (tempstr='rv64') then
      begin
       InputArchitecture:=elf_machine_riscv; InputBits:=64;
      end
     else if(tempstr='loongarch32') or (tempstr='la32') then
      begin
       InputArchitecture:=elf_machine_loongarch; InputBits:=32;
      end
     else if(tempstr='loongarch64') or (tempstr='la64') then
      begin
       InputArchitecture:=elf_machine_loongarch; InputBits:=64;
      end
     else
      begin
       unild_param_raise_error(i+1,ParamStr(i+1),
       'Unsupported Input Architecture '+tempstr);
      end;
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--gnu-linux')
   or(LowerCase(ParamStr(i))='--gnu')or(LowerCase(ParamStr(i))='--gnulinux')
   or(LowerCase(ParamStr(i))='--linux') then
    begin
     Script.SystemIndex:=1;
    end
   else if(LowerCase(ParamStr(i))='--output-arch') or(LowerCase(ParamStr(i))='--outputarch')
   or(LowerCase(ParamStr(i))='--output-architecture')
   or(LowerCase(ParamStr(i))='--outputarchitecture') then
    begin
     tempstr:=LowerCase(ParamStr(i+1));
     if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
     ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
     tempstr:=Copy(tempstr,2,length(tempstr)-2);
     if(tempstr='i386') or (tempstr='ia32') then
      begin
       OutputArchitecture:=elf_machine_386; OutputBits:=32;
      end
     else if(tempstr='x86_64') or (tempstr='x86')
     or (tempstr='amd64') then
      begin
       OutputArchitecture:=elf_machine_x86_64; OutputBits:=64;
      end
     else if(tempstr='arm') or (tempstr='arm32') or
     (tempstr='aarch32') then
      begin
       OutputArchitecture:=elf_machine_arm; OutputBits:=32;
      end
     else if(tempstr='arm64') or (tempstr='aarch64') then
      begin
       OutputArchitecture:=elf_machine_aarch64; OutputBits:=64;
      end
     else if(tempstr='riscv32') or (tempstr='rv32') then
      begin
       OutputArchitecture:=elf_machine_riscv; OutputBits:=32;
      end
     else if(tempstr='riscv64') or (tempstr='rv64') then
      begin
       OutputArchitecture:=elf_machine_riscv; OutputBits:=64;
      end
     else if(tempstr='loongarch32') or (tempstr='la32') then
      begin
       OutputArchitecture:=elf_machine_loongarch; OutputBits:=32;
      end
     else if(tempstr='loongarch64') or (tempstr='la64') then
      begin
       OutputArchitecture:=elf_machine_loongarch; OutputBits:=64;
      end
     else
      begin
       unild_param_raise_error(i+1,ParamStr(i+1),
       'Unsupported Output Architecture '+tempstr);
      end;
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--entry')or(LowerCase(ParamStr(i))='--entryname')
   or(LowerCase(ParamStr(i))='--entry-name')or(LowerCase(ParamStr(i))='--entry-symbol')
   or(LowerCase(ParamStr(i))='--entrysymbol') then
    begin
     tempstr:=ParamStr(i+1);
     if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
     ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
     tempstr:=Copy(tempstr,2,length(tempstr)-2);
     Script.EntryName:=tempstr; inc(i);
    end
   else if(LowerCase(ParamStr(i))='--script-path') or
   (LowerCase(ParamStr(i))='--scriptpath') or
   (LowerCase(ParamStr(i))='--linker-script-path') or
   (LowerCase(ParamStr(i))='--linker-scriptpath') or
   (LowerCase(ParamStr(i))='--linkerscriptpath') or
   (LowerCase(ParamStr(i))='--linker-script') or
   (LowerCase(ParamStr(i))='--linkerscript') then
    begin
     j:=i+1;
     while(j<=ParamCount)do
      begin
       tempstr:=ParamStr(j);
       if(length(tempstr)<=2) then break
       else if(length(tempstr)>2) then
        begin
         if(Copy(tempstr,1,2)='--') then break;
         if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
         ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
         tempstr:=Copy(tempstr,2,length(tempstr)-2);
         if(FileExists(tempstr)) and (LinkerScript='') then LinkerScript:=tempstr
         else
          begin
           inc(j); continue;
          end;
        end;
       inc(j);
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--script-path-default') or
   (LowerCase(ParamStr(i))='--scriptpath-default') or
   (LowerCase(ParamStr(i))='--linker-script-path-default') or
   (LowerCase(ParamStr(i))='--linker-scriptpath-default') or
   (LowerCase(ParamStr(i))='--linkerscriptpath-default') or
   (LowerCase(ParamStr(i))='--linker-script-default') or
   (LowerCase(ParamStr(i))='--linkerscript-default') then
    begin
     LinkerScript:='';
    end
   else if(LowerCase(ParamStr(i))='--interpreter-need-function') or
   (LowerCase(ParamStr(i))='--interpreter-needfunction') or
   (LowerCase(ParamStr(i))='--interpreterneedfunction') or
   (LowerCase(ParamStr(i))='--interp-need-function') or
   (LowerCase(ParamStr(i))='--interp-needfunction') or
   (LowerCase(ParamStr(i))='--interpneedfunction') then
    begin
     Script.InterpreterDynamicLinkFunction:=ParamStr(i+1); inc(i);
    end
   else if(LowerCase(ParamStr(i))='--got-enable') or (LowerCase(ParamStr(i))='--gotenable') then
    begin
     Script.GlobalOffsetTableSectionEnable:=true;
    end
   else if(LowerCase(ParamStr(i))='--got-alias') or (LowerCase(ParamStr(i))='--gotalias') then
    begin
     tempstr:=ParamStr(i+1);
     if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
     ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
     tempstr:=Copy(tempstr,2,length(tempstr)-2);
     Script.GlobalOffsetTableAlias:=tempstr; inc(i);
    end
   else if(LowerCase(ParamStr(i))='--dynamic-enable') or (LowerCase(ParamStr(i))='--dynamicenable') then
    begin
     Script.DynamicSectionEnable:=true;
    end
   else if(LowerCase(ParamStr(i))='--dynamic-alias') or (LowerCase(ParamStr(i))='--dynamicalias') then
    begin
     tempstr:=ParamStr(i+1);
     if((tempstr[1]='"') and (tempstr[length(tempstr)]='"')) or
     ((tempstr[1]=#39) and (tempstr[length(tempstr)]=#39)) then
     tempstr:=Copy(tempstr,2,length(tempstr)-2);
     Script.DynamicSectionAlias:=tempstr; inc(i);
    end
   else if(LowerCase(ParamStr(i))='--version-enable') or (LowerCase(ParamStr(i))='--versionenable')
   or(LowerCase(ParamStr(i))='--ver-enable') or (LowerCase(ParamStr(i))='--verenable') then
    begin
     Script.VersionSwitch:=true;
    end
   else if(LowerCase(ParamStr(i))='--start-on-entry') or
   (LowerCase(ParamStr(i))='--start-onentry') or
   (LowerCase(ParamStr(i))='--startonentry') then
    begin
     Script.EntryAsStartOfSection:=true;
    end
   else if(LowerCase(ParamStr(i))='--implicit-section-address') or
   (LowerCase(ParamStr(i))='--implicitsection-address') or
   (LowerCase(ParamStr(i))='--implicitsectionaddress') then
    begin
     j:=i+1; tempstr:='';
     while(j<=ParamCount)do
      begin
       tempstr:=ParamStr(j);
       if(Copy(tempstr,1,2)='--') then break;
       if(tempstr='.strtab') or (tempstr='.symtab') or (tempstr='.shstrtab') then
        begin
         unild_param_raise_error(j,ParamStr(j),
         'Typed section '+tempstr+' is specified section auto-generated and '+
         'not to be changed,cannot change address with the Implicit Section Address Command.');
        end
       else if(tempstr<>'.hash')and(tempstr<>'.gnu.hash')and(tempstr<>'.dynamic')
       and(tempstr<>'.dynsym')and(tempstr<>'.dynstr')and(tempstr<>'.got')and(tempstr<>'.got.plt')
       and(Copy(tempstr,1,5)<>'.rela')and(Copy(tempstr,1,5)<>'.relr')
       and(Copy(tempstr,1,4)<>'.rel') and(tempstr<>'.version') or (tempstr<>'.unidata')then
        begin
         unild_param_raise_error(j,ParamStr(j),
         'Typed section '+tempstr+' is not the implicit section,cannot change address '+
         'with the Implicit Section Address Command.');
        end;
       if(j+1>ParamCount) or (Copy(ParamStr(j+1),1,2)='--') then
        begin
         unild_param_raise_error(j,ParamStr(j),
         'The Specified Implicit Section does not have the address value of '+
         'this implicit section.');
        end;
       if(unild_check_str_int(ParamStr(j+1))=false) then
        begin
         unild_param_raise_error(j+1,ParamStr(j+1),
         'The Input Specified Implicit Section Address is not a vaild unsigned number.');
        end;
       tempvalue:=unild_str_to_int(ParamStr(j+1));
       inc(Script.ImplicitCount);
       SetLength(Script.ImplicitName,Script.ImplicitCount);
       SetLength(Script.ImplicitAddress,Script.ImplicitCount);
       Script.ImplicitName[i-1]:=tempstr;
       Script.ImplicitAddress[i-1]:=tempvalue;
       inc(j,2);
      end;
     if(tempstr='') then
      begin
       unild_param_raise_error(i,ParamStr(i),
       'ERROR:Implicit Section Address must have at least two parameters.');
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--implicit-section-maxsize') or
   (LowerCase(ParamStr(i))='--implicitsection-maxsize') or
   (LowerCase(ParamStr(i))='--implicitsectionmaxsize') then
    begin
     j:=i+1; tempstr:='';
     while(j<=ParamCount)do
      begin
       tempstr:=ParamStr(j);
       if(Copy(tempstr,1,2)='--') then break;
       if(tempstr='.strtab') or (tempstr='.symtab') or (tempstr='.shstrtab') then
        begin
         unild_param_raise_error(j,ParamStr(j),
         'Typed section '+tempstr+' is not the implicit section,cannot change address '+
         'with the Implicit Section Maximum Command.');
        end
       else if(tempstr<>'.hash')and(tempstr<>'.gnu.hash')and(tempstr<>'.dynamic')
       and(tempstr<>'.dynsym')and(tempstr<>'.dynstr')and(tempstr<>'.got')and(tempstr<>'.got.plt')
       and(Copy(tempstr,1,5)<>'.rela')and(Copy(tempstr,1,5)<>'.relr')
       and(Copy(tempstr,1,4)<>'.rel')and(tempstr<>'.version') or (tempstr<>'.unidata') then
        begin
         unild_param_raise_error(j,ParamStr(j),
         'The Specified Implicit Section does not have the Maximum value of this implicit section.');
        end;
       if(j+1>ParamCount) and (Copy(ParamStr(j+1),1,2)='--') then
        begin
         unild_param_raise_error(j+1,ParamStr(j+1),
         'The Input Specified Implicit Section Maximum Size is not a vaild unsigned number.');
        end;
       tempvalue:=unild_str_to_int(ParamStr(j+1));
       inc(Script.ImplicitSizeCount);
       SetLength(Script.ImplicitSizeName,Script.ImplicitSizeCount);
       SetLength(Script.ImplicitSize,Script.ImplicitSizeCount);
       Script.ImplicitSizeName[i-1]:=tempstr;
       Script.ImplicitSize[i-1]:=tempvalue;
       inc(j,2);
      end;
     if(tempstr='') then
      begin
       unild_param_raise_error(i,ParamStr(i),
       'Implicit Section Size must have at least two parameters.');
      end;
     i:=j; continue;
    end
   else if(LowerCase(ParamStr(i))='--help') then
    begin
     unild_help;
     readln;
     exit;
    end
   else
    begin
     unild_param_raise_error(i,ParamStr(i),
     'Unknown Command '+ParamStr(i)+',please look up the help for more information.');
    end;
   inc(i);
  end;
 if(ParamCount=0) then
  begin
   writeln('No parameter,enter the help of the program.');
   unild_help;
   readln;
   exit;
  end;
 unifile_linkerwait:=Script.LinkerWait;
 if(Script.GenerateCustomSign) then
  begin
   for i:=1 to Script.SectionCount do
    begin
     if(Script.Section[i-1].SectionName=Script.CustomSignSectionName) then
      begin
       unild_init_raise_error('Section Name cannot be '+Script.CustomSignSectionName+' due to Section Name '+
       Script.Section[i-1].SectionName+' is a existing section in linking.',
       'Please examine the linker script for more information.',Script.LinkerWait);
      end;
    end;
   tempstr:=Script.CustomSignSectionName;
   if(tempstr='.hash')or(tempstr='.gnu.hash')or(tempstr='.dynamic')
   or(tempstr='.dynsym')or(tempstr='.dynstr')or(tempstr='.got')or(tempstr='.got.plt')
   or(Copy(tempstr,1,5)='.rela')or(Copy(tempstr,1,5)='.relr')
   or(Copy(tempstr,1,4)='.rel')or(tempstr='.version') or (tempstr='.unidata') then
    begin
     unild_init_raise_error('Section Name cannot be '+Script.CustomSignSectionName+' due to Section Name '+
     Script.Section[i-1].SectionName+' is a implicit section in linking.',
     'Please examine the linker script for more information.',Script.LinkerWait);
    end;
  end;
 for i:=1 to Script.SectionCount do
  begin
   tempstr:=Script.Section[i-1].SectionName;
   if(tempstr='.hash')or(tempstr='.gnu.hash')or(tempstr='.dynamic')
   or(tempstr='.dynsym')or(tempstr='.dynstr')or(tempstr='.got')or(tempstr='.got.plt')
   or(Copy(tempstr,1,5)='.rela')or(Copy(tempstr,1,5)='.relr')
   or(Copy(tempstr,1,4)='.rel')or(tempstr='.version') or (tempstr='.unidata') then
    begin
     unild_init_raise_error('Section Name cannot be '+tempstr+' due to Section Name '+
     tempstr+' is a implicit section in linking.',
     'Please examine the linker script for more information.',Script.LinkerWait);
    end;
  end;
 if(InputArchitecture<>0) then Script.InputArchitecture:=InputArchitecture;
 if(InputBits<>0) then Script.InputBits:=InputBits;
 if(OutputArchitecture<>0) then Script.OutputArchitecture:=OutputArchitecture;
 if(OutputBits<>0) then Script.OutputBits:=InputArchitecture;
 if(Script.Interpreter<>'') and (Script.IsEFIFile=false) and (Script.IsUntypedBinary=false) then
  begin
   if(Script.elfclass=unild_class_relocatable) then Script.Interpreter:='';
   Script.NoFixedAddress:=true;
  end;
 if(Script.OutputFileName='') then Script.OutputFileName:=OutputFileName;
 if(LinkerScript<>'') then Script:=unild_script_read(LinkerScript)
 else if(Script.IsEFIFile) or (Script.IsUntypedBinary) then
 Script:=unild_generate_default_other_file
 else Script:=unild_generate_default_elf_file;
 writeln(Script.EntryName);
 if(Script.BaseAddress<>0) and (Script.IsEFIFile=false) and (Script.IsUntypedBinary=false) then
  begin
   Script.NoFixedAddress:=false; Script.Interpreter:='';
  end;
 if(unild_check_path(Script.OutputFileName)=false) then
  begin
   unild_init_raise_error('Output File Name '+Script.OutputFileName+' is not vaild due to path invaild.',
   'Please check the output path for more information.',Script.LinkerWait);
  end;
 if(Script.IsEFIFile) and (Script.EFIFileIndex=0) then
  begin
   unild_init_raise_error('EFI File Format Type does not specified,must be specified to EFI(UEFI) Format.',
   'Please check the parameters passed and linker script for more information.',Script.LinkerWait);
  end;
 if(Script.IsEFIFile=false) and (Script.IsUntypedBinary=false) and (Script.elfclass=0) then
  begin
   unild_init_raise_error('ELF File Format Type does not specified,must be specified to ELF Format.',
   'Please check the parameters passed and linker script for more information.',Script.LinkerWait);
  end;
 if(Script.IsUntypedBinary) then Script.EntryAsStartOfSection:=true;
 if(Script.DynamicPathWithSubDirectoryCount>0) then
  begin
   for i:=1 to Script.DynamicPathWithSubDirectoryCount do
    begin
     FileList:=unild_search_for_directorylist(Script.DynamicPathWithSubDirectoryList[i-1],true);
     for j:=1 to FileList.Count do
      begin
       inc(Script.DynamicLibraryPathCount);
       SetLength(Script.DynamicLibraryPath,Script.DynamicLibraryPathCount);
       Script.DynamicLibraryPath[Script.DynamicLibraryPathCount-1]:=FileList.FilePath[j-1];
      end;
    end;
   SetLength(Script.DynamicPathWithSubDirectoryList,0);
   Script.DynamicPathWithSubDirectoryCount:=0;
  end;
 for i:=1 to Script.DynamicLibraryCount do
  begin
   for j:=i+1 to Script.DynamicLibraryCount do
    begin
     if(Script.DynamicLibrary[i-1]=Script.DynamicLibrary[j-1]) then
      begin
       unild_init_raise_error('Dynamic Library Name '+Script.DynamicLibrary[i-1]+' repeated.',
       'Please check the passed parameters and linker script for more needed information.',
       Script.LinkerWait);
      end;
    end;
  end;
 for i:=1 to Script.DynamicLibraryPathCount do
  begin
   for j:=i+1 to Script.DynamicLibraryPathCount do
    begin
     if(Script.DynamicLibraryPath[i-1]=Script.DynamicLibraryPath[j-1]) then
      begin
       unild_init_raise_error('Dynamic Library Search Path '+Script.DynamicLibraryPath[i-1]+' repeated.',
       'Please check the passed parameters and linker script for more needed information.',
       Script.LinkerWait);
      end;
    end;
  end;
 for i:=1 to Script.DynamicLibraryCount do
  begin
   TempHaveLibrary:=false; j:=1;
   for j:=1 to Script.DynamicLibraryPathCount do
    begin
     if(FileExists(Script.DynamicLibraryPath[j-1]+'/'+Script.DynamicLibrary[i-1])) then
      begin
       TempHaveLibrary:=true; break;
      end;
    end;
   if(TempHaveLibrary=false) then
    begin
     unild_init_raise_error('The specified library '+Script.DynamicLibrary[i-1]+' does not exist in the '+
     'specified search path or search paths.',
     'Please check the passed parameters and linker script for more needed information.',
     Script.LinkerWait);
    end
   else
    begin
     inc(Script.DynamicLibraryActualPathCount);
     SetLength(Script.DynamicLibraryActualPath,Script.DynamicLibraryActualPathCount);
     Script.DynamicLibraryActualPath[Script.DynamicLibraryActualPathCount-1]:=
     Script.DynamicLibraryPath[j-1]+'/'+Script.DynamicLibrary[i-1];
    end;
  end;
 if(Script.NoFixedAddress=false) then
  begin
   if(Script.IsEFIFile=false) and (Script.IsUntypedBinary=false) then
    begin
     if(Script.elfclass<>unild_class_executable) then
      begin
       unild_init_raise_error('Only ELF Executable can be fixed-addressable,other format is not supported.',
       'Please check the passed parameters and linker script for more needed information.',
       Script.LinkerWait);
      end;
    end;
  end;
 if(Script.IsEFIFile=false) and (Script.IsUntypedBinary=false) and
 (Script.elfclass<>unild_class_executable) then Script.Interpreter:='';
 {Then Input the File}
 unifile_filelist_initialize;
 unifile_total_file_initialize(InputFileList);
 if(Verbose) then writeln('Reading the input files......');
 for i:=1 to Script.InputFileCount do
  begin
   for j:=i+1 to Script.InputFileCount do
    begin
     if(Script.InputFile[i-1]=Script.InputFile[j-1]) then
      begin
       unild_init_raise_error('File Name '+Script.InputFile[i-1]+' repeated,must not to be repeated as same file'+
       ' will cause linking error.',
       'Please check the input file name for more relevant information.',Script.LinkerWait);
      end;
    end;
   tempstr:=LowerCase(ExtractFileExt(Script.InputFile[i-1]));
   if(tempstr='.o')or (tempstr='.obj') then
    begin
     unifile_total_add_file(InputFileList,unifile_read_elf_file(Script.InputFile[i-1]));
    end
   else if(tempstr='.a')or (tempstr='.lib') or (tempstr='.lib') then
    begin
     unifile_total_add_archive_file(InputFileList,unifile_read_archive_file(Script.InputFile[i-1]));
    end;
  end;
 for i:=1 to Script.InputFilePathCount do
  begin
   for j:=i+1 to Script.InputFilePathCount do
    begin
     if(Script.InputFilePath[i-1]=Script.InputFilePath[j-1]) then
      begin
       unild_init_raise_error('File Name '+Script.InputFile[i-1]+' repeated,must not to be repeated as same file'+
       ' path will cause linking error.',
       'Please check the input file names for more relevant information.',Script.LinkerWait);
       writeln('ERROR:File Path '+Script.InputFilePath[i-1]+' repeated.');
       readln;
       halt;
      end;
    end;
  end;
 for i:=1 to Script.InputFilePathCount do
  begin
   FileList:=unild_search_for_filelist(Script.InputFilePath[i-1],
   '*.o',Script.InputFileHaveSubPath[i-1]);
   for j:=1 to FileList.Count do
    begin
     unifile_total_add_file(InputFileList,unifile_read_elf_file(FileList.FilePath[j-1]));
    end;
   FileList:=unild_search_for_filelist(Script.InputFilePath[i-1],
   '*.obj',Script.InputFileHaveSubPath[i-1]);
   for j:=1 to FileList.Count do
    begin
     unifile_total_add_file(InputFileList,unifile_read_elf_file(FileList.FilePath[j-1]));
    end;
   FileList:=unild_search_for_filelist(Script.InputFilePath[i-1],
   '*.a',Script.InputFileHaveSubPath[i-1]);
   for j:=1 to FileList.Count do
    begin
     unifile_total_add_archive_file(InputFileList,unifile_read_archive_file(FileList.FilePath[j-1]));
    end;
   FileList:=unild_search_for_filelist(Script.InputFilePath[i-1],
   '*.lib',Script.InputFileHaveSubPath[i-1]);
   for j:=1 to FileList.Count do
    begin
     unifile_total_add_archive_file(InputFileList,unifile_read_archive_file(FileList.FilePath[j-1]));
    end;
   FileList:=unild_search_for_filelist(Script.InputFilePath[i-1],
   '*.ar',Script.InputFileHaveSubPath[i-1]);
   for j:=1 to FileList.Count do
    begin
     unifile_total_add_archive_file(InputFileList,unifile_read_archive_file(FileList.FilePath[j-1]));
    end;
  end;
 if(Script.EntryName='') and (not ((Script.elfclass<=1) and (Script.IsEFIFile=false)
 and (Script.IsUntypedBinary=false))) then
  begin
   unild_init_raise_error('No Entry Name Input when the file is not ELF-format Relocatable File.',
   'Please examine the entry point command and linker script for settling this error.',Script.LinkerWait);
  end
 else if(Script.elfclass<=1) and (Script.IsEFIFile=false) and (Script.IsUntypedBinary=false) then
  begin
   Script.EntryName:='';
  end;
 if(InputFileList.ObjectCount=0) then
  begin
   unild_init_raise_error('No Object File input,must have at least one object to input.',
   'Please examine the entry point command and linker script for settling this error.',Script.LinkerWait);
  end;
 if(OutputFileName='') then
  begin
   unild_init_raise_error('No Object File input,must have at least one object to input.',
   'Please examine the entry point command and linker script for settling this error.',Script.LinkerWait);
   writeln('ERROR:No Output File Name Specified.');
   readln;
   halt;
  end;
 if(Script.elfclass=0) and (Script.IsUntypedBinary=false) and (Script.IsEFIFile=false) then
  begin
   unild_init_raise_error('ELF File Type not Specified,Must specify a type for this type for creating.',
   'Please examine the entry point command and linker script for settling this error.',Script.LinkerWait);
  end;
 if(Script.EFIFileIndex=0) and (Script.IsUntypedBinary=false) and (Script.IsEFIFile) then
  begin
   unild_init_raise_error('EFI File Type not Specified,Must specify a type for this type for producing.',
   'Please examine the entry point command and linker script for settling this error.',Script.LinkerWait);
  end;
 if(Script.Bits<>0) and (unifile_total_check_bits(InputFileList,Script.Bits)=false) then
  begin
   unild_init_raise_error('The input file bits does not match the specified bits,must be same for linking.',
   'Please examine the entry point command and linker script for settling this error.',Script.LinkerWait);
  end;
 if(Script.InputArchitecture<>0) and ((Script.Bits<>0) or (Script.InputBits<>0)) and
 (unifile_total_check(InputFileList,Script.InputArchitecture,Script.InputBits)=false) then
  begin
   unild_init_raise_error('The input file architecture does not match the specified architecture,'
   +'must be same for linking.',
   'Please examine the entry point command and linker script for settling this error.',Script.LinkerWait);
  end;
 if(Script.NoFixedAddress) and (unifile_total_check_relocatable(InputFileList)=false) then
  begin
   unild_init_raise_error('The Input Files should be relocatable while some files in the input are not.'+
   'A Dynamic-Addressing Output File demands all of input files are relocatable.',
   'Please examine the entry point command and linker script for settling this error.',Script.LinkerWait);
  end;
 if(Verbose) then writeln('Parsing the input files......');
 ParseFileList:=unifile_parse(InputFileList);
 if(Verbose) then writeln('Reprasing the input files......');
 LinkFileList:=unifile_parsed_to_first_stage(ParseFileList,Script,Script.SmartLinking);
 if(Verbose) then writeln('Linking the input files......');
 if(Script.IsUntypedBinary) then
 unifile_convert_file_to_final(LinkFileList,Script,Script.OutputFileName,unifile_class_binary_file)
 else if(Script.IsEFIFile) then
 unifile_convert_file_to_final(LinkFileList,Script,Script.OutputFileName,unifile_class_pe_file)
 else
 unifile_convert_file_to_final(LinkFileList,Script,Script.OutputFileName,unifile_class_elf_file);
 if(Verbose) then
  begin
   writeln('Output File '+OutputFileName+' have generated!');
   writeln('Done!');
  end;
 unifile_total_free(InputFileList);
end;
begin
 unild_parse_param;
end.
