# Completed H5 and O4 mutation round

On the locked Ryzen 7 9700X, all 116 one-at-a-time changes to the frozen #3213 production source built. The Develop checker (seed 133, shard 5/8) caught 107 and accepted nine. All four unmodified controls passed. Mutation 115, `note-not-in-the-input`, produced one failure on shard 5. The additional shards in its fallback list were unnecessary.

The original [0–39](9700x.txt) and resumed [40–98](9700x-040-098.txt), [99–102](9700x-099-102.txt) and [103–115](9700x-103-115.txt) logs cover every index exactly once. The middle run was [checkpointed](9700x-099-102.stop) after 102 while its tree was restored. Every catch recorded checker exit 1 and at least one failing assertion. All the surviving changes had appeared in the previous round. The [source record](https://github.com/buster14a/buster/blob/0647d69ba8af4e466c89df2519dea0b382524d37/docs/node-machine.md#L7480) explains the retained terms.

| ID | Surviving change | Interpretation on this source |
| --- | --- | --- |
| 4 | `segment-unextended-asked` | Looks up address-space qualifiers with an unextended type table. Those types have no extended address space. The guard avoids that work. |
| 19, 20 | `ordered-two-pointers-too`, `ordered-any-other-operand` | The reference checks for exactly one pointer-like operand and an integer on the other side of the comparison. These two mutations weaken the reference conditions independently. |
| 25 | `own-order-unasked` | Also considers an ungrouped ordered-comparison diagnostic when its policy is disabled. With warnings suppressed, the tables do not list an operator for a nonconstant pointer/integer comparison, and the constant case is handled earlier. |
| 32 | `orders-any-operator` | Removes the relational class test. The other masks require only the conversion bit on the sender and pointer-like operands on both sides. Casts have one operand and a two-pointer or two-array addition fails ordinary checking. This explanation applies to the frozen operator tables. |
| 57–59 | `labelled-at-file-scope-too`, `labelled-with-linkage-too`, `labelled-any-kind` | The original conditions encode the reference rule for a labelled automatic object. They require a block-scope object with no linkage. These mutations remove one condition at a time. |
| 81 | `renames-one-not-taken-too` | Treats an unsupported rename pragma as accepted. The original record locates this case in an error translation unit that the reader declines. |

The run establishes that these nine mutations escaped the checker shard. The table states the source-level rationale for retaining their guards. General observational equivalence across arbitrary C programs remains unproved.
