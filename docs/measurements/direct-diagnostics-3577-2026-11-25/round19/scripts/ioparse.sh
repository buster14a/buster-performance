#!/bin/bash
# ioparse.sh: per-function IBS op statistics of base and work: samples, branches, mispredicts, loads, DC misses, their
# latency, tag-to-retire and completion-to-retire cycles, misaligned accesses.
cd ~/buster-fast-bench/3577-claude || exit 1
for t in base work; do
  perf report -D -i pio-$t.data 2>/dev/null | awk '
    function field(name,   i) { for (i = 2; i < NF; i++) if ($i == name) return $(i+1); return 0 }
    /^ibs_op_ctl:/ { have = 1; next }
    /^IbsOpRip:/ { rip = $2; next }
    /^ibs_op_data:/ { c2r = field("CompToRetCtr"); t2r = field("TagToRetCtr"); br = field("BrnRet"); mis = field("OpBrnMisp"); next }
    /^ibs_op_data3:/ { ld = field("LdOp"); st = field("StOp"); dcm = field("DcMiss"); lat = field("DcMissLat"); mal = field("DcMisAcc"); l2m = field("L2Miss");
                       if (have) printf "%s %d %d %d %d %d %d %d %d %d %d\n", rip, t2r, c2r, br, mis, ld, st, dcm, lat, mal, l2m; have = 0 }' > io-samples-$t.txt
  awk -v T=$t 'NR == FNR { a[n] = strtonum("0x" $1); s[n] = $2; n++; next }
    { x = strtonum("0x" $1); lo = 0; hi = n - 1; if (x < a[0]) { f = "?" } else { while (lo < hi) { mid = int((lo + hi + 1) / 2); if (a[mid] <= x) lo = mid; else hi = mid - 1 } f = s[lo] }
      N[f]++; T2[f] += $2; C2[f] += $3; B[f] += $4; M[f] += $5; LD[f] += $6; DM[f] += $8; DL[f] += $9; MA[f] += $10; tot++ }
    END { printf "TOTAL\t%s\t%d\n", T, tot; for (f in N) printf "F\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", T, f, N[f], T2[f], C2[f], B[f], M[f], LD[f], DM[f], DL[f], MA[f] }' if-syms-$t.txt io-samples-$t.txt
done > io-sum.txt
grep TOTAL io-sum.txt
echo "fn | base: n t2r c2r br mis ld dcm dclat mal | work: same"
for f in fast_pp_run_calls fast_pp_skip_inactive fast_pp_drain fast_skip_block_comment fval_to_gp_full fast_pp_try_expand_nonfunc fast_pp_window_convert fast_pp_handle_define fast_pp_lex_window fast_cc_expr fast_cc_compile_func; do
  b=$(awk -F'\t' -v f=$f '$1=="F" && $2=="base" && $3==f {print $4, $5, $6, $7, $8, $9, $10, $11, $12}' io-sum.txt)
  w=$(awk -F'\t' -v f=$f '$1=="F" && $2=="work" && $3==f {print $4, $5, $6, $7, $8, $9, $10, $11, $12}' io-sum.txt)
  echo "$f | $b | $w"
done
