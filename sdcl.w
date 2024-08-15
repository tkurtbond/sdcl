#-h- .indent_pro       14  bin  12-aug-24 09:39:48  tkb ()
-kr -psl -ip4
#-h- 000change_log.txt 10829  bin  13-aug-24 17:21:18  tkb ()
Mon Aug 12 09:13:32 2024  T. Kurt Bond  (TKB at MPLVAX)

        * Put under revision control using SWTOOLS TCS using files sdcl.w
        and sdcl.tcs

        * SDCL_SETUP.COM: Add command procedure to set up SDCL DCL symbol
        for foreign command execution.

        * LISTSRCS.SH: Add SWTOOLS shell script to list sources and
        produce commands to initialize sdcl.w.

        * COUNT_SRCS.COM: Add commmand procedure to count sources.

        * SDCL.RNO: Rename section Notes to Language Notes.  Convert that
        section to use lists to make reference to each of the items
        easier. 

Tue Jul  2 13:58:06 2024  T. Kurt Bond  (TKB at MPLVAX)

        * PARSER.C, SDCL.C, SDCL.H: Add the reinitlabels() function to
        reinitialize the label counter, so that if we're not outputing to
        a single file the label numbers SDCL generates for its translation
        of control structures will will start over for each output file,
        so diffing the .COM files produced will be easier.

        * SDCL.MAN: Document that labels are reinitialized at the start of
        each file, unless outputing everything to a single file.

        * VERSION.C: Incrememt tertiary version number.

        * STRIPCRLF.COM: Addeed for building SDCL.DOC.

        * SDCL.RNO: Create from SDCL.MAN, and delete SDCL.MAN.

        * DESCRIP.MMS: Add rules to build SDCL.MEM and SDCL.DOC from
        SDCL.RNO.

Mon Jul  1 15:09:20 2024  T. Kurt Bond  (TKB at MPLVAX)

        * DESCRIP.MMS: Added zipto target for createding zip file
        SDCLWRK.ZIP, for exporting current work in progress.  Use the
        NOTE macro if specified as an additional part of the zipfile
        in the zipit target.

        * GETOPT.C: Improve portability, by switching from bcopy, index,
        rindex, and alloca to memmove, strchr, strrchr, and malloc and
        free.

        * IOINIT.C: Improve portability by adding forward declaration and
        using EXIT_FAILURE.

        * README.RST: Use the correct terminology: it's called "VAX C".

        * SDCL.C: Improve portability by switching from <strings.h> to
        <string.h> and index and rindex to strchr and strrchr and
        convert return statements in main() to exit() calls.

        VAX C doesn't understand that string constants without
        anything but whitespace between them should be a single string
        constant, so make it one string constant using newline
        backslash to indicate the string constant is continued on the
        next line.

        Add a "-h" option to display help and then exit, and usage()
        to implement it.

        * SDCL.MAN: Add the "-h" option and sort the options
        alphabetically.

        * TODO.ORG: Rename TODO.; to TODO.ORG and update.


Sun Feb 20 13:50:12 2022  T. Kurt Bond  (TKB at MPLVAX)

        * README.RST: Renamed AAAREADME.1ST to README.RST, so GitHub will
        recognize it.  Added links to MMK and SSTG.

        * SDCL.SCN: Update comments in preparation for uploading to
        GitHub.

        * DESCRIP.MMS.  Change CLEAN target to not delete SDCL.TABLE,
        CODES.H, and LEXTAB.H, so SDCL can be built without SSTG.  Add
        REALCLEAN target that *does* delete them.

Fri Feb 18 14:30:30 2022  T. Kurt Bond  (TKB at MPLVAX)

        * DESCRIP.MMS: Created in preparation for uploading to GitHub.

        * SDCL.TABLE, CODES.H, LEXTAB.H: Generated new versions for
        comparison to ensure the completed version of SSTG_TO_C.SCM worked
        correctly.

Thu Feb 17 15:30:03 2022  T. Kurt Bond  (TKB at MPLVAX)

        * sdcl.man: added details on recognition of SDCL keywords and
        braces, and multiple line initialize and reinitialize clauses
        in for loops.

Thu Nov  7 11:20:19 1991  T. Kurt Bond  (TKB at _MPL)

        * Version 1.5.1 released.

Fri Aug  9 16:33:03 1991  T. Kurt Bond  (TKB at _MPL)

        * parser.c: added case for TC_ELSE in `compound_stmt()' that
        outputs an error message (an ELSE should normally only be found
        after an if, in which case it will be processed in `if_stmt()').
        Added reporting of line number where an unclosed loop or compound
        statement starts.

        * sdcl.c: added call to `ioinit()' in `main()' to do io
        redirection and expand wildcards.

Fri Mar 23 17:07:46 1990    (TKB at MPL)

        * parser.c: add new production, `ident_stmt()', which allows SDCL
        to recognize SDCL constructs after identifier labels.  Before,
        SDCL didn't recognize labels, so the whole line was classified as
        an `other' statement, and any SDCL constructs on that line were not
        recognized.  Now, SDCL recognizes that an identifier followed by a
        colon (optionally seperated by whitespace), where the colon is not
        part of a `:=', is a label, so it can recognize SDCL constructs on
        lines after a label.

        * sdcl.scn: Add LT_COLON and LT_EQUAL, so scanner can return
        TC_COLON or TC_ASSIGN, allowing parser to recognize labels.

Wed Mar 21 12:52:58 1990    (TKB at MPL)

        * sdcl.c: change so total number of lines is output only if there
        are more than one files processed.

        * sdcl.scn: Add character class LT_BANG, token code TC_OTHER, and
        state 22, which together allows the scanner to return a DCL
        comment as a single token, thus avoiding the error where a long
        DCL comment is broken over two lines since the comment was treated as a
        normal sequence of `other' statements.  Note: LEXTAB.H and CODES.H
        are automatically generated from SDCL.SCN.

Thu Sep 14 09:05:03 1989    (TKB at MPL)

        * Version 1.4 released.

        * sdcl.man: update for new '//' syntax.

        * parser.c: Change `dcl_stmt()' to only output the current token,
        since DCL statements (statements starting with `//' and continuing
        to the end of the line) are now returned as a single token.

        * lex.c: Add `killtok()' macro to empty the current token, for the
        AC_KILLGET action.  Add AC_KILLGET to case statement that handles
        actions. 

        * codes.h lextab.h: These files are now produced by a scanner
        table generator, from `sdcl.scn'.  The scanner table generator
        reads a file containing the definitions for a FSM lexical
        analyser, and produces the tables to drive the lexical analyser
        and the necessary #define's for token codes, etc.

Mon Jul 24 13:31:09 1989    (TKB at MPL)

        * lex.c codes.h lextab.h: Change `LC_' to `LT_', since `LC_' is
        reserved by the Draft ANSI C Standard for macros dealing with
        locales. 

Wed Jul 19 15:32:27 1989    (TKB at MPL)

        * sdcl.c: Add call to macro `va_end(ap)' to `warning()',
        `error()', `message()', `error_plain()', `error_line()' after call
        to function `vfprintf()'.

Tue Jul 18 16:02:43 1989    (TKB at MPL)

        * Add `-b' option to prohibit breaking of long lines into multiple
        physical lines using DCL line continuation conventions.  Changed
        sdcl.c:`main()' and output.c:`putstr()' to set and look at the
        flag `break_lines_flag'.

Fri Jul 14 10:17:27 1989    (TKB at MPL)

        * Version 1.3 released.

        * lex.c: Add `scan_tok_eol()' for use with "break <int>" and
        "next <int>" forms.

        * stack.c: Change `peek()' to return correct item from stack (it
        wasn't stepping down through the stack properly) and got rid of
        error message in `peek()' when it was called to look at something
        that was deeper than the stack was deep (underflow), since
        that condition causes a FALSE to be returned that the calling
        function can test.

        * parser.c: Change `break_stmt()' and `next_stmt()' to handling
        constructs like "break 2" and "next 5".  The integer *must* be on
        the same line as the "break" or "next".

        Change `dcl_line()' to `dcl_stmt()'.

        * sdcl.c: Add function `error_line()', which is like `error()'
        except that it takes as its parameter the line number to use when
        reporting the the error.  Used in `break_stmt()' and `next_stmt()'
        where the line number may be off due to looking ahead for an
        option integer count.

        * lextab.c: Change `char_to_class[]' so '%' is undefined and '?'
        is `LC_QUESTION'.

        * codes.h: Change `LC_PERCENT' to `LC_QUESTION' and `TC_DCLLINE'
        to `TC_DCLSTMT'.  This makes is so we can use '?' instead of '%'
        to indicate a statement that is to be passed through to the output
        file relatively untouched.  Since this is actually a statement
        rather than a line, we will call it such.

Thu Jul 13 13:29:37 1989    (TKB at MPL)

        * Version 1.2 released.

        * lex.c: Add "until" to list of keywords in `identify()' so it
        will be recognized as a keyword by the lexical analysis.

Fri May 19 18:22:25 1989    (TKB at MPL)

        * parser.c: Change `break()' and `next()' to use new version of
        `peek()'.

        * stack.c: Change arrangement of the stack so that a count of
        items is kept up-to-date.  Change `peek()' to take a new
        parameter, indicating the depth of the item to peek at.

