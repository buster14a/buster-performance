#!/usr/bin/env bash
# Private diagnostic orchestration; no compiler source or workflow edits.
set -euo pipefail
task=/home/david/Documents/Codex/2026-10-30/tak/work/msan-native-corpus-timeout-20261030
src=$task/source-674
out=$task/diagnostic
tc=$task/official-23.1.4
corpus=$task/corpus-391e729af658
export PATH="$tc/bin:/usr/bin:/bin"
export LD_LIBRARY_PATH="$tc/lib"
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH LD_PRELOAD CCC_OVERRIDE_OPTIONS COMPILER_PATH GCC_EXEC_PREFIX
unset BUSTER_HOST_RUNTIME BUSTER_FUZZ_AVAILABLE BUSTER_FUZZ_ENTRY
export BUSTER_HOST_ARCH=znver3 BUSTER_SANITIZER=memory BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_LINKER=lld
export BUSTER_CLANG_RESOURCE_DIR="$tc/lib/clang/23"
export BUSTER_ORACLE_CACHE=check XDG_CACHE_HOME="$task/private-cache"
unset SOURCE_DATE_EPOCH
export TMPDIR="$task/tmp"
mkdir -p "$out" "$TMPDIR" "$XDG_CACHE_HOME"
cd "$src"

case ${1:?preflight|build|run|original} in
preflight)
    test -x "$tc/bin/clang"
    test -x "$tc/bin/llvm-symbolizer"
    test "$(clang -dumpversion)" = 23.1.4
    clang --version > "$out/compiler-version.txt"
    llvm-symbolizer --version > "$out/symbolizer-version.txt"
    clang -dumpmachine > "$out/default-triple.txt"
    clang -print-resource-dir > "$out/resource-directory.txt"
    clang -print-runtime-dir > "$out/runtime-directory.txt"
    clang -march=znver3 -### -c -x c /dev/null > "$out/effective-driver.txt" 2>&1
    clang -march=znver3 -dM -E -include src/buster/compiler/host_isa.h -x c /dev/null > "$out/target-macros.txt"
    clang -march=native -dM -E -include src/buster/compiler/host_isa.h -x c /dev/null > "$out/local-native-macros.txt"
    grep -Fx '#define BUSTER_HOST_VECTOR 0' "$out/target-macros.txt"
    for feature in AES AVX2 BMI2 BMI LZCNT POPCNT SSE4_1 SSSE3 VAES XSAVE; do
        grep -Fx "#define __${feature}__ 1" "$out/target-macros.txt"
        grep -Fx "#define __${feature}__ 1" "$out/local-native-macros.txt"
    done
    ./build.sh print-compile-flags > "$out/compile-flags.nul"
    ./build.sh print-sources > "$out/sources.nul"
    sha256sum --check "$out/source-before.sha256" > "$out/source-preflight-check.log"
    test -f "$corpus/MANIFESTS.sha256"
    printf '%s  %s\n' 391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd "$corpus/MANIFESTS.sha256" | sha256sum --check
    printf '%s\n' "BUSTER_HOST_ARCH=$BUSTER_HOST_ARCH" "BUSTER_SANITIZER=$BUSTER_SANITIZER" "BUSTER_SANITIZER_OPTIMIZATION=$BUSTER_SANITIZER_OPTIMIZATION" "BUSTER_LINKER=$BUSTER_LINKER" "BUSTER_CLANG_RESOURCE_DIR=$BUSTER_CLANG_RESOURCE_DIR" "BUSTER_ORACLE_CACHE=$BUSTER_ORACLE_CACHE" "XDG_CACHE_HOME=$XDG_CACHE_HOME" 'SOURCE_DATE_EPOCH=unset_during_build' "TMPDIR=$TMPDIR" > "$out/selected-environment.txt"
    ;;
