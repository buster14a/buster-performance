lowering-nodes	evaluated=4	batched=0	share=0.00%	classified=0	templates=0	template-share=0.00%	template-entries=0	entry-share=0.00%
time-stage	stage	ms	percent	system-ms	minor-faults	peak-kb-added
time-stage	setup	0.126	6.1	0.132	70	4728
time-stage	lanes-start	0.009	0.4	0.010	6	24
time-stage	preprocess	0.418	20.1	0.416	167	820
time-stage	preprocess.read	0.074	3.6
time-stage	preprocess.lex	0.059	2.9
time-stage	preprocess.refine	0.051	2.5
time-stage	preprocess.directives	0.021	1.0
time-stage	preprocess.main-loop	0.212	10.2
time-stage	parse	0.091	4.4	0.093	31	2228
time-stage	type-table	0.017	0.8	0.018	28	112
time-stage	check-input	0.367	17.7	0.364	56	4812
time-stage	check-expressions	0.014	0.7	0.017	1	4
time-stage	check-declarations	0.007	0.3	0.007	0	0
time-stage	static-data	0.006	0.3	0.006	0	0
time-stage	check-program	0.110	5.3	0.109	11	1972
time-stage	select	0.021	1.0	0.021	3	0
time-stage	backend-setup	0.003	0.2	0.004	0	0
time-stage	lower	0.048	2.3	0.076	26	992
time-stage	lower.prepare	0.020	1.0
time-stage	lower.statements	0.005	0.2
time-stage	lower.bodies	0.009	0.4
time-stage	lower.validate	0.006	0.3
time-stage	lower.rest	0.009	0.4
time-stage	tier0	0.018	0.9	0.000	0	0
time-stage	emit-setup	0.116	5.6	0.115	14	4264
time-stage	lanes	0.000	0.0	0.000	0	0
time-stage	branch-sizing	0.004	0.2	0.000	0	0
time-stage	encode	0.002	0.1	0.000	0	0
time-stage	unwind	0.007	0.3	0.004	1	64
time-stage	code-atoms	0.010	0.5	0.010	1	64
time-stage	debug	0.003	0.1	0.003	0	0
time-stage	publish-data	0.018	0.9	0.018	2	128
time-stage	object-build	0.000	0.0	0.000	0	0
time-stage	object-write	0.000	0.0	0.000	0	0
time-stage	runtime	0.053	2.6	0.053	19	1120
time-stage	executable	0.354	17.0	0.352	86	4300
time-stage	write	0.209	10.1	0.209	86	344
time-stage	release	0.044	2.1	0.046	0	0
time-stage	total	2.075	100.0
time-check	expressions	0.017	0.8
time-check	expressions.classes	0.001	0.0
time-check	expressions.prepare	0.007	0.3
time-check	expressions.actions	0.009	0.4
time-check	expressions.visits	0.000	0.0
time-check	expressions.usage	0.017	5
time-check	transition-hits	0
time-check	transition-misses	0
time-check	transition-folds	0
time-check	transition-entries	0
time-write	count	0.038
time-write	layout	0.024
time-write	symbols	0.010
time-write	dynamic	0.008
time-write	open	0.008
time-write	chunks	0.115
time-write	finish	0.001
time-process	tsc-mhz	3792.5
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
time-process	peak-rss-kb	36536
time-process	peak-rss-start-kb	10560
time-process	user-ms	0.000
time-process	system-ms	2.399
time-process	rusage-peak-rss-kb	36400
time-process	minor-faults	755
time-process	major-faults	0
time-process	voluntary-switches	0
time-process	involuntary-switches	1
worker-budget	mode=none	limit=64	requested=1	granted=1	active=1	grown=0	worked=1	fallback=0
