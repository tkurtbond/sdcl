$ !> TOTAL.SDCL -- Total up the hours in 'root'yyyymmdd.TIME (v1.1)
$ sort_date = f$cvtime(p1,, "date") - "-" - "-" - "-" 
$ if (.not.(p2 .nes. "")) then goto 23000
$ root = p2
$ goto 23001
$ 23000: 
$ time_lib = f$trnlnm("TIME_LIB")
$ if (.not.(time_lib .eqs. "")) then goto 23002
$ root = "sys$disk:[]" 
$ goto 23003
$ 23002: 
$ root = time_lib 
$ 23003: 
$ 23001: 
$ filename = root + sort_date + ".time"
$ if (.not.(f$search(filename) .eqs. "")) then goto 23004
$ write sys$output "total: error, file does not exist, ", filename
$ exit
$ 23004: 
$ open/read/error=Cant_Open inf 'filename'
$ read inf line /end=Error_Reading /err=Error_Reading
$ 23006: if (.not.(f$locate("=====", line) .eq. f$length(line))) then goto 23007
$ read inf line /end=Error_Reading /err=Error_Reading
$ goto 23006
$ 23007: 
$ hours = 0
$ minutes = 0
$ total = 0
$ 23008: 
$ read inf line /end=End_File /err=Error_Reading
$ if (.not.(f$locate("=====", line) .ne. f$length(line))) then goto 23011
$ goto 23010
$ 23011: 
$ hours = f$integer(f$extract(74, 2, line))
$ minutes = f$integer(f$extract(77, 2, line))
$ total = total + (hours * 60) + minutes
$ 23009: goto 23008
$ 23010: 
$ End_File:
$ total_hours = total / 60
$ total_minutes = total - (total_hours * 60)
$ write sys$output f$fao("Total: !2ZL:!2ZL", total_hours, total_minutes)
$ close inf
$ The_End:
$ exit
$ Cant_Open:
$ write sys$output "total: error opening file, ", filename
$ exit
$ Error_Reading:
$ write sys$output "total: error reading file, ", filename
$ close inf
$ exit