Fri Apr 21 18:50:05 1989    (TKB at MPL)

        * Version 1.1 released.
        
        * sdcl.c and version.c: changed `version' to `version_string'.

        * sdcl.c (main): add reporting of input and output lines per file
        when `-v' option is used.  Input line numbers are now added into
        the total correctly (line numbers start at 1, so after EOF they
        are always one too many).

        * lex.c: Defined `newchar()' to get a new character when needed
        and hide the incrementing of line numbers if the last character
        was a newline.  This is to ensure that input line numbers are
        correct in error messages. Previously the input line numbers in
        error messages were often incorrect because the input line number
        was only being incremented when a newline TOKEN was being returned
        (stupid, stupid), but newlines on backslash continued lines were
        NOT being counted.

        * output.c: Make `putstr' output white-space before the
        continuation character when it finds it necessary to break a long
        line. Make `putstr' add linebreaks inserted by the continuation of
        long lines to the output line counter, so that the number of lines
        output is correct.

Tue Apr 11 20:40:34 1989    (TKB at MPL)

        * Version 1.0 of SDCL in C released.  Supports break, do-while
        loop, for loop, if-else, repeat loop, while loop, and lines
        relatively untouched by SDCL.


Local Variables:
fill-prefix: "        "
End:
#-h- build_sdcl.com  1018  bin  12-aug-24 09:39:48  tkb ()
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

#-h- compile_link.com 367  bin  12-aug-24 09:39:48  tkb ()
$ where = f$environment("PROCEDURE")
$ where = f$parse(where,,, "DEVICE") + f$parse(where,,, "DIRECTORY")
$ set def 'where'
$ cc -c -g getopt.c
$ cc -c -g lex.c
$ cc -c -g output.c
$ cc -c -g parser.c
$ cc -c -g sdcl.c
$ cc -c -g stack.c
$ cc -c -g version.c
$ cc -c -g ioinit.c
$ cc -g  getopt.o lex.o output.o parser.o sdcl.o stack.o version.o ioinit.o -o sdcl.exe
#-h- count_srcs.com    81  asc  12-aug-24 09:39:48  tkb ()
$ owc *.txt *.com *.h *.c makefile. *.rst *.rno *.scn *.table *.text .indent_pro
#-h- make_sdcl.com    150  bin  12-aug-24 09:39:49  tkb ()
$ root = f$environment("PROCEDURE")
$ dir_spec = f$parse(root,,,"DEVICE") + f$parse(root,,,"DIRECTORY")
$ set def 'dir_spec'
$ makecom ml:make
$ make
#-h- sdcl_setup.com   381  asc  12-aug-24 10:42:36  tkb ()
$ where = f$environment("PROCEDURE")
$ where = f$parse(where,,, "DEVICE") + f$parse(where,,, "DIRECTORY")
$ root = where - "]"
$ define sdcl_dir 'where'
$ sdcl :== $sdcl_dir:sdcl.exe
$ rawsdcl :== $sdcl_dir:sdcl.exe
$! This SDCL command procedure remembers what SDCL procedure you
$! compiled last, so you don't have to.  Uncomment it to use.
$! sdcl :== @'root'.examples]sdcl.com
#-h- stripcrlf.com    747  asc  12-aug-24 09:39:49  tkb ()
$!> STRIPCRLF.COM -- Strip CR LF pairs off lines in a .MEM file.
$       usage = "Usage: @STRIPCRLF.COM input-file [output-file]"
$       crlf[0,8] = 13
$       crlf[8,8] = 10
$!
$       if p1 .eqs. ""
$       then 
$           write sys$error usage
$           exit 1
$       endif
$       if p2 .nes. ""
$       then
$           outfilename = p2
$           open/write outfile 'outfilename'
$       else
$           define outfile sys$output
$       endif
$!
$       open/read infile 'p1'
$       i = 0
$ 10$:  read/end=19$ infile s
$       i = i + 1
$       pos = f$locate (crlf, s)
$       t = f$extract (0, pos, s)
$       write outfile t
$       !if i .gt. 10 then goto 19$
$       goto 10$
$ 19$:
$       close infile
$       close outfile
#-h- codes.h         1442  bin  12-aug-24 09:39:49  tkb ()
/* codes.h -- made by sstg_to_c 2.0 from sdcl.scn (by way of sdcl.table created by sstg 2.0) */

/* Character Classes */
#define LT_BACKSLASH (0)
#define LT_BANG (1)
#define LT_CBRACE (2)
#define LT_COLON (3)
#define LT_CPAREN (4)
#define LT_DIGIT (5)
#define LT_DOLLAR (6)
#define LT_EOF (7)
#define LT_EOL (8)
#define LT_EQUAL (9)
#define LT_LETTER (10)
#define LT_OBRACE (11)
#define LT_OPAREN (12)
#define LT_SLASH (13)
#define LT_POUND (14)
#define LT_DQUOTE (15)
#define LT_SEMI (16)
#define LT_SPACE (17)
#define LT_UNDER (18)
#define LT_UNDEFINED (19)

/* Action Codes */
#define AC_ADDGET (0)
#define AC_IGNGET (1)
#define AC_IGNNOP (2)
#define AC_IGNERR (3)
#define AC_IGNINL (4)
#define AC_BLKGET (5)
#define AC_KILGET (6)

/* Token Codes */
#define TC_ASSIGN (0)
#define TC_COLON (1)
#define TC_EOF (2)
#define TC_EOL (3)
#define TC_IDENT (4)
#define TC_INTEGER (5)
#define TC_LABEL (6)
#define TC_SINGLE (7)
#define TC_SPACE (8)
#define TC_STRING (9)
#define TC_CBRACE (10)
#define TC_CPAREN (11)
#define TC_DCLSTMT (12)
#define TC_OBRACE (13)
#define TC_OPAREN (14)
#define TC_OTHER (15)
#define TC_QUOTED (16)
#define TC_SEMI (17)
#define TC_BREAK (18)
#define TC_DO (19)
#define TC_ELSE (20)
#define TC_FOR (21)
#define TC_IF (22)
#define TC_NEXT (23)
#define TC_REPEAT (24)
#define TC_UNTIL (25)
#define TC_WHILE (26)
#define TC_UNKNOWN (27)

/* Start state */
#define ST_START (1)

/* Accept State */
#define ST_ACCEPT (0)

#-h- lextab.h       14792  bin  12-aug-24 09:39:49  tkb ()
/* lextab.h -- made by sstg_to_c 2.0 from sdcl.scn (by way of sdcl.table created by sstg 2.0) */

/* Array for translating characters to character classes */
short char_to_class[128] = {
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_SPACE,
    LT_EOL,
    LT_UNDEFINED,
    LT_SPACE,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_SPACE,
    LT_BANG,
    LT_DQUOTE,
    LT_POUND,
    LT_DOLLAR,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_OPAREN,
    LT_CPAREN,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_SLASH,
    LT_DIGIT,
    LT_DIGIT,
    LT_DIGIT,
    LT_DIGIT,
    LT_DIGIT,
    LT_DIGIT,
    LT_DIGIT,
    LT_DIGIT,
    LT_DIGIT,
    LT_DIGIT,
    LT_COLON,
    LT_SEMI,
    LT_UNDEFINED,
    LT_EQUAL,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_UNDEFINED,
    LT_BACKSLASH,
    LT_UNDEFINED,
    LT_UNDEFINED,
    LT_UNDER,
    LT_UNDEFINED,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_LETTER,
    LT_OBRACE,
    LT_UNDEFINED,
    LT_CBRACE,
    LT_UNDEFINED,
    LT_UNDEFINED,
};

/* Array for translating states to return token codes */
short state_to_tc[25] = {
    TC_UNKNOWN,
    TC_UNKNOWN,
    TC_EOF,
    TC_EOL,
    TC_IDENT,
    TC_SPACE,
    TC_STRING,
    TC_STRING,
    TC_OBRACE,
    TC_CBRACE,
    TC_OPAREN,
    TC_CPAREN,
    TC_UNKNOWN,
    TC_UNKNOWN,
    TC_UNKNOWN,
    TC_QUOTED,
    TC_INTEGER,
    TC_SINGLE,
    TC_SEMI,
    TC_EOL,
    TC_SINGLE,
    TC_DCLSTMT,
    TC_OTHER,
    TC_COLON,
    TC_ASSIGN,
};

/* Lexical error message strings */
char *state_error[25] = {
    "transition from accept state",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "unterminated string",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "unexpected end of file after continuation character",
    "unexpected end of file after continuation character",
    "unexpected end of file after continuation character",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
    "improper action",
};

/* Goto matrix -- matrix of state transitions */
short nextstate[25][20] = {
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,

    12,
    22,
    9,
    23,
    11,
    16,
    20,
    2,
    3,
    20,
    4,
    8,
    10,
    17,
    19,
    6,
    18,
    5,
    4,
    20,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    4,
    4,
    0,
    0,
    0,
    4,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    4,
    0,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    5,
    0,
    0,

    6,
    6,
    6,
    6,
    6,
    6,
    6,
    0,
    0,
    6,
    6,
    6,
    6,
    6,
    6,
    7,
    6,
    6,
    6,
    6,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    6,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    15,
    15,
    15,
    15,
    15,
    15,
    15,
    1,
    13,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    15,
    13,
    15,
    15,

    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    13,
    1,
    1,
    1,
    1,
    1,
    14,
    1,
    1,
    13,
    1,
    1,

    14,
    14,
    14,
    14,
    14,
    14,
    14,
    1,
    13,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    14,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    16,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    21,
    0,
    0,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    19,
    19,
    19,
    19,
    19,
    19,
    19,
    0,
    0,
    19,
    19,
    19,
    19,
    19,
    19,
    19,
    19,
    19,
    19,
    19,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    21,
    21,
    21,
    21,
    21,
    21,
    21,
    0,
    0,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,
    21,

    22,
    22,
    22,
    22,
    22,
    22,
    22,
    0,
    0,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,
    22,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    24,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,

};

