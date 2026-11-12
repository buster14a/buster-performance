#!/bin/bash
# usage: lock.sh ./probes.sh ; the readings of dump.sh's two dumps that chose the sweeps' keys (tools/key_probes.py):
# which operators' facts their operands decide, which operands' contexts their node decides, and the lowering keys that
# two nodes answer with different entries. Counts, not timings. Results in results/sweeps.
set -euo pipefail
cd "$(dirname "$0")"
out=results/sweeps
mkdir -p "$out"
python3 -I tools/key_probes.py scratch/sqlite3.dump scratch/musl.dump > "$out/key-probes-sqlite3.txt"
python3 -I tools/key_probes.py scratch/musl.dump scratch/sqlite3.dump > "$out/key-probes-musl.txt"
sha256sum tools/key_probes.py > "$out/key-probes-hashes.txt"
echo done > "$out/probes.done"
