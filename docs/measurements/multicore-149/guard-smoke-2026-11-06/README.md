# Guard and real-lock SQLite smoke, 2026-11-06

This is a single-sample plumbing smoke, not a curve, output-equality comparison,
wait measurement, or acceptance result. The performance checkout was
`b136b9af48b3c72fc8bcd40ff204a0628316a944`; the compiler checkout was merged
Buster `2dc50258e8b33393474b64032a5cbe9f17c63def`, with executable SHA-256
`51b54dd02986a28f294c0d5b2539e93739acb8962851127316da7953d4f8b09b`.
The separately locked build produced runner SHA-256
`3a9eb04027d31e6316b6c845f0b0be2b2b02420e64b98c8b7244fce010d63f3d`;
a separately locked self-test passed 52 checks. The post-smoke identity record
rechecked both executables and revisions.

The normal controller used the real prepared SQLite case and a one-grant wrapper
included in the archive. That wrapper delegated the first invocation to the
actual `exclusive.sh` shared lock and deliberately refused every subsequent
invocation. The one-lane reference completed successfully and created one
verified object. Its guard reports 270,695,871 ns, status 0, no interruption,
and no adopted descendants; its successful wrapper elapsed 275,434,120 ns,
including lock wait. These are guard plumbing observations, not performance
acceptance data.

The wrapper intentionally refused warmup 0, exit 99. The retained controller
log and case status show failure and `parent-issue-status=not-established`.
The failed warmup's lock-window receipt explicitly marks its elapsed time as
invalid for an upper lock-hold bound. No later samples ran. The single compiled
object is omitted from the archive; its original object hash is retained.

`receipts.tar.gz` retains the frozen case manifests, controller and reference
records, guard and failed-warmup receipts, one-grant script, preparation logs,
and post-smoke identities. `SHA256SUMS` inside the archive checks the archived
sanitized files. Host home paths are replaced by `$BENCH_HOME/`, and other
sessions' lock-holder details in preparation logs are redacted. Consequently,
recorded hashes of original files and commands containing those paths are
historical identity evidence, not hashes of the sanitized files or directly
replayable commands. The original unredacted files remain on the host.

The exact-merged compiler's hosted sanitizer/fuzz prerequisite, the three-case
campaign, and measured waits remained pending when this smoke ran. The native
qualification's documented internal host/tool exclusions still apply.
