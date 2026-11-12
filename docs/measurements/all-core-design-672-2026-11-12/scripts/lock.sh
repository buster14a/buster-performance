#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-672-allcore" EXCLUSIVE_TITLE="#672: the all-core design (eight workers)" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxneCARdP1WQUPTUTzXC"
exec ~/buster-fast-bench/exclusive.sh "$@"
