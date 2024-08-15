$ save_verify_env = 'f$verify(f$type(pipes_verify) .nes. "")'
$ !> PIPES.SDCL -- UNIX style pipes and i/o redirection
$ wse = "write sys$error"
$ wso = "write sys$output"
$ inq = "inquire/nopun"
$ udef = "define/user/nolog"
$ true = 1 .eq. 1
$ false = .not. true
$ debug = false
$ temp_spec = "sys$scratch:pipes_"
$ temp_type = "tmp"
$ is_input_file = false
$ error_resume = "interactive_resume"
$ verify = 0 
$ opt_list = "/DEBUG/HELP/INPUT/TESTING/VERIFY/"
$ opt_list_len = f$length(opt_list)
$ i = 1
$ 23000: if (.not.(f$extract(0, 1, p'i') .eqs. "-")) then goto 23001
$ opt = p'i'
$ which = f$extract(1, 3, opt)
$ ok = (f$locate("/" + which, opt_list) .ne. opt_list_len) .and. (which .nes. -
  "")
$ if (.not.(ok)) then goto 23002
$ gosub OPT$'which'
$ goto 23003
$ 23002: 
$ wse "pipes: invalid option `", opt, "'"
$ 23003: 
$ i = i + 1
$ goto 23000
$ 23001: 
$ if (.not.(p'i' .nes. "")) then goto 23004
$ inl = p'i'
$ gosub process_line
$ goto The_End
$ 23004: 
$ on error then goto error_handler
$ on control_y then goto error_handler
$ if (.not.(is_input_file)) then goto 23006
$ gosub take_from_file
$ goto 23007
$ 23006: 
$ wso "PIPES -- Enter -h for help.                           ''f$time()'"
$ done = false
$ 23008: 
$ inq inl "PIPES> "
$ gosub process_line
$ interactive_resume:
$ 23009: if (.not. done) then goto 23008
$ 23010: 
$ 23007: 
$ The_End:
$ exit (1 .or. (f$verify(save_verify_env) .and. 0))
$ error_handler:
$ on control_y then goto error_handler
$ on error then goto error_handler
$ goto 'error_resume'
$ process_line:
$ line = f$edit(inl, "trim,uncomment")
$ if (.not.((f$extract(0, 1, line) .eqs. "#") .or. line .eqs. "")) then goto 23011
$ return
$ 23011: 
$ if (.not.(f$edit(line, "upcase") .eqs. "EXIT")) then goto 23013
$ done = true
$ return
$ 23013: 
$ if (.not.(line .eqs. "-H")) then goto 23015
$ gosub pipes_help_routine
$ return
$ 23015: 
$ if (.not.(line .eqs. "%")) then goto 23017
$ read/prompt="PIPES>> " sys$command line
$ 23017: 
$ if (.not.(f$locate("&", line) .eq. f$length(line) - 1)) then goto 23019
$ line = f$extract(0, f$length(line) -1, line)
$ spawn /nowait /notify pipes "''line'"
$ return
$ 23019: 
$ if (.not.(f$locate("take", f$edit(line, "trim,lowercase")) .eq. 0)) then goto 23021
$ input_file = f$edit(f$element(1, " ", f$edit(line, "trim,compress")), "collapse")
$ if (.not.(input_file .eqs. "")) then goto 23023
$ inq input_file "_File Name: "
$ if (.not.(input_file .eqs. "")) then goto 23025
$ wse "pipes: No file name specified"
$ return
$ 23025: 
$ 23023: 
$ gosub take_from_file
$ return
$ 23021: 
$ i = 0 
$ 23027: 
$ iplus = i + 1 
$ line_len = f$length(line)
$ bar_pos = f$locate("|", line)
$ pipe = f$extract(0, bar_pos, line) 
$ if (.not.(bar_pos .ne. line_len)) then goto 23030
$ line = f$extract(bar_pos + 1, line_len, line)
$ more_pipes = true
$ goto 23031
$ 23030: 
$ more_pipes = false 
$ 23031: 
$ if (.not.(debug)) then goto 23032
$ wse "Current joint: ", pipe
$ wse "Current line:  ", line
$ 23032: 
$ gosub stdin_redirect 
$ gosub stdout_redirect 
$ gosub stderr_redirect 
$ if (.not.(is_err_file)) then goto 23034
$ udef sys$error 'err_file'
$ 23034: 
$ if (.not.(is_in_file)) then goto 23036
$ udef sys$input 'in_file'
$ goto 23037
$ 23036: 
$ if (.not.(i .ge. 1)) then goto 23038
$ udef sys$input 'temp_spec''i'.'temp_type'
$ goto 23039
$ 23038: 
$ udef sys$input sys$command
$ 23039: 
$ 23037: 
$ if (.not.(more_pipes)) then goto 23040
$ udef sys$output 'temp_spec''iplus'.'temp_type'
$ goto 23041
$ 23040: 
$ if (.not.(is_out_file)) then goto 23042
$ udef sys$output 'out_file'
$ 23042: 
$ 23041: 
$ if (.not.(debug)) then goto 23044
$ wse "sys$command: ", f$trnlnm("sys$command")
$ wse "sys$error:   ", f$trnlnm("sys$error")
$ wse "sys$input:   ", f$trnlnm("sys$input")
$ wse "sys$output:  ", f$trnlnm("sys$output")
$ 23044: 
$ junk = f$verify(save_verify_env)
$ 'pipe' 
$ junk = 'f$verify(f$type(pipes_verify) .nes. "")'
$ if (.not.(out_append)) then goto 23046
$ append /new_version 'out_file' 'append_file'
$ delete 'out_file';*
$ 23046: 
$ if (.not.(err_append)) then goto 23048
$ append /new_version 'err_file' 'err_append_file'
$ delete 'err_file';*
$ 23048: 
$ if (.not.(i .ge. 1)) then goto 23050
$ delete 'temp_spec''i'.'temp_type';* 
$ 23050: 
$ i = i + 1 
$ 23028: if (more_pipes) then goto 23027
$ 23029: 
$ return 
$ stdin_redirect:
$ len = f$length(pipe)
$ pos = f$locate("<", pipe)
$ if (.not.(pos .ne. len)) then goto 23052
$ if (.not.(i .ge. 1)) then goto 23054
$ is_in_file = false
$ wse "Error: misplaced <"
$ goto error_handler
$ goto 23055
$ 23054: 
$ is_in_file = true
$ in_file = f$extract(pos + 1, len, pipe)
$ pipe = f$extract(0, pos - 1, pipe)
$ pos = f$locate(" ", in_file)
$ len = f$length(in_file)
$ pipe = pipe + f$extract(pos, len, in_file)
$ in_file = f$extract(0, pos, in_file)
$ 23055: 
$ goto 23053
$ 23052: 
$ is_in_file = false
$ 23053: 
$ return 
$ stdout_redirect:
$ len = f$length(pipe)
$ pos = f$locate(">>", pipe) 
$ if (.not.(pos .ne. len)) then goto 23056
$ out_append = true
$ skip = 2 
$ goto 23057
$ 23056: 
$ pos = f$locate(">", pipe) 
$ out_append = false
$ skip = 1 
$ 23057: 
$ if (.not.(pos .ne. len)) then goto 23058
$ if (.not.(more_pipes)) then goto 23060
$ is_out_file = false
$ wse "Error: misplaced > or >>"
$ goto error_handler
$ goto 23061
$ 23060: 
$ is_out_file = true
$ out_file = f$extract(pos + skip, len, pipe)
$ pipe = f$extract(0, pos - 1, pipe)
$ pos = f$locate(" ", out_file)
$ len = f$length(out_file)
$ pipe = pipe + f$extract(pos, len, out_file)
$ out_file = f$extract(0, pos, out_file)
$ 23061: 
$ goto 23059
$ 23058: 
$ is_out_file = false
$ 23059: 
$ if (.not.(out_append)) then goto 23062
$ append_file = out_file 
$ out_file = temp_spec + "app." + temp_type 
$ 23062: 
$ return 
$ stderr_redirect:
$ len = f$length(pipe)
$ pos = f$locate("??", pipe)
$ if (.not.(pos .ne. len)) then goto 23064
$ err_append = true
$ skip = 2 
$ goto 23065
$ 23064: 
$ pos = f$locate("?", pipe)
$ err_append = false
$ skip = 1 
$ 23065: 
$ if (.not.(pos .ne. len)) then goto 23066
$ is_err_file = true
$ err_file = f$extract(pos + skip, len, pipe)
$ pipe = f$extract(0, pos - 1, pipe)
$ pos = f$locate(" ", err_file)
$ len = f$length(err_file)
$ pipe = pipe + f$extract(pos, len, err_file)
$ err_file = f$extract(0, pos, err_file)
$ goto 23067
$ 23066: 
$ is_err_file = false
$ 23067: 
$ if (.not.(err_append)) then goto 23068
$ err_append_file = err_file 
$ err_file = temp_spec + "err." + temp_type 
$ 23068: 
$ return 
$ pipes_help_routine:
$ copy sys$input sys$error
 PIPES -- This command procedure adds UNIX style piping and i/o
          redirection to DCL.  Written in SDCL.
 
 Invocation command line options:
 -DEBUG - Turns on debugging output.
 -HELP - Displays this message and exits.
 -INPUT=filename - Specifies file to  read commands from.
 -TESTING - Also turns on debugging output.
 -VERIFY - Turns on verification.
 
 Pipes command line operators:
 | -- Pipe symbol. Used to direct the output from one command to
      the next command.
 > -- Output redirection symbol.  Used to direct the output from
      one command to a file.  Legal only on the end of a pipeline.
 < -- Input redirection symbols.  Used to direct the command to take
      input from a file. Legal only on the beginning of a pipeline.
 ? -- Error redirection symbols.  Used to direct the error output
      from a command to a file.
 & -- Spawn a pipeline.
 >> -- Append output to a file.
 ?? -- Append error output to a file.
 
 Note: i/o redirection doesn't work properly with DCL command procedures,
 just actual executable programs.

 Example: 
 PIPES> translit a-z @n <a.in | wordcount >words.out
      takes the input for the translit command from the file a.in
      and takes translit's output for the input for wordcount, and
      stores wordcount's output in words.out.
 Commands: 
 EXIT  -- Exit from PIPES.
 TAKE  -- Take input from file.  Specify a file name after the command.
 %     -- Read a literal line.  Used when quotes ("") or spaces or case
          of letters in command line is significant.
 -h    -- This message.
 Other -- Any valid DCL command with ALL required parameters and
          qualfiers specified.
 
