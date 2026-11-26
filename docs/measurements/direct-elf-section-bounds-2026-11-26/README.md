# Section boundary resolution in Buster’s direct ELF linker

CCAN’s autodata test registers three pointers across two C files. Buster previously inspected 420 atoms to resolve the four uses of its section boundaries. With the patch, those four uses read the recorded endpoints. The binder finished its own lookups without building a hash table. A complete build of Lua 5.4.8 exercised the path for programs without input section names and skipped grouping entirely.

| Single-lane input | Atom visits to resolve boundary values before | Indexed endpoint reads after |
|---|---:|---:|
| CCAN autodata test and its TAP runner | 420 | 4 |
| Four registries with 512 entries across eight producer files | 8,656 | 16 |
| Lua interpreter | 0 | 0 |
| 2,048 single-entry sections | 17,031,168 | 8,192 |
| 8,192 single-entry sections | 269,451,264 | 32,768 |

The columns count operations in boundary-value resolution. They exclude hashing, group construction, layout, and other compiler work. The single-entry inputs stress the number of distinct names. The four-registry case stresses the number of entries per name. Each ELF was byte-identical to the baseline and ran successfully. CCAN passed all four upstream TAP assertions. Lua sorted and checked a table of 1,000 elements. Clang independently passed the CCAN, Lua, and four-registry programs.

## Revisions and environment

- Buster baseline `c9921c19dcb75d9af678530ee7045da4971d622c`, candidate `c088b4769cc5d4e3ce29db5100c270ce70c461f2`.
- CCAN `0ca68d374de2c53262f6bbd948c81054ec141ea5`, upstream test `ccan/autodata/test/run.c` with `helper.c` and `ccan/tap/tap.c`. CCAN’s configurator selected `HAVE_SECTION_START_STOP=1`.
- Lua 5.4.8 release archive, SHA-256 `4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae`. The interpreter uses all C sources in `src` except the standalone `luac.c`.
- Linux 6.18.57, AMD EPYC 9V74, Debian glibc 2.41, Clang and LLVM tools 23.1.4. Both compilers used the native Release configuration with `BUSTER_DEBUG_INFO=0`. These are source execution counts. Wall-clock performance on the project’s 9700X was unmeasured.

## Replay

Use Bash, Git, Make, awk, jq, the matching `llvm-profdata` and `llvm-cov` on PATH, and a Linux/x86-64 machine supported by Buster. In the commands below, set `record` to the absolute path of this measurement directory. Buster’s helper verifies the Lua archive before extraction.

```bash
git clone https://github.com/buster14a/buster.git buster
git -C buster worktree add --detach ../base c9921c19dcb75d9af678530ee7045da4971d622c
git -C buster worktree add --detach ../head c088b4769cc5d4e3ce29db5100c270ce70c461f2
for tree in base head; do
    (cd "$tree" && BUSTER_DEBUG_INFO=0 ./build.sh --config Release --jobs 4)
done
git clone https://github.com/rustyrussell/ccan.git ccan
git -C ccan checkout --detach 0ca68d374de2c53262f6bbd948c81054ec141ea5
make -C ccan config.h
bash head/tools/ci/hosted-offline.sh lua "$PWD/lua"
bash "$record/replay.sh" base head ccan lua "$PWD/results"
```

The replay generates the synthetic inputs and compiles each case through the ordinary Release driver. It then rebuilds the binder and writer’s unity object with LLVM coverage and relinks each compiler with its other Release objects. It compiles each input once per instrumented binary with one lane, checks the ELF against its ordinary build, compares the two revisions’ ELFs and runs them. The JSON reports in the output directory retain the original LLVM regions. The extractor selects the baseline atom-loop body, the candidate’s successful endpoint read, each grouping call, and the binder’s index construction at the two recorded revisions.

The TSV includes executable hashes for this environment. Different system runtimes can change those hashes. The replay checks each before/after pair on the same machine. [Recorded counters and hashes](counters.tsv)

[Compiler binary identities](compiler-hashes.sha256) cover the native and instrumented executables used for this replay. No CCAN or Lua source is vendored in this record.
