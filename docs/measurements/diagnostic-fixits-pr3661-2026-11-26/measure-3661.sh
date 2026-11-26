set -euo pipefail
mode=$1
root=$PWD
out="$root/diagnostics-3661"
base="$root/base3661/build/compiler"
head="$root/pr3661/build/compiler"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
perf_events=(--no-big-num -x, -e cycles:u,instructions:u,task-clock)
case "$mode" in
    sqlite)
        printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d "$sqlite/sqlite3.c" | sha256sum --check > "$out/sqlite-identity.txt"
        flags=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
        cd "$root/pr3661"
        for pipeline in default no-direct; do
            options=()
            if [[ "$pipeline" == no-direct ]]; then options=(--no-direct); fi
            taskset -c 2 "$head" measure-compile --runs 31 --reference "$base" -- -c "${options[@]}" "${flags[@]}" > "$out/sqlite-$pipeline.txt" 2>&1
            for side in base head; do
                compiler=$base
                if [[ "$side" == head ]]; then compiler=$head; fi
                taskset -c 2 "$compiler" -c "${options[@]}" "${flags[@]}" -o "$out/$pipeline-$side.o"
            done
            sha256sum "$out/$pipeline-base.o" "$out/$pipeline-head.o" >> "$out/sqlite-identity.txt"
            if cmp -s "$out/$pipeline-base.o" "$out/$pipeline-head.o"; then printf '%s bytes match\n' "$pipeline" >> "$out/sqlite-identity.txt"; fi
        done
        ;;
    diagnostic-none|diagnostic-caret)
        cd "$out"
        python3 "$root/gen-3661.py" > warnings.c
        options=(--no-direct -fsyntax-only -Wparentheses -Wstring-plus-int -ferror-limit=0)
        if [[ "$mode" == diagnostic-none ]]; then options+=(-fno-caret-diagnostics); fi
        mkdir -p "$out/$mode"
        for round in $(seq 0 20); do
            order=(base head)
            if (( round % 2 )); then order=(head base); fi
            for side in "${order[@]}"; do
                compiler=$base
                if [[ "$side" == head ]]; then compiler=$head; fi
                label="$out/$mode/$round-$side"
                taskset -c 2 perf stat "${perf_events[@]}" -o "$label.csv" -- "$compiler" "${options[@]}" warnings.c > "$label.stdout" 2> "$label.stderr"
                [[ "$(grep -c ': warning:' "$label.stderr")" == 1024 ]]
                if [[ "$round" != 0 ]]; then
                    cmp "$label.stderr" "$out/$mode/0-$side.stderr"
                    rm "$label.stderr"
                fi
                test ! -s "$label.stdout"
                rm "$label.stdout"
            done
        done
        ;;
    oracle)
        cd "$root/pr3661"
        for side in base head; do
            compiler=$base
            if [[ "$side" == head ]]; then compiler=$head; fi
            status=0
            taskset -c 2 perf stat "${perf_events[@]}" -o "$out/oracle-$side.csv" -- "$compiler" test-carets --clang "$(command -v clang)" --fixtures "$PWD/tests/carets" > "$out/oracle-$side.txt" 2>&1 || status=$?
            printf '%s %s\n' "$side" "$status" >> "$out/oracle-status.txt"
        done
        grep -Fx "test-carets: 74 cases, 0 differ from clang's" "$out/oracle-head.txt"
        ;;
    *)
        exit 2
        ;;
esac
