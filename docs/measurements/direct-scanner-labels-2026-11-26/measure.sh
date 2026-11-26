#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Run with pinned clang and clang++ on PATH. The last argument is a new output directory.
set -euo pipefail
[[ $# == 6 ]] || { echo 'usage: measure.sh BASE_COMPILER HEAD_COMPILER RE2C_TREE CMARK_TREE DYNAMORIO_ROOT NEW_OUTPUT' >&2; exit 2; }
base_bin=$(realpath "$1")
head_bin=$(realpath "$2")
re2c_tree=$(realpath "$3")
cmark_tree=$(realpath "$4")
dr_root=$(realpath "$5")
mkdir -- "$6"
cd -- "$6"
work=$PWD
[[ $(git -C "$re2c_tree" rev-parse HEAD) == ffdc69dc2eee74404109f916721491b9dc5a2948 ]]
[[ $(git -C "$cmark_tree" rev-parse HEAD) == bb3678d7a73cb02d35c8876ecd097072636200a8 ]]
export LC_ALL=C
unset BUSTER_NO_DIRECT SOURCE_DATE_EPOCH
export BUSTER_CLANG_RESOURCE_DIR="$(clang -print-resource-dir)"
ulimit -c 0

cmake -S "$cmark_tree" -B cmark-build -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_BUILD_TYPE=Release -DCMARK_SHARED=OFF > cmark-build.log
cmake --build cmark-build -j4 >> cmark-build.log
names_file=$re2c_tree/test/encodings/utf8_names.c
sed '/^const char \*names\[\] =/,$d' "$names_file" > names.c
sed -n '/^const char \*names\[\] =/,$p' "$names_file" > names-suite.inc
printf 'int f(int x) { return 3 * x; }\n' > tiny.c
cat > names-runner.cc <<'CPP'
#include <cstdio>
#include <string>
extern "C" int lex(const char *);
extern "C" int reference_lex(const char *);
#define main upstream_main
#include "names-suite.inc"
#undef main
int main() {
    if (upstream_main() != 0) return 1;
    for (const char *name : names) {
        std::string prefix(name);
        prefix.pop_back();
        std::string suffixed = std::string(name) + "!";
        if (lex(prefix.c_str()) != reference_lex(prefix.c_str()) || lex(suffixed.c_str()) != 1) return 1;
    }
    std::printf("%zu names, prefixes and suffixed negatives passed\n", sizeof(names) / sizeof(names[0]));
    return 0;
}
CPP
clang -O0 -Dlex=reference_lex -c names.c -o reference.o
printf 'workload\tpair\trevision\tpath\tinstructions\n' > instructions.tsv
for sample in names cmark byte-switch tiny; do
    case "$sample" in
        names) args=(-c names.c) ;;
        cmark) args=(-c -DCMARK_STATIC_DEFINE -DNDEBUG "-I$work/cmark-build/src" "-I$cmark_tree/src" "$cmark_tree/src/scanners.c") ;;
        byte-switch) args=(-c "$re2c_tree/test/bug2102138.c") ;;
        tiny) args=(-c tiny.c) ;;
    esac
    for revision in base head; do
        if [[ $revision == base ]]; then bin=$base_bin; else bin=$head_bin; fi
        "$bin" "${args[@]}" -o "$sample.$revision.o"
    done
    if [[ $sample == names ]]; then
        "$head_bin" --no-direct "${args[@]}" -o disabled.o
        cmp disabled.o names.base.o
        for revision in base head; do
            clang++ names-runner.cc "names.$revision.o" reference.o -o names-check
            ./names-check
        done
    else
        cmp "$sample.base.o" "$sample.head.o"
    fi
    for pair in 1 2 3 4 5; do
        order=(base head)
        if (( pair % 2 == 0 )); then order=(head base); fi
        for revision in "${order[@]}"; do
            if [[ $revision == base ]]; then bin=$base_bin; else bin=$head_bin; fi
            ln -sfn "$bin" compiler
            log=$sample.$pair.$revision.log
            "$dr_root/bin64/drrun" -root "$dr_root" -c "$dr_root/samples/bin64/libinscount.so" -- ./compiler "${args[@]}" -o result.o > "$log" 2>&1
            cmp result.o "$sample.$revision.o"
            instructions=$(sed -n 's/^Instrumentation results: \([0-9][0-9]*\) instructions executed$/\1/p' "$log")
            [[ $instructions =~ ^[1-9][0-9]*$ ]]
            if readelf -p .comment result.o | grep -q 'buster direct'; then route=direct; else route=full; fi
            if [[ $sample == names && $revision == base ]]; then [[ $route == full ]]; else [[ $route == direct ]]; fi
            printf '%s\t%d\t%s\t%s\t%s\n' "$sample" "$pair" "$revision" "$route" "$instructions" >> instructions.tsv
        done
    done
done
clang cmark-build/src/CMakeFiles/cmark_exe.dir/main.c.o cmark.head.o cmark-build/src/libcmark.a -o cmark-under-test
python3 "$cmark_tree/test/spec_tests.py" --program "$work/cmark-under-test" --spec "$cmark_tree/test/spec.txt"
