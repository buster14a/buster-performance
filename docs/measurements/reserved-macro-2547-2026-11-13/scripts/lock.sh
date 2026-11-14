#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run, with a timeout.
export EXCLUSIVE_OWNER="claude-2547" EXCLUSIVE_TITLE="#2547: -Wreserved-macro-identifier's cost when it is off" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxneMmPASHnMpG43xD7u"
exec ~/buster-fast-bench/exclusive.sh timeout 900 "$@"
