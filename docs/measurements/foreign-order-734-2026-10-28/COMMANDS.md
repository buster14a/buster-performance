# Reproduction commands and identities

These commands describe the completed frozen cohort. Do not overwrite an
existing snapshot or rerun its output paths while another command reads them.
Obtain a separate exclusive lease for each build, test, benchmark or manifest
operation. The loops below invoke the wrapper once per iteration, without
holding a campaign lock. Preserve failed setup and noisy output too.

## Sources and toolchain

From a Buster checkout containing both commits, create fresh immutable source
directories with `git archive`:

```sh
git archive abc6bf2455c6d1d78f16bc2d494276380c546a79 | tar -x -C baseline
git archive 732b79132a52264683abdd0b757053c3901e622b | tar -x -C candidate4
```

The completed target workspace is
`/home/david/buster-fast-bench/codex-734-20261028`. Its read-only official
installation is `toolchain/official`; its complete archive/license identities
are in [README.md](README.md). The official archive is
`https://github.com/llvm/llvm-project/releases/download/llvmorg-23.1.4/LLVM-23.1.4-Linux-X64.tar.zst`.
Verify the full SHA256 before extraction. No CI-private installation is used.
System GCC/CRT/libc/libgcc provide the external runtime inputs; the generated
input/runtime manifests identify the actual bytes.

In the examples, set task-specific variables:

```sh
record_root=/home/david/buster-fast-bench/codex-734-20261028
record_tools="$record_root/toolchain/official/bin"
record_lock=/home/david/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=codex-734
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/734
```

For each source snapshot separately:

```sh
EXCLUSIVE_TITLE='734 baseline optimized build' "$record_lock" \
    env PATH="$record_tools:$PATH" BUSTER_DEBUG_INFO=0 \
    bash -c 'cd "$1" && ./build.sh' sh "$record_root/baseline"
EXCLUSIVE_TITLE='734 candidate4 optimized build' "$record_lock" \
    env PATH="$record_tools:$PATH" BUSTER_DEBUG_INFO=0 \
    bash -c 'cd "$1" && ./build.sh' sh "$record_root/candidate4"
EXCLUSIVE_TITLE='734 candidate4 full foreign cross-check' "$record_lock" \
    env PATH="$record_tools:$PATH" "$record_root/candidate4/build/compiler" \
    test-foreign --cross-check --keep
```

The whole portable 41-unit build is separately attributed to `97c47417`, whose
foreign production files equal `732b7913`; it adds `BUSTER_HOST_ARCH=x86-64`.
The exact final candidate's portable sanitizer execution covers the final
test-only change. Do not relabel either receipt as another source's build.

## Raw resolver samples

Place the original [adapter](harness/foreign-cost.c) at
`$record_root/harness/foreign-cost.c`. Compile it independently from each
source directory; the include resolves against that snapshot:

```sh
EXCLUSIVE_TITLE='734 baseline sample adapter build' "$record_lock" \
    env PATH="$record_tools:$PATH" bash -c 'cd "$1" && clang \
    -O3 -g0 -march=native -fwrapv -funsigned-char -fno-strict-aliasing \
    -Wall -Werror -Isrc -Isrc/buster/compiler ../harness/foreign-cost.c \
    -pthread -ldl -lm -o ../harness/foreign-cost-base' sh "$record_root/baseline"
EXCLUSIVE_TITLE='734 candidate sample adapter build' "$record_lock" \
    env PATH="$record_tools:$PATH" bash -c 'cd "$1" && clang \
    -O3 -g0 -march=native -fwrapv -funsigned-char -fno-strict-aliasing \
    -Wall -Werror -Isrc -Isrc/buster/compiler ../harness/foreign-cost.c \
    -pthread -ldl -lm -o ../harness/foreign-cost-candidate' sh "$record_root/candidate4"
```

The executed order was baseline1, candidate1, baseline2, candidate2, baseline3,
candidate3. Other jobs may run between leases. Run each with its own directory
and preserve stdout and stderr:

