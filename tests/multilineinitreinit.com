$ i = 0
 s = ""
$ 23000: if (.not.(i .lt. 10)) then goto 23002
$ write sys$output "i: ", i, " s: ", s
$ 23001: i = i + 1
 s = s + "."
$ goto 23000
$ 23002: 
$ write sys$output "at end: i: ", i, " s: ", s
