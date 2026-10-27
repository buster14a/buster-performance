#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
set -uo pipefail
case_dir=${1:?case directory}
compiler=${2:?compiler executable}
oracle=${3:-clang}
mkdir -p "$case_dir/logs"
failed=0
printf 'compiler\tshape\tpolicy\tstatus\texpected\n'
for route in clang vector scalar; do
    executable=$compiler
    schedule=()
    case "$route" in
        clang) executable=$oracle ;;
        scalar) schedule=(--scalar) ;;
    esac
    for shape in direct compound nonconstant; do
        for policy in default quiet; do
            flags=()
            expected=1
            if [[ $policy == quiet ]]; then
                flags=(-w)
                if [[ $shape != nonconstant ]]; then expected=0; fi
            fi
            env -u CPATH -u C_INCLUDE_PATH "$executable" "${schedule[@]}" \
                -fsyntax-only -std=gnu17 "${flags[@]}" "$case_dir/$shape.c" \
                > "$case_dir/logs/cli-$route-$shape-$policy.out" \
                2> "$case_dir/logs/cli-$route-$shape-$policy.err"
            probe_status=$?
            printf '%s\t%s\t%s\t%s\t%s\n' "$route" "$shape" "$policy" "$probe_status" "$expected"
            if [[ $probe_status != "$expected" ]]; then failed=1; fi
        done
    done
done
exit "$failed"
