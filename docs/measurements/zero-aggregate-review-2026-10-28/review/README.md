# Independent review of PR627's direct nonzero path

Source snapshot: Buster `cba8b5aea85b32b0395c59cd15ad21e0f88b4505`.
Comparison: replace only `c_check_data.c` with `92857a32` (cached path), keeping
the same snapshot's other modules and test/type helpers. `baseline.d` confirms
the old module was selected. Local Clang 23.1.4 / Ryzen 9 7940HS; these are
correctness observations, not performance qualification.

Both executables use AddressSanitizer and UndefinedBehaviorSanitizer with
recovery disabled and leak detection enabled. The direct version passes 297
assertions; cached baseline passes 295. The extra two assertions test private
witness admission at exactly the eighth and ninth final part. All 50 public
semantic output rows match byte-for-byte (SHA-256 in `identities.txt`).

Cases cover malformed UCHAR value 256, mismatched value types, out-of-range
and unmapped references, live TLS targets, overwritten TLS references,
overwritten invalid/non-static references, ordinary live relocations, atom
and fixup capacity failures, duplicate-symbol publication, full versus zero
retained suffix capacity, OBJECT versus TLS output classes, exact publication
demand, existing 17-byte prefix preservation, all Link-table bytes, symbols,
byte length and scratch rollback. The cutoff cases put the complete immutable
initializer-part array immediately before a protected page.

Build from this directory, each command through `cores -n 1`:

```sh
clang -O1 -g -fsanitize=address,undefined -fno-sanitize-recover=all \
  -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing \
  -Wno-unused-function -Wno-unused-variable adversarial.c \
  -o direct -lpthread -ldl -lm
clang -O1 -g -fsanitize=address,undefined -fno-sanitize-recover=all \
  -march=native -DREVIEW_BASELINE=1 -Ibaseline -Isrc -Isrc/buster/compiler \
  -fwrapv -funsigned-char -fno-strict-aliasing \
  -Wno-unused-function -Wno-unused-variable -MMD -MF baseline.d \
  adversarial.c -o cached -lpthread -ldl -lm
ASAN_OPTIONS=detect_leaks=1 ./direct > direct.log 2>&1
ASAN_OPTIONS=detect_leaks=1 ./cached > cached.log 2>&1
```

The production and test source files were read only; no edits were made in
the owner's checkout. The later `0097ff1e` revision changes only boundary sort
selection, not the admission/writer logic. Its scalar/vector threshold and
constant-half skip were also reviewed: stable sorting after two half-rotations
preserves the full 64-bit order, including constant halves and returned-buffer
parity. Target-host acceptance remains the owner's separate performance gate.
