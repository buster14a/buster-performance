# #1340: the common warnings' cost on every compile, 6 November 2026

Evidence for the buster branch
[`droid/1340-common-warnings-cost`](https://github.com/buster14a/buster/tree/9fa45bbbc2c5e2b4d7db31b729c0ef0172d69200)
(head `9fa45bbb`), which is part of [buster#1340](https://github.com/buster14a/buster/issues/1340). #1049's common
warnings took sqlite3.c's `-c` from 107.0 to 162.4 ms on the 9700X, and `check-program` from 10.4 to 58.6 ms. This
record measures the branch's two commits against main and against the compiler before #1049. It also measures what
is still left, and which part of that belongs to other issues.

Every timing and counter here is from the Ryzen 7 9700X (`benchpress`), CPU 2, each run inside a hold of the shared
lock (`exclusive.sh`). The correctness checks ran on the owner's Ryzen 9 7940HS, under its `cores` queue.

## Sources

| Name | Revision | What |
| --- | --- | --- |
| `pre1049` | buster `aca9e53aa981bb3f61d21cdd5a408ce5167a06f8` | main before #1049, the issue's reference |
| `main` | buster `0eca996a660548aff827c8b1d08789c413d6eba1` | the branch's base |
| `walks` | buster `ac819d97a2208b98b4703ca7a32c742c2772e5b2` | the branch's first commit: the pass visits only what can warn |
| `head` (`znver5`) | buster `9fa45bbbc2c5e2b4d7db31b729c0ef0172d69200` | the branch's second commit: analyses whose warnings are all ignored don't run |

Every build is `BUSTER_HOST_ARCH=znver5`, Release, built on the 9700X by the harness under the lock
([`zen5-9700x/builds.log`](zen5-9700x/builds.log)). `pre1049` and `main` come from `build-commit`, which builds a
`git archive` of the commit. `head` and `walks` come from `setup`, which builds the repository checkout. The checkout
was clean at each commit, and each build's `.commit` file names the full id with no `-dirty-` suffix. `walks` is the
first run's `setup` build at `ac819d97`, kept as `compiler-walks-znver5` with that `.commit` file. The second run's
`build-commit walks ac819d97` reused it because the id matched. [`zen5-9700x/identity.txt`](zen5-9700x/identity.txt)
has the SHA-256 of each executable, of the corpus, of `self-main.i` and of the harness files. `env/` has the host's
identity (kernel, CPU, governors, perf and its catalog, tool versions).

The harness is buster's [`tools/microarch`](https://github.com/buster14a/buster/tree/9fa45bbbc2c5e2b4d7db31b729c0ef0172d69200/tools/microarch)
at `9fa45bbb`. The branch doesn't touch `tools/`, so it is main `0eca996a`'s harness. The workloads are those of
[`microarchitecture-two-hosts-2026-11-04`](../microarchitecture-two-hosts-2026-11-04/README.md):

- `sq-c`: sqlite3.c from the frozen corpus `preprocessor-391e729af658`, with CI's options and `-c --lanes 1`;
- `sq-syn`: the same with `-fsyntax-only`;
- `self-syn`: the compiler's own `main.c`, preprocessed once by `head`'s build (`self-main.i`, 37,481,935 bytes,
  SHA-256 `0e59dd07…`), with `-fsyntax-only`.

None of them passes a `-W` option, so they measure what every default compile pays.

## Results

### sqlite3.c, `-c` (`sq-c`)

Medians of 11 rotated rounds ([`ab1340b/time-summary.tsv`](zen5-9700x/ab1340b/time-summary.tsv)). The counters are
medians of 5 `perf stat` runs per group, never multiplexed ([`ab1340b/stat.tsv`](zen5-9700x/ab1340b/stat.tsv)):

| | pre1049 | main | walks | head | head against main |
| --- | ---: | ---: | ---: | ---: | ---: |
| wall (ms) | 107.11 | 170.97 | 147.64 | **140.77** | −30.20 (−17.7%) |
| user (ms) | 93.62 | 150.43 | 129.49 | 120.37 | −20.0% |
| max RSS (KiB) | 278,432 | 299,676 | 295,276 | 291,180 | −2.8% |
| user instructions | 1,155.7 M | 2,151.8 M | 1,712.1 M | 1,646.5 M | −23.5% |
| user cycles | 503.1 M | 844.6 M | 715.0 M | 680.8 M | −19.4% |
| retired branches | 176.5 M | 363.2 M | 272.4 M | 258.8 M | −28.7% |
| mispredicted branches | 3.13 M | 7.19 M | 5.32 M | 4.99 M | −30.6% |
| task-clock (ms) | 105.92 | 168.86 | 145.99 | 139.50 | −17.4% |

Stages, the medians of the same 11 runs' `--time-stages` reports
([`stages-medians.tsv`](zen5-9700x/stages-medians.tsv), by [`scripts/stages.sh`](scripts/stages.sh)):

| stage (ms) | pre1049 | main | walks | head |
| --- | ---: | ---: | ---: | ---: |
| check-input | 44.98 | 58.87 | 58.89 | 58.94 |
| check-program | 10.37 | 58.60 | 35.24 | **28.40** |
| release | 0.09 | 1.87 | 1.86 | 1.85 |
| total | 105.60 | 169.74 | 146.32 | 139.45 |

`head` removes 30.2 ms of the 48.2 ms that `check-program` gained between `pre1049` and `main` (63%). `walks` alone
removes 23.4 ms. The rest, 6.8 ms, is `head`'s gating. The defaults leave `-Wsign-compare`, `-Wself-assign` and
`-Wuninitialized` ignored, so their analyses no longer run.

### sqlite3.c, `-fsyntax-only` (`sq-syn`), and the compiler's `main.c` (`self-syn`)

| | pre1049 | main | walks | head |
| --- | ---: | ---: | ---: | ---: |
| `sq-syn` wall (ms), 11 rounds | 86.54 | 150.11 | 126.80 | 120.06 |
| `sq-syn` check-program (ms) | 10.50 | 58.76 | 35.37 | 28.48 |
| `self-syn` wall (ms), 3 rounds | 1,491.8 | 4,738.2 | 3,433.3 | 3,155.5 |
| `self-syn` check-program (ms) | 105.5 | 3,071.0 | 1,757.1 | 1,482.7 |
| `self-syn` check-input (ms) | 916.9 | 1,192.1 | 1,195.4 | 1,193.4 |

([`ab1340b-self/time-summary.tsv`](zen5-9700x/ab1340b-self/time-summary.tsv).) Most of `self-syn`'s remaining
`check-program` is [buster#1341](https://github.com/buster14a/buster/issues/1341): the pass's `_Generic` scan of
unselected roots, which is quadratic in the number of selections. A `cycles:u` profile of one `head` compile
([`self-profile/`](zen5-9700x/self-profile), [`scripts/sp.sh`](scripts/sp.sh)) has 211,732 samples.
`check_driver_common_warnings` has 88,220 of them (41.7%), and 79,439 of those (90.0%) are in
`check_common_unselected_roots`: 37.5% of the compile.

### Every common warning enabled: `sq-c` with `-Wall -Wextra`

With `-Wall -Wextra`, every gated analysis runs, so this shows the walks' gain alone
([`wall-wextra/`](zen5-9700x/wall-wextra), [`scripts/wx.sh`](scripts/wx.sh), 11 rotated rounds, one hold):

| | pre1049 | main | walks | head |
| --- | ---: | ---: | ---: | ---: |
| wall (ms) | 106.89 | 170.92 | 147.74 | 146.91 |
| check-program (ms) | 10.38 | 58.77 | 35.23 | 34.38 |

`main`, `walks` and `head` print the same 47 warnings, byte for byte, in every round's log. `pre1049` has none of
these warnings.

### The one warning sqlite3.c gets

With default options, sqlite3.c gets one warning, `-Wempty-body` at `sqlite3.c:74649`. Only the vector path gives it;
`--scalar`, the x86-64 build and clang don't ([buster#1339](https://github.com/buster14a/buster/issues/1339)).
`head`'s `sq-syn` with and without `-Wno-empty-body`, 11 rotated rounds, one hold
([`no-empty-body/`](zen5-9700x/no-empty-body), [`scripts/ep.sh`](scripts/ep.sh)):

| | the warning | `-Wno-empty-body` |
| --- | ---: | ---: |
| wall (ms) | 119.80 | 111.92 |
| check-program (ms) | 28.51 | 22.37 |
| check-program minor faults | 491 | 17 |
| release (ms) | 1.81 | 0.01 |

Placing and printing that one diagnostic costs 7.9 ms: 6.1 ms in `check-program`, with 474 more page faults, and
1.8 ms in `release`. The 1.8 ms is all of `release`'s growth since `pre1049`. Profiles of the two, eight compiles
each ([`no-empty-body/profiles`](zen5-9700x/no-empty-body/profiles), [`scripts/pp.sh`](scripts/pp.sh)), show
where it goes. The warning adds 4,114 of the 63,289 samples (6.5%): `pp_diagnostic_place` 1,106,
`pp_run_contexts` +1,040, `pp_invoke` +442, and the rest of the preprocessor's functions (`pp_emit_simple_write`,
`pp_append_tokens`, `pp_directive`, `pp_scan_arguments`, `pp_substitute` …) +100 to +180 each. Without the warning,
the whole compile's `pp_run_contexts` is 925 samples. So placing the first diagnostic runs about as much of the
preprocessor again as the compile itself ran.

### Profiles

`cycles:u` with a fixed period of 50,021, eight `sq-c` compiles per build on CPU 2, under the lock. Per-symbol samples
are in [`profiles/`](zen5-9700x/profiles), merged by [`scripts/diff.sh`](scripts/diff.sh) into
[`diff-samples.tsv`](zen5-9700x/profiles/diff-samples.tsv). The 9700X caps perf at 63,300 samples per second, so
these keep about 70% of the cycles. Compare them as shares, not absolute counts. The totals are 56,116 (`pre1049`),
90,996 (`main`) and 74,484 (`head`) samples. `pre1049` and `main` were recorded by [`prof.sh`](scripts/prof.sh) and
[`prof2.sh`](scripts/prof2.sh). `head` was recorded by [`run2.sh`](scripts/run2.sh), from the same executables that
the A/B measured.

| symbol | pre1049 | main | head |
| --- | ---: | ---: | ---: |
| `check_driver_common_warnings` | 0 | 7,713 | 4,641 |
| `check_common_evaluated` (inlined in `head`) | 0 | 5,461 | 0 |
| `check_common_emit_run` | 0 | 5,808 | 806 |
| `check_common_emit_kids` | 0 | 2,072 | 175 |
| `check_input_run` | 2,502 | 5,745 | 5,886 |
| `__memset_avx512_unaligned_erms` | 0 | 2,017 | 1,928 |
| `pp_diagnostic_place` | 0 | 1,167 | 1,067 |
| `pp_run_contexts` | 1,091 | 2,054 | 2,061 |
| `check_program_return_flow` | 7 | 610 | 610 |

The pass's own symbols (`check_driver_common_warnings` and every `check_common_*`) fall from 21,228 samples, 23.3% of
`main`'s, to 5,760, 7.7% of `head`'s.

Within `check_driver_common_warnings` in `head`, perf's source lines summed by function
([`check_driver_common_warnings.functions.tsv`](zen5-9700x/profiles/check_driver_common_warnings.functions.tsv),
[`scripts/srcline-functions.sh`](scripts/srcline-functions.sh) over [`srcline.sh`](scripts/srcline.sh)'s output):
`check_common_unselected_roots` 20.8% (buster#1341), `check_common_evaluated` 13.1%, lines perf gives as line 0 12.3%,
`check_common_facts` 9.3%, `check_common_own_candidate` 6.6%, inlined `c_checker.c` code 6.6%,
`check_common_body_reached` 3.7%, and less than 3% each for the rest.

[`analysis/memset-trace.txt`](analysis/memset-trace.txt) is a gdb trace ([`memset.gdb`](analysis/memset.gdb)) of
every `memset` above 256 KiB in one `sq-c` compile. It ran on the 7940HS with `head`'s native build. It shows 55
calls clearing 105.9 MB: 22.9 MB in `check_input_output_none`, 17.9 MB in `check_input_run`, 13.5 MB in
`check_program`, 12.2 MB in `check_input_deprecated_uses` and 8.6 MB in `parse_tree_columns`. 30 of the 55 clear
2,864,632 bytes each (85.9 MB): a 4-byte column over sqlite3.c's 716,158 tokens. The common-warning pass's own
memsets clear 2.7 MB (`check_common_facts`, `check_common_dangling_else` and `check_common_graph_warnings`).

## What is left between `head` and `pre1049`

`sq-c`'s stage totals differ by 33.9 ms (139.45 against 105.60):

- **`check-program`, +18.0 ms.** 6.1 ms of it places sqlite3.c's one warning (above), which #1339 says shouldn't be
  given. The rest, about 12 ms, is the common-warning analyses (the `check_common_*` symbols and
  `check_driver_common_warnings`, 7.7% of `head`'s samples, about 9.5 ms), `check_program_return_flow` (0.8%) and the memsets they need. About 1.6 ms of
  it is buster#1341's scan (`check_common_unselected_roots`).
- **`check-input`, +14.0 ms.** The pass this branch changes runs in `check-program`; `walks` and `head` leave
  `check-input` unchanged. The two-host record's three-way A/B (`ab3`) gives the history on this host: 44.76 ms at
  `aca9e53a`, 48.03 at #1049's merge `e36740b8` and 52.92 at `9e7f918f`; this record has 58.9 at `0eca996a`. So
  3.3 ms came with #1049's merge and 10.9 ms with later commits. In the profiles, `check_input_run` (+3,384 samples
  against `pre1049`) and `check_input_binding_answers` (+663) grew, and `memset` went from no samples to 1,928.
  In the gdb trace, `check_input_*` functions clear 62 of the 106 MB.
- **`release`, +1.8 ms**, from the one warning (above).

## Correctness

The diagnostics don't change. All of these ran on the 7940HS:

- **The checker's suites at `head`** ([`validation/tests`](validation/tests), [`scripts/tests.sh`](scripts/tests.sh)):
  `test-checker-driver` in 4 parts (58,155 checks), with `--lazy-system-headers` in 2 parts (2,145 and 2,524 checks),
  `test-checker --seed 133` (764,839 checks) and `test-checker-deferred` (3,399 checks), 0 failures.
- **The same suites on `head` merged with main `d9442df0`**, a local, unpushed merge commit
  ([`validation/tests-merge`](validation/tests-merge), [`scripts/merge-check.sh`](scripts/merge-check.sh)): 58,252,
  2,145, 2,524, 767,709 and 3,399 checks, 0 failures.
- **The corpus's 1,745 units with `-Wall -Wextra`** (sqlite, musl and the c-testsuite subset; the frozen corpus
  `391e729a…`'s local copy). Each unit ran `-fsyntax-only` and `-c`, by `head` vector and `--scalar`, and `-fsyntax-only`
  by `head`'s x86-64 host build, from `git archive 9fa45bbb`
  ([`scripts/diag-final.sh`](scripts/diag-final.sh), [`scripts/diag.sh`](scripts/diag.sh)). Every captured diagnostic and exit status is identical to `main`'s on the same path (vector to vector; `--scalar` and x86-64 to `--scalar`). The script discards generated objects without comparing their bytes
  ([`validation/diag-final.log`](validation/diag-final.log)). The vector outputs hold 1,568 warnings (286
  `-Wsign-compare`, 24 `-Wuninitialized`, 8 `-Wself-assign`); the scalar ones 1,564. The 4 extra vector warnings are
  `-Wempty-body` (sqlite3.c:74649 and musl's `execl.c`, `execle.c`, `execlp.c`), #1339's divergence; `main` gives
  the same.
- **The same units with default options**, `-fsyntax-only` ([`scripts/diag-none.sh`](scripts/diag-none.sh),
  [`scripts/diag-none-main.sh`](scripts/diag-none-main.sh)): `head`, `walks` and `main` give identical outputs, 487
  warnings ([`validation/diag-none-main.log`](validation/diag-none-main.log),
  [`validation/diag-none-head.log`](validation/diag-none-head.log)).
- **The gate's fixtures** ([`validation/gate`](validation/gate), [`scripts/gate.sh`](scripts/gate.sh)): ten files of
  `#pragma clang diagnostic` push/pop, ignored, warning, error and fatal records, each under 18 flag sets (including
  `-w`, `-Werror`, `-Weverything`, `-Wno-everything -Wuninitialized` and `-Wno-error=sign-compare`), vector and
  `--scalar`. `head`'s outputs and statuses equal `walks`' in all 360 runs. The log gives clang's warning count beside
  each.

[`validation/diag.tar.zst`](validation/diag.tar.zst) has every output compared above, the job lists and the empty
`diff -r` results. The `bin/compiler-*` executables they name:

| executable | revision | identity |
| --- | --- | --- |
| `compiler-main` | `0eca996a`, native | SHA-256 `34083ccc…` |
| `compiler-gate` | `9fa45bbb`, native | `.text`, `.rodata` and `.data` identical to a fresh build of the committed tree |
| `compiler-gate-x86-64` | `git archive 9fa45bbb`, x86-64 | SHA-256 `7d0b239d…` |
| `compiler-head` | `ac819d97`, native | `.text`, `.rodata` and `.data` identical to a build of `git archive ac819d97` |

The local names come from before the second commit existed: `compiler-head` was then the branch's head, `ac819d97`
(`walks` here), and `compiler-gate` the second commit's build (`head` here). `compiler-gate` was built from the
worktree before the commit was made; the section hashes show it is the committed tree's code.
[`validation/binaries.txt`](validation/binaries.txt) has them.

## Lock receipts and run status

Each hold appended the lock's owner line to a `holds.txt` file before it measured:
[`zen5-9700x/holds.txt`](zen5-9700x/holds.txt) (`ab`, `ab-self`), [`profiles/holds-prof.txt`](zen5-9700x/profiles/holds-prof.txt),
[`profiles/holds-prof2.txt`](zen5-9700x/profiles/holds-prof2.txt), [`wall-wextra/holds.txt`](zen5-9700x/wall-wextra/holds.txt),
[`no-empty-body/holds.txt`](zen5-9700x/no-empty-body/holds.txt),
[`no-empty-body/profiles/holds.txt`](zen5-9700x/no-empty-body/profiles/holds.txt) and
[`self-profile/holds.txt`](zen5-9700x/self-profile/holds.txt). The harness's builds took the lock through its
host profile's `hold_build`. Each `time.tsv` row has its run's exit status (`failed` is 0 in every summary). The
`perf stat` runs' `.status` files are in `raw.tar.zst`. The `status.txt` files in `profiles/`, `wall-wextra/`,
`no-empty-body/`, `no-empty-body/profiles/` and `self-profile/` hold the scripts' final statuses.

An earlier run measured `pre1049`, `main` and `ac819d97` before the second commit existed. It is superseded by this
one and not recorded: its builds are the same files, and its `self-main.i` came from `ac819d97`.

## Files

- `zen5-9700x/`: [`tools/microarch/pack.sh`](https://github.com/buster14a/buster/blob/9fa45bbbc2c5e2b4d7db31b729c0ef0172d69200/tools/microarch/pack.sh)'s
  copy of the run's results (summaries as they are; per-run logs and `perf stat` CSVs in `raw.tar.zst`), plus
  `stages-medians.tsv`, `builds.log` and the second run script's own log (`run2-script.log`).
- `zen5-9700x/profiles/`, `self-profile/`, `wall-wextra/`, `no-empty-body/`: the profiles and the two extra A/Bs
  (each A/B has its logs in `raw.tar.zst`; `no-empty-body/profiles/` has its profiles).
- `scripts/`: every script that ran, as it ran. `run.sh` is the first run, whose builds this run reused.
  `verify-head.sh` built `git archive ac819d97` to check `compiler-head`.
- `validation/`, `analysis/`: above.

The `perf.data` files aren't kept. They are on the 9700X under `~/buster-fast-bench/1340-droid/`.
