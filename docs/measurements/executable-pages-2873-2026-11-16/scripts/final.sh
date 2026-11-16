#!/bin/bash
# final.sh: `order` and `full` built from the patches on main, then the record's runs and the tests, each a hold of
# the lock.
cd "$(dirname "$0")"
./build-both.sh
./series2.sh
./tests.sh full results/tests-full
echo finished > final.done
