$!> BUILD_SDCL.COM -- Make SDCL; assumes LEXTAB.H and CODES.H already exist.
$! p1 = GCC if supposed to use GNU C Compiler
$! p2 = options for compile
$! p3 = options for link
$! p4 = if not null, link only
$
$ 	if p1 .eqs. "GCC" then cc = "gcc"	!use the GNU C Compiler
$	if p4 .nes. "" then goto link_only
$
$ 	cc /debug 'p2 sdcl.c 		
$ 	cc /debug 'p2 getopt.c
$ 	cc /debug 'p2 lex.c
$ 	cc /debug 'p2 output.c
$ 	cc /debug 'p2 parser.c
$ 	cc /debug 'p2 stack.c
$ 	cc /debug 'p2 version.c
$ 	cc /debug 'p2 ioinit.c
$
$ link_only:
$ 	if p1 .eqs. "GCC" 
$	then 
$! 	Link with the GNU C library
$
$ 	    link /exe=sdcl.exe  'p3 sys$input:/opt
sdcl.obj, getopt.obj, lex.obj, output.obj, -
parser.obj, stack.obj, version.obj, ioinit.obj, -
gnu_cc:[000000]gcclib.olb/lib,-
sys$share:vaxcrtl.exe/share
$
$	else
$! 	Link with only VMS C library
$
$ 	    link /exe=sdcl.exe 'p3 sys$input:/opt
sdcl.obj, getopt.obj, lex.obj, output.obj, -
parser.obj, stack.obj, version.obj, ioinit.obj, -
sys$share:vaxcrtl.exe/share
$
$	endif

