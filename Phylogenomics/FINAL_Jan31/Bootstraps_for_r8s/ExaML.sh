#PBS -j oe -N examl -l nodes=1:ppn=24,mem=48gb -q highmem -l walltime=2:00:00 


module load ExaML
BASE=all.JGI_1086.351.fasaln
DIR=BS
TREE=RAxML_bipartitions.allseq_JGI_1086.351.1KFG.tre
N=$PBS_ARRAYID
if [ "$N" == 0 ]; then
 echo "ok"
elif [ ! $N ]; then 
 N=$1
fi

if [ ! $N ]; then
 echo "No PBS_ARRAY_ID or cmdline num"
 exit
fi 
if [ -f ExaML_TreeFile.BS${N} ]; then
 echo "already run BS$N skipping"
else
 if [ ! -f BS${N}.binary ]; then
  parse-examl -m PROT -s $DIR/${BASE}.BS${N} -n BS${N} -q LG_partition.txt
 fi
 rm -f ExaML_info.BS${N}
 mpirun examl -s BS${N}.binary -t $TREE -m GAMMA -n BS${N} -f E
fi
