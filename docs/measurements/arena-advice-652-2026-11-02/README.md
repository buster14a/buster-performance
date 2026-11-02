# Arena page advice and `.bss` in base pages (#652, PR #1168)

Evidence for [buster14a/buster#1168](https://github.com/buster14a/buster/pull/1168), part of
[#652](https://github.com/buster14a/buster/issues/652): a small unit's fixed setup cost.

## Sources

| tree | source | what |
| --- | --- | --- |
| `base` | `3ce71ec312efb45fbcab4d66775e069e30d7e513`'s `git archive` | main when measured |
| `head` | `base` with the first version of the change (advice at commit only) | intermediate |
| `head2` | `base` with `head2.patch` = `git diff 3ce71ec3 6be9b104d74f04c32d797830bc0b74e81254b7e5` | the PR's first commit; rebased unchanged as `3f8e603289adcd8670838b61655a2198b738b024` |
| `m687` | `5b3f29e9e012646388f47468d8f1e7e7b101efb8` | #687 merged |
| `pre956` | `051de9c6754b68600cee5127a1e55b35c2ac6390` (`55c98c73^1`) | just before #956 |
| `m956` | `55c98c73e1537cb2554c130416e6d9f63e4d1de8` | #956 merged |

The PR's second commit (`476e5a030cde3ad71208bec6407b3783d4452581`: docs, tests, and a floor on `arena_reserve_small`'s `small` that no
caller is below) was not timed. Every tree was built on the 9700X with `BUSTER_HOST_ARCH=znver5 ./build.sh`,
each build under the machine's lock. `identities-host.txt` has the executables', inputs' and patches'
SHA-256, the kernel, clang, and the transparent huge page settings.

## Host

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, transparent huge pages `always`, defrag `madvise`.
Timed processes pinned to CPU 2. Every build and every measurement batch ran under the shared 9700X lock,
taken per batch.

## Runs

- `scripts/campaign.sh` (log `raw/campaign.log`): three rounds of `perf stat -x, -r 51 -e
  task-clock,page-faults,instructions:u,instructions:k` of an empty file's `-fsyntax-only` and a one-line
  function's `-c` on each tree; three rounds of `scripts/reserve_bench.c` (90 arenas of 64 GB by six
  layouts, 401 forked samples each); `strace -f -c` of each tree's empty `-fsyntax-only`
  (`raw/strace-*.txt`).
- `scripts/ab2.sh` (log `raw/ab2.log`): `ab --rounds 3 --cpu 2` of `time-runs --copies 3` with builds
  `base`, `head2`, `base-again` (the same executable as `base`, the comparison's floor), one input per
  `time-runs` process: empty `-fsyntax-only` (31 runs), empty `-E -P` (31), tiny `-c` (31), and the
  corpus's `sqlite3.c` `-c` (7), each executable run from three fresh copies.

The logs keep only the lines these scripts and the compiler's `ab`/`time-runs` print; the lock's waiting
notices, which name other sessions, were dropped.

## Results

perf stat task-clock (ms) and kernel instructions, the three rounds' range:

| tree | empty `-fsyntax-only` | kernel instr | tiny `-c` | kernel instr |
| --- | ---: | ---: | ---: | ---: |
| m687 | 0.47 | 2.80–2.81 M | 1.05 | 3.41–3.44 M |
| pre956 | 0.49 | 3.04 M | 1.19–1.20 | 3.74–3.77 M |
| m956 | 0.58–0.59 | 3.65–3.67 M | 1.39–1.41 | 4.43–4.46 M |
| base | 0.58–0.59 | 3.63–3.64 M | 0.69–0.70 | 4.30–4.32 M |
| head | 0.56 | 3.46–3.47 M | 0.67–0.68 | 4.08–4.11 M |
| head2 | 0.53 | 3.42–3.44 M | 0.64–0.65 | 4.07–4.09 M |

(Tiny `-c` before main's #590 bake ran the backend's initializers per process: m687 to m956 are not
comparable with base there.)

`strace -f -c`, empty `-fsyntax-only`: m687 292 calls (1 `getrlimit`, 4 `mprotect`, 144 `madvise`), m956
and base 461 (82, 82, 146), head 362 (82, 82, 47), head2 363 (82, 82, 48).

`time-runs` wall-time medians against `base`, per round:

| input | head2 | base-again |
| --- | --- | --- |
| empty `-fsyntax-only` | −5.37%, −4.42%, −5.22% | +0.37%, +0.71%, −0.02% |
| empty `-E -P` | −2.16%, −2.66%, −2.69% | +0.56%, +0.23%, +0.37% |
| tiny `-c` | −4.44%, −5.08%, −4.54% | −0.20%, −0.40%, +0.18% |
| `sqlite3.c` `-c` | −0.39%, −0.40%, −0.34% | −0.26%, −0.12%, −0.40% |

User cycles of the small inputs read 1–2% above their floor (head2 +1.8% to +4.0%, base-again +0.2% to
+2.4%); `sqlite3.c`'s −0.32% to −0.38% (floor −0.04% to −0.17%). User instructions differ by 0.2%.

`reserve_bench` medians (µs, three rounds): #956's layout 369.5–379.3, lazy (head) 321.2–324.9, `rw`
(before #956) 323.3–326.4, `fixed` 311.9–316.7, `two` 297.5–298.9, `slab` 296.3–299.2; no arenas
24.5–25.6.

## Limitations

- One machine, one kernel; the `.bss` result depends on transparent huge pages `always` (with `madvise`,
  `.bss` takes no huge pages either way).
- The resident-memory figures in the PR (23.8 → 19.7 MB at exit) were taken on a Ryzen 9 7940HS, not here.
- `reserve_bench` isolates reservation layouts; it doesn't measure the compiler.
