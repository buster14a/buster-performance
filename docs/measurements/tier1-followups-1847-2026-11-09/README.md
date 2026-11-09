# Tier 1 follow-ups of #1847: refusals, records and code size (buster#1981, buster#1982)

Cloud-container counts, not timings. Two compilers, both built from buster14a/buster with `BUSTER_DEBUG_INFO=0 ./build.sh` (native host, AVX-512):
- **base** (`compiler-rt`): main `cb608c1f6` with #1955's first commit (`709cb7800`, the returns-twice refusal), which changes nothing in these sources.
- **head** (`compiler-comb`): the same, merged with #1980 (masked-compare fold), #1981 (result staging) and #1982 (64 arguments) as first written (`5358410f7`, `5d80821fd`, `a3104450b`/`7fcfa74fa`).

## The compiler's own `main_unit_backend.c`

Source: the head's tree (main `cb608c1f6` plus the three branches). Command, at `-march=x86-64` and `-march=znver5`:

```
COMPILER --lanes 1 --tier1 --tier1-refusals --tier1-report --verify -march=ARCH -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -c -o OBJ src/buster/compiler/main_unit_backend.c
```

| Target | Build | Refused | Records | Code certified | Uncertified | .text bytes |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| x86-64 | base | 25 | 1,426,361 | 3,966 | 203 | 6,434,752 |
| x86-64 | head | 9 | 1,439,893 | 3,982 | 203 | 6,428,688 |
| znver5 | base | 25 | 1,491,161 | 4,225 | 204 | 6,738,144 |
| znver5 | head | 9 | 1,504,647 | 4,241 | 204 | 6,735,616 |

The 16 functions past the old 16-argument limit compile by Tier 1, all certified. Records count only Tier 1's functions, so they grow; the object's code shrinks by 6,064 and 2,528 bytes. The 9 left are 5 naked functions and 4 callers of `__builtin_frame_address(0)` (`be-*.txt`).

## The frozen SQLite (speedtest1's `sqlite3.c`)

The CI corpus `preprocessor-391e729af658` at znver5 (`sq-*.txt`): both builds Tier 1 all 2,602 functions with 285,746 records and none refused, and their objects are byte-identical. None of the three PRs changes this code.
