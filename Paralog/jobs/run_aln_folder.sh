#PBS -l nodes=1:ppn=1 -N MSA -j oe -l walltime=48:00:00
module load muscle
GENOMELIST=FILES
if [ ! -f $GENOMELIST ]; then
 ls *.pep > $GENOMELIST
fi

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

for base in `cat $GENOMELIST`;
do
 if [ ! -f $base.fasaln ]; then
  muscle -in $base -out $base.fasaln -quiet
 fi
done
