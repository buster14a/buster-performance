#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# usage: lock.sh COMMAND... ; runs COMMAND under the 9700X lock, held for that one run
export EXCLUSIVE_OWNER="claude-2532" EXCLUSIVE_TITLE="#2532: make the asm matcher's index once (bake it)" EXCLUSIVE_LINK="https://claude.ai/code/session_01EgbxnfwZ9oQCpoXgixQwnZ"
exec ~/buster-fast-bench/exclusive.sh "$@"
