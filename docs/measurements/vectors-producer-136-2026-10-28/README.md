# #136's vector producer: what it costs checking and lowering, 2026-10-28

Branch `claude/loving-carson-j9sz52-producer-vectors` (buster14a/buster#717) gives the lowering GNU C's and clang's
vector types of 16, 32 and 64 bytes as Tier 0's VECTOR class, with their operators as X86 entries. This record measures
its commit `c0b216d7`, the branch with main `241fcb3e` merged, against that main, on the frozen `sqlite3.c`. The unit
has no vector type, so this measures what the producer's code costs a unit without vectors. The pull request's publication
head, `326cbf0` (main `12db4a0e` merged), isn't measured here. Neither is the later reviewed `c32dbf57` boundary fix;
this remains evidence for the frozen `c0b216d7` source only.

| Measure (`sqlite3.c`) | main (`241fcb3e`) | head (`c0b216d7`) | change |
| --- | --- | --- | --- |
| `-fsyntax-only`, user instructions (`perf stat`) | 995,717,343 | 996,106,684 | +389,341 (+0.039%) |
| `-fsyntax-only`, user cycles | 467.091 M | 468.784 M | +0.36% |
| `-fsyntax-only`, wall (`time-runs`) | 101.866 ms | 102.490 ms | +0.61% |
| `-fsyntax-only`, peak resident set | 375,008 KB | 374,952 KB | -56 KB |
| `-c`, user instructions | 1,256,935,345 | 1,260,152,655 | +3,217,310 (+0.256%) |
| `-c`, user cycles | 584.904 M | 586.915 M | +0.34% |
| `-c`, wall (`time-runs`) | 124.232 ms | 124.758 ms | +0.42% |
| `-c`, peak resident set | 389,548 KB | 389,252 KB | -296 KB |

Where the rows come from:

- The `perf stat` rows are the medians of three rounds of `-r 11`, the trees in turn (`perf.log`).
- The `time-runs` rows are the medians of five `ab` rounds of 11 processes each (`ab.log`). The head is slower in all
  five paired rounds: by 0.05% to 0.72% for `-fsyntax-only`, and 0.06% to 0.53% for `-c`.
- The head's `-c` object is main's, byte for byte (`abP2.log`: "lower objects identical", against #619's first
  record's `lower_base.o`, the same main's).

These are observed costs, retained. The run has no A/A control, so the wall rows' smaller differences can't be
separated from what an identical executable shows. `-c`'s instruction count, which doesn't depend on placement, is the
firmest number: 3.2 million more instructions, of which `-fsyntax-only`'s 0.39 million are checking's. So about 2.8
million come after checking. There the producer changes only the lowering, and Tier 0's, the encoder's and the
object writer's code is the same in both trees, with the same output.

## The stages

`-c --time-stages` of the same input by each executable (`stagesP2.sh`): six holds of the lock, the trees in turn, of
seven runs each, 21 per tree (`stages2.log`, `stages2-receipts.log`). The medians, in ms:

| Stage | main | head | change |
| --- | --- | --- | --- |
| preprocess | 9.456 | 9.498 | +0.042 |
| parse | 7.242 | 7.243 | +0.001 |
| check-input | 53.603 | 53.579 | -0.024 |
| check-expressions | 13.586 | 13.750 | +0.164 (+1.2%) |
| check-declarations | 2.580 | 2.574 | -0.006 |
| check-program | 11.881 | 11.966 | +0.085 (+0.7%) |
| select | 0.862 | 0.876 | +0.014 |
| lower | 13.947 | 14.021 | +0.074 (+0.5%) |
| tier0 | 4.861 | 4.857 | -0.004 |
| the rest: each run's total less the rows above | 6.235 | 6.275 | +0.040 |
| total | 124.219 | 124.580 | +0.361 (+0.29%) |

Each run's spread is larger than these differences: the totals ran from 123.555 to 127.549 ms for main and from 123.688
to 127.006 ms for the head. The two largest differences are in checking. The expression-checking algorithms are unchanged; the control-program
phase additionally carries the new output-target feature metadata. The aggregate `-fsyntax-only` instruction count
shows only a small instruction increase, while the stage rows show more time in these two passes; it does not isolate
the cause of either pass's cycle change. That fits
a change in clang's code for the same sources (inlining, or the placement of the checker unit's code, in which the
lowering is compiled: #502 measured placement moving `sqlite3.c`'s compile by up to 2%), but this record doesn't
establish which. The lowering's 0.074 ms is consistent with its 2.8 million instructions.

A first attempt took the lock for each run (`stagesP.sh`, `stages.log`, `stages-receipts.log`). CI's jobs, which each
took the lock between two of its runs, made it slow. It was stopped after 7 runs per tree: their totals' medians are
125.349 ms for main and 124.933 ms for the head, the opposite sign, within the same spread.

## The profile

`profile.sh` recorded `perf record -e instructions:u -c 1000003` of 100 runs of `-c` by each tree. It resolved each
sample's address against the tree's own symbol table (`nm_*.txt`, `ips_*.txt`, `functions_*_lower.txt`). The raw files
contain 125,600 and 126,000 samples; the archived tables name 125,513 and 125,943 of them, with the remaining 87 and
57 in unnamed rows. Its per-function differences aren't a reliable attribution here. Summed by component, they move by
millions of instructions a run in code that is the same in both trees and gets the same input: Tier 0's functions by
+404 samples (about +4.0 million instructions a run), and the checker's graph and actions (`check_graph_*`,
`check_action*`, `check_init*`, `check_literal*`, `check_constant*`, `check_builtin*`) by +602, while all of
`-fsyntax-only`'s checking moved by 0.39 million. Sampling skid and differences in what clang inlined into which
function are possible causes; the record doesn't separate them. The raw sample addresses and symbol tables are kept,
so the profile can be decoded again.

