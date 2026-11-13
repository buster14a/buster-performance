# Call initializers in place, Buster #1549's follow-up

Compiler issue: [#1549](https://github.com/buster14a/buster/issues/1549). Compiler PR:
[#2673](https://github.com/buster14a/buster/pull/2673). #1718 (merged as `71d4b4a2`) had already
made `T x = f(...);` pass `x` as the call's hidden result pointer. The head:

- drops the dead `lea` after each in-place call;
- writes in place in bodies with labels, unless a label lies between the opener of the
  declaration's innermost group and the initializer's end;
- writes in place for a one-member wrapper or a one-element array
  (`struct Outer o = { make(n) };`).

Sources:

- Base: main `b7a95eedbe16fbd8434654f192f8f7aab76c56e5`.
- Head: `a95636d5d79bb77d35140355880ce80a676c34e2`, the PR's only commit on that base.

Both trees are worktrees of a fresh clone of `buster14a/buster` (`setup.sh`).

## Host and method

The Ryzen 7 9700X (`benchpress`): CPU 2 (governor and EPP `performance`), THP `always`, clang 23.1.1,
CMake 4.4.4 and Ninja 1.13.2 (`results/host.txt`, which also has the executables' and harness files'
SHA-256 values). Each tree was built with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`
(`build.sh`; `results/build-*.log`).

**Lock.** Every build, every measured executable run and every `time-runs` invocation took its own
hold of the shared lock through `lock.sh`, which wraps `~/buster-fast-bench/exclusive.sh`. Inside each
hold, `lock.sh` first prints a `receipt` line: the time and the lock's owner line, which names this
hold's command. The receipts are in:

- `results/*/receipts.txt`: one per kernel run, 30 and 42;
- the first line of `results/build-*.log`, `results/compile-*/time-runs-*.txt`, `shape-receipt.txt`
  and `results/self-*/self-*-receipt.txt`.

exclusive.sh's own messages name other holders. The record keeps only their counts
(`results/lock-messages.txt`): every hold waited except 8 of the second series's 42 kernel runs,
and one hold started while a short `sha256sum` was busy.

**Kernels** (`k/kernel.c`, driven by `k/driver.c` compiled by clang `-O2`):

- `return`: #1376's `k_return`, a 328-byte `struct Big b = k_make(i);`, in place on both trees since #1718.
- `cleanup`: the same with a `goto out;` cleanup label after the declaration.
- `wrapped`: `struct Outer o = { k_make(i) };`, where `struct Outer` has only `struct Big` as a member.

Each kernel is compiled by each tree (`-c` for Tier 0, `-c --tier1` for Tier 1), by clang `-O0`, and
by clang `-O2 -fno-vectorize`. Each object is linked with the same driver. The driver calls each
kernel 2,000,000 times, in three passes, and prints the best pass in ns per call, plus a checksum
that every executable prints the same.

- First series (`measure.sh`, `results/run-1794600408`): 5 rounds, one hold per run.
- Second series (`measure2.sh`, `results/rusage-1794606055`): the first series's executables again,
  identified in `results/run-1794600408/sha256.txt` and repeated in the second series's
  `sha256.txt`. 7 rounds, one hold per run, each run under `k2/rusage-run.c`. That wrapper prints
  the run's wall, user and system time, its context switches, and CPU 2's busy jiffies over the run.

Both series rotate the executables' order by round and pin to CPU 2. `summarize.py` gives each
executable's median, minimum and maximum, and flags slow-state runs: rounds where some kernel took
more than 1.5 times its minimum over all rounds.

**Compile time** (`compile.sh`): three `time-runs --runs 21 --warmups 2` invocations, each its own hold.
Each compares base and head as whole processes on `-c --lanes 1` of the frozen `sqlite3.c`, with the
CI's defines, in rotated order. One more hold compiles each tree's object for its shape.

**Self** (`self.sh`): the compiler's own `main.c` at the base, compiled `-c` by each tree, one hold each.

## Results

The second series: ns per call, medians of 7 rounds, with each executable's minimum and maximum in
`results/rusage-1794606055/summary.txt`.

| kernel | base Tier 0 | head Tier 0 | base Tier 1 | head Tier 1 | clang `-O0` | clang `-O2` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `return` | 2.895 | 2.920 | 3.240 | 2.922 | 3.187 | 3.015 |
| `cleanup` | 9.120 | **2.801** (3.3×) | 10.940 | **2.886** (3.8×) | 3.368 | 3.013 |
| `wrapped` | 8.932 | **2.565** (3.5×) | 8.924 | **2.758** (3.2×) | 3.188 | 3.006 |

The head takes at most clang `-O0`'s time on all three kernels at both tiers. `return` was
already in place on the base. Its Tier 0 difference is within the rounds' spread: 2.886 to 3.068 ns
on the base outside its slow round, and 2.898 to 3.429 on the head. The base's `cleanup` and `wrapped` keep the 328-byte
temporary and its `memmove`.

The first series (`results/run-1794600408/summary.txt`) gives the same minima: head Tier 0 2.808,
2.914 and 2.568 ns; clang `-O0` 3.030, 2.923 and 2.849 ns for `cleanup`, `return` and `wrapped`.
Its medians are higher for the head's Tier 0 (3.432 to 3.621 ns) because 2 of its 5 head Tier 0
runs were in the slow state below.

**Slow states.** Some runs took 2–4.5 times as long for all three kernels at once, and the three
kernels' times then came out nearly equal. For example, clang `-O2` round 5 read 13.283, 13.295
and 13.293 ns, where it normally reads 2.9–3.6. The second series's `rusage` lines rule out
another process on CPU 2: in those runs wall ≈ user time, involuntary context switches are 3 to 4,
and CPU 2's busy jiffies match the run's own time.

The state is per process and hits every build alike: base Tier 0 and Tier 1 and clang `-O2` in
round 5, clang `-O0` in round 4, and in the first series the head in rounds 1, 3 and 5. A stall
that fixes each call's cost regardless of kernel fits the 9700X's known process-level states,
where a process's random stack placement 4K-aliases stored data. That cause was not measured
here. The medians above are robust to one such run in 7.

**Compile time**, frozen `sqlite3.c` `-c --lanes 1`, 21 runs per tree per invocation:

| invocation | base wall | head wall | wall | base user cycles | head user cycles | cycles |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 125.135 ms | 125.033 ms | −0.08% | 602.925 M | 602.477 M | −0.07% |
| 2 | 124.613 ms | 124.581 ms | −0.03% | 602.094 M | 603.313 M | +0.20% |
| 3 | 125.102 ms | 125.065 ms | −0.03% | 602.729 M | 602.715 M | −0.00% |

Instructions: 1,353,378,740 (base) against 1,353,422,349 (head), +0.003%. Both trees' `sqlite3.c`
objects are byte-identical (`results/compile-1794605976/sha256.txt`): no initializer there changes.

**Self**: `main.c`'s `.text` goes from 1,830,222 to 1,829,470 bytes (−752), with 38 `memmove` and 211
`memcpy` calls in both (`results/self-1794607041/shape.txt`). The PR reports the instruction-level
comparison: 107 dead `lea`s gone in 55 functions, and nothing else.

## Limitations

- The kernels measure the initializer's code shape in isolation: one call per iteration, with the
  callee compiled by clang `-O2`.
- The slow states' cause is inferred, not measured; no counters or stack places were recorded.
- `results/host.txt` is a snapshot taken once, after the builds.
- The executables and objects are not archived, only their SHA-256 values.
