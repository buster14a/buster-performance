# Checked canonical body addresses in the typed source runner

The program-facing command `interpret-c` calls `run_typed_source`. Once the interpreter image is ready, the old `interpreter_source_run` compares each function symbol's resolved address with every populated canonical body. The patch computes an index from the unsigned address difference and the body stride. An index below the populated count can name one candidate. Exact address equality rejects interior bytes, including naturally aligned addresses between two element starts.

| Bodies | Function symbols | Base body-address equalities | Patched equalities | Entry symbol | Steps | Return |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 64 | 96 | 6,144 | 96 | 97 | 452 | 37 |
| 128 | 192 | 24,576 | 192 | 193 | 900 | 37 |

Each generated program has two translation units. Main calls every leaf and checks the sum. The cross-unit declarations account for the additional 32 and 64 symbols. The counts cover the lookup after image construction. The uninstrumented vector build retained the baseline SIMD compare loop. [Measurements and disassembly](observations.txt)

Both clean builds passed 908 interpreter, 52 native and 39 interpreter-link checks, plus the typed source fixture, its strict Tier 1 variant and the SSA-source self-test. All 28 traced cases agreed on canonical body selections, native counts, selected entry and parameters, interpreter status, both return words, steps, stdout, stderr and exit status. Native Clang agreed on all ten successful ordinary cases. The cases include aliases, colliding local names, native calls, unresolved weak and null values, reversed unit order, both weak and strong entries, and 13 address injections. The local full trace archive had been verified when the execution host disconnected. This record contains the observed results and the probes and inputs that regenerate those traces.

Buster base `198a76539df21f444e4be4e968a14f06fb43531f`. Candidate commit `4a5d03ddfa4cd08d3df72a589689d0f75e43b519` has tested tree `28126b9ebfaf0ced56d5d794f3fa3e1fadee0439`. The production diff touches the source runner and the multi-unit alias regression. [Compiler PR](https://github.com/buster14a/buster/pull/3177)

## Reproduce

From this directory on an identified non-9700X AVX-512 Linux host, pass a Buster checkout containing the base and an output directory that does not yet exist.

```sh
./reproduce.sh /path/to/buster /tmp/typed-source-3154-results
```

The script creates a detached worktree. It uses `BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 ./build.sh --config Develop`, the pinned toolchain, both clean builds and two temporary probe builds. Each source case enters through `build/compiler interpret-c`. The generator, native oracle, correctness commands and comparison rules are included here. The original machine was an isolated Linux x86-64 workspace on an AMD Ryzen 9 7940HS with Clang 23.1.4. The script uses `cores` when installed and accepts a managed host's per-command allocator in `BODY_RUNNER`.

Each normal case produces separate stdout, stderr and process status files. Probe cases append a deterministic per-symbol trace and count only evaluations of the equality against a canonical element. For edge cases the probe overrides one resolved token after image construction. The production patch contains neither the counter nor the overrides. Recheck any completed run with

```sh
./verify.sh /tmp/typed-source-3154-results
```
