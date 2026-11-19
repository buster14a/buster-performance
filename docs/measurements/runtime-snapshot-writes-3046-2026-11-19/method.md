# Cold runtime snapshot writes

This experiment measures the cache miss reached by a normal link in buster14a/buster issue #3046. The base is `6427879e1143026a12fb0388a20bdea1fe4b2bc5`. All compiler binaries and test programs ran on GitHub-hosted Ubuntu 26.04 x86-64 machines after the repository's AVX-512 probe qualified their CPU and OS. The baseline, uninstrumented comparisons, write census and phase comparisons each identify their host in the corresponding run record.

## Workloads and builds

Use the repository's pinned Clang 23.1.4 toolchain with `BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none ./build.sh --config Release` for both binaries. The vector target is `-march=x86-64-v4 -maes -mgfni -mvaes -mavx512vbmi -mavx512vbmi2 -mavx512vpopcntdq -mavx512bitalg -mavx512vnni`. Each measured pair used the same guest, toolchain, system runtimes, CPU affinity, build configuration and input.

Four workloads compile and link the repository's real `tools/ci/qualification.c`, with the default dynamic PIE, `-static`, `-static-pie`, and `-no-pie`. The dynamic program's own self-test made 225,000,750 checks. The shared-library workload uses the existing direct linker on one generated function, including the ordinary `runtime_open_shared` cache path. The base baseline first ran the unmodified command suite and compiled the real input into an empty cache.

```sh
./build/compiler test-snapshot
cache=$(mktemp -d)
XDG_CACHE_HOME="$cache" ./build/compiler tools/ci/qualification.c -o "$cache/qualification"
"$cache/qualification" --self-test
XDG_CACHE_HOME="$cache" ./build/compiler tools/ci/qualification.c -o "$cache/qualification"
./build/compiler benchmark-link --only direct --kinds shared --functions 1 --runs 1 \
    --cpus "$allowed_cpu" --cache "$cache/buster" --directory "$cache"
```

For each script, start with a separate clean base checkout, run from its root, copy this directory's `snapshot-3046/` into it and set the hosted build environment above. Set `RUNNER_TEMP` to an empty writable directory. `bash path/to/compare.sh` reconstructs each candidate by applying `head.patch` followed by its variant patch and starts at the C driver or direct shared link. `bash path/to/first-comparison.sh` and `bash path/to/first-phase.sh` reproduce the original selective writer separately. `bash path/to/repeat.sh` repeats the prefault comparison on a fresh VM and injects `EINVAL` specifically into the writer’s writable-page advice. The hosted job definition is included in `hosted.yml`. The compile-time counter and timer transforms are confined to the harness.

## Byte accounting

Every logical write into the destination, including field stores, gets a byte mark. A successful image requires a mark for every output byte. `memset_bytes` counts explicit zero fills. `all_explicit_zero_bytes` also includes explicit zero scalar fields, sentinels and NUL terminators. A data-dependent value that happens to be zero counts as a field store. `memcpy_bytes` includes the header, immutable columns, strings, atom bytes and the final directory digest. `bytes_written_exactly_twice`, `bytes_written_three_or_more_times` and `bytes_cleared_and_copied` count distinct destination bytes. Kernel page initialization and cache-line traffic are outside these source-level counts.

The successful writer covers the serialized header, including the initial hash slot. Layout provides every region's start and size, so adjacent bounds give each gap, including the page gap before the directory. Of the 88 region kinds, 77 receive a whole-column copy when nonempty. The 11 exceptions are probes, libc versions, members, strings, piece hashes and piece data boundaries, the object and member name offsets, the object and member atom offsets, and the data payload. Fully copied columns preserve every source byte. Pointer-bearing records initialize the probe flags' padding, the libc version's trailing padding, and the unused archive-member fields. Loader and libgcc_s version records preserve the original copied padding when their name offsets are substituted. The first name and atom offsets remain zero. Nonempty string records write a terminator, and the final string cursor must equal the reserved extent. Contiguous validated pieces cover the atom payload between the two names runs. Every piece boundary, including the final boundary, and every piece hash is written. The writer publishes the complete directory digest last.

The tests serialize the same imported runtime over exact-size buffers initially filled with `0xa5` and `0x5a`. Each is compared with the complete raw file before any loader pointer rebasing. The cross-build witness uses the same real compiler-file identity, taken from `stat("/usr/bin/env")`, in **both counting binaries only**. The production format intentionally records the compiler's device, inode, size and timestamps. Holding these values constant lets the harness compare whole files, their SHA-256 digests, the directory hash and every piece hash. Independently built plain binaries ran the normal executable identity, reload, corruption and atomic replacement paths. A warm link must keep the snapshot's inode and timestamps and reproduce the linked ELF. Flipping its first byte must replace the damaged file with a byte-identical reconstruction.

## Timings

Cold means a missing buster cache in a fresh process on a running guest with warm OS file caches. Each phase comparison uses 128 base/head pairs per kind, balanced randomized order with a fixed seed, after four discarded pairs, on one allowed CPU. The image timer brackets `snapshot_image`; the publication timer starts before the write arena reservation and ends after file creation, close, rename and release. The follow-up experiment additionally samples process minor faults immediately around the image call. An independent run uses plain binaries for 40 alternating whole-command cold and warm pairs and eight alternating 15-iteration blocks of `benchmark-snapshot`. The shared whole-command measurement also includes its benchmark harness. Positive percentages mean lower elapsed time. Intervals are seeded percentile-bootstrap 95% intervals on paired median percentage changes.

The release binary links statically. The independent fallback witness applies a process-scoped syscall filter to just the writable-population advice, then records the return value with strace.

The first candidate removed the whole-image clear and performed the existing transfers in their existing order. The second preserved the format and moved the member-name suffix and later columns after the atom data. The third kept the first writer's order and asked the kernel to populate the owned writable image range before its first output store. None of the three changes the cache-hit path or code generation.
