lr descrip.mms *.sdcl | tee ~usr/sdcltest.lis | sedit 's/%{?+}$/ar uv sdcltest.w $1/' | tee ~usr/initsdcltest.sh
