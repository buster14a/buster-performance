#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE.
# Hosted compilation/identity glue only. Never execute the resulting controller.
# The LLVM URL/hash/license and action pins derive from the reviewed Buster
# caef4ea2 tools/ci/setup-hosted.sh and .github/workflows/9700x.yml; see HOSTED-BUILD.md.
set -euo pipefail
umask 077
export LC_ALL=C
export LANG=C

test "${RUNNER_ENVIRONMENT:-}" = github-hosted
test "${GITHUB_REPOSITORY:-}" = buster14a/buster-performance
test "${GITHUB_EVENT_NAME:-}" = push
test "${GITHUB_REF:-}" = refs/heads/codex/prepare-914-controller-build
[[ ${GITHUB_SHA:-} =~ ^[0-9a-f]{40}$ ]]
test "$(uname -s)" = Linux
test "$(uname -m)" = x86_64
. /etc/os-release
test "$VERSION_ID" = 26.04

cd -P "${GITHUB_WORKSPACE:?}"
[[ $PWD != *[[:space:]]* ]]
directory=docs/measurements/intrinsic-filter-914-input-binding-2026-10-30
source="$PWD/$directory/profile914.c"
receipt="${RUNNER_TEMP:?}/914-controller-receipt"
mkdir "$receipt"
receipt=$(readlink -f "$receipt")
finish_receipt() {
    local result=$?
    trap - EXIT
    set +e
    if [ -f "$receipt/profile914.elf" ]; then chmod 0644 "$receipt/profile914.elf" || result=1; fi
    if [ -f "$receipt/profile914.o" ]; then chmod 0644 "$receipt/profile914.o" || result=1; fi
    date -u +%Y-%m-%dT%H:%M:%SZ > "$receipt/finished-utc.txt" || result=1
    printf '%s\n' "$result" > "$receipt/overall-status.txt" || result=1
    (
        cd "$receipt" || exit 1
        find . -type f ! -name SHA256SUMS -print0 | sort -z | xargs -0 sha256sum > SHA256SUMS
    )
    local manifested=$?
    if [ "$manifested" -ne 0 ]; then
        result=1
        printf '1\n' > "$receipt/overall-status.txt"
        printf 'MANIFEST_FAILED; artifact is not accepted\n' > "$receipt/manifest-failure.txt"
    fi
    exit "$result"
}
trap finish_receipt EXIT
date -u +%Y-%m-%dT%H:%M:%SZ > "$receipt/started-utc.txt"
mkdir "$receipt/source" "$receipt/licenses" "$receipt/elf"
printf '%s\n' "$GITHUB_SHA" > "$receipt/trigger-sha.txt"
test "$(git rev-parse HEAD)" = "$GITHUB_SHA"
git show -s --format=fuller HEAD > "$receipt/commit.txt"
git rev-parse HEAD 'HEAD^{tree}' > "$receipt/git-identities.txt"
printf 'original_protocol_review_commit=%s\nbinding_fix_parent=%s\n' \
    0ead6f9a5f136039c15f28b56dd92d846a5ef04a 66149e3b47205b16f70ad2f5899baaa8c4c5e0d3 > "$receipt/source-binding.txt"
printf 'repository=%s\nref=%s\nevent=%s\nrun_id=%s\nrun_attempt=%s\nrunner_environment=%s\n' \
    "$GITHUB_REPOSITORY" "$GITHUB_REF" "$GITHUB_EVENT_NAME" "$GITHUB_RUN_ID" "$GITHUB_RUN_ATTEMPT" "$RUNNER_ENVIRONMENT" > "$receipt/run.txt"
printf '%s\n' "$PWD" > "$receipt/build-working-directory.txt"
printf 'HOME=%s\nPATH=/usr/bin:/bin\nLC_ALL=C\nLANG=C\n' "$HOME" > "$receipt/compiler-environment.txt"
uname -a > "$receipt/uname.txt"
cp /etc/os-release "$receipt/os-release.txt"
grep -m1 '^model name[[:space:]]*:' /proc/cpuinfo > "$receipt/cpu-model.txt"

