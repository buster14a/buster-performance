#!/usr/bin/env bash
set -euo pipefail
compiler=$1
directory=$(mktemp -d)
trap 'rm -rf "$directory"' EXIT
export ORDER_DIR="$directory" REAL_CLANG
REAL_CLANG=$(command -v clang)
export BUSTER_CLANG_RESOURCE_DIR
BUSTER_CLANG_RESOURCE_DIR=$("$REAL_CLANG" -print-resource-dir)
mkdir "$directory/bin"
cat > "$directory/bin/clang" <<'WRAPPER'
#!/usr/bin/env bash
set -eu
last=${!#}
case "$last" in
    "$ORDER_DIR/first.c")
        if mkdir "$ORDER_DIR/first-started" 2>/dev/null; then
            for ((i=0; i<250; i++)); do
                test ! -d "$ORDER_DIR/third-started" || break
                sleep 0.02
            done
            test -d "$ORDER_DIR/third-started" || { echo 'first timed out waiting for third' >&2; exit 1; }
        fi ;;
    "$ORDER_DIR/second.c")
        for arg do
            if test "$arg" = -dM; then mkdir -p "$ORDER_DIR/second-finishing"; fi
        done ;;
    "$ORDER_DIR/third.c")
        test -d "$ORDER_DIR/second-finishing" || { echo 'third started before second finished its checks' >&2; exit 1; }
        mkdir -p "$ORDER_DIR/third-started" ;;
esac
exec "$REAL_CLANG" "$@"
WRAPPER
chmod +x "$directory/bin/clang"
for name in first second third; do
    printf '#warning %s\nint %s;\n' "$name" "$name" > "$directory/$name.c"
done
export PATH="$directory/bin:$PATH" BUSTER_PARALLEL_CPUS=2
status=0
"$compiler" test-preprocessor --clang "$directory"/{first,second,third}.c > "$directory/out" 2> "$directory/err" || status=$?
cat "$directory/out"
# The third file released the first. Their warnings must still appear in argument order.
sed -nE 's/.*warning: (first|second|third).*/\1/p' "$directory/err" | uniq > "$directory/order"
cat "$directory/order"
test "$status" -eq 0 && diff -u <(printf 'first\nsecond\nthird\n') "$directory/order"
