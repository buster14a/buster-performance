set -e
i='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-phase-inputs'
o='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-phase-qualification'
s='/home/david/buster-fast-bench/codex-421-template-phase'
mkdir "$i" "$o"
tar -xf - -C "$i"
printf '%s
' 'f27ee5f937abbad78b07b4523576aeac38517b4a45e50f0e832b0ee319c2a891  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-phase-inputs/source-full.tar' '9140931571eec4b0c2311204325f070ba763e36d7b4a59b57a57d10b401d37ed  /home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-phase-inputs/raw/template-phase-source-files.sha256' | sha256sum -c - > "$o/input-identities.log"
printf '%s
' '939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae  /usr/bin/clang' '8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51  /usr/bin/wild' | sha256sum -c - > "$o/tool-identities.log"
mkdir "$s"
tar -xf "$i/source-full.tar" -C "$s"
cd "$s"
sha256sum -c "$i/raw/template-phase-source-files.sha256" > "$o/source-identities.log"
clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I src -fuse-ld=wild phase-probe.c -o phase-probe > "$o/build.log" 2>&1
taskset -c 2 ./phase-probe --verify > "$o/verify.log" 2>&1
sha256sum phase-probe > "$o/binary-identity.sha256"
size -A phase-probe > "$o/sizes.log"
readelf -Ws phase-probe > "$o/symbols.txt"
objdump -d --no-show-raw-insn -Mintel --disassemble=x86_encode_16 phase-probe > "$o/encoder.dis"
printf 'build=0
verify=0
exit=0
' > "$o/steps.txt"
tar -cf - -C "$o" .
