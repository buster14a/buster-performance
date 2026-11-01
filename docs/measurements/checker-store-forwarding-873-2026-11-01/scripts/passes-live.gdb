set pagination off
set confirm off
break *0x0000000000eff380
break *0xf00259
break *0xf00264
ignore 1 1000000000
ignore 2 1000000000
ignore 3 1000000000
run
info breakpoints
quit