# Freeze all four corrected source/protocol files; original 0ead/66149 remain history.
# Neither this controller nor another compiled program is run here.
cat > "$receipt/frozen-source.sha256" <<'HASHES'
5f7e12028829fbed3bd5ac92fdb80e0d003376a25f69ae1a08b41de008c1ea17  docs/measurements/intrinsic-filter-914-input-binding-2026-10-30/profile914.c
b95694b55c05470b317e1b0f417bebebeb504b968ffaddbb02a2d8b8d3cedcb3  docs/measurements/intrinsic-filter-914-input-binding-2026-10-30/PLAN.md
9bf91cf0488d3690f26fe2110b059099dff9044a0dd6e6b1858dcb932927af25  docs/measurements/intrinsic-filter-914-input-binding-2026-10-30/DEPENDENCIES.tsv
a106c74445ad91ca945f4bf849438326dd68b2dc23b016803084bb151d1b7c2b  docs/measurements/intrinsic-filter-914-input-binding-2026-10-30/PROVENANCE.md
HASHES
sha256sum --check --strict "$receipt/frozen-source.sha256" > "$receipt/frozen-source-check.txt"
test "$(wc -l < "$source")" -eq 613
test "$(git hash-object --no-filters "$source")" = beaa45b167b0413da525271c426167e43156fc5f
git ls-tree HEAD -- "$directory/profile914.c" "$directory/PLAN.md" "$directory/DEPENDENCIES.tsv" "$directory/PROVENANCE.md" > "$receipt/source-git-blobs.txt"
cp "$source" "$directory/PLAN.md" "$directory/DEPENDENCIES.tsv" "$directory/PROVENANCE.md" "$receipt/source/"
cp "$directory/build-controller-hosted.sh" "$directory/HOSTED-BUILD.md" "$receipt/source/"
cp .github/workflows/914-controller-hosted.yml "$receipt/source/914-controller-hosted.yml"
cp LICENSE "$receipt/licenses/Buster-LICENSE"
sha256sum "$directory/build-controller-hosted.sh" "$directory/HOSTED-BUILD.md" .github/workflows/914-controller-hosted.yml > "$receipt/recipe.sha256"

# This is the minimum disposable-host dependency subset, not setup-hosted.sh's
# compiler correctness, oracle, perf, sanitizer, fuzzer or native setup.
sudo apt-get update > "$receipt/apt-update.stdout" 2> "$receipt/apt-update.stderr"
sudo apt-get install --yes --no-install-recommends gcc binutils libc6-dev zstd libstdc++6 libzstd-dev libxml2-dev zlib1g-dev \
    > "$receipt/apt-install.stdout" 2> "$receipt/apt-install.stderr"
dpkg-query -W -f='${Package}\t${Version}\t${Architecture}\n' \
    gcc binutils libc6 libc6-dev libgcc-s1 libstdc++6 zstd libzstd-dev libxml2-dev zlib1g-dev > "$receipt/packages.tsv"

version=23.1.4
archive=LLVM-${version}-Linux-X64
llvm="$RUNNER_TEMP/914-llvm-$version"
download="$RUNNER_TEMP/914-llvm.tar.zst"
url="https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/${archive}.tar.zst"
printf '%s\n' "$url" > "$receipt/llvm-download-url.txt"
curl --fail --location --retry 3 "$url" --output "$download" \
    > "$receipt/llvm-download.stdout" 2> "$receipt/llvm-download.stderr"
printf '%s  %s\n' efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378 "$download" \
    | tee "$receipt/llvm-archive.sha256" | sha256sum --check --strict > "$receipt/llvm-archive-check.txt"
mkdir "$llvm"
tar -I 'zstd -d --long=30' --extract --file "$download" --directory "$llvm" --strip-components=1 --no-same-owner --wildcards \
    "$archive/bin/clang" "$archive/bin/clang-23" "$archive/lib/clang/23/*" \
    > "$receipt/llvm-extract.stdout" 2> "$receipt/llvm-extract.stderr"
curl --fail --location --retry 3 \
    https://raw.githubusercontent.com/llvm/llvm-project/7a941dfb2877a0b8cf30323fefa85ad019e0b0f5/llvm/LICENSE.TXT \
    --output "$receipt/licenses/LLVM-LICENSE.TXT" > "$receipt/llvm-license-download.stdout" 2> "$receipt/llvm-license-download.stderr"
printf '%s  %s\n' 8d85c1057d742e597985c7d4e6320b015a9139385cff4cbae06ffc0ebe89afee "$receipt/licenses/LLVM-LICENSE.TXT" \
    | sha256sum --check --strict > "$receipt/llvm-license-check.txt"
clang="$llvm/bin/clang"
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C "$clang" --no-default-config --version > "$receipt/clang-version.txt" 2> "$receipt/clang-version.stderr"
test "$(env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C "$clang" --no-default-config -dumpversion)" = "$version"
sha256sum "$(readlink -f "$clang")" /usr/bin/ld.bfd /usr/bin/sha256sum /usr/bin/readelf /usr/bin/zstd > "$receipt/tools-before.sha256"
/usr/bin/ld.bfd --version > "$receipt/linker-version.txt"

