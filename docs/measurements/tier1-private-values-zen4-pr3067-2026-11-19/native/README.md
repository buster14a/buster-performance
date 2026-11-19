# Native live-frontier construction in Buster Tier 1

Buster revision `b63551526c488dd08cd2138f7d9aa95e655af3e5` places live joins and renames their actual incoming operands inside the compiler. It was compared with untouched main `b847801169f2b73aed6496c8fa23e9a5499c94e7` and the PR's first demand-driven compiler `3dc3d4f6d74ba353c07101ff614600416272817f`. All three matched builds used the same opt-in define and unit partition. This campaign ran on the local Ryzen 9 7940HS. [Compiler PR](https://github.com/buster14a/buster/pull/3067) · [Host, toolchain, inputs, flags and original demand measurements](../README.md)

## Source-to-object throughput

Source throughput uses primary C input bytes and decimal megabytes. On one core SQLite rose from 11.79 to 12.21 MB/s. [Absolute throughput for all cases](checks/source-throughput.tsv)

The two change columns compare the same frontier arm with main and with the earlier demand arm in the same round. Wall time is measured from fork to exit for one fresh compiler process writing all objects. Separate arm medians in milliseconds can differ from a within-round median ratio.

| Corpus | Cores | Main ms | Frontier ms | Wall vs main | Lower pairs | User cycles vs main | User instructions vs main | Wall vs demand |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 1 | 806.44 | 778.55 | −3.75% | 12/12 | −3.72% | −4.79% | −1.46% |
| Lua | 1 | 263.10 | 253.30 | −4.38% | 12/12 | −3.20% | −2.74% | −0.86% |
| musl | 1 | 1,595.38 | 1,638.06 | +2.19% | 3/12 | +2.03% | −1.07% | +1.01% |
| SQLite | 6 | 292.47 | 291.43 | −0.64% | 6/12 | −3.44% | −4.75% | +0.51% |
| Lua | 6 | 74.18 | 72.13 | −0.52% | 8/12 | −2.04% | −2.58% | −0.52% |
| musl | 6 | 417.68 | 416.61 | −0.27% | 6/12 | −0.67% | −1.04% | +0.92% |

Round zero warms every executable. Twelve subsequent rounds rotate through all six orders twice. Counter running time was 100% across all arms and files. The six-core SQLite and musl pairs split evenly on wall time. The one-core musl regression coincided with more user cycles and fewer instructions. In an earlier separate series the eager native solver and its control gave different musl wall times, so retain that variability when interpreting the magnitudes. [Raw series](raw/) · [Final paired changes](checks/refined-timings.tsv) · [Earlier native comparison](checks/first-native-timings.tsv)

The first native implementation built the frontier index eagerly for all functions. Its source patch applies to `34edaaa9af52eed9df8f282c75ff7939be364798`, whose compiler is identical to the demand revision. The final implementation builds the index lazily, skips placement for a single definition strictly dominating its exposed reads, and omits scratch for per-local parts used only by the existing bounded constructor. The matched compiler SHA-256 values are `1555feb7160436755a6aa9e6475b24c8308a4665d67311be80669c1677acb53a` (main), `1cf46400c546b0e55fbae455fe7a9e6cf6c2de4d23db9a6dca171a3091628ee5` (demand), `5119cc03603ce0ddc0b4d9e02cc54e6cd201152195c7e9e993cd7b47eba60d08` (first native) and `0857bf07af9de53c459deae4fae323e2d3a3ab95253e1921cc76fbc1943602f9` (final native). [First native patch](first-native.patch.xz)

One earlier six-core musl invocation completed all 39 compiler processes, then the shell reported a parsing error because its runner file had been edited during execution. The table uses a complete repeat with a fixed runner. The earlier series recorded +0.56% versus main and is included for comparison. [Superseded six-core musl timing](raw/refined-6-musl-superseded.csv)

## Joins, operands and constructor memory

These are counts from real source-to-object compilations using a separate instrumented binary. The two constructors received the same input. Every promotion published the same number of joins and incoming operands in both runs. Its emitted objects and diagnostics matched the timing builds. All corpus promotions completed within the sparse frontier budget.

| Corpus | Promotions | Provisional joins, demand → frontier | Provisional operands, demand → frontier | Published joins | Published operands | Largest constructor arena growth, bytes, demand → frontier |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 2,602 | 179,634 → 7,222 | 431,209 → 20,378 | 6,665 | 19,260 | 1,506,588 → 670,792 |
| Lua | 1,103 | 9,091 → 1,633 | 21,650 → 4,044 | 1,461 | 3,700 | 441,176 → 281,004 |
| musl | 2,755 | 24,084 → 4,734 | 58,267 → 11,762 | 4,192 | 10,677 | 131,644 → 66,216 |

Across 6,460 promotions, 212,809 provisional joins fell to 13,589. SQLite's largest individual constructor arena growth fell 55.5%. This is the difference between arena lengths at constructor entry and return. Whole-process peak RSS is a separate column in the timing CSVs. The 125,960 preliminary SQLite joins in the earlier graph study belong to its historical producer and revision. The matched native comparison here observed 179,634. [Per-corpus memory and placement totals](checks/placement.tsv) · [Per-promotion numeric records](counts/)

## Control flow, budget and object checks

