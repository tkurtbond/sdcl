lr  .indent_pro *.txt *.com *.h *.c makefile. *.rst *.rno *.scn *.table *.text *.sh | tee ~usr/sdcl.lis | sedit 's/%{?+}$/ar uv sdcl.w $1/' | tee ~usr/initsdcl.sh
