set -e
o='/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-absolute-dump'
s='/home/david/buster-fast-bench/codex-421-prototype-tail-color512'
mkdir "$o"
printf '%s
' '939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae  /usr/bin/clang' '8446253a800c27c5312e85fc95288ddc1b965a7f2f6b5805255eb8323daf9c51  /usr/bin/wild' | sha256sum -c - > "$o/tool-identities.log"
cd "$s"
sha256sum -c '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/prototype-tail-color512-inputs/raw/prototype-tail-color512-source-files.sha256' > "$o/source-identities.log"
env -u CPATH -u C_INCLUDE_PATH LC_ALL=C /usr/bin/clang -std=gnu17 -O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I src --ld-path=/usr/bin/wild '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/template-dump.c' -o "$o/template-dump" > "$o/build.log" 2>&1
taskset -c 2 "$o/template-dump" "$o/templates.bin" > "$o/dump.log"
test "$(wc -c < "$o/templates.bin")" -eq 16035840
cmp "$o/templates.bin" '/home/david/buster-fast-bench/codex-180-fix-20261026-evidence/templates-hybrid.bin'
sha256sum "$o/templates.bin" >> "$o/dump.log"
printf 'absolute_compiler=0
absolute_linker=0
exact_length=16035840
cmp=0
exit=0
' > "$o/steps.txt"
tar -cf - -C "$o" build.log dump.log tool-identities.log source-identities.log steps.txt
