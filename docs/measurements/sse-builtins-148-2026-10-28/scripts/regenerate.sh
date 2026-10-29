#!/usr/bin/env bash
# #148's SSE builtins: the own-main inventory regenerated from the pinned clang 23.1.1 inputs, as #619 did. Each
# build and generation takes its own hold of the host's lock; every exit status and digest goes to receipts.txt.
set -uo pipefail
cd "$(dirname "$0")"
lock()
{
    EXCLUSIVE_OWNER=claude-sse-148 EXCLUSIVE_TITLE="#148 SSE builtins: own-main inventory" \
    EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/148#issuecomment-6482945766 \
    ~/buster-fast-bench/exclusive.sh "$@"
}
base=(--builtins /usr/include/clang/Basic/Builtins.inc --x86 /usr/include/clang/Basic/BuiltinsX86.inc
      --x86-64 /usr/include/clang/Basic/BuiltinsX86_64.inc --version /usr/include/clang/Basic/Version.inc)
{
    echo "date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "host: $(uname -a)"
    echo "clang: $(clang --version | head -1)"
    echo "package: $(pacman -Q clang)"
    sha256sum /usr/bin/clang /usr/include/clang/Basic/Builtins.inc /usr/include/clang/Basic/BuiltinsX86.inc \
              /usr/include/clang/Basic/BuiltinsX86_64.inc /usr/include/clang/Basic/Version.inc \
              tools/clang_builtin_metadata.c docs/builtin-metadata/own-main.names.txt
} > receipts.txt
(cd tools && lock clang -std=c17 -O2 -march=native -Wall -Wextra -Werror -pedantic clang_builtin_metadata.c -o clang_builtin_metadata) 2> build.stderr
echo "build status $?" >> receipts.txt
sha256sum tools/clang_builtin_metadata >> receipts.txt
lock tools/clang_builtin_metadata "${base[@]}" --format c > full.inc 2> full.stderr
echo "full catalogue status $?" >> receipts.txt
lock tools/clang_builtin_metadata "${base[@]}" --names docs/builtin-metadata/own-main.names.txt > own-main.tsv 2> tsv.stderr
echo "own-main tsv status $?" >> receipts.txt
lock tools/clang_builtin_metadata "${base[@]}" --names docs/builtin-metadata/own-main.names.txt --format c > own-main.inc 2> inc.stderr
echo "own-main c status $?" >> receipts.txt
sha256sum full.inc own-main.tsv own-main.inc >> receipts.txt
echo done >> receipts.txt
