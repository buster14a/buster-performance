#!/usr/bin/env bash
# objects.sh TREE: TREE's sources compiled as build.sh compiles them, without -g (BUSTER_DEBUG_INFO=0), into
# TREE/objects/INDEX.o, but main_unit_checker.c, which goes to TREE/objects/checker.s, and with
# -falign-functions=64 to TREE/objects/checker-align64.s. Run under the lock (8 compiles at once).
set -e
cd "$1"
eval "$(sed -n '/^sources=/p;/^sources+=/p;/^flags=/p' build.sh)"
mkdir -p objects
for i in "${!sources[@]}"; do
    case "${sources[$i]}" in
        */main_unit_checker.c)
            echo "clang -S ${sources[$i]} -o objects/checker.s ${flags[*]} -O3"
            echo "clang -S ${sources[$i]} -o objects/checker-align64.s ${flags[*]} -O3 -falign-functions=64"
            echo "clang -c ${sources[$i]} -o objects/checker-direct.o ${flags[*]} -O3" ;;
        *) echo "clang -c ${sources[$i]} -o objects/$i.o ${flags[*]} -O3" ;;
    esac
done | xargs -P 8 -I{} sh -c '{}'
for i in "${!sources[@]}"; do
    case "${sources[$i]}" in */main_unit_checker.c) echo "$i" > objects/checker.index ;; esac
done
echo "${#sources[@]}" > objects/count
