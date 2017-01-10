#!/usr/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4G

perl scripts/summarize_RM.pl > repeat_summary.tab
