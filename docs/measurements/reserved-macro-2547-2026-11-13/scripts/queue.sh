#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# queue.sh STEP...: the record's steps in order, each its own hold of the lock, detached from the ssh session
# (setsid nohup ./queue.sh ... > queue.log): prepare, build-TREE, lists, run-ROUNDS, profile. The first failure stops it.
set -u
cd "$(dirname "$0")"
for step in "$@"; do
    echo "$(date -u +%FT%TZ) start $step"
    case $step in
        prepare) ./lock.sh ./prepare.sh ;;
        build-*) ./lock.sh ./build.sh "${step#build-}" ;;
        lists) ./lists.sh ;;
        run-*) ./lock.sh ./run.sh "${step#run-}" ;;
        profile) ./lock.sh ./profile.sh ;;
        *) false ;;
    esac
    status=$?
    echo "$(date -u +%FT%TZ) end $step status $status"
    if ((status != 0)); then exit $status; fi
done
echo "$(date -u +%FT%TZ) done"
