# Draft publication receipt for #665

- Draft PR: https://github.com/buster14a/buster/pull/714
- Head: `25783a29a42e0bafebd5e09a6b934ff02f4c0607`.
- Pinned source base: `12db4a0edd13a4ee319aa04467b910f3151a9290`, including #678.
- Branch: `codex/665-builtin-scratch`.
- Only the five intended #665 files from frozen `a207fcd7` were ported.
  Native/scalar copy guards and the existing run-native test gates were retained.
  No combined4349 branch contents were imported. Independent read-only scope,
  lifetime and guard review found no concrete blocker.
- Release build: 41 units, 126.8 s with two allocated cores, Clang23.1.4,
  BUSTER_DEBUG_INFO=0 and usual -O3/-march=native flags. Local compiler SHA256:
  `69a3a92526b28c783051210748baa6ce6a3aced3f173e7ec39d02a118fdb90c5`.
- Builtin lowering: 970287/0; full checker:465960/0; driver:21648/0.
- Scalar-host syntax passes; focused generic scalar-host source adapter under
  ASan/UBSan:89/0 (`generic-source.log`).
- Many-body one/two-lane/scalar runtime and byte controls pass.
- Both publication-head add8000/popcount4000 source controls pass against
  Clang on143 inputs, with scalar/vector object equality. Their frame
  reservations are64008bytes/0bytes, independently replayed on this head.
  Clang-O0 controls reserve31880bytes/0bytes. Actual source/prologue/runtime
  receipts are in their named subdirectories.

The draft was authorized with explicit native665 qualification pending because
the shared target queue was preventing hardware progress. The PR body contains
no unrun target timing or nonexistent evidence link; it keeps current-head
validation separate from the frozen241→a207 experiment. It is not a statement
of native or throughput qualification.

The plain frozen source ref `codex/665-frozen-native-candidate` was pushed at
`a207fcd7e742c517f0d5bac6ff1bd5ac2772c360`. It is a candidate ref, not a
qualification ref. Both pushes were ordinary atomic new-ref pushes, without
force. Repository identity1421805693 was verified via the GitHub connector.
The PR was immediately attached through attach_artifact. A single later read
confirmed open/draft/mergeable against base5d5eacb8; initial creation's false
mergeable field was an asynchronous placeholder. No merge or issue comment
was made by this agent.
