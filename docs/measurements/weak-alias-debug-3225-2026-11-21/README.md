# Object symbol names for debug compilations with pragma weak aliases

The Develop compiler at `bd35904be2f29a631661aa8abc5974c6db0002c7` corrupted two of the three weak aliases in its ELF symbol string table when writing a debug object. Four compilations of the same source produced four object hashes in each of three emission modes. Linking a consumer of all three weak symbols reported a corrupt symbol table.

With the output arena fix at `6deb2dcc9412f11c6c8b6c8e30d93095e71469e1`, each set of four compilations produced the same complete object. The ordinary, deferred-body and windowed-loop modes agreed for each source and debug setting. Each weak alias had the expected binding and shared its target's ELF type, section, value and size. These results cover the tracked fixture and a version that places the targets in explicit sections, totaling 48 candidate compilations. The consumer executed successfully with Clang linking the emitted object and with Buster compiling and linking the two C sources. [Compiler fix](https://github.com/buster14a/buster/pull/3225)

## Reproduce

From the directory containing this record, use the absolute paths of the two Develop compilers and the tracked fixture. Use a new output directory for each invocation. The checker reads ELF64 little-endian objects.

```sh
fixture="$source_root/tests/checker/weak-alias/mixed-unused.c"
python3 check-aliases.py "$baseline" "$fixture" baseline-objects fail
python3 check-aliases.py "$candidate" "$fixture" fixed-objects pass
python3 check-aliases.py "$candidate" mixed-sections.c fixed-sections pass
mkdir -p fixed-link
CLANG=clang bash check-linked.sh "$candidate" "$fixture" fixed-link
```

## Controls

The tracked fixture without debug information had the same complete object hash before and after the fix. Compiling the consumer without pragma aliases with debug enabled also gave the same complete object hash. DWARF records the input paths, so hashes can vary when reproducing in a different directory.

| Compared item | SHA-256 |
| --- | --- |
| Baseline compiler | `b50cb24d4e9f23186e1d8c4df03329b163c2886fdd4bf675519e77e587328128` |
| Fixed compiler | `7ec41954407d10d216322b03a58e8715c8189366b134ea210235fa646c67a5dc` |
| Fixture without debug, both compilers | `50721340515f7cded00dc8c4af3614645179f679ef1be504298fbed62cf0553c` |
| Source without aliases with debug, both compilers | `e3957b6170e5154a222e57929033fe28d184f713e2ccd2a2d8acd2d258612f9a` |

The reference compiler and linker driver was Clang 23.1.4 at `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`. See the neighboring logs for the before-and-after outcomes.
