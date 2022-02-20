/* IOINITW.C -- I/O redirection subroutine.  Redirects stdin (< or <<);
 *	stdout (> or >>); or stderr ( 2>, 2>>).  Also expands wildcards.
 * Usage:
 *	main(nargs, args)
 *	{	...
 *      #ifdef VMS
 *              extern char **ioinit();
 *		args = ioinit(&nargs, args);
 *      #endif 
 *		...
 *	}
 */

#include <errno.h>
#include <stdio.h>
#include <descrip.h>		/* DSC$K_DTYPE_T, DSC$K_CLASS_S */
#include <ssdef.h>		/* SS$_INSFMEM */
#include <rmsdef.h>		/* RMS$_FNF, RMS$_NMF, RMS$_SYN */

extern char *strcpy(), *strchr(), *strrchr();
extern void *malloc(), *realloc(), free();
extern int strlen();

typedef char bool;		/* Smallest addressable signed data type. */
typedef unsigned char uchar;
typedef unsigned short ushort;
typedef unsigned int uint;
typedef unsigned long ulong;

#define odd(stat)	((stat) & 1)

/* General VMS descriptor (not as clumsy as $DESCRIPTOR from <descrip.h>): */
struct descr {
    ushort leng;		/* Length of data area (or string). */
    uchar type;			/* Type of data in area (DSC$K_DTYPE_T). */
    uchar class;		/* Class of desctiptor (DSC$K_CLASS_S). */
    char *addr;			/* Address of start of data area. */
};


/* To allocate a descriptor (dsc) for array of char (arr): */
#define   desc_arr(dsc,arr)     struct descr dsc = \
    { (sizeof arr)-1, DSC$K_DTYPE_T, DSC$K_CLASS_S, arr }

/* To allocate a descriptor (dsc) for null-terminated string (str): */
#define   desc_str(dsc,str)     struct descr dsc = \
    { strlen(str), DSC$K_DTYPE_T, DSC$K_CLASS_S, str }

#define   FNAMSIZ   256		/* size of filename buffers (+1 for '\0') */
#define   LINSIZ   4096		/* maximum length of command line */



/* sigvms -- Signals non-boring condition values, so error/warning messages */
/*           will be displayed */
static void 
sigvms(stat)
    uint stat;
{
    extern void lib$signal();
    if ((stat & 0xffff) == 1)
	return;			/* Boring status message; skip it. */
    lib$signal(stat);
}


/* strsub -- Returns the position of a substring within a string. */
/*           Should be replaced by* strstr() when DEC provides one. */
static char *
strsub(str, sub)
    char *str, *sub;
{
    register char *fp = sub;	/* Points to character we hope to Find next */
    char *sp = strchr(str, *fp);/* Points to current Starting character */
    register char *cp = sp;	/* Points to character currently Comparing */

    while (sp) {
	while (*fp && *fp == *cp)
	    ++fp, ++cp;
	if (!*fp)
	    return (sp);	/* We found it */
	fp = sub;		/* Start the search over again */
	cp = sp = strchr(sp + 1, *fp);	/* were we left off last time */
    }
    return (0);
}


/* Same as malloc() except never returns NULL. */
static void *
emalloc(siz)
    unsigned siz;
{
    register void *p = malloc(siz);
    if (!p)
	/* Don't try to recover after allocating too much: */
	sys$exit(SS$_INSFMEM);	/* Don't recover */
    return (p);
}


/* Same as realloc() except never returns NULL. */
static void *
erealloc(ptr, siz)
    void *ptr;
    unsigned siz;
{
    register void *p = realloc(ptr, siz);
    if (!p)
	/* Don't try to recover after allocating too much: */
	sys$exit(SS$_INSFMEM);	/* Don't recover */
    return (p);
}


/* iswild -- Returns 1 if `name' looks like a wild-carded file name. */
static bool
iswild(name)
    char *name;
{
    return (strchr(name, '*') || strchr(name, '%') || strsub(name, "..."));
}


/* next_wild --  Returns the next file name matching the specified wildcard. */
/*               Returns a pointer to an malloc()ed expanded filename */
/*               Returns 0 if all matching filenames have been returned. */
static char *
next_wild(wild)
    char *wild;			/* Wildcard to be expanded. */
{
    desc_str(wlddsc, wild);	/* VMS descriptor of wildcard string. */
    static uint cntxt = 0;	/* Context of wildcard search. */
    uint stat;			/* Status returned by lib$* services. */
    uint two = 2;		/* Flags to be passed by reference. */
    char file[FNAMSIZ];		/* Buffer to hold expanded file name. */
    desc_arr(fildsc, file);	/* VMS descriptor of buffer. */
    extern uint lib$find_file(), lib$find_file_end();	/* Library services. */

    stat = lib$find_file(&wlddsc, &fildsc, &cntxt, 0, 0, 0, &two);
    if (RMS$_SYN == stat) {	/* File syntax error: */
	fprintf(stderr, "%s: Invalid file wildcard.\n", wild);
    } else if (RMS$_FNF != stat && RMS$_NMF != stat) {
	/* Not "file not found" (1st try)
         * nor "no more files" (later tries): */
	sigvms(stat);		/* Display non-trivial status messages. */
    }
    if (!odd(stat)) {		/* Search didn't work: */
	sigvms(lib$find_file_end(&cntxt));
	return (0);
    }
    while (' ' == file[fildsc.leng - 1])
	--fildsc.leng;		/* Remove trailing spaces: */
    file[fildsc.leng] = '\0';
    /* Make copy of expanded name suitable for `argv': */
    return (strcpy(emalloc((unsigned) fildsc.leng + 1), file));
}


