# The shared libraries' versions in mixed source links (buster#1590), 2026-11-17

[buster#1590](https://github.com/buster14a/buster/issues/1590), under
[its claim](https://github.com/buster14a/buster/issues/1590#issuecomment-6943297337).
The pull request is buster#2909, on main `d876a5e0`:

- `c1e2ea12`: the checks;
- `11e898ba`: the lookups by index;
- `77a429e5`: the guide's numbers.

Follow-ups: buster#2910 (unversioned library references) and buster#2911 (a library's versioned reference loads archive members by its bare name).

A source command with a positional object, assembly or a selected archive beside its C links through the foreign resolver. Before #2909, that resolver checked no library's versions:

- with one object added to `check_test_driver_versions`' fixtures, 15 of its 22 cases failed on main;
- the weak-need control linked and exited 127.

`ForeignCommand.library_versions`, which the driver's mixed links set, makes the resolution check what the direct path checks:

- it reads each library's version facts beside its import;
- each round, it keeps a library under `--as-needed` that provides a needed library's versioned reference, unless the referring library's own `DT_NEEDED` names it;
- after the last round, it refuses a versioned reference no library exports, and a version need the loader would refuse.

## The cost, on the 9700X

CPU 2, under the lock, a hold a round. `scripts/run.sh` builds both trees Release without debug information, checks that both programs link and run, and compares base's and head's outputs. It then runs `time-runs --runs 5 --copies 3` in three rounds. Each round has two builds of main (`base` and `base-again`) and the head, each from three fresh copies on `/dev/shm`, over two lists:

- **list 1**, the mixed link: `-o /dev/shm/1590-mixed hello.c extra.o -lm` (`printf` and `sqrt`, an object of clang's);
- **list 2**, the direct control: `-o /dev/shm/1590-direct direct.c -lm`, the same program with its object's function in the source.

Both lists write the same bytes from base and head, at both heads.

| head | list 1 instructions (base, head) | list 1 user cycles, head against base, rounds 1-3 | base again |
| --- | --- | --- | --- |
| `c1e2ea12` | 26,241,288 to 26,548,387 (+307,000, +1.17%) | +3.57%, +2.83%, +2.58% | +0.96%, +1.38%, +1.78% |
| `11e898ba` | 26,241,289 to 26,345,081 (+104,000, +0.40%) | +1.46%, +1.65%, +1.90% | +0.19%, -0.05%, +0.75% |

- **List 2 is unchanged.** Its instructions are 30,189,2xx in every build, and its user cycles are within base again's spread.
- **Wall time is noise here.** The mixed link takes about 3.5 ms, and its copies are within 7 to 16% of each other.
- The logs are `results/time-runs-c1e2ea12.log` and `results/time-runs-11e898ba.log`, with each hold's busiest processes before and after.

**Where `c1e2ea12`'s instructions went.** `scripts/profile.sh` ran `perf record -e instructions:u -c 100003` over 300 links of list 1, from each build, under the lock. `results/perf-symbols-*.txt` are the top 40 symbols.

- In base, `foreign_lane_main` was 1.41%. In `c1e2ea12`, `foreign_read_indices` and `foreign_lane_main` were 2.32% together. The readers and the rounds are inlined into them, about +0.9% between them.
- `link_hash_names` went from 0.51% to 0.76%, and `memcmp` from 1.76% to 1.89%.
- An estimate of the inlined code's part:
  - each of the 47 needed versioned references (the 21 of `libc.so.6` and the 26 of `libm.so.6` on this Arch Linux) was looked up twice;
  - each lookup compared every library's version definitions by name, and scanned the hidden exports at that version, `libc.so.6`'s 537 among them.

`11e898ba` indexes each library's hidden exports by hash when it is read, and looks each reference up once. What is left is mostly reading: the hidden exports' lengths, hashes and index (747 names over the five libraries), and the readers' walk of the section headers.

## Mutants, cloud container (not timings)

Each mutant is a copy of the tree with one change, built Develop and run through `test-foreign` and `test-checker-driver --part 26/64`, the part that holds `check_test_driver_versions`. `scripts/mutants-run.sh` runs them.

- **`scripts/mutants-c1e2ea12.py`:** all 10 fail one check or both (`results/mutants-c1e2ea12.txt`).
- **`scripts/mutants-11e898ba.py`:** the index probe, the default export's version, the version name's compare and the recorded reference. Results in `results/mutants-11e898ba.txt`.

## Tests, cloud container

- **`test-foreign --cross-check`:** 0 failures; the new `foreign versions` section has 110 checks.
- **`test-checker-driver`:** all 8 parts with `--in-process`, 0 failures in 206,175 checks. With the flag off, exactly the 15 mixed cases fail.
- **Direct-path suites:** `test-bind`, `test-dynamic`, `test-static` and `test-import` with `--cross-check`, and `test-snapshot`, `test-executable` and `test-link`: 0 failures.
- **`x86-64` baseline Release, `c1e2ea12`:** `test-foreign --cross-check`, driver part 2/8, `test-dynamic`, `test-bind` and `test-import`: 0 failures.
- **`x86-64` rows on the final tree,** plain and AddressSanitizer, MemorySanitizer and ThreadSanitizer, with CI's fatal options (`scripts/sanitizer-rows.sh`): `results/sanitizer-rows.txt`.
