-- Native Perfetto v58.2 fixture queries. All data is deliberately synthetic.
-- The source clock origin is 1,000,000,000 ns; selections are half-open.
WITH RECURSIVE
  sample_ancestors(sample_id, ts, frame_id, parent_id) AS (
    SELECT p.id, p.ts, c.frame_id, c.parent_id
    FROM perf_sample p JOIN stack_profile_callsite c ON c.id = p.callsite_id
    UNION ALL
    SELECT a.sample_id, a.ts, c.frame_id, c.parent_id
    FROM sample_ancestors a JOIN stack_profile_callsite c ON c.id = a.parent_id
  ),
  leaf AS (
    SELECT p.ts, f.name
    FROM perf_sample p
    JOIN stack_profile_callsite c ON c.id = p.callsite_id
    JOIN stack_profile_frame f ON f.id = c.frame_id
  )
SELECT 'total_samples' AS metric, COUNT(*) AS value FROM perf_sample
UNION ALL SELECT 'self_all_' || name, COUNT(*) FROM leaf GROUP BY name
UNION ALL SELECT 'selected_samples', COUNT(*) FROM perf_sample WHERE ts >= 1002000000 AND ts < 1007000000
UNION ALL SELECT 'self_selected_' || name, COUNT(*) FROM leaf WHERE ts >= 1002000000 AND ts < 1007000000 GROUP BY name
UNION ALL SELECT 'inclusive_' || f.name, COUNT(DISTINCT a.sample_id)
  FROM sample_ancestors a JOIN stack_profile_frame f ON f.id = a.frame_id
  WHERE f.name IN ('main', 'worker') GROUP BY f.name
UNION ALL SELECT 'parse_ns', dur FROM slice WHERE name = 'parse'
UNION ALL SELECT 'encode_ns', dur FROM slice WHERE name = 'encode task'
UNION ALL SELECT 'main_instrumented_self_ns', c.dur - p.dur FROM slice c JOIN slice p ON p.parent_id = c.id WHERE c.name = 'compile' AND p.name = 'parse'
UNION ALL SELECT 'dispatch_flows', COUNT(*) FROM flow
UNION ALL SELECT 'counter_points_' || t.name, COUNT(*) FROM counter c JOIN counter_track t ON t.id = c.track_id WHERE t.name IN ('Resident bytes','Package energy') GROUP BY t.name
UNION ALL SELECT 'main_runnable_ns', SUM(s.dur) FROM thread_state s JOIN thread t USING(utid) WHERE t.tid=100 AND s.state='R'
UNION ALL SELECT 'parser_error_or_loss_stats', COUNT(*) FROM stats WHERE value != 0 AND severity IN ('error','data_loss')
ORDER BY metric;