In the symbol tables, the head has these functions out of line that main doesn't:

- the producer's new lowering functions;
- two of its new helpers, `check_lower_access_value` (9 samples in 100 runs) and `check_lower_temporary_of`;

and main has `check_lower_table_index` out of line, which the head inlines.

## Tests

On the 9700X, against the system clang 23.1.1 with the oracle cache off, the head passes (`test_*.log`):

- `test-checker --seed 133` (465,224 checks);
- `test-tier0 --cross-check` (265,774);
- `test-checker-driver --executable ./build/compiler` (21,648);
- `test-checker-deferred` (80 fixtures, 1,423 checks);
- `test-check-lanes` (2,937);
- `test-calling-convention --cross-check`;
- `test-check-builtins-x86` (5,607).

The head predates main's #678, so its fpclassify order is the 9700X clang's (`../sections-asm-619-2026-10-28/` explains
the difference).

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`241fcb3e`](https://github.com/buster14a/buster/tree/241fcb3e9a5a55d8ccc3dfffc7d9d0efd56bdda7) | main when measured; its build is #619's first record's (`../checker-pragmas-619-2026-10-28/`, `base`), through a link |
| `head` | [`c0b216d7`](https://github.com/buster14a/buster/tree/c0b216d7d129e6fa6b120e2524f63c83656b2233) | #717's head when measured: `482f3ff7` with main `241fcb3e` merged |

Each tree was `git archive` of its commit, sent by tar into an empty directory. Each `source-*.sha256` holds the
SHA-256 of every file of its tree but `build/`: 669 and 671 files, all of which match `git archive` of the full commits
above. `inputs.sha256` holds those of both executables, both objects, the input and its predefines, and the host's
kernel and clang. The head was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh` (`build_head.log`), and the
base the same way for #619's record. The stage runs used the same executables (the same SHA-256).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1.

## Method

`abP2.sh` ran the comparison, the suites and `profile.sh`; `abP2.log` is its output. The inputs and options are those of
[#619's first record](../checker-pragmas-619-2026-10-28/README.md): the preprocessor oracle's frozen
`sqlite/sqlite3.c` with the pinned gnu17 predefines, `-march=znver5 -std=gnu17 -nostdinc` and the corpus's system
directories, `SOURCE_DATE_EPOCH=1792454400`, `CPATH` and `C_INCLUDE_PATH` unset. `-fsyntax-only` runs with
`--clang-features` and `-c` without it. Timed runs ran pinned to CPU 2, and the suites on CPUs 0 to 7.

Each build, test and timed run of `abP2.sh` took the shared lock on its own, but without receipts. Its logs have the
lock's lines removed (the script's `filter`), which leaves the logs of runs that printed nothing empty. The stage
scripts kept every line and wrote a receipt of each hold: 20 holds, each with `governor=performance epp=performance
min=605310 max=5582301 boost=1 driver=amd-pstate-epp` and status 0.

## Limits

- One input, with one placement per tree.
- No A/A control.
- The comparison's own holds have no receipts, and its logs are filtered (above).
- The profile's attribution isn't reliable (above).
- The publication head `326cbf0`, with main `12db4a0e` merged, and the later reviewed `c32dbf57` boundary fix are not measured.
