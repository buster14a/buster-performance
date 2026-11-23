#!/bin/bash
# --node-bodies at main da652ae8: stages and profile by symbol with and without the option, and the cycles by source line
# within the symbols the option adds most to.
set -uo pipefail
cd "$HOME/buster-fast-bench/2850-claude-01Egbx"
./setup.sh da652ae8
./prof2.sh nb2-plain da652ae8d
./prof2.sh nb2-bodies da652ae8d --node-bodies
./lines2.sh da652ae8d nb2-bodies --node-bodies node_census_node node_alone_bodies node_front_chunk node_alone_begin node_machine_type_in_context node_twin_build node_machine_contexts check_lower_taken_body node_machine_rule node_machine_reader_chunk node_machine_reader_side node_machine_expand node_producer_before node_census_walk
echo job-complete
