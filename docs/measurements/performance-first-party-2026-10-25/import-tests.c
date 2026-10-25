/* Original bounded CSV, Git-identity and source-preservation regression probes.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
#define BUSTER_HISTORY_NO_MAIN
#include "import.c"

int main(void)
{
    HistoryCsv csv = {0};
    bool valid = history_csv(perf_literal("a,b\r\n\"x,y\",\"a\"\"b\"\r\n\"one\nline\",end\n\n"), ',', &csv);
    const char *expected[] = {"a", "b", "x,y", "a\"b", "one\nline", "end", ""};
    perf_expect(valid && csv.row_count == 4 && csv.count == 7, "CSV escaped, multiline, CRLF and blank source records retained");
    for (size_t i = 0; i < 7; ++i)
    {
        perf_expect(perf_bytes_equal(history_cell(&csv, i), perf_literal(expected[i])), "decoded CSV source cell exact");
    }
    history_csv_free(&csv);
    const char *empty_inputs[] = {"", "\n", ",", "\"\""};
    const size_t row_counts[] = {0, 1, 1, 1};
    const size_t cell_counts[] = {0, 1, 2, 1};
    for (size_t i = 0; i < 4; ++i)
    {
        HistoryCsv empty = {0};
        bool accepted = history_csv(perf_literal(empty_inputs[i]), ',', &empty);
        perf_expect(accepted && empty.row_count == row_counts[i] && empty.count == cell_counts[i], "empty file, blank record and empty cells remain distinct");
        for (size_t c = 0; c < empty.count; ++c)
        {
            perf_expect(history_cell(&empty, c).size == 0 && perf_utf8(history_cell(&empty, c)), "empty cell has a safe bounded slice");
        }
        history_csv_free(&empty);
    }
    const char *bad_inputs[] = {"\"unterminated", "\"closed\"x", "\"x\" \n"};
    for (size_t i = 0; i < 3; ++i)
    {
        HistoryCsv bad = {0};
        perf_expect(!history_csv(perf_literal(bad_inputs[i]), ',', &bad), "ambiguous quoted source rejected");
        history_csv_free(&bad);
    }
    HistoryCsv literal = {0};
    perf_expect(history_csv(perf_literal("path\terror: expected \"FILENAME\"\n"), '\t', &literal) && literal.count == 2 && perf_bytes_equal(history_cell(&literal, 1), perf_literal("error: expected \"FILENAME\"")), "frozen TSV diagnostic quotes retained as source text");
    history_csv_free(&literal);
    perf_expect(history_git_blob(perf_literal(""), perf_literal("e69de29bb2d1d6434b8b29ae775ad8c2e48c5391")), "Git empty-blob identity agrees with independent Git");
    perf_expect(history_git_blob(perf_literal("abc"), perf_literal("f2ba8f84ab5c1bce84a7b441cb1959cfc7093b7f")), "Git abc-blob identity agrees with independent Git");
    perf_expect(!history_git_blob(perf_literal("abd"), perf_literal("f2ba8f84ab5c1bce84a7b441cb1959cfc7093b7f")), "changed original bytes cannot retain frozen identity");
    perf_expect(history_revision("d7b07d3f71338b0844323fbf24b88c7bf11bff33") && !history_revision("0000000000000000000000000000000000000000") && !history_revision("missing"), "source revisions must be explicit nonzero Git IDs");
    PerfJson document = {0};
    HistoryPatch patch = {0};
    PerfBuffer output = {0};
    bool parsed = perf_json_parse(&document, perf_literal("{\"a\":1,\"b\":{\"x\":\"unchanged\"},\"c\":[1,2]}"));
    patch.node = perf_json_find(&document, 0, "a");
    bool replaced = parsed && perf_buffer_append(&patch.bytes, perf_literal("2")) && history_patched(&document, &patch, 1, &output);
    perf_expect(replaced && perf_bytes_equal(perf_buffer_bytes(&output), perf_literal("{\"a\":2,\"b\":{\"x\":\"unchanged\"},\"c\":[1,2]}")), "updating one fact retains all unrelated optional source metadata");
    free(patch.bytes.data);
    free(output.data);
    perf_json_free(&document);
    printf("{\"first_party\":true,\"checks\":%u,\"failures\":%u,\"scope\":\"CSV/Git/metadata source preservation; full frozen census is a separate integration check\"}\n", perf_checks, perf_failures);
    return perf_failures == 0 ? 0 : 1;
}
