$ root = f$environment("PROCEDURE")
$ dir_spec = f$parse(root,,,"DEVICE") + f$parse(root,,,"DIRECTORY")
$ set def 'dir_spec'
$ makecom ml:make
$ make
