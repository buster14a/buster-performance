# One line per ab run of #2925's A/B: round, tree, list, and the vectorized arm's medians (benchmark-preprocessor):
# its run (ms), instructions an input token, the run with printing (ms) and the printing (ms); for --tables, the
# tables' ms and cycles a token.
/^== round / {
    round = $3; tree = $5; sub(/^\.\.\//, "", tree)
    list = index($0, "--tables") ? "tables" : index($0, "--markers") ? "markers" : "clang-P"
    arm = 0; next
}
/^  vectorized/ && list != "tables" { arm = 1; ms = $2; for (i = 1; i <= NF; i++) if ($(i + 1) == "instructions/input") ins = $i; next }
/^  scalar/ { arm = 0; next }
arm && /with printing/ {
    for (i = 1; i <= NF; i++) { if ($i == "printing" && $(i - 1) == "with") total = $(i + 1); if ($i == "(printing") printing = $(i + 1) }
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", round, tree, list, ms, ins, total, printing
    arm = 0
}
/^  vectorized/ && list == "tables" { for (i = 1; i <= NF; i++) if ($(i + 1) == "cycles/token") cyc = $i; printf "%s\t%s\t%s\t%s\t-\t-\t%s\n", round, tree, list, $2, cyc }
