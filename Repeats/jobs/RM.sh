#!/usr/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem-per-cpu=2G
#SBATCH --time=0-24:00:00

module load RepeatMasker/4-0-6
CPU=16
if [ $PBS_NP ]; then
 CPU=$PBS_NP
fi

N=${SLURM_ARRAY_TASK_ID}
DIR=DNA
ODIR=results

mkdir -p $ODIR

if [ ! $N ]; then
 N=$PBS_ARRAYID
 if [ ! $N ]; then
  N=$1
 fi
 if [ ! $N ]; then
  echo "need an array job ID"
  exit
 fi
fi

FILE=$(ls $DIR/*.fasta | sed -n ${N}p)
OFILE=$(basename $FILE)
if [ -f $ODIR/$OFILE.out ]; then
 echo "skipping - already processed $OFILE"
else
 RepeatMasker -species fungi -s -pa $CPU -gff $FILE -dir $ODIR
fi
