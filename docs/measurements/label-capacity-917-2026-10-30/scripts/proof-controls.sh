#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
. "$(dirname "$0")/env.sh"
cd "$Q"
test "$(cat logs/place-base-v4.status)" = 0
mkdir proof-controls
clang -std=c17 -O2 -Wall -Wextra -Werror proof-tools/mutate.c -o proof-controls/mutate
trap 'status=$?; printf "%s\n" "$status" > "$Q/logs/proof-controls.status"' EXIT
object="$Q/placements-base-v4/16/checker.o"
for item in missing:-16 double:16 wrong:8; do
  label=${item%%:*}
  delta=${item#*:}
  proof-controls/mutate "$object" "proof-controls/$label.o" addend "$delta"
  if python3 proof-tools/elf_proof.py object base/build/8.o "proof-controls/$label.o" --shift 16 > "proof-controls/$label.json"; then
    printf 'unexpected acceptance: %s\n' "$label" >&2
    exit 1
  fi
done
site=$(jq -r '.proved_local_hot_plt32_targets[0].variant.site' placements-base-v4/16/linked-proof.json)
test -n "$site"
proof-controls/mutate placements-base-v4/16/compiler proof-controls/wrong-linked-target site "$site"
if python3 proof-tools/check_linked.py base/build/8.o base/build/compiler proof-controls/wrong-linked-target --shift 16 \
  --required check_input_run --required check_input_controls --required check_input_controls_prefix > proof-controls/wrong-linked-target.json; then
  printf 'unexpected linked-target acceptance\n' >&2
  exit 1
fi
printf 'missing, double, wrong addend translations and wrong wild linked target all refused\n'
for item in wrong-base:symbol:check_input_run ambiguous:duplicate:check_graph_validate_lists; do
  label=${item%%:*}
  rest=${item#*:}
  mode=${rest%%:*}
  name=${rest#*:}
  address=$(jq -r --arg name "$name" '.functions[] | select(.name == $name) | .shifted_address' placements-base-v4/16/linked-proof.json)
  test -n "$address"
  proof-controls/mutate placements-base-v4/16/compiler "proof-controls/$label" "$mode" "$address"
  if python3 proof-tools/check_linked.py base/build/8.o base/build/compiler "proof-controls/$label" --shift 16 \
    --required check_input_run --required check_input_controls --required check_input_controls_prefix > "proof-controls/$label.json"; then
    printf 'unexpected ownership acceptance: %s\n' "$label" >&2
    exit 1
  fi
done
printf 'wrong ownership anchor and ambiguous duplicate address both refused\n'
for item in null-address:1 null-extended-index:2; do
  label=${item%%:*}
  mode=${item#*:}
  proof-controls/mutate placements-base-v4/16/compiler "proof-controls/$label" null "$mode"
  if python3 proof-tools/check_linked.py base/build/8.o base/build/compiler "proof-controls/$label" --shift 16 \
    --required check_input_run --required check_input_controls --required check_input_controls_prefix > "proof-controls/$label.json"; then
    printf 'unexpected NULL metadata acceptance: %s\n' "$label" >&2
    exit 1
  fi
done
proof-controls/mutate placements-base-v4/16/checker.o proof-controls/rel-null.o null 3
if python3 proof-tools/elf_proof.py object base/build/8.o proof-controls/rel-null.o --shift 16 > proof-controls/rel-null.json; then
  printf 'unexpected ET_REL NULL metadata acceptance\n' >&2
  exit 1
fi
printf 'wrong NULL address, extended-index fields and noncanonical ET_REL NULL row all refused\n'
