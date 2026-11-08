#!/usr/bin/env bash
# One verified run or one Callgrind capture of the frozen SQLite workload.
set -euo pipefail
root=/home/david/buster-fast-bench/1736-current-01a1bae5
side=${1:?main or candidate}
mode=${2:?verify or callgrind}
case "$side-$mode" in main-verify|candidate-verify|main-callgrind|candidate-callgrind) ;; *) exit 2;; esac
test "${BUSTER_9700X_HELD:-}" = 1
test "$(uname -n)" = benchpress
binary="$root/out/candidate-ordinary-sqlite/program"
record="$root/receipts/run-sqlite-$side-$mode"
test ! -e "$record"
mkdir "$record"
scratch=$(mktemp -d /dev/shm/buster-1736-sqlite.XXXXXXXX)
trap 'rm -rf -- "$scratch"' EXIT
mkdir "$scratch/db" "$scratch/tmp"
expected=cc67398324468c6bd5e2ca0d1b08fd629accbbef6a98828c31c33ba009f6f140
test "$side" = candidate
printf '%s  %s\n' "$expected" "$binary" | sha256sum -c -
sha256sum "$binary" > "$record/elf.sha256"
valroot=/home/david/buster-fast-bench/1189-codex-01a1b81e-plan/valgrind-retained
sha256sum /usr/bin/timeout > "$record/tools.sha256"
sha256sum /usr/bin/sqlite3 >> "$record/tools.sha256"
if test "$mode" = callgrind; then
  sha256sum "$valroot/bin/valgrind" "$valroot/lib/valgrind/callgrind-amd64-linux" >> "$record/tools.sha256"
  env VALGRIND_LIB="$valroot/lib/valgrind" "$valroot/bin/valgrind" --tool=callgrind --version > "$record/valgrind-version.txt"
fi
uname -a > "$record/host.txt"
args=(--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1)
if test "$mode" = verify; then args+=(--verify); fi
args+=(speedtest1.db)
cmd=("$binary" "${args[@]}")
if test "$mode" = callgrind; then
  cmd=("$valroot/bin/valgrind" --tool=callgrind --dump-instr=yes "--callgrind-out-file=$record/callgrind.out" "${cmd[@]}")
fi
printf '%s\0' "${cmd[@]}" > "$record/argv.nul"
printf 'LC_ALL=C\nHOME=%s\nPATH=/usr/bin:/bin\nSQLITE_TMPDIR=%s\nVALGRIND_LIB=%s\n' "$root/home" "$scratch/tmp" "$valroot/lib/valgrind" > "$record/environment.txt"
date -u '+started=%FT%TZ' > "$record/time.txt"
cd "$scratch/db"
set +e
env -i PATH=/usr/bin:/bin LC_ALL=C "HOME=$root/home" "SQLITE_TMPDIR=$scratch/tmp" "VALGRIND_LIB=$valroot/lib/valgrind" "${cmd[@]}" > "$record/stdout" 2> "$record/stderr"
status=$?
set -e
printf '%s\n' "$status" > "$record/status"
date -u '+finished=%FT%TZ' >> "$record/time.txt"
test "$status" -eq 0
printf '%s  %s\n' "$expected" "$binary" | sha256sum -c -
sqlite3 "$scratch/db/speedtest1.db" .dump > "$record/database.sql"
sha256sum "$record/database.sql" > "$record/database.sha256"
if test "$mode" = verify; then
  grep -Fx 'Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739' "$record/stdout"
else
  test -s "$record/callgrind.out"
  grep -q '^summary:' "$record/callgrind.out"
fi
