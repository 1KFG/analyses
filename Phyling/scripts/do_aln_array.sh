#PBS -l nodes=1:ppn=1 -N muscle -j oe
module load muscle
F=$PBS_ARRAYID
GENOMELIST=FILES
if [ ! -f $GENOMELIST ]; then
 ls aa/*.aa.rename > $GENOMELIST
fi

if [ ! $F ]; then
 F=$1
fi

if [ ! $F ]; then
 echo "no PBS_ARRAYID or input"
 exit
fi

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

FILE=`head -n $F $GENOMELIST | tail -n 1`
if [ ! $FILE ]; then
 echo "No input file - check PBS_ARRAYID or input number"
 exit
fi
b=`basename $FILE .rename`
d=`dirname $FILE`
if [ ! -d "$d-aln" ]; then
 mkdir -p "$d-aln"
fi

if [ ! -f "$d-aln/$b.fasaln" ]; then
 muscle -quiet -in $FILE -out $d-aln/$b.fasaln
fi
