$ verify_on = 'f$verify(0)'
$ !> SDCL.SDCL -- provide default name and extension for the SDCL preprocessor
$ file = p1
$ switches = p2
$ sdcl_processor = "$sdcl_dir:sdcl"
$ if (.not.(f$extract(0, 1, file) .eqs. "-")) then goto 23000
$ switches = file
$ file = ""
$ 23000: 
$ if (.not.(file .eqs. "")) then goto 23002
$ inquire file "_SDCL file <''f$trnlnm("EDIT_FILE")'>"
$ if (.not.(file .eqs. "")) then goto 23004
$ file = f$trnlnm("EDIT_FILE")
$ 23004: 
$ if (.not.(file .eqs. "")) then goto 23006
$ exit (1 .or. (f$verify(verify_on) .and. 0))
$ 23006: 
$ 23002: 
$ define edit_file 'file'
$ write sys$output "Processing ''f$parse(file,,,"name")'"
$ file = f$parse(file, ".sdcl")
$ i = f$locate("]", file)
$ if (.not.(i .ne. f$length(file))) then goto 23008
$ file = f$extract(i + 1, f$length(file), file)
$ i = f$locate("]", file)
$ if (.not.(i .ne. f$length(file))) then goto 23010
$ file = f$extract(i + 1, f$length(file), file)
$ 23010: 
$ 23008: 
$ sdcl_processor 'file' 'switches'
$ The_End:
$ exit (1 .or. (f$verify(verify_on) .and. 0))
