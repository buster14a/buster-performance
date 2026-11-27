#!/bin/bash
grep -v '^\s*\.\(loc\|cfi\|p2align\)' "$1" | grep -v '^\s*#' | sed 's/\s*#.*$//'
