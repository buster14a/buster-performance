set pagination off
set confirm off
break *0x0000000000c99790
commands
silent
printf "C %lx %d\n", *(unsigned long*)$rsp, $esi & 255
continue
end
run
quit
