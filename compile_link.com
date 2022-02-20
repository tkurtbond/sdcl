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
