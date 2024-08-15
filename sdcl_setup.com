$ where = f$environment("PROCEDURE")
$ where = f$parse(where,,, "DEVICE") + f$parse(where,,, "DIRECTORY")
$ root = where - "]"
$ define sdcl_dir 'where'
$ sdcl :== $sdcl_dir:sdcl.exe
$ rawsdcl :== $sdcl_dir:sdcl.exe
$! This SDCL command procedure remembers what SDCL procedure you
$! compiled last, so you don't have to.  Uncomment it to use.
$! sdcl :== @'root'.examples]sdcl.com