/* add_arg -- adds an argument to the list, expanding the list when needed */
static char **
add_arg(arg, acnt, ptrs)
    char *arg;			/* Argument to be added to the argument list */
    int *acnt;			/* # of args currently in the argument list */
    char **ptrs;		/* Array of pointers to the arguments */
{
#define ARGRP 64		/* # of string pointers allocated at a time */
    if (!ptrs) {		/* Initialize a new argument list: */
	char **v = emalloc(ARGRP * sizeof(char *));
	*acnt = 0;
	v[0] = 0;
	return (v);
    }
    if (0 == (*acnt + 1) % ARGRP)	/* Need more space for pointers */
	ptrs = erealloc(ptrs, (*acnt + 1 + ARGRP) * sizeof(char *));
    ptrs[*acnt] = arg;
    ptrs[++*acnt] = (char *) 0;
    return (ptrs);
}


/* ioinit -- do redirection and expansion of wildcards */
char **
ioinit(nargs, args)
    int *nargs;
    char **args;
{
    int argnum;
    char **argsp = args;
    int endc;
    char **endv = add_arg(0, &endc, 0); /* Initialize `add_arg()' structures */
    char *cp;

    /* First, do any necessary redirection */
    for (argnum = 1; argnum < *nargs; ++argnum) {
	if (strncmp(args[argnum], "<", 1) == 0) {
	    args[argnum] += 1;
	    *nargs = u_reopen(*nargs, args, argnum, "r", stdin);
	    argnum--;
	} else if (strncmp(args[argnum], ">>", 2) == 0) {
	    args[argnum] += 2;
	    *nargs = u_reopen(*nargs, args, argnum, "a", stdout);
	    argnum--;
	} else if (strncmp(args[argnum], ">", 1) == 0) {
	    args[argnum] += 1;
	    *nargs = u_reopen(*nargs, args, argnum, "w", stdout);
	    argnum--;
	} else if (strncmp(args[argnum], "2>>", 3) == 0) {
	    args[argnum] += 3;
	    *nargs = u_reopen(*nargs, args, argnum, "a", stderr);
	    argnum--;
	} else if (strncmp(args[argnum], "2>", 2) == 0) {
	    args[argnum] += 2;
	    *nargs = u_reopen(*nargs, args, argnum, "w", stderr);
	    argnum--;
	}
    }

    /* Second, expand any wildcards */
    while (*argsp) {
	if (iswild(*argsp)) {
	    while (cp = next_wild(*argsp))
		endv = add_arg(cp, &endc, endv);
	} else
	    endv = add_arg(*argsp, &endc, endv);
	argsp++;
    }

    *nargs = endc;
    return endv;
}


/* u_reopen -- redirect standard io streams and adjust arg list by */
/*             deleting redirection */
static int
u_reopen(nargs, args, argnum, acmod, chan)
    int nargs, argnum;
    char **args;		/* these two may be wrong */
    char *acmod;
    FILE *chan;
{
    char *file;
    int offset, i, errornum;

    if (args[argnum][0] != '\0') {
	offset = 1;
	file = args[argnum];
    } else if ((argnum + 1) < nargs) {
	offset = 2;
	file = args[argnum + 1];
    } else {
	fprintf(stderr, "Illegal redirection on command line.\n");
	exit(1);
    }
    for (i = argnum; i < nargs - offset; ++i)
	args[i] = args[i + offset];
    args[nargs - offset] = 0;	/* end of argv is supposed to be NULL? */
    if (((*acmod == ' ' || strcmp(acmod, "a+") == 0) && freopen(file, acmod,
       chan, "rfm=stm") != chan) || freopen(file, acmod, chan) != chan) {
	if (errno == EVMSERR) {
	    errornum = vaxc$errno;
	    fprintf(stderr, "Failure opening redirected stream.\n");
	    exit(errornum);
	} else {
	    perror("Failure opening redirected stream.");
	    exit(1);
	}
    } return (nargs - offset);
}



#ifdef EXAMPLE
#include <ctype.h>

/* Displays a string to `stdout', making all control and meta characters
 * printable unambigously. */
void dump(str)
    char *str;
{
#define META '`'		/* Show 'a'+'\200' as "`a" */
#define CTRL '^'		/* Show '\001' as "^A" */
#define BOTH '~'		/* Show '\201' as "~A" */
#define QOTE '~'		/* Show '`' as "~`", '^' as "~^", and '~' as "~~" */
#define DEL '\177'
#define uncntrl(c)     ( DEL==c ? '?' : c + '@' )
    static char spec[] = { META, CTRL, BOTH, QOTE, 0 };
    while (*str) {
	switch ((!!iscntrl(*str)) + 2 * (!isascii(*str))) {
	case 0:		/* Normal */
	    if (strchr(spec, *str))
		putchar(QOTE);
	    putchar(*str);
	    break;
	case 1:		/* Control */
	    putchar(CTRL);
	    putchar(uncntrl(*str));
	    break;
	case 2:		/* Meta */
	    putchar(META);
	    putchar(toascii(*str));
	    break;
	case 3:		/* Both */
	    putchar(BOTH);
	    putchar(uncntrl(toascii(*str)));
	    break;
	}
	++str;
    }
}

main(argc, argv)
    int argc;
    char **argv;
{
    int cnt;
    
    argv = ioinit(&argc, argv);
    printf("%d argument%s%s\n", argc,
	   1 == argc ? "" : "s", argc ? ":" : ".");
    for (cnt = 0; *argv; ++argv) {
	printf("%5d: `", ++cnt);
	dump(*argv);
	printf("'\n");
    }
    sys$exit(1);
}

#endif				/* EXAMPLE */
