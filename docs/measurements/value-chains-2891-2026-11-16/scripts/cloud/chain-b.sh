#!/bin/bash
# Chain B: the x86-64 build and its suites, its objects against the native head's, then the sanitizer builds' parts.
S=/root/.cache/claude-2891
bash $S/scripts/x86-64.sh
cd $S/scripts && for c in sqlite3 lua musl; do nice -n 10 ./compile-objects.sh /home/user/buster-x86/build/compiler $c $S/objects-x86; done > $S/logs/objects-x86.txt 2>&1
(cd $S/objects-head && same=0; differ=0; for o in *.o; do if cmp -s "$o" "$S/objects-x86/$o"; then same=$((same + 1)); else differ=$((differ + 1)); echo "differs: $o"; fi; done; echo "objects same $same differ $differ") >> $S/logs/objects-x86.txt
bash $S/scripts/sanitizers.sh
echo chain-b done > $S/logs/chain-b.done
