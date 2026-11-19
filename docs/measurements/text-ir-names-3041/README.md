# Textual IR import spelling checks

Buster's `interpret-ir --print` imports a saved IR file, verifies each function and prints it. These counts cover calls to its private `ir_parse_named` lookup. C lowering supplied the real input. The measurement applies to importing textual IR in tooling. [Buster issue #3041](https://github.com/buster14a/buster/issues/3041)

| Input | Bytes | Named tokens | Base candidates | Head candidates | Base per token | Head per token |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 36 canonical fixtures, 48 functions | 24,209 | 1,692 | 66,615 | 6,781 | 39.37 | 4.01 |
| Lowered `test_deal_makespan` | 17,457 | 1,085 | 45,094 | 5,558 | 41.56 | 5.12 |

A candidate is an enum entry whose spelling the lookup examines. Base takes the length of every candidate and calls `memcmp` on lengths that match. Head filters the large spelling tables in groups of up to 64 byte lengths and compares only the selected strings. Its small vocabularies compare bounded prefixes and require a terminating NUL at the end of a match. Both implementations return the highest matching enum index. The counts are source-level operations.

| Input | Base `memcmp` | Head `memcmp` | Head `strncmp` | Head vector length comparisons | Active length lanes |
| --- | ---: | ---: | ---: | ---: | ---: |
| Canonical fixtures | 12,031 | 6,347 | 434 | 2,223 | 64,731 |
| Lowered `test_deal_makespan` | 10,241 | 5,170 | 388 | 1,536 | 44,614 |

The clean Release executable contains one length column each for types (18 bytes), opcodes (70) and intrinsics (43). `nm -S` reports **131 read-only symbol bytes** in total. Each column comes from the same string literals as its printer table. The importer allocates no scratch for the lookup. The separate vector-lane type spelling scan in `ir_parse_lane_type` is outside these counts.

## Reproduction

Use a disposable checkout of `buster14a/buster` on an ordinary AVX-512 Linux VM. Check out `6427879e1143026a12fb0388a20bdea1fe4b2bc5`, put this record in a separate directory, and run `bash /path/to/record/run.sh` from the compiler checkout. The script fetches head `7dafd2f7d2e9fc35b9194e2b7c3e81f261ed399e`, builds both revisions with the pinned tooling and applies the temporary C counters only to the measurement builds. The script finishes with a clean head build.

The recorded comparison ran both revisions on one GitHub-hosted Ubuntu 26.04 VM with an Intel Xeon 6973P-C. It used Clang 23.1.4, CMake 4.4.3, Ninja 1.13.2, vector Release, debug info off, sanitizer `none` and linker `auto`. It compared the complete NUL-delimited compile flag streams byte for byte. [Hosted comparison](https://github.com/buster14a/buster-performance/actions/runs/44603630304/job/135841947155) · [Initial baseline](https://github.com/buster14a/buster-performance/actions/runs/44601668032/job/135834402109)

`run.sh` concatenates the existing parser fixture list in order. It also uses `test-ir-source --print test_deal_makespan` on a translation unit including Buster’s production shard scheduling header, saves the 562-line as-lowered function and imports those bytes. Both emitters produced the same IR. Each input survived two successive parse/print rounds byte for byte on both revisions.

`test-ir-parse` passed 6,552 checks on base and 6,725 on head, including another pass on the clean head binary. The comparison checked exit status, stdout and the entire diagnostic on 14 malformed inputs. They include an empty token at EOF, a truncated `call_indirect`, unknown suffixes, a 259-byte token and two verifier errors. The parser regressions also check the rejected byte offset, line and column. [Recorded output](results.txt)

---
Agent session: 6aff4fd8-b780-8191-b5fb-518f4493b048 (OpenAI Codex session ID; no share URL is exposed)
Model: OpenAI / GPT-6 (Codex)
