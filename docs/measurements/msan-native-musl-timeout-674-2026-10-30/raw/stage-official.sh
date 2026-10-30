#!/usr/bin/env bash
# Task-private official toolchain preparation only. No source build or diagnostic.
# Run after review, with the owner's cores budget and an outer staging deadline.
set -euo pipefail
umask 077

task_root=$(cd -- "$(dirname -- "$0")" && pwd -P)
expected_task_root=/home/david/Documents/Codex/2026-10-30/tak/work/msan-native-corpus-timeout-20261030
test "$task_root" = "$expected_task_root"

version=23.1.4
archive=LLVM-$version-Linux-X64
archive_digest=efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378
license_digest=8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee
release_commit=7a941dfb2877a0b8cf30323fefa85ad019e0b0f5
destination="$task_root/official-23.1.4"
downloads="$task_root/setup-downloads"

mkdir -p "$downloads"
test "$(realpath -e "$downloads")" = "$downloads"
exec 9>"$downloads/staging.lock"
flock 9

attempt=$(mktemp -d "$downloads/attempt.XXXXXXXX")
receipts="$attempt/receipts"
mkdir "$receipts"
exec 3>&1
printf 'staging_receipts=%s\n' "$receipts" >&3
exec >"$receipts/stage.log" 2>&1
finish()
{
    stage_exit=$?
    trap - EXIT
    printf 'stage_exit=%s\n' "$stage_exit" >"$receipts/exit.txt"
    date -u +'%Y-%m-%dT%H:%M:%SZ' >"$receipts/finished-utc.txt"
    printf 'stage_exit=%s staging_receipts=%s\n' "$stage_exit" "$receipts" >&3
    exit "$stage_exit"
}
trap finish EXIT

test "$(uname -s)" = Linux
test "$(uname -m)" = x86_64
test ! -e "$destination"
test ! -L "$destination"
for tool in curl tar zstd sha256sum realpath find sort xargs flock; do
    command -v "$tool"
done
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH LD_PRELOAD LD_LIBRARY_PATH

{
    date -u +'%Y-%m-%dT%H:%M:%SZ'
    printf 'scope=private_official_toolchain_staging_only\n'
    printf 'recipe_source_commit=674ae159503b4b51f2c54865d9cfdd225e9d27a0\n'
    printf 'recipe_source_path=tools/ci/setup-hosted.sh\n'
    printf 'recipe_source_blob=01420cdcf08c6a8e54e3e5a285e52d3b01f55a3c\n'
    printf 'recipe_source_sha256=43851b66eaf8dc7c7e04a924f4d1ccc2753a291471ce23cabbfa8fc126094d04\n'
    printf 'archive_digest=%s\nlicense_digest=%s\nrelease_commit=%s\n' "$archive_digest" "$license_digest" "$release_commit"
    printf 'task_root=%s\ndestination=%s\nattempt=%s\n' "$task_root" "$destination" "$attempt"
    printf 'CORES_HELD=%s\nCORES=%s\n' "${CORES_HELD:-}" "${CORES:-}"
    sha256sum "$task_root/stage-official.sh"
    df -h "$task_root"
    df -i "$task_root"
} >"$receipts/preflight.txt"

archive_path="$attempt/$archive.tar.zst"
curl --fail --location --retry 3 --connect-timeout 30 --max-time 900 --silent --show-error \
    "https://github.com/llvm/llvm-project/releases/download/llvmorg-$version/$archive.tar.zst" \
    --output "$archive_path"
printf '%s  %s\n' "$archive_digest" "$archive_path" >"$receipts/archive.sha256"
sha256sum --check "$receipts/archive.sha256" >"$receipts/archive-check.txt"
sha256sum "$archive_path" >"$receipts/archive-actual.sha256"

tree="$attempt/tree"
mkdir "$tree"
tar -I 'zstd -d --long=30' --extract --file "$archive_path" \
    --directory "$tree" --strip-components=1 --no-same-owner --wildcards \
    "$archive/bin/clang" "$archive/bin/clang-23" "$archive/bin/clang++" \
    "$archive/bin/lld" "$archive/bin/ld.lld" "$archive/bin/llvm-config" \
    "$archive/bin/llvm-dwarfdump" "$archive/bin/llvm-readobj" "$archive/bin/llvm-symbolizer" \
    "$archive/include/*" "$archive/lib/clang/23/*" "$archive/lib/libclang-cpp.so*"

license_path="$attempt/LICENSE.TXT"
curl --fail --location --retry 3 --connect-timeout 30 --max-time 120 --silent --show-error \
    "https://raw.githubusercontent.com/llvm/llvm-project/$release_commit/llvm/LICENSE.TXT" \
    --output "$license_path"
