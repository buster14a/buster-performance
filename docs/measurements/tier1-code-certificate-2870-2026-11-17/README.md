# buster#2870: the code certificate's benchmark on the frozen sqlite3.c

The nightly step "Benchmark the code certificates of the frozen SQLite source's functions" failed on main with
`a function's code certificate refused it: no report`
([buster#2870](https://github.com/buster14a/buster/issues/2870)).

The function was `pagerWriteLargeSector`: #2784's slot stamps left out a store into a loop bound's slot two blocks
after its reload, in a run of single-predecessor blocks, and the certificate's entry facts held only the bound's
register there, so the edge into a block that waits for it in its slot was refused (`TIER1_CERT_EDGE`). The fix
(branch `claude/adoring-bell-lipssn`, head `38a848237`) has the emitter list those slots per block and the decoding
assert them as entry facts that the edges must prove.

On benchpress (Ryzen 7 9700X), Release, under the lock, CPU 2, the nightly's command (`run.sh`):

- main `d876a5e0f` (`bench-main.log`): exit 1, the same line as the nightly's, after 584 functions;
- head `38a848237` (`bench-head.log`): exit 0, 2,109 functions certified (429 straight-line, 20 variadic and 42
  indirect left uncertified, none refused), with the report: certify 996 cycles an IR instruction, check 420.

`exclusive.sh` waited for other sessions' runs before each benchmark (the logs' first lines); the times were taken
with the lock held.
