$ if (.not.(this)) then goto 23000
this is a dcl line     x
$ goto 23001
$ 23000: 
this is also a dcl line	x
$ 23001: 
$ exit
