	#! /bin/bash
	#Parameter ARCH means output Architecture,and Parameter CROSSARCH means cross-compile the unild software to the target architecture which bash build.sh needs for executing and compiling.If you demand have custom binutils to compile,you ought to specified the custom binutils after cross-compile architecture parameter(due to usage of the custom binutils should be used in the cross-compile level). Source Path is the path to Free Pascal Compiler Source Code with including the object files compiled and compiled compilers.
	ARCH=$(uname -m)
	USERNAME=$(whoami)
	SOURCEPATH=/home/$USERNAME/source
	CROSSARCH=$1
	CUSTOMBIN=$2
	if [ "$ARCH" = "x86_64" ]; then
	 CARCH="x64"
	 CARCHNAME="x86_64"
	 CARCHNAMEL="X86_64"
	 BITS="64"
	 CISONAME="x64"
	 CISONAMEL="X64"
	elif [ "$ARCH" = "aarch64" ]; then
	 CARCH="a64"
	 CARCHNAME="aarch64"
	 CARCHNAMEL="AARCH64"
	 BITS="64"
	 CISONAME="aa64"
	 CISONAMEL="AA64"
	elif [ "$ARCH" = "riscv64" ]; then
	 CARCH="rv64"
	 CARCHNAME="riscv64"
	 CARCHNAMEL="RISCV64"
	 BITS="64"
	 CISONAME="riscv64"
	 CISONAMEL="RISCV64"
	elif [ "$ARCH" = "loongarch64" ]; then
	 CARCH="loongarch64"
	 CARCHNAME="loongarch64"
	 CARCHNAMEL="LOONGARCH"
	 BITS="64"
	 CISONAME="loongarch64"
	 CISONAMEL="LOONGARCH64"
	elif [ "$ARCH" = "i386" ]; then
	 CARCH="386"
	 CARCHNAME="i386"
	 CARCHNAMEL="I386"
	 BITS="32"
	 CISONAME="ia32"
	 CISONAMEL="IA32"
	elif [ "$ARCH" = "arm" ]; then
	 CARCH="arm"
	 CARCHNAME="arm"
	 CARCHNAMEL="ARM"
	 BITS="32"
	 CISONAME="arm"
	 CISONAMEL="ARM"
	else
	 echo "Unsupported architecture "$ARCH
	 exit
	fi
	if [ "$CROSSARCH" = "x86_64" ]; then
	 CCARCH="x64"
	 CCARCHNAME="x86_64"
	 CCARCHNAMEL="X86_64"
	 CCFILEARCHNAME="x86-64"
	 BUNAME="-XPx86_64-linux-gnu-"
	 OCNAME="x86_64-linux-gnu-"
	 BITS="64"
	 CCISONAME="x64"
	 CCISONAMEL="X64"
	elif [ "$CROSSARCH" = "aarch64" ]; then
	 CCARCH="a64"
	 CCARCHNAME="aarch64"
	 CCARCHNAMEL="AARCH64"
	 CCFILEARCHNAME="aarch64"
	 BUNAME="-XPaarch64-linux-gnu-"
	 OCNAME="aarch64-linux-gnu-"
	 BITS="64"
	 CCISONAME="aa64"
	 CCISONAMEL="AA64"
	elif [ "$CROSSARCH" = "riscv64" ]; then
	 CCARCH="rv64"
	 CCARCHNAME="riscv64"
	 CCARCHNAMEL="RISCV64"
	 CCFILEARCHNAME="riscv64"
	 BUNAME="-XPriscv64-linux-gnu-"
	 OCNAME="riscv64-linux-gnu-"
	 BITS="64"
	 CCISONAME="riscv64"
	 CCISONAMEL="RISCV64"
	elif [ "$CROSSARCH" = "loongarch64" ]; then
	 CCARCH="loongarch64"
	 CCARCHNAME="loongarch64"
	 CCARCHNAMEL="LOONGARCH"
	 CCFILEARCHNAME="loongarch64"
	 BUNAME="-XPloongarch64-linux-gnu-"
	 OCNAME="loongarch64-linux-gnu-"
	 BITS="64"
	 CCISONAME="loongarch64"
	 CCISONAMEL="LOONGARCH64" 
	elif [ "$CROSSARCH" = "i386" ]; then
	 CCARCH="386"
	 CCARCHNAME="i386"
	 CCARCHNAMEL="I386"
	 CCFILEARCHNAME="i386"
	 BUNAME="-XPi386-linux-gnu-"
	 OCNAME="i386-linux-gnu-"
	 BITS="32"
	 CCISONAME="ia32"
	 CCISONAMEL="IA32"
	elif [ "$CROSSARCH" = "arm" ]; then
	 CCARCH="arm"
	 CCARCHNAME="arm"
	 CCARCHNAMEL="ARM"
	 CCFILEARCHNAME="arm"
	 BUNAME="-XParm-linux-gnu-"
	 OCNAME="arm-linux-gnu-"
	 BITS="32"
	 CCISONAME="arm"
	 CCISONAMEL="ARM"
	else
	 CCARCH=$CARCH
	 CCARCHNAME=$CARCHNAME
	 CCARCHNAMEL=$CARCHNAMEL
	 if [ "$CCARCH" == "x86_64" ]; then
	 CCFILEARCHNAME="x86-64"
	 else
	 CCFILEARCHNAME=$CCARCHNAME
	 fi
	 BUNAME=""
	 OCNAME=""
	 CCISONAME=$CISONAME
	 CCISONAMEL=$CISONAMEL
	fi
	if [ "$CUSTOMBIN" != "" ]; then
	 BUNAME="-XP"$CUSTOMBIN
	fi
	if [ "$CROSSARCH" == "" ]; then
	$SOURCEPATH/compiler/ppc$CCARCH -Mobjfpc -n -O3 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Fu$SOURCEPATH/compiler/$CCARCHNAME/units/$CCARCHNAME-linux -Fu$SOURCEPATH/rtl/units/$CCARCHNAME-linux -Fu/home/tydq/source/packages/rtl-objpas/units/$CCARCHNAME-linux -dcpu$BITS -ounild -Cg unild.pas
	elif [ "$CCARCH" == "$CARCH" ]; then
	$SOURCEPATH/compiler/ppc$CCARCH -Mobjfpc -n -O3 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Fu$SOURCEPATH/compiler/$CCARCHNAME/units/$CCARCHNAME-linux -Fu$SOURCEPATH/rtl/units/$CCARCHNAME-linux -Fu$SOURCEPATH/packages/rtl-objpas/units/$CCARCHNAME-linux -dcpu$BITS -ounild-$CCFILEARCHNAME -Cg unild.pas
	else
	$SOURCEPATH/compiler/ppcross$CCARCH -Mobjfpc $BUNAME -n -O3 -Si -Sc -Sg -Xd -Ur -CX -XXs -Xi -Fu$SOURCEPATH/compiler/$CCARCHNAME/units/$CCARCHNAME-linux -Fu$SOURCEPATH/rtl/units/$CCARCHNAME-linux -Fu$SOURCEPATH/packages/rtl-objpas/units/$CCARCHNAME-linux -dcpu$BITS -ounild-$CCFILEARCHNAME -Cg unild.pas
	fi
	rm *.ppu 
	rm *.o
	if [ "$CROSSARCH" == "" ]; then
	./unild --help
	elif [ "$CCARCH" == "$CARCH" ]; then
	./unild-$CCFILEARCHNAME --help
	fi
