# Input: harness lines "MARCH NAME padP kernel n reps secs ns digest | ...". Prints per-kernel pad0/best and geomeans.
$1 != "perf" && $3 ~ /^pad/ {
    v = $8 + 0; key = $2 SUBSEP $4
    if ($3 == "pad0") p0[key] = v
    if (!(key in best) || v < best[key]) best[key] = v
    dig[key] = $9; kern[$4] = 1; build[$2] = 1
}
END {
    split("dot_f32 prefix_sum_i32 histogram_u8 find_u8 crc32_table fnv1a", c, " ")
    for (i in c) ctl[c[i]] = 1
    n = split("main-tier1-vec buster-tier1-vec", B, " ")
    for (k in kern) for (b in build) if (dig[b SUBSEP k] != dig["clang-O2" SUBSEP k]) print "DIGEST MISMATCH", b, k
    for (j = 1; j <= n; j++) {
        b = B[j]; s0 = sb = s0c = sbc = 0; m = mc = 0
        for (k in kern) {
            r0 = log(p0[b SUBSEP k] / p0["clang-O2" SUBSEP k]); rb = log(best[b SUBSEP k] / best["clang-O2" SUBSEP k])
            if (k in ctl) { s0c += r0; sbc += rb; mc++ } else { s0 += r0; sb += rb; m++ }
        }
        printf "%s / clang-O2: %d loops %.2f / %.2f; %d controls %.2f / %.2f\n", b, m, exp(s0 / m), exp(sb / m), mc, exp(s0c / mc), exp(sbc / mc)
    }
    split("count_eq_u8 aos_sum rgb_to_gray", T, " ")
    for (i = 1; i <= 3; i++) { k = T[i]
        printf "%s: clang %.4f/%.4f main %.4f/%.4f branch %.4f/%.4f ns; branch/clang %.2f/%.2f; main/branch %.2f/%.2f\n", k,
            p0["clang-O2" SUBSEP k], best["clang-O2" SUBSEP k], p0["main-tier1-vec" SUBSEP k], best["main-tier1-vec" SUBSEP k],
            p0["buster-tier1-vec" SUBSEP k], best["buster-tier1-vec" SUBSEP k],
            p0["buster-tier1-vec" SUBSEP k] / p0["clang-O2" SUBSEP k], best["buster-tier1-vec" SUBSEP k] / best["clang-O2" SUBSEP k],
            p0["main-tier1-vec" SUBSEP k] / p0["buster-tier1-vec" SUBSEP k], best["main-tier1-vec" SUBSEP k] / best["buster-tier1-vec" SUBSEP k] }
    for (k in kern) if (!(k in ctl)) { r = best["buster-tier1-vec" SUBSEP k] / best["main-tier1-vec" SUBSEP k]; if (r > 1.05 || r < 0.95) printf "changed %s: branch/main best %.3f\n", k, r }
}
