#!/bin/bash
# selfbuild.sh LABEL: the compiler built by results/LABEL/compiler from trees/head2's sources, as the self-host
# qualification's bootstrap does it (tools/ci/selfhost.c): each unit by COMPILER --lanes 1 FLAGS -c -o OBJECT SOURCE, the
# flags Release's without debug information (BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release), and
# the objects linked by clang (-no-pie, -lm, -ldl, -lpthread). The sources are head's for every LABEL, so that two
# labels' self-built compilers differ by the code Tier 0 wrote for them alone. One hold of the lock for the lists, the
# compiles and the link. results/LABEL/selfbuilt, selfbuild.log and the lists in results/LABEL/selfbuild/.
set -u
cd "$(dirname "$0")"
label=$1
out=$PWD/results/$label
tree=$PWD/trees/head2
rm -rf "$out/selfbuild" "$out/selfbuilt"
mkdir -p "$out/selfbuild"
cat > "$out/selfbuild/run.sh" <<RUN
#!/bin/bash
set -eu
cd "$tree"
./build.sh print-sources > "$out/selfbuild/sources.argv"
BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags --config Release > "$out/selfbuild/flags.argv"
mapfile -d '' -t sources < "$out/selfbuild/sources.argv"
mapfile -d '' -t flags < "$out/selfbuild/flags.argv"
objects=()
start=\$(date +%s%N)
for i in "\${!sources[@]}"; do
    object=\$(printf '%s/selfbuild/unit-%04d.o' "$out" "\$i")
    taskset -c 2 "$out/compiler" --lanes 1 "\${flags[@]}" -c -o "\$object" "\${sources[\$i]}"
    objects+=("\$object")
done
echo "units \${#sources[@]} compiled in \$(( (\$(date +%s%N) - start) / 1000000 )) ms"
clang -no-pie "\${objects[@]}" -lm -ldl -lpthread -o "$out/selfbuilt"
size "$out/selfbuilt"
RUN
chmod +x "$out/selfbuild/run.sh"
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200; $out/selfbuild/run.sh" > "$out/selfbuild.log" 2>&1
echo "status $?" >> "$out/selfbuild.log"
rm -f "$out"/selfbuild/unit-*.o
test -x "$out/selfbuilt" && sha256sum "$out/selfbuilt" > "$out/selfbuilt.sha256"
tail -4 "$out/selfbuild.log"
