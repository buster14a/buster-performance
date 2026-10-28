# Include-directory negative lookup cache (#653)

The compiler changes are local only, on `codex/perf-653` at
`4b3a4f50f81dd4ad840a2183680e6b30fe55e222` (use the full identity in `identity.txt`). No PR or push
was made. Baseline is `bc1b486150850fe00bad1361a19f57d67706bb3b`.

The optional cache stores entry-name hashes for explicit/standard include
search directories. An absent first component eliminates a file probe;
collisions only retain a probe. Every existing component, symlink, dot/dot-dot,
overlong component, failed listing and unsupported/casefold filesystem keeps
the original probe semantics. Names are a snapshot for the FileCache lifetime;
a fresh cache sees new files. A first quoted-header hit beside the source pays
no listing. File-lane listings run on lane 0 inside the measured walk, before
other lanes probe includes.

`directory_check.c` is an original focused ASan/UBSan adapter, built against
the compiler sources. It checks 512 known present/missing names, optional-arena
capacities from 8 to 16384 bytes, and a path ending immediately before a
PROT_NONE page. No external implementation or fixture was incorporated.

Local validation uses the Ryzen 9 7940HS laptop, Clang 23.1.4, an optimized
native build without debug info. These are correctness/syscall screens, not
9700X timing claims. The first build/logs (`build.txt`, `preprocessor.txt`,
`*-head-syscalls.txt`) predate final review changes and remain explicitly
intermediate. Use `final-*` logs and objects for final-head results.

Inputs are external runtime corpora:

- zlib 1.3.1, downloaded from https://zlib.net/fossils/zlib-1.3.1.tar.gz;
  archive SHA256 `9a93b2b7dfdac77ceba5a558a580e74667dd6fede4585b91eefb60f03b72df23`.
  The original archive/source under `inputs/` is not a compiler import.
- Frozen SQLite 3.53.2, SHA256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

The syscall cohort invokes each compiler with `--lanes 1 -c INPUT -o OBJECT`
under `strace -f -c -e trace=openat,newfstatat,getdents64,faccessat2,fstatfs,ioctl`.
It includes directory-listing and filesystem-qualification costs rather than
reporting only the saved opens. Compare `zlib-base-syscalls.txt` with
`final-zlib-syscalls.txt`, `base-uncompr-syscalls.txt` with
`final-uncompr-syscalls.txt`, and `sqlite-base-syscalls.txt` with
`final-sqlite-syscalls.txt`. Syscall tracer times are not wall-time benchmarks.

Final correctness commands are `test-preprocessor --clang` (including 3000
C17/C23 fuzz cases), `test-files --lanes 1,2`, `build.sh check-call-graph`, and
the focused sanitizer adapter. Parent session coordinates locked 9700X runs
and the integrated compiler checks separately.

## Final local result

All final validation commands exited 0. Preprocessor: 377 built-in cases,
176 header/mode sets and 3000 C17/C23 fuzz oracle cases pass, including exact
scalar/vector output comparisons. File lanes 1/2 pass their identity/order,
shared-cache, include-next, alias, special-path and 48 memory-failure runs.
The call graph has zero disallowed cycles and zero split variables. The
ASan/UBSan adapter passes 3585 checks. The temporary filesystem cannot enable
casefold, so the actual +F fixture is explicitly unavailable locally; the
production flags check rejects casefold before accepting a listing.

| Input | Baseline openat calls/errors | Final openat calls/errors | Selected syscall total before/after |
|---|---:|---:|---:|
| zlib deflate.c | 205 / 123 | 99 / 13 | 220 / 135 |
| zlib uncompr.c | 170 / 101 | 86 / 13 | 185 / 122 |
| frozen SQLite | 499 / 323 | 193 / 13 | 514 / 229 |

For each input the final cohort adds 9 getdents64, 4 fstatfs, 4 faccessat2 and
4 ioctl calls. The selected trace omits fstat/close and is not an all-syscall
count. All three final objects are byte-identical to baseline; hashes are in
`object-hashes.txt`. No whole-compile speedup is inferred from strace times.