/* Action matrix -- matrix of actions for (state, class) pairs */
short nextaction[25][20] = {
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,
    AC_IGNERR,

    AC_IGNGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_IGNNOP,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_IGNGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_BLKGET,
    AC_ADDGET,
    AC_ADDGET,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_ADDGET,
    AC_ADDGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_ADDGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_ADDGET,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNGET,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_IGNERR,
    AC_IGNERR,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_ADDGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_IGNERR,
    AC_IGNGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_IGNGET,
    AC_ADDGET,
    AC_ADDGET,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNERR,
    AC_IGNGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNGET,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNERR,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_ADDGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_KILGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNINL,
    AC_ADDGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,
    AC_IGNGET,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,

    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,
    AC_ADDGET,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_ADDGET,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,
    AC_IGNNOP,

};
#-h- sdcl.h          1281  bin  12-aug-24 09:39:50  tkb ()
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
#-h- getopt.c       16573  bin  12-aug-24 09:39:50  tkb ()
/* Getopt for GNU.
   Copyright (C) 1987 Free Software Foundation, Inc.

		       NO WARRANTY

  BECAUSE THIS PROGRAM IS LICENSED FREE OF CHARGE, WE PROVIDE ABSOLUTELY
NO WARRANTY, TO THE EXTENT PERMITTED BY APPLICABLE STATE LAW.  EXCEPT
WHEN OTHERWISE STATED IN WRITING, FREE SOFTWARE FOUNDATION, INC,
RICHARD M. STALLMAN AND/OR OTHER PARTIES PROVIDE THIS PROGRAM "AS IS"
WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY
AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE PROGRAM PROVE
DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR
CORRECTION.

 IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW WILL RICHARD M.
STALLMAN, THE FREE SOFTWARE FOUNDATION, INC., AND/OR ANY OTHER PARTY
WHO MAY MODIFY AND REDISTRIBUTE THIS PROGRAM AS PERMITTED BELOW, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY LOST PROFITS, LOST MONIES, OR
OTHER SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR
DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY THIRD PARTIES OR
A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS) THIS
PROGRAM, EVEN IF YOU HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGES, OR FOR ANY CLAIM BY ANY OTHER PARTY.

		GENERAL PUBLIC LICENSE TO COPY

  1. You may copy and distribute verbatim copies of this source file
as you receive it, in any medium, provided that you conspicuously and
appropriately publish on each copy a valid copyright notice "Copyright
 (C) 1987 Free Software Foundation, Inc."; and include following the
copyright notice a verbatim copy of the above disclaimer of warranty
and of this License.  You may charge a distribution fee for the
physical act of transferring a copy.

  2. You may modify your copy or copies of this source file or
any portion of it, and copy and distribute such modifications under
the terms of Paragraph 1 above, provided that you also do the following:

    a) cause the modified files to carry prominent notices stating
    that you changed the files and the date of any change; and

    b) cause the whole of any work that you distribute or publish,
    that in whole or in part contains or is a derivative of this
    program or any part thereof, to be licensed at no charge to all
    third parties on terms identical to those contained in this
    License Agreement (except that you may choose to grant more
    extensive warranty protection to third parties, at your option).

    c) You may charge a distribution fee for the physical act of
    transferring a copy, and you may at your option offer warranty
    protection in exchange for a fee.

  3. You may copy and distribute this program or any portion of it in
compiled, executable or object code form under the terms of Paragraphs
1 and 2 above provided that you do the following:

    a) cause each such copy to be accompanied by the
    corresponding machine-readable source code, which must
    be distributed under the terms of Paragraphs 1 and 2 above; or,

    b) cause each such copy to be accompanied by a
    written offer, with no time limit, to give any third party
    free (except for a nominal shipping charge) a machine readable
    copy of the corresponding source code, to be distributed
    under the terms of Paragraphs 1 and 2 above; or,

    c) in the case of a recipient of this program in compiled, executable
    or object code form (without the corresponding source code) you
    shall cause copies you distribute to be accompanied by a copy
    of the written offer of source code which you received along
    with the copy you received.

  4. You may not copy, sublicense, distribute or transfer this program
except as expressly provided under this License Agreement.  Any attempt
otherwise to copy, sublicense, distribute or transfer this program is void and
your rights to use the program under this License agreement shall be
automatically terminated.  However, parties who have received computer
software programs from you with this License Agreement will not have
their licenses terminated so long as such parties remain in full compliance.

  5. If you wish to incorporate parts of this program into other free
programs whose distribution conditions are different, write to the Free
Software Foundation at 675 Mass Ave, Cambridge, MA 02139.  We have not yet
worked out a simple rule that can be stated here, but we will often permit
this.  We will be guided by the two goals of preserving the free status of
all derivatives of our free software and of promoting the sharing and reuse of
software.


In other words, you are welcome to use, share and improve this program.
You are forbidden to forbid anyone else to use, share and improve
what you give them.   Help stamp out software-hoarding!  */

/* This version of `getopt' appears to the caller like standard Unix `getopt'
   but it behaves differently for the user, since it allows the user
   to intersperse the options with the other arguments.

   As `getopt' works, it permutes the elements of `argv' so that,
   when it is done, all the options precede everything else.  Thus
   all application programs are extended to handle flexible argument order.

   Setting the environment variable _POSIX_OPTION_ORDER disables permutation.
   Then the behavior is completely standard.

   GNU application programs can use a third alternative mode in which
   they can distinguish the relative order of options and other arguments.  */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* For communication from `getopt' to the caller.
   When `getopt' finds an option that takes an argument,
   the argument value is returned here.
   Also, when `ordering' is RETURN_IN_ORDER,
   each non-option ARGV-element is returned here.  */

char *optarg = 0;

/* Index in ARGV of the next element to be scanned.
   This is used for communication to and from the caller
   and for communication between successive calls to `getopt'.

   On entry to `getopt', zero means this is the first call; initialize.

   When `getopt' returns EOF, this is the index of the first of the
   non-option elements that the caller should itself scan.

   Otherwise, `optind' communicates from one call to the next
   how much of ARGV has been scanned so far.  */

int optind = 0;

/* The next char to be scanned in the option-element
   in which the last option character we returned was found.
   This allows us to pick up the scan where we left off.

   If this is zero, or a null string, it means resume the scan
   by advancing to the next ARGV-element.  */

static char *nextchar;

/* Callers store zero here to inhibit the error message
   for unrecognized options.  */

int opterr = 1;

/* Describe how to deal with options that follow non-option ARGV-elements.

   UNSPECIFIED means the caller did not specify anything;
   the default is then REQUIRE_ORDER if the environment variable
   _OPTIONS_FIRST is defined, PERMUTE otherwise.

   REQUIRE_ORDER means don't recognize them as options.
   Stop option processing when the first non-option is seen.
   This is what Unix does.

   PERMUTE is the default.  We permute the contents of `argv' as we scan,
   so that eventually all the options are at the end.  This allows options
   to be given in any order, even with programs that were not written to
   expect this.

   RETURN_IN_ORDER is an option available to programs that were written
   to expect options and other ARGV-elements in any order and that care about
   the ordering of the two.  We describe each non-option ARGV-element
   as if it were the argument of an option with character code zero.
   Using `-' as the first character of the list of option characters
   requests this mode of operation.

   The special argument `--' forces an end of option-scanning regardless
   of the value of `ordering'.  In the case of RETURN_IN_ORDER, only
   `--' can cause `getopt' to return EOF with `optind' != ARGC.  */

static enum { REQUIRE_ORDER, PERMUTE, RETURN_IN_ORDER } ordering;

/* Handle permutation of arguments.  */

/* Describe the part of ARGV that contains non-options that have
   been skipped.  `first_nonopt' is the index in ARGV of the first of them;
   `last_nonopt' is the index after the last of them.  */

static int first_nonopt;
static int last_nonopt;

/* Exchange two adjacent subsequences of ARGV.
   One subsequence is elements [first_nonopt,last_nonopt)
    which contains all the non-options that have been skipped so far.
   The other is elements [last_nonopt,optind), which contains all
    the options processed since those non-options were skipped.

   `first_nonopt' and `last_nonopt' are relocated so that they describe
    the new indices of the non-options in ARGV after they are moved.  */

static void
exchange (argv)
     char **argv;
{
  int nonopts_size
    = (last_nonopt - first_nonopt) * sizeof (char *);
  char **temp = (char **) malloc (nonopts_size);

  /* Interchange the two blocks of data in argv.  */

  memmove (temp, &argv[first_nonopt], nonopts_size);
  memmove (&argv[first_nonopt], &argv[last_nonopt], 
           (optind - last_nonopt) * sizeof (char *));
  memmove (&argv[first_nonopt + optind - last_nonopt], temp,
           nonopts_size);

  /* Update records for the slots the non-options now occupy.  */

  first_nonopt += (optind - last_nonopt);
  last_nonopt = optind;
  free (temp);
}

