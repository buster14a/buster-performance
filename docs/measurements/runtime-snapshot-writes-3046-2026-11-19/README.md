# Runtime snapshot creation on a cold compiler cache

The published candidate is `8d14623f71f3198be0be4291275f2c32158fa5c0` in buster14a/buster. It explicitly initializes alignment gaps, reserved fields, padding and sentinels, lets the complete writes initialize their destinations, and requests writable population of the owned mapping. This record covers compiler/linker cache creation through the normal runtime-open paths.

## Hosted results

An Intel Xeon Platinum 8370C ran all five runtime kinds. Cold publication includes reservation, image creation, file writing, close, rename and arena release. The table gives the median paired reduction in elapsed time over 128 pairs per kind. The uninstrumented command column compares 40 pairs. The shared workload is a direct link of one generated function. Four executable workloads use the real C qualification program.

| Runtime | Image time saved | Cold publication time saved (95% interval) | Full cold command time saved (95% interval) |
|---|---:|---:|---:|
| Dynamic PIE | 24.77% | 15.45% (12.94% to 19.61%) | −2.52% (−7.28% to 4.85%) |
| Static | 22.07% | 14.04% (13.13% to 14.55%) | 4.03% (2.41% to 5.38%) |
| Static PIE | 22.88% | 14.23% (13.67% to 14.86%) | 5.42% (2.67% to 8.59%) |
| Non-PIE | 24.85% | 15.41% (11.96% to 18.93%) | 0.71% (−4.01% to 3.26%) |
| Shared | 24.37% | 15.33% (13.47% to 16.98%) | −0.13% (−1.00% to 0.89%) |

The independent uninstrumented `benchmark-snapshot` on this Xeon recorded 11.97% to 15.88% less `snapshot_write` time. The process's median reported minor faults were 800 for both dynamic runs and 2,118 for both static runs. The improvement concerns the cost of preparing and filling those pages. The direct shared benchmark additionally made two, differently sized writable-population calls from outside the snapshot writer.

An independent Intel Xeon 6973P-C run measured 16.80% to 21.53% less cold publication time and 27.79% to 34.54% less image-building time. Forcing the snapshot’s writable-page advice to return EINVAL produced identical complete snapshots and linked ELFs for all five kinds. The forced-error suite passed all 7,435 checks. The second guest’s static and static-PIE images were each 304 bytes larger than the first guest’s. Each comparison uses both binaries or both syscall outcomes on the same guest.

The original selective writer by itself took 3.07% to 9.21% longer in the image builder on a hosted EPYC 9V74. A separate control changed the write order on the Xeon. Its result and the complete sample vectors are recorded below.

## Output bytes

| Runtime | File bytes | Explicit bytes cleared, base → head | Bytes copied by memcpy, both | Distinct bytes written exactly twice, base → head |
|---|---:|---:|---:|---:|
| Dynamic PIE | 3,269,108 | 3,269,513 → 11,057 | 3,218,217 | 3,257,911 → 200 |
| Static | 8,668,104 | 8,670,670 → 66,152 | 8,227,617 | 8,604,502 → 16 |
| Static PIE | 8,667,368 | 8,669,933 → 66,053 | 8,227,079 | 8,603,864 → 16 |
| Non-PIE | 3,269,216 | 3,269,622 → 11,091 | 3,218,232 | 3,257,986 → 200 |
| Shared | 3,267,140 | 3,267,542 → 11,161 | 3,216,316 | 3,255,836 → 200 |

The byte census found zero untouched output bytes, zero bytes both explicitly cleared and subsequently copied by the head, and zero bytes written three or more times on the head. The remaining 16 bytes are the final directory digest, and dynamic variants have 184 additional version-name pointer bytes replaced with offsets. The base wrote 545 bytes at least three times on the dynamic, non-PIE and shared inputs, and 16 on both static inputs. These are logical destination writes, excluding kernel page preparation. All five raw images, their SHA-256 values, directory and piece hashes, and all five linked ELFs matched their base control. The instrumented format comparison held the two compiler file identities equal. Warm links bypassed the writer and kept the existing image. All 7,435 head checks in `test-snapshot` passed, including exact-capacity poison buffers, short storage, incomplete strings, reloads, corruption, staleness and concurrent publishers.

## Reproduction and receipts

- [Method, builds, normal entry points and byte coverage](method.md)
- [Full baseline on current-at-start main](baseline-run.txt)
- [Initial byte and output comparison](first-comparison-run.txt) and [initial phase timings](first-phase-run.txt)
- [Two alternatives, plain binaries, byte counters, file hashes and complete raw samples](experiments-run.txt)
- [Independent repeat and forced syscall failure](independent-run.txt)
- [Verified write counts](verified-writes.tsv), [image and hash receipts](verified-images.tsv), [timings](experiment-timings.tsv) and [minor faults](experiment-faults.tsv)
- [Base correctness job](https://github.com/buster14a/buster/actions/runs/44601214871/job/135833399005), [full first candidate](https://github.com/buster14a/buster/actions/runs/44603586076/job/135842185592), [first phase comparison](https://github.com/buster14a/buster/actions/runs/44604724821/job/135845249125), [Xeon comparison and final verification](https://github.com/buster14a/buster/actions/runs/44607417970/job/135854714108) and [independent repeat](https://github.com/buster14a/buster/actions/runs/44611895224/job/135870395598)

The first partial run used a C driver form that cannot create a shared runtime snapshot. The complete campaigns use the direct shared-link caller. The syscall failure control filters on both the advice and the snapshot length and checks the result with strace. The Release compiler is statically linked, so libc interposition could not establish this control.

Agent session `6aff501b-b5f8-8191-bba4-6a2f7ed0a050`, OpenAI / GPT-6 (Codex).
