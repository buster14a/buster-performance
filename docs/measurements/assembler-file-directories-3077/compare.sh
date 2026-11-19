#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Run paired normal-entry-point checks. Only the two counted executables contain probes.
set -euo pipefail
export LC_ALL=C
if [[ $# != 6 ]]; then
    echo 'usage: bash compare.sh BASE HEAD COUNTED_BASE COUNTED_HEAD SOURCE_TREE OUTPUT_DIR' >&2
    exit 2
fi
script_dir=$(cd -- "$(dirname -- "$0")" && pwd)
base=$(realpath "$1")
head=$(realpath "$2")
bc=$(realpath "$3")
hc=$(realpath "$4")
src=$(realpath "$5")
mkdir -p "$6"
cd "$6"
mkdir -p inputs objects dumps
cc -std=c17 -O2 -Wall -Wextra -Werror "$script_dir/make-inputs.c" -o ./make-inputs
bash "$script_dir/cases.sh" inputs ./make-inputs
out=$PWD
for tool in gcc clang; do
    flags=()
    if [[ $tool == clang ]]; then flags+=(-fno-integrated-as); fi
    (cd "$src" && "$tool" -gdwarf-5 -O2 -march=x86-64 -fcf-protection=none -fno-ident \
        -fdebug-prefix-map="$src"=/src -S "${flags[@]}" examples/assembler/program-storage.c -o "$out/inputs/$tool-storage.s")
done
printf 'input\tbuild\tlookups\tcandidates\tfull_compares\thashes\tbucket_probes\tclear_bytes\tarena_bytes\n' > counts.tsv
printf 'input\tbuster_status\tgas_status\tgas_elf_bytes\tgas_line_comparison\n' > comparisons.tsv
: > objects.sha256
printf 'existing output\n' > sentinel
function capture {
    local o=$1 prefix=$2 section
    readelf -W --debug-dump=rawline "$o" > "$prefix.raw" 2>"$prefix.raw.err"
    readelf -W --debug-dump=decodedline "$o" > "$prefix.decoded" 2>"$prefix.decoded.err"
    readelf -Wr "$o" | awk '/^Relocation section/ {keep=($3=="\047.rela.debug_line\047"); next} keep && $1 ~ /^[0-9a-f]+$/ {print $1,$3,$5,$6,$7}' > "$prefix.reloc"
    readelf -SW "$o" > "$prefix.sections"
    for section in .text .debug_line .debug_line_str; do
        if awk -v s="$section" '{for (i=1; i<=NF; ++i) if ($i==s) seen=1} END {exit !seen}' "$prefix.sections"; then
            objcopy --dump-section "$section=$prefix$section" "$o" /dev/null
        else
            printf 'section absent\n' > "$prefix$section"
        fi
    done
}
for input in inputs/*.s; do
    name=$(basename "$input" .s)
    prefix=objects/$name
    for kind in base head bc hc; do
        tool=${!kind}
        cp sentinel "$prefix.$kind.o"
        status=0
        "$tool" assemble -o "$prefix.$kind.o" "$input" > "$prefix.$kind.out" 2>"$prefix.$kind.err" || status=$?
        grep -v '^DIR_COUNTS ' "$prefix.$kind.err" > "$prefix.$kind.diag" || true
        if [[ $kind == base ]]; then original=$status; fi
        [[ $status == "$original" ]]
        cmp "$prefix.base.out" "$prefix.$kind.out"
        cmp "$prefix.base.diag" "$prefix.$kind.diag"
        cmp "$prefix.base.o" "$prefix.$kind.o"
        if [[ $status != 0 ]]; then cmp sentinel "$prefix.$kind.o"; fi
    done
    if [[ $name == bad-* ]]; then [[ $original == 1 ]]; else [[ $original == 0 ]]; fi
    arena_base=-
    if [[ $original == 0 ]]; then
        sha256sum "$prefix.base.o" >> objects.sha256
        for kind in base head; do
            tool=${!kind}
            capture "$prefix.$kind.o" "dumps/$name.$kind"
            "$tool" assemble --timing -o "$prefix.timing.o" "$input" 2> "$prefix.tmp"
            arena=$(sed -En 's/^assembly: .*arena_bytes=([0-9]+) .*/\1/p' "$prefix.tmp")
            [[ $arena =~ ^[0-9]+$ ]]
            if [[ $kind == base ]]; then arena_base=$arena; fi
            [[ $arena == "$arena_base" ]]
            cmp "$prefix.$kind.o" "$prefix.timing.o"
            rm "$prefix.tmp" "$prefix.timing.o"
        done
        for suffix in raw decoded reloc raw.err decoded.err; do
            cmp "dumps/$name.base.$suffix" "dumps/$name.head.$suffix"
        done
    fi
    for kind in bc hc; do
        read -ra fields <<< "$(sed -n 's/^DIR_COUNTS //p' "$prefix.$kind.err")"
        if [[ ${#fields[@]} == 0 ]]; then fields=(0 0 0 0 0 0); fi
        [[ ${#fields[@]} == 6 ]]
        printf '%s\t%s' "$name" "$kind" >> counts.tsv
        printf '\t%s' "${fields[@]}" "$arena_base" >> counts.tsv
        printf '\n' >> counts.tsv
    done
    flags=(--64 --nocompress-debug-sections)
    case "$name" in dwarf3|no-file|clang-storage|gcc-storage) ;; *) flags+=(--gdwarf-5);; esac
    gas=0
    as "${flags[@]}" -o "$prefix.gas.o" "$input" 2>"$prefix.gas.err" || gas=$?
    whole=-
    line=-
    if [[ $gas == 0 && $original == 0 ]]; then
        capture "$prefix.gas.o" "dumps/$name.gas"
        whole=different
        if cmp -s "$prefix.base.o" "$prefix.gas.o"; then whole=identical; fi
        line=identical
        for suffix in raw decoded reloc text debug_line debug_line_str; do
            if ! cmp -s "dumps/$name.base.$suffix" "dumps/$name.gas.$suffix"; then line=different; fi
        done
    fi
    case "$name" in
        bad-zero) [[ $gas == 0 ]];;
        bad-*) [[ $gas != 0 ]];;
        fill-explicit|fill-implicit) [[ $gas != 0 ]];;
        late-fill-implicit)
            [[ $line == different ]]
            awk '/The Directory Table/ {d=1; next} d && $1=="0" {good=$NF=="d07/"; exit} END {exit !good}' "dumps/$name.base.raw"
            awk '/The Directory Table/ {d=1; next} d && $1=="0" {good=$NF=="d07//"; exit} END {exit !good}' "dumps/$name.gas.raw"
            ;;
        *) [[ $gas == 0 && $line == identical ]] || { echo "GNU comparison failed: $name ($gas, $line)" >&2; exit 1; };;
    esac
    printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$original" "$gas" "$whole" "$line" >> comparisons.tsv
done
awk -F '\t' '
    $1=="distinct-2048" && $2=="bc" {base_ok=($3==2048 && $5==2096128)}
    $1=="distinct-2048" && $2=="hc" {head_ok=($3==2048 && $5<8192 && $6>0 && $7>=$6 && $8>0)}
    $1=="repeated-2048" && $2=="hc" {small_ok=($5==4093 && $6==0 && $7==0 && $8==0)}
    END {exit !(base_ok && head_ok && small_ok)}
' counts.tsv
cat comparisons.tsv
