/* sdcl.c -- this file contains the main function and several other functions
   used in several places */

#include "stdlib.h"
#include <stdio.h>
#include <stdarg.h>
#include <strings.h>

#include "sdcl.h"

/* file information variables */
FILE *infile;			/* input file pointer */
char *infilename;		/* input file name */
int inlineno;			/* input line number */
int no_input = 0;		/* true if no input file specified, */
 /* in which case it goes to stdout */

FILE *outfile;			/* output file pointer */
char *outfilename;		/* output file name */
int outlineno;			/* output line number */

int inputlines = 0, outputlines = 0;


/* warning and error counters */
int warningcount = 0;		/* number of warnings */
int errorcount = 0;		/* number of errors */

/* flags */
int break_lines_flag = TRUE;	/* normally we insert line continuation */
int debug_flag = FALSE;		/* don't normally need debug info */
int out_flag = FALSE;		/* normally get output name from input name */
int verbose_flag = FALSE;	/* print more information */

extern char *version_string;	/* version string, from version.c */

/* external declarations for `getopt' */
extern int getopt(int, char **, char *);
extern char *optarg;
extern int optind;

char *getoutname(char *);	/* forward declaraction */

main(argc, argv)
    int argc;
    char *argv[];
{
    int c;			/* return value from getopt */
    int nfiles = 0;		/* number of files processed */

#ifdef VMS
    extern char **ioinit();
    argv = ioinit(&argc, argv);
#endif

    optind = 0;			/* init for getopt */
    while ((c = getopt(argc, argv, "bdvo:")) != EOF) {
	switch (c) {
	case 'b':
	    break_lines_flag = 0;	/* don't break long lines */
	    break;
	case 'd':
	    debug_flag = 1;
	    break;
	case 'v':
	    verbose_flag = 1;
	    break;
	case 'o':
	    outfilename = optarg;
	    out_flag = 1;
	    break;
	}
    }

    if (verbose_flag)		/* tell user who we are */
	message("SDCL version %s\n", version_string);

    /* process the files */
    if (out_flag) {		/* output file specified */
	if (!(outfile = fopen(outfilename, "w"))) {
	    error_plain("unable to open specified output file %s",
			outfilename);
	    exit(EXIT_FAILURE);
	}
    }
    if (optind == argc) {	/* no input file specified, so use stdin */
	infile = stdin;
	infilename = "(standard input)";
	no_input = 1;
	if (!out_flag) {	/* and no output file, so use stdout */
	    outfile = stdout;
	    outfilename = "(standard output)";
	}
    }
    while (optind < argc || no_input) {
	if (!no_input) {	/* open input file */
	    infilename = argv[optind++];
	    if (!(infile = fopen(infilename, "r"))) {
		error_plain("cannot open input file %s", infilename);
		continue;
	    }
	}
	if (!(no_input || out_flag)) {	/* open output file */
	    outfilename = getoutname(infilename);
	    if (!(outfile = fopen(outfilename, "w"))) {
		error_plain("cannot open output file %s", outfilename);
		fclose(infile);
		error_plain("skipping input file %s", infilename);
		continue;
	    }
	}
	initlex();		/* initialize lexical analyzer */
	program();		/* parse a SDCL program */
	nfiles++;

	/* reports some statistics for the current file */
	if (verbose_flag) {
	    message("%8d input lines from %s\n"
		    "%8d output lines written to %s\n\n",
		    (inlineno - 1), infilename, outlineno, outfilename);
	}
	/* record some statistics for possible total, and re-init counters */
	inputlines += (inlineno - 1);
	outputlines += outlineno;
	inlineno = 0;
	outlineno = 0;

	if (no_input)
	    break;		/* if no input, just read to end of stdin */
    }				/* end of file processing */

    if (verbose_flag && (nfiles > 1)) {
	message("%8d input lines processed\n%8d output lines processed\n",
		inputlines, outputlines);
	if (warningcount)
	    message("%d warning(s)\n", warningcount);
	if (errorcount)
	    message("%d error(s)\n", errorcount);
    }
    if (errorcount)
	return EXIT_FAILURE;
    return EXIT_SUCCESS;
}



void 
warning(char *format,...)
{
    va_list ap;

    fprintf(stderr, "warning: %s:%d: ", infilename, inlineno);
    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
    putc('\n', stderr);
    warningcount++;
}



void 
error(char *format,...)
{
    va_list ap;

    fprintf(stderr, "error: %s:%d: ", infilename, inlineno);
    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
    putc('\n', stderr);
    errorcount++;
}




void 
message(char *format,...)
{
    va_list ap;

    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
}



void 
error_plain(char *format,...)
{
    va_list ap;

    fprintf(stderr, "sdcl: ");
    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
    putc('\n', stderr);
    errorcount++;
}



void 
error_line(int lineno, char *format,...)
{
    va_list ap;

    fprintf(stderr, "error: %s:%d: ", infilename, lineno);
    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
    putc('\n', stderr);
    errorcount++;
}



/* getoutname -- given the name of an input file, produce the name of the */
/*               corresponding output file, by eliminating any directory */
/*               name and extension, and adding ".COM" to the end. */
/*               Note: This works for VMS-style directory names only, */
/*               though it could work for unix-style directory names also. */

char *
getoutname(char *s)
{
    char *start, *end, *t;
    int len;

    if (start = rindex(s, ']'))
	start++;		/* start with next char */
    else if (start = rindex(s, ':'))
	start++;		/* start with next char */
    else			/* no logical or directory, use whole name */
	start = s;
    if (!(end = rindex(start, '.')))
	end = index(start, '\0');

    len = (int) end - (int) start;
    if (!(t = malloc(len + 5))) {	/* serious error, not enough memory */
	fprintf(stderr,
	      "sdcl: unable to allocate memory for file name, aborting");
	exit(EXIT_FAILURE);
    }
    t[0] = 0;
    strcat(strncat(t, start, len), ".com");
    return t;
}
