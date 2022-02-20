$ !> HOURS.SDCL -- Create time use record of hours worked for current date (v1.5)
$ TRUE = (1 .eq. 1)
$ FALSE = .not. TRUE
$ wso = "write sys$output"
$ get = "read/end=End_File/error=End_file sys$command"
$ months = "January/February/March/April/May/June/July" + "/August/September/October/November/December"
$ default_width = 79 
$ heading = "Time Use Record" 
$ format_string = "!8AS  !17<!AS to !AS!>  !43AS  !5AS"
$ time_lib = f$trnlnm("TIME_LIB")
$ if (.not.(time_lib .eqs. "")) then goto 23000
$ root = "sys$disk:[]" 
$ goto 23001
$ 23000: 
$ root = time_lib 
$ 23001: 
$ time = f$time()
$ get newtime /prompt="Time <''time'>? " 
$ if (.not.(newtime .nes. "")) then goto 23002
$ time = newtime
$ 23002: 
$ nice_date = f$cvtime(time,, "weekday") + ", " + f$cvtime(time, "absolute", -
  "day") + " " + f$element(f$integer(f$cvtime(time,, "month"))-1, "/", months) -
  + " " + f$cvtime(time,, "year")
$ sort_time = f$cvtime(time, "comparison", "date") - "-" - "-"
$ date = f$cvtime(time,,"month") + "/" + f$cvtime(time,,"day") + "/" + f$extract(2, -
  2, f$cvtime(time,,"year"))
$ file_name = root + sort_time + ".time"
$ if (.not.(f$search(file_name) .nes. "")) then goto 23004
$ open /append outf 'file_name'
$ goto 23005
$ 23004: 
$ open /write outf 'file_name'
$ write outf ""
$ i = (default_width - f$length(nice_date)) / 2
$ write outf f$fao("!''i'* !AS", nice_date)
$ i = (default_width - f$length(heading)) / 2
$ write outf f$fao("!''i'* !AS", heading)
$ write outf f$fao("!''default_width'*=")
$ 23005: 
$ last_end_time = "" 
$ last_description = ""
$ get start_time /prompt="Start Time:  "
$ 23006: if (.not.(start_time .nes. "")) then goto 23008
$ start_time = f$edit(start_time, "compress")
$ if (.not.(start_time .eqs. "=")) then goto 23009
$ start_time = last_end_time
$ wso "        Start Time is: ", start_time
$ 23009: 
$ get end_time /prompt="End Time:    "
$ end_time = f$edit(end_time, "compress")
$ last_end_time = end_time
$ get description /prompt="Description: "
$ if (.not.(f$edit(description, "compress") .eqs. "=")) then goto 23011
$ description = last_description
$ wso "     Description is: ", description
$ goto 23012
$ 23011: 
$ last_description = description
$ 23012: 
$ st_len = f$length(start_time)
$ et_len = f$length(end_time)
$ i = f$locate(".", start_time)
$ if (.not.(i .ne. st_len)) then goto 23013
$ start_time[i*8, 8] = 58 
$ 23013: 
$ j = f$locate(".", end_time)
$ if (.not.(j .ne. et_len)) then goto 23015
$ end_time[j*8, 8] = 58 
$ 23015: 
$ i = f$locate(":", start_time)
$ j = f$locate(":", end_time)
$ st_hours = f$integer(f$extract(0, i, start_time))
$ st_minutes = f$integer(f$extract(i+1, st_len, start_time))
$ et_hours = f$integer(f$extract(0, j, end_time))
$ if (.not.(et_hours .lt. st_hours)) then goto 23017
$ et_hours = et_hours + 12 
$ 23017: 
$ et_minutes = f$integer(f$extract(j+1, et_len, end_time))
$ temp_dur = ((et_hours * 60) + et_minutes) - ((st_hours * 60) + st_minutes)
$ duration = f$fao("!2ZL:!2ZL", temp_dur / 60, temp_dur - ((temp_dur / 60) -
  * 60))
$ write outf f$fao(format_string, date, start_time, end_time, description, -
  duration)
$ 23007: get start_time /prompt="Start Time:  "
$ goto 23006
$ 23008: 
$ close outf
$ The_End:
$ exit
$ End_File:
$ write sys$error "report: end of file or error on input, exiting..."
$ close outf
$ exit
