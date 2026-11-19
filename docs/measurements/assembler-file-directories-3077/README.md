# Numbered `.file` directory lookups

Buster base `3741c264fb349e86359acfd1c732ee1c2eaa4052`, head `4cd28ea7c69cba3dec5a4f7ec82926f40f76113b`. Each measurement runs the shipped `compiler assemble -o object.o input.s` command. [Buster issue 3077](https://github.com/buster14a/buster/issues/3077)

## Deterministic work

A full comparison is a call to `memcmp` between equal-length directory spellings during lookup. Candidate counts also include comparisons that stop at the length check. Bucket probes include occupied and vacant buckets during lookup, insertion and rehash. The input size includes file zero. Every numbered file in the mixed workload has an MD5. It introduces a new directory every fourth file and interleaves reuse of 17 spellings with slash and split-name aliases.

| Directives | Directories | Base full comparisons | Head full comparisons | Head hashes | Head bucket probes | Index bytes cleared, cumulative |
|---:|---|---:|---:|---:|---:|---:|
| 1,024 | Repeated | 2,045 | 2,045 | 0 | 0 | 0 |
| 2,048 | Repeated | 4,093 | 4,093 | 0 | 0 | 0 |
| 1,024 | Distinct | 523,776 | 1,865 | 2,031 | 3,017 | 16,256 |
| 2,048 | Distinct | 2,096,128 | 3,799 | 4,079 | 6,124 | 32,640 |
| 1,024 | Mixed | 46,063 | 2,045 | 1,510 | 1,810 | 8,064 |
| 2,048 | Mixed | 157,794 | 4,085 | 3,046 | 3,684 | 16,256 |

With slot zero and seven positive directories, both builds make 28 full comparisons. Adding the eighth positive directory still costs 36 cumulative comparisons in both builds. Head then clears 128 bytes, hashes eight spellings and probes 11 buckets to build its first index. Twelve spellings with the same initial bucket deliberately exercise linear probing through the end of the table. Each build makes 168 full comparisons on that control. GCC and Clang assembly for `examples/assembler/program-storage.c` remain in the small-table path, with two and one full comparisons respectively.

Each first assignment of a numbered file can append one directory, with one extra entry for slot zero. The positive slots are append-only. The index occupies spare space in the existing directory reservation and grows with the positive directory count. The live check of slot zero preserves precedence after a late fill. On this host `sizeof(AsmParser)` grows from 1,000 to 1,008 bytes. The assembler reports identical retained arena bytes for all 34 successful inputs. The measurements cover deterministic work and storage.

## Object and diagnostic checks

All four binaries produced identical complete Buster objects for the 34 successes. Each of the nine failures returned the same status, stdout, first diagnostic bytes and location, and left a pre-existing output file intact. The 43 inputs cover DWARF 3 and 5, empty file and directory slots, hidden writes before slot zero is published, one and multiple trailing slashes, duplicate spellings, growth boundaries, probe wraparound, MD5 reassignment and competing errors. The two local runs of `test-assembler` passed 1,964,718 and 1,964,720 checks respectively.

GNU binutils 2.47 agreed on 30 emitted line tables and on the no-line-table control. The comparisons cover raw `.debug_line` and `.debug_line_str`, `.text`, line relocation offset/type/target/addend, and both raw and decoded `readelf` output. Complete ELF files from the two assemblers differed on all 32 inputs both accepted. Eight invalid inputs were rejected by both. Four cases record existing differences between Buster and GNU as.

- GNU as retains an early directory called `hidden` and rejects both later assignments in `fill-explicit` and `fill-implicit`. Buster's original count is zero at the first write, and both Buster builds accept the later assignments.
- On `late-fill-implicit`, GNU as records `d07//` in directory zero. Both Buster builds record `d07/`.
- GNU as supplies the working directory for `.file 0 "sub/main.c"`. Both Buster builds issue the original missing-directory diagnostic.

## Reproduce

Use a verified non-9700X Linux x86-64 host with the ISA required by `host_isa.h`. The run recorded here used a Ryzen 9 7940HS, the project's Clang 23.1.4 Debug configuration with native ISA and sanitizers off, GCC 16.2.1, system Clang 23.1.5, and GNU binutils 2.47. The local incremental link reused the clean base build and rebuilt both Debug translation units containing the assembler parser (`main_unit_assembler.c` and `main_unit_checker.c`). Both clean and counted products ran the normal executable's command dispatch. The replay does fresh project builds. Each counting patch applies only to its disposable checkout.

Start in this directory. These commands use fresh paths under `/tmp` for the checkout and results.

```sh
packet=$PWD
git clone https://github.com/buster14a/buster.git /tmp/buster-file-directory-src
git -C /tmp/buster-file-directory-src fetch origin codex/asm-line-directory-index
bash "$packet/replay.sh" /tmp/buster-file-directory-src /tmp/buster-file-directory-replay
```

The output directory must be new. The four-way object comparisons, both readers, the GNU oracle and the work counters run in `compare.sh`. The results include `counts.tsv`, `comparisons.tsv`, object digests and reader dumps. Both GCC-compiled and Clang-compiled versions of the real program depend on the installed toolchain and headers.

From the Buster checkout, the included `late-fill-explicit.s` is a complete input. File 19 refers to directory 8 before a late fill gives directory zero the same spelling. File 20 then refers to directory zero. With a built compiler, inspect both assemblers with these commands.

```sh
./build/compiler assemble -o buster.o "$packet/late-fill-explicit.s"
as --64 --gdwarf-5 --nocompress-debug-sections -o gnu.o "$packet/late-fill-explicit.s"
readelf -W --debug-dump=rawline buster.o > buster.raw
readelf -W --debug-dump=rawline gnu.o > gnu.raw
cmp buster.raw gnu.raw
```

