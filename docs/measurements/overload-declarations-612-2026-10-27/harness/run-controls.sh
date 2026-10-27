#!/usr/bin/env bash
# Record identities of the default-path control already measured in run-measure.sh's paired matrix.
set -euo pipefail
cd "$HOME/buster-fast-bench/issue-612-codex"
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sha256sum "$corpus/sqlite/sqlite3.c" "$corpus/provenance/gnu17-pinned-predefines.txt" > evidence/control-input.sha256
printf 'control identities complete\n'
