# #590's closing checks and #1571, 2026-11-06

The raw outputs behind two Buster changes:
- [buster14a/buster#1557](https://github.com/buster14a/buster/pull/1557), merged as `16c047db`. It records
  [#590](https://github.com/buster14a/buster/issues/590)'s "Done when" checks in `docs/compile-time.md` ("The issue's
  checks at `ec5f0f6b`").
- [buster14a/buster#1573](https://github.com/buster14a/buster/pull/1573), which fixed
  [#1571](https://github.com/buster14a/buster/issues/1571): two routes rebuilt the x86 semantics' tables in a baked
  executable. Its measurements are in the same section of `docs/compile-time.md`, under "Assembly inputs (#1571)".

The earlier #590 record, of #1027, is [`backend-setup-590-2026-11-01`](../backend-setup-590-2026-11-01/).

## What was measured

#590 is done when an empty file's `backend-setup` is near zero with THP `madvise` and `always`, with the same objects,
and a small file's compile has been measured against tcc.

**Executables.** At Buster `main` `ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b`, each machine compares two executables
from one `build.sh` link (`BUSTER_DEBUG_INFO=0`):
- `baked`: the default, with the backend's tables baked in (#1078);
- `unbaked`: `BUSTER_BAKE=0`, the post-link step rerun alone. It builds the tables when it runs, as every compile did
  before #1078.

**Inputs** (`*/inputs/`):
- `empty.c`, empty;
- `tiny.c`, `int main(void) { return 0; }`;
- `hello.c`, `<stdio.h>` and a `puts`;
- c-testsuite at `5c7275656d751de0e68b2d340a95b5681858ed07`: the 220 programs listed in Buster's
  `tests/c-testsuite/subset.txt` (`subset.list`). The programs themselves aren't copied here.
- For #1571: `foo.s`, a function in assembly, and `call.c`, a `main` that calls it.

**Commands.** Each small-file timing is `measure-compile --runs 41 --reference <tcc> -- -c FILE`, pinned to CPU 2,
which also reports `--time-stages`' medians. c-testsuite's rows come from `best_of`: each program's best of 3 runs, per
compiler, summed and divided by 220.

## Results

On the Ryzen 7 9700X, one round:

| input | THP | `backend-setup`, baked | unbaked | wall, baked | unbaked | tcc |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `empty.c` | `always` | 0.004 ms | 0.004 ms | 0.448 ms | 0.481 ms | 0.360 ms |
| `empty.c` | disabled | 0.004 ms | 0.004 ms | 0.561 ms | 0.598 ms | 0.360 ms |
| `hello.c` | `always` | 0.003 ms | 0.862 ms (1,136 faults) | 1.364 ms | 2.516 ms | 0.776 ms |
| `hello.c` | disabled | 0.003 ms | 0.746 ms (1,136 faults) | 1.447 ms | 2.307 ms | 0.769 ms |
| c-testsuite's 220, mean | `always` | | | 0.964 ms | 1.883 ms | 0.543 ms |

On the Xeon VM, the mean of two rounds' medians, with `BUSTER_HUGE_PAGES=1`:

| input | THP | `backend-setup`, baked | unbaked | wall, baked | unbaked | tcc |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `empty.c` | `madvise` | 0.008 ms | 0.009 ms | 1.99 ms | 2.05 ms | 1.65 ms |
| `empty.c` | `always` | 0.009 ms | 0.010 ms | 2.11 ms | 2.41 ms | 1.79 ms |
| `tiny.c` | `madvise` | 0.008 ms | 2.25 ms | 2.22 ms | 4.90 ms | 1.73 ms |
| `tiny.c` | `always` | 0.009 ms | 2.19 ms | 2.45 ms | 4.87 ms | 1.83 ms |
| `hello.c` | `madvise` | 0.009 ms | 2.25 ms | 5.46 ms | 8.01 ms | 2.83 ms |
| `hello.c` | `always` | 0.008 ms | 2.24 ms | 4.88 ms | 7.55 ms | 2.66 ms |
| c-testsuite's 220, mean | `madvise` | | | 3.06 ms | 5.42 ms | 1.66 ms |
| c-testsuite's 220, mean | `always` | | | 3.20 ms | 5.63 ms | 1.71 ms |

**Objects.** The two executables write the same bytes for c-testsuite's 220 programs, `empty.c`, `tiny.c` and `hello.c`,
on both machines (`*/objects.txt`: 223 files, 0 differ).

#1571, two rounds against the build before:

| | 9700X, after | before | VM, after | before |
| --- | ---: | ---: | ---: | ---: |
| `-c foo.s` | 0.479, 0.476 ms (230 faults) | 0.546, 0.546 ms (269) | 2.40, 2.57 ms (675) | 2.64, 2.89 ms (716) |
| link of `call.c` and `foo.s` | 1.181, 1.193 ms (529) | 1.268, 1.283 ms (568) | 4.18, 4.39 ms (1,202) | 4.49, 4.63 ms (1,243) |

## `9700x/`

**Machine.** benchpress: AMD Ryzen 7 9700X, Linux `6.18.50-2-lts`, THP `[always]`, defrag `[madvise]`, clang 23.1.1,
`build.sh`'s `auto` linker. The reference is tcc 0.9.28rc 2026-01-17 (sha256 `49e2d1af…`).

**Harness.** Every build and run took the shared lock through `~/buster-fast-bench/exclusive.sh`, one run per hold,
pinned to CPU 2.
- `harness/close.sh` built both executables, ran `test-baked-tables` on each and compared their objects (`objects.txt`).
  It then ran one `measure-compile`, `empty-always-unbaked-1.txt`.
- `harness/close.sh` was stopped there: lock contention made each run wait 10 to 15 minutes.
- `harness/close2.sh` ran the rest, keeping that log:
  - one round of `empty.c` and `hello.c`, each executable, under THP `always` and with `PR_SET_THP_DISABLE` on the
    process (`harness/nothp`, "disabled");
  - c-testsuite's subset with THP `always` (`harness/best_of`).

  `tiny.c` and a second round were dropped there; the VM has them.

**Identities.** `host.txt` has the executables', inputs', tcc's and the corpus `sqlite3.c`'s sha256, and `size`'s output.
`revision.txt` has the source revision. `test-baked-tables-*.txt` give "baked, the same as built" and "not baked (built
when it runs)".

**Lock receipts.** `exclusive.sh` keeps no per-run log. Its receipts are the "waiting for the 9700X, held by: …" lines at
the head of each output, which name the holder that run waited behind. `close.out` and `close2.out` are the harnesses'
own output.

## `vm/`

**Machine.** A 2.1 GHz Intel Xeon VM with 4 vCPUs: the session's own container, so no lock. Linux `6.18.44-fc-v242`,
Ubuntu clang 23.1.5, ld.lld. The reference is Ubuntu's tcc 0.9.27.

**Harness.** `vm.sh` ran, pinned to CPU 2:
- objects first (`objects.txt`);
- then, under the kernel's THP `madvise` and then `always` (`/sys/kernel/mm/transparent_hugepage/enabled`, switched by
  the script), two rounds with the executables' order swapped of `empty.c`, `tiny.c` and `hello.c`;
- then c-testsuite.

Each ran with two page policies:
- `system`: `BUSTER_HUGE_PAGES=1`, which leaves the kernel's setting in force;
- `vm-off`: the compiler's default on a VM, which turns huge pages off for itself (`lane.c`'s `arena_page_policy`).

`summarize.py` computed the tables above from the logs.

**Identities.** `host.txt` has the executables', inputs' and tcc's sha256, the source revision and `test-baked-tables`'
reports. `1571-hashes.txt` has the #1571 executables'.

**#1571 on the VM.** `1571-*.txt` compare Buster `main` `67cd05ca530b9597fbd24e6843791a85f16ed6ad` (before) with the
fix's source, which was then committed as `fdeaadd0` (after). Both were built by `build.sh` with `BUSTER_DEBUG_INFO=0`.
Each is `taskset -c 2 <after> measure-compile --runs 41 --reference <before> -- ARGUMENTS`, with these arguments:
- `-c inputs/foo.s` for `1571-foo-s-*`;
- `inputs/call.c inputs/foo.s` for `1571-mixed-*`.

## `1571/`

**The comparison.** On the 9700X, `harness/close1571.sh` compares:
- `close/baked`, the `ec5f0f6b` executable above;
- the same revision with `harness/1571.patch` applied (the two guards of #1573, whose files are `main`'s at that
  revision), built by `build.sh` under the lock (`build.log`).

**The runs.**
- `objects.txt`: `-c foo.s`, `assemble foo.s`, and the link of `call.c` and `foo.s`, compared between the two. Each
  program must exit 0.
- `foo-s-*` and `mixed-*`: two rounds of `measure-compile --runs 41 --reference <before>`.
- `hashes.txt` has the identities, and `test-baked-tables.txt` the patched build's report.

## Limitations

- **One round on the 9700X.** The lock's contention limited the 9700X to one round and dropped `tiny.c` there.
- **VM variance.** VM timings vary by up to a millisecond between rounds, and a run in 41 can be several times the
  median. Rely on the medians and the fault counts, not on single runs.
- **What "disabled" stands for.** It is `PR_SET_THP_DISABLE` on the process, inherited by its children. It stands in for
  a kernel with `never`; the 9700X's kernel setting was not changed.
- **No `sqlite3.c` here.** This record doesn't time `sqlite3.c`; `close.sh`'s `sqlite3.c` step never ran.

## License

The harness files and this README are original Buster material under the repository's license (Apache-2.0 WITH
LLVM-exception).

External runtime inputs are referenced by identity and not incorporated: tcc, the c-testsuite programs and the corpus
`sqlite3.c`.

`SHA256SUMS` lists every file of this record but itself.
