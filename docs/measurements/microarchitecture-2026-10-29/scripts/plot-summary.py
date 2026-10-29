#!/usr/bin/env python3
"""Three views from distinct measurement cohorts; do not infer CPU speedup."""
import argparse
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

p = argparse.ArgumentParser()
p.add_argument('output')
a = p.parse_args()
plt.rcParams.update({'font.size': 12, 'axes.spines.top': False, 'axes.spines.right': False,
                     'figure.facecolor': '#f8fafc', 'axes.facecolor': '#f8fafc'})
fig, axes = plt.subplots(1, 3, figsize=(19, 6), layout='constrained')
fig.suptitle('Buster: SQLite compile scaling and synthetic IR-pass costs',
             fontsize=20, fontweight='bold', color='#12304a')
for ax, workers, throughput, title, color, factor in [
    (axes[0], [1, 2, 4, 6], [54.96, 105.48, 169.81, 202.33], '7940HS: local', '#087f8c', '3.68× at 6 cores'),
    (axes[1], [1, 2, 4, 8], [73.82, 124.50, 189.14, 227.81], '9700X: locked host', '#4c60a8', '3.09× at 8 cores'),
]:
    ax.plot(workers, throughput, color=color, linewidth=3, marker='o', markersize=8)
    for x, y in zip(workers, throughput):
        ax.annotate(f'{y:.1f}', (x, y), xytext=(0, 9), textcoords='offset points',
                    ha='center', fontweight='bold', fontsize=10)
    ax.set(xlabel='Independent one-lane compiles', ylabel='Original source MB/s',
           title=title, ylim=(0, 260))
    ax.set_xticks(workers)
    ax.grid(axis='y', alpha=.18)
    ax.text(.05, .91, factor, transform=ax.transAxes, color=color, fontweight='bold', fontsize=11)
ax = axes[2]
labels = ['GVN DAG\n4,100 instructions', 'LICM chain\n4,109 instructions']
scalar, vector = [262.54, 282.54], [1286.35, 809.63]
for i in range(2):
    ax.barh(i + .18, scalar[i], height=.3, color='#597a95', label='Scalar' if i == 0 else None)
    ax.barh(i - .18, vector[i], height=.3, color='#e28840', label='Vector' if i == 0 else None)
    ax.text(vector[i] + 24, i - .18, f'{vector[i] / scalar[i]:.2f}×',
            va='center', fontweight='bold', fontsize=11)
ax.set_yticks([0, 1], labels)
ax.invert_yaxis()
ax.set(xlabel='Median whole-pass time, µs', title='9700X: synthetic IR passes', xlim=(0, 1500))
ax.grid(axis='x', alpha=.18)
ax.legend(loc='lower right', frameon=False, fontsize=10)
fig.text(.5, -.03,
         'Scaling: 5 rounds per host, different builds and environments; not a controlled CPU comparison. '
         'IR: 21 interleaved samples; not current -c throughput.',
         ha='center', fontsize=10, color='#435565')
fig.savefig(a.output, dpi=150, bbox_inches='tight')
