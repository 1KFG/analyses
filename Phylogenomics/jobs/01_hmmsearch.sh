#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=2G
#SBATCH --time=2:00:00
#SBATCH --job-name=hmmsearch

module load hmmer/3
N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$SLURM_ARRAY_TASK_ID 
fi

PEPDIR=pep
MARKERS=HMM/JGI_1086/markers_3.hmmb
CUTOFF=1e-10
OUT=search/JGI_1086
LIST=list # this is the list file

if [ ! $N ]; then
  N=$1
fi

if [ ! $N ]; then
 echo "need to have a job id"
 exit;
fi

CPU=$PBS_NP
if [ ! $CPU ]; then
 CPU=$SLURM_JOB_CPUS_PER_NODE
 if [ ! $CPU ]; then
  CPU=1
 fi
fi

mkdir -p $OUT
G=`sed -n ${N}p $LIST`
NM=`basename $G .aa.fasta`
echo "g=$G"

if [ ! -f "$OUT/$NM.domtbl" ]; then
 hmmsearch --cpu $CPU -E $CUTOFF --domtblout $OUT/$NM.domtbl $MARKERS $PEPDIR/$G >& $OUT/$NM.log
fi
