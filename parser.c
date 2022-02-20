/* parser.c -- this file contains the recursive descent parser for SDCL.

   Code generation is driven directly by the parser; i.e., the output
   code is generated as the input source is parsed.

   The parser follows the BNF pretty closely, with one function per
   production. */

#include <stdio.h>
#include "sdcl.h"
#include "codes.h"



int tokencode;			/* token code of current token */
char token[MAXTOK + 1];		/* value of current token */



/* forward declarations of functions */
void statement();



/* genlab -- generate `n' labels */
int 
genlab(int n)
{
    static int label = 23000;
    int m;

    m = label;
    label += n;
    return m;
}



/* condition -- process a conditional, end with unbalanced ")", or ";" */
void 
condition()
{
    int paren_count = 1;

    if (tokencode == TC_OPAREN)
	paren_count++;
    putstr(token);
    do {
	tokencode = gettoken(token);
	switch (tokencode) {
	case TC_OPAREN:
	    paren_count++;
	    putstr(token);
	    break;
	case TC_CPAREN:
	    if (--paren_count != 0)
		putstr(token);
	    break;
	case TC_EOL:		/* eat up newlines */
	    break;
	case TC_SEMI:		/* in a for loop */
	    break;
	default:
	    putstr(token);
	    break;
	}
    } while (paren_count > 0 && tokencode != TC_SEMI && tokencode != TC_EOF);
}



/* initialize -- process initialize portion of 'for' statement */
void 
initialize()
{
    putstr("$ ");
    while (tokencode != TC_SEMI && tokencode != TC_EOF) {
	putstr(token);
	tokencode = gettoken(token);
    }
    putch('\n');
}



/* reinitialize -- process re-initialize portion of 'for' statement */
void 
reinitialize(char *s)
{
    int paren = 1;
    int tl, sl;			/* token length, re-init string len */

    if (tokencode == TC_OPAREN)
	paren++;
    s[0] = '\0';		/* make sure it is terminated */
    sl = strlen(s);
    do {
	tl = strlen(token);
	if ((tl + sl) > MAXTOK)
	    error("reinitialization string too long");
	else {
	    strcat(s, token);
	    sl += tl;
	}
	tokencode = gettoken(token);
	tl = strlen(token);
	switch (tokencode) {
	case TC_OPAREN:
	    paren++;
	    break;
	case TC_CPAREN:
	    paren--;
	    break;
#if 0				/* we don't actually need this */
	case TC_EOL:		/* eat up newlines */
	    break;
	case TC_EOF:
	    break;		/* do nothing */
	default:
	    break;		/* do nothing */
#endif
	}
    } while (paren != 0 && tokencode != TC_SEMI && tokencode != TC_EOF);
}



/* break_stmt -- Process a break statement */
void 
break_stmt()
{
    int tc, label, lineno, break_loop = 1, line_for_error = inlineno;

    /* line number for error is saved because if next token is TC_EOL the
       error line number would be off due to the `scan_tok_eol'. */

    tokencode = scan_tok_eol(token);
    if (tokencode == TC_INTEGER) {
	break_loop = atoi(token);
	if (break_loop <= 0) {
	    error_line(line_for_error, "negative or zero argument to 'break'");
	    break_loop = 1;
	}
    }
    if (!peek(break_loop, &tc, &label, &lineno))
	error_line(line_for_error,
		   "'break' statement not within %d enclosing loop(s)",
		   break_loop);
    else {
	putstr("$ goto ");
	if (TC_FOR == tc || TC_DO == tc || TC_REPEAT == tc)
	    puttarget(label + 2);
	else
	    puttarget(label + 1);
	putch('\n');
    }
    if (tokencode == TC_SPACE ||
	tokencode == TC_EOL || tokencode == TC_INTEGER) {
	/* discard following whitespace or integer, if any */
	tokencode = scan(token);
    }
}



/* do_stmt -- process a do-while statement (the while is required) */
void 
do_stmt()
{
    int tc = TC_DO, label = genlab(3), lineno = inlineno;

    push(tc, label, lineno);
    tokencode = scan(token);
    putstr("$ ");
    putlabel(label);
    putch('\n');
    statement();
    if (tokencode == TC_WHILE)
	tokencode = scan(token);
    else {
	error("missing keyword 'while' in do-while loop starting on line %d",
	      lineno);
    }
    if (tokencode == TC_OPAREN)
	tokencode = scan(token);
    else
	error("missing '(' in do-while condition");
    putstr("$ ");
    putlabel(label + 1);
    putstr("if (");
    condition();
    if (tokencode == TC_CPAREN)
	tokencode = scan(token);
    else
	error("missing ')' in do-while condition");
    putstr(") then goto ");
    puttarget(label);
    putch('\n');
    putstr("$ ");
    putlabel(label + 2);
    putch('\n');
    if (!pop(&tc, &label, &lineno))	/* clean up loop stack */
	error("internal error: corrupted loop stack at end of 'do'-'while'");
}



