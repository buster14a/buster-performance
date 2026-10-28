#!/bin/bash
# ab's --lock for ab619s2.sh: the 9700X's lock, with the receipts its `locked` writes (receipt, RECEIPTS from the
# environment).
exec ~/buster-fast-bench/exclusive.sh bash -c 'receipt acquired "$@"; "$@"; status=$?; receipt "released status=$status" "$@"; exit $status' locked "$@"
