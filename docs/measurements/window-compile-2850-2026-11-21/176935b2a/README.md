# Source-verified lexical handles across the preprocessing checkpoint

The final resolver verifies the source ordering of every prior declaration and scope restoration against records retained during preprocessing. An admitted use can then append its original lexical handle directly. The ordinary per-use name-head lookup is omitted. The final declared type still comes from the live final translation unit. All normal binding events and subsequent ordinary consumers remain active.

| Frozen source at checkpoint 24 | Prior events checked | Scope actions checked | Names and final answers reused | Retained bytes |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 93,906 | 44,064 | 40,058 | 2,024,248 |
| Buster | 109,756 | 63,572 | 12,743 | 1,834,552 |

Corrupting the first retained declaration caused both full inputs to decline every fast use and emit the ordinary ELF. Across 16 source/checkpoint pairs the ordinary objects and diagnostics matched. The native GDB oracle observed all eight columns and the final scope heads, active stack, source targets and type IDs. SQLite produced 4,666,856 bytes of binding state and 5,729,092 bytes of final answers. Buster produced 10,281,578 and 19,468,508 bytes respectively. Every byte matched public ordinary, the connected parent and the candidate.

Both this experiment and [the per-use predecessor](../979ea1232/README.md) ran 140 directed source/policy comparisons and another 140 with active preprocessor checkpoints forced by directives. On the latter cases, 70 captured rows and 62 consumed a total of 461,628 uses and the same number of final answers. All matched the connected parent. In three cases that parent differed from ordinary on late symbol renaming. The sibling correction recovers ordinary spelling and binding for a late pragma on already used externals and fixes a weak alias that previously reached a backend error.

Against the same executable in capture-only mode, SQLite median paired elapsed fell 3.136 ms in 10 of 18 rounds. User instructions increased by 2.892 million in all 12 rounds and median user cycles increased by 48.49 million. Buster median wall time rose 23.622 ms across six rounds and user instructions rose by 9.645 million. These are local 7940HS Develop builds. The experiment establishes source ownership of the selected lookups. The measured work excludes it from the target benchmark queue.

The [complete source, raw comparisons, captured event columns and reproduction scripts](live-binding-sources.tar.xz) have SHA-256 `0126f5cd766adb28c5d7e3d01d6f1b06528ce8e7105dd294752b269e4daa9526`. The [five exact compiler revisions and executable SHA-256 values](builds.tsv) identify the ordinary, experimental and repaired compilers.
