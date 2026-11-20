set pagination off
set confirm off
set debuginfod enabled off
set disable-randomization off
set $hits = 0
break *0x4602d4
commands
silent
set $hits = $hits+1
continue
end
run
printf "vector_multiply_hits=%d inferior_exit=%d\n", $hits, $_exitcode
