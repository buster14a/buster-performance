/* Frozen family dispositions and scope notes, derived from the retained
 * reports at d3453eb. Original first-party adapter metadata.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception */
typedef struct HistoryFamily HistoryFamily;
struct HistoryFamily
{
    const char *name;
    size_t expected_files;
    const char *scope;
    const char *disposition;
    const char *reason;
    size_t files;
    uint64_t source_rows;
    uint64_t source_cells;
};

static HistoryFamily history_families[] = {
    {
        .name = "c-body-bindings-2026-10-23",
        .expected_files = 3,
        .scope = "Whole supported source path; 1/8 lanes; 8-lane thread cycles unavailable; storage versus capacity.",
        .disposition = "unsupported",
        .reason = "Free-form report/harness retained; no versioned numeric log grammar is declared."
    },
    {
        .name = "c-checker-2026-10-23",
        .expected_files = 3,
        .scope = "Checker-only synthetic source timing excludes preprocessing/parsing; -1 hardware counters mean unavailable; corpus refusals are not timings.",
        .disposition = "unsupported",
        .reason = "Free-form logs embedded in report; source bytes retained without inventing observation rows."
    },
    {
        .name = "c-checker-completion-2026-10-23",
        .expected_files = 3,
        .scope = "Protocol/launcher only; target campaign was planned, not run.",
        .disposition = "planned",
        .reason = "No retained measured observations exist; no timing rows are emitted."
    },
    {
        .name = "c-environments-2026-10-23",
        .expected_files = 4,
        .scope = "Fresh type setup, parsing, publication, checking; process ranges and exact fingerprints.",
        .disposition = "unsupported",
        .reason = "Free-form report/harness retained; no versioned numeric log grammar is declared."
    },
    {
        .name = "c-lowering-2026-10-23",
        .expected_files = 21,
        .scope = "Process medians; cycles/instructions; graph edges/rounds/batches; preparation includes selection.",
        .disposition = "partial",
        .reason = "Structured source cells retained exactly; arbitrary columns are not yet assigned comparison eligibility."
    },
    {
        .name = "foreign-cie-2026-10-23",
        .expected_files = 8,
        .scope = "Whole-link pooling; image/arena sizes; TSC ticks; warmed controls; bounded qualification.",
        .disposition = "unsupported",
        .reason = "Original logs retained; phase windows cannot be inferred from field spelling."
    },
    {
        .name = "foreign-gc-2026-10-23",
        .expected_files = 7,
        .scope = "Whole-link optional section GC; correctness and input/output/retained bytes.",
        .disposition = "unsupported",
        .reason = "Original logs retained; no new whole-compiler performance claim."
    },
    {
        .name = "foreign-strings-2026-10-23",
        .expected_files = 104,
        .scope = "288 process/case/path medians and 12 whole-process resource rows; nonadditive phase medians; inner 11 are not independent processes.",
        .disposition = "imported",
        .reason = "Versioned foreign-strings.first-party.v2 conversion preserves all 7,308 source cells and exact typed values."
    },
    {
        .name = "header-replay-2026-10-23",
        .expected_files = 239,
        .scope = "Negative result; alternating passes; whole-batch RSS; local per-header distributions remain separate.",
        .disposition = "partial",
        .reason = "Structured source cells retained; local/target and whole-batch/per-header populations remain uncombined."
    },
    {
        .name = "linker-shared-tls-2026-10-23",
        .expected_files = 130,
        .scope = "Writer-only times exclude whole-command perf-counter work; historical workers is workload size, not writer lanes.",
        .disposition = "partial",
        .reason = "Structured source cells retained with writer-versus-process scope; no guessed lane or counter normalization."
    },
    {
        .name = "parser-bindings-128-2026-10-23",
        .expected_files = 1,
        .scope = "Preparation/source/isolated costs per source identifier; capacity is not RSS.",
        .disposition = "unsupported",
        .reason = "Only a report is retained; no raw observation sequence is reconstructed."
    },
    {
        .name = "parser-c-testsuite-2026-10-23",
        .expected_files = 17,
        .scope = "Per-file correctness/first-error/oracle coverage; absence of timing remains absence.",
        .disposition = "partial",
        .reason = "Structured acceptance rows preserved as evidence, never invented performance observations."
    },
    {
        .name = "preprocessor-117-2026-10-23",
        .expected_files = 86,
        .scope = "Frozen corpus/header/configuration identities; phase/whole timings; counters and exit receipts.",
        .disposition = "partial",
        .reason = "Source cells remain segmented by file/protocol; unavailable precision is not reconstructed."
    },
    {
        .name = "preprocessor-cloud-2026-10-23",
        .expected_files = 117,
        .scope = "Paired raw passes/fresh processes/warmups; phase TSC; preliminary zero hardware counters unavailable; uint64 digests remain exact strings.",
        .disposition = "partial",
        .reason = "Source cells preserve warmup/order, exact digests and original counter tokens; no cross-host regression classification."
    },
    {
        .name = "refinement-budget-2026-10-23",
        .expected_files = 230,
        .scope = "Candidate screens; adjacent setup/whole cost; negative and incomplete experiments; budget policy.",
        .disposition = "partial",
        .reason = "Source cells and campaign artifacts retained; discarded/incomplete screens are not promoted to completed measurements."
    },
    {
        .name = "simd-301-2026-10-23",
        .expected_files = 13,
        .scope = "Cloud screens use unrelated work units; spread matters; zero hardware counters mean unavailable.",
        .disposition = "unsupported",
        .reason = "Free-form reports retained; no target-host or common-denominator inference."
    },
    {
        .name = "ssa-2026-10-23",
        .expected_files = 2,
        .scope = "Synthetic CFG/IR scope; calibrated repeats; core cycles; exact merge checkout identity.",
        .disposition = "unsupported",
        .reason = "Original report/harness retained; no source-corpus timing is fabricated."
    },
    {
        .name = "x86-lengths-2026-10-23",
        .expected_files = 48,
        .scope = "Combined producer/consumer differs from isolated phases; weak scaling; incomplete pair census.",
        .disposition = "partial",
        .reason = "Structured source cells retained; missing pairs and revised target evidence remain explicit."
    },
    {
        .name = "x86-zen5-2026-10-22",
        .expected_files = 7,
        .scope = "Instruction experiments: actual core cycles/macro-ops, code hashes, Q8 models and unknown sentinel.",
        .disposition = "unsupported",
        .reason = "Original instruction evidence retained; model observations are not end-to-end compiler results."
    }
};
