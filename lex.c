/* lex.c -- lexical analyzer for SDCL.  Uses a table driven Finite State
   Machine (FSM).  The FSM uses two tables, one which controls state
   transitions depending on what the input character is and what the current
   state is, and one which controls how the input is handled (add character
   to token and get new character, ignore character and get new character,
   ignore character, etc.) */

#include <stdio.h>

#include "sdcl.h"
#include "codes.h"
#include "lextab.h"



int nextchar;			/* lookahead character */


#define getch() fgetc(infile)	/* how we get input from the file */

/* `newchar()' is used to get a new character and increment the input line
   number. Make sure that `newchar()' is only used AFTER any lex box error
   messages, so that line numbers will not be wrong */
#define newchar() \
    do { if ('\n' == nextchar) inlineno++; nextchar = getch(); } while (0)


/* initlex -- initialize lexical analyzer */
void 
initlex()
{
    nextchar = getch();		/* lookhead character */
    inlineno = 1;		/* always start on line 1 */
}



#ifdef LEXDEBUGCHAR
/* lexstateout -- print out lexical analyzer state information */
#define lexstateout() \
    fprintf(stderr, "debug: state %d, laststate %d, action %d, nextchar %d\n",\
	    state, laststate, action, nextchar)
#else
#define lexstateout()
#endif				/* LEXDEBUGCHAR */



/* getclass -- this macro returns the character class of `nextchar' (unsafe) */
#define getclass(nextchar) \
    nextchar == EOF ? \
        LT_EOF : nextchar >= 0 && nextchar <= 127 ? \
            char_to_class[nextchar] : LT_UNDEFINED



/* addchar -- this macro adds character `c' to the output string if it fits */
#define addchar(c) \
    do { \
	if (p < MAXTOK) token[p++] = c; \
	else { \
	    lexstateout(); \
	    warning("internal error: token too long"); \
	} \
    } while (0)



/* killtok -- this macro erases the token collected so far */
#define killtok() p = 0



/* gettoken -- read a token into string, return its token code */
int 
gettoken(char *token)
{
    int state = ST_START, laststate, action;
    int class;
    int p = 0;			/* pointer into token buffer */
    int tc;			/* token code to return for this token */

    do {
	class = getclass(nextchar);
	laststate = state;
	action = nextaction[state][class];
	state = nextstate[state][class];
	/* perform the action appropriate to this state transition */
	switch (action) {
	case AC_ADDGET:
	    addchar(nextchar);
	    newchar();
	    break;
	case AC_IGNGET:
	    newchar();
	    break;
	case AC_IGNNOP:
	    break;
	case AC_IGNERR:
	    lexstateout();
	    warning("lexical error: %s", state_error[laststate]);
	    break;
	case AC_IGNINL:
	    addchar('\n');
	    break;
	case AC_BLKGET:
	    addchar(' ');
	    break;
	case AC_KILGET:
	    killtok();
	    newchar();
	    break;
	default:
	    lexstateout();
	    warning("internal error in lexical analyzer: unknown action");
	    break;
	}
    } while (state != ST_ACCEPT);

    token[p++] = '\0';		/* terminate the token string */

    /* the last state before accept tells the type of token */
    tc = state_to_tc[laststate];

    if (tc == TC_IDENT)
	tc = identify(token);	/* decide if it's a keyword */

#ifdef LEXDEBUGTOKEN
    fprintf(stderr, "lex: code %d, value '%s'\n", tc, token);
#endif				/* LEXDEBUGTOKEN */

    return tc;
}



/* scan -- read tokens until we get a non-(whitespace|newline) token */
int 
scan(char *token)
{
    int tc;

    /* gets at least one new token */
    tc = gettoken(token);
    while (tc == TC_SPACE || tc == TC_EOL)
	tc = gettoken(token);

    return tc;
#ifdef LEXDEBUGTOKEN
    fprintf(stderr, "lex: end of scan-------------------------------------\n");
#endif				/* LEXDEBUGTOKEN */
}



/* identify -- identify if an identifer is a keyword */
int 
identify(char *token)
{
    static struct Keyword {
	char *word;
	int code;
    } keywords[] =
    {
    /* INDENT OFF */
    { "break", TC_BREAK },
    { "do", TC_DO },
    { "else", TC_ELSE },
    { "for", TC_FOR },
    { "if", TC_IF },
    { "next", TC_NEXT },
    { "repeat", TC_REPEAT },
    { "until", TC_UNTIL },
    { "while", TC_WHILE },
    { 0, TC_IDENT },
	/* INDENT ON */
    };

    int i;

    for (i = 0; keywords[i].word; i++)
	if (!strcmp(keywords[i].word, token))
	    return keywords[i].code;
    return keywords[i].code;
}



/* scan_tok_eol -- scan whitespace till find a token or an end of line */
int 
scan_tok_eol(char *token)
{
    int tc;

    tc = gettoken(token);	/* gets at least one token */
    while (tc == TC_SPACE)
	tc = gettoken(token);

    return tc;
}