# Only the already approved external compiler/linker receive loader metadata
# queries. Never run ldd, a loader, --help or any mode of profile914.elf.
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C /usr/bin/ldd "$clang" > "$receipt/clang-runtime.txt" 2> "$receipt/clang-runtime.stderr"
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C /usr/bin/ldd /usr/bin/ld.bfd > "$receipt/linker-runtime.txt" 2> "$receipt/linker-runtime.stderr"
if grep -q 'not found' "$receipt/clang-runtime.txt" "$receipt/linker-runtime.txt"; then
    exit 1
else
    test "$?" -eq 1
fi
/usr/sbin/ldconfig -p > "$receipt/ldconfig-cache.txt"
awk '{for(i=1;i<=NF;i++)if($i ~ /^\//)print $i}' "$receipt/clang-runtime.txt" "$receipt/linker-runtime.txt" \
    | sort -u > "$receipt/build-runtime-paths.txt"
while IFS= read -r path; do
    test -f "$path"
    sha256sum "$(readlink -f "$path")"
done < "$receipt/build-runtime-paths.txt" > "$receipt/build-runtime-before.sha256"

common=(--no-default-config -std=c17 -O2 -Wall -Wextra -Werror -march=x86-64 -mtune=generic)
discover=("$clang" "${common[@]}" -M -MT profile914 -MF "$receipt/inputs-before.d" "$source")
compile=("$clang" "${common[@]}" -MD -MT profile914 -MF "$receipt/inputs-actual.d" -MJ "$receipt/compile-command.json" -c "$source" -o "$receipt/profile914.o")
link=("$clang" --no-default-config -fuse-ld=bfd "$receipt/profile914.o" "-Wl,-Map=$receipt/profile914.link.map" -Wl,--trace -o "$receipt/profile914.elf")
for phase in discover compile link; do
    declare -n argv="$phase"
    printf '%s\0' "${argv[@]}" > "$receipt/$phase.argv.nul"
    printf '%q ' "${argv[@]}" > "$receipt/$phase.argv.txt"
    printf '\n' >> "$receipt/$phase.argv.txt"
    unset -n argv
done
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C "${discover[@]}" > "$receipt/discover.stdout" 2> "$receipt/discover.stderr"

