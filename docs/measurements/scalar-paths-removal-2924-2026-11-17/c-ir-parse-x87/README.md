# C9g: the IR parser's newline scan and the x87 transfer candidates, two-path fixtures (#2924)

Neither scan is on a corpus's measured compile path: the IR text parser serves tests and `reduce-ir`, and the x87
transfer planner runs only on functions with `long double` regions. So, as #2924's owner set for such areas, each was
timed by a fixture of its own first, with both paths in one executable (Release, on the 9700X under the lock, CPU 2;
three runs each). Ratios are the twin's (scalar) time over the vector path's: above 1 the vector path wins.

## The IR parser (rule 3: the twin goes)

[`measure-paths.patch`](measure-paths.patch) (`measure-c9g-paths`, on #2924's value numbering branch, which doesn't
touch the parser) parses each of `tests/`' 175 IR files 50 times by both paths, the paths taking turns
([`run-measure.sh`](run-measure.sh), [`logs-measure/`](logs-measure/)): 7,799,250 bytes a round, the twin 10.75 to
10.88 ticks a byte against 10.19 to 10.20 for the 64-byte newline scan, **1.054 to 1.067**.

## The x87 transfer candidates (rule 2: to the owner)

The same patch's first table: regions of `count` records, every 64-record window of 64 Ki random records
([`logs-measure/run*.txt`](logs-measure/)). The gather kernel lost below six records:

| Records | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 16 | 32 | 64 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| twin / gather | 0.29-0.32 | 0.36-0.37 | 0.45-0.46 | 0.55-0.59 | 0.72-0.92 | 1.37-1.45 | 1.75-1.78 | 2.03-2.09 | 1.81-1.84 | 1.06-1.11 | 0.98-1.00 |

The kernel was rewritten without the gather: a record is 16 bytes, so one 64-byte load holds four records' forms,
and the tokens and the eligibility are sixteen lanes at a time (which also replaces the scalar loop that cleared
ineligible stores). [`measure-x87.patch`](measure-x87.patch) (`measure-c9g-x87`) times it against both, with half the
records' eligibility random ([`run-x87.sh`](run-x87.sh), [`logs-x87/`](logs-x87/), three runs):

| Records | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 16 | 32 | 64 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| twin / loads | 0.45-0.46 | 0.59-0.63 | 0.81-0.82 | 1.02-1.03 | 0.89-0.91 | 1.01-1.05 | 1.27 | 1.44-1.46 | 1.66-1.67 | 1.72-1.79 | 1.79-1.82 |
| gather / loads | 1.39-1.44 | 1.42-1.48 | 1.59-1.61 | 1.69-1.72 | 1.30-1.31 | 1.37-1.40 | 1.46-1.50 | 1.55-1.57 | 1.56-1.59 | 1.68-1.71 | 1.78-1.80 |

Every window's result agrees with the twin's. The new kernel beats the gather at every size, and the twin from six
records up, but still loses at one to three records and five: about 4.5 ticks for the twin's one compare against
about 10 for the kernel's fixed loads, compares and mask arithmetic. Under rule 2 the twin can't go yet, so the x87
piece waits for the owner.

[`x87-rewrite/`](x87-rewrite/) holds the branch as patches on main `968a085f`, waiting for the owner: the parser's and
the x87 scans' tests and deletion as first written (the parser's half went into #3507 alone), the fixture for regions
past record 0, the 64-byte-load kernel, and (`fixture-bytes/`) the fixture for the bytes beside a store's form.
