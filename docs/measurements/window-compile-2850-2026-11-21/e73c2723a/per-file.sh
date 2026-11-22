#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
d=$PWD
if [[ ! -s "$d/operand-oracle/complete" ]]; then python3 "$d/mutate-operands.py"; fi
mkdir -p "$d/per-file"
cc="$d/../main-typed-reserve/build/compiler"
for mode in control producer; do
    wrapper="$d/per-file/$mode.sh"
    echo '#!/bin/bash' > "$wrapper"
    if [[ $mode = control ]]; then cc="$d/../main-typed-reserve-base/build/compiler"; else cc="$d/../main-typed-reserve/build/compiler"; fi
    printf 'exec %q "$@"\n' "$cc" >> "$wrapper"
    chmod +x "$wrapper"
done
cd "$d/../switch-inputs"
source ../switch-local-args.sh
source_tree=$PWD/../pregraph-warning-study/compiler-source
main_arguments="-march=native -I$source_tree/src -fwrapv -funsigned-char --predefines $PWD/../proof-predefines.h $source_tree/src/buster/compiler/main.c"
for group in sqlite main lua musl; do
    key=${group}_arguments
    eval "args=(${!key})"
    python3 "$d/pair-output.py" "$d/per-file" "$group" "$d/per-file/control.sh" "$d/per-file/producer.sh" "${args[@]}"
done