# Fixed Linux paths here contain no whitespace; refuse an unsupported makefile
# spelling instead of silently hashing a different dependency list.
dependency_paths() {
    local text
    text=$(sed ':a;N;$!ba;s/\\\n/ /g' "$1")
    text=${text#profile914: }
    [[ $text != *\\* ]]
    read -r -a words <<< "$text"
    test "${#words[@]}" -gt 0
    for path in "${words[@]}"; do
        test -f "$path"
        printf '%s\n' "$path"
    done | sort -u
}
dependency_paths "$receipt/inputs-before.d" > "$receipt/compile-inputs-before.paths"
while IFS= read -r path; do sha256sum "$path"; done < "$receipt/compile-inputs-before.paths" > "$receipt/compile-inputs-before.sha256"

# Freeze all potential startup/default-C-link inputs before linking, then require
# every actual --trace input to belong to this set. No dynamic target is executed.
for name in crt1.o Scrt1.o rcrt1.o crti.o crtbegin.o crtbeginS.o crtend.o crtendS.o crtn.o libgcc.a libgcc_s.so libgcc_s.so.1 libc.so libc.so.6 libc_nonshared.a ld-linux-x86-64.so.2; do
    path=$(env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C "$clang" --no-default-config -print-file-name="$name")
    if [[ $path = /* ]] && test -f "$path"; then readlink -f "$path"; fi
done > "$receipt/link-candidates.paths"
awk '$1=="libc.so.6" && /x86-64/ {print $NF;exit}' "$receipt/ldconfig-cache.txt" >> "$receipt/link-candidates.paths"
cat "$receipt/build-runtime-paths.txt" >> "$receipt/link-candidates.paths"
readlink -f /lib64/ld-linux-x86-64.so.2 >> "$receipt/link-candidates.paths"
while IFS= read -r path; do test -f "$path"; readlink -f "$path"; done < "$receipt/link-candidates.paths" \
    | sort -u > "$receipt/link-candidates.canonical.paths"
mv "$receipt/link-candidates.canonical.paths" "$receipt/link-candidates.paths"
while IFS= read -r path; do test -f "$path"; sha256sum "$(readlink -f "$path")"; done < "$receipt/link-candidates.paths" > "$receipt/link-inputs-before.sha256"

env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C "$clang" -### "${compile[@]:1}" > "$receipt/compile-driver.stdout" 2> "$receipt/compile-driver.stderr"
date -u +%Y-%m-%dT%H:%M:%SZ > "$receipt/compile-started-utc.txt"
set +e
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C "${compile[@]}" > "$receipt/compile.stdout" 2> "$receipt/compile.stderr"
status=$?
set -e
printf '%s\n' "$status" > "$receipt/compile-status.txt"
date -u +%Y-%m-%dT%H:%M:%SZ > "$receipt/compile-finished-utc.txt"
test "$status" -eq 0
sha256sum "$receipt/profile914.o" > "$receipt/object-before-link.sha256"
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C "$clang" -### "${link[@]:1}" > "$receipt/link-driver.stdout" 2> "$receipt/link-driver.stderr"
date -u +%Y-%m-%dT%H:%M:%SZ > "$receipt/link-started-utc.txt"
set +e
env -i HOME="$HOME" PATH=/usr/bin:/bin LC_ALL=C LANG=C "${link[@]}" > "$receipt/link.stdout" 2> "$receipt/link.stderr"
status=$?
set -e
printf '%s\n' "$status" > "$receipt/link-status.txt"
date -u +%Y-%m-%dT%H:%M:%SZ > "$receipt/link-finished-utc.txt"
test "$status" -eq 0
chmod 0644 "$receipt/profile914.elf" "$receipt/profile914.o"

dependency_paths "$receipt/inputs-actual.d" > "$receipt/compile-inputs-actual.paths"
cmp "$receipt/compile-inputs-before.paths" "$receipt/compile-inputs-actual.paths"
sha256sum --check --strict "$receipt/compile-inputs-before.sha256" > "$receipt/compile-inputs-after-check.txt"
sha256sum --check --strict "$receipt/link-inputs-before.sha256" > "$receipt/link-inputs-after-check.txt"
sha256sum --check --strict "$receipt/object-before-link.sha256" > "$receipt/object-after-link-check.txt"
sha256sum --check --strict "$receipt/tools-before.sha256" > "$receipt/tools-after-check.txt"
sha256sum --check --strict "$receipt/llvm-archive.sha256" > "$receipt/llvm-archive-after-check.txt"
sha256sum --check --strict "$receipt/build-runtime-before.sha256" > "$receipt/build-runtime-after-check.txt"
sha256sum --check --strict "$receipt/frozen-source.sha256" > "$receipt/frozen-source-after-check.txt"
sha256sum --check --strict "$receipt/recipe.sha256" > "$receipt/recipe-after-check.txt"
while IFS= read -r path; do
    if [[ $path = /* ]]; then
        test -f "$path"
        path=$(readlink -f "$path")
        test "$path" = "$receipt/profile914.o" || grep -Fxq "$path" "$receipt/link-candidates.paths"
    fi
done < "$receipt/link.stdout"

readelf --wide --file-header --program-headers --dynamic --notes --version-info "$receipt/profile914.elf" > "$receipt/elf/profile914.txt"
if grep -Eq '\((RPATH|RUNPATH)\)' "$receipt/elf/profile914.txt"; then
    exit 1
else
    test "$?" -eq 1
fi
sed -n 's/.*(NEEDED).*\[\([^]]*\)\].*/\1/p' "$receipt/elf/profile914.txt" > "$receipt/elf/controller-needed.txt"
test "$(cat "$receipt/elf/controller-needed.txt")" = libc.so.6
interpreter=$(sed -n 's/.*Requesting program interpreter: \([^]]*\)\].*/\1/p' "$receipt/elf/profile914.txt")
test -n "$interpreter"
test "$(readlink -f "$interpreter")" = "$(readlink -f /lib64/ld-linux-x86-64.so.2)"
libc=$(awk '$1=="libc.so.6" && /x86-64/ {print $NF;exit}' "$receipt/ldconfig-cache.txt")
test -f "$libc"
sha256sum "$(readlink -f "$libc")" "$(readlink -f "$interpreter")" > "$receipt/elf/controller-runtime.sha256"
readelf --wide --dynamic --notes --version-info "$libc" > "$receipt/elf/libc.txt"
readelf --wide --dynamic --notes --version-info "$interpreter" > "$receipt/elf/loader.txt"
sha256sum "$receipt/source/profile914.c" "$receipt/profile914.o" "$receipt/profile914.elf" > "$receipt/controller.sha256"
printf '%s\n' 'CONTROLLER_COMPILATION_COMPLETE; CONTROLLER_NOT_EXECUTED; NO_STAGING_OR_MEASUREMENT_ACCEPTANCE' > "$receipt/result.txt"
