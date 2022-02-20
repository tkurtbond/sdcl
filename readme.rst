SDCL -- Structured DCL
@@@@@@@@@@@@@@@@@@@@@@

This version of SDCL is a complete rewrite from scratch, inspired by
original SDCL written by Sohail Aslam, of the University of Colorado
at Colorado Springs, which was available from the DECUS program
library as VAX-143.

To run SDCL you need to set it up as a foreign comment, like this:

	$ sdcl :== $dev:[dir]sdcl 

where `dev' is the device SDCL is on and `dir' is the directory it is
in.  

To rebuild SDCL just execute the file BUILD_SDCL.COM (which assumes
you are using the VAX/VMS C Compiler; if you are using the GNU C
compiler, execute BUILD_SDCL.COM with a first parameter of "GCC").

**2022 Note:** If you have MMS or MMK_ you can build with them using
DESCRIP.MMS instead.  DESCRIP.MMS assumes you are using the VAX port
of GCC 2.7.1, but should be easy to adapt to VMS C To rebuild
completely from scratch you need SSTG_, a Simple Scanner Table
Generator, to generate CODES.H and LEXTAB.H from SDCL.TABLE, which is
generated from SDCL.SCN.

The file TODO in this directory lists things that need to be done to
improve SDCL.  PROBLEMS. is a list of problems in the SDCL
implementation, mostly fixed.  Documentation for SDCL is in SDCL.MAN.
The files in [.EXAMPLES] are example command procedures written in
SDCL.  The files in [.TESTS] for testing SDCL.  

The file ioinit.c was distrubted as part of another program on a DECUS 
tape.  Unfortuantely I don't remember which one, or who to credit it 
to.

.. _MMK: https://vms.process.com/scripts/fileserv/fileserv_search.exe?package=mmk&description=&author=&system=Either&language=All&RD=&RM=&RY=
.. _SSTG: https://github.com/tkurtbond/sstg