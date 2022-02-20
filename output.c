/* output.c -- output routines for SDCL.  These are necessary because we
   want to keep output lines 80 characters long or less and therefore
   have to insert DCL line continuation sequences every so often.  However,
   sometimes we don't want the lines to be split at all, so we have a
   seperate routine for that, too.

   I'm sure there is a better way... */

#include <stdio.h>

#include "sdcl.h"

extern int break_lines_flag;	/* in sdcl.c */


int outlinelen;			/* output line length */



/* putch -- output a character, keeping track of line length and end of line */
void 
putch(char c)
{
    fputc(c, outfile);
    outlinelen++;
    if (c == '\n') {
	outlinelen = 0;
	outlineno++;
    }
}



/* putstr -- output a string, possibly inserting a DCL continuation
   before the string; Note that this only works because the *only*
   string that can be output with a space as the first character is a
   TC_SPACE token, which is also the only place where a line should be
   broken.  There should be a better way to do this... */

void 
putstr(char *s)
{
    if (break_lines_flag && (*s == ' ') && (outlinelen > 72)) {
	fprintf(outfile, " -\n%s", s);
	outlinelen = 0;
	outlineno++;
    }
    while (*s)
	putch(*s++);
}



/* putstr_unbroken -- output a string, *never* insert DCL line continuation */
void 
putstr_unbroken(char *s)
{
    while (*s)
	putch(*s++);
}



/* putlabel -- output a number followed by colon */
void 
putlabel(int n)
{
    char s[15];

    sprintf(s, "%05d: ", n);
    putstr(s);
}



/* puttarget -- output a label to be used as a target in a goto */
void 
puttarget(int n)
{
    char s[15];

    sprintf(s, "%05d", n);
    putstr(s);
}
