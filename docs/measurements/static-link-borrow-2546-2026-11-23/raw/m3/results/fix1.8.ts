lowering-nodes	evaluated=4	batched=0	share=0.00%	classified=0	templates=0	template-share=0.00%	template-entries=0	entry-share=0.00%
time-stage	stage	ms	percent	system-ms	minor-faults	peak-kb-added
time-stage	setup	0.108	5.7	0.000	72	4736
time-stage	lanes-start	0.009	0.5	0.000	6	24
time-stage	preprocess	0.408	21.5	0.000	167	820
time-stage	preprocess.read	0.071	3.8
time-stage	preprocess.lex	0.058	3.1
time-stage	preprocess.refine	0.050	2.7
time-stage	preprocess.directives	0.021	1.1
time-stage	preprocess.main-loop	0.207	10.9
time-stage	parse	0.069	3.7	0.068	31	2228
time-stage	type-table	0.017	0.9	0.017	28	112
time-stage	check-input	0.345	18.2	0.343	56	4812
time-stage	check-expressions	0.013	0.7	0.016	1	4
time-stage	check-declarations	0.006	0.3	0.006	0	0
time-stage	static-data	0.006	0.3	0.006	0	0
time-stage	check-program	0.079	4.2	0.078	10	1968
time-stage	select	0.023	1.2	0.023	3	0
time-stage	backend-setup	0.003	0.2	0.004	0	0
time-stage	lower	0.044	2.3	0.068	26	992
time-stage	lower.prepare	0.019	1.0
time-stage	lower.statements	0.004	0.2
time-stage	lower.bodies	0.008	0.4
time-stage	lower.validate	0.005	0.2
time-stage	lower.rest	0.009	0.5
time-stage	tier0	0.016	0.9	0.000	0	0
time-stage	emit-setup	0.077	4.1	0.077	14	4264
time-stage	lanes	0.000	0.0	0.000	0	0
time-stage	branch-sizing	0.004	0.2	0.000	0	0
time-stage	encode	0.002	0.1	0.000	0	0
time-stage	unwind	0.006	0.3	0.004	1	64
time-stage	code-atoms	0.009	0.5	0.010	1	64
time-stage	debug	0.003	0.1	0.002	0	0
time-stage	publish-data	0.019	1.0	0.019	2	128
time-stage	object-build	0.000	0.0	0.000	0	0
time-stage	object-write	0.000	0.0	0.000	0	0
time-stage	runtime	0.051	2.7	0.051	19	1120
time-stage	executable	0.335	17.7	0.334	86	4300
time-stage	write	0.198	10.5	0.198	86	344
time-stage	release	0.043	2.3	0.045	0	0
time-stage	total	1.894	100.0
time-check	expressions	0.016	0.9
time-check	expressions.classes	0.001	0.1
time-check	expressions.prepare	0.006	0.3
time-check	expressions.actions	0.008	0.4
time-check	expressions.visits	0.000	0.0
time-check	expressions.usage	0.017	5
time-check	transition-hits	0
time-check	transition-misses	0
time-check	transition-folds	0
time-check	transition-entries	0
time-write	count	0.035
time-write	layout	0.022
time-write	symbols	0.010
time-write	dynamic	0.008
time-write	open	0.008
time-write	chunks	0.110
time-write	finish	0.001
time-process	tsc-mhz	3792.4
time-process	tokens	2991
time-process	lanes-asked	1
time-process	lanes	1
time-process	huge-pages	system
time-process	stage-system-source	getrusage-rusage-self-ru-stime
time-process	stage-system-boundary	resource-marks
time-process	stage-system-status	available
time-process	stage-system-accuracy	low-confidence
time-process	stage-system-reason	resource-mark-getrusage-deltas
time-process	stage-system-validation	docs-compile-time-clock-accounting-control
time-process	stage-system-use	do-not-rank-or-subtract-from-elapsed
time-process	peak-rss-source	proc-self-status-vmhwm
time-process	peak-rss-scope	post-exec-through-last-mark
time-process	peak-rss-precision	approximate
time-process	peak-rss-status	available
time-process	peak-rss-kb	36544
time-process	peak-rss-start-kb	10564
time-process	user-ms	0.892
time-process	system-ms	1.404
time-process	rusage-peak-rss-kb	36408
time-process	minor-faults	755
time-process	major-faults	0
time-process	voluntary-switches	0
time-process	involuntary-switches	1
worker-budget	mode=none	limit=64	requested=1	granted=1	active=1	grown=0	worked=1	fallback=0
