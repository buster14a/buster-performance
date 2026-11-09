# Provenance and retained notices

The compiler source is Buster commit
`a20d741c37f176655aa120cafb085ae69421058a`, tree
`2b3ae9a71c09d6a7ea7ed803aa3f715664c825a0`. No compiler source changes were made
for the recorded build or validation. `source-files.sha256` was generated from
`git archive` of that commit and checked against the host's source files after
the build.

`helpers/identity-fixture-constant.inc` is an unmodified extraction of lines
1339–1367 of that revision's
[`src/buster/compiler/c_check_tier1_driver_test.c`](https://github.com/buster14a/buster/blob/a20d741c37f176655aa120cafb085ae69421058a/src/buster/compiler/c_check_tier1_driver_test.c#L1339).
The complete source file's SHA-256 is recorded in `identities.txt`. The extraction
can be recreated from that exact source with:

```sh
git show a20d741c37f176655aa120cafb085ae69421058a:src/buster/compiler/c_check_tier1_driver_test.c |
    sed -n '1339,1367p' > identity-fixture-constant.inc
```

`helpers/identity-extract.c` writes that constant verbatim to
`tier1-reproducible.c`, whose bytes and hash are retained here. The original
first-party Buster fixture's notices are retained in [SOURCE-NOTICE.txt](SOURCE-NOTICE.txt).
It uses **Apache-2.0 WITH LLVM-exception**. The new extraction/orchestration/GDB
helpers and report text are original contributions under those same project
terms; the full license and exception are in the repository's `LICENSE`.
No third-party implementation or fixture was imported. Clang, GDB, system
headers, libc and startup/linker files are external runtime/build tools or inputs,
not bundled material in this evidence directory.

The archived helpers are their executed versions. Their recorded validation uses
the original fixture's options, 12 functions, two host paths, and both
rematerialization settings. The only additional C probe is the extractor's
`BUSTER_HOST_VECTOR` print. The debugger uses symbol breakpoints on the unmodified
release executable. Neither substitutes a patched or instrumented binary.

## Receipt treatment

Most receipts are unmodified. Three receipts have these presentation-only
changes; their unsanitized SHA-256 digests are recorded below:

- `receipts/build.log`: omitted its initial four lines about an unrelated CI
  job holding the queue; replaced the absolute task-owned home path with
  `<work>`. Build output and outcome remain.
- `receipts/identity.log`: shortened `uname`'s kernel build metadata to retain
  host, release and architecture. All validation lines are unchanged.
- `receipts/trace.log`: removed debugger thread-creation/exit chatter and the
  host library-loader path; omitted the process number in the normal-exit
  line. The actual breakpoint hit, code addresses, call stack, Tier 1 report
  and normal-exit outcome remain.

```text
2f2aeb17adc86ee404350f3c9aff3a356d23c21939d92dfa223a82727c1e6fe8  original build.log
5998c1225e9b82e683721b121f855852b0233d8d19485538aef299b459ddce58  original identity.log
5b2c363d4fc947791de7556d0fa05995687235debaa7dc59d5c672be32ebf2f6  original trace.log
```

The unsanitized originals remain in the task-owned work area on `benchpress`;
this public evidence contains only the declared sanitized versions. No compiler
binary, oracle executable, generated program or object is included. Their hashes
record identities without distributing toolchain or runtime code. Source archive
and source-file hashes are reproducible from the named public commit.