/* if_stmt -- Process an if-else statement (else is optional) */
void 
if_stmt()
{
    int label;

    tokencode = scan(token);
    if (tokencode == TC_OPAREN)
	tokencode = scan(token);
    else
	error("missing '(' in 'if' condition");

    label = genlab(2);		/* if takes 2 labels, one in case of else */
    putstr("$ if (.not.(");

    condition();

    if (tokencode == TC_CPAREN)
	tokencode = scan(token);
    else
	error("missing ')' in 'if' condition");

    putstr(")) then goto ");
    puttarget(label);
    putch('\n');

    statement();		/* do then branch of if */

    if (tokencode != TC_ELSE) {	/* no else part */
	putstr("$ ");
	putlabel(label);
	putch('\n');
    } else {			/* we found an ELSE part */
	tokencode = scan(token);
	putstr("$ goto ");
	puttarget(label + 1);
	putstr("\n$ ");
	putlabel(label);
	putch('\n');
	statement();		/* do else branch of if */
	putstr("$ ");
	putlabel(label + 1);
	putch('\n');
    }
}



/* for_stmt -- process a for statement */
void 
for_stmt()
{
    int tc = tokencode, label = genlab(3), lineno = inlineno;
    char reinitstr[MAXTOK + 1];

    reinitstr[0] = '\0';	/* make sure it is terminated */
    push(tc, label, lineno);
    tokencode = scan(token);
    if (tokencode != TC_OPAREN)
	error("missing '(' in 'for' statement");
    else
	tokencode = scan(token);
    if (tokencode != TC_SEMI)
	initialize();		/* token should now be a semicolon */

    putstr("$ ");
    putlabel(label);

    tokencode = scan(token);
    if (tokencode != TC_SEMI) {
	putstr("if (.not.(");
	condition();
	putstr(")) then goto ");
	puttarget(label + 2);
    }
    putch('\n');

    tokencode = scan(token);
    if (tokencode != TC_CPAREN)
	reinitialize(reinitstr);
    if (tokencode != TC_CPAREN)
	error("missing ')' in 'for' statement");
    else
	tokencode = scan(token);

    statement();		/* process the body of the loop */
    putstr("$ ");
    putlabel(label + 1);
    if (reinitstr[0])
	putstr(reinitstr);
    putstr("\n$ goto ");
    puttarget(label);
    putstr("\n$ ");
    putlabel(label + 2);
    putch('\n');
    if (!pop(&tc, &label, &lineno))
	error("internal error: corrupted loop stack at end of 'for'");
}



/* next_stmt -- Process a next statement */
void 
next_stmt()
{
    int tc, label, lineno, next_loop = 1, line_for_error = inlineno;

    /* line number for error is saved because if next token is TC_EOL the
       error line number would be off */

    tokencode = scan_tok_eol(token);
    if (tokencode == TC_INTEGER) {
	next_loop = atoi(token);
	if (next_loop <= 0) {
	    error_line(line_for_error, "negative or zero argument to 'next'");
	    next_loop = 1;
	}
    }
    if (!peek(next_loop, &tc, &label, &lineno))
	error_line(line_for_error,
		   "'next' statement not within %d enclosing loop(s)",
		   next_loop);
    else {
	putstr("$ goto ");
	if (TC_FOR == tc || TC_DO == tc || TC_REPEAT == tc)
	    puttarget(label + 1);
	else
	    puttarget(label);
	putch('\n');
    }
    if (tokencode == TC_SPACE ||
	tokencode == TC_EOL || tokencode == TC_INTEGER) {
	/* discard following whitespace or integer, if any */
	tokencode = scan(token);
    }
}



/* repeat_stmt -- Process repeat-until statement (until optional). */
void 
repeat_stmt()
{
    int tc = TC_REPEAT, label = genlab(3), lineno = inlineno;

    push(tc, label, lineno);
    tokencode = scan(token);
    putstr("$ ");
    putlabel(label);
    putch('\n');
    statement();
    if (tokencode != TC_UNTIL) {
	/* endless loop */
	putstr("$ ");
	putlabel(label + 1);
	putstr("goto ");
	puttarget(label);
	putch('\n');
    } else {
	tokencode = scan(token);
	if (tokencode == TC_OPAREN)
	    tokencode = scan(token);
	else
	    error("missing '(' in repeat-until condition");
	putstr("$ ");
	putlabel(label + 1);
	putstr("if (.not.(");
	condition();
	if (tokencode == TC_CPAREN)
	    tokencode = scan(token);
	else
	    error("missing ')' in repeat-until condition");
	putstr(")) then goto ");
	puttarget(label);
	putch('\n');
    }
    putstr("$ ");
    putlabel(label + 2);
    putch('\n');
    if (!pop(&tc, &label, &lineno))
	error("internal error: corrupted loop stack in 'repeat'");
}



