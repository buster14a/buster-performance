# Builds with CI's toolchain and the host's (2026-11-13)

[buster#2628](https://github.com/buster14a/buster/issues/2628): sessions build the compiler with CI's toolchain. This
record times clean builds of one tree on the 9700X with each of the two clangs a session there could use:

- **`ci`**: CI's toolchain, `./build.sh`'s new default (`BUSTER_TOOLCHAIN=ci`): the official LLVM 23.1.4 release that
  the 9700X job stages (`~/.cache/buster/benchpress-clang/efdd1dbd...`, `tools/ci/setup-benchpress.sh`), with CMake
  4.4.3 and Ninja 1.13.2 from `~/.cache/buster/build-tools`, which `tools/ci/session-toolchain.sh` finds there.
- **`path`**: the host's clang 23.1.1 (`/usr/bin/clang`), CMake and Ninja, as `./build.sh` built before
  (`BUSTER_TOOLCHAIN=path`).

**Result.** CI's toolchain builds Develop, now `./build.sh`'s default, **19% faster** (27.9 s against 34.7 s), and
Release with `-g` **17% faster** (72.0 s against 86.9 s):

| Configuration | Round | `path` (host 23.1.1) | `ci` (release 23.1.4) |
| --- | ---: | ---: | ---: |
| Develop | 1 | 34.7 s | 27.9 s |
| Develop | 2 | 34.7 s | 28.0 s |
| Release (`-g`) | 1 | 86.9 s | 72.0 s |
| Release (`-g`) | 2 | 87.5 s | 72.5 s |

The times are wall time inside the lock, from `rm -rf build` to the published executable, configure step included.
Both toolchains had the parts on (`parallel native generation: 1`, `Develop configuration: TRUE, in parts: TRUE` in
every log). The longest compiles moved alike: Release's checker unit 70.7 to 57.2 s, the backend's 47.2 to 37.9 s;
Develop's longest, `c_preprocessor_benchmark.c` (a benchmark unit Develop keeps, since `test-preprocessor` runs it),
10.2 to 7.4 s.

- **Sources:** buster at `4ff2dfc6`, the pull request's commit that added `BUSTER_TOOLCHAIN` (its tree is that of the
  branch's `28dfe806` but for a mapping of runtime-only libraries the 9700X doesn't use: it has `/usr/lib/libzstd.so`).
- **The 9700X** (`benchpress`): eight jobs, `BUSTER_HOST_ARCH=native`, `BUSTER_DEBUG_INFO` unset (Release with `-g`).
  Each build was its own hold of the 9700X's lock (`run.sh`), the two toolchains alternating within each round,
  Develop then Release; the tree's switch of toolchain starts it afresh, as `build.sh` does, so each is a clean build.
  Other sessions' work ran between holds.
- **Files:** `run.sh` (the script), `results.txt` (its summary: round, toolchain, configuration, wall milliseconds,
  `build.sh`'s own report, and the configure step's line naming the toolchain), and `logs/` (each build's output).

A cloud container (4 CPUs, Ubuntu's clang 23.1.6 on `PATH`) staged the hosted layout in 91 s: 1.27 GB from the pinned
GHCR mirror in 61 s, then the install (`install-hosted-tools.sh`), 1.9 GB on disk.
