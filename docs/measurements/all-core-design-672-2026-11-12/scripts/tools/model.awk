# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# model.awk: the design's estimate of a compile of sqlite3.c at eight workers after each step, from the measured table
# tables.sh writes (model-inputs.tsv). It is an estimate, not a measurement: what each step changes is an assumption
# stated here, in three cases. Usage: awk -f tools/model.awk results/tables/model-inputs.tsv
#
# The inputs, a line a stage (cycles in millions, per compile):
#   stage  user1  user8  bodies1  bodies8  faults8  spine_faults8
# user1 and user8 are the stage's user cycles at one worker and at eight; bodies1 and bodies8 the function bodies' share
# of the stage's time at each (the unit whole against the unit without its bodies); faults8 the pages the stage faults
# in at eight workers and spine_faults8 the same for the unit without its bodies. Lines of `total` give the compile's
# kernel cycles (kernel1, kernel8), frequencies (ghz1, ghz8), source megabytes and body tokens.
#
# The rules:
# - A stage that the chain runs a window at a time costs its one-worker cycles times `eps`, the residual inflation of
#   work that stays in its caches at eight workers (measured for small units and for Tier 0), times `gain1`, what cache
#   residency gives it at one worker. The stages join the chain step by step (the design's steps 1 to 5). In step 2 the
#   graph's run still reads the graph the reader wrote for the whole unit, so `cold` of its excess stays.
# - The kernel's cycles follow the pages faulted: kernel8 / faults8 cycles a page, measured. A chained stage faults its
#   window's pages once (`window_faults`), not its unit-sized records'.
# - The node machine (#2524) removes, for the bodies it takes, the share of each stage's bodies' cycles that
#   docs/node-machine.md's steps name, and costs `machine` cycles a body token, which stay in the first-level cache
#   (`eps_machine`).
# - A compile's slot at eight workers is its cycles over the frequency there, plus the time it is off its CPU, which
#   today is 8.3 ms and is taken to follow the kernel's cycles.
BEGIN {
    FS = "\t"
    cases = 3
    name[1] = "conservative"; name[2] = "expected"; name[3] = "optimistic"
    eps[1] = 1.30; eps[2] = 1.17; eps[3] = 1.08
    gain1[1] = 1.00; gain1[2] = 1.00; gain1[3] = 0.90
    cold[1] = 0.75; cold[2] = 0.50; cold[3] = 0.25
    window_faults[1] = 1024; window_faults[2] = 512; window_faults[3] = 256
    # The node machine's coverage and cost (docs/node-machine.md, "Expected gains"): nodes in taken expressions for its
    # step 2, tokens in taken bodies for its steps 3 and 4; cycles a body token for expressions, statements and reading.
    cover2[1] = 0.80; cover2[2] = 0.90; cover2[3] = 0.95
    cover34[1] = 0.70; cover34[2] = 0.85; cover34[3] = 0.95
    machine2[1] = 90; machine2[2] = 55; machine2[3] = 45
    machine3[1] = 20; machine3[2] = 15; machine3[3] = 10
    machine4[1] = 40; machine4[2] = 30; machine4[3] = 5
    eps_machine[1] = 1.15; eps_machine[2] = 1.10; eps_machine[3] = 1.05
    # The share of the bodies' cycles in each stage that each of the node machine's steps removes for a taken body, from
    # its design's lists (cumulative: its step 2, 3, 4).
    removes[2, "check-input"] = 0.33; removes[2, "check-expressions"] = 0.87; removes[2, "check-program"] = 0.58; removes[2, "lower"] = 0.65
    removes[3, "check-input"] = 0.33; removes[3, "check-expressions"] = 1; removes[3, "check-declarations"] = 1; removes[3, "check-program"] = 1; removes[3, "select"] = 1; removes[3, "lower"] = 1
    removes[4, "check-input"] = 1; removes[4, "check-expressions"] = 1; removes[4, "check-declarations"] = 1; removes[4, "check-program"] = 1; removes[4, "select"] = 1; removes[4, "lower"] = 1
    # The step of this design at which each stage joins the chain (0: never).
    joins["lower"] = 1; joins["emission"] = 1
    joins["check-expressions"] = 2; joins["check-declarations"] = 2; joins["check-program"] = 2; joins["select"] = 2
    joins["check-input"] = 3
    joins["parse"] = 4
    joins["preprocess"] = 5
    joins["object"] = 0; joins["start"] = 0
}
$1 == "stage" { next }
$1 == "total" { total[$2] = $3; next }
NF >= 7 {
    count += 1
    stage[count] = $1
    user1[$1] = $2; user8[$1] = $3; bodies1[$1] = $4; bodies8[$1] = $5; faults8[$1] = $6; spine_faults8[$1] = $7
}
# The compile at one worker (user, kernel) and at eight (user, kernel) with this design's steps up to `windows` (0 to 5)
# and the node machine's up to `node` (0, or 2 to 4), in case `c`.
function compile(windows, node, c,    i, s, u1, u8, f, b1, b8, f1, f8, chained, body_faults, k1, k8, cover, taken, machine, remove, page)
{
    u1 = 0; u8 = 0; f = 0
    for (i = 1; i <= count; i += 1) {
        s = stage[i]
        # The bodies' and the file scope's parts of the stage.
        b1 = user1[s] * bodies1[s]; f1 = user1[s] - b1
        b8 = user8[s] * bodies8[s]; f8 = user8[s] - b8
        body_faults = faults8[s] - spine_faults8[s]
        if (body_faults < 0) body_faults = 0
        cover = node == 2 ? cover2[c] : cover34[c]
        remove = (node SUBSEP s) in removes ? removes[node, s] * cover : 0
        chained = joins[s] != 0 && joins[s] <= windows
        if (chained) {
            # Step 3 chains the reader's bodies; the file scope's part of check-input joins with the tree, at step 4.
            if (s == "check-input" && windows < 4) {
                u8 += f8 + b1 * (1 - remove) * gain1[c] * eps[c]
                u1 += f1 + b1 * (1 - remove) * gain1[c]
                f += spine_faults8[s] + body_faults * 0
            } else if (s == "check-expressions" && windows == 2) {
                u8 += (f1 + b1 * (1 - remove)) * gain1[c] * eps[c] + cold[c] * ((f8 + b8 * (1 - remove)) - (f1 + b1 * (1 - remove)) * eps[c])
                u1 += (f1 + b1 * (1 - remove)) * gain1[c]
            } else {
                u8 += (f1 + b1 * (1 - remove)) * gain1[c] * eps[c]
                u1 += (f1 + b1 * (1 - remove)) * gain1[c]
            }
        } else {
            u8 += f8 + b8 * (1 - remove)
            u1 += f1 + b1 * (1 - remove)
            f += spine_faults8[s] + body_faults * (1 - remove)
        }
    }
    if (windows > 0) f += window_faults[c]
    if (node != 0) {
        machine = machine2[c] + (node >= 3 ? machine3[c] : 0) + (node >= 4 ? machine4[c] : 0)
        taken = total["body_tokens"] * (node == 2 ? cover2[c] : cover34[c])
        u1 += machine * taken / 1e6
        u8 += machine * taken / 1e6 * eps_machine[c]
    }
    page = total["kernel8"] / total["faults8"]
    k8 = f * page
    k1 = total["kernel1"] * f / total["faults8"]
    result_u1 = u1; result_k1 = k1; result_u8 = u8; result_k8 = k8
    # The slot at eight workers and the wall time at one.
    result_slot = (u8 + k8) / total["ghz8"] + total["off8_ms"] * k8 / total["kernel8"]
    result_rate = 8 * total["megabytes"] / (result_slot / 1e3)
    result_wall1 = (u1 + k1) / total["ghz1"] + total["off1_ms"]
}
function row(label, windows, node,    c, line)
{
    line = label
    for (c = 1; c <= cases; c += 1) {
        compile(windows, node, c)
        line = line sprintf("\t%.0f\t%.0f\t%.0f\t%.2f", result_u8 + result_k8, result_rate, result_wall1, base_rate > 0 ? result_rate / base_rate : 1)
    }
    print line
}
END {
    compile(0, 0, 2)
    base_rate = result_rate
    printf "# today, by the model: %.1f M user and %.1f M kernel cycles a compile at eight workers, a slot of %.1f ms, %.1f MB/s; %.1f ms alone\n", result_u8, result_k8, result_slot, result_rate, result_wall1
    printf "# each case: cycles a compile at eight workers (M), MB/s at eight workers, ms alone, times today's eight-worker rate\n"
    print "scenario\tconservative: Mcycles\tMB/s\tms alone\ttimes\texpected: Mcycles\tMB/s\tms alone\ttimes\toptimistic: Mcycles\tMB/s\tms alone\ttimes"
    row("today", 0, 0)
    row("this design, step 1: the back half by parts", 1, 0)
    row("step 2: the chain from the graph's run", 2, 0)
    row("step 3: the chain from the reader's bodies", 3, 0)
    row("step 4: the tree and the file scope by windows", 4, 0)
    row("step 5: the tokens by windows", 5, 0)
    row("the node machine alone, its step 2", 0, 2)
    row("the node machine alone, its step 3", 0, 3)
    row("the node machine alone, its step 4", 0, 4)
    row("both: step 2 here, the machine's step 2", 2, 2)
    row("both: step 2 here, the machine's step 3", 2, 3)
    row("both: step 3 here, the machine's step 4", 3, 4)
    row("both: step 4 here, the machine's step 4", 4, 4)
    row("both: step 5 here, the machine's step 4", 5, 4)
    printf "# 1 GB/s is a slot of %.1f ms: %.0f M cycles a compile at %.3f GHz\n", 8 * total["megabytes"], 8 * total["megabytes"] * total["ghz8"], total["ghz8"]
}
