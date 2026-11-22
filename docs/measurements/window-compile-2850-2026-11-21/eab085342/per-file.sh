#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
d=$PWD
mkdir -p "$d/per-file"
cc="$d/../source-sparse-proof/build/compiler"
for mode in control producer; do
    wrapper="$d/per-file/$mode.sh"
    echo '#!/bin/bash' > "$wrapper"
    echo 'export BUSTER_CONTROL_SOURCE_NATIVE=1' >> "$wrapper"
    if [[ $mode = producer ]]; then echo 'export BUSTER_SOURCE_ARITHMETIC=1' >> "$wrapper"; else echo 'unset BUSTER_SOURCE_ARITHMETIC' >> "$wrapper"; fi
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
