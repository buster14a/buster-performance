set pagination off
set complaints 1000
file ./dbg
maint expand-symtabs
break t1i_mark
run
bt
up
maint info blocks
printf "GDB-T1I-DONE\n"
kill
