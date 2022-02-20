### makefile. -- Make file for SDCL, Structured DCL preprocessor.  

### This makefile was used under VMS with GNU CC (with a unix-c-like
### compiler driver, hacked from GCC.C to run under VMS), the MAKE
### from Nelson Beebe's TeX device driver family collection from the
### DECUS TeX collection, and XLISP version 1.7.  You might be able to
### change it for use elsewhere.

### The command PNXL invokes XLISP; see SCANNER.LSP for comments on
### porting the scanner table generator programs if you want to change
### SDCL.SCN and don't have XLISP.

LISP = pnxl
CFLAGS = -g
LDFLAGS = #-vmsdebug
OBJS = getopt.o lex.o output.o parser.o sdcl.o stack.o version.o ioinit.o

.c.o:	
	$(CC) -c $(CFLAGS) $<

sdcl.exe: $(OBJS)
	cc $(CFLAGS) $(LDFLAGS) $(OBJS) -o sdcl.exe

sdcl.table: sdcl.scn
	$(LISP) do_tab.lsp

# Uncomment the following lines if you need to rebuild the lexer tables
#lextab.h: sdcl.table
#	$(LISP) do_c_tab.lsp

parser.o lex.o: lextab.h codes.h

