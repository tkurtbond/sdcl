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
