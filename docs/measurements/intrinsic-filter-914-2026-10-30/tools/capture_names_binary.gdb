# Original diagnostic-only capture, Linux/x86-64 SysV ABI. No inferior calls.
# check_input_intrinsic_lookup entry arguments: rsi=names, ecx=lanes.
# BuiltinIntrinsicName pointer offset0, u32 length offset8, stride16.
# The target u32 length is already little-endian. Dump its four bytes, then
# append exactly the counted source bytes. No NUL assumptions or text encoding.
# Set $capture_output to a trusted absolute path without spaces before sourcing.
set pagination off
set confirm off
set debuginfod enabled off
set print thread-events off
set breakpoint pending off
init-if-undefined $capture_output = "/tmp/buster-intrinsic-names.u32le"
init-if-undefined $capture_max_names = 1000000
init-if-undefined $capture_max_length = 1048576
set $capture_batches = 0
set $capture_names = 0
break *check_input_intrinsic_lookup
commands
    silent
    set $capture_array = (unsigned char*)$rsi
    set $capture_lanes = (unsigned int)$ecx
    if $capture_lanes > 8 || $capture_array == 0
        printf "CAPTURE_ERROR invalid batch lanes=%u array=%p\n", $capture_lanes, $capture_array
        quit 2
    end
    if $capture_names + $capture_lanes > $capture_max_names
        printf "CAPTURE_ERROR name budget exceeded\n"
        quit 2
    end
    printf "CAPTURE_BATCH index=%u names_before=%u lanes=%u\n", $capture_batches, $capture_names, $capture_lanes
    set $capture_lane = 0
    while $capture_lane < $capture_lanes
        set $capture_name = *(unsigned char**)($capture_array + 16 * $capture_lane)
        set $capture_length_address = $capture_array + 16 * $capture_lane + 8
        set $capture_length = *(unsigned int*)$capture_length_address
        if $capture_length > $capture_max_length || ($capture_length != 0 && $capture_name == 0)
            printf "CAPTURE_ERROR invalid counted name length=%u pointer=%p\n", $capture_length, $capture_name
            quit 2
        end
        if $capture_names == 0
            eval "dump binary memory %s %p %p", $capture_output, $capture_length_address, $capture_length_address + 4
        else
            eval "append binary memory %s %p %p", $capture_output, $capture_length_address, $capture_length_address + 4
        end
        if $capture_length != 0
            eval "append binary memory %s %p %p", $capture_output, $capture_name, $capture_name + $capture_length
        end
        set $capture_names = $capture_names + 1
        set $capture_lane = $capture_lane + 1
    end
    set $capture_batches = $capture_batches + 1
    continue
end
run
printf "CAPTURE_DONE batches=%u names=%u\n", $capture_batches, $capture_names
if $capture_names == 0
    quit 2
end
if $_exitcode != 0
    quit 3
end
quit
