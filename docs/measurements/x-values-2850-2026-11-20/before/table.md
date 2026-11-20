| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the rows take; their records | 49,073; 268,942 | 9,888; 61,509 | 39,495; 188,250 | 39,456; 205,869 |
| their entries; those whose value is not zero | 302,047; 152,808 (50.59%) | 54,341; 29,859 (54.95%) | 184,146; 96,945 (52.65%) | 255,517; 129,265 (50.59%) |
| values that are not zero, a record | 0.568 | 0.485 | 0.515 | 0.628 |
| **by its source: entries; of them not zero** | | | | |
| its record's object: a name's read, an address constant's, an update's read by name | 67,111; 67,111 | 14,532; 14,532 | 58,111; 58,111 | 62,499; 62,499 |
| its destination's record's object: a store or an update by name | 10,881; 10,881 | 1,649; 1,649 | 9,641; 9,641 | 7,130; 7,130 |
| an integer constant's bits, by its class | 22,277; 10,553 | 4,324; 3,030 | 11,755; 9,123 | 5,314; 4,147 |
| a folded constant's, by its target's class; to bool | 10,889; 4,838 | 1,194; 845 | 6,481; 4,853 | 21,446; 11,358 |
| a member's offset in bytes | 21,511; 21,511 | 3,431; 3,431 | 2,822; 2,822 | 13,584; 13,584 |
| the 1 of an offset's sum (a member's, an address constant's) | 22,272; 22,272 | 3,485; 3,485 | 3,167; 3,167 | 14,545; 14,545 |
| an address constant's offset | 959; 761 | 525; 54 | 719; 345 | 1,200; 961 |
| a pointer's stride (a sum's, a subscript's) | 6,184; 6,184 | 923; 923 | 3,546; 3,546 | 8,349; 8,349 |
| a pointer's update's stride; its step's 1 | 768; 768 | 588; 588 | 1,070; 1,070 | 104; 104 |
| an update's step: one, of the class it is computed in | 1,633; 1,633 | 251; 251 | 932; 932 | 190; 190 |
| a floating constant's bits | 83; 46 | 10; 9 | 956; 898 | 31; 31 |
| a branch's label: the control's | 3,969; 3,969 | 352; 352 | 1,434; 1,434 | 5,589; 5,589 |
| a branch's label: an operator's own | 891; 58 | 76; 5 | 380; 12 | 756; 66 |
| a call's row | 12,501; 398 | 3,710; 180 | 6,957; 611 | 8,674; 437 |
| a temporary's number | 1,825; 1,825 | 525; 525 | 380; 380 | 275; 275 |
| an access's value (a vector's bytes, else 0) | 29,526; 0 | 4,850; 0 | 10,090; 0 | 22,355; 0 |
| a test's zero | 15,077; 0 | 1,820; 0 | 8,681; 0 | 14,420; 0 |
| none: an operation's, a conversion's, a discard's | 73,690; 0 | 12,096; 0 | 57,024; 0 | 69,056; 0 |
| **expressions with two or more of an evaluated call, a labeled operator and a postfix update through an address** | 474 (0.97%) | 163 (1.65%) | 635 (1.61%) | 479 (1.21%) |
