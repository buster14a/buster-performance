# Scalar FP contraction: decoder acceptance for Buster #1239

Correctness evidence for [buster14a/buster#1239](https://github.com/buster14a/buster/issues/1239),
recorded on 2026-11-13. This packet reruns two real MP3 decoders using three
inputs, both FMA targets, all three contraction modes, and both output routes.
The final matrix uses the committed implementation and native host compiler;
an earlier scalar-host matrix is retained separately. These are serial
correctness runs and make no performance claim.

**Result: 72/72 PCM comparisons passed, with zero failures; all 12/12 on/off
oracle pairs differed.** Every build and decode completed successfully.

## Recorded source and tools

- Published Buster source:
  [b6e29be78ef19b2a3a9bf1fdb75bdd4fd392b1d2](https://github.com/buster14a/buster/commit/b6e29be78ef19b2a3a9bf1fdb75bdd4fd392b1d2).
  The native run used local commit 0e5d318fd9369261da821288e64ee3d37d5b1960.
  Both commits have the identical Git source tree
  169a44eb1940453f5da626d8fe038b29d7341347; the local worktree was clean.
  The final executable is
  build/cmake/native-g0/Debug/compiler, rebuilt from that exact commit.
  SHA-256: 4e3026a1e7e7515c0488d8081223f3b58149c9cfcead7dbdbd35991b5476d981.
  The native receipt records the commit, tree, clean status, and binary digest.
- Earlier scalar-host run, Buster base:
  26f0bb0e1ab0ae8fc0a7c119064796dfd4b0d5fa, with the issue #1239
  implementation in the working tree. The log records the base and changed-file
  list, and the executable digest is retained below, but an exact source
  snapshot matching that scalar binary was not retained. A later working-tree
  manifest could include edits made after the scalar build and is therefore
  omitted. This earlier receipt is supplementary; the final native receipt's
  clean Git tree is the exact source-pinned acceptance reference.
- Earlier executable: build/cmake/x86-64-g0/Debug/compiler, a Debug build with
  the scalar host implementation. SHA-256:
  74b3362b625c37483a8e2c683ea8646290858057fcd9a1fbc0e8c50bea1f2d62.
- External oracle/linker driver: Clang 23.1.4, LLVM revision
  7a941dfb2877a0b8cf30323fefa85ad019e0b0f5. Executable SHA-256:
  c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67.
- Host: Linux 6.18.57, x86-64, exposed Intel Xeon Platinum 8573C with FMA.
  This cloud host is not the approved 9700X performance host. The log retains
  its CPU flags; znver5 describes generated-code selection, not the host.

## Matrix and result interpretation

The matrix has **72 byte comparisons**:

| Dimension | Values |
| --- | --- |
| Decoder | dr_mp3, minimp3 |
| Generated-code target | x86-64-v3, znver5 |
| Buster contraction mode | default, -ffp-contract=on, -ffp-contract=off |
| Output route | Buster object linked by Clang, Buster direct executable |
| Input | generated tone, generated mixed stereo, upstream MPEG-2 vector |

The oracle uses Clang -O0 -march=TARGET -ffp-contract=on for default/on and
-ffp-contract=off for off. Each adapter writes three native-endian uint64_t
values (sample rate, channel count, sample count), followed by signed 16-bit PCM.
The runner compares every byte, requires nonempty PCM and successful process
exits, and records SHA-256 identities for all oracle and Buster outputs.

The runner also requires the on/off oracle outputs to differ for all
**12 decoder × target × input combinations**. This prevents accepting a corpus
that never exposes the original rounding discrepancy.

[native/results.tsv](native/results.tsv) is the final comparison table and
[native/run.log](native/run.log) is the final command receipt. The earlier
scalar-host [table](results.tsv) and [log](run.log) are preserved, identified by
their base revision and binary digest, subject to the source-snapshot limit
above. Each log contains every exact argv, exit
status, input verification, output digest, sensitivity check and summary. The initial
[setup-attempt.log](setup-attempt.log) and [table](setup-attempt.tsv) retain a
failed metadata probe before any decoder was compiled: this environment omits
a sysfs file required by lscpu. The runner now falls back to a bounded
/proc/cpuinfo read. This setup failure is separate from decoder acceptance.

## Supporting compiler suites

The same final implementation also passed the following native-host suites.
Their original logs, including skips and diagnostics, are retained alongside
the exact-commit incremental [build log](native/suites/build-native-commit.log).

| Suite | Checks | Failures | Receipt |
| --- | ---: | ---: | --- |
| Full checker | 830,051 | 0 | [test-checker-native-final.log](native/suites/test-checker-native-final.log) |
| Memoized transitions | 324 | 0 | [test-transitions-native-final.log](native/suites/test-transitions-native-final.log) |
| Requests and option admission | 213 | 0 | [test-requests-native-final.log](native/suites/test-requests-native-final.log) |
| Focused FP-contraction driver | 257 | 0 | [driver-native.log](native/suites/driver-native.log) |

The full checker explicitly skips native execution for some instruction-set
cases the host cannot run; those cases still compile/link where the log says
so. AMX uses separate instruction-trace and memory-ABI checks. Preserve those
limits when interpreting the totals: these are passing suite checks, not a
claim that every generated instruction was executed on this host. Timing lines
are retained as part of the raw logs and supply no performance conclusion.

## Sources, licenses, and inputs

The decoder implementations are unmodified external runtime inputs. They are
not copied into this packet or the compiler repository.

| Input | Exact upstream revision | Retained upstream license |
| --- | --- | --- |
| [mackron/dr_libs](https://github.com/mackron/dr_libs) | f12e197fd462e4c22873fbd70d11b1d2f2c1dc3c | [Unlicense or MIT-0](https://github.com/mackron/dr_libs/blob/f12e197fd462e4c22873fbd70d11b1d2f2c1dc3c/LICENSE), copyright David Reid |
| [lieff/minimp3](https://github.com/lieff/minimp3) | ea99364f61c14656440e8d77e9c233ccf3124633 | [CC0-1.0](https://github.com/lieff/minimp3/blob/ea99364f61c14656440e8d77e9c233ccf3124633/LICENSE) |

[inputs.sha256](inputs.sha256) identifies the three decoder headers, both
upstream license files, the two original adapters, and all three MP3 inputs.
The runner checks this manifest before compilation.

The upstream input is exactly minimp3/vectors/M2L3_bitrate_16_all.bit at the
pinned revision. The two small generated inputs are retained here so their bytes
do not depend on another FFmpeg build. FFmpeg 7.1.5 created them with:

    ffmpeg -hide_banner -loglevel error -y -f lavfi \
      -i 'sine=frequency=440:sample_rate=44100:duration=1' \
      -ac 2 -c:a libmp3lame -b:a 128k tone128.mp3
    ffmpeg -hide_banner -loglevel error -y -f lavfi \
      -i 'aevalsrc=sin(2*PI*440*t)+0.25*sin(2*PI*997*t)|0.75*sin(2*PI*659*t):s=44100:d=1' \
      -c:a libmp3lame -b:a 128k mixed128.mp3

The tone is newly generated. Its filename follows the issue's example; it is
not claimed to be the historical, unprovided tone128.mp3. The generated audio
uses only the stated numerical signals, with no third-party recording.

The C runner, both decoder adapters, and this report are original project
material under Apache-2.0 WITH LLVM-exception. The adapters include the external
decoders when compiled and do not relicense them. The generated signal inputs
and original result records follow the project default terms. Upstream source,
licenses, compiler binaries, generated executables and PCM bodies remain
external/reproducible working artifacts; their revisions or digests are here.

## Reproduce

Use an x86-64 Linux host that can execute the selected generated code, with
Clang 23.1.4, CMake 3.25 or later, and Ninja 1.10 or later. Set absolute paths for
the two checkouts and Clang. Use a dedicated Buster checkout at the recorded
commit. The native host setting uses the machine running the build; the final
recorded run exercised the vector host implementation. An explicit compiler
path prevents a later build publishing build/compiler from changing the test
mid-run. Follow the compiler repository's shared-host lock/core rules where
they apply.

    BUSTER_TREE=/absolute/path/to/buster
    PERFORMANCE_TREE=/absolute/path/to/buster-performance
    CLANG_BIN=/absolute/path/to/llvm-23.1.4/bin
    CLANG="$CLANG_BIN/clang"
    CLANG_RESOURCE=/absolute/path/to/llvm-23.1.4/lib/clang/23
    PACKET="$PERFORMANCE_TREE/docs/measurements/fp-contract-1239-2026-11-13"
    CORPUS="$BUSTER_TREE/build/fp-contract-corpus"
    BUSTER_BINARY="$BUSTER_TREE/build/cmake/native-g0/Debug/compiler"

    git -C "$BUSTER_TREE" checkout --detach b6e29be78ef19b2a3a9bf1fdb75bdd4fd392b1d2
    PATH="$CLANG_BIN:$PATH" BUSTER_HOST_ARCH=native BUSTER_DEBUG_INFO=0 \
      "$BUSTER_TREE/build.sh" --config Debug

    mkdir -p "$CORPUS"
    git clone https://github.com/mackron/dr_libs.git "$CORPUS/dr_libs"
    git -C "$CORPUS/dr_libs" checkout --detach f12e197fd462e4c22873fbd70d11b1d2f2c1dc3c
    git clone https://github.com/lieff/minimp3.git "$CORPUS/minimp3"
    git -C "$CORPUS/minimp3" checkout --detach ea99364f61c14656440e8d77e9c233ccf3124633
    cp "$PACKET/dr_mp3_decode.c" "$PACKET/minimp3_decode.c" \
       "$PACKET/tone128.mp3" "$PACKET/mixed128.mp3" "$CORPUS/"
    "$CLANG" -std=c17 -O2 -Wall -Wextra -Werror "$PACKET/run.c" -o "$CORPUS/run"

    # Use fresh work and receipt destinations; existing files are not overwritten.
    RECEIPTS="$PERFORMANCE_TREE/docs/measurements/fp-contract-1239-rerun"
    mkdir "$RECEIPTS"
    cp "$PACKET/inputs.sha256" "$RECEIPTS/"
    "$CORPUS/run" "$BUSTER_TREE" "$BUSTER_BINARY" "$CLANG" "$CLANG_RESOURCE" \
      "$CORPUS" "$CORPUS/rerun" "$RECEIPTS"

The expanded build, decode, and input paths for each recorded run remain in
its command log. The reproduction commands above depend only on the supplied
checkouts and toolchain paths.

To repeat the supporting suites with the same paths:

    export BUSTER_CLANG_RESOURCE_DIR="$CLANG_RESOURCE"
    "$BUSTER_BINARY" test-checker --clang "$CLANG"
    "$BUSTER_BINARY" test-checker --transitions --clang "$CLANG"
    "$BUSTER_BINARY" test-checker --requests --clang "$CLANG"
    "$BUSTER_BINARY" test-checker-driver --fp-contract-only --executable "$BUSTER_BINARY" --clang "$CLANG"

This matrix makes no fast-mode, optimization-throughput, Tier 1 performance,
other-host, arbitrary-corpus, or exhaustive MP3-decoding claim. Dedicated
compiler fixtures separately cover pragma scope, rounding modes, exceptional
values, and feature gates.