The sparse frontier index limits the target column to 16 MiB. A generated strict Tier 1 program sends two dispatches to the same joins through very different dominance paths. At 64 joins its 330-block function stayed on the frontier constructor. At 2,200 joins its 11,010-block function reached pair 4,194,305, restored the arena and took the existing bounded constructor. Both native programs and their Clang references returned the expected result. [Small stress case](checks/stress-64.txt) · [Over-budget stress case](checks/stress-2200.txt) · [Generator](scripts/make-frontier-stress.py)

The first and final native implementations both produced byte-identical objects, standard output and diagnostics for 1,371 input files in each of the six configurations recorded for the demand version. The final native build passed 3,854 SSA checks, 1,480,784 shared lowering checks with the frozen digest, and all 64 generated C programs and 384 native functions against Clang. A two-entry loop checks a value at a join inside an irreducible region. A separate vector callee goes through a scalar wrapper before reaching its final caller. The strict default, all-pass and debug executables passed and their object files matched main. [Final object comparisons](checks/refined-objects.tsv) · [Native and oracle checks](checks/native-tests.txt)

## Ordinary Release and the default driver

The unflagged Release builds of main and the final PR produced the same 1,371 objects, standard output and diagnostics with `--tier1 -c` and also with plain `-c`. The ordinary PR build passed the SSA suite and the frozen shared-lowering digest. Plain `-c` goes through the frontend throughput path targeted by #2850. With one core and twelve alternating pairs, the paired user-instruction changes were below 0.001% in absolute value for all three corpora.

| Plain `-c` | Wall time vs main | Lower pairs | User cycles | User instructions |
| --- | ---: | ---: | ---: | ---: |
| SQLite | +0.23% | 5/12 | −0.19% | −0.00002% |
| Lua | −1.83% | 9/12 | −1.26% | −0.00025% |
| musl | −0.27% | 7/12 | −0.30% | +0.00052% |

These are an independent control for compiler layout and timing variability. The measured Tier 1 savings in the main table came from an opt-in build. [Plain-driver comparisons](checks/plain.tsv) · [Ordinary-build tests and binary hashes](checks/regular-build.txt)

The measured parent already included #3030 from #2850. The native PR also applied without a file conflict to main after #3047 from #2924. A local opt-in Release build of that combined tree passed both IR suites, the strict vector fixture and the typed, lifetime and native two-entry-cycle fixture. [Exact merged tree and check outputs](checks/main-integration.txt)

## Reproduce timing and placement

Set `RECORD` to the parent measurement directory. Prepare the frozen corpus and Lua using its instructions. Build three separate Buster worktrees at the revisions in the first paragraph. Use `BUSTER_TOOLCHAIN=path BUSTER_HOST_ARCH=znver4 BUSTER_DEBUG_INFO=0 BUSTER_BUILD_DEFINES=-DBUSTER_TIER1_PRIVATE_VALUES=1 ./build.sh --config Release` in each worktree. The three compiler paths below refer to those matched Release builds.

```sh
for ids in 2 2,3,4,5,6,7; do
    for c in sqlite lua musl; do
        bash "$RECORD/scripts/run.sh" base/build/compiler frontier/build/compiler \
            inputs/frozen inputs/lua-5.4.8/src "$c" "$ids" "times/$c-$ids" \
            12 demand/build/compiler
    done
done
```

The earlier native series uses the same command with the first native executable in the frontier position. To reproduce it, apply the decompressed `first-native.patch.xz` to `34edaaa9af52eed9df8f282c75ff7939be364798` and rebuild with the same define. For the independent plain `-c` control, rebuild clean main and final worktrees with `BUSTER_BUILD_DEFINES` unset, then use an empty ninth argument and `plain` as the tenth argument to the same timing script.

The untimed counter build includes both the actual PR constructor and the earlier demand constructor. The probe reads the latter from its recorded Git revision. Prepare a clean worktree at the final compiler revision, then execute the following from the directory containing the three compiler worktrees. The example assumes the parent record's input-preparation step produced `lists`.

```sh
git -C frontier worktree add --detach ../census b63551526c488dd08cd2138f7d9aa95e655af3e5
python3 "$RECORD/native/scripts/placement-probe.py" census
(cd census && BUSTER_TOOLCHAIN=path BUSTER_HOST_ARCH=znver4 BUSTER_DEBUG_INFO=0 \
    BUSTER_BUILD_DEFINES=-DBUSTER_TIER1_PRIVATE_VALUES=1 ./build.sh --config Release)
export BUSTER_HUGE_PAGES=1 BUSTER_TEST_HOST_BUSY=0 BUSTER_EXIT_HELPER=0 SOURCE_DATE_EPOCH=1700000000
for arm in demand frontier; do
    unset BUSTER_PROBE_DEMAND
    if [ "$arm" = demand ]; then export BUSTER_PROBE_DEMAND=1; fi
    python3 "$RECORD/scripts/verify.py" --compiler census/build/compiler --data lists \
        --out "counts/$arm" --common-object-dir counts-objects --lanes 1
done
unset BUSTER_PROBE_DEMAND
for n in 64 2200; do
    python3 "$RECORD/native/scripts/make-frontier-stress.py" "$n" > "joins-$n.c"
    census/build/compiler --lanes 1 --tier1 --tier1-strict --verify "joins-$n.c" -o "stress-$n"
    "./stress-$n"
done
```

Each census row reports block count, local count, provisional joins, provisional incoming operands, published joins, published incoming operands and arena growth in bytes from construction entry to exit. The compiler only prints these rows in the separate diagnostic build. The normal timing set uses the uninstrumented executables. [Counter inputs and reproduction scripts](scripts/)
