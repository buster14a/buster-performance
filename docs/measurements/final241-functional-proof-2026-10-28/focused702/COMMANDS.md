# Completed focused commands

Run from the private composition checkout identified in `README.md`.
`task_focus` names the absolute directory containing this frozen adapter and
its `main-standalone.c`. The source copy uses the composition's real headers.

```sh
task_focus=/absolute/path/to/compat-678-4b2
cores -n 2 --title '702 plus678 focused native adapter build' --link https://github.com/buster14a/buster/pull/702 -- \
  /usr/bin/clang -O1 -g -march=native -DEXPECT_HOST_VECTOR=1 \
  -Isrc -Isrc/buster/compiler -fwrapv -funsigned-char -fno-strict-aliasing \
  -Wall -Werror -fsanitize=address,undefined -fno-omit-frame-pointer \
  -ffunction-sections -fdata-sections "$task_focus/fill-host-checks.c" \
  -Wl,--gc-sections -lm -ldl -pthread -o "$task_focus/fill-checks-native"
cores -n 2 --title '702 plus678 focused native guard and caller contract' --link https://github.com/buster14a/buster/pull/702 -- \
  "$task_focus/fill-checks-native"

cores -n 2 --title '702 plus678 focused generic adapter build' --link https://github.com/buster14a/buster/pull/702 -- \
  /usr/bin/clang -O1 -g -march=x86-64 -DEXPECT_HOST_VECTOR=0 \
  -Isrc -Isrc/buster/compiler -fwrapv -funsigned-char -fno-strict-aliasing \
  -Wall -Werror -Wno-unused-function -Wno-psabi \
  -fsanitize=address,undefined -fno-omit-frame-pointer \
  -ffunction-sections -fdata-sections "$task_focus/fill-host-checks.c" \
  -Wl,--gc-sections -lm -ldl -pthread -o "$task_focus/fill-checks-scalar"
cores -n 2 --title '702 plus678 host-vector-zero guard and caller contract' --link https://github.com/buster14a/buster/pull/702 -- \
  "$task_focus/fill-checks-scalar"
```

The final local logs are `build-native-final.log`, `run-native.log`,
`build-scalar-corrected.log` and `run-scalar.log`. Earlier failed scalar
invocations are retained separately and do not qualify a build. Both final
executions return zero and report 214 checks, zero failures.
