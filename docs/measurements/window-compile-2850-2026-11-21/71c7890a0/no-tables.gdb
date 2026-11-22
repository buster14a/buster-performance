set debuginfod enabled off
set confirm off
set env BUSTER_CONTROL_SOURCE_NATIVE 1
set env BUSTER_CONTROL_SOURCE_AUDIT 1
break check_live_control_native
commands
silent
set {unsigned char}&tier0_initialized = 0
continue
end
run
