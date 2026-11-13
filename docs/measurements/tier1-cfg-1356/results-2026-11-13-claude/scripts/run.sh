#!/bin/bash
set -euo pipefail
export LC_ALL=C TZ=UTC
work="$HOME/buster-fast-bench/1356-claude"
packet="$HOME/buster-fast-bench/1356-claude-packet"
revision=b7a95eedbe16fbd8434654f192f8f7aab76c56e5
test ! -e "$work"
mkdir -p "$work"/{logs,inputs,drivers,objects,bin,raw}
git clone https://github.com/buster14a/buster.git "$work/compiler"
git -C "$work/compiler" checkout --detach "$revision"
test "$(git -C "$work/compiler" rev-parse HEAD)" = "$revision"
echo a35c9fd0cc7bfe9cbc1f4e48771782034421b562 > "$work/evidence-revision.txt"
git -C "$work/compiler" rev-parse HEAD > "$work/compiler-revision.txt"
git -C "$work/compiler" status --porcelain > "$work/compiler-status.txt"
test ! -s "$work/compiler-status.txt"
export EXCLUSIVE_OWNER=claude-1356
export EXCLUSIVE_TITLE='Tier 1 switch and label-table scaling (#1356)'
export EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxng6adVZSsrqxaH43pJ
export CORES_TITLE="$EXCLUSIVE_TITLE" CORES_LINK="$EXCLUSIVE_LINK"

# One lock hold per command: the timeout limits execution after acquisition.
# Both busy snapshots are inside the hold; keep exclusive.sh's own stderr too.
locked()
{
    local log=$1 seconds=$2
    shift 2
    "$HOME/buster-fast-bench/exclusive.sh" bash -c '
        seconds=$1
        shift
        date -u +%FT%TZ
        printf "command:"
        printf " %q" "$@"
        printf "\n"
        cat /var/lib/buster-9700x/owner
        cat /proc/loadavg
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
        run_status=0
        timeout -k 5 "$seconds" "$@" || run_status=$?
        cat /proc/loadavg
        ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head
        date -u +%FT%TZ
        printf "exit=%s\n" "$run_status"
        exit "$run_status"
    ' _ "$seconds" "$@" > "$log" 2>&1
}

cd "$work/compiler"
{
    uname -srvm
    LC_ALL=C lscpu
    clang --version
    cmake --version
    ninja --version
    cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
    cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference
    cat /sys/kernel/mm/transparent_hugepage/enabled
} > "$work/host.txt"
grep -Fq 'AMD Ryzen 7 9700X' "$work/host.txt"
build_command=(env BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_FUZZ_AVAILABLE=0 BUSTER_PGO=0 ./build.sh --config Release --jobs 4)
if command -v cores > /dev/null; then
    build_command=(cores -n 4 -- "${build_command[@]}")
fi
locked "$work/logs/build.log" 480 "${build_command[@]}"
compiler="$work/compiler/build/compiler"
cp "$work/compiler/build/compile_commands.json" "$work/compile_commands.json"
cp "$work/compiler"/build/cmake/*/CMakeCache.txt "$work/CMakeCache.txt"
locked "$work/logs/build-generator.log" 60 clang -std=c17 -O2 -Wall -Wextra -Werror "$packet/generate.c" -o "$work/bin/generate"

for shape in switch label-table; do
    for n in 4000 8000 16000; do
        "$work/bin/generate" "$shape" "$n" > "$work/inputs/$shape-$n.c"
        "$work/bin/generate" "$shape" "$n" --driver > "$work/drivers/$shape-$n.c"
    done
done
sha256sum "$compiler" "$work/bin/generate" "$packet/generate.c" "$work"/inputs/*.c "$work"/drivers/*.c > "$work/identities.sha256"
check_report()
{
    awk -F '\t' '
        $1 == "tier1" {
            reports++
            for (i = 2; i <= NF; i++) {
                split($i, field, "=")
                values[field[1]] = field[2]
            }
            good = values["functions"] == "1" && values["requested"] == "1" &&
                   values["admitted"] == "1" && values["compiled"] == "1" &&
                   values["unsupported"] == "0" && values["resource_failures"] == "0" &&
                   values["internal_failures"] == "0" && values["fallbacks"] == "0"
        }
        END { exit !(reports == 1 && good) }
    ' "$1"
}

for shape in switch label-table; do
    for n in 4000 8000 16000; do
        name="$shape-$n"
        locked "$work/logs/verify-$name.log" 120 taskset -c 2 "$compiler" -std=gnu17 --lanes 1 --tier1 --tier1-strict --tier1-report --verify -c "$work/inputs/$name.c" -o "$work/objects/$name.o"
        check_report "$work/logs/verify-$name.log"
        locked "$work/logs/link-$name.log" 60 clang -std=c17 -O2 -Wall -Wextra -Werror -no-pie "$work/drivers/$name.c" "$work/objects/$name.o" -o "$work/bin/$name"
        locked "$work/logs/run-$name.log" 60 taskset -c 2 "$work/bin/$name"
        sha256sum "$work/objects/$name.o" "$work/bin/$name" >> "$work/qualified.sha256"
    done
done
points=(switch:4000 switch:8000 switch:16000 label-table:4000 label-table:8000 label-table:16000)
printf 'sample\tshape\tn\treport\n' > "$work/samples.tsv"
shopt -s nullglob
for round in 0 1 2 3 4 5 6 7 8 9; do
    sample=$round
    if [ "$round" -eq 0 ]; then sample=warmup; fi
    for offset in 0 1 2 3 4 5; do
        point=${points[$(((round + offset) % 6))]}
        shape=${point%:*}
        n=${point#*:}
        pair="$work/raw/$sample/$shape-$n"
        mkdir -p "$pair"
        locked "$pair/run.log" 60 taskset -c 2 "$compiler" measure-compile --runs 1 --warmups 0 --directory "$pair" --keep -- -std=gnu17 --lanes 1 --tier1 --tier1-strict --tier1-report -c "$work/inputs/$shape-$n.c"
        reports=("$pair"/measure-compile-*/errors.txt)
        test "${#reports[@]}" -eq 1
        check_report "${reports[0]}"
        # Tie the measured code to the separately verified and executed object.
        cmp "$work/objects/$shape-$n.o" "${reports[0]%/errors.txt}/default.o"
        sha256sum "${reports[0]%/errors.txt}"/*.o >> "$work/measured-objects.sha256"
        printf '%s\t%s\t%s\t%s\n' "$sample" "$shape" "$n" "${reports[0]}" >> "$work/samples.tsv"
    done
done
sha256sum -c "$work/identities.sha256" > "$work/identities-after.log"
sha256sum -c "$work/qualified.sha256" > "$work/qualified-after.log"

echo CAMPAIGN-DONE
