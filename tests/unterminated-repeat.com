$ 23000: 
$ write sys$output "outer repeat body"
$ 23003: 
$ write sys$output "inner repeat body"
$ 23004: goto 23003
$ 23005: 
$ 23001: goto 23000
$ 23002: 
