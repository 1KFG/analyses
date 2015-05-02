#PBS -l nodes=1:ppn=2 -N Roz.HMMsearch -j oe
module load hmmer/3.1b1
N=$PBS_ARRAYID
PEPDIR=pep
MARKERS=HMM/Roz200/markers_3.hmmb
CUTOFF=1e-10
OUT=search/Roz200
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
 CPU=1
fi

mkdir -p $OUT
G=`head -n $N $LIST | tail -n 1`
NM=`basename $G .aa.fasta`
echo "g=$G"

if [ ! -f "$OUT/$NM.domtbl" ]; then
 hmmsearch --cpu $CPU -E $CUTOFF --domtblout $OUT/$NM.domtbl $MARKERS $PEPDIR/$G >& $OUT/$NM.log
fi
