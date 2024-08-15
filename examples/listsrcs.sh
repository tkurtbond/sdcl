lr descrip.mms *.sdcl | tee ~usr/sdclex.lis | sedit 's/%{?+}$/ar uv sdclex.w $1/' | tee ~usr/initsdclex.sh
