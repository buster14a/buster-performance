set pagination off
set debuginfod enabled off
catch syscall exit_group
run
source scripts/smaps.py
kill
