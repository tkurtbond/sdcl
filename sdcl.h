/* sdcl.h -- various definitions used globally */

#define MAXTOK (512)		/* maximum length of token */
#define MAXLEN (512)		/* maximum length of input buffer */
#define TRUE   (-1)		/* true value */
#define FALSE  (0)		/* false value */


extern FILE *infile;		/* input file pointer */
extern char *infilename;	/* input file name */
extern int inlineno;		/* input line number */

extern FILE *outfile;		/* output file pointer */
extern char *outfilename;	/* output file name */
extern int outlineno;		/* output file number */
extern int outlinelen;		/* output line length */


extern void warning(char *, ...); /* report warning, with file and line */
extern void error(char *, ...);	  /* report error, with file and line */
extern void error_plain(char *, ...); /* report error, without file and line */
extern void message(char *, ...); /* report a message */


extern void putch(char c);	/* output a character */
extern void putstr(char *s);	/* output a string, with auto-continuation */
extern void putsr_unbroken(char *s); /* output a string w/o continued */
extern void putlabel(int n);	/* output a number followed by a colon */
extern void puttarget(int n);	/* output label to be used as target in goto */

extern void reinitlabels(void); /* Reinitialize label numbers. */
