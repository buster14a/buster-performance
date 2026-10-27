#!/usr/bin/env bash
# Small build/run glue. Invoke from the campaign root containing base/, head/ and evidence/.
set -euo pipefail
export EXCLUSIVE_OWNER=codex-605
export EXCLUSIVE_TITLE="Buster #605 attribute argument qualification"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/605
lock="$HOME/buster-fast-bench/exclusive.sh"
root="$PWD"
mode="${1:?mode}"
shift
case "$mode" in
    probe-build)
        tree="${1:?base or head}"
        destination="$root/$tree-probe"
        mkdir -p "$destination"
        tar -cf - --exclude=build -C "$tree" . | tar -xf - -C "$destination"
        evidence/instrument-fixed "$destination/src/buster/compiler/c_check_attribute.c" "$destination/attribute-probe.c"
        mv "$destination/attribute-probe.c" "$destination/src/buster/compiler/c_check_attribute.c"
        sed 's/#define BUSTER_ELSEWHERE inline __attribute__((noinline))/#define BUSTER_ELSEWHERE static/' "$destination/src/buster/compiler/main.c" > "$destination/main-probe.c"
        cp evidence/probe.c "$destination/probe.c"
        "$lock" clang -O1 -march=native -I"$destination/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -Wno-unused-function \
            "$destination/probe.c" -pthread -lm -o "$destination/probe"
        ;;
    probe)
        "$lock" taskset -c 2 bash evidence/run.sh probe-held
        ;;
    probe-held)
        : "${BUSTER_9700X_HELD:?must hold the shared lock}"
        for tree in base head; do
            for source in evidence/cases/*.c; do
                for path in vector scalar; do
                    printf 'tree=%s case=%s path=%s\n' "$tree" "${source##*/}" "$path"
                    options=()
                    if [ "$path" = scalar ]; then options+=(--scalar); fi
                    "$root/$tree-probe/probe" "${options[@]}" -fsyntax-only "$source"
                done
            done
        done
        ;;
    measure)
        "$lock" taskset -c 2 evidence/campaign-fixed measure "$root/base/build/compiler" "$root/head/build/compiler" "$root/evidence/cases" "${1:?round}"
        ;;
    checker)
        cd head
        "$lock" ./build/compiler test-checker --seed 133
        ;;
    driver)
        cd head
        "$lock" ./build/compiler test-checker-driver --executable ./build/compiler
        ;;
    deferred)
        cd head
        "$lock" ./build/compiler test-checker-deferred
        ;;
    corpus)
        "$lock" head/build/compiler test-checker-corpus --clang /usr/bin/clang evidence/cases/*.c
        ;;
    call-graph)
        cd head
        "$lock" ./build.sh check-call-graph
        ;;
    *) exit 2 ;;
esac
