#PBS -l nodes=1:ppn=4 -N HMMmatch -j oe -l walltime=4:00:00
module load hmmer/3.1b1
CPU=4
F=$PBS_ARRAYID
CUTOFF=1e-10
MARKERS=/shared/stajichlab/projects/Phylogenomics/Phyling/DB/markers/euk45/markers_3.hmmb
GENOMELIST=genomes/FILES
OUT=genomes
if [ ! -f $GENOMELIST ]; then
 ls genomes/pep/*.fasta > $GENOMELIST
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

BASE=`basename $FILE .fasta`
#echo "FILE is $FILE. Base is $BASE"

if [ ! -f "$OUT/$BASE.domtbl" ]; then
echo "$OUT/$BASE.domtbl $MARKERS $FILE > $OUT/$BASE.hmmsearch"
hmmsearch --domtbl $OUT/$BASE.domtbl -E $CUTOFF --cpu $CPU $MARKERS $FILE > $OUT/$BASE.hmmsearch
fi
