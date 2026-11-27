# Tier 1 frame sort using significant bits

Candidate `100ed8223d73c67db829fbd254a059c5fcd86bed` replaces the large-frame byte radix with a stable radix over the bits that vary. It extracts eight digits at once, uses a ninth bit when that saves a pass, and writes only event IDs in the last pass. The baseline is `0a2c3034cf6093cda0f461e519ceb04484739259`. [Compiler revision](https://github.com/buster14a/buster/tree/100ed8223d73c67db829fbd254a059c5fcd86bed)

**The sort passed its per-size gate. The whole-compiler gate is open.** The same-path control measured a 0.217% Lua and 0.260% SQLite increase in Tier 1 whole-compiler user cycles. Musl used 0.036% fewer. All 1,371 objects and both diagnostic streams matched byte for byte. The output set contains one SQLite object, 34 Lua objects, and 1,336 musl objects.

| Complete frame-planning benchmark on 9700X | Comparisons | Candidate / baseline ticks |
| --- | ---: | ---: |
| Standard 33–32,768-object set, two class distributions, three repeats | 66 | 0.533–0.923 |
| 9–32 objects, class generator cycles through 9 or 12 distinct classes, three repeats | 144 | 0.582–0.755 |
| Dense sweep at 33–512 and around powers of two through 65,536, two distributions | 1,086 | 0.514–0.929 |
| Replay of 1,388 SQLite frames | 1,388 matching plans | 0.944 overall |
| Replay of 638 Lua frames | 638 matching plans | 1.002 overall |
| Replay of 2,479 musl frames | 2,479 matching plans | 0.912 overall |

The dense sweep also measures 64 cells at 1–32 objects. Small random frames often use the existing rank sort and class register. The 9–32-object boundary fixture forces enough distinct class keys to reach the changed radix. The 33-object boundary always exceeds the 64-event rank limit. The prior reach census found 29 SQLite, one Lua and 58 musl frames above that event limit. The forced no-room index-sort arm has correctness coverage in the compiler tests. [Earlier reach census and original gate](../tier1-frame-sort)

The official frame suite passed at seeds 177, 7, 11 and 1234. The default seed retained its frozen digest `0x98e191af1dc9e33b` over 1,175,093 checks. The execution suite passed 14,646 checks. The focused sort fixture checked 1,924 stable permutations under ASan and UBSan. Seven independent mutations were rejected. Mutation 5 suppressed intermediate key writes and tripped the sanitizer. [Raw measurements and checks](results)

## Reproduction

Use native Release with Clang 23.1.4 on the 9700X under the shared exclusive lock. Set `BASE_TREE` and `HEAD_TREE` to the two clean compiler checkouts. Set `CC` to the toolchain's clang. Run `bash kernel-build`, then run `taskset -c 2 ./gate synth`, `./boundary synth`, and `./stress synth` with the same pinning. Reuse the three captures from the prior frame record with `./gate replay INPUT.bin`. [Capture recipe](../tier1-frame)

`gate.c` and `side.c` come from the preceding frame-sort experiment. `stress.c` extends that gate with every count through 512 and nine counts around each later sampled power of two. `boundary.c` fixes the class distribution. The standard and small boundary tests take medians of 21 alternating passes in a single process. The dense sweep uses 11 passes.

Build each compiler with `./build.sh --config Release`. The shared-host `driver` records the compiler options, corpus selection, output comparisons and three 3-run rounds. The 16-repeat `same-driver` holds the launch path, output directory and build label fixed and rotates the candidate and baseline with one duplicate of each. The paired change is the median across repeats of the ratio of the sum of candidate user cycles to the sum of baseline user cycles. Run `bash run` from the mutations directory with `HEAD_TREE` set to exercise the independent permutation test.
