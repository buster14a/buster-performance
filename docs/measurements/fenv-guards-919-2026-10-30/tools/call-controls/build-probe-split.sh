#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Explicit local-preprocess / remote-codegen / local-link diagnostic workflow.
# Private preprocessed files contain external system headers: publish hashes only.
set -euo pipefail
mode=${1:?usage: build-probe-split.sh prepare|link ...}
shift
source_dir=$(cd -- "$(dirname -- "$0")" && pwd)
compiler_sha=c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67
command_line()
{
    printf '%q ' "$@"
    printf '\n'
}
if [[ "$mode" = prepare ]]; then
    tree=$(realpath -- "${1:?prepare TREE OBJECTS NEW_OUTPUT OFFICIAL_CLANG ADAPTER REMOTE_DIRECTORY REMOTE_CLANG}")
    retained=$(realpath -- "${2:?}")
    output=${3:?}
    clang=$(realpath -- "${4:?}")
    adapter=$(realpath -- "${5:?}")
    remote=${6:?}
    remote_clang=${7:?}
    [[ "$remote" = /* && "$remote_clang" = /* ]]
    test ! -e "$output"
    mkdir -p "$output/private/control-root" "$output/private/probe-root" "$output/private/control" "$output/private/probe"
    output=$(realpath -- "$output")
    sha256sum "$clang" "$adapter" "$source_dir/build-probe-split.sh" "$retained/8.json" "$retained"/{0..40}.o \
        "$tree/src/buster/compiler/c_check_actions.c" "$tree/src/buster/compiler/c_checker.c" > "$output/before-prepare-tools.sha256"
    date -u '+before_adapter_utc=%Y-%m-%dT%H:%M:%SZ' > "$output/adapter-receipt.txt"
    printf '%s  %s\n' "$compiler_sha" "$clang" > "$output/expected-compiler.sha256"
    sha256sum --check "$output/expected-compiler.sha256" > "$output/compiler-check.txt"
    sed '$s/,$//' "$retained/8.json" > "$output/production-checker-command.json"
    jq -e '.file == "src/buster/compiler/main_unit_checker.c" and (.arguments | type == "array") and (.arguments | length > 5)' "$output/production-checker-command.json" > /dev/null
    mapfile -d '' original < <(jq -j '.arguments[] | . + "\u0000"' "$output/production-checker-command.json")
    test "${#original[@]}" -gt 5
    test "$(realpath -- "${original[0]}")" = "$clang"
    cp -a "$tree/src" "$output/private/control-root/src"
    cp -a "$tree/src" "$output/private/probe-root/src"
    "$adapter" "$tree/src/buster/compiler/c_check_actions.c" "$tree/src/buster/compiler/c_checker.c" \
        "$output/private/probe-root/src/buster/compiler/c_check_actions.c" "$output/private/probe-root/src/buster/compiler/c_checker.c" > "$output/adapter.log"
    sha256sum --check "$output/before-prepare-tools.sha256" > "$output/after-prepare-tools-check.txt"
    date -u '+after_adapter_utc=%Y-%m-%dT%H:%M:%SZ' >> "$output/adapter-receipt.txt"
    sha256sum "$clang" "$adapter" "$source_dir/build-probe-split.sh" "$retained/8.json" "$retained"/{0..40}.o > "$output/before-preprocess.sha256"
    find "$tree/src" "$output/private/control-root/src" "$output/private/probe-root/src" -type f -print0 | sort -z | xargs -0 sha256sum >> "$output/before-preprocess.sha256"
    date -u '+before_preprocess_utc=%Y-%m-%dT%H:%M:%SZ' > "$output/preprocess-receipt.txt"
    for variant in control probe; do
        preprocess=("$clang")
        codegen=("$remote_clang")
        outputs=0
        sources=0
        compiles=0
        languages=0
        for ((index=1; index<${#original[@]}; index++)); do
            argument=${original[index]}
            case "$argument" in
                -o)
                    index=$((index + 1))
                    test "$index" -lt "${#original[@]}"
                    preprocess+=(-o "$output/private/$variant/main_unit_checker.c")
                    codegen+=(-o "$remote/$variant.o")
                    outputs=$((outputs + 1))
                    ;;
                -c)
                    preprocess+=(-E)
                    codegen+=(-c)
                    compiles=$((compiles + 1))
                    ;;
                -xc)
                    preprocess+=(-xc)
                    codegen+=(-x cpp-output)
                    languages=$((languages + 1))
                    ;;
                -x)
                    index=$((index + 1))
                    test "${original[index]}" = c
                    preprocess+=(-x c)
                    codegen+=(-x cpp-output)
                    languages=$((languages + 1))
                    ;;
                src/buster/compiler/main_unit_checker.c)
                    preprocess+=("$argument")
                    codegen+=("$remote/$variant/main_unit_checker.c")
                    sources=$((sources + 1))
                    ;;
                *) preprocess+=("$argument"); codegen+=("$argument") ;;
            esac
        done
        test "$outputs" = 1
        test "$sources" = 1
        test "$compiles" = 1
        test "$languages" = 1
        # Macro expansion loses diagnostic-only source context in cpp-output.
        # Suppress those diagnostics only; exact control object/image gates below
        # must still prove that this split route preserves all production bytes.
        codegen+=(-w)
        printf '%s\0' "${preprocess[@]}" > "$output/$variant-preprocess.argv0"
        printf '%s\0' "${codegen[@]}" > "$output/$variant-codegen.argv0"
        (cd "$output/private/$variant-root" && "${preprocess[@]}") > "$output/$variant-preprocess.log" 2>&1
        read -r input_sha rest < <(sha256sum "$output/private/$variant/main_unit_checker.c")
        printf '%s  %s\n' "$compiler_sha" "$remote_clang" "$input_sha" "$remote/$variant/main_unit_checker.c" > "$output/expected-$variant-remote.sha256"
        {
            printf '#!/usr/bin/env bash\nset -euo pipefail\n'
            command_line cd "$remote"
            command_line sha256sum --check "$remote/expected-$variant-remote.sha256"
            command_line date -u "+${variant}_codegen_begin_utc=%Y-%m-%dT%H:%M:%SZ"
            printf '%q ' printf '%s\0' "${codegen[@]}"
            printf '> %q\n' "$remote/$variant-executed.argv0"
            command_line cmp "$remote/$variant-codegen.argv0" "$remote/$variant-executed.argv0"
            command_line "${codegen[@]}"
            command_line sha256sum --check "$remote/expected-$variant-remote.sha256"
            printf '%q ' sha256sum "$remote/$variant.o"
            printf '> %q\n' "$remote/$variant.o.sha256"
            command_line cat "$remote/$variant.o.sha256"
            command_line date -u "+${variant}_codegen_end_utc=%Y-%m-%dT%H:%M:%SZ"
        } > "$output/remote-$variant.sh"
        # The outer list is caller-frozen after generating the inner command.
        # It excludes the launch recipe so its hash can be embedded in that recipe.
        outer="$output/outer-$variant.sha256"
        : > "$outer"
        for suffix in "remote-$variant.sh" "expected-$variant-remote.sha256" "$variant-codegen.argv0"; do
            read -r identity rest < <(sha256sum "$output/$suffix")
            printf '%s  %s\n' "$identity" "$remote/$suffix" >> "$outer"
        done
        printf '%s  %s\n' "$input_sha" "$remote/$variant/main_unit_checker.c" "$compiler_sha" "$remote_clang" >> "$outer"
        read -r outer_sha rest < <(sha256sum "$outer")
        recipe='set -euo pipefail
expected=$1
outer=$2
job=$3
printf "%s  %s\n" "$expected" "$outer" | sha256sum --check
sha256sum --check "$outer"
bash "$job"
sha256sum --check "$outer"
printf "%s  %s\n" "$expected" "$outer" | sha256sum --check'
        launch=(/usr/bin/bash -c "$recipe" buster919-frozen-remote "$outer_sha" "$remote/outer-$variant.sha256" "$remote/remote-$variant.sh")
        printf '%s\0' "${launch[@]}" > "$output/launch-$variant.argv0"
        command_line "${launch[@]}" > "$output/launch-$variant.command"
    done
    date -u '+after_preprocess_utc=%Y-%m-%dT%H:%M:%SZ' >> "$output/preprocess-receipt.txt"
    sha256sum --check "$output/before-preprocess.sha256" > "$output/after-preprocess-check.txt"
    sha256sum "$output/private/control/main_unit_checker.c" "$output/private/probe/main_unit_checker.c" \
        "$output"/{control,probe}-codegen.argv0 "$output"/remote-{control,probe}.sh \
        "$output"/expected-{control,probe}-remote.sha256 "$output"/outer-{control,probe}.sha256 \
        "$output"/launch-{control,probe}.{argv0,command} > "$output/split-inputs.sha256"
    printf 'Prepared private cpp-output inputs and explicit remote commands; no codegen/remote job was launched.\n'
elif [[ "$mode" = link ]]; then
    output=$(realpath -- "${1:?link OUTPUT OBJECTS PRODUCTION_COMPILER OFFICIAL_CLANG}")
    retained=$(realpath -- "${2:?}")
    production=$(realpath -- "${3:?}")
    clang=$(realpath -- "${4:?}")
    printf '%s  %s\n' "$compiler_sha" "$clang" | sha256sum --check > "$output/link-compiler-check.txt"
    sha256sum --check "$output/before-prepare-tools.sha256" > "$output/prepare-tools-before-link-check.txt"
    sha256sum --check "$output/before-preprocess.sha256" > "$output/preprocess-inputs-before-link-check.txt"
    sha256sum --check "$output/split-inputs.sha256" > "$output/split-inputs-before-link-check.txt"
    test -s "$output/control.o"
    test -s "$output/probe.o"
    for variant in control probe; do
        read -r object_sha remainder < "$output/$variant.o.sha256"
        [[ "$object_sha" =~ ^[0-9a-f]{64}$ ]]
        printf '%s  %s\n' "$object_sha" "$output/$variant.o" | sha256sum --check > "$output/$variant-transfer-check.txt"
    done
    cmp "$retained/8.o" "$output/control.o"
    printf 'Unmodified split-control object is byte-identical to retained production8.o.\n' > "$output/zero-identity.txt"
    wild=$(command -v ld.wild)
    "$wild" --help > "$output/wild-help.txt"
    link_flags=(-no-pie -fuse-ld=wild)
    # Run linking through cores; Wild's explicit thread flags change image bytes.
    # Preserve the ordinary production arguments for the mandatory exact gate.
    sha256sum "$clang" "$wild" "$production" "$retained"/{0..40}.o "$output/control.o" "$output/probe.o" \
        "$source_dir/build-probe-split.sh" > "$output/before-local-link.sha256"
    for variant in control probe; do
        objects=()
        for index in {0..40}; do
            if [[ "$index" = 8 ]]; then objects+=("$output/$variant.o"); else objects+=("$retained/$index.o"); fi
        done
        link=("$clang" "${link_flags[@]}" "${objects[@]}" -lm -ldl -o "$output/compiler-$variant")
        printf '%s\0' "${link[@]}" > "$output/$variant-link.argv0"
        "${link[@]}" > "$output/$variant-link.log" 2>&1
        if [[ "$variant" = control ]]; then
            cmp "$production" "$output/compiler-control"
            printf 'Unmodified split-control image is byte-identical to ordinary production compiler.\n' >> "$output/zero-identity.txt"
        fi
    done
    sha256sum --check "$output/before-local-link.sha256" > "$output/after-local-link-check.txt"
    sha256sum "$retained/8.o" "$output/control.o" "$production" "$output/compiler-control" "$output/probe.o" "$output/compiler-probe" > "$output/built.sha256"
    printf 'Both exact zero-identity gates passed; diagnostic probe linked with40 retained objects. Never time this probe.\n'
else
    printf 'Unknown split-build phase.\n' >&2
    exit 1
fi
