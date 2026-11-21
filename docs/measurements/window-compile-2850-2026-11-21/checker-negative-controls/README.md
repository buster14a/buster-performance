# Availability and scalar condition reader experiments

All three compiler images used public Buster main f4f8dd9a1 as their parent. Every experiment compared fresh native Release processes on the locked Ryzen 7 9700X against its unchanged parent. Each mode compiled SQLite, Buster, Lua and musl. All emitted ELF files and diagnostics matched.

| Change | SQLite | Buster self-compile | Outcome |
| --- | --- | --- | --- |
| [Availability use check](availuse) | −0.0535 ms in seven pairs | +2.09 ms | Fewer instructions on SQLite, higher median self-compile time |
| [Move availability tables after the check](availtables) | −0.3675 ms in three pairs | +5.8585 ms | Lower SQLite time with a larger self-compile cost |
| [Checked scalar conditions](plaintruth) | +0.051 ms in three pairs | −0.165 ms | All four workloads executed more instructions |

The linked records include individual samples, paired ranges, frozen workloads, exact patches, object manifests and diagnostic checks. These experimental paths remain outside the normal compiler.
