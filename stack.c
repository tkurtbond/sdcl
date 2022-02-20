/* stack.c -- this file contains the functions and variables used to
   maintain the loop stack for loops and the break and next statements.

   The only reason the loop stack exists is so that DCL code for the
   break and next SDCL statements can be generated.  To generate
   those, we have to know what label to output the `goto' to.  So, we
   push that on the loop stack when we start a loop, and can peek at
   items on the stack while inside that loop.

   If we eliminate the break and next statments, the implicit stack
   due to the recursive descent parser has all the info we'd need. */


#include <stdio.h>


typedef struct itemtype {
    int tc;			/* token code of loop keyword */
    int label;			/* first label of loop */
    int lineno;			/* line number of loop keyword */
    struct itemtype *next;	/* pointer to next item in stack */
} ITEM;

typedef struct stacktype {
    int depth;			/* number of items in the stack */
    ITEM *top;
} STACK;


STACK stack =
{
    0,				/* stack starts with no items, and is */
    NULL,			/* empty, so pointer to top of stack is NULL */
};



/* depth -- return the number of items on the stack */
int 
depth(void)
{
    return (stack.depth);
}



/* push -- push a token code and label onto the node stack */
int 
push(int tc, int label, int lineno)
{
    ITEM *p;
    extern char *malloc();

    if ((p = (ITEM *) malloc(sizeof(ITEM))) == NULL) {
	error("internal error: not enough memory to expand loop stack");
	return 0;		/* return false, not enough memory */
    } else {
	p->tc = tc;
	p->label = label;
	p->lineno = lineno;
	p->next = stack.top;
	stack.top = p;
	stack.depth++;
	return 1;		/* return true, info pushed on stack */
    }
}



/* pop -- pop loop information */
int 
pop(int *tc, int *label, int *lineno)
{
    ITEM *p;
    extern char *free();

    if (stack.top != NULL) {
	*tc = stack.top->tc;
	*label = stack.top->label;
	*lineno = stack.top->lineno;
	p = stack.top;
	stack.top = stack.top->next;
	stack.depth--;
	free((char *) p);
	return 1;
    } else {
	error("internal error: attempt to pop empty loop stack");
	return 0;
    }
}



/* peek -- get the info in the n-th item (indexed from 1) of the stack */
int 
peek(int n, int *tc, int *label, int *lineno)
{
    if (stack.depth < n) {
	return 0;		/* no such enclosing stack */
    } else {
	if (NULL == stack.top) {
	    error("internal error: attempt to peek at empty loop stack");
	    return 0;
	} else {
	    /* there are enough items on stack to satisfy the request */
	    int i = 0;
	    ITEM *p;

	    p = stack.top;
	    do {
		if (NULL == p) {
		    error("serious internal error: corrupted loop stack");
		    return 0;
		}
		i++;
		if (i >= n)
		    break;	/* found item n */
		p = p->next;
	    } while (0);
	    *tc = p->tc;
	    *label = p->label;
	    *lineno = p->lineno;
	    return 1;
	}
    }
}
