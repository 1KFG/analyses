#PBS -l nodes=1:ppn=1 -j oe -N hmmalign
module load trimal
module load hmmer/3.1b1
DBDIR=HMM/Roz200/HMM3
DIR=aln/Roz200
LIST=alnlist # this is the list file
N=$PBS_ARRAYID
if [ ! $N ]; then
  N=$1
fi

if [ ! $N ]; then
 echo "need to have a job id"
 exit;
fi

G=`head -n $N $LIST | tail -n 1`
marker=`basename $G .fa`
if [ ! -f $DIR/$marker.msa ]; then
 hmmalign --trim --amino $DBDIR/$marker.hmm $DIR/$marker.fa > $DIR/$marker.msa
fi

if [ ! -f $DIR/$marker.aln ]; then
 sreformat clustal $DIR/$marker.msa > $DIR/$marker.aln
fi

if [ ! -f $DIR/$marker.msa.trim ]; then
 trimal -automated1 -fasta -in $DIR/$marker.aln -out $DIR/$marker.msa.trim
fi
