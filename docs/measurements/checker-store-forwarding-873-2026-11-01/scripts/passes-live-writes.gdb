set pagination off
set confirm off
break *0x0000000000e993c0
break *0x0000000000e9b180
break *0xe99d44
break *0xe99d4d
ignore 1 1000000000
ignore 2 1000000000
ignore 3 1000000000
ignore 4 1000000000
run
info breakpoints
quit
