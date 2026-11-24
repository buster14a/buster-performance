set pagination off
set confirm off
set startup-with-shell off
break c_check_input.c:18178
commands
silent
python import time; print("ARENA_BEGIN", time.monotonic_ns(), gdb.selected_inferior().pid)
continue
end
break c_check_input.c:18742
commands
silent
python import time; print("ARENA_END", time.monotonic_ns(), int(gdb.parse_and_eval("(uintptr_t)sparse.base")), int(gdb.parse_and_eval("sparse.length")))
continue
end
run
