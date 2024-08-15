PROGRAMS=dirsize.com, hours.com, pipes.com, sdcl.com, total.com

all : $(PROGRAMS)

SDCL=rawsdcl ! use the executable directly.
.SUFFIXES : .SDCL .COM

.SDCL.COM : 
        $(SDCL) -o $(MMS$TARGET) $(MMS$SOURCE)


clean :
        - delete *.com.*
