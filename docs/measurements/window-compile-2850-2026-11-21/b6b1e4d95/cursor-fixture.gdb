set pagination off
set confirm off
set debuginfod enabled off
break check_test_programs
run
printf "cursor-shard=%u/8\n", ((check_test_part.dealt + 1) % 8) + 1
quit
