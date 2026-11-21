# T from the reader’s expression window before graph construction

The existing lean window front produced each tested expression’s operands and type inputs before the ordinary reader created its graph nodes. The independent T kernel took the following roots. Every accepted source range was subsequently bound to its graph nodes and checked against the ordinary completed program’s value, conversion and member-offset columns. The table gives roots and records in parentheses.

| Qualification | SQLite | Lua | musl | Buster main |
| --- | ---: | ---: | ---: | ---: |
| Built-in integer operands | 15,606 (53,744) | 2,037 (6,924) | 17,155 (61,439) | 6,430 (26,805) |
| Add pointer and member operations, refuse any floating record | 33,089 (160,015) | 4,308 (22,864) | 22,976 (93,908) | 19,897 (122,575) |

Both rows had zero differences against the completed program. A third run allowed floating records. It produced 15 differing musl roots covering 43 differing records. Sampled records from `fma.c` and `fmaf.c` lacked the ordinary floating-environment flag. The reader-time shadow’s existing comparison found no differences in this third run because its reference admission selected a different population. The corpus-level results distinguish the two comparisons. [Coverage](coverage.tsv)

On SQLite the integer run took 9,333 evaluated statement roots with 32,463 records, 3,683 conditions with 15,568 records, and 2,590 returns with 5,713 records. Of its statements, 5,451 were explicit void casts of literal leaves (16,353 records) and 2,460 were assignments (11,222). Equality conditions contributed 984 roots with 4,245 records. A separate 1,046 declaration discards have no runtime root. The parser distinguishes these before the graph exists. The measurements used default warning options and captured local compilation, including 2,668 SQLite bodies on this host. Buster main was compiled from the instrumented checkout.

## Qualification boundary

The proof reads cached type rows and declaration lines, the actual front’s packed columns, and the language-extension and overload settings. Its machine has no ordinary graph nodes or reference T columns. When a rule leaves a record, the run supplies a zero invalid record and refuses any enclosing expression that depended on it. The alternative experiment permits address, dereference, subscript and member operations. Calls, ternary operators and initializer consumers remain outside the candidates.

The completed-stream comparison checks each candidate’s type, value category, flags, constant kind and payload, object, offset, fault, overload, bit width, both operand conversions and member offsets. The packed word additionally compares with the existing shadow for the overlap it takes. The new stream comparison accepts the compact zero representation for a floating zero. A typed probe can succeed on an expression that still needs a warning test, read event, native tape or relocation during production compilation. The probe does not change generated objects or measure compiler throughput.

## Reproduce

The patch applies to Buster commit `84a7d3d76891d6c393497e62e6aff38f2b162fc2`. The run script expects the frozen node-machine corpora and their standard `corpora.sh`. It runs the usual `measure-node-machine` command with the real front before the graph walk. `CLANG` may select the compiler used for the Buster main predefines.

```sh
git apply /path/to/pregraph-t-probe.patch
./build.sh
bash /path/to/run.sh /absolute/path/to/corpora /absolute/path/to/results
python3 /path/to/summarize.py /absolute/path/to/results/integer-sqlite.stderr
```

The compressed logs retain all probe counters and comparison findings. Their source path prefixes are normalized. The companion census files retain each original command’s body and root totals.