/* while_stmt -- process while statement */
void 
while_stmt()
{
    int tc = TC_WHILE, label = genlab(2), lineno = inlineno;

    push(tc, label, lineno);
    tokencode = scan(token);
    putstr("$ ");
    putlabel(label);
    putstr("if (.not.(");
    if (tokencode == TC_OPAREN)
	tokencode = scan(token);
    else
	error("missing a '(' in while condition");
    condition();
    if (tokencode == TC_CPAREN)
	tokencode = scan(token);
    else
	error("missing a ')' in a while condition");
    putstr(")) then goto ");
    puttarget(label + 1);
    putch('\n');
    statement();
    putstr("$ goto ");
    puttarget(label);
    putstr("\n$ ");
    putlabel(label + 1);
    putch('\n');
    if (!pop(&tc, &label, &lineno))
	error("internal error: corrupted loop stack in 'while'");
}



/* compound_stmt -- process a compound statement, a list of statements
   between `{' and `}' */
void 
compound_stmt()
{
    int lineno = inlineno;
    
    tokencode = scan(token);
    while (tokencode != TC_CBRACE && tokencode != TC_EOF)
	statement();
    if (tokencode == TC_CBRACE)
	tokencode = scan(token);
    else {
	error("missing closing '}' in compound statement starting on line %d",
	      lineno);
    }
}



/* ident_stmt -- process a statement that begins with an identifier */
/* It can be either a <label>: statement or something else. */
void 
ident_stmt()
{
    int whitespace_token = 0;

    putstr("$ ");		/* since this will be a statement regardless */
    putstr(token);

    /* Find next non-whitespace token.  Remember if a whitespace token
       appears, because the whitespace token will be significant on anything
       but a label. */
    tokencode = gettoken(token);/* gets at least one token */
    if (tokencode == TC_SPACE) {
	whitespace_token = 1;	/* remember this */
	while (tokencode == TC_SPACE)
	    tokencode = gettoken(token);
    }
    if (tokencode == TC_COLON) {/* label  */
	putstr(token);
	putch('\n');		/*  since labels can always be on prev. line */
    } else {			/* anything but label */
	if (whitespace_token)
	    putch(' ');
	while (tokencode != TC_EOL && tokencode != TC_EOF) {
	    putstr(token);
	    tokencode = gettoken(token);
	}
	putch('\n');		/* end this line */
    }
    tokencode = scan(token);
}



/* dcl_stmt -- Emit a pure DCL statement, untouched by SDCL. */
void 
dcl_stmt()
{
    putstr_unbroken(token);
    putch('\n');
    tokencode = scan(token);
}



/* other_stmt -- process statement not otherwise recognized,
   i.e. DCL instead of SDCL */
void 
other_stmt()
{
    putstr("$ ");
    putstr(token);
    tokencode = gettoken(token);
    while (tokencode != TC_EOL && tokencode != TC_EOF) {
	putstr(token);
	tokencode = gettoken(token);
    }
    putch('\n');		/* end this line */
    tokencode = scan(token);	/* find beginning of next statement */
}



/* unexpected -- unexpected token, display error message and eat token */
void
unexpected(char *token_name)
{
    error("unexpected keyword %s", token_name);
    tokencode = scan(token);
}



/* statement -- decide what type of statement and dispatch to be processed */
void 
statement()
{
    switch (tokencode) {
	case TC_BREAK:
	break_stmt();
	break;
    case TC_DO:
	do_stmt();
	break;
    case TC_ELSE:
	unexpected("ELSE");
	break;
    case TC_FOR:
	for_stmt();
	break;
    case TC_IF:
	if_stmt();
	break;
    case TC_NEXT:
	next_stmt();
	break;
    case TC_REPEAT:
	repeat_stmt();
	break;
    case TC_WHILE:
	while_stmt();
	break;
    case TC_OBRACE:
	compound_stmt();
	break;
    case TC_IDENT:
	ident_stmt();
	break;
    case TC_DCLSTMT:
	dcl_stmt();
	break;
    default:			/* anything not recognized as a SDCL */
	other_stmt();		/* construct is treated as a DCL statement */
    }
}



/* program -- parse a SDCL program */
void 
program()
{
    tokencode = scan(token);	/* get the first non-whitespace token */
    while (tokencode != TC_EOF)
	statement();		/* process each statement */
}
