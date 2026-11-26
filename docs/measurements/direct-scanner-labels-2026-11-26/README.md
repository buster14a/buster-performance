# Compiling generated scanners through Buster's direct path

Buster's ordinary single-file `-c` invocation previously tried the direct compiler and then fell back when a function reached 513 named labels. The change indexes labels by interned identifier and stores the known code offset of each switch case. The re2c Unicode-name recognizer has 1,861 named labels. Compiling it took 85.11% fewer user-space x86-64 instructions once the direct compiler could finish it.

| C input | Baseline route | Changed route | Baseline instructions | Changed instructions | Reduction |
| --- | --- | --- | ---: | ---: | ---: |
| re2c 4.3 UTF-8 name recognizer | Full | Direct | 91,662,305 | 13,644,512 | 85.11% |
| cmark 0.31.1 `src/scanners.c` | Direct | Direct | 16,545,056 | 16,000,136 | 3.29% |
| re2c 4.3 byte-switch regression `bug2102138.c` | Direct | Direct | 4,479,551 | 4,142,546 | 7.52% |
| One arithmetic function | Direct | Direct | 610,574 | 610,492 | 0.01% |

Each number is the median of five whole compiler processes. Each pair alternated which revision ran first. DynamoRIO's `inscount` client counted dynamically executed user-space instructions, including driver startup and the baseline's direct attempt before fallback. Kernel execution and elapsed time are outside this measurement. Both binaries were Release builds with the default native target, Clang 23.1.4 and debug information disabled on an AMD EPYC 9V74. [Raw counts and observed routes](instructions.tsv)

The script checked the ELF `.comment` and compared every instrumented output to its ordinary compiler output. The byte-switch, cmark and one-function objects were identical across revisions. The Unicode scanner's C function is copied verbatim up to the upstream C++ test data. The changed compiler with `--no-direct` produced exactly the baseline object. Both objects passed all 808 upstream names, prefix checks against Clang, and 808 suffixed negatives. The changed cmark object linked with the rest of the Clang-built program and passed all 652 CommonMark specification examples. [re2c scanner and test data](https://github.com/skvadrik/re2c/blob/ffdc69dc2eee74404109f916721491b9dc5a2948/test/encodings/utf8_names.c) · [cmark scanner](https://github.com/commonmark/cmark/blob/bb3678d7a73cb02d35c8876ecd097072636200a8/src/scanners.c)

## Reproduce

Build the two compiler revisions in separate checkouts using `BUSTER_DEBUG_INFO=0 ./build.sh --config Release --jobs 4`. Use the pinned Clang and Clang++ on PATH, with CMake, Ninja, Python 3 and GNU readelf available. Unpack the x86-64 Linux DynamoRIO release identified below. The last argument to the script names a new directory for its objects, individual client logs and TSV. [Baseline compiler](https://github.com/buster14a/buster/commit/44cf35e195eb73e7306f13882ef15b2d9b301c4d) · [Changed compiler](https://github.com/buster14a/buster/commit/b9fdf917a6537409bd66b4aa8562af456b1f1c71) · [DynamoRIO cronbuild 11.92.20777](https://github.com/DynamoRIO/dynamorio/releases/tag/cronbuild-11.92.20777) · [Measurement script](measure.sh)

```sh
git clone --quiet --depth 1 --branch 4.3 https://github.com/skvadrik/re2c.git re2c
git clone --quiet --depth 1 --branch 0.31.1 https://github.com/commonmark/cmark.git cmark
bash measure.sh /path/to/base/build/compiler /path/to/change/build/compiler \
    re2c cmark /path/to/DynamoRIO-Linux-11.92.20777 results
```
