#!/usr/bin/env bash
set -uo pipefail
case_dir=${1:?case directory}
before=${2:?pre-review compiler}
after=${3:?review-fix compiler}
oracle=${4:-clang}
failed=0
printf 'compiler\tshape\tstatus\texpected\n'
for variant in before after clang; do
    case "$variant" in
        before) executable="$before"; expected=0 ;;
        after) executable="$after"; expected=1 ;;
        clang) executable="$oracle"; expected=1 ;;
    esac
    for shape in scalar array record nested; do
        env -u CPATH -u C_INCLUDE_PATH "$executable" -fsyntax-only -std=gnu17 "$case_dir/$shape.c" \
            > "$case_dir/logs/$variant-$shape.out" 2> "$case_dir/logs/$variant-$shape.err"
        probe_status=$?
        printf '%s\t%s\t%s\t%s\n' "$variant" "$shape" "$probe_status" "$expected"
        if [[ "$probe_status" != "$expected" ]]; then failed=1; fi
    done
done
exit "$failed"
