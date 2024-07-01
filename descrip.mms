!++++
! DESCRIP.MMS - SDCL
!----

!+++
! Set up flags for commands, depending on what macros the user defines.
!---

!++
! CFLAGS is the default list of flags for the C compile command.
! ICFLAGS is the list of flags for the C compile command that are set
!     internally by this file.
! XCFLAGS is the additional list of flags specified by the user on the 
!     mmk command line using /macro.
!
! You can add extra flags (like /LIST) to the C compile command by 
! specifying a value for XCFLAGS on the command line:
! $ mmk/macro=("XCFLAGS=/LIST")
!
! You can completely override the flags used for the C compile command by
! specifying a value for CFLAGS on the command line:
! $ mmk/macro=("CFLAGS=/LIST/NOOPT")
!--
CFLAGS    = /NOLIST/OBJECT=$(MMS$TARGET_NAME)$(OBJ)${ICFLAGS}${XCFLAGS}
LINKFLAGS = /EXEC=$(MMS$TARGET) ${ILINKFLAGS}${XLINKFLAGS}

!++
! You can compile with debugging enable doing
!     $ mmk clean
!     $ mmk/macro=(dbg)
!--
.IFDEF DBG
ICFLAGS=$(ICFLAGS)/DEBUG/NOOPT
ILINKFLAGS=$(ILINKFLAGS)/DEBUG
.ENDIF

!++
! Building with a variant: 
!     $ mmk/macro=(var=1)
!
! It's useful to define a dcl command like the following if you will
! be building with variants much.
!     $ var1 :== $mmk_dir:mmk.exe/macro=(var=1)
!--
.IFDEF VAR
ICFLAGS=$(ICFLAGS)/VAR=$(VAR)
.ENDIF

!+++
! We're using GNU C.
!---
CC=GCC

OBJS = getopt.obj, lex.obj, output.obj, parser.obj, sdcl.obj, stack.obj, version.obj, ioinit.obj

sdcl.exe : $(OBJS)
            $(LINK)$(LINKFLAGS) $(MMS$SOURCE_LIST), gnu_cc:[000000]gcclib.olb/lib, sys$library:vaxcrtl.olb/lib


lex.obj, output.obj, parser.obj, sdcl.obj : sdcl.h
parser.obj, lex.obj : lextab.h, codes.h

lextab.h, codes.h : sdcl.table
	sstg_to_c sdcl.table codes.h lextab.h

sdcl.table : sdcl.scn
        sstg sdcl.scn sdcl.table

clean : 
        - delete/log *.exe;*, *.obj;*

realclean : clean
        - delete/log sdcl.table;*, codes.h;*, lextab.h;*


!+++
! Make an archival backup with today's date.
!---
zipit : 
	today = f$cvtime (,, "DATE")
        note = "$(NOTE)"
        set def [-]
	zipfile = "[.project_backups]sdcl_" + today
        if note .nes. "" then zipfile = zipfile + "_" + note
        zipfile = zipfile + ".zip"
        write sys$output "Zipfile is ", zipfile
	! It's not really accurate unless we start from scratch.
	if f$search (zipfile) .nes. "" then delete 'zipfile';*/log
	zip -r 'zipfile' sdcl.dir -x *.dsc *.key *.obj *.exe *.hlb *.lis *.map *.log
        write sys$output "Done zipiting!"

zipto : 
        set def [-]
	zipfile = "sdclwrk.zip"
	! It's not really accurate unless we start from scratch.
	if f$search (zipfile) .nes. "" then delete 'zipfile';*/log
	zip -r 'zipfile' sdcl.dir -x *.dsc *.key *.obj *.exe *.hlb *.lis *.map *.log
        write sys$output "Done ziptoing!"
