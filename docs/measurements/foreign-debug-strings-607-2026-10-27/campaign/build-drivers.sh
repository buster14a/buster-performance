#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p candidate results
cp -a base/src candidate/
(cd candidate && git apply ../campaign/candidate.patch)
flags=(-O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror)
clang "${flags[@]}" -Ibase/src campaign/dwarf607.c -o campaign/dwarf607 -pthread
clang "${flags[@]}" -Ibase/src campaign/driver.c -o campaign/driver-base -pthread
clang "${flags[@]}" -Icandidate/src campaign/driver.c -o campaign/driver-merge -pthread
clang -O2 -Wall -Wextra -Werror campaign/decoded.c -o campaign/decoded
sha256sum campaign/candidate.patch > results/driver-patch.sha256
sha256sum campaign/dwarf607 campaign/dwarf607.c campaign/driver-base campaign/driver-merge campaign/driver.c campaign/candidate.patch campaign/decoded.c > results/drivers.sha256
{
    date -Is
    uname -a
    lscpu
    clang --version
    ld.lld --version
    llvm-dwarfdump --version
    gdb --version
    objcopy --version
    sha256sum base/build/compiler /usr/bin/clang /usr/bin/ld.lld
    cat results/drivers.sha256
    stat -f -c 'filesystem=%T' outputs
} > results/identity.txt
for marker in results/*/DONE results/*/FAILED; do
    rm -f "$marker"
done