build)
    test ! -e "$out/build.started"
    date --iso-8601=seconds > "$out/build.started"
    clang -std=c17 -O2 -Wall -Wextra -Werror "$task/diagnostic-supervisor.c" -o "$out/supervisor" > "$out/supervisor-build.log" 2>&1
    sha256sum "$task/diagnostic-supervisor.c" "$out/supervisor" > "$out/supervisor.sha256"
    control=0
    "$out/supervisor" 2 "$out/control-exit.receipt" /bin/sh -c 'exit 7' || control=$?
    printf 'control_exit=%s\n' "$control" > "$out/controller-controls.status"
    test "$control" -eq 7
    grep -Fx 'cleanup=ECHILD' "$out/control-exit.receipt"
    control=0
    "$out/supervisor" 2 "$out/control-escape.receipt" /bin/sh -c 'setsid /bin/sh -c "sleep 60 & wait" & wait' || control=$?
    printf 'control_escape=%s\n' "$control" >> "$out/controller-controls.status"
    test "$control" -eq 124
    grep -Fx 'cleanup=ECHILD' "$out/control-escape.receipt"
    status=0
    timeout --kill-after=10s 1200 ./build.sh > "$out/build.log" 2>&1 || status=$?
    printf 'build=%s\n' "$status" > "$out/build.status"
    test "$status" -eq 0
    cp build/compile_commands.json "$out/compile_commands.json"
    sha256sum build/compiler > "$out/binary.sha256"
    proof=0
    bash tools/ci/sanitizers.sh probe "$out/probes" > "$out/probe.log" 2>&1 || proof=$?
    printf 'proof=%s\n' "$proof" >> "$out/build.status"
    test "$proof" -eq 0
    sha256sum --check "$out/source-before.sha256" > "$out/source-after-build-check.log"
    ;;
original)
    export SOURCE_DATE_EPOCH=1792454400
    printf '%s\n' "$$" > "$out/compiler.pid"
    musl="$corpus/libc/musl"
    exec ./build/compiler test-checker-corpus --clang clang --symbols-minimum 354 --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os -pipe \
      -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" \
      "$musl/src/math" "$musl/src/string" "$musl/src/stdlib" "$musl/src/fenv" "$musl/src/legacy" "$musl/src/process" "$musl/src/signal" "$musl/src/multibyte"
    ;;
