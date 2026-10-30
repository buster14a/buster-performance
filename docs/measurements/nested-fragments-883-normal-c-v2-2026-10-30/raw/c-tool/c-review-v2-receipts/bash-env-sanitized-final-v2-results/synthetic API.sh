set -e
if [[ -o posix ]] && shopt -q extglob && [[ ${BASH_COMPAT-} == 42 ]]; then builtin printf options > "$TEST_DIR/options"; fi
if [[ $TEST_CASE == cdpath ]]; then (cd target; builtin pwd > "$TEST_DIR/cd"); fi
if [[ $TEST_CASE == glob ]]; then (cd "$TEST_GLOB"; builtin printf '%s\0' * > "$TEST_DIR/glob"); fi
if [[ $TEST_CASE == lookup ]]; then private-probe; fi
inner_fixture() { builtin printf nested > "$TEST_DIR/nested"; }
outer_fixture() { inner_fixture; }
if [[ $TEST_CASE == nesting ]]; then outer_fixture; fi
printf '%s\0' "$@"
command printf '%s\0' command-sentinel
