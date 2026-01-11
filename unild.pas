program unild;

uses Sysutils,Classes,unifile,unildscript,unihash,binbase;

type unild_filelist=packed record
                    FilePath:array of string;
                    Count:SizeUInt;
                    end;

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
procedure unild_help;
begin
 writeln('unild(universal linker editor) version 0.0.1');
 writeln('Commands:unild [parameters] '+
 '(linking commands are not case-sensitive,while file name and path not)');
 writeln('Tips:Implicit section will not be auto-generated in the file,'
 +'cannot be linked in specified section.');
 writeln('Available Commands:');
 writeln('--verbose,--cui');
 writeln('  Enable the linking hint of the unild.');
 writeln('--untypedbinary,--binary');
 writeln('  Set the output format type to untyped binary(pure binary).');
 writeln('--version');
 writeln('  Show the version of the unild.');
 writeln('--smartlinking,--smart,--smartlink');
 writeln('  Enable the smart linking of the unild(disable the linking all option).');
 writeln('--linkallsection,--linkallsect,--nosmartlinking,--linkall,--nosmart,--nosmartlinking');
 writeln('  Disable the smart linking of the unild(enable the linking all option).');
 writeln('--no-symbol,--discard-symbol,--strip-symbol,--delete-symbol');
 writeln('  Erase the static symbol of the output file(disable the keeping symbol option).');
 writeln('--symbolic,--keep-symbol,--maintain-symbol');
 writeln('  Maintain the static symbol of the output file(disable the deleting symbol option).');
 writeln('--no-executable-stack,--no-executablestack,--no-exec-stack,--no-execstack');
 writeln('  Check the executable stack(ELF Files Only)');
 writeln('--no-writable-got,--no-writablegot,--no-writable,--nowritable,--no-write,--nowrite');
 writeln('  Disable the Writable Got(Global Offset Table) section(ELF Files Only).');
 writeln('--interpreter');
 writeln('  Specify the path of the interpreter(ELF dynamic library and ELF executable only).');
 writeln('--output-file-name,--output-filename,--outputfilename');
 writeln('  Specify output file name(Cannot lack,otherwise a error will thrown).');
 writeln('--input-file,--inputfile');
 writeln('  Specify the input file name(Single File).');
 writeln('--input-file-path,--input-filepath,--inputfilepath');
 writeln('  Specify the path contains input file(without subdirectory).');
 writeln('--input-file-path-with-subdir,--input-filepath-with-subdir,--inputfilepath-with-subdir,'+
 '--input-file-path-withsubdir,--input-filepath-withsubdir,--inputfilepath-withsubdir');
 writeln('  Specify the path contains input file(with subdirectory).');
 writeln('--dynamic-library,--dynamiclibrary,--shared-library,--sharedlibrary');
 writeln('  Specify the dynamic library name needed in output file.');
 writeln('--dynamic-library-search-path,--dynamiclibrary-search-path,--dynamiclibrary-searchpath,'+
 '--dynamiclibrarysearchpath,--shared-library-search-path,--sharedlibrary-search-path'+
 '--sharedlibrary-searchpath,--sharedlibrarysearchpath');
 writeln('  Specify the dynamic library search path for dynamic library(Only available when '+
 'dynamic library specified).');
 writeln('--baseaddress,--startaddress,--base-address,--start-address');
 writeln('  Specify the base address of the output file.');
 writeln('--filealign,--file-align');
 writeln('  Specify the file align of the output file(EFI File Only)');
 writeln('--nodeflib,--nodefaultlib,--no-deflib,--no-defaultlib,--nodeflibrary,'+
 '--nodefaultlibrary,--no-deflibrary,--no-defaultlibrary');
 writeln('  Disable the Default Library of the file.');
 writeln('--noextlib,--noexternallib,--no-extlib,--no-extlib,--noextlibrary,'+
 '--noexternallibrary,--no-extlibrary,--no-externallibrary');
 writeln('  Disable the External Library of the file(ELF is optional while EFI is forced).');
 writeln('--bits,--file-bits,--filebits');
 writeln('  Specify the bits of the output file');
 writeln('--untypedbinaryalign,--untyped-binaryalign,--untyped-binary-align');
 writeln('  Specify the align of the untyped binary.');
 writeln('--relocatable');
 writeln('  Specify the relocatable type of ELF file(ELF Only)');
 writeln('--sharedobject,--sharedlink');
 writeln('  Specify the shared object(dynamic library) type of ELF file(ELF Only)');
 writeln('--executable');
 writeln('  Specify the executable type of ELF file(ELF Only)');
 writeln('--fixed-address,--fixedaddress,--fixed-addr,--fixedaddr');
 writeln('  Specify the fixed address option.');
 writeln('--pie,--positionindependentexecutable,--position-independent-executable');
 writeln('  Specify the PIE executable(Default in executable ELF file).');
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
 writeln('--input-format,--inputformat');
 writeln('  Specify the input format of the file.');
 writeln('  Vaild Options:i386/ia32,x86_64/x86/amd64,arm/arm32/aarch32,riscv32/rv32,riscv64/rv64,'+
 'la32/la64');
 writeln('--output-format,--outputformat');
 writeln('  Specify the output format of the file.');
 writeln('  Vaild Options:i386/ia32,x86_64/x86/amd64,arm/arm32/aarch32,riscv32/rv32,riscv64/rv64,'+
 'la32/la64');
 writeln('--entry,--entryname,--entry-name');
 writeln('  Specify the entry name of the output file.');
 writeln('--script-path,--scriptpath,--linker-script-path,--linker-scriptpath,--linkerscriptpath'+
 ',--linker-script,--linkerscript');
 writeln('  Specify the Linker Script Path.');
 writeln('--gnu-linux,--gnulinux,--gnu,--linux');
 writeln('  Specify the ELF File Operating System to Linux(ELF File Only).');
 writeln('--help');
 writeln('  Show the help of the unild.');
