# Source qualification

The candidate passed 850,925 checks across the eight checker shards and matched the unmodified parent in all 4,116 per-unit comparisons on SQLite, Buster, Lua and musl. A further 480 directed compilations matched exit status, diagnostic streams and object output across the recorded modes. The compressed tables retain the observations for each comparison. [Checker log](checker.log) · [Directed results](directed.tsv.gz)

The [depth-boundary cases](deep.tsv.gz) checked 756 pairs of native compiles with shallow and deep syntax, scalar declaration fallback, recovery, debug information and warning policies. Their linked native results matched Clang in 35 executions. The [physical depth capture](physical.tsv) reads the parser output before the checker consumes it, expands the actual depth values to 32 bits, and hashes the entire sequence. The byte count describes depth payload for live tokens. The [debugger observations](parser-tree-observations.tar.xz) and [source identities](local-source-inputs.tsv) accompany the comparison.

The [independent C17 error comparisons](clang-diagnostics.tsv) matched complete Buster diagnostic streams in all 40 cases. The first error text, line and column matched Clang in 30 cases. Clang used a bracket limit of 8,192 to reach the tested expressions. [Raw diagnostic streams](clang-diagnostic-streams.tar.xz)

The full-word fallback was observed on paren-257 (depth 258), paren-2060 (depth 2061). The role and parent sequences also matched in each complete capture.

The [candidate-stack census](precedence-carry.tsv) counts the incoming monotonic precedence stack from both directions at each fixed 4,096-token boundary of both completed trees. It records candidate counts for an additional fixed-width design.

A [post-parse count of parent edges](tile-edges.tsv) split each complete source and the largest Buster initializer into fixed 4,096-token slices. That 421,058-token declaration had 493 edges between slices and at most seven distinct external parent targets per slice. This count uses the completed tree.

The permanent fresh-source parser regression uses 3,072 tentative declarations. It checks packed and wide depths across six nesting cases and compares every resulting parent. The [three-compiler replay](previous-mask.tsv) shows the failing predecessor alongside the corrected compiler.

The [Linux pagemap sample](precedence-residency.tsv) was collected on the Ryzen 9 7940HS source-qualification host. It counts present 4-KiB virtual pages completely inside each of the three K4 working columns at parser return. The nominal range is that column's full-unit payload. It excludes partial edge pages.

The SQLite and Buster rows record the number of precedence cuts and longest local interval. A generated unit placed its 64 function-closing cuts at every possible lane of a vector block. The rows' parent and role digests cover all tokens in each full source.

The ordinary typed dump comparison compiled both SQLite and Buster with `--dump-typed --lanes 1 -c`. Each complete dump, diagnostic stream and ELF object matched the baseline. The [stream and object sizes and hashes](typed-object-and-output.tsv) record each source.

The complete SQLite shells were linked from freshly compiled objects and ran the repository’s core, dot-command and file SQL suites. All output, diagnostics and exit statuses matched the independently compiled Clang shell. The core and file suites deliberately exercised errors and returned one. [Runtime comparisons](sqlite-runtime.tsv) · [Output and diagnostics](sqlite-runtime-streams.tar.xz) · [Command](sqlite-runtime.sh)
