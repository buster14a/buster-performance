# String literal blocks on an Ice Lake server, Buster #1388

Compiler branch: `perplexity/1388-simd-string-literals` of buster14a/buster, for
[this claim of #1388](https://github.com/buster14a/buster/issues/1388#issuecomment-6680525395).

The checker decoded every string literal one unit at a time (`check_literal_string_part`), and the preprocessor copied
every spelling with a backslash in it through the scalar lexer's characters (`pp_remove_splices`), so a literal of
escapes was copied byte by byte and then decoded byte by byte. The branch decodes ordinary and `u8` literals 64 source
bytes at a time (`check_literal_string_blocks`, its scalar twin `check_literal_string_part_scalar`), and copies a
spelling only when a backslash in it comes before a byte up to `' '` or ends it, as the printer's rule has it
(`pp_splice_possible_vector`, its scalar twin `pp_splice_possible_scalar`). This record measures both on #1388's
inputs. It is not a 9700X record: the session had no access to `benchpress`, and its numbers are evidence for this
machine only.

## Sources and host

- **main:** `d9442df0` (the branch's base when measured), built as `compiler-base`;
- **head:** `d9442df0` with the branch's two commits (`34f2b983`, `3759360e`; rebased onto main's `bc47e59c` as
  `bc6b3cd9` and `367a7f60`, with no change to the files they touch), built as `compiler-new`.

Each was built by `BUSTER_DEBUG_INFO=0 ./build.sh` with clang 23.1.4 (llvm-project `7a941dfb`) first in `PATH`. The host:
an Intel Xeon @ 2.90GHz (Ice Lake server, the complete `host_isa.h` AVX-512 set, so `BUSTER_HOST_VECTOR` is 1), 2
vCPUs, 7 GiB, Ubuntu 26.04.1 LTS, Linux 6.1.155, on a shared virtual machine. `sha256.txt` has both executables' and
the six inputs' SHA-256.

## Inputs

`gen.py` (seed 1388) writes #1388's shape: one `const char s[]` of 1,000,000 characters in 31,250 adjacent pieces of
32, each piece on its own line, as

- `letters.c`: ASCII letters (1.2 MB);
- `octal.c`: `\ooo` escapes of random bytes (4.2 MB);
- `hex.c`: `\xhh` escapes of random bytes (4.2 MB);
- `wide.c`: `L"..."` letters, which the blocks leave to the scalar step (1.3 MB);
- `utf8.c`: `u8"..."` characters of 1 to 4 UTF-8 bytes (2.8 MB);
- `text.c`: C-like text with simple escapes (1.6 MB).

## Method

- `ab.sh BINARY 11`: 11 runs per input of `BINARY check --time-stages -c INPUT -o /tmp/ab.o`, pinned to CPU 1
  (`taskset -c 1`). It prints the median wall time and the medians of the `check-input` and `preprocess` stages.
  `base.txt` and `new.txt` are its outputs for the two executables.
- `perf.txt`: `perf record -F 20000` of 6 runs of `check -c` on `hex.c`, `letters.c` and `utf8.c`, by symbol, for both.
- `decoder-microbench.txt`: `bench.c` drives `check_literal_string_part` alone (`extract.py` cuts the decoder out of
  `c_check_literals.c` into `extract.h`), over each input's 31,250 parts, scalar twin and blocks, best of 15 passes
  with warm caches.
- `fuzz.txt`: `fuzz.c` compares the blocks against the scalar twin, both measured and written, for every body of 1 to
  4 bytes over a 57-byte alphabet and then random bodies of up to 300 bytes from escapes, stray backslashes, quotes,
  line breaks and every UTF-8 lead and continuation byte, each part ending at a `PROT_NONE` page; the second run's
  bodies reach 3,000 bytes with fewer corrupted bytes.

Reproduce from the branch's checkout:

```sh
python3 gen.py
python3 extract.py ~/buster
clang -O2 -march=native -std=gnu2x -w -I ~/buster/src/buster/compiler -o fuzz fuzz.c && ./fuzz 3000000
clang -O2 -march=native -std=gnu2x -w -I ~/buster/src/buster/compiler -o bench bench.c && taskset -c 1 ./bench hex.c
./ab.sh ~/buster/build/compiler 11
```

## Results

Median wall time of `check -c` and of the checker's input stage, 11 runs each (`base.txt`, `new.txt`):

| input | main wall | head wall | speedup | main check-input | head check-input | speedup |
|---|---:|---:|---:|---:|---:|---:|
| letters | 27.03 ms | 18.52 ms | 1.46× | 15.80 ms | 7.95 ms | 1.99× |
| octal | 46.50 ms | 24.97 ms | 1.86× | 32.55 ms | 10.92 ms | 2.98× |
| hex | 67.59 ms | 24.13 ms | 2.80× | 53.69 ms | 11.01 ms | 4.88× |
| wide | 36.59 ms | 36.17 ms | 1.01× | 21.03 ms | 20.41 ms | 1.03× |
| utf8 | 56.58 ms | 26.25 ms | 2.16× | 42.62 ms | 11.80 ms | 3.61× |
| text | 40.46 ms | 20.26 ms | 2.00× | 28.63 ms | 8.73 ms | 3.28× |

The decoder alone, per 32-character part (`decoder-microbench.txt`): `hex` 646.7 to 56.3 ns, `octal` 362.5 to 57.0 ns,
`letters` 108.1 to 21.4 ns, `text` 244.0 to 22.6 ns.

On `hex.c`, `check_literal_string_part` went from 60.2% to 32.0% of the samples, and `__memchr_evex` (7.5%) and
`get_char_slow` (4.2%), the copies of the escaped spellings, are gone (`perf.txt`). Every input's object is byte for
byte main's.

The fuzz runs found no difference in 9,783,106 parts (`fuzz.txt`). The harness found every planted fault that changes
the result, as a difference or a fault at the guard page: a 62-byte window, octal values past 255 let through, `\x`
with three digits let through, `\xhh` values dropped, continuation bytes counted as unit starts, the UTF-8 error placed at the error byte
rather than its unit, and the wrong mask for an octal pair. Taking `\e` out of the escape table, which only sends it
to the scalar step, and looping on a part's last full block, which only moves work to the next call, changed nothing,
as they should.

`test-checker --seed 133` (`test-checker.base.log`, `test-checker.new.log`): main has 765,428 checks with 140
failures and the head 765,429 with the same 140; the added check is the blocks' (30,000 groups, 0 differences). The
140 fail the same way on main on this host: the fixtures of many records after a large type table exhaust their
resources on its 7 GiB, and source fixture and backend-source cases fail as well.

## Limits

These are a 2-vCPU virtual machine's numbers on an Ice Lake server, not the 9700X's. Instruction throughput alone does
not establish the overall ratios on Zen 5; the 9700X numbers are still to be taken. The literals are #1388's synthetic
megabyte. Wide, UTF-16 and UTF-32 literals and raw ones are unchanged.
