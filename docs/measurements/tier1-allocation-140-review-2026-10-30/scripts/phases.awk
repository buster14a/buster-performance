# Sums `perf report --sort srcline --stdio` shares of a harness run by allocator phase. Line ranges are those of
# tier1_allocate.c at the measured commit, of make_proto.sh's proto_impl.c and of this record's harness.c.
/%/ {
    share = $1; sub("%", "", share)
    split($2, place, ":"); file = place[1]; line = place[2] + 0
    phase = "other (libc memset and memcpy, harness)"
    if (file == "tier1_allocate.c" && line >= 115 && line <= 158) phase = "1 input validation (tier1_allocation_input_valid)"
    else if (file == "tier1_allocate.c" && line >= 160 && line <= 185) phase = "x next-use binary search"
    else if (file == "proto_impl.c" && line <= 86) phase = "0 arena pushes"
    else if (file == "proto_impl.c" && line <= 114) phase = "2 memsets, per-interval initialization, bucket counts"
    else if (file == "proto_impl.c" && line <= 118) phase = "3 bucket prefix sum"
    else if (file == "proto_impl.c" && line <= 140) phase = "4 event placement"
    else if (file == "proto_impl.c" && line <= 158) phase = "5 value-overlap validation"
    else if (file == "proto_impl.c" && line >= 163 && line <= 196) phase = "6 per-class count and pressure passes"
    else if (file == "proto_impl.c" && line >= 197 && line <= 222) phase = "7b class dispatch"
    else if (file == "proto_impl.c" && line >= 223) phase = "8 fragment publication"
    else if (file == "harness.c" && line >= 20 && line <= 50) phase = "7 coloring (proto_color)"
    total[phase] += share
}
END { for (phase in total) printf "%6.2f%%  %s\n", total[phase], phase }
