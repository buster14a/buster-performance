#!/bin/sh
# Summarize the gate's IR dataflow logs: each operation's totals, then by block count, phi uses and row width, and the
# losing solve bucket's instructions. Usage: sh summarize.sh logs/ir-edges.log logs/ir-sqlite.log.xz
for f in "$@"; do
    case "$f" in *.xz) xz -dc "$f" ;; *) cat "$f" ;; esac
done | awk '
/^ir-dataflow-benchmark:/ {
    for (i = 2; i <= NF; i++) { split($i, kv, "="); v[kv[1]] = kv[2] }
    key = v["file"] "|" v["function"] "|" v["form"] "|" v["operation"]
    c[key, v["path"]] = v["cycles_per_function"]; ops[key] = v["operation"]; bl[key] = v["blocks"]
    ph[key] = v["phi_uses"]; rw[key] = v["row_words"]; dn[key] = v["dense"]; fn[key] = v["function"] " " v["form"]
}
/^ir-dataflow-sample:/ && / operation=solve / {
    for (i = 2; i <= NF; i++) { split($i, kv, "="); w[kv[1]] = kv[2] }
    skey = w["file"] "|" w["function"] "|" w["form"] "|solve"
    sins[skey, w["path"]] += w["instructions"] / w["repeats"]; scyc[skey, w["path"]] += w["cycles"] / w["repeats"]; sn[skey, w["path"]] += 1
}
END {
    for (k in ops) {
        o = ops[k]; s = c[k, "scalar"]; x = c[k, "vector"]
        n[o]++; ts[o] += s; tv[o] += x; if (x > s * 1.02) l[o]++
        b = bl[k]; bk = b <= 2 ? "blocks<=2" : b <= 8 ? "blocks3-8" : b <= 32 ? "blocks9-32" : b <= 128 ? "blocks33-128" : "blocks>128"
        p = ph[k] == 0 ? "no-phi" : "phi"; r = rw[k] + 0 == 0 ? "words0" : rw[k] + 0 == 8 ? "words8" : "words16+"
        g = o " " bk " " p " " r; gn[g]++; gs[g] += s; gv[g] += x; if (x > s * 1.02) gl[g]++
        if (o == "solve" && p == "no-phi" && r == "words8" && b >= 33 && b <= 128 && dn[k] <= 64) {
            for (q = 0; q < 2; q++) { path = q ? "scalar" : "vector"; bi[path] += sins[k, path] / sn[k, path]; bc[path] += scyc[k, path] / sn[k, path] }
            bn += 1
        }
    }
    for (o in n) printf "%s: forms=%d scalar_cycles=%.0f vector_cycles=%.0f vector/scalar=%.3f vector_slower_by_2%%=%d\n", o, n[o], ts[o], tv[o], tv[o] / ts[o], l[o]
    for (g in gn) printf "  %-40s forms=%5d scalar=%11.0f vector=%11.0f vector/scalar=%.3f slower_by_2%%=%d\n", g, gn[g], gs[g], gv[g], gv[g] / gs[g], gl[g]
    if (bn != 0) for (q = 0; q < 2; q++) { path = q ? "scalar" : "vector"; printf "solve, no phi, 33-128 blocks, <=64 values (%d forms), %s: instructions/solve=%.1f cycles/solve=%.1f IPC=%.2f\n", bn, path, bi[path] / bn, bc[path] / bn, bi[path] / bc[path] }
}' | sort
