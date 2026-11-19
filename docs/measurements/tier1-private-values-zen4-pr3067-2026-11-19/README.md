# Private local values in Buster Tier 1 on Zen 4

The PR now implements native live-frontier placement. Its follow-up campaign compares that implementation with both the initial PR and untouched main, measures construction memory, and exercises the bounded fallback. [Native compiler, timings and correctness results](native/)

The opt-in compiler in [Buster PR 3067](https://github.com/buster14a/buster/pull/3067) carries simple local values directly into Tier 1, resolves other private reads on demand and records cross-block operands during escape classification. The PR's compiler source revision is `3dc3d4f6d74ba353c07101ff614600416272817f`. The baseline is its parent, `b847801169f2b73aed6496c8fa23e9a5499c94e7`. All measurements used a local Ryzen 9 7940HS.

## Source-to-object compilation

Each row covers twelve paired fresh `--tier1 -c` processes per arm after warm-up. A negative percentage means the candidate used less time, fewer cycles or fewer instructions. The two absolute times are the median of each arm. The percentages are medians of individual within-round ratios.

| Corpus | Physical cores | Baseline ms | PR ms | Wall time | User cycles | User instructions | Pairs with lower PR time |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 1 | 801.09 | 780.58 | −2.62% | −2.51% | −3.54% | 12/12 |
| Lua | 1 | 260.84 | 256.67 | −1.44% | −2.33% | −2.59% | 9/12 |
| musl | 1 | 1,563.78 | 1,581.15 | +0.74% | +0.45% | −0.97% | 5/12 |
| SQLite | 6 | 289.57 | 286.19 | −0.34% | −1.22% | −3.49% | 8/12 |
| Lua | 6 | 70.60 | 70.51 | −0.51% | −1.24% | −2.37% | 8/12 |
| musl | 6 | 415.55 | 412.18 | −0.84% | −0.98% | −0.96% | 8/12 |

SQLite on one core has the most consistent wall-time result. Each six-core result has four pairs that ran more slowly with the PR. One-core musl slowed down even though it retired fewer instructions. These runs measure the host compiler writing objects. The 9700X stayed outside this campaign. [Per-pair timings and counters](raw/) · [Computed summaries](checks/timings.tsv)

### Conditions

The host ran Linux 7.3.5-1-cachyos, perf 7.3.4 and Clang 23.1.5. SMT and boost were enabled, with the powersave governor. One lane used CPU 2. Six lanes used CPUs 2 through 7, one hardware thread per physical core. Machines with SMT can use different CPU numbering. Objects were written to btrfs, with the same directory, source paths and flags for both arms. The compiler's huge-page option was enabled. Transparent huge pages were set to `always`, with `defer+madvise` defrag. The source-date epoch was fixed and each compiler completed its own teardown.

The baseline and candidate both used Release, znver4, no host debug information and the same nonempty `BUSTER_BUILD_DEFINES`. The define is inert on the baseline. A nonempty value selects a different compilation-unit partition in this Buster revision, so passing it to both builds keeps that build choice matched. Measured executable SHA-256 values were `1555feb7160436755a6aa9e6475b24c8308a4665d67311be80669c1677acb53a` (baseline) and `1cf46400c546b0e55fbae455fe7a9e6cf6c2de4d23db9a6dca171a3091628ee5` (candidate).

Round zero warms both programs. The twelve measured rounds alternate candidate-first and baseline-first. The launcher times from immediately before fork through wait for process exit. The four inherited user-mode counters include workers and the small launcher. All four recorded 100% running time in every sample. The harness verifies each process exit and emitted object count. Primary C source bytes exclude headers. SQLite contributes one amalgamation, Lua 34 translation units and the musl selection 1,336 translation units with distinct object basenames. [Inputs and file hashes](inputs/) · [Timing harness](scripts/run.sh)

### Reproduce

Set `RECORD` to the absolute path of this measurement directory. Run the following in a fresh working directory with Buster's Linux build dependencies, Clang, Python 3 and Linux perf.

```sh
git clone https://github.com/buster14a/buster.git base
git -C base worktree add --detach ../candidate 3dc3d4f6d74ba353c07101ff614600416272817f
git -C base switch --detach b847801169f2b73aed6496c8fa23e9a5499c94e7
export BUSTER_TOOLCHAIN=path BUSTER_HOST_ARCH=znver4 BUSTER_DEBUG_INFO=0
export BUSTER_BUILD_DEFINES=-DBUSTER_TIER1_PRIVATE_VALUES=1
(cd base && ./build.sh --config Release)
(cd candidate && ./build.sh --config Release)

mkdir -p inputs
bash base/tools/ci/fetch-corpus.sh inputs/frozen
curl -fsSLo inputs/lua-5.4.8.tar.gz https://www.lua.org/ftp/lua-5.4.8.tar.gz
echo '4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae  inputs/lua-5.4.8.tar.gz' | sha256sum -c -
tar -xzf inputs/lua-5.4.8.tar.gz -C inputs
python3 "$RECORD/scripts/inputs.py" --frozen inputs/frozen --lua inputs/lua-5.4.8/src --out lists
for c in sqlite lua musl; do cmp "lists/$c.inputs.tsv" "$RECORD/inputs/$c.inputs.tsv"; done
for ids in 2 2,3,4,5,6,7; do
    for c in sqlite lua musl; do
        bash "$RECORD/scripts/run.sh" base/build/compiler candidate/build/compiler \
            inputs/frozen inputs/lua-5.4.8/src "$c" "$ids" "rerun/$c-$ids" 12
    done
done
```

The harness needs access to the four user-mode perf counters and a fresh output directory per case. Preserve the same absolute input and working paths across both arms when comparing object files containing debug paths.

## Correctness

All 1,371 object files, standard output and diagnostics matched in each of six comparisons. The one-core comparisons used the default Tier 1 pipeline, `-g`, `--tier1-passes=+gvn`, `--tier1-passes=+sroa` and `--tier1-passes=+all`. The sixth used the default pipeline on six cores. Ordinary Release builds without the define also matched each other for all 1,371 objects on one core. The object manifest digests cover the sorted per-file SHA-256 hashes and names. [Per-configuration comparisons](checks/objects.tsv) · [Per-object manifests](checks/manifests-index.tsv)

Both opt-in and ordinary builds passed the 3,854 shared SSA checks and the 1,480,784 lowering checks, with frozen digest `0xfa8a6114710fa332`. The opt-in build passed 64 generated C programs and all 384 native functions against Clang at seed 48915. The focused lifetime fixture checks a local assignment, a loop-carried value and an address passed to another function. Its vector form forces a vector callee through a scalar wrapper. Both compilers produced identical vector-fixture objects and returned success from strict native execution under default, all-pass and debug settings. Full upstream runtime test suites and sanitizer qualification are separate from these observations. [Test results](checks/tests.txt)

```bash
export BUSTER_EXIT_HELPER=0 BUSTER_HUGE_PAGES=1 BUSTER_TEST_HOST_BUSY=0 SOURCE_DATE_EPOCH=1700000000
for cfg in default debug gvn sroa all six; do
    n=1
    flags=()
    case "$cfg" in
        six) n=6 ;;
        debug) flags=(--option=-g) ;;
        gvn|sroa|all) flags=("--option=--tier1-passes=+$cfg") ;;
    esac
    for arm in base candidate; do
        python3 "$RECORD/scripts/verify.py" --compiler "$arm/build/compiler" \
            --data lists --lanes "$n" --common-object-dir object-dir \
            --out "check/$cfg-$arm" "${flags[@]}"
    done
    for c in sqlite lua musl; do
        for f in stdout stderr objects.sha256; do cmp "check/$cfg-base/$c/$f" "check/$cfg-candidate/$c/$f"; done
    done
done
candidate/build/compiler test-ssa-ir
candidate/build/compiler test-ir-lowering
candidate/build/compiler test-ssa-source --tier1 --typed --lifetimes --generate 64 --seed 48915 --clang clang
```

## Earlier experiment and sparse placement

The three records below count provisional merge locations in the earlier demand-driven experiment. An independent replay computes the iterated dominance frontier of a local's defining blocks and keeps blocks where the local is live on entry. It reads the compiler's published locations for scoring. Each candidate is a distinct (block, local) pair per promotion.

| Corpus | Promotions | Demand provisional | Live-frontier candidates | Published | Published locations missed |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 2,602 | 125,960 | 7,222 | 6,665 | 0 |
| Lua | 1,103 | 9,091 | 1,633 | 1,461 | 0 |
| musl | 2,755 | 24,084 | 4,734 | 4,192 | 0 |

The replay covers every published location, with 1,271 extra candidates across 6,460 promotions. The compiler timed above uses demand-driven construction. The later native implementation also supplies the incoming operands and measures scratch use and source-to-object time. [Recorded graphs and per-promotion counts](graphs/) · [Independent replay results](checks/replay.txt) · [Native results](native/)

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror "$RECORD/scripts/replay.c" -o replay
for c in sqlite lua musl; do xz -dc "$RECORD/graphs/$c.u32.xz" | ./replay; done
```

The traces contain little-endian 32-bit words. Each record contains a magic word, five counts, immediate dominators, predecessor offsets, predecessor IDs, ordered (local, block, write) events and the final block and local columns. The demand census columns are blocks, local slots, entries traversed, provisional merges and provisional operand edges. [Per-invocation demand counts and earlier raw timings](prior/)

The earlier prototype and diagnostic patches in `prior/` apply to Buster `6427879e1143026a12fb0388a20bdea1fe4b2bc5`. Decompress and apply `tier1-private-values.patch.xz` there. The three switch digits in that revision's CSVs are direct local values, demanded joins and recorded cross-block operands. Enable them with `BUSTER_RESEARCH_VALUES=1 BUSTER_RESEARCH_EVENTS=1 BUSTER_RESEARCH_USES=1`. Use the graph instrumentation on a separate build by applying `05-graph-trace-only.patch.xz`, then set `BUSTER_RESEARCH_GRAPH` to the absolute path of a fresh file and run one corpus with one lane. Patch 03 produces separate `SSA-JOINS` and `SSA-SLOTS` counts with `BUSTER_RESEARCH_SHAPE=1`. These instrumentation switches belong to the historical prototype. The new PR's timed executable contains no graph tracing.
