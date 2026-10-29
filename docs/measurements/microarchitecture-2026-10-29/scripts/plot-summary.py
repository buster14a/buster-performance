#!/usr/bin/env python3
"""Two independent views; the panels use different workloads and machines."""
import argparse
from pathlib import Path
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

p=argparse.ArgumentParser();p.add_argument('output');a=p.parse_args()
plt.rcParams.update({'font.size': 12, 'axes.spines.top': False, 'axes.spines.right': False,
                     'figure.facecolor': '#f8fafc', 'axes.facecolor': '#f8fafc'})
fig,axes=plt.subplots(1,2,figsize=(14.8,5.8),layout='constrained')
fig.suptitle('Buster: observed scaling and IR-pass costs',fontsize=19,fontweight='bold',color='#12304a')
ax=axes[0]
workers=[1,2,4,6]; throughput=[54.96,105.48,169.81,202.33]
ax.plot(workers,[54.96*n for n in workers],color='#a3afba',linestyle='--',label='Linear scaling from one core')
ax.plot(workers,throughput,color='#087f8c',linewidth=3,marker='o',markersize=8,label='Measured median')
for x,y in zip(workers,throughput): ax.annotate(f'{y:.1f}',(x,y),xytext=(0,9),textcoords='offset points',ha='center',fontweight='bold',fontsize=10)
ax.set(xlabel='Independent one-lane compiles',ylabel='Original source MB/s',title='7940HS: SQLite compilation')
ax.set_xticks(workers);ax.grid(axis='y',alpha=.18);ax.legend(loc='upper left',fontsize=9,frameon=False)
ax=axes[1]
labels=['GVN DAG\n4,100 instructions','LICM chain\n4,109 instructions'];scalar=[262.54,282.54];vector=[1286.35,809.63]
for i in range(2):
 ax.barh(i+.18,scalar[i],height=.3,color='#597a95',label='Scalar' if i==0 else None)
 ax.barh(i-.18,vector[i],height=.3,color='#e28840',label='Vector' if i==0 else None)
 ax.text(vector[i]+24,i-.18,f'{vector[i]/scalar[i]:.2f}×',va='center',fontweight='bold',fontsize=11)
ax.set_yticks([0,1],labels);ax.invert_yaxis();ax.set(xlabel='Median whole-pass time, µs',title='9700X: synthetic IR passes')
ax.set_xlim(0,1500);ax.grid(axis='x',alpha=.18);ax.legend(loc='lower right',frameon=False,fontsize=9)
fig.text(.5,-.03,'Five local scaling rounds; 9700X pass results use 21 interleaved samples. Synthetic IR results are not current -c throughput.',ha='center',fontsize=9,color='#435565')
fig.savefig(a.output,dpi=150,bbox_inches='tight')
