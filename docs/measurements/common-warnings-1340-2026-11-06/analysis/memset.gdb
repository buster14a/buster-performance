set pagination off
set breakpoint pending on
set print frame-arguments none
break __memset_avx512_unaligned_erms if $rdx > 262144
commands
silent
printf "memset %lu\n", $rdx
bt 4
cont
end
run
