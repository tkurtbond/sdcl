! Some of these are intended to produce errors, so use MMK/IGNORE=ERROR.

all :	COMPOUNDS.COM, DCLLINE_EXAMPLE.COM, MULTILINE-CONTROL.COM, -
	PROBLEM_WITH_CONDITION.COM, TRYSLASHSLASH.COM, UNEXPECTED_ELSE.COM, -
	UNTERMINATED_COMPOUNDS.COM, UNTERMINATED-REPEAT.COM

clean :
	- delete *.com.*/log


SDCL=sdcl
.SUFFIXES : .SDCL

.SDCL.COM :
	$(SDCL) $(MMS$SOURCE)
