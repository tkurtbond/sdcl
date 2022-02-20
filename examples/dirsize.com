$ verifying = 'f$verify(f$type(dirsize_verify) .nes. "")'
$ !> DIRSIZE.SDCL -- Show total size of directory and all subdirectories.
$ true = (1 .eq. 1)
$ false = .not. true
$ debug = true
$ opt_list = "/OUTPUT/SORT/"
$ opt_list_len = f$length(opt_list)
$ do_output = false
$ do_sort = false
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
$ write sys$output "Invalid Option: ''opt'"
$ 23003: 
$ i = i + 1
$ goto 23000
$ 23001: 
$ if (.not.(do_sort .and. .not. do_output)) then goto 23004
$ write sys$output "dirsize: cannot sort if output file not specified"
$ goto The_End
$ 23004: 
$ if (.not.(.not. do_output)) then goto 23006
$ output = "sys$output"
$ goto 23007
$ 23006: 
$ if (.not.(f$parse(output_file) .eqs. "")) then goto 23008
$ write sys$output "dirsize: invalid filename specified: ", output_file
$ goto The_End
$ 23008: 
$ output = "outputfile"
$ if (.not.(do_sort)) then goto 23010
$ outfile = f$parse(output_file, , , "device") + f$parse(output_file, , , -
  "directory") + f$parse(output_file, , , "name") + "." + f$getjpi("", "pid") -
  + "_dirsize"
$ open 'output' 'outfile'/write/error=Cannot_Open_File
$ goto 23011
$ 23010: 
$ open 'output' 'output_file'/write/error=Cannot_Open_File
$ 23011: 
$ 23007: 
$ StartDir = p'i' 
$ if (.not.(StartDir .eqs. "")) then goto 23012
$ inquire StartDir "_Starting Directory"
$ 23012: 
$ if (.not.(StartDir .eqs. "")) then goto 23014
$ exit (1 .or. (f$verify(verifying) .and. 0))
$ 23014: 
$ DevSpec = f$parse(StartDir,,,"device")
$ DirSpec = f$parse(StartDir,,,"directory") - "[" - "]"
$ Top = 1 
$ DirSpec_'Top' = DirSpec 
$ TotalSize_'Top' = 0 
$ 23016: 
$ FileSpec = f$search(DevSpec + "[" + DirSpec + "]*.dir;1", Top)
$ FileSpec = f$parse(FileSpec,,,"name")
$ if (.not.(FileSpec .eqs. "000000")) then goto 23019
$ goto 23017
$ 23019: 
$ if (.not.(FileSpec .nes. "")) then goto 23021
$ Top = Top + 1 
$ DirSpec_'Top' = DirSpec 
$ DirSpec = DirSpec + "." + FileSpec 
$ if (.not.(f$type(TotalSize_'Top') .eqs. "")) then goto 23023
$ TotalSize_'Top' = 0
$ 23023: 
$ goto 23017
$ 23021: 
$ if (.not.(Top .eq. 1)) then goto 23025
$ goto 23018
$ 23025: 
$ if (.not.(Top .ge. 0)) then goto 23027
$ gosub DoCurrentLevel 
$ DirSpec = DirSpec_'Top' 
$ Top = Top - 1 
$ goto 23017
$ 23027: 
$ write sys$output "dirsize: Stack Underflow!"
$ goto Close_Files
$ 23017: goto 23016
$ 23018: 
$ gosub DoCurrentLevel 
$ Close_Files:
$ if (.not.(do_output)) then goto 23029
$ close 'output'
$ if (.not.(do_sort)) then goto 23031
$ sort 'outfile' 'output_file'/spec=sys$input
/collating=(seq=ascii,mod=("["=" ", "."=" ", "]"=" "))
$ delete 'outfile'.0
$ 23031: 
$ 23029: 
$ The_End:
$ exit (1 .or. (f$verify(verifying) .and. 0)) 
$ Cannot_Open_File:
$ write sys$output "dirsize: cannot open output file"
$ exit (1 .or. (f$verify(verifying) .and. 0))
$ DoCurrentLevel:
$ Spec = DevSpec + "[" + DirSpec + "]"
$ DirSize_'Top' = 0 
$ FileName = f$search(Spec + "*.*;*")
$ 23033: if (.not.(FileName .nes. "")) then goto 23034
$ DirSize_'Top' = DirSize_'Top' + f$file(FileName, "ALQ") 
$ FileName = f$search(Spec + "*.*;*")
$ goto 23033
$ 23034: 
$ TopPlus1 = Top + 1 
$ if (.not.(f$type(TotalSize_'TopPlus1') .eqs. "")) then goto 23035
$ write 'output' f$fao( " !44<[!AS]!> Size: !8SL", DirSpec, DirSize_'Top' -
  )
$ TotalSize_'Top' = TotalSize_'Top' + DirSize_'Top'
$ goto 23036
$ 23035: 
$ write 'output' f$fao( " !44<[!AS]!> Size: !8SL Sub: !8SL", DirSpec, DirSize_'Top', -
  TotalSize_'TopPlus1' )
$ TotalSize_'Top' = TotalSize_'Top' + DirSize_'Top' + TotalSize_'TopPlus1'
$ delete/symbol TotalSize_'TopPlus1' 
$ 23036: 
$ return 
$ OPT$out:
$ do_output = true
$ p = f$locate("=", opt)
$ l = f$length(opt)
$ if (.not.(p .ne. l)) then goto 23037
$ output_file = f$extract(p+1, l, opt)
$ goto 23038
$ 23037: 
$ output_file = ""
$ 23038: 
$ return ! from OPT$out, the output option
$ OPT$sor:
$ do_sort = true
$ return ! from OPT$sor, the sort option
