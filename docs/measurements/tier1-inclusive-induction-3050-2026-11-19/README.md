# Inclusive i32 induction in Tier 1

The normal `--tier1 -c` compile of a signed index starting at zero and guarded by `i <= (int)(n & 65535u)` changed on head `1062fdee1e2c4e4b7759c4f7f96a6cacc5449c89`. The base was `b847801169f2b73aed6496c8fa23e9a5499c94e7`. The four sum loops replace the sign extension in the address calculation with a 64-bit register copy. The two search functions also lose the entire sign-extension instruction at the return of the index. [Issue #3050](https://github.com/buster14a/buster/issues/3050)

## Emitted code

Counts use instructions and bytes inside each ELF symbol. Inter-function alignment padding is excluded. The disassembly files contain the symbol sizes from `nm -S` and the instructions from `objdump -d`.

| C function | Instructions, base → head | Bytes, base → head | `movslq`, base → head |
| --- | ---: | ---: | ---: |
| `sum1`, `sum3`, `swap1`, `swap3`, each | 11 → 11 | 28 → 28 | 1 → 0 |
| `find1`, index or first index past the limit | 12 → 11 | 31 → 28 | 2 → 0 |
| `find3`, matching index or −1 | 14 → 13 | 39 → 36 | 2 → 0 |
| `strict1`, the existing strict guard | 11 → 11 | 28 → 28 | 0 → 0 |

The four add loops use `movslq %ecx,%rdx` on base and `mov %rcx,%rdx` on head before `add (%rdi,%rdx,4),%eax`. Both searches use `mov %rax,%rcx` for their array index on head. Their index return goes from `movslq %eax,%rax` followed by `ret` to `ret` alone. The strict control has identical function bytes. Compiler work, run time and hardware performance were unmeasured. [Base disassembly](base.dis) · [Head disassembly](head.dis)

## Correctness and inputs

The hosted A/B job built and ran both compilers on the same GitHub-hosted Ubuntu 26.04 Xeon Platinum 8573C VM after it passed Buster’s vector probe. Both used pinned Clang 23.1.4, Release, `BUSTER_HOST_ARCH=vector`, `BUSTER_DEBUG_INFO=0`, and `BUSTER_SANITIZER=none`. The compiler hashes are in the host receipt. [Hosted A/B job](https://github.com/buster14a/buster/actions/runs/44614261444/job/135878619707) · [Host and fixture output](host-and-tests.txt)

On each revision, the regular object and the object from `--tier1 --tier1-strict --verify --tier1-report` had identical `.text`. The strict driver certified all seven functions, with zero fallbacks and zero uncertified functions. Each product matched the Clang executable and its independent C oracle in 442 checks, digest `4e5f62349346e7b9`. The 17 inputs include zero (one iteration for the inclusive guard), 65535, 65536, high-bit values and unsigned maximum. The searches exercise early, late and missing keys. [Base report](base.txt) · [Head report](head.txt)

The first dataset repeats the 24,798 source bytes of the base revision’s `src/buster/compiler/tier1_select_ranges.c` as unsigned array elements. Its SHA-256 is `a0689de3bbb4dcfdaa2fa6f246f6856db08ff7e9e93795a4d3b66a6fc83e3821`. The second dataset contains 65,536 deterministic 32-bit words. [C kernels](kernel.c) · [Oracle and inputs](oracle.c)

`test-tier1-emit` passed 220,231 checks on base and 220,443 on head. The new fixtures verify the IR, allocate and certify the CFG, and execute the machine code. They cover both branch directions, swapped operands, the exact safe `INT32_MAX - stride` endpoint, one-past overflow, an extra predecessor of the selected successor, and a path around it to the add. A bounded post-add comparison is a strict-only control. The initial five-function probe also captured the baseline before the implementation. [Initial baseline job](https://github.com/buster14a/buster/actions/runs/44612964629/job/135874078615)

## Reproduction

On a compatible hosted Linux x86-64 VM, put the versions from Buster’s `tools/ci/hosted-tools.lock` on `PATH`. From a Buster checkout containing both revisions, set `record` to this directory and run the commands below. The script disassembles each normal object, checks its bytes against the certified object, and runs the executables and induction fixtures. [Reproduction script](reproduce.sh)

```sh
build_root=$(mktemp -d)
git worktree add --detach "$build_root/base" b847801169f2b73aed6496c8fa23e9a5499c94e7
git worktree add --detach "$build_root/head" 1062fdee1e2c4e4b7759c4f7f96a6cacc5449c89
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_TOOLCHAIN=path
(cd "$build_root/base" && ./build.sh --config Release)
(cd "$build_root/head" && ./build.sh --config Release)
bash "$record/reproduce.sh" "$build_root/base/build/compiler" "$build_root/head/build/compiler"
```
