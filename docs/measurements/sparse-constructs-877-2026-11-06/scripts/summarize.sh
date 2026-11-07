#!/bin/bash
# #877: each pair's stage medians from measure.sh stages' output (ab's rounds of measure-compile). For each build and
# stage: the median over its offsets and rounds; each offset's median over its rounds and their spread; the merge's
# median against the base's, with its range over the offsets as time-runs gives it (each of the merge's offset medians
# against each of the base's: they pair nothing, since an offset of one tree isn't that offset of the other); and
# each round's median over the offsets, the merge's against the base's. Usage: summarize.sh STAGES.txt BASE HEAD
set -u
export LC_ALL=C
awk -v base="$2" -v head="$3" '
function sorted(list, n,    i, j, t) { for (i = 2; i <= n; i++) { t = list[i]; for (j = i - 1; j >= 1 && list[j] > t; j--) list[j + 1] = list[j]; list[j + 1] = t } }
function median(list, n) { sorted(list, n); return n % 2 ? list[(n + 1) / 2] : (list[n / 2] + list[n / 2 + 1]) / 2 }
/^== round / {
    round = $3; path = $5
    n = split(path, parts, "/"); exe = parts[n]; tree = parts[n - 1]
    sub(/^compiler-/, "", exe); offset = exe
    build = tree == base ? "base" : tree == head ? "head" : "other"
    if (!(offset in seen_offset)) { seen_offset[offset] = 1; offsets[++offset_count] = offset }
    if (!(round in seen_round)) { seen_round[round] = 1; rounds[++round_count] = round }
    next
}
/^default: median of/ { value[build, offset, round, "wall"] = $5; stage_seen("wall"); next }
/^  [a-z]/ && $2 ~ /^[0-9.]+$/ { value[build, offset, round, $1] = $2; stage_seen($1); next }
function stage_seen(s) { if (!(s in seen_stage)) { seen_stage[s] = 1; stages[++stage_count] = s } }
END {
    printf "%-16s %10s %10s %8s  %-21s %-15s %-15s  %s\n", "stage (ms)", "base", "merge", "change", "over offsets", "base offsets", "merge offsets", "rounds (merge against base)"
    for (s = 1; s <= stage_count; s++) {
        st = stages[s]
        for (b = 1; b <= 2; b++) {
            bn = b == 1 ? "base" : "head"; k = 0; lo[bn] = 1e18; hi[bn] = -1
            for (o = 1; o <= offset_count; o++) {
                m = 0
                for (r = 1; r <= round_count; r++) if ((bn, offsets[o], rounds[r], st) in value) { all[++k] = value[bn, offsets[o], rounds[r], st]; one[++m] = value[bn, offsets[o], rounds[r], st] }
                if (m) { om = median(one, m); lo[bn] = om < lo[bn] ? om : lo[bn]; hi[bn] = om > hi[bn] ? om : hi[bn] }
            }
            med[bn] = k ? median(all, k) : 0
            for (r = 1; r <= round_count; r++) {
                m = 0
                for (o = 1; o <= offset_count; o++) if ((bn, offsets[o], rounds[r], st) in value) one[++m] = value[bn, offsets[o], rounds[r], st]
                per_round[bn, r] = m ? median(one, m) : 0
            }
        }
        if (med["base"] <= 0) continue
        line = ""
        for (r = 1; r <= round_count; r++) line = line sprintf(" %+.2f%%", per_round["base", r] > 0 ? (per_round["head", r] / per_round["base", r] - 1) * 100 : 0)
        printf "%-16s %10.3f %10.3f %+7.2f%%  %+6.2f%% to %+6.2f%%  spread %5.2f%%   spread %5.2f%%  %s\n", st, med["base"], med["head"],
            (med["head"] / med["base"] - 1) * 100, (lo["head"] / hi["base"] - 1) * 100, (hi["head"] / lo["base"] - 1) * 100,
            (hi["base"] / lo["base"] - 1) * 100, (hi["head"] / lo["head"] - 1) * 100, line
    }
}' "$1"
