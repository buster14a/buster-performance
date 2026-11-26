set -euo pipefail
root="$PWD"
out="$root/followup-9700x/3657"
compat="$(mktemp -d "$out/archive-tools.XXXXXX")"
trap 'rm -rf "$compat"' EXIT
if ! command -v zip >/dev/null; then
    install -m 755 "$root/observer-3657-zip.sh" "$compat/zip"
fi
if ! command -v unzip >/dev/null; then
    ln -s /usr/bin/bsdunzip "$compat/unzip"
fi
export PATH="$compat:$PATH"
{ cc --version; bsdtar --version; bsdunzip --version; } > "$out/observer-toolchain.txt" 2>&1
cd pr3657
taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$out/observer-fixtures.csv" -- bash tests/ci/nightly-observe.sh > "$out/observer-fixtures.out" 2>&1
