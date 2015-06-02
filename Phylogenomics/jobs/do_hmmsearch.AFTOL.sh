#PBS -l nodes=1:ppn=2 -N AFTOL.HMMsearch -j oe
module load hmmer/3.1b1
N=$PBS_ARRAYID
PEPDIR=pep
MARKERS=HMM/AFTOL_70/markers_3.hmmb
CUTOFF=1e-25
OUT=search/AFTOL70
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

G=`head -n $N $LIST | tail -n 1`
NM=`basename $G .aa.fasta`
echo "g=$G"

if [ ! -f "$OUT/$NM.domtbl" ]; then
 hmmsearch --cpu $CPU -E $CUTOFF --domtblout $OUT/$NM.domtbl $MARKERS $PEPDIR/$G >& $OUT/$NM.log
fi
