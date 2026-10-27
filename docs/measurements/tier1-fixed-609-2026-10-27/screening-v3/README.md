# Initial screening; superseded for whole-allocation comparisons

These original logs, sources and receipts are retained for audit. Both source
variants passed semantic checks and the hardware native/guard/rollback suite.
This harness compiled the baseline in an external wrapper but allowed the
candidate allocator to inline into the caller's translation unit. Its whole
allocation numbers therefore mix the allocator change with different call and
compilation contexts. In particular, its F=0 controls reported +1.5% to +2.9%
for N=256..8192; that is not an isolated measurement of filter overhead.

The primary record in the parent directory compiles **both** allocators in
matching external wrappers and repeats the qualification. Use that record for
acceptance. The initial fixed-only sparse N=8192 result was 6.868 ms to
57.914 us, but it is not substituted for the primary run's measurements.