end;
procedure unild_parse_param;
var InputFileList:unifile_elf_object_file_total;
    ParseFileList:unifile_elf_object_file_parsed;
    LinkFileList:unifile_linked_file_stage;
    FileList:unild_filelist;
    {For Scanning}
    i,j:SizeUint;
    tempstr:string;
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
   if(LowerCase(ParamStr(i))='--verbose') or (LowerCase(ParamStr(i))='--cui') then
    begin
     Verbose:=true;
    end
   else if(LowerCase(ParamStr(i))='--untypedbinary') or (LowerCase(ParamStr(i))='--binary') then
    begin
     Script.IsUntypedBinary:=true;
    end
   else if(LowerCase(ParamStr(i))='--version') then
    begin
     writeln('unild(universal linker editor) version 0.0.1');
     readln;
     halt;
    end
   else if(LowerCase(ParamStr(i))='--smartlinking') or (LowerCase(ParamStr(i))='--smart')
   or(LowerCase(ParamStr(i))='--smartlink') then
    begin
     Script.SmartLinking:=true; Script.LinkAll:=false;
    end
   else if(LowerCase(ParamStr(i))='--linkallsection') or (LowerCase(ParamStr(i))='--linkallsect')
   or(LowerCase(ParamStr(i))='--nosmartlinking') or(LowerCase(ParamStr(i))='--linkall')
   or(LowerCase(ParamStr(i))='--nosmart') or (LowerCase(ParamStr(i))='--nosmartlink') then
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
   else if(LowerCase(ParamStr(i))='--no-writable-got') or
   (LowerCase(ParamStr(i))='--no-writablegot') or
   (LowerCase(ParamStr(i))='--no-writable') or (LowerCase(ParamStr(i))='--nowritable') or
   (LowerCase(ParamStr(i))='--no-write') or (LowerCase(ParamStr(i))='--nowrite') then
    begin
     Script.NoGotWritable:=true;
    end
   else if(LowerCase(ParamStr(i))='--interpreter') then
    begin
     Script.Interpreter:=ParamStr(i+1);
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--output-file-name')
   or(LowerCase(ParamStr(i))='--output-filename')
   or(LowerCase(ParamStr(i))='--outputfilename') then
    begin
     OutputFileName:=ParamStr(i+1);
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--input-file') or (LowerCase(ParamStr(i))='--inputfile') then
    begin
     inc(Script.InputFileCount);
     SetLength(Script.InputFile,Script.InputFileCount);
     Script.InputFile[Script.InputFileCount-1]:=ParamStr(i+1);
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--input-file-path') or (LowerCase(ParamStr(i))='--input-filepath')
   or(LowerCase(ParamStr(i))='--inputfilepath') then
    begin
     inc(Script.InputFilePathCount);
     SetLength(Script.InputFilePath,Script.InputFilePathCount);
     SetLength(Script.InputFileHaveSubPath,Script.InputFilePathCount);
     Script.InputFilePath[Script.InputFilePathCount-1]:=ParamStr(i+1);
     Script.InputFileHaveSubPath[Script.InputFilePathCount-1]:=false;
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--input-file-path-with-subdir')
   or(LowerCase(ParamStr(i))='--input-filepath-with-subdir')
   or(LowerCase(ParamStr(i))='--inputfilepath-with-subdir')
   or(LowerCase(ParamStr(i))='--input-file-path-withsubdir')
   or(LowerCase(ParamStr(i))='--input-filepath-withsubdir')
   or(LowerCase(ParamStr(i))='--inputfilepath-withsubdir') then
    begin
     inc(Script.InputFilePathCount);
     SetLength(Script.InputFilePath,Script.InputFilePathCount);
     SetLength(Script.InputFileHaveSubPath,Script.InputFilePathCount);
     Script.InputFilePath[Script.InputFilePathCount-1]:=ParamStr(i+1);
     Script.InputFileHaveSubPath[Script.InputFilePathCount-1]:=true;
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--dynamic-library') or
   (LowerCase(ParamStr(i))='--dynamiclibrary') or
   (LowerCase(ParamStr(i))='--shared-library') or
   (LowerCase(ParamStr(i))='--sharedlibrary') then
    begin
     inc(Script.DynamicCount);
     SetLength(Script.DynamicLibrary,Script.DynamicCount);
     Script.DynamicLibrary[Script.DynamicCount-1]:=ParamStr(i+1);
     inc(i);
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
     inc(Script.DynamicPathCount);
     SetLength(Script.DynamicLibraryPath,Script.DynamicPathCount);
     Script.DynamicLibraryPath[Script.DynamicPathCount-1]:=ParamStr(i+1);
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--baseaddress') or (LowerCase(ParamStr(i))='--startaddress')
   or(LowerCase(ParamStr(i))='--base-address') or (LowerCase(ParamStr(i))='--start-address') then
    begin
     Script.BaseAddress:=unild_str_to_int(ParamStr(i+1));
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--filealign') or (LowerCase(ParamStr(i))='--file-align') then
    begin
     Script.FileAlign:=unild_str_to_int(ParamStr(i+1));
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--untypedbinaryalign') or
   (LowerCase(ParamStr(i))='--untyped-binaryalign') or
   (LowerCase(ParamStr(i))='--untyped-binary-align') then
    begin
     Script.IsUntypedBinary:=true;
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
     Script.Bits:=unild_str_to_int(ParamStr(i+1));
     if(Script.Bits<>32) and (Script.Bits<>64) then
      begin
       writeln('ERROR:Bits must be 32/64');
       readln;
       halt;
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
   else if(LowerCase(ParamStr(i))='--fixed-address') or (LowerCase(ParamStr(i))='--fixedaddress')
   or(LowerCase(ParamStr(i))='--fixed-addr') or (LowerCase(ParamStr(i))='--fixedaddr') then
    begin
     Script.NoFixedAddress:=false;
    end
   else if(LowerCase(ParamStr(i))='--pie') or
   (LowerCase(ParamStr(i))='--positionindependentexecutable') or
   (LowerCase(ParamStr(i))='--position-independent-executable') then
    begin
     Script.elfclass:=unild_class_executable; Script.NoFixedAddress:=true;
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
   else if(LowerCase(ParamStr(i))='--input-format')
   or(LowerCase(ParamStr(i))='--inputformat') then
    begin
     Script.InputFormat:=LowerCase(ParamStr(i+1));
     if(Script.OutputFormat='i386') or (Script.OutputFormat='ia32') then
      begin
       InputArchitecture:=elf_machine_386; InputBits:=32;
      end
     else if(Script.OutputFormat='x86_64') or (Script.OutputFormat='x86')
     or (Script.OutputFormat='amd64') then
      begin
       InputArchitecture:=elf_machine_x86_64; InputBits:=64;
      end
     else if(Script.OutputFormat='arm') or (Script.OutputFormat='arm32') or
     (Script.OutputFormat='aarch32') then
      begin
       InputArchitecture:=elf_machine_arm; InputBits:=32;
      end
     else if(Script.OutputFormat='arm64') or (Script.OutputFormat='aarch64') then
      begin
       InputArchitecture:=elf_machine_aarch64; InputBits:=64;
      end
     else if(Script.OutputFormat='riscv32') or (Script.OutputFormat='rv32') then
      begin
       InputArchitecture:=elf_machine_riscv; InputBits:=32;
      end
     else if(Script.OutputFormat='riscv64') or (Script.OutputFormat='rv64') then
      begin
       InputArchitecture:=elf_machine_riscv; InputBits:=64;
      end
     else if(Script.OutputFormat='loongarch32') or (Script.OutputFormat='la32') then
      begin
       InputArchitecture:=elf_machine_loongarch; InputBits:=32;
      end
     else if(Script.OutputFormat='loongarch64') or (Script.OutputFormat='la64') then
      begin
       InputArchitecture:=elf_machine_loongarch; InputBits:=64;
      end
     else
      begin
       writeln('ERROR:Unsupported Architecture '+Script.InputFormat);
       readln;
       halt;
      end;
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--gnu-linux')
   or(LowerCase(ParamStr(i))='--gnu')or(LowerCase(ParamStr(i))='--gnulinux')
   or(LowerCase(ParamStr(i))='--linux') then
    begin
     Script.SystemIndex:=1;
    end
   else if(LowerCase(ParamStr(i))='--output-format')
   or(LowerCase(ParamStr(i))='--outputformat') then
    begin
     Script.OutputFormat:=LowerCase(ParamStr(i+1));
     if(Script.OutputFormat='i386') or (Script.OutputFormat='ia32') then
      begin
       OutputArchitecture:=elf_machine_386; OutputBits:=32;
      end
     else if(Script.OutputFormat='x86_64') or (Script.OutputFormat='x86')
     or (Script.OutputFormat='amd64') then
      begin
       OutputArchitecture:=elf_machine_x86_64; OutputBits:=64;
      end
     else if(Script.OutputFormat='arm') or (Script.OutputFormat='arm32') or
     (Script.OutputFormat='aarch32') then
      begin
       OutputArchitecture:=elf_machine_arm; OutputBits:=32;
      end
     else if(Script.OutputFormat='arm64') or (Script.OutputFormat='aarch64') then
      begin
       OutputArchitecture:=elf_machine_aarch64; OutputBits:=64;
      end
     else if(Script.OutputFormat='riscv32') or (Script.OutputFormat='rv32') then
      begin
       OutputArchitecture:=elf_machine_riscv; OutputBits:=32;
      end
     else if(Script.OutputFormat='riscv64') or (Script.OutputFormat='rv64') then
      begin
       OutputArchitecture:=elf_machine_riscv; OutputBits:=64;
      end
     else if(Script.OutputFormat='loongarch32') or (Script.OutputFormat='la32') then
      begin
       OutputArchitecture:=elf_machine_loongarch; OutputBits:=32;
      end
     else if(Script.OutputFormat='loongarch64') or (Script.OutputFormat='la64') then
      begin
       OutputArchitecture:=elf_machine_loongarch; OutputBits:=64;
      end
     else
      begin
       writeln('ERROR:Unsupported Architecture '+Script.OutputFormat);
       readln;
       halt;
      end;
     inc(i);
    end
   else if(LowerCase(ParamStr(i))='--entry')or(LowerCase(ParamStr(i))='--entryname')
   or(LowerCase(ParamStr(i))='--entry-name') then
    begin
     Script.EntryName:=LowerCase(ParamStr(i+1)); inc(i);
    end
   else if(LowerCase(ParamStr(i))='--script-path') or
   (LowerCase(ParamStr(i))='--scriptpath') or
   (LowerCase(ParamStr(i))='--linker-script-path') or
   (LowerCase(ParamStr(i))='--linker-scriptpath') or
   (LowerCase(ParamStr(i))='--linkerscriptpath') or
   (LowerCase(ParamStr(i))='--linker-script') or
   (LowerCase(ParamStr(i))='--linkerscript') then
    begin
     LinkerScript:=ParamStr(i+1); inc(i);
    end
   else if(LowerCase(ParamStr(i))='--help') then
    begin
     unild_help;
     readln;
     halt;
    end
   else
    begin
     writeln('ERROR:Unknown Command '+ParamStr(i+1));
     writeln('Please input --help for help.');
     readln;
     halt;
    end;
   inc(i);
  end;
 if(Script.Interpreter<>'') and (Script.IsEFIFile=false) then
  begin
   if(Script.elfclass=unild_class_relocatable) then
    begin
     writeln('ERROR:File with interpreter '+Script.Interpreter+' unsupported!');
     readln;
     halt;
    end;
   Script.NoFixedAddress:=true;
  end;
 if(ParamCount=0) then
  begin
   unild_help;
   readln;
   halt;
  end;
 if(InputBits<>0) then Script.Bits:=InputBits else InputBits:=Script.Bits;
 if(LinkerScript='') then
  begin
   writeln('ERROR:Linker Script Path '+Script.InputFormat+' does not exist.');
   readln;
   halt;
  end;
 Script:=unild_script_read(LinkerScript);
 if(InputArchitecture<>OutputArchitecture) or (InputBits>OutputBits) then
  begin
   writeln('ERROR:Input Architecture '+Script.InputFormat+' and Output Architecture '+
   Script.OutputFormat+' does not correspond.');
   readln;
   halt;
  end;
 if(Script.IsUntypedBinary) then
  begin
   if(Script.UntypedBinaryAlign=0) then
    begin
     writeln('ERROR:Untyped Binary Align not specified.');
     readln;
     halt;
    end;
  end;
 if(Script.IsEFIFile) then
  begin
   if(Script.FileAlign=0) then
    begin
     writeln('ERROR:EFI File Align not specified.');
     readln;
     halt;
    end;
  end;
 if(Script.NoExternalLibrary=false) then
  begin
   if(Script.Interpreter='') then
    begin
     writeln('ERROR:Interpreter Path not specified.');
     readln;
     halt;
    end;
   if(Script.DynamicCount>0) then
    begin
     writeln('ERROR:Demanding Dynamic Library not specified.');
     readln;
     halt;
    end;
   if(Script.DynamicPathCount>0) then
    begin
     writeln('ERROR:Dynamic Library Search Path specified.');
     readln;
     halt;
    end;
  end;
 {Then Input the File}
 unifile_total_file_initialize(InputFileList);
 if(Verbose) then writeln('Reading the input files......');
 for i:=1 to Script.InputFileCount do
  begin
   tempstr:=LowerCase(ExtractFileExt(Script.InputFile[i-1]));
   if(tempstr='.o')or (tempstr='.obj') then
   unifile_total_add_file(InputFileList,unifile_read_elf_file(Script.InputFile[i-1]))
   else if(tempstr='.a')or (tempstr='.lib') or (tempstr='.lib') then
   unifile_total_add_archive_file(InputFileList,unifile_read_archive_file(Script.InputFile[i-1]));
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
 if(Script.EntryName='') then
  begin
   writeln('ERROR:No Entry Name Input.');
   readln;
   halt;
  end;
 if(InputFileList.ObjectCount=0) then
  begin
   writeln('ERROR:No Object File Input.');
   readln;
   halt;
  end;
 if(OutputFileName='') then
  begin
   writeln('ERROR:No Output File Name Specified.');
   readln;
   halt;
  end;
 if(InputArchitecture<>0) and ((Script.Bits<>0) or (InputBits<>0)) and
 (unifile_total_check(InputFileList,InputArchitecture,InputBits)=false) then
  begin
   writeln('ERROR:The input file architecture does not match the specified architecture.');
   readln;
   halt;
  end;
 unihash_initialize;
 if(Verbose) then writeln('Parsing the input files......');
 ParseFileList:=unifile_parse(InputFileList);
 if(Verbose) then writeln('Reprasing the input files......');
 LinkFileList:=unifile_parsed_to_first_stage(ParseFileList,Script,Script.SmartLinking);
 if(Verbose) then writeln('Linking the input files......');
 if(Script.IsUntypedBinary) then
 unifile_convert_file_to_final(LinkFileList,Script,OutputFileName,unifile_class_binary_file)
 else if(Script.IsEFIFile) then
 unifile_convert_file_to_final(LinkFileList,Script,OutputFileName,unifile_class_pe_file)
 else
 unifile_convert_file_to_final(LinkFileList,Script,OutputFileName,unifile_class_elf_file);
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

