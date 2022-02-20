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
$ opt_list = "/INPUT/TESTING/VERIFY/"
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
$ file = f$search(input_file) 
$ if (.not.(file .eqs. "")) then goto 23008
$ wse "pipes: can't open input file `", input_file, "'"
$ goto The_End
$ 23008: 
$ open inf 'file'
$ error_resume = "non_interactive_resume" 
$ done = false
$ 23010: 
$ read /end_of_file=end_file /prompt="PIPES> " inf inl
$ gosub process_line
$ non_interactive_resume:
$ 23011: if (.not. done) then goto 23010
$ 23012: 
$ end_file:
$ close inf
$ goto 23007
$ 23006: 
$ wso "PIPES -- Enter -h for help.                           ''f$time()'"
$ done = false
$ 23013: 
$ inq inl "PIPES> "
$ gosub process_line
$ interactive_resume:
$ 23014: if (.not. done) then goto 23013
$ 23015: 
$ 23007: 
$ The_End:
$ exit (1 .or. (f$verify(save_verify_env) .and. 0))
$ error_handler:
$ on control_y then goto error_handler
$ on error then goto error_handler
$ goto 'error_resume'
$ process_line:
$ line = f$edit(inl, "trim,uncomment")
$ if (.not.((f$extract(0, 1, line) .eqs. "#") .or. line .eqs. "")) then goto 23016
$ return
$ 23016: 
$ if (.not.(f$edit(line, "upcase") .eqs. "EXIT")) then goto 23018
$ done = true
$ return
$ 23018: 
$ if (.not.(line .eqs. "-H")) then goto 23020
$ gosub pipes_help_routine
$ return
$ 23020: 
$ if (.not.(line .eqs. "%")) then goto 23022
$ read/prompt="PIPES>> " sys$command line
$ 23022: 
$ if (.not.(f$locate("&", line) .eq. f$length(line) - 1)) then goto 23024
$ line = f$extract(0, f$length(line) -1, line)
$ spawn /nowait /notify pipes "''line'"
$ return
$ 23024: 
$ i = 0 
$ 23026: 
$ iplus = i + 1 
$ line_len = f$length(line)
$ bar_pos = f$locate("|", line)
$ pipe = f$extract(0, bar_pos, line) 
$ if (.not.(bar_pos .ne. line_len)) then goto 23029
$ line = f$extract(bar_pos + 1, line_len, line)
$ more_pipes = true
$ goto 23030
$ 23029: 
$ more_pipes = false 
$ 23030: 
$ if (.not.(debug)) then goto 23031
$ wse "Current joint: ", pipe
$ wse "Current line:  ", line
$ 23031: 
$ gosub stdin_redirect 
$ gosub stdout_redirect 
$ gosub stderr_redirect 
$ if (.not.(is_err_file)) then goto 23033
$ udef sys$error 'err_file'
$ 23033: 
$ if (.not.(is_in_file)) then goto 23035
$ udef sys$input 'in_file'
$ goto 23036
$ 23035: 
$ if (.not.(i .ge. 1)) then goto 23037
$ udef sys$input 'temp_spec''i'.'temp_type'
$ goto 23038
$ 23037: 
$ udef sys$input sys$command
$ 23038: 
$ 23036: 
$ if (.not.(more_pipes)) then goto 23039
$ udef sys$output 'temp_spec''iplus'.'temp_type'
$ goto 23040
$ 23039: 
$ if (.not.(is_out_file)) then goto 23041
$ udef sys$output 'out_file'
$ 23041: 
$ 23040: 
$ if (.not.(debug)) then goto 23043
$ wse "sys$command: ", f$trnlnm("sys$command")
$ wse "sys$error:   ", f$trnlnm("sys$error")
$ wse "sys$input:   ", f$trnlnm("sys$input")
$ wse "sys$output:  ", f$trnlnm("sys$output")
$ 23043: 
$ junk = f$verify(save_verify_env)
$ 'pipe' 
$ junk = 'f$verify(f$type(pipes_verify) .nes. "")'
$ if (.not.(out_append)) then goto 23045
$ append /new_version 'out_file' 'append_file'
$ delete 'out_file';*
$ 23045: 
$ if (.not.(err_append)) then goto 23047
$ append /new_version 'err_file' 'err_append_file'
$ delete 'err_file';*
$ 23047: 
$ if (.not.(i .ge. 1)) then goto 23049
$ delete 'temp_spec''i'.'temp_type';* 
$ 23049: 
$ i = i + 1 
$ 23027: if (more_pipes) then goto 23026
$ 23028: 
$ return 
$ stdin_redirect:
$ len = f$length(pipe)
$ pos = f$locate("<", pipe)
$ if (.not.(pos .ne. len)) then goto 23051
$ if (.not.(i .ge. 1)) then goto 23053
$ is_in_file = false
$ wse "Error: misplaced <"
$ goto error_handler
$ goto 23054
$ 23053: 
$ is_in_file = true
$ in_file = f$extract(pos + 1, len, pipe)
$ pipe = f$extract(0, pos - 1, pipe)
$ pos = f$locate(" ", in_file)
$ len = f$length(in_file)
$ pipe = pipe + f$extract(pos, len, in_file)
$ in_file = f$extract(0, pos, in_file)
$ 23054: 
$ goto 23052
$ 23051: 
$ is_in_file = false
$ 23052: 
$ return 
$ stdout_redirect:
$ len = f$length(pipe)
$ pos = f$locate(">>", pipe) 
$ if (.not.(pos .ne. len)) then goto 23055
$ out_append = true
$ skip = 2 
$ goto 23056
$ 23055: 
$ pos = f$locate(">", pipe) 
$ out_append = false
$ skip = 1 
$ 23056: 
$ if (.not.(pos .ne. len)) then goto 23057
$ if (.not.(more_pipes)) then goto 23059
$ is_out_file = false
$ wse "Error: misplaced > or >>"
$ goto error_handler
$ goto 23060
$ 23059: 
$ is_out_file = true
$ out_file = f$extract(pos + skip, len, pipe)
$ pipe = f$extract(0, pos - 1, pipe)
$ pos = f$locate(" ", out_file)
$ len = f$length(out_file)
$ pipe = pipe + f$extract(pos, len, out_file)
$ out_file = f$extract(0, pos, out_file)
$ 23060: 
$ goto 23058
$ 23057: 
$ is_out_file = false
$ 23058: 
$ if (.not.(out_append)) then goto 23061
$ append_file = out_file 
$ out_file = temp_spec + "app." + temp_type 
$ 23061: 
$ return 
$ stderr_redirect:
$ len = f$length(pipe)
$ pos = f$locate("??", pipe)
$ if (.not.(pos .ne. len)) then goto 23063
$ err_append = true
$ skip = 2 
$ goto 23064
$ 23063: 
$ pos = f$locate("?", pipe)
$ err_append = false
$ skip = 1 
$ 23064: 
$ if (.not.(pos .ne. len)) then goto 23065
$ is_err_file = true
$ err_file = f$extract(pos + skip, len, pipe)
$ pipe = f$extract(0, pos - 1, pipe)
$ pos = f$locate(" ", err_file)
$ len = f$length(err_file)
$ pipe = pipe + f$extract(pos, len, err_file)
$ err_file = f$extract(0, pos, err_file)
$ goto 23066
$ 23065: 
$ is_err_file = false
$ 23066: 
$ if (.not.(err_append)) then goto 23067
$ err_append_file = err_file 
$ err_file = temp_spec + "err." + temp_type 
$ 23067: 
$ return 
$ pipes_help_routine:
$ wse ""
$ wse "PIPES -- This command procedure adds UNIX style piping and i/o"
$ wse "         redirection to DCL.  Written in SDCL."
$ wse ""
$ wse "Command Line Operators:"
$ wse "| -- Pipe symbol. Used to direct the output from one command to"
$ wse "     the next command."
$ wse "> -- Output redirection symbol.  Used to direct the output from"
$ wse "     one command to a file.  Legal only on the end of a pipeline."
$ wse "< -- Input redirection symbols.  Used to direct the command to take"
$ wse "     input from a file. Legal only on the beginning of a pipeline."
$ wse "? -- Error redirection symbols.  Used to direct the error output"
$ wse "     from a command to a file."
$ wse "& -- Spawn a pipeline."
$ wse ">> -- Append output to a file."
$ wse "?? -- Append error output to a file."
$ wse "Example: "
$ wse "PIPES> translit a-z @n <a.in | wordcount >words.out"
$ wse "     takes the input for the translit command from the file a.in"
$ wse "     and takes translit's output for the input for wordcount, and"
$ wse "     stores wordcount's output in words.out."
$ wse "Commands: "
$ wse "EXIT  -- Exit from PIPES."
$ wse "%     -- Read a literal line.  Used when quotes "" or spaces or case"
$ wse "         of letters in command line is significant."
$ wse "-h    -- This message."
$ wse "Other -- Any valid DCL command with ALL required parameters and"
$ wse "         qualfiers specified."
$ wse ""
$ return 
$ OPT$inp:
$ p = f$locate("=", opt)
$ l = f$length(opt)
$ if (.not.(p .ne. 1)) then goto 23069
$ input_file = f$extract(p + 1, l, opt)
$ is_input_file = true
$ 23069: 
$ return
$ OPT$tes:
$ if (.not.(f$locate("~", opt) .ne. f$length(opt))) then goto 23071
$ debug = false
$ goto 23072
$ 23071: 
$ debug = true
$ 23072: 
$ return
$ OPT$ver:
$ if (.not.(f$locate("~", opt) .ne. f$length(opt))) then goto 23073
$ verify = 0
$ goto 23074
$ 23073: 
$ pipes_verify = 1
$ junk = f$verify(1)
$ 23074: 
$ return