```sh
for record_repeat in 1 2 3; do
    for record_variant in base candidate; do
        record_label="$record_variant-$record_repeat"
        EXCLUSIVE_TITLE="734 raw resolver $record_label" "$record_lock" \
            env PATH="$record_tools:$PATH" "$record_root/harness/foreign-cost-$record_variant" \
            --runs 21 --lanes 1,8 --cpus 2,0,1,3,4,5,6,7 \
            --directory "$record_root/cost-foreign-$record_label" --keep \
            > "$record_root/foreign-$record_label.stdout" \
            2> "$record_root/foreign-$record_label.raw"
    done
done
```

The wrapper's waiting/owner text may precede `RAW` records on stderr. The
reader requires all 6,720 unique records and rejects malformed/duplicate/
missing records. It ignores the wrapper's non-record text. Run without
`--linkers`, whose external-linker samples have a different representation.

## Real whole-command controls

The completed order was baseline1, candidate1, baseline2, candidate2, under
separate leases. Substitute `baseline` for a base label and `candidate4` for
a candidate label:

```sh
EXCLUSIVE_TITLE='734 whole command base-1' "$record_lock" \
    env PATH="$record_tools:$PATH" "$record_root/baseline/build/compiler" \
    benchmark-link --only linkers --linkers link-foreign --runs 7 \
    --kinds dynamic,static --cpus 2 \
    --directory "$record_root/cost-link-base-1" \
    --cache "$record_root/cache-link-base-1" --keep \
    > "$record_root/link-base-1.stdout" 2> "$record_root/link-base-1.stderr"
```

Each process produces all 24 placement rows. The command's input model and
the resolver model differ as documented in [RESULTS.md](RESULTS.md).
The command exposes min/median/max summaries, not its seven individual times.

## Local readers and functional adapters

From this record's directory, compile the bounded readers locally:

```sh
clang -std=c17 -O2 -Wall -Wextra -Werror harness/foreign-samples.c -o /tmp/734-samples
clang -std=c17 -O2 -Wall -Wextra -Werror harness/foreign-summary.c -o /tmp/734-summary
for record_repeat in 1 2 3; do
    for record_variant in base candidate; do
        record_label="$record_variant-$record_repeat"
        /tmp/734-samples "raw/foreign-$record_label.raw" "$record_label" \
            > "raw/foreign-$record_label.csv"
    done
done
/tmp/734-summary raw
```

The actual-module sanitizer run uses [qualification.c](harness/qualification.c)
against exact candidate source, with a private include overlay containing a
copy of `src/buster/compiler/main.c` patched by
[qualification-main.patch](harness/qualification-main.patch). This materializes
the actual module entry points and shared target table; it does not replace
the foreign implementation. Apply the patch from that overlay's include root
with `patch -p1`. Compile from the frozen source directory with:

```sh
clang -O0 -g0 -march=native -fwrapv -funsigned-char -fno-strict-aliasing \
    -Wall -Werror -Wno-unused-function -Wno-unused-variable -Wno-psabi \
    -Wno-undefined-internal -ffunction-sections -fdata-sections \
    -fsanitize=address,undefined -I/absolute/private-overlay -Isrc -Isrc/buster/compiler \
    /absolute/record/harness/qualification.c -Wl,--gc-sections -pthread -ldl -lm \
    -o /absolute/private-output/native-order
ASAN_OPTIONS=detect_leaks=1:abort_on_error=1 UBSAN_OPTIONS=halt_on_error=1 \
    /absolute/private-output/native-order
```

The baseline-host adapter changes `-march=native` to `-march=x86-64` and has
its own output. Every local long compile/run is individually wrapped by
`/home/david/dev/scripts/cores -n 1 --title ... --link ... -- COMMAND`.
The old-production negative control uses the three exact baseline foreign
production files, test registration only, and
[the final functional body](harness/old-final-functional.c). New-helper-only
tests are omitted. Old file hashes are recorded beside the receipts.

## Input/binary manifests

[target-manifest.sh](harness/target-manifest.sh) collects source, binaries and
generated inputs/outputs from this issue's owned directories, under one
bounded exclusive lease. It does not modify the shared read-only toolchain:

```sh
EXCLUSIVE_TITLE='734 frozen compiler cohort identities' "$record_lock" \
    sh "$record_root/harness/target-manifest.sh" "$record_root"
```

Large generated payloads remain in the target workspace; the lean text
manifests identify them. Published raw receipts retain rejected and noisy
outcomes and source labels. No compiler binary or toolchain archive is
incorporated into the evidence source repository.
