# The change rebased on main 7fbf3eb3

The branch's commit `1ebb568f` rebased cleanly on buster `7fbf3eb3` (#1485's format diagnostics, which touch the same
files elsewhere) as `03c713a2`. Both rebuilt with `BUSTER_DEBUG_INFO=0 ./build.sh`:

| build | sha256 |
|---|---|
| main `7fbf3eb3` | `c419a782326865f02cf65071848ca6466371e2faf4b51abb035ca770f14e4a85` |
| rebased `03c713a2` | `1009f486592d164a70450e7cb092f69abfc2b0e833771925cd5c66336a4d4cde` |

- `fuzz-1-500.log`: the parent's `fuzz/run.sh 1 500` with these two builds: 1,000 runs, 1,000 identical, 17,132
  self-initialization warnings.
- `corpus.log`: the parent's `corpus/corpus.sh` with these two builds (tests and examples from `7fbf3eb3`): 168 runs,
  168 identical, 320 diagnostics.
- `test-checker-driver-rebased.log`: 60,398 checks, 122 failures; `failures-rebased.txt` differs from the parent's
  `tests/failures-main.txt` only in the race counters and the check totals.
- `ab-rebased.sh 7` (`ab-rebased-7.txt`): medians of 7, `vm.overcommit_memory` 1.

| input | main wall | rebased wall | main check-program | rebased check-program |
|---|---:|---:|---:|---:|
| local16000 `-Wall -c` | 544.50 ms | 28.35 ms | 518.046 ms | 1.989 ms |
| local32000 `-Wall -c` | 2,119.29 ms | 53.34 ms | 2,070.757 ms | 4.130 ms |
| strings16000 `-Wall -c` | 558.46 ms | 42.38 ms | 518.683 ms | 2.238 ms |
| static32000 `-Wall -c` | 53.48 ms | 53.54 ms | 3.443 ms | 3.458 ms |
| sqlite3.c `-Wall -c` | 380.94 ms | 384.80 ms | 54.623 ms | 54.477 ms |

sqlite3.c's check-program stage is the same; its wall time moved by 1% in 7 runs, within this VM's run-to-run spread
(the parent's 11-run medians are 372.33 ms and 371.95 ms).
