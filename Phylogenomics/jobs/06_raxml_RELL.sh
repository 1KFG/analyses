#!/usr/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --mem-per-cpu=1G
#SBATCH --mail-type=ALL
#SBATCH --job-name=raxml.RELL

module load RAxML

CPU=2
if [ $SLURM_JOB_CPUS_PER_NODE ]; then
 CPU=$SLURM_JOB_CPUS_PER_NODE
fi

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

# -l nodes=1:ppn=32 -q batch -N raxmlRELL -j oe

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi
if [ -f config.txt ]; then
 source config.txt
else
 PREFIX=ALL
 OUT=Pult
fi
count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=$PREFIX.$datestr".JGI1086".${count}sp
IN=all_${count}.JGI_1086
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
fi

cd phylo
raxmlHPC-PTHREADS-AVX -T $CPU -f D -p 771 -o $OUT -m PROTGAMMALG \
  -s $str.fasaln -n ${PREFIX}_RELL.$str 
