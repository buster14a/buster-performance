#!/bin/bash
# summary.sh FILE...: of time-runs' runs in FILEs (compare.sh's), each build's count, median and least wall time (ms),
# median user cycles and median instructions, and each build's medians over base's, in percent. No lock.
awk '
function sorted(values, count, into,    i, j, t) {
    for (i = 1; i <= count; i += 1) into[i] = values[i]
    for (i = 2; i <= count; i += 1) { t = into[i]; for (j = i - 1; j >= 1 && into[j] > t; j -= 1) into[j + 1] = into[j]; into[j + 1] = t }
}
function median(values, count,    s) { sorted(values, count, s); return count % 2 ? s[(count + 1) / 2] : (s[count / 2] + s[count / 2 + 1]) / 2 }
function least(values, count,    s) { sorted(values, count, s); return s[1] }
/^run [0-9]+ list [0-9]+ / && / status 0$/ {
    build = $5
    for (i = 1; i < NF; i += 1) {
        if ($(i + 1) == "ms" && $(i + 2) == "wall,") wall = $i
        if ($(i + 1) == "user" && $(i + 2) == "cycles,") cycles = $i
        if ($(i + 1) == "instructions,") instructions = $i
    }
    if (!(build in n)) { order[++builds] = build }
    n[build] += 1
    w[build, n[build]] = wall; c[build, n[build]] = cycles; ins[build, n[build]] = instructions
}
/^run [0-9]+ list [0-9]+ / && !/ status 0$/ { failed += 1 }
END {
    printf "%-12s %5s %12s %12s %16s %16s %9s %9s %9s\n", "build", "runs", "wall median", "wall least", "cycles median", "instructions", "wall %", "cycles %", "instr %"
    for (b = 1; b <= builds; b += 1) {
        build = order[b]
        for (i = 1; i <= n[build]; i += 1) { a[i] = w[build, i]; d[i] = c[build, i]; e[i] = ins[build, i] }
        mw[build] = median(a, n[build]); lw = least(a, n[build]); mc[build] = median(d, n[build]); mi[build] = median(e, n[build])
        printf "%-12s %5d %12.3f %12.3f %16.0f %16.0f %+9.3f %+9.3f %+9.3f\n", build, n[build], mw[build], lw, mc[build], mi[build],
               100 * (mw[build] / mw[order[1]] - 1), 100 * (mc[build] / mc[order[1]] - 1), 100 * (mi[build] / mi[order[1]] - 1)
    }
    if (failed) printf "failed runs: %d\n", failed
}' "$@"
