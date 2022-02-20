$ !> SDCL.SDCL -- provide default name and extension for the SDCL preprocessor
$ verify_on = f$verify(0)
$ TRUE = (1 .eq. 1)
$ FALSE = .not. TRUE
$ wso = "write sys$output "
$ wse = "write sys$error "
$ inq = "inquire/nopun "
$ debug = TRUE
$ sdcl_processor = "$exe_lib:sdcl"
$ current_directory = f$environment("default")
$ temp_file_name_pattern = "SDCL_" + f$getjpi("", "pid")
$ temp_file_name = temp_file_name_pattern + ".tmp"
$ opt_list = "/BATCH/COM/"
$ opt_list_len = f$length(opt_list)
$ batch = FALSE
$ com_file = FALSE
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
$ list = ""
$ j = i
$ 23004: if (.not.(j .le. 8)) then goto 23006
$ if (.not.(p'j' .eqs. "")) then goto 23007
$ goto 23006
$ 23007: 
$ list = list + p'j'
$ 23005: j = j + 1
$ goto 23004
$ 23006: 
$ if (.not.(list .eqs. "")) then goto 23009
$ list = f$trnlnm("EDIT_FILE")
$ 23009: 
$ if (.not.(list .eqs. "")) then goto 23011
$ inq list "_File: "
$ 23011: 
$ if (.not.(list .eqs. "")) then goto 23013
$ exit
$ 23013: 
$ list = "," + f$edit(list, "lowercase,collapse")
$ length = f$length(list)
$ p = f$locate("+", list)
$ 23015: if (.not.(p .ne. length)) then goto 23017
$ list[p*8, 8] = 44 
$ 23016: p = f$locate("+", list)
$ goto 23015
$ 23017: 
$ if (.not.(batch .or. com_file)) then goto 23018
$ open/write outf 'temp_file_name'
$ write outf "$!> ", f$edit(temp_file_name, "upcase"), " -- Compile SDCL"
$ write outf "$! Time: ", f$time()
$ 23018: 
$ i = 1
$ fspec = f$element(i, ",", list) 
$ if (.not.(batch .or. com_file)) then goto 23020
$ log_file = f$parse(f$search(fspec, 1), , , "name")
$ if (.not.(log_file .eqs. "")) then goto 23022
$ log_file = temp_file_name_pattern + ".log"
$ wse "sdcl: no log file name; using """, log_file
$ 23022: 
$ 23020: 
$ 23024: if (.not.(fspec .nes. ",")) then goto 23025
$ if (.not.(fspec .eqs. "")) then goto 23026
$ wso "sdcl: null file specified"
$ 23026: 
$ fspec = f$parse(fspec, ".sdcl") 
$ file = f$search(fspec)
$ 23028: if (.not.(file .nes. "")) then goto 23029
$ temp = file 
$ write sys$output "Processing ", f$parse(file,,,"name")
$ if (.not.(batch .or. com_file)) then goto 23030
$ write outf "$ sdcl ", file
$ goto 23031
$ 23030: 
$ if (.not.(debug)) then goto 23032
$ wso "SDCL ", file
$ goto 23033
$ 23032: 
$ sdcl_processor 'file'
$ 23033: 
$ 23031: 
$ file = f$search(fspec)
$ if (.not.(file .eqs. temp)) then goto 23034
$ goto 23029
$ 23034: 
$ goto 23028
$ 23029: 
$ i = i + 1
$ fspec = f$element(i, ",", list)
$ goto 23024
$ 23025: 
$ if (.not.(batch .or. com_file)) then goto 23036
$ write outf "$! End of SDCLing"
$ write outf "$ The_End:"
$ write outf "$        exit"
$ close outf
$ if (.not.(.not. debug)) then goto 23038
$ if (.not.(batch)) then goto 23040
$ submit/delete/noprint/log='current_directory''log_file' 'temp_file_name'
$ goto 23041
$ 23040: 
$ @'temp_file_name'
$ delete 'temp_file_name';*
$ 23041: 
$ 23038: 
$ 23036: 
$ The_End:
$ if (.not.(verify_on)) then goto 23042
$ set verify
$ 23042: 
$ exit
$ OPT$bat:
$ batch = TRUE
$ return 
$ OPT$com:
$ com_file = TRUE
$ return 
