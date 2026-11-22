# Source qualification

The candidate passed 850,925 checks across the eight checker shards and matched the unmodified parent in all 4,116 per-unit comparisons on SQLite, Buster, Lua and musl. A further 480 directed compilations matched exit status, diagnostic streams and object output across the recorded modes. The compressed tables retain the observations for each comparison. [Checker log](checker.log) · [Directed results](directed.tsv.gz)

The [depth-boundary cases](deep.tsv.gz) checked 756 pairs of native compiles with shallow and deep syntax, scalar declaration fallback, recovery, debug information and warning policies. Their linked native results matched Clang in 35 executions. The [physical depth capture](physical.tsv) reads the parser output before the checker consumes it, expands the actual depth values to 32 bits, and hashes the entire sequence. The byte count describes depth payload for live tokens. The [debugger observations](parser-tree-observations.tar.xz) and [source identities](local-source-inputs.tsv) accompany the comparison.

The [independent C17 error comparisons](clang-diagnostics.tsv) matched complete Buster diagnostic streams in all 40 cases. The first error text, line and column matched Clang in 30 cases. Clang used a bracket limit of 8,192 to reach the tested expressions. [Raw diagnostic streams](clang-diagnostic-streams.tar.xz)

The full-word fallback was observed on paren-257 (depth 258), paren-2060 (depth 2061). The role and parent sequences also matched in each complete capture.

The ordinary typed dump comparison compiled SQLite and Buster with `--dump-typed --lanes 1 -c`. The complete dumps, diagnostic streams and objects matched for both sources. The [stream and object digests](typed-object-and-output.tsv) include their lengths.

The [64 shifted source units](fixed-boundary-oracle.tsv) move conditionals, subscripts, bitwise operators and statement boundaries across fixed 4,096-token cuts. Every final parent and role matched across the two compilers. Each executable returned the same value as the independently compiled Clang source. The [generator and comparison](lanes.py) reproduce the unit at each alignment.

The [Linux pagemap samples](precedence-residency.tsv) cover the three K4 vector columns and seven possible auxiliary columns at parser return on a Ryzen 9 7940HS. The cells count resident 4-KiB pages completely inside the respective nominal full-unit ranges. The [three-compiler replay](previous-mask.tsv) retains the six nesting configurations in the long-index regression.

The [right snapshot counts](boundary-records.tsv) are the live future candidates read from the compiler at each boundary, summed over the full source.

The complete SQLite shells were linked from freshly compiled objects and ran the repository’s core, dot-command and file SQL suites. All output, diagnostics and exit statuses matched the independently compiled Clang shell. The core and file suites deliberately exercised errors and returned one. [Runtime comparisons](sqlite-runtime.tsv) · [Output and diagnostics](sqlite-runtime-streams.tar.xz) · [Command](sqlite-runtime.sh)
