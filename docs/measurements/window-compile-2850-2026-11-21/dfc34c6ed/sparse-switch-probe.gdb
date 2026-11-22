set pagination off
set debuginfod enabled off
start
set $probe=(void*)calloc(1,65536)
call (void)check_test_program_sparse_switches($probe)
printf "sparse-switch-test checks=%llu failures=%llu\n", *(unsigned long long*)$probe,*((unsigned long long*)$probe+1)
quit
