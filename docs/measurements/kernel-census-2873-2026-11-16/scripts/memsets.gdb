# memsets.gdb: every memset and memmove of 64 KB or more in the compile, with its destination, size and return address
# (its caller), for the first touches item 2 finds inside them (memsets.sh).
set pagination off
set confirm off
set print thread-events off
unset environment LINES
unset environment COLUMNS
break __memset_avx512_unaligned_erms if $rdx >= 65536
commands
silent
printf "memset\t%lx\t%lx\t", $rdi, $rdx
info symbol *(long*)$rsp
continue
end
break __memset_avx512_unaligned if $rdx >= 65536
commands
silent
printf "memset\t%lx\t%lx\t", $rdi, $rdx
info symbol *(long*)$rsp
continue
end
break __memmove_avx512_unaligned_erms if $rdx >= 65536
commands
silent
printf "memmove\t%lx\t%lx\t", $rdi, $rdx
info symbol *(long*)$rsp
continue
end
break __memmove_avx512_unaligned if $rdx >= 65536
commands
silent
printf "memmove\t%lx\t%lx\t", $rdi, $rdx
info symbol *(long*)$rsp
continue
end
run
