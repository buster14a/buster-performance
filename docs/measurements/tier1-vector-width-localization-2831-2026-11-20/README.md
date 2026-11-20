# Why SQLite vectorization costs more with a Zen 5 target

On Buster `c8b259413110b1d6f5ff9a005a1c49f48ca01e57` the excess work in [#2831](https://github.com/buster14a/buster/issues/2831) comes chiefly from two loop-invariant values being moved inside `sqlite3VdbeExec` after a sorter loop has been vectorized and inlined. The original comparison changes the generated ISA and the vector width together. Holding the generated ISA at `znver5` shows nearly identical compiler work at 16, 32 and 64 bytes.

## Whole compiler

SQLite 3.53.2, Release host build for znver5, Tier 1 at `-O2`, one compiler lane, frozen input, local Ryzen 9 7940HS. Counts are the medians of four measured rounds after a warm-up. The unmodified executable’s base and vectorized counts were 7,852,167,665 and 7,922,816,202 at znver5, and 7,851,269,056 and 7,869,689,243 at x86-64. The difference between those two increases was 52,228,351 instructions.

The diagnostic executable kept all znver5 forms and capped only the widths offered to the loop vectorizer. Its end-to-end totals were 7,924,598,463, 7,924,591,096 and 7,924,462,094 instructions for 16, 32 and 64 bytes. The driver confirmed that its two emitted vectorized loops used the requested width in each case. The ordinary x86-64 and znver5 settings on the diagnostic executable produced the exact unmodified object hashes. Both independent instrumented stage traces also produced those hashes. The full table includes `-inline` controls.

## Source function and actual pass work

One source function accounts for approximately 52.29 million instructions of the difference between the two target-specific vectorization costs. In `sqlite3VdbeExec`, loop-invariant code motion accounts for 35.77 million and the machine emitter for another 10.09 million. Selection changes by about 34 thousand. The function and stage tables report both independent rounds. Nested stages are inclusive.

At the entry to loop-invariant code motion the default case has 45,157 IR nodes in 4,138 blocks, four 128-bit vectors and zero hoists. With the znver5 target and vectorization it has 45,180 nodes in 4,140 blocks. The 16-byte case has nine 128-bit vectors. The 64-byte case has five 128-bit vectors and four 512-bit vectors. Both move two nodes, visit 44,235 analysis entries and consume 4,598,832 bytes of scratch. The default case consumes 2,697,864 bytes. Once any value is hoisted, the existing LICM implementation materializes the reordered function, rebuilds its CFG, rewrites its IR and verifies the result. In the x86-64 vectorized execution this VM function retains its default IR counts and moves zero values.

The site intervention enables the vectorizer at just one original source body while keeping the rest of the compiler target fixed. Allowing only `vdbeSorterAddToTree` suffices to produce both hoists and the high VM-stage instruction count. Allowing only `chacha_block`, `unixShmLock` or `walRestartHdr` leaves zero hoists in the VM. Skipping just the original sorter body still allows its loop to be discovered in a later inlined caller; the site ledger names every actual successful transformation. These interventions localize the cause and change which functions pay to attempt vectorization.

The diagnostic uses per-thread Linux hardware retired user instructions, with a pinned event and kernel/hypervisor instructions excluded. Stage totals were collected separately from uninstrumented process counts. The complete source delta and profiling source accompany the two raw per-body traces for each of eleven settings. These are local measurements. A direct 9700X comparison is pending.
