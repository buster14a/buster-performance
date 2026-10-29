# Provenance and retention

The compiler modules and permanent tests belong to Buster source commit
`e175decaf684ff1812673faf424424b7cbafe659`, tree
`4d80f373e0878405798657b474788fbb8adbb3b0`. They are not copied wholesale
into this evidence record. The pinned compiler tree supplies their existing
licenses, component notices and dependencies.

`adapter/reduce-tests.c` is the original takeover session's C wrapper,
recovered byte-for-byte from `work/733-qualification/reduce-tests.c`.
`adapter/oracle-prefix.h` is the recovered earlier ownership-audit unity
prefix, copied into that qualification folder before building. Its exact
artifact hash is retained; the prefix is not claimed to have been generated
from `e175deca` during this run. The included actual compiler modules come
from the independently compared frozen `e175deca` source copy. This focused
linkage adapter is distinct from the compiler's real multi-unit build.

The wrapper, prefix and synthetic IR fixtures are original project/task
material under Apache-2.0 WITH LLVM-exception. The prefix retains its existing
David Gonzalez Martin copyright and SPDX notice. Its references to separately
included compiler components do not relicense those components. The retained
reports and metadata use the project-default terms, with repository LICENSE
and LICENSES retaining the complete applicable texts.

`bundle-moved/` contains original generated canonical IR, JSON records and
recipes from the completed built-in compiler-fixture reduction. No external
program, implementation, corpus or package is incorporated. Clang, its
resource headers, the system headers and sanitizer runtime remain external
dependencies. The large compiled adapters are omitted, with their actual
executed SHA-256 identities retained.

Original source/artifact manifests are copied unchanged. Published run logs
filter only `cores:` scheduler records. Original complete log hashes remain
in `identity/original-logs.sha256`; build and syntax logs represented there
contain scheduler records without Clang diagnostics. Installed host/tool
identity was captured after the checks for publication, rather than being a
new build-time tool attestation.

No compiler source change, build, test, replay or timing campaign was added
while publishing this packet. No human DCO trailer is inferred from the
compiler repository's separate standing authorization.
