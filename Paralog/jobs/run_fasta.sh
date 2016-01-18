#PBS -l nodes=1:ppn=4,mem=2gb -j oe -N fastaSelf
module load fasta

CPU=$PBS_NUM_PPN

if [ ! $CPU ]; then
 CPU=1
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi
if [ ! $N ]; then 
 echo "Need a cmdline or PBS_ARRAYID value"
 exit
fi
INFILE=files
F=`sed -n ${N}p $INFILE`
OUT=results
base=`basename $F .pep.fasta`
fasta36 -T $CPU -E 1e-15 -m 8c $F $F > $OUT/$base.FASTA.tab