run)
    export SOURCE_DATE_EPOCH=1792454400
    printf 'SOURCE_DATE_EPOCH=%s\n' "$SOURCE_DATE_EPOCH" > "$out/run-source-date-epoch.txt"
    test ! -e "$out/run.started"
    grep -Fx 'proof=0' "$out/build.status"
    sha256sum --check "$out/binary.sha256" > "$out/binary-before-run-check.log"
    sha256sum --check "$out/supervisor.sha256" > "$out/supervisor-before-run-check.log"
    export GITHUB_ENV="$out/sanitizer.env"
    : > "$GITHUB_ENV"
    bash tools/ci/sanitizers.sh configure "$out/reports"
    set -a
    source "$GITHUB_ENV"
    set +a
    supervisor=
    observer=
    command_status=125
    finish_run()
    {
        trap - EXIT INT TERM HUP
        set +e
        if [ -n "$supervisor" ] && kill -0 "$supervisor" 2>/dev/null; then
            kill -TERM "$supervisor"
            wait "$supervisor"
            command_status=$?
        fi
        observer_status=0
        if [ -n "$observer" ]; then
            wait "$observer" || observer_status=$?
        fi
        cleanup_status=1
        grep -Fxq 'cleanup=ECHILD' "$out/supervisor.receipt" && cleanup_status=0
        audit_status=0
        bash tools/ci/sanitizers.sh audit "$out/reports" > "$out/audit.log" 2>&1 || audit_status=$?
        source_status=0
        sha256sum --check "$out/source-before.sha256" > "$out/source-after-run-check.log" || source_status=$?
        binary_status=0
        sha256sum --check "$out/binary.sha256" > "$out/binary-after-run-check.log" || binary_status=$?
        cache_status=0
        find "$XDG_CACHE_HOME" -type f -print0 | sort -z | xargs -0 -r sha256sum > "$out/cache-after.sha256" || cache_status=$?
        date --iso-8601=seconds > "$out/run.finished"
        printf 'command=%s cleanup=%s audit=%s observer=%s source=%s binary=%s cache_receipt=%s\n' "$command_status" "$cleanup_status" "$audit_status" "$observer_status" "$source_status" "$binary_status" "$cache_status" | tee "$out/status.txt"
        if [ "$cleanup_status" -ne 0 ]; then
            printf '%s\n' 'Cleanup did not prove ECHILD; audit is provisional and cannot qualify this run.' >> "$out/status.txt"
        fi
        result=1
        if [ "$command_status" -eq 0 ] && [ "$cleanup_status" -eq 0 ] && [ "$audit_status" -eq 0 ] && [ "$observer_status" -eq 0 ] && [ "$source_status" -eq 0 ] && [ "$binary_status" -eq 0 ] && [ "$cache_status" -eq 0 ]; then result=0; fi
        exit "$result"
    }
    trap finish_run EXIT
    trap 'command_status=130; finish_run' INT
    trap 'command_status=143; finish_run' TERM HUP
    find "$XDG_CACHE_HOME" -type f -print > "$out/cache-before-paths.txt"
    test ! -s "$out/cache-before-paths.txt"
    date --iso-8601=seconds > "$out/run.started"
    cat "/proc/$$/status" > "$out/controller-process.status"
    cat /proc/sys/kernel/yama/ptrace_scope > "$out/ptrace-scope.txt"
    "$out/supervisor" 240 "$out/supervisor.receipt" bash "$task/diagnostic-controller.sh" original > "$out/command.log" 2>&1 &
    supervisor=$!
    printf '%s\n' "$supervisor" > "$out/timeout.pid"
    (
        trap 'observer_exit=$?; printf "observer_exit=%s\n" "$observer_exit" > "$out/observer.status"' EXIT
        sampled=0
        printf '%s\n' 'stack_sample=skipped_not_reached' > "$out/parent-stack.status"
        for ((tick=0; tick<50; tick+=1)); do
            kill -0 "$supervisor" 2>/dev/null || break
            date --iso-8601=ns
            if [ -s "$out/compiler.pid" ]; then
                read -r compiler_pid < "$out/compiler.pid"
                if [ "$(readlink "/proc/$compiler_pid/exe" 2>/dev/null || true)" = "$src/build/compiler" ]; then
                    ps -p "$compiler_pid" --ppid "$compiler_pid" -o pid,ppid,pgid,stat,etime,time,comm,args || true
                    cat "/proc/$compiler_pid/stat" || true
                    cat "/proc/$compiler_pid/io" || true
                    cat "/proc/$compiler_pid/wchan" || true
                    ls -l "/proc/$compiler_pid/fd" || true
                    if [ "$tick" -ge 36 ] && [ "$sampled" -eq 0 ]; then
                        sampled=1
                        if command -v gdb >/dev/null; then
                            sample_status=0
                            timeout --kill-after=2s 8 gdb -nx -nh -q -batch \
                                -iex 'set auto-load off' -ex 'set follow-fork-mode parent' -ex 'set detach-on-fork on' \
                                -ex "attach $compiler_pid" -ex 'thread apply all bt 16' -ex detach -ex quit \
                                > "$out/parent-stack-sample.log" 2>&1 || sample_status=$?
                            printf 'stack_sample=attempted exit=%s\n' "$sample_status" > "$out/parent-stack.status"
                        else
                            printf '%s\n' 'stack_sample=unavailable_gdb' > "$out/parent-stack.status"
                        fi
                    fi
                fi
            fi
            sleep 5
        done
    ) > "$out/progress.log" 2>&1 &
    observer=$!
    command_status=0
    wait "$supervisor" || command_status=$?
    supervisor=
    finish_run
    ;;
*) exit 2 ;;
esac
