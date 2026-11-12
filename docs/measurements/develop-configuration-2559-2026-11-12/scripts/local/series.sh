#!/bin/bash
# series.sh: the record's edits, applied in turn to the checkout, each followed by a Develop build; then a clean Develop
# build of the edited sources; prints each build's time and part jobs, and the two executables' SHA-256.
set -euo pipefail
cd /home/user/buster
c=src/buster/compiler
log=/tmp/claude-0/ps/series
mkdir -p $log
probe() { printf '\n__attribute__((used)) static const char* buster_series_probe_%s(void)\n{\n    return "series probe %s";\n}\n' "$1" "$1"; }
append() { probe "$2" >> "$c/$1"; }
top() { { probe "$2"; cat "$c/$1"; } > "$c/$1.new"; mv "$c/$1.new" "$c/$1"; }
header() { f=$c/host_isa.h; last=$(grep -n '^#endif' "$f" | tail -1 | cut -d: -f1); { head -n $((last-1)) "$f"; printf 'static inline int buster_series_probe_header(void)\n{\n    return 7;\n}\n'; tail -n +$last "$f"; } > "$f.new"; mv "$f.new" "$f"; }
build() {
    local name=$1 s e
    s=$(date +%s.%N)
    ./build.sh --config Develop > "$log/$name.log" 2>&1
    e=$(date +%s.%N)
    printf '%s\t%.1f s\t%s part jobs\t%s compiles\n' "$name" "$(echo "$e - $s" | bc)" "$(grep -c 'Optimizing and generating' "$log/$name.log" || true)" "$(grep -c 'Building C object' "$log/$name.log" || true)"
}
build start
build nothing
append c_check_input.c a; build checker-append
top c_check_input.c b; build checker-top
append differential.c c; build differential
append tier0.c d; build tier0
append c_parser_impl.c e; build parser
append c_checker_driver_test.c f; build driver-test
append c_checker_test.c g; build checker-test
header; build header
touch $c/host_isa.h; build header-touch
incremental=$(sha256sum build/cmake/native/Develop/compiler | cut -d' ' -f1)
cp build/cmake/native/Develop/compiler $log/incremental-compiler
./build.sh clean --config Develop > /dev/null 2>&1
build clean-after-edits
clean=$(sha256sum build/cmake/native/Develop/compiler | cut -d' ' -f1)
echo "incremental $incremental"
echo "clean       $clean"
[ "$incremental" = "$clean" ] && echo "SAME" || echo "DIFFERENT"