/* Scan elements of ARGV (whose length is ARGC) for option characters
   given in OPTSTRING.

   If an element of ARGV starts with '-', and is not exactly "-" or "--",
   then it is an option element.  The characters of this element
   (aside from the initial '-') are option characters.  If `getopt'
   is called repeatedly, it returns successively each of theoption characters
   from each of the option elements.

   If `getopt' finds another option character, it returns that character,
   updating `optind' and `nextchar' so that the next call to `getopt' can
   resume the scan with the following option character or ARGV-element.

   If there are no more option characters, `getopt' returns `EOF'.
   Then `optind' is the index in ARGV of the first ARGV-element
   that is not an option.  (The ARGV-elements have been permuted
   so that those that are not options now come last.)

   OPTSTRING is a string containing the legitimate option characters.
   A colon in OPTSTRING means that the previous character is an option
   that wants an argument.  The argument is taken from the rest of the
   current ARGV-element, or from the following ARGV-element,
   and returned in `optarg'.

   If an option character is seen that is not listed in OPTSTRING,
   return '?' after printing an error message.  If you set `opterr' to
   zero, the error message is suppressed but we still return '?'.

   If a char in OPTSTRING is followed by a colon, that means it wants an arg,
   so the following text in the same ARGV-element, or the text of the following
   ARGV-element, is returned in `optarg.  Two colons mean an option that
   wants an optional arg; if there is text in the current ARGV-element,
   it is returned in `optarg'.

   If OPTSTRING starts with `-', it requests a different method of handling the
   non-option ARGV-elements.  See the comments about RETURN_IN_ORDER, above.  */

int
getopt (argc, argv, optstring)
     int argc;
     char **argv;
     char *optstring;
{
  /* Initialize the internal data when the first call is made.
     Start processing options with ARGV-element 1 (since ARGV-element 0
     is the program name); the sequence of previously skipped
     non-option ARGV-elements is empty.  */

  if (optind == 0)
    {
      first_nonopt = last_nonopt = optind = 1;

      nextchar = 0;

      /* Determine how to handle the ordering of options and nonoptions.  */

      if (optstring[0] == '-')
	ordering = RETURN_IN_ORDER;
      else if (getenv ("_POSIX_OPTION_ORDER") != 0)
	ordering = REQUIRE_ORDER;
      else
	ordering = PERMUTE;
    }

  if (nextchar == 0 || *nextchar == 0)
    {
      if (ordering == PERMUTE)
	{
	  /* If we have just processed some options following some non-options,
	     exchange them so that the options come first.  */

	  if (first_nonopt != last_nonopt && last_nonopt != optind)
	    exchange (argv);
	  else if (last_nonopt != optind)
	    first_nonopt = optind;

	  /* Now skip any additional non-options
	     and extend the range of non-options previously skipped.  */

	  while (optind < argc
		 && (argv[optind][0] != '-'
		     || argv[optind][1] == 0))
	    optind++;
	  last_nonopt = optind;
	}

      /* Special ARGV-element `--' means premature end of options.
	 Skip it like a null option,
	 then exchange with previous non-options as if it were an option,
	 then skip everything else like a non-option.  */

      if (optind != argc && !strcmp (argv[optind], "--"))
	{
	  optind++;

	  if (first_nonopt != last_nonopt && last_nonopt != optind)
	    exchange (argv);
	  else if (first_nonopt == last_nonopt)
	    first_nonopt = optind;
	  last_nonopt = argc;

	  optind = argc;
	}

      /* If we have done all the ARGV-elements, stop the scan
	 and back over any non-options that we skipped and permuted.  */

      if (optind == argc)
	{
	  /* Set the next-arg-index to point at the non-options
	     that we previously skipped, so the caller will digest them.  */
	  if (first_nonopt != last_nonopt)
	    optind = first_nonopt;
	  return EOF;
	}
	 
      /* If we have come to a non-option and did not permute it,
	 either stop the scan or describe it to the caller and pass it by.  */

      if (argv[optind][0] != '-' || argv[optind][1] == 0)
	{
	  if (ordering == REQUIRE_ORDER)
	    return EOF;
	  optarg = argv[optind++];
	  return 0;
	}

      /* We have found another option-ARGV-element.
	 Start decoding its characters.  */

      nextchar = argv[optind] + 1;
    }

  /* Look at and handle the next option-character.  */

  {
    char c = *nextchar++;
    char *temp = (char *) strchr (optstring, c);

    /* Increment `optind' when we start to process its last character.  */
    if (*nextchar == 0)
      optind++;

    if (temp == 0 || c == ':')
      {
	if (opterr != 0)
	  {
	    if (c < 040 || c >= 0177)
	      fprintf (stderr, "%s: unrecognized option, character code 0%o\n",
		       argv[0], c);
	    else
	      fprintf (stderr, "%s: unrecognized option `-%c'\n",
		       argv[0], c);
	  }
	return '?';
      }
    if (temp[1] == ':')
      {
	if (temp[2] == ':')
	  {
	    /* This is an option that accepts an argument optionally.  */
	    if (*nextchar != 0)
	      {
	        optarg = nextchar;
		optind++;
	      }
	    else
	      optarg = 0;
	    nextchar = 0;
	  }
	else
	  {
	    /* This is an option that requires an argument.  */
	    if (*nextchar != 0)
	      {
		optarg = nextchar;
		/* If we end this ARGV-element by taking the rest as an arg,
		   we must advance to the next element now.  */
		optind++;
	      }
	    else if (optind == argc)
	      {
		if (opterr != 0)
		  fprintf (stderr, "%s: no argument for `-%c' option\n",
			   argv[0], c);
		optarg = 0;
	      }
	    else
	      /* We already incremented `optind' once;
		 increment it again when taking next ARGV-elt as argument.  */
	      optarg = argv[optind++];
	    nextchar = 0;
	  }
      }
    return c;
  }
}

#ifdef TEST

/* Compile with -DTEST to make an executable for use in testing
   the above definition of `getopt'.  */

int
main (argc, argv)
     int argc;
     char **argv;
{
  char c;
  int digit_optind = 0;

  while (1)
    {
      int this_option_optind = optind;
      if ((c = getopt (argc, argv, "abc:d:0123456789")) == EOF)
	break;

      switch (c)
	{
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':
	  if (digit_optind != 0 && digit_optind != this_option_optind)
	    printf ("digits occur in two different argv-elements.\n");
	  digit_optind = this_option_optind;
	  printf ("option %c\n", c);
	  break;

	case 'a':
	  printf ("option a\n");
	  break;

	case 'b':
	  printf ("option b\n");
	  break;

	case 'c':
	  printf ("option c with value `%s'\n", optarg);
	  break;

	case '?':
	  break;

	default:
	  printf ("?? getopt returned character code 0%o ??\n", c);
	}
    }

  if (optind < argc)
    {
      printf ("non-option ARGV-elements: ");
      while (optind < argc)
	printf ("%s ", argv[optind++]);
      printf ("\n");
    }

  return 0;
}

#endif /* TEST */
#-h- ioinit.c        9382  bin  12-aug-24 09:39:51  tkb ()
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
#include <stdlib.h>

extern char *strcpy(), *strchr(), *strrchr();
extern void *malloc(), *realloc(), free();
extern int strlen();

static int u_reopen();

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
	exit(EXIT_FAILURE);
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
	    exit(EXIT_FAILURE);
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
#-h- lex.c           4574  bin  12-aug-24 09:39:51  tkb ()
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
#-h- output.c        1671  bin  12-aug-24 09:39:52  tkb ()
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
#-h- parser.c       12523  bin  12-aug-24 09:39:52  tkb ()
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

static int label = 23000;

/* reinitlabels -- Reinitialize label numbers. */
void
reinitlabels(void)
{
  label = 23000;
}