printf '%s  %s\n' "$license_digest" "$license_path" >"$receipts/license.sha256"
sha256sum --check "$receipts/license.sha256" >"$receipts/license-check.txt"
cp "$license_path" "$tree/LICENSE.TXT"

test "$(LD_LIBRARY_PATH="$tree/lib" "$tree/bin/clang" -dumpversion)" = "$version"
test "$(LD_LIBRARY_PATH="$tree/lib" "$tree/bin/llvm-config" --version)" = "$version"
test -f "$tree/lib/clang/23/include/immintrin.h"
test -f "$tree/lib/clang/23/include/sanitizer/msan_interface.h"
test -f "$tree/lib/libclang-cpp.so"
for tool in clang clang-23 clang++ lld ld.lld llvm-config llvm-dwarfdump llvm-readobj llvm-symbolizer; do
    test -x "$tree/bin/$tool"
    canonical=$(realpath -e "$tree/bin/$tool")
    case "$canonical" in "$tree"/*) ;; *) exit 41 ;; esac
done
runtime=$(LD_LIBRARY_PATH="$tree/lib" "$tree/bin/clang" -print-runtime-dir)
case "$runtime" in "$tree/lib/clang/23/"*) ;; *) exit 42 ;; esac
test -f "$runtime/libclang_rt.msan.a"
test -f "$runtime/libclang_rt.msan_cxx.a"
{
    printf 'prepublication_runtime_directory=%s\n' "$runtime"
    sha256sum "$runtime/libclang_rt.msan.a" "$runtime/libclang_rt.msan_cxx.a"
} >"$receipts/runtime-prepublication.txt"

# Publish only this new task-owned directory; never remove or replace a cache.
mv "$tree" "$destination"
test "$(realpath -e "$destination")" = "$destination"
export LD_LIBRARY_PATH="$destination/lib"
{
    "$destination/bin/clang" --version
    "$destination/bin/clang" -dumpversion
    "$destination/bin/llvm-config" --version
    "$destination/bin/llvm-symbolizer" --version
    "$destination/bin/ld.lld" --version
    "$destination/bin/clang" -print-resource-dir
    "$destination/bin/clang" -print-runtime-dir
} >"$receipts/versions.txt"
grep -F "$release_commit" "$receipts/versions.txt"
test "$("$destination/bin/clang" -print-resource-dir)" = "$destination/lib/clang/23"
test "$("$destination/bin/clang" -dumpversion)" = "$version"
test "$("$destination/bin/llvm-config" --version)" = "$version"
"$destination/bin/llvm-symbolizer" --version | grep -E 'LLVM version 23[.]1[.]4([^0-9]|$)'

{
    sha256sum "$destination/LICENSE.TXT"
    for tool in clang clang-23 clang++ lld ld.lld llvm-config llvm-dwarfdump llvm-readobj llvm-symbolizer; do
        sha256sum "$destination/bin/$tool"
        printf 'canonical_%s=%s\n' "$tool" "$(realpath -e "$destination/bin/$tool")"
    done
    sha256sum "$destination/lib/libclang-cpp.so" "$destination/lib/clang/23/include/immintrin.h"
    runtime=$("$destination/bin/clang" -print-runtime-dir)
    sha256sum "$runtime/libclang_rt.msan.a" "$runtime/libclang_rt.msan_cxx.a"
} >"$receipts/binary-runtime-identities.txt"
find "$destination" -type f -print0 | sort -z | xargs -0 sha256sum >"$receipts/toolchain-files.sha256"
find "$destination" -type l -printf '%p -> %l\n' | sort >"$receipts/toolchain-symlinks.txt"

{
    printf 'TOOLCHAIN=%s\n' "$destination"
    printf 'TOOLCHAIN_BIN=%s/bin\n' "$destination"
    printf 'BUSTER_CLANG_RESOURCE_DIR=%s/lib/clang/23\n' "$destination"
    printf 'LD_LIBRARY_PATH=%s/lib\n' "$destination"
    printf 'archive=%s\nlicense_download=%s\nreceipts=%s\n' "$archive_path" "$license_path" "$receipts"
    printf 'scope=C_diagnostic_toolchain_and_matching_resources_not_full_hosted_package_setup\n'
} >"$receipts/toolchain-paths.txt"
printf '%s\n' "$archive_digest" >"$destination/.complete"
printf '%s\n' "$archive_digest" >"$destination/.correctness-complete"
sha256sum "$destination/.complete" "$destination/.correctness-complete" >"$receipts/completion-markers.sha256"
printf 'staging=complete\n'
