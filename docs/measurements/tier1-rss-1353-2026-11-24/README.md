# Tier 1 whole-process peak RSS for scoped loops

On Buster main `7515714d05caa655e8c2e1e2776e07aa9b8058df`, the 8,000-loop case in issue #1353 compiled at 158 MiB peak RSS and 16,000 loops at 255 MiB. The issue originally reported 2.53 GB for 8,000. These are Linux process memory measurements on an AMD EPYC 9V74 cloud VM. The original measurements used a Ryzen 7 9700X. [Issue and generator description](https://github.com/buster14a/buster/issues/1353)

| Loops | Tier 0 peak RSS (MiB) | Tier 1 peak RSS (MiB) |
| ---: | ---: | ---: |
| 1,000 | 41.0 | 48.7 |
| 2,000 | 47.8 | 62.9 |
| 4,000 | 59.4 | 91.8 |
| 8,000 | 84.1 | 157.9 |
| 16,000 | 131.4 | 254.5 |

Each number is the median of three fresh compiler processes pinned to CPU 2, reading `time-process rusage-peak-rss-kb` from the driver. The additional Tier 1 memory above Tier 0 rises from 7.7 MiB at 1,000 loops to 123.1 MiB at 16,000, approximately 16-fold for 16 times the loops. [Individual readings in KiB](loops.tsv)

## Reproduction

The build used `BUSTER_DEBUG_INFO=0 ./build.sh --config Release --jobs 4` with the repository's default native target and pinned Clang 23.1.4. The compiler executable's SHA-256 was `177e5ef22a532cc6ee27765137494a44f5220fc4cb81c4207432eadc74149147`. All inputs came from the existing C generator, Git blob `e9f62c8b49eae6ace4604cde80b6787f03b2887b`. Set `compiler` to the built executable, `record` to this directory and `generator` to the linked source. Run in a scratch directory. [Generator](../ssa-bounded-1353-2026-11-13/ssa_resource.c) · [Generated input hashes](inputs.sha256)

```bash
cc -O2 -Wall -Wextra -Werror "$generator" -o ssa_resource
for n in 1000 2000 4000 8000 16000; do
    ./ssa_resource generate loops "$n" 0 0 > "loops-$n.c"
    ./ssa_resource generate max "$n" 1 0 > "max-$n.c"
    for repeat in 1 2 3; do
        taskset -c 2 "$compiler" -c --time-stages "loops-$n.c" -o "tier0-$n.o"
        taskset -c 2 "$compiler" -c --tier1 --time-stages "loops-$n.c" -o "tier1-$n.o"
    done
done
for depth in 8 10; do
    ./ssa_resource generate nested 200 "$depth" 0 > "nested-$depth.c"
done
sha256sum -c "$record/inputs.sha256"
```

## Execution checks

All 12 inputs compiled and ran at both tiers. Every strict Tier 1 report showed one function compiled and zero fallbacks. All repeated plain loop builds produced objects byte-identical to the execution-tested object at their tier. Nested MAX includes 200 statements at depths 8 and 10. The separate execution runs used the generator's `wait4` RSS measurement. [Execution results and RSS](execution.tsv)

For each input, the commands below show the strict Tier 1 check. Omit the three Tier 1 options for the default-tier run. Set `unit` to the generated C file. For loops set `oracle=loops` and pass the loop count to `check`. For MAX set `oracle=max` and pass the statement count and depth. The loop oracle checks seven inputs from −1 through 5. The MAX oracle independently scans each window over a repeating sequence of positive and negative values. [Loop oracle](check-loops.c) · [MAX oracle](check-max.c)

```bash
./ssa_resource run 4194304 "$compiler" -c --tier1 --tier1-strict --tier1-report --time-stages "$unit" -o unit.o
cc -O2 -c "$record/check-$oracle.c" -o oracle.o
cc -no-pie oracle.o unit.o -o check
timeout 15 ./check "$@"
```

The same compiler passed `test-ssa` (8,731 checks), `test-ssa-ir` (2,946) and `test-tier1-cfg` (99,274).
