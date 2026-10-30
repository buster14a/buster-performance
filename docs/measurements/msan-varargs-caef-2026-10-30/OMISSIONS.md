# Omitted payloads

| Omitted material | Preserved identity and scope |
| --- | --- |
| Hosted 22-member artifact ZIP | Digest `306c7fc388a49e5e3d2279c17dc78b470886372ff39be3ef1df4ab066d542361`, original member list and all 21 included text-member comparisons; ZIP contains an ELF probe |
| Hosted compiled detector probe | Exact digest in `inspection/omitted-inputs.sha256`; never executed during collection/curation |
| Local v1/v2 detector binaries and v2 compiler | Original raw manifests/input identities, compiler hash/stat and invocation/expected-report receipts; binaries omitted |
| Source checkout/archive, full toolchain, headers, runtime libraries, cache/tmp/corpus | Source 810-file manifest/tree identities and complete recorded toolchain hashes/markers/four-symlink ledgers; external inputs only |
| V1 full mixed native macro dump | Original manifest digest, repeated in omitted-input ledger; selected first-party vector predicate retained |
| Wrong-TU 52,464,073-byte IR | Exact omitted-input digest plus original launch/completion history; fallback queue and wrong TU explicitly unqualified |
| Qualified backend 195,039,427-byte IR | Digest `bf0e52170ce36d9c4edb816bd1742ff5ad7395bb68aa635f1e8664a84b135a2b`, external origin and original payload manifest; only bounded source/IR context included |
| Optional stand-in C source | Digest `778456521780435e01aa4b4609e6aa66995e73b1fe586869c545d41a0063b0ec`; prepared/static review only, never compiled or executed |
| C3/C4 placement artifacts, source fixes and later qualification | Outside this separate failure/diagnostic record; no inferred results |

`inspection/omitted-inputs.sha256` hashes available local omitted files without
copying or running them. Original raw manifests can therefore name files
deliberately absent here or original absolute paths. Those are identity records;
use the portable `package.sha256` for included files. Empty report/file lists
describe actual absence; no empty directory or omitted executable is represented
as a passing runtime result. Original external files remain at their recorded
task-owned locations; availability to readers is not promised.
