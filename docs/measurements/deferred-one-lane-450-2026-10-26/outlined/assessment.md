# #450: exact native e2de code-generation assessment

The `31c4ced2`/`e2de00e9` run is a negative performance result despite its
correctness passes. Source-order normalization does not establish acceptance.
Its raw 548-process record and identities remain unchanged.

Read-only analysis used the exact native images with SHA-256
`2a30c27d0d94cd692a8559ef47f400458021e11f02f32d8848b46254f84ce218`
and `e899c199ed90a57822aea6d4ce7fb4e315829738ba5de88fbe9c0a5918fc3911`.
Neither native image was executed on the local desktop.

The common reader's base/head instruction streams have 17,636/17,642
instructions after removing addresses and comments. The address-neutralized
diff is in `common-normalized.diff`. It contains the deferred-only branch
and block rearrangement, a padding NOP change, and a cold assertion-string
address. It shows no added source-order work, changed stack slots or changed
spills outside that deferred code. This comparison strips placement; it does
not prove that changed placement is free.

The source-order call supplies a null deferred pointer. Its relevant skip is:

| Image | Test/branch | Landing block |
| --- | --- | --- |
| Base | `108996f: test %rdx,%rdx`; `1089972: je 108b251` | `check_input_run+0xb041` |
| e2de | `1089a2f: test %rdx,%rdx`; `1089a32: je 108b329` | `check_input_run+0xb059` |

The landing blocks have the same loads, comparisons and stack offsets.
Their relative positions differ by 24 bytes, beyond the function's overall
192-byte movement. Thus source-order instruction placement changed even
though it skips the changed deferred dispatch. No added dynamic source-order
instruction cost has been identified from this static comparison.

Other observed layout changes:

- `.text` starts 192 bytes later and grows by `0x470` bytes.
- `.data.rel.ro` moves by `0x530` bytes, changing its position modulo a cache
  line by 48 bytes; its size is unchanged.
- `.bss` moves by `0x500` bytes; its size is unchanged. The benchmark's
  identifiers, preprocessor, parser and timing arrays all move by that amount.
  Their cache-line alignment is preserved, while page offsets/cache indices
  change.
- The TLS section size (`0xaa0`) and thread-context sizes/offsets (`0x88`
  each) are unchanged. The added corpus-test CPU pointer is ordinary BSS,
  not a new TLS field.

These observations do not identify one cache or branch-predictor mechanism
as the cause of the measured regression. No alignment padding, layout seed
or threshold adjustment is proposed.

## One bounded diagnostic: outline the existing deferred-only phase

Revision `d4db297d122fc4be18c4cf245dd1462439d884d0`, parent `e2de00e9`,
marks the existing `check_deferred_bodies` definition `noinline`, places the
identical one-lane context operations directly inside it, and removes the
separate one-lane helper. It changes one C file, eight additions and fourteen
deletions relative to e2de. The existing semantic boundary gets one explicit
call on deferred readings; source-order readings skip it. There is no new
API, per-token scan, arena allocation or changed timing boundary.

The exact-source local optimized checker object compiled with production
flags through the shared core allocator:

| Item | e2de object | Outlined diagnostic object |
| --- | ---: | ---: |
| Common reader code | `0x13b02` (80,642 bytes) | `0xc2dc` (49,884 bytes) |
| Common reader stack allocation | `0x808` | `0x6c8` (320 bytes smaller) |
| Separate deferred phase | Inlined | `0x79a6` code, `0x2c8` stack |
| Separate one-lane helper | `0x59` code | Removed |
| Lane callback code | `0x65db` | `0x65db` |

The reduction is in the common reader's footprint, not a claim of smaller
total text: common reader plus phase totals 81,026 bytes, compared with
80,731 bytes for e2de's common reader plus helper. Deferred-path stack usage
also includes the new phase's frame. The full reader timing must include
those costs before this candidate can be accepted.

Archive: `.git/450-outlined-phase.tar`, SHA-256
`f1947c4b17666505cb169c3968c306b765413caff59635c8edf2921c516df71e`.
The original helper branch remains at e2de. Native measurement is reserved
for the coordinator after B's current FIFO campaign; no performance
acceptance is claimed here.
