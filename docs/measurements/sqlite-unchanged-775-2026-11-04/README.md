# #775: `sqlite3.c` without vectors, main against #1224, 9700X, 2026-11-04

Evidence for [buster14a/buster#1224](https://github.com/buster14a/buster/pull/1224), which closes
[#775](https://github.com/buster14a/buster/issues/775). Its last acceptance item: code without vectors is
unchanged. `-c` of `sqlite3.c` must write the same object, and the PR must have the 9700X's instructions and cycles
for it, main against the head.

Two A/Bs, each dispatched once by hand on the short-lived branch `claude/775-sqlite-ab`. That branch's workflow is
the A/B alone (`harness/`), so a dispatch holds the 9700X for about two minutes rather than the whole suite. This
is the method of #873's A/B (buster `b1178004`).

| run | main (base) | #1224 (head) | head's tree |
| --- | --- | --- | --- |
| [41744484812](https://github.com/buster14a/buster/actions/runs/41744484812) | `e98426b2` | `1ed9666b` | `e98426b2` merged with the PR |
| [41746367274](https://github.com/buster14a/buster/actions/runs/41746367274) | `2fef25b0` | `1f1294b0` | `2fef25b0` merged with the PR: the tree that lands |

In each pair, the head merges the base, so the two builds differ only by #1224's ten files (+1071 −24).

## Host and method

- AMD Ryzen 7 9700X, runner `buster-zen5-9700x` (group `buster-9700x-service-dispatch`). Every step ran within
  the CI job, whose runner hooks hold the shared host lock.
- Clang 23.1.4 (`7a941dfb`), staged by the head's `tools/ci/setup-benchpress.sh`; `BUSTER_HOST_ARCH=znver5`,
  `BUSTER_DEBUG_INFO=0`.
- Each tree was built with `./build.sh shifts DIR main_unit_checker.c 0 704 1408 2048 2752 3456`. That gives
  `build/compiler`, plus six copies with the checker's unit moved by that many bytes (#509's placements).
- Input: the host's frozen corpus `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`.
  `sqlite/sqlite3.c` was checked against sha256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
  It was compiled with the pinned predefines and headers: `--predefines …/provenance/gnu17-pinned-predefines.txt
  --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem …/headers/usr/lib/clang/23/include
  -isystem …/headers/usr/local/include -isystem …/headers/usr/include -c sqlite3.c`.
- **Objects:** each build's `build/compiler` compiles once on CPU 2, and `cmp` must pass.
- **Counters:** 21 rounds of `perf stat -x, -e cycles:u,instructions:u,task-clock` on CPU 2, one process per build
  per round, the builds' order alternating by round. Medians are over the 21 rounds (`stat.txt` holds every value).
- **Placements and copies:** `compiler ab --rounds 2 --cpu 2 head -- time-runs --runs 3 --copies 2`, over the
  six placements of main, of the head, and of main again as the floor. Each round, each build gets 36 runs. The
  logs give each placement and copy.

## Results

### Objects

Both builds write the same bytes in each run:

| run | `sqlite3.o` sha256 |
| --- | --- |
| 41744484812 | `e634dadc62c6874c8ee6b5000368a935b39bbfc61915a39e915ec55133c40e1d` |
| 41746367274 | `5326bfcd9c581dd1f4bea17e906d83e3d32fe84535f4273fe6979184cc98274c` |

The two runs' objects differ because main changed between `e98426b2` and `2fef25b0`.

### Counters (medians of 21)

| run | instructions:u main → head | Δ | cycles:u main → head | Δ | task-clock (ms) |
| --- | --- | --- | --- | --- | --- |
| 41744484812 | 1,187,159,522 → 1,187,160,794 | +1,272 (+0.0001%) | 516,364,319 → 517,857,138 | +0.29% | 108.94 → 108.98 |
| 41746367274 | 1,203,305,656 → 1,203,317,734 | +12,078 (+0.0010%) | 512,528,454 → 512,547,112 | +0.004% | 107.56 → 107.68 |

Cycles ranges, min to max over the 21 rounds:
- run 41744484812: main 513.8M to 518.3M, head 514.5M to 522.1M;
- run 41746367274: main 509.0M to 518.0M, head 508.9M to 523.7M.

Each build's instruction counts vary by less than 200 across the 21 rounds, so the instruction differences are real but tiny. Where
they come from isn't traced.

### Placements and copies (head and main again, against main)

| run | round | head: wall | head: user cycles | main again: wall | main again: user cycles |
| --- | --- | --- | --- | --- | --- |
| 41744484812 | 1 | +0.23% (−0.18% to +0.78%) | +0.20% (−0.32% to +0.93%) | −0.02% | −0.03% |
| 41744484812 | 2 | +0.09% (−0.55% to +0.75%) | +0.01% (−0.48% to +0.73%) | +0.06% | −0.03% |
| 41746367274 | 1 | −0.21% (−0.59% to +0.34%) | −0.02% (−0.73% to +0.70%) | −0.08% | +0.03% |
| 41746367274 | 2 | −0.07% (−0.78% to +0.60%) | +0.15% (−0.91% to +0.62%) | −0.25% | −0.14% |

Each percentage is the median's difference from main. The parentheses give the range over the six placements.
Each build's placements spread 0.4% to 0.9%.

### Reading

- On the landing tree (run 41746367274), the head's difference from main is within ±0.21%. Every interval over
  placements includes zero, as main against itself does (up to −0.25%). That is no measurable change.
- The earlier pair (run 41744484812) is the same, except that its round 1 put the head at +0.23% wall and +0.20%
  cycles. Its intervals over placements include zero too, and round 2 gives +0.09% and +0.01%.
- Instructions differ by +1,272 and +12,078 per compile (0.0001% and 0.0010%).

## Files

- `harness/9700x-ab-e98426b2-1ed9666b.yml` and `harness/9700x-ab-2fef25b0-1f1294b0.yml`: the one-off workflows,
  buster commits `24d77c8c` and `51ecba8c` on `claude/775-sqlite-ab`.
- `run-*/job-*.log`: the jobs' complete logs, as GitHub Actions served them. Credentials are masked by GitHub
  (`***`).
- `run-*/stat.txt`: every counter value, `STAT build round event value`.
- `run-*/objects.sha256`: the sha256 of each build's object and of the counters' object.

The objects themselves (2.3 MB each) are not retained, and neither are the builds' executables.

## Limitations

- One host and one input. The cycle comparisons are within this host's placement and copy noise, which is about
  ±1% over placements and copies. They show no change at that resolution, not that there is none below it.
- The counters come from `perf stat` on whole processes, with the user-space events only.
- Run 41744484812 compared `e98426b2` with `1ed9666b`. Main then moved, so the landing tree was measured again in
  run 41746367274.
