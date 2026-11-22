# One line per ab run of #2925's in-process A/B over placements: round, build, shift, list (P: -E -P's printing;
# markers: -E's with line markers), and the vectorized kernels' medians: the run (ms), instructions an input token,
# the run with printing (ms) and the printing (ms).
/^== round / {
    round = $3; exe = $5; n = split(exe, parts, "/"); name = parts[n]
    build = name; sub(/-[0-9]+$/, "", build); shift_ = name; sub(/^.*-/, "", shift_)
    list = index($0, "--markers") ? "markers" : "P"
    arm = 0; next
}
/^  vectorized/ { arm = 1; ms = $2; for (i = 1; i <= NF; i++) if ($(i + 1) == "instructions/input") ins = $i; next }
arm && /with printing/ {
    for (i = 1; i <= NF; i++) { if ($i == "printing" && $(i - 1) == "with") total = $(i + 1); if ($i == "(printing") printing = $(i + 1) }
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", round, build, shift_, list, ms, ins, total, printing
    arm = 0
}
