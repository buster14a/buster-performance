# Issue 2053 integrated fixture checks

The combined vector Release build used Clang 23.1.4 and main at `58fc2a865`. The local merge `529c1af8cd3f03b4ffddb4d239645f151afe2b40` incorporates the following published packet revisions.

| PR | Revision | Migration |
| --- | --- | --- |
| [#3539](https://github.com/buster14a/buster/pull/3539) | `bffd866ea` | Warning v2 loader and default sweep |
| [#3540](https://github.com/buster14a/buster/pull/3540) | `d816ddaaa` | 33 warning suites |
| [#3520](https://github.com/buster14a/buster/pull/3520) | `d53b51403` | Remaining 25 warning suites |
| [#3530](https://github.com/buster14a/buster/pull/3530) | `e8d757e00` | Complete driver programs and goldens |
| [#3526](https://github.com/buster14a/buster/pull/3526) | `b6eb10860` | Ordinary native checker programs |
| [#3532](https://github.com/buster14a/buster/pull/3532) | `78207a6f2` | Private checker fixtures |
| [#3531](https://github.com/buster14a/buster/pull/3531) | `8ae2edbb9` | Preprocessor auxiliary fixtures |

The difference from the integrated main baseline is 1,331,330 fewer host-source bytes across 87 C files. The final executable is 74,063,320 bytes, the checker object 29,823,376 bytes and the frontend object 6,765,936 bytes. The packet directories record matched before/after sizes and their build environments. The paired clean builds in the warning record ran under different machine loads.

## Runtime and build observations

- The final Release binary passed all four preprocessor shards with Clang. The added ordinary header regression checks main and included-file locations and literal percent text in diagnostic messages. An added header/guard pair passed with its frozen digest. A wrong header golden failed. Two no-op option sets still failed the Clang refusal check when a standard appeared later or as a forwarded operand.
- A separate data-only control changed the header’s logical filename to literal `%d/structure.h` with `#line`. Without Clang, part 3/64 passed all 52 structure fixtures before the location fix at `d44a2dad1`. The same control on `8ae2edbb9` failed exactly one fixture. The good fixture passed. The standalone matcher controls also passed with address and undefined-behavior sanitizers.
- The auto-address control supplied an explicit fixture root and corrupted only its auto-address catalog. Part 14/16 named the alternate catalog and failed. All other parts passed. Restoring the catalog passed 14,193 checks with the identical executable.
- Touching each of five representative data files, then restoring them, scheduled zero host commands in the configured Ninja Release graph. The executable and both owner-object SHA-256 hashes stayed identical after every probe. See `combined-noop-final.log`.
- The combined checker and driver focuses passed 2,142 and 675 checks under the instrumented build. Preprocessor part 1/4 also passed under instrumentation. That initial build used main at `7515714d0` and the preprocessor packet through `713a78f52`. Updating the preprocessor test sources and their fixture data to `8ae2edbb9` passed the Clang directives shard under address and undefined-behavior sanitizers, and the forged location failed as expected.
- The combined Release driver part 6/16 passed 15,790 checks. The IR parser passed 12,226 checks over 52 functions. The Tier 1 mask suite passed 211,144 checks including 1,280 native runs against the interpreter.
- The native-program PR merged after its [merge-group correctness and benchmark workflow](https://github.com/buster14a/buster/actions/runs/45367318763) passed.

The [hosted preprocessor PR workflow](https://github.com/buster14a/buster/actions/runs/45372184756) passed on `8ae2edbb9`. All seven PR heads had successful check rollups when this record was published.

Run the saved controls from the Buster source root after the vector Release build. The diagnostic and warning-root scripts write temporary output under `/tmp/b2053`. Create that directory before running them. `pp-literal-path-control.py build/compiler` intentionally exits 1 on the corrected binary. The combined object and executable size capture comes from `combined-noop.py`.

The adjacent warning, driver, native, private-checker and preprocessor records contain ordered Clang byte extractions, packet-specific case-addition and failure controls, artifact sizes, owner rebuild probes and shard logs. The private checker record includes an isolated passing rerun of the host-sensitive wide-vector shard.