/* genlab -- generate `n' labels */
int 
genlab(int n)
{
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
#-h- sdcl.c          7759  bin  12-aug-24 09:39:53  tkb ()
/* sdcl.c -- this file contains the main function and several other functions
   used in several places */

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

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
int out_flag = FALSE;		/* normally get output name from input name */
int verbose_flag = FALSE;	/* print more information */

extern char *version_string;	/* version string, from version.c */

/* external declarations for `getopt' */
extern int getopt(int, char **, char *);
extern char *optarg;
extern int optind;

char *getoutname(char *);	/* forward declaration */
void usage (void);


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
    while ((c = getopt(argc, argv, "bho:v")) != EOF) {
	switch (c) {
	case 'b':
	    break_lines_flag = 0;	/* don't break long lines */
	    break;
        case 'h':
            usage ();
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
        /* Reinitialize label numbers if not outputing everything to a
           single file. */
        if (! out_flag)
          reinitlabels();

	program();		/* parse a SDCL program */

	nfiles++;

	/* reports some statistics for the current file */
	if (verbose_flag) {
	    message("%8d input lines from %s\n\
%8d output lines written to %s\n\n",
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
	exit(EXIT_FAILURE);
    exit(EXIT_SUCCESS);
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

    if (start = strrchr(s, ']'))
	start++;		/* start with next char */
    else if (start = strrchr(s, ':'))
	start++;		/* start with next char */
    else			/* no logical or directory, use whole name */
	start = s;
    if (!(end = strrchr(start, '.')))
	end = strchr(start, '\0');

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

void
usage (void)
{
    fprintf(stderr,
            "usage: sdcl [-b] [-v] [-h] [-o outfile] [infiles ...]\n\
\n\
Options:\n\
\n\
        -b      Do not insert DCL line continuation sequences in long\n\
                lines.  By default, SDCL inserts continuation\n\
                sequences to break long lines into seperate physical\n\
                lines for readability.\n\
\n\
        -h      Show the help message.\n\
\n\
        -o      Specifies the output file name, which must follow it\n\
                immediately or seperated by whitespace.\n\
\n\
        -v      Produce verbose output.\n\
\n\
        Input and Output Files:\n\
\n\
        If no output file is specified, each input file is processed\n\
        and written out seperately to files in the current directory.\n\
        These files have the same name as their corresponding input\n\
        file, except that `.com' is substituted for whatever followed\n\
        the last period in the input file name.  If an output file is\n\
        specified, all the input files are processed and all the\n\
        results are written out to the specified output file.  If no\n\
        input files are specified, the standard input is read.  If no\n\
        input files are specified and no output file is specified, the\n\
        input is taken from the standard input and the output is\n\
        written to the standard output, allowing SDCL to be used as a\n\
        filter in a pipe.\n\
\n\
        Unix-style i/o redirection using \"<\", \">\", \">>\", \"2>\", and\n\
        \"2>>\".  is supported, as are VMS wildcards.\n");
    exit (EXIT_SUCCESS);
}
#-h- stack.c         2853  bin  12-aug-24 09:39:54  tkb ()
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
#-h- version.c         87  bin  12-aug-24 09:39:55  tkb ()
/* version.c -- Version number of SDCL preprocessor */
char *version_string = "1.5.2";
#-h- makefile         963  bin  12-aug-24 09:39:55  tkb ()
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

#-h- readme.rst      1847  bin  15-aug-24 08:51:45  tkb ()
SDCL -- Structured DCL
@@@@@@@@@@@@@@@@@@@@@@

This version of SDCL is a complete rewrite from scratch, inspired by
the original SDCL written by Sohail Aslam, of the University of
Colorado at Colorado Springs, which was available from the DECUS
program library as VAX-143.

To run SDCL you need to set it up as a foreign comment, like this:

	$ sdcl :== $dev:[dir]sdcl

where `dev' is the device SDCL is on and `dir' is the directory it is
in.  

The command procedure SDCL_SETUP.COM sets that up.  Look at it for
the option to use RAWSDCL for the executable and SDCL for an SDCL.COM
command procedure from the [.EXAMPLES] directory.

To rebuild SDCL just execute the file BUILD_SDCL.COM (which assumes
you are using the VAX C Compiler; if you are using the GNU C
compiler, execute BUILD_SDCL.COM with a first parameter of "GCC").

**2022 Note:** If you have MMS or MMK_ you can build with them using
DESCRIP.MMS instead.  DESCRIP.MMS assumes you are using the VAX port
of GCC 2.7.1, but should be easy to adapt to VAX/VMS C To rebuild
completely from scratch you need SSTG_, a Simple Scanner Table
Generator, to generate CODES.H and LEXTAB.H from SDCL.TABLE, which is
generated from SDCL.SCN.

The file TODO.ORG in this directory lists things that need to be done to
improve SDCL.  PROBLEMS. is a list of problems in the SDCL
implementation, mostly fixed.  Documentation for SDCL is in SDCL.MAN.
The files in [.EXAMPLES] are example command procedures written in
SDCL.  The files in [.TESTS] for testing SDCL.  

The file ioinit.c was distrubted as part of another program on a DECUS 
tape.  Unfortuantely I don't remember which one, or who to credit it 
to.

.. _MMK: https://vms.process.com/scripts/fileserv/fileserv_search.exe?package=mmk&description=&author=&system=Either&language=All&RD=&RM=&RY=
.. _SSTG: https://github.com/tkurtbond/sstg
#-h- sdcl.rno        8649  asc  13-aug-24 17:21:19  tkb ()
.NO FLAGS LOWERCASE
.PAGE SIZE 62,66
.IF NOPAGING
.NO PAGING
.ELSE NOPAGING
.! Set up running headers
.TITLE sdcl -- Structured DCL preprocessor
.ENDIF NOPAGING
.SET PARAGRAPH 0
.STYLE HEADERS , 0
.LM 8
.RM 72
.I -8
Name
.S
sdcl -- Structured DCL preprocessor
.S
.I -8
Synopsis
.S
sdcl  [-b] [-h] [-v] [-o outfile] [input-file ...]
.S
.I -8
Description
.P
SDCL is a structured DCL preprocessor, in the tradition of
RATFOR: it adds several control structures to DCL, such as
break statement, do-while loops, the if-else statement, the
next statement, repeat loops, and while loops.
.S
.I -8
Options
.S
.LM +8
.I -8
-b######Do not insert DCL line continuation sequences in long
lines.  By default, SDCL inserts continuation
sequences to break long lines into seperate physical
lines for readability.
.S
.I -8
-h######Display the help message.
.S
.I -8
-o######Specifies the output file name, which must follow it
immediately or seperated by whitespace.
.S
.I -8
-v######Produce verbose output.
.S
.LM -8
.I -8
Input and Output Files
.P
If no output file is specified, each input file is processed
and written out seperately to files in the current directory.
These files have the same name as their corresponding input
file, except that ".COM" is substituted for whatever followed
the last period in the input file name.  Label renumbering
starts over at at 23000 for every new output file.
.P
If an output file is specified, all the input files are
processed and all the results are written out to the specified
output file.
.P
If no input files are specified, the standard input is read.
.P
If no input files are specified and no output file is
specified, the input is taken from the standard input and the
output is written to the standard output, allowing SDCL to be
used as a filter in a pipe.
.P
Unix-style i/o redirection using "<", ">", ">>", "2>", and
"2>>"  is supported, as are VMS wildcards.
.IFNOT NOPAGING
.PAGE
.ELSE NOPAGING
.S
.ENDIF NOPAGING
.I -8
SDCL Language
.P
The BNF for SDCL is as follows; the non-terminals are in angle
brackets (<>).
.S
.LT
<program>   : <statement>
            | <program> <statement>
<statement> : if (<condition>) <statement>
            | if (<condition>) <statement> else <statement>
            | while (<condition>) <statement>
            | for (<intialize> ; <condition> ; <reinitalize>)
                  <statement>
            | do <statement> while (<condition>)
            | repeat <statement> until (<condition>)
            | repeat <statement>
            | break <integer>
            | break
            | next <integer>
            | next
            | { <program> }
            | <label>: <statement>
            | <other>
            | //<DCL inclusion>
.EL
.S
.i -8
Language Notes
.LS
.LE
Lines do not start with the dollar sign ($), unlike DCL.
.LE
Comments start with the pound sign (_#) and extend to the end
of the line.
.LE
Labels consist of a letter or underscore followed by zero or
more letters, dollar signs, digits, or underscores.
Whitespace may seperate the label from the colon, but the
colon must be on the same line as the label.  Note that in the
statement
.S
.LM +4
.LT
ds :== dir/size=all/width=(filename=40)
.EL
.LM -4
.S
the "ds :" is *NOT* a label, because the colon is part of the
":==" token.  SDCL handles this case correctly as one
statement, not as a label followed by a statement beginning
with "==".
.P
Note that SDCL does not recognize the DCL label "100$:"
because it starts with a digit, rather than a letter or
underscore, so any SDCL constructs that appear on that line
will not be recognized.  Such labels may still be used, but
they must not appear on the same line as an SDCL construct.
.P
The labels that SDCL uses internally consist of decimal
numbers starting with 23000.  Avoid using such labels in your
own programs.  When output is being written to multiple files
the labels will start over at 23000 with each output file.  When
output is being to one file the line numbers DO NOT start over
for each input file!
.LE
Multiple statements can be enclosed between braces ({}) to
make a compound statement.
.LE
SDCL keywords and braces are only recognized as the first
word of a DCL command.  This means that, given
.S
.LM +4
.LT
wso :== write sys$output
.EL
.LM -4
.S
then
.S
.LM +4
.LT
if (c1) if (c2) wso "inside cond2 true"
.EL
.LM -4
.S
is legal, but
.S
.LM +4
.LT
if (c1) if (c2) wso "cond2 true" else wso "cond2 false"
.EL
.LM -4
.S
is not legal, because the else keyword is not recognized.
.P
It also means that
.S
.LM +4
.LT
if (cond) { wso "cond true" } else { wso "cond false" }
.EL
.LM -4
.S
is not legal because the first "}" is not recognized.
.P
(Otherwise you couldn't use keywords or braces in DCL commands
in SDCL, like write sys$output "{here!}")
.LE
Multiple line <initialize> and <reinitialize> clauses in a 
for loop are legal, like this:
.S
.LM +4
.LT
for (i = 0
     s = ""; 
     i .lt. 10;
     i = i + 1
     s = s + ".")
    write sys$output "i: ", i, " s: ", s
write sys$output "at end: i: ", i, " s: ", s
.EL
.LM -4
.LE
The break statement without an integer argument exits the
immediately enclosing loop.  With an integer argument of n, it
exits the n'th enclosing loop.  The integer argument MUST be
on the same line as the "break".  (Rationale: that way
SDCL doesn't go looking across lines and possibly finding the
integer that begins a label on the next line.)
.LE
The next statement without an integer argument starts the
next iteration of the immediately enclosing loop, starting at
the test of the continuation condition for the loop, if any.
With an integer argument of n, it starts the next iteration of
the n'th enclosing loop.  The integer argument MUST be on the
same line as the "next". (Rationale: that way SDCL doesn't
go looking across lines and possibly finding the integer that
begins a label on the next line.)
.LE
The repeat loop without an until part repeats forever.
.LE
<other> statements are anything not otherwise recognized by
SDCL.  If SDCL does not recognize the first token in a
statement, that statement is assumed to be an <other>, and
tokens are output until the end of the statement (which is the
end of the logical line, taking into account backslash line
continuation).  The statement is emitted preceded by a dollar
sign ($) and with appropriate continuation lines if it is more
than 80 characters long.
.LE
Lines may be continued with the backslash character (\). A
backslash followed by whitespace (blanks or tabs, possibly
including a comment after the first whitespace character) and
a newline indicates that the line is continued.  If the
whitespace is terminated by anything other than a newline, the
intervening backslash and whitespace are ignored.  Do not use
the dash (-) as the continuation character, as it doesn't mean
anything to SDCL.
.P
Inside SDCL control structures (such as the <condition> part
of a loop) the backslash continuation character need not be
used because SDCL knows to continue over lines until the end
of the structure.
.LE
A statement starting with two slashes ('//') is called a DCL
inclusion and extends to the next newline. It is output
without a preceeding dollar sign ($) and without squashing
spaces and tabs to one space.
.P
If '//' is encountered as part of an <other> statement,
everything from the '//' to the end of the line is output as
part of the <other> statment without further processing by
SDCL (without squashing spaces and tabs to one space).
.P
The special significance of characters such as the
backslash, etc., can be eliminated by preceding them with a
backslash.  If a backslash followed by a non-whitespace
character is encountered, the backslash is ignored and the
following character is treated as a normal character despite
any special meaning it may have elsewhere to SDCL.
.ELS
.S
.I -8
Limitations
.S
.LS
.LE
Lines are limited to 512 characters.
.LE
Tokens are limited to
512 characters.
.LE
DCL inclusions ('//' lines) are limited to
512 characters.
.LE
<reinitalize> sequences are limited to 512
characters.
.ELS
Except for the last, these limits aren't a
serious problem, since DCL's line buffer is shorter than that.
.LS
.NUMBER LIST 5
.LE
Error reporting is primitive.
.LE
Only labels that start with letters or underscores and contain
only letters, underscores, dollar signs, and digits are
recognized.
.ELS
.s
.i -8
Authors
.p
The original SDCL was written by Sohail Aslam, of the
University of Colorado at Colorado Springs, and is available
from the DECUS program library as VAX-143.
.p
This version was completely rewritten from scratch by
T.  Kurt Bond, with additions and changes to the SDCL syntax.

#-h- sdcl.scn        6944  bin  12-aug-24 09:39:58  tkb ()
;;; -*-lisp-*- ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sdcl.scn -- scanner table definitions for SDCL; Version 1.5.
;;;
;;; This file is used to produce the include files to define various codes
;;; used by the scanner and the parser, and the FSM tables used by the scanner.
;;;
;;; This file is a description of the Finite State Machine that drives
;;; the lexical analyser of SDCL.  When processed by SSTG.LSP (or
;;; SSTG.SCM) and SSTG_TO_C.LSP (or SSTG_TO_C.SCM) it produces a file
;;; that contains constant definitions and another file that contains
;;; the declarations of the various tables used by the Finite State
;;; Machine in the lexical analyser.  Since that code is generated
;;; from a description by a program, the programmer does not have to
;;; build the tables himself or herself, which eliminates a LOT of
;;; tedious work.  It also allows changes to be made to the FSM easily
;;; and painlessly.
;;; 
;;; 2022 Note: DESCRIP.MMS includes rules for bulding SDCL.TABLE, CODES.H, 
;;; and LEXTAB.C from SDCL.SCN using SSTG.SCM and SSTG_TO_C.SCM.
;;;
;;; Original directions for building CODES.H and LEXTAB.H with XLISP 1.7:
;;;
;;; To generate new versions of the scanner table and/or constants, follow
;;; these steps:
;;; 
;;; Make the changes in this file, after saving the old version
;;; somewhere safe.
;;;
;;; Get into XLISP 1.7 and issue the following commands:
;;;     (load "sstg" t)  
;;;     (gen-scantab "sdcl.scn" "sdcl.table")
;;;     (load "sstg_to_c" t)
;;;     (sstg-to-c "sdcl.table" "codes.h" "lextab.h")
;;;
;;; If you don't have XLISP 1.7, it shouldn't be too difficult to port
;;; SSTG.LSP and SSTG-C.LSP to another LISP.  
;;;
;;; 2022 Note: and in fact I ported it mostly to SCM, a R4RS Scheme
;;; that ran on the VAX back in 1992ish.  The current version I use on
;;; the VAX/VMS 5.5-2 system I maintain is SCM4c0.
;;;
;;; Get into SCM4c0 and issue the following commands:
;;;     (load "sstg")  
;;;     (gen-scantab "sdcl.scn" "sdcl.table")
;;;     (load "sstg_to_c")
;;;     (sstg-to-c "sdcl.table" "codes.h" "lextab.h")
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Character classes
(classes (LT_BACKSLASH #\\)
	 (LT_BANG      #\!)		;for comments
	 (LT_CBRACE    #\})
	 (LT_COLON     #\:)		;for := and labels
	 (LT_CPAREN    #\))
	 (LT_DIGIT     (#\0 #\9))
	 (LT_DOLLAR    #\$)
	 (LT_EOF       special)
	 (LT_EOL       10)
	 (LT_EQUAL     #\=)		;for := 
	 (LT_LETTER    (#\A #\Z) (#\a #\z))
	 (LT_OBRACE    #\{)
	 (LT_OPAREN    #\()
	 (LT_SLASH     #\/)
	 (LT_POUND     #\#)
	 (LT_DQUOTE    #\")
	 (LT_SEMI      #\;)
	 (LT_SPACE     32 12 9)		;space, formfeed, tab
	 (LT_UNDER     #\_)
	 (LT_UNDEFINED others))

;; The actions that the scanner can take, depending on current char and state
(actions AC_ADDGET			;AG add char to token and get new char
	 AC_IGNGET			;IG ingore char and get new one
	 AC_IGNNOP			;IC ingore char and do not get new char
	 AC_IGNERR			;IE ignore char and issue error message
	 AC_IGNINL			;NL ignore char and add a '\n' to token
	 AC_BLKGET			;BG add blank to token and get new char
	 AC_KILGET			;KG kill token and get a new char
	 )


;; The names for the tokens that the scanner can return.
;; Note: TC_COLON and TC_ASSIGN are used to let the *parser* figure out if
;; a statement starts with a label.  If you can't do it easily in the scanner,
;; do it in the parser!

(tokens TC_ASSIGN
	TC_COLON
	TC_EOF
	TC_EOL
	TC_IDENT
	TC_INTEGER
	TC_LABEL
	TC_SINGLE
	TC_SPACE
	TC_STRING
	TC_CBRACE
	TC_CPAREN
	TC_DCLSTMT
	TC_OBRACE
	TC_OPAREN
	TC_OTHER
	TC_QUOTED
	TC_SEMI
	;; Keywords, which are not actually recogized by the FSM, but
	;; by a helper function in the scanner, `identify()', which is
	;; called for each identifier.
	TC_BREAK
	TC_DO
	TC_ELSE
	TC_FOR
	TC_IF
	TC_NEXT
	TC_REPEAT
	TC_UNTIL
	TC_WHILE
	TC_UNKNOWN)


;; The desciption of the FSM states and what actions to perform in each
;; state for each character class
(states (0 TC_UNKNOWN "transition from accept state"
	   (others AC_IGNERR 1))
	(1 TC_UNKNOWN nil
	   (LT_EOF AC_IGNNOP 2)
	   (LT_EOL AC_ADDGET 3) 
	   (LT_LETTER AC_ADDGET 4)
	   (LT_UNDER AC_ADDGET 4)
	   (LT_SPACE AC_BLKGET 5)
	   (LT_DQUOTE AC_ADDGET 6)
	   (LT_OBRACE AC_ADDGET 8)
	   (LT_CBRACE AC_ADDGET 9)
	   (LT_OPAREN AC_ADDGET 10)
	   (LT_CPAREN AC_ADDGET 11)
	   (LT_BACKSLASH AC_IGNGET 12)
	   (LT_DIGIT AC_ADDGET 16)
	   (LT_SLASH AC_ADDGET 17)
	   (LT_SEMI AC_ADDGET 18)
	   (LT_POUND AC_IGNGET 19)
	   (LT_DOLLAR AC_ADDGET 20)
	   (LT_COLON AC_ADDGET 23)
	   (LT_BANG AC_ADDGET 22)
	   (LT_EQUAL AC_ADDGET 20)
	   (LT_UNDEFINED AC_ADDGET 20)
	   (others AC_IGNNOP 0))
	(2 TC_EOF nil
	   (others AC_IGNNOP 0))
	(3 TC_EOL nil
	   (others AC_IGNNOP 0))
	(4 TC_IDENT nil
	   ((LT_LETTER LT_DOLLAR LT_DIGIT LT_UNDER) AC_ADDGET 4)
	   (others AC_IGNNOP 0))
	(5 TC_SPACE nil
	   (LT_SPACE AC_IGNGET 5)
	   (others AC_IGNNOP 0))
	(6 TC_STRING "unterminated string"
	   (LT_DQUOTE AC_ADDGET 7)
	   ((LT_EOF LT_EOL) AC_IGNERR 0)
	   (others AC_ADDGET 6))
	(7 TC_STRING nil
	   (LT_DQUOTE AC_ADDGET 6)
	   (others AC_IGNNOP 0))
	(8 TC_OBRACE nil
	   (others AC_IGNNOP 0))
	(9 TC_CBRACE nil
	   (others AC_IGNNOP 0))
	(10 TC_OPAREN nil
	    (others AC_IGNNOP 0))
	(11 TC_CPAREN nil
	    (others AC_IGNNOP 0))
	(12 TC_UNKNOWN "unexpected end of file after continuation character"
	    ((LT_EOL LT_SPACE) AC_IGNGET 13)
	    (LT_EOF AC_IGNERR 1)
	    (others AC_ADDGET 15))
	(13 TC_UNKNOWN "unexpected end of file after continuation character"
	    ((LT_EOL LT_SPACE) AC_IGNGET 13)
	    (LT_EOF AC_IGNERR 1)
	    (LT_POUND AC_IGNGET 14)
	    (others AC_IGNNOP 1))
	(14 TC_UNKNOWN "unexpected end of file after continuation character"
	    (LT_EOF AC_IGNERR 1)
	    (LT_EOL AC_IGNGET 13)
	    (others AC_IGNGET 14))
	(15 TC_QUOTED nil
	    (others AC_IGNNOP 0))
	(16 TC_INTEGER nil
	    (LT_DIGIT AC_ADDGET 16)
	    (others AC_IGNNOP 0))
	(17 TC_SINGLE nil
	    (LT_SLASH AC_KILGET 21)	;'/' followed by '/' is TC_DCLSTMT
	    (others AC_IGNNOP 0))	;anything else is TC_SINGLE ('/')
	(18 TC_SEMI nil
	    (others AC_IGNNOP 0))
	(19 TC_EOL nil
	    (LT_EOL AC_ADDGET 0)
	    (LT_EOF AC_IGNINL 0)
	    (others AC_IGNGET 19))
	(20 TC_SINGLE nil
	    (others AC_IGNNOP 0))
	(21 TC_DCLSTMT nil
	    (LT_EOL AC_IGNNOP 0)	;so EOL is left to be next token
	    (LT_EOF AC_IGNNOP 0)	;so EOF is left to be next token
	    (others AC_ADDGET 21))
	(22 TC_OTHER nil		;Handle DCL comment as one token
	    (LT_EOL AC_IGNNOP 0)	;so EOL is left to be next token
	    (LT_EOF AC_IGNNOP 0)	;so EOF is left to be next token
	    (others AC_ADDGET 22))
	(23 TC_COLON nil
	    (LT_EQUAL AC_ADDGET 24)	;part of :=
	    (others AC_IGNNOP 0))	;so anything else is used next time
	(24 TC_ASSIGN nil
	    (others AC_IGNNOP 0))	;return this identified as :=
	)

(start 1 ST_START)			;the start state and its name
(accept 0 ST_ACCEPT)			;the accept state and its name

end					;no more input
#-h- sdcl.table     11256  bin  12-aug-24 09:39:59  tkb ()
:creator  "sstg"

:version  2.0

:source  "sdcl.scn"

:classes  20
	lt_backslash  0
	lt_bang  1
	lt_cbrace  2
	lt_colon  3
	lt_cparen  4
	lt_digit  5
	lt_dollar  6
	lt_eof  7
	lt_eol  8
	lt_equal  9
	lt_letter  10
	lt_obrace  11
	lt_oparen  12
	lt_slash  13
	lt_pound  14
	lt_dquote  15
	lt_semi  16
	lt_space  17
	lt_under  18
	lt_undefined  19

:chartoclass  128
	lt_undefined  0
	lt_undefined  1
	lt_undefined  2
	lt_undefined  3
	lt_undefined  4
	lt_undefined  5
	lt_undefined  6
	lt_undefined  7
	lt_undefined  8
	lt_space  9
	lt_eol  10
	lt_undefined  11
	lt_space  12
	lt_undefined  13
	lt_undefined  14
	lt_undefined  15
	lt_undefined  16
	lt_undefined  17
	lt_undefined  18
	lt_undefined  19
	lt_undefined  20
	lt_undefined  21
	lt_undefined  22
	lt_undefined  23
	lt_undefined  24
	lt_undefined  25
	lt_undefined  26
	lt_undefined  27
	lt_undefined  28
	lt_undefined  29
	lt_undefined  30
	lt_undefined  31
	lt_space  32
	lt_bang  33
	lt_dquote  34
	lt_pound  35
	lt_dollar  36
	lt_undefined  37
	lt_undefined  38
	lt_undefined  39
	lt_oparen  40
	lt_cparen  41
	lt_undefined  42
	lt_undefined  43
	lt_undefined  44
	lt_undefined  45
	lt_undefined  46
	lt_slash  47
	lt_digit  48
	lt_digit  49
	lt_digit  50
	lt_digit  51
	lt_digit  52
	lt_digit  53
	lt_digit  54
	lt_digit  55
	lt_digit  56
	lt_digit  57
	lt_colon  58
	lt_semi  59
	lt_undefined  60
	lt_equal  61
	lt_undefined  62
	lt_undefined  63
	lt_undefined  64
	lt_letter  65
	lt_letter  66
	lt_letter  67
	lt_letter  68
	lt_letter  69
	lt_letter  70
	lt_letter  71
	lt_letter  72
	lt_letter  73
	lt_letter  74
	lt_letter  75
	lt_letter  76
	lt_letter  77
	lt_letter  78
	lt_letter  79
	lt_letter  80
	lt_letter  81
	lt_letter  82
	lt_letter  83
	lt_letter  84
	lt_letter  85
	lt_letter  86
	lt_letter  87
	lt_letter  88
	lt_letter  89
	lt_letter  90
	lt_undefined  91
	lt_backslash  92
	lt_undefined  93
	lt_undefined  94
	lt_under  95
	lt_undefined  96
	lt_letter  97
	lt_letter  98
	lt_letter  99
	lt_letter  100
	lt_letter  101
	lt_letter  102
	lt_letter  103
	lt_letter  104
	lt_letter  105
	lt_letter  106
	lt_letter  107
	lt_letter  108
	lt_letter  109
	lt_letter  110
	lt_letter  111
	lt_letter  112
	lt_letter  113
	lt_letter  114
	lt_letter  115
	lt_letter  116
	lt_letter  117
	lt_letter  118
	lt_letter  119
	lt_letter  120
	lt_letter  121
	lt_letter  122
	lt_obrace  123
	lt_undefined  124
	lt_cbrace  125
	lt_undefined  126
	lt_undefined  127

:actions  7
	ac_addget  0
	ac_ignget  1
	ac_ignnop  2
	ac_ignerr  3
	ac_igninl  4
	ac_blkget  5
	ac_kilget  6

:tokens  28
	tc_assign  0
	tc_colon  1
	tc_eof  2
	tc_eol  3
	tc_ident  4
	tc_integer  5
	tc_label  6
	tc_single  7
	tc_space  8
	tc_string  9
	tc_cbrace  10
	tc_cparen  11
	tc_dclstmt  12
	tc_obrace  13
	tc_oparen  14
	tc_other  15
	tc_quoted  16
	tc_semi  17
	tc_break  18
	tc_do  19
	tc_else  20
	tc_for  21
	tc_if  22
	tc_next  23
	tc_repeat  24
	tc_until  25
	tc_while  26
	tc_unknown  27

:returns  25
	tc_unknown  0
	tc_unknown  1
	tc_eof  2
	tc_eol  3
	tc_ident  4
	tc_space  5
	tc_string  6
	tc_string  7
	tc_obrace  8
	tc_cbrace  9
	tc_oparen  10
	tc_cparen  11
	tc_unknown  12
	tc_unknown  13
	tc_unknown  14
	tc_quoted  15
	tc_integer  16
	tc_single  17
	tc_semi  18
	tc_eol  19
	tc_single  20
	tc_dclstmt  21
	tc_other  22
	tc_colon  23
	tc_assign  24

:errors  25
	"transition from accept state"  0
	"improper action"  1
	"improper action"  2
	"improper action"  3
	"improper action"  4
	"improper action"  5
	"unterminated string"  6
	"improper action"  7
	"improper action"  8
	"improper action"  9
	"improper action"  10
	"improper action"  11
	"unexpected end of file after continuation character"  12
	"unexpected end of file after continuation character"  13
	"unexpected end of file after continuation character"  14
	"improper action"  15
	"improper action"  16
	"improper action"  17
	"improper action"  18
	"improper action"  19
	"improper action"  20
	"improper action"  21
	"improper action"  22
	"improper action"  23
	"improper action"  24

:start  st_start  1

:accept  st_accept  0

:goto-matrix  25  20
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1
	1

	12
	22
	9
	23
	11
	16
	20
	2
	3
	20
	4
	8
	10
	17
	19
	6
	18
	5
	4
	20

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	0
	0
	0
	0
	0
	4
	4
	0
	0
	0
	4
	0
	0
	0
	0
	0
	0
	0
	4
	0

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	5
	0
	0

	6
	6
	6
	6
	6
	6
	6
	0
	0
	6
	6
	6
	6
	6
	6
	7
	6
	6
	6
	6

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	6
	0
	0
	0
	0

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	15
	15
	15
	15
	15
	15
	15
	1
	13
	15
	15
	15
	15
	15
	15
	15
	15
	13
	15
	15

	1
	1
	1
	1
	1
	1
	1
	1
	13
	1
	1
	1
	1
	1
	14
	1
	1
	13
	1
	1

	14
	14
	14
	14
	14
	14
	14
	1
	13
	14
	14
	14
	14
	14
	14
	14
	14
	14
	14
	14

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	0
	0
	0
	0
	0
	16
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	21
	0
	0
	0
	0
	0
	0

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	19
	19
	19
	19
	19
	19
	19
	0
	0
	19
	19
	19
	19
	19
	19
	19
	19
	19
	19
	19

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	21
	21
	21
	21
	21
	21
	21
	0
	0
	21
	21
	21
	21
	21
	21
	21
	21
	21
	21
	21

	22
	22
	22
	22
	22
	22
	22
	0
	0
	22
	22
	22
	22
	22
	22
	22
	22
	22
	22
	22

	0
	0
	0
	0
	0
	0
	0
	0
	0
	24
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0

	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0


:action-matrix  25  20
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr
	ac_ignerr

	ac_ignget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_ignnop
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_ignget
	ac_addget
	ac_addget
	ac_blkget
	ac_addget
	ac_addget

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_addget
	ac_addget
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_addget
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_addget
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignget
	ac_ignnop
	ac_ignnop

	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_ignerr
	ac_ignerr
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_addget
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_ignerr
	ac_ignget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_ignget
	ac_addget
	ac_addget

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignerr
	ac_ignget
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignget
	ac_ignnop
	ac_ignnop
	ac_ignget
	ac_ignnop
	ac_ignnop

	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignerr
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_addget
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_kilget
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_igninl
	ac_addget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget
	ac_ignget

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_ignnop
	ac_ignnop
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget

	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_ignnop
	ac_ignnop
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget
	ac_addget

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_addget
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop

	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop
	ac_ignnop


#-h- sdcl_notes.text 9579  bin  12-aug-24 09:40:00  tkb ()
-*-Outline-*-

* SDCL Macro processing (SDCLM for short)

Refers only to the processing of macros, which happens before the
translation of SDCL control structures to DCL if-then-goto constructs.

** Integration into SDCL

*** Seperate Program or Pass

Less efficient (two image activations).  However, much simpler and
quicker to implement since would not need to worry about the SDCL code
generation part.  Also easier to change, since needn't worry about
side effects on the SDCLC

*** Part of SDCL 

Probably more efficient, since it would mean code (for gettoken, for
instance) and data could be shared and there would only be one image
activation.  However, it would be considerably more complex (since the
code and the data would be shared!).

** include
include "filename"  looks for that exact filename and no other
include <filename>  looks for that file in library directories
include filename    check if filename is a macro, then look for the
		    expansion as one of above.

** macros

What form should be used for defining macros?  When should the macros
be processed (like SWTOOLS or CPP)?

How can the user join two macro expansions without a space between
them? In other words, 
defmac(x,1)
defmac(y,2)
xy --> xy
x y --> 1 2
We want 12.
x<>y --> 12    since the quote characters are stripped and there is
no text between them...

*** defmac(name(parameters), replacement text)

1. defmac(name, ) no parameters, no () required
2. defmac(name(), ) no parameters, () required
3. defmac(name(parameters), ) parameters required

Reasonably close match to SWTOOLS style macros, although that
closeness might be confusing.  Nicer because it allows named
parameters instead of the `$n' notation.

*** defmac(name, replacement text) 

Straight SWTOOLS style macros, would require `$n' style parameters which
would not be as nice as named parameters.

*** defmac name(parameters) (replacement text)
defmac name(parameters) {replacement text}

Not a close match to SWTOOLS style macros.

*** vax macro style
defmac name parameter-list            
    replacement text		
endmacro

Not a close match to SWTOOLS macros, and not as general, since it
would not allow any in-line macros.

** conditional preprocessing

if
else
endif
elseif
ifdef
ifndef

How can we use these without conflicting with the SDCL control
structures?  We cannot use #<directive>

** Software Tools style macros (SWTP, p 305)

These allow using the macros as a programming language, which makes it
very powerful, if somewhat convoluted...  Perhaps should see about
adding some other structures, such as loop() (cut down on recursion).

*** ifelse(a, b, c, d)

*** expr(e) 

with +, -, *, /, %, & (and), | (or), ~ (not) <, >, <=, >=, ~=

*** substr(s, m, n)

*** len(s)

*** changeq() 

quote characters normally <>, since their only use in DCL is TOPS-20
style directory names.

** New SWTOOLS style macros

*** string(s) 

Convert s into a quoted DCL string that ends up as a TC_STRING.

I don't think this will require any mucking about with internals, just
push the result back on the input and rescan it.


** notes

SDCL does not  consider `{'  or  `}' (or  for  that  matter,  any SDCL
construct)  significate if they do  not start   a statement  (in other
words, either follow a SDCL construct or the beginning of a line.  For
instance, the SDCL statements

    if (p1) { write sys$output "p1: ", p1 }
    else { write sys$output "not p1: ", p1 } 

are translated to

    $ if (.not.(p1)) then goto 23000
    $ write sys$output "p1: ", p1 }
    $ else { write sys$output "not p1: ", p1 }
    $ 23000: 

instead of 

    $ if (.not.(p1)) then goto 23000
    $ write sys$output "p1: ", p1
    $ goto 23001
    $ 23000: 
    $ write sys$output "not p1: ", p1
    $ 23001: 

This happens because SDCL classifies a statement by  the first part of
the statement.   If the statement  is anything but `other',  it parses
out the SDCL control structure and goes back to  look at the following
statement. If it is an other, it reads to the end of the line and goes
back  to look at   the following statement.   In other  words,  if the
statement is an `other', only  the end of  the line is  the end of the
statement.   Therefore, a `}'  in  an `other'  is just    part of  the
statement.

It might  be  nice to make `{'  and  `}' recognized in others,  so you
could do things like

    if (x) { this } else { that }

on one line.  I don't know if it would be worth it, though.

* New SDCL

*** labels

The  label construct is _extremely_ important.   Note that DCL accepts
`[a-z0-9_][a-z0-9_$]*[ \t]*:' as  a  label,  but  that  is  probably a
little too  complex   at the moment,  since without  we only  need one
character  look-head,   and  with    it we  need  indefinite-character
look-ahead.

Actually, we need at least two character look-ahead, since 
	label:=x
is not a label and
	label: x
is one.  (i.e., need lookahead to see if ":" following, and another to
see if "=" follows that, in which case it is *not* a label.)


*** comments

Old sdcl  uses "/*" and "*/"  for  comments and squeezes them all out,
replacing them by the null string.

New sdcl  uses "#" to start a  comment which  ends at  the  end of the
line. Comments  are   stripped by  gettoken   and  replaced by TC_EOL,
end-of-line.

*** strings

**** Change to not break strings at `""'

Currently, SDCL will break a  string at an  embedded `""'  in order to
insert a continuation line, thinking it to be two strings.  SDCL needs
to understand this  facet of DCL strings.   (done: gettoken recognizes
such strings)

**** Change to never break a string across lines

Also, the continuation characters are  inserted anywhere in  the line,
once the line is too long, even  inside strings.  Teach  it to _never_
break strings.  This problem is due to the fact that output is done by
a  single-character   output  routine  that automatically   inserts  a
continuation character if the buffer  is about to fill up,  regardless
of  what it  is  in the middle  of.  emitstring, which  is supposed to
prevent this, actually  uses this output  routine, partially defeating
its purpose.

**** strings ended by end of line

DCL allows strings to be ended by end of line, i.e.

    $ write sys$output "hello, world

is valid  DCL.  Should SDCL  allow  this as well?  It  wouldn't be too
difficult, would it? (done: gettoken just continues to  the end of the
line.   ???Perhaps  it  should  return  a  message  about unterminated
strings that would be output, or just output the message itself. Also,
should  it add the terminating  quotes itself?  Probably not... should
be the last thing on the line anyway.)

*** problems with symbol substitution 

**** don't break 'symbol'

SDCL should not insert a continuation  symbol in a 'symbol' construct,
because DCL thinks that  the continuation symbol marks  the end of the
substitution.  This will require treating (') somewhat like (").  (???
change getstring to accept a second parameter to  indicate the type of
quote to use.  But see next item for why not.)

**** end of word terminates ' substitution

Substitution started with (') does not require and ending ('), since a
space   character (and  perhaps  others?) will stop the  substitution.
Here is an example:

    $ symbol = "[this]
    $ x := 'symbol 'symbol
    $ sho sym x
    X = "[THIS] [THIS]"

So, will SDCL have to recognize this? Or should we just say "that is a
sloppy feature  that we don't  think  anyone  should use, so we  don't
allow it"?

**** Substitution using (&)

Symbols substitued using (&) can be continued  on a new  line with the
DCL continuation character, so we don't have to worry about them.

*** text preprocessing: #`facility'

It would be  very nice to  have this  sort of facility.  How difficult
would  it be  add this?  Should it  be a seperate  (previous) pass, or
part of the main program?

**** Change meaning of # 

Currently, # means leave line  alone.  If  text preprocessing is added
this will have to  be changed so that  #dcl  at front of line  emits a
line untouched,  which will allow  us to use #  as the  lead-in to the
preprocessor directives.  Also, should allow  any amount of whitespace
before a # directive (old SDCL allows it).

**** #dcl

Should this emit the rest  of the line  completely untouched, or strip
out comments as the current one does? Or should  we have two different
versions, one which strips comments, one that doesn't?

**** #include file 

It would be nice to have some sort of #include  facility.   If this is
added, should set up a directory search path of some sort  to look for
include files in (like the <file> of C)?

**** macro definitions

#define #ifdef #ifnotdef

How  hard would  it be to implement a  #define?  Would it be worth it?
Would have to do much  more parsing.  Implement as completely seperate
pass?  If not defines for general text, at least allow #ifdef  and #if
XXX | YYY type usages so we can have conditional processing of text.

**** conditional processing of source

#if #else #elseif #endif 

Investigate possibility  of #if   #else #endif.  If  not  defines  for
general text, at least allow #ifdef  and #if XXX |  YYY type usages so
we can have conditional processing of text.

*** repeat ... until, do ... while

It would be nice to have repeat until, but not essential.  However, if
don't have  repeat ... until, at  least make the  while part of the do
...  while optional, so  the loop  is infinite if ommited.  Or perhaps
make the repeat not have an until at all, like Icon.

** Sources

SDCL
C-preprocessor
SWTools macro

#-h- listsrcs.sh      163  asc  12-aug-24 15:27:34  tkb ()
lr  .indent_pro *.txt *.com *.h *.c makefile. *.rst *.rno *.scn *.table *.text *.sh | tee ~usr/sdcl.lis | sedit 's/%{?+}$/ar uv sdcl.w $1/' | tee ~usr/initsdcl.sh