# unild
Universal Linker Editor(Universal Linker eDitor)
## Requirements of the unild to execute
Windows or Linux Operating System
## Requirements of compling unild 
FPC(Free Pascal Compiler)  
Please run build.sh in the source code to quickly compile the source code to executable file.   
Default Compiler Path is in Linux(/home/(your user name)/source/compiler),you can edit the build.sh to change the default compiler path.  
If you want to cross compile the unild software,you should bash build.sh (Architecture) to cross compile the linker.  
(Changing the optimization shell command will cause errors,if you ought to alter optimization,you should to take a test).  
## Details about using unild
All input object file must be ELF-Format Files.  
Example Linker Script is linkerscript.txt(Not a entire one,please look up unildscript.pas for more details).  
Execute command ./unild after you compile the unild source code or directly input ./unild in the binary.