$ return 
$ take_from_file:
$ file = f$search(input_file) 
$ if (.not.(file .eqs. "")) then goto 23070
$ wse "pipes: can't open input file `", input_file, "'"
$ return
$ 23070: 
$ open inf 'file'
$ error_resume = "non_interactive_resume" 
$ done = false
$ 23072: 
$ read /end_of_file=end_file /prompt="PIPES> " inf inl
$ gosub process_line
$ non_interactive_resume:
$ 23073: if (.not. done) then goto 23072
$ 23074: 
$ end_file:
$ close inf
$ error_resume = "interactive_resume" 
$ return
$ OPT$deb:
$ OPT$tes:
$ if (.not.(f$locate("~", opt) .ne. f$length(opt))) then goto 23075
$ debug = false
$ goto 23076
$ 23075: 
$ debug = true
$ 23076: 
$ return
$ OPT$hel:
$ gosub pipes_help_routine
$ exit (1 .or. (f$verify(save_verify_env) .and. 0))
$ OPT$inp:
$ p = f$locate("=", opt)
$ l = f$length(opt)
$ if (.not.(p .ne. 1)) then goto 23077
$ input_file = f$extract(p + 1, l, opt)
$ is_input_file = true
$ 23077: 
$ return
$ OPT$ver:
$ if (.not.(f$locate("~", opt) .ne. f$length(opt))) then goto 23079
$ verify = 0
$ goto 23080
$ 23079: 
$ pipes_verify = 1
$ junk = f$verify(1)
$ 23080: 
$ return
