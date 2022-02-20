$ wso :== write sys$output
$ if (.not.(cond)) then goto 23000
$ wso "then"
$ goto 23001
$ 23000: 
$ wso "else"
$ 23001: 
$ if (.not.(cond)) then goto 23002
$ wso "compound then"
$ goto 23003
$ 23002: 
$ wso "compound else"
$ 23003: 
$ if (.not.(cond)) then goto 23004
$ wso "cuddled braces compound then"
$ goto 23005
$ 23004: 
$ wso "cuddled braces compound else"
$ 23005: 
$ 23006: if (.not.(cond)) then goto 23007
$ wso "while body"
$ goto 23006
$ 23007: 
$ 23008: if (.not.(cond)) then goto 23009
$ wso "compound while body"
$ goto 23008
$ 23009: 
$ i = 1
$ 23010: if (.not.(i .lt 10)) then goto 23012
$ wso "for body"
$ 23011: i = i + 1
$ goto 23010
$ 23012: 
$ i = 1
$ 23013: if (.not.(i .lt 10)) then goto 23015
$ wso "compound for body"
$ 23014: i = i + 1
$ goto 23013
$ 23015: 
$ 23016: 
$ wso "do body"
$ 23017: if (cond) then goto 23016
$ 23018: 
$ 23019: 
$ wso "do body on same line as do"
$ 23020: if (cond) then goto 23019
$ 23021: 
$ 23022: 
$ wso "compound do body"
$ 23023: if (cond) then goto 23022
$ 23024: 
