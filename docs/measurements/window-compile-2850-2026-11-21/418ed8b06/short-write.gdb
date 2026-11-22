set confirm off
set debuginfod enabled off
set env BUSTER_OBJECT_TEXT_STREAM 1
set env BUSTER_OBJECT_TEXT_RUNS 1
set env BUSTER_CONTROL_SOURCE_NATIVE 1
set env BUSTER_CONTROL_EARLY_NATIVE 1
set env BUSTER_CONTROL_EARLY_RELEASE 1
set env BUSTER_CONTROL_OBJECT_FIELDS 1
catch syscall pwritev
set $state=0
commands
silent
if $state==0
 set $pointer=$rsi+8
 set $original=*(unsigned long long*)$pointer
 set $rdx=1
 set *(unsigned long long*)$pointer=7
 set $state=1
else
 if $state==1
  printf "kernel-wrote=%ld first-span-length=%llu\n", $rax, $original
  set *(unsigned long long*)$pointer=$original
  set $state=2
  disable 1
 end
end
continue
end
run
