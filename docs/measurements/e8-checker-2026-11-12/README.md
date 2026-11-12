# E8 checker PRs, base against heads, 2026-11-12

Base-against-head timings on the 9700X for package E8's checker PRs in buster14a/buster:

| PR | Issue | What it adds | Directory |
| --- | --- | --- | --- |
| [#2447](https://github.com/buster14a/buster/pull/2447) | #2230, #1844 | casts to atomic types (`check_action_cast`, `check_action_arithmetic`) | `2447/` |
| [#2469](https://github.com/buster14a/buster/pull/2469) | #2375 | casts of records: the scalar cast's error, `-Wpedantic`'s same-type cast warning (a check per cast in the warning graph) | `2375-2213/` (`h2375`) |
| #2213's PR | #2213 | `-Welaborated-enum-base` (a cold reader path) | `2375-2213/` (`h2213`) |

## Host and method

- **Host:** Ryzen 7 9700X (`benchpress`), CPU 2 (`taskset -c 2`), clang 23.1.1.
- **Builds:** each tree was built with `BUSTER_HOST_ARCH=znver5 ./build.sh` (Release) under its own `exclusive.sh` hold (`build.sh`, `all.sh`).
- **Timing:** each `run.sh` is a single `exclusive.sh` hold around one `time-runs` (21 runs, 3 warm-ups, Williams order), with four command lists:
  1. `-fsyntax-only` on the pinned corpus's `sqlite3.c`;
  2. `-c` on `sqlite3.c`;
  3. `-fsyntax-only` on `src/buster/compiler/main.c`;
  4. `-c` on `main.c`.

## Trees

| Name | Revision |
| --- | --- |
| `base` | main `8c67a8d61825d3c28ab88d046cca0ad2d813abd2` |
| `head` (`2447/`) | `f20fd0fd5e55ac0fcf12255a23b3e8746f6bb261` (#2447's head) |
| `h2375` | `8a94efbbaaac9e31dac440f9b48a18a00cf805ed` (#2375's code before its main merge and ID renumbering) |
| `h2213` | `97fa6447f7c93d58874a0753595e093cade73f49` (#2213's first version; its later commits change a fixture, the -w policy of default-error events and the main merge) |

## Results (median, against base)

| Build | List | Wall | User cycles | Instructions |
| --- | --- | --- | --- | --- |
| head (#2447) | sqlite `-fsyntax-only` | +0.86% | +0.21% | +0.066% |
| head (#2447) | sqlite `-c` | +0.26% | +0.29% | +0.055% |
| head (#2447) | main.c `-fsyntax-only` | +0.09% | +0.12% | +0.053% |
| head (#2447) | main.c `-c` | -0.11% | -0.29% | +0.061% |
| h2375 | sqlite `-fsyntax-only` | +0.24% | +0.02% | +0.049% |
| h2375 | sqlite `-c` | +0.22% | -0.03% | +0.039% |
| h2375 | main.c `-fsyntax-only` | +0.23% | +0.31% | +0.071% |
| h2375 | main.c `-c` | +0.13% | +0.02% | +0.062% |
| h2213 | sqlite `-fsyntax-only` | +0.38% | -0.24% | +0.001% |
| h2213 | sqlite `-c` | +0.41% | +0.02% | +0.001% |
| h2213 | main.c `-fsyntax-only` | -0.01% | -0.04% | -0.010% |
| h2213 | main.c `-c` | +0.05% | +0.02% | -0.009% |

All runs ended with 0 failed processes. Every change is within 0.4% of cycles and 0.07% of instructions, which is the spread between unchanged trees on this host: flat.

Raw files: `2447/all.log` and `2375-2213/all.log`, with the scripts that made them.

Session: https://claude.ai/code/session_01EgbxngcM2C2LEUmibuXSqa
