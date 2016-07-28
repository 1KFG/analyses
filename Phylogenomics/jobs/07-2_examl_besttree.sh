#PBS -l nodes=4:ppn=3,mem=4gb -N ExaML.Best -j oe
module load ExaML
module load RAxML
# need starting tree 

N=$PBS_ARRAYID
if [ "$N" == "" ]; then
 N=$1
fi
if [ "$N" == "" ]; then
 echo "no array id or cmdline ID provided"
 exit
fi

PARTITION=partition_all.txt
BASE=aln
if [ ! -f ${BASE}.binary ]; then
 convertFasta2Phylip.sh $BASE > $BASE.phy
 parse-examl -s $BASE.phy -m PROT -n ${BASE}_Best -q $PARTITION
fi


mpirun examl-AVX -s ${BASE}_Best.binary -m GAMMA \
 -n all_Phylo.T$N -f d --auto-prot=aic -t RAxML_parsimonyTree.T$N

