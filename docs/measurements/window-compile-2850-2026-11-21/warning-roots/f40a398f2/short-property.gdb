set pagination off
set confirm off
set debuginfod enabled off
break *check_test_driver_common_trees
run
set $test=(CheckTest*)$rdi
set $start=$test->checks
set $bad=$test->failures
tbreak *(*(void **)$rsp)
continue
printf "tree-property-checks %u failures %u\n", $test->checks-$start,$test->failures-$bad
quit
