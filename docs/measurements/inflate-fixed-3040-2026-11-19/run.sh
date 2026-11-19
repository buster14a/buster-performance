#!/usr/bin/env bash
set -euo pipefail
tools=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d)
export BUSTER_TOOLCHAIN=path
clang --version
git rev-parse HEAD
printf 'host=%s sanitizer=%s linker=%s debug=%s\n' "$BUSTER_HOST_ARCH" "$BUSTER_SANITIZER" "$BUSTER_LINKER" "$BUSTER_DEBUG_INFO"
clang -O2 -gdwarf-4 -ffile-prefix-map="$PWD"=. -fno-pie -fno-stack-protector -fno-asynchronous-unwind-tables -c zlib/adler32.c -o "$work/adler.raw.o"
llvm-objcopy --compress-debug-sections=zlib "$work/adler.raw.o" "$work/adler.o"
cat > "$work/start.s" <<'ASM'
.text
.globl _start
_start:
    mov $1, %edi
    lea input(%rip), %rsi
    mov $3, %edx
    call adler32
    cmp $0x024d0127, %eax
    setne %dil
    movzbl %dil, %edi
    mov $60, %eax
    syscall
.section .rodata
input: .ascii "abc"
.section .note.GNU-stack,"",@progbits
ASM
clang -c "$work/start.s" -o "$work/start.o"
sha256sum "$work/adler.o"
for rev in base head; do
    if [[ $rev == head ]]; then
        head=4fcc52d74b68ac2b60f638deb43793d4bf559dac
        if ! git cat-file -e "$head^{commit}" 2>/dev/null; then
            git fetch --no-tags --depth=1 origin "$head"
        fi
        git switch --detach "$head"
    fi
    echo "=== $rev ==="
    git rev-parse HEAD
    bash "$tools/count.sh" "$work" "$rev"
    ./build.sh --config Release --jobs "$(nproc)" > "$work/build.log" 2>&1 || { tail -90 "$work/build.log"; exit 1; }
    ./build/compiler test-inflate
    ./build/compiler link-foreign -static -e _start -o "$work/$rev.exe" "$work/start.o" "$work/adler.o"
    "$work/$rev.exe"
    llvm-dwarfdump --verify "$work/$rev.exe"
    sha256sum "$work/$rev.exe"
done
if [[ -f "$work/head.exe" ]]; then
    cmp "$work/base.exe" "$work/head.exe"
    cmp "$work/base.classes" "$work/head.classes"
    echo "Base/head linked ELF and classifier records match byte for byte."
fi
