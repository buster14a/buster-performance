# Static-selection checking on the Ryzen 7 9700X

The November 23 run on main at `4704727a1` found that increasing the number of functions from 1,000 to 16,000 increased median `check-program` time from 0.582 to 10.513 ms. The checker took 1.652 s wall time to compile the regenerated historical source, including 361 ms in `check-program`. [Buster issue #1341](https://github.com/buster14a/buster/issues/1341)

The historical input came from Buster source `9e7f918f3`, preprocessed by `4704727a1`. Its SHA-256 is `9c0a4c3f35c1024255cb3b910eb83eed01620c2271b471635620fc51c43af8c7` and its size is 36,138,597 bytes. The original November 4 record used a 36,149,566-byte file. A text search of the regenerated file finds 389 occurrences of `_Generic`; a Clang token dump finds zero `_Generic` keywords. Test-source strings account for many of the text matches. The unit contains `__extension__`, which Buster also represents as a selection. Each generated function has one actual `_Generic`. [Original input and timings](../microarchitecture-two-hosts-2026-11-04/README.md)

## November 23 measurements across the merge

The previous issue claimant collected these runs on benchpress. I recovered the original logs and checked all 123 for a complete stage table and diagnostics. The 33 self-compile logs also record successful process exit codes. The 90 generated-unit logs contain stage output but the older driver did not save individual exit codes for them. Its generator produced byte-identical files to `uarch generate-generic` at all five sizes. [Claim and scope](https://github.com/buster14a/buster/issues/1341#issuecomment-7087790113)

| Buster revision | Historical source, wall ms | Historical source, check-program ms | November 22 source, wall ms | November 22 source, check-program ms |
| --- | ---: | ---: | ---: | ---: |
| `437ccbbc3`, first parent of the #2669 merge | 1,725.1 | 401.7 | 564.3 | 100.8 |
| `ad415ef91`, #2669 merged | 1,720.4 | 403.6 | 563.3 | 100.0 |
| `4704727a1`, November 22 main | 1,652.1 | 360.7 | 513.2 | 63.4 |

Wall and stage times are medians of five rotated rounds on the historical source and six on the November 22 source. On the historical source the last round included a 4.25 s merge-revision outlier. Every observation is included in the medians. The two inputs have different sizes and separate rows in the raw table.

| Functions | Before #2669, ms | #2669 merged, ms | November 22 main, ms |
| ---: | ---: | ---: | ---: |
| 1,000 | 0.738 | 0.724 | 0.582 |
| 2,000 | 1.365 | 1.358 | 1.145 |
| 4,000 | 2.917 | 2.881 | 2.656 |
| 8,000 | 6.156 | 5.746 | 5.112 |
| 16,000 | 12.545 | 11.758 | 10.513 |

These are median `check-program` times across six rounds. The flat generated workload already scaled approximately linearly before #2669. That PR covered nested selections and chosen-arm diagnostics. [#1516](https://github.com/buster14a/buster/pull/1516) · [#2669](https://github.com/buster14a/buster/pull/2669)

The archived builds used Clang 23.1.4 and `./build.sh --config Release` on benchpress. The claimant’s scripts record the preprocessing, compilation flags, CPU 2 affinity, build rotation and lock scope. The archive contains its original stage logs, scripts, build and round logs, plus a newly verified manifest of revision, executable and input identities. Wait messages identifying other lock holders are omitted. Empty fields in the table denote values the driver did not record. [All observations](runs.tsv) · [November 23 evidence](nov23.tar.gz)
