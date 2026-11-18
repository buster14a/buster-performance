# Diagnostics' gate (#2924, C6): main `6eaf73cfd`

`benchmark-diagnostics` on main's Release build plus [`counts.patch`](counts.patch). The patch is for the experiment
only: it adds record counts between the insertion cutoff (256) and 4,096, which the 2026-10-22 measurements in
`docs/determinism.md` didn't cover. [`gate.sh`](gate.sh) runs three processes of each mode under the lock on CPU 2:
both paths interleaved, each path alone, and the selected path after 100 ms of insertion sorts.

The run is queued behind CI on the 9700X; the logs and the verdict follow in this directory.
