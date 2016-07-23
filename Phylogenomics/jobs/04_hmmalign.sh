#PBS -l nodes=1:ppn=1 -j oe -N hmmalign.JGI1086 -l walltime=4:00:00
module load trimal
module load hmmer/3
DBDIR=HMM/JGI_1086/HMM3
DIR=aln/JGI_1086
LIST=alnlist.JGI_1086 # this is the list file
N=$PBS_ARRAYID
if [ ! $N ]; then
  N=$1
fi

if [ ! $N ]; then
 echo "need to have a job id"
 exit;
fi

G=`sed -n ${N}p $LIST`
marker=`basename $G .fa`
echo "marker is $marker for gene $G $N from $LIST"

if [ ! -f $DIR/$marker.msa ]; then
 hmmalign --trim --amino $DBDIR/$marker.hmm $DIR/$marker.fa | perl -p -e 's/^>(\d+)\|/>/' > $DIR/$marker.msa
fi

if [ ! -f $DIR/$marker.aln ]; then
 esl-reformat --replace=\*:-  --gapsym=- clustal $DIR/$marker.msa > $DIR/$marker.1.aln
 esl-reformat --replace=x:- clustal $DIR/$marker.1.aln > $DIR/$marker.aln
fi

if [ ! -f $DIR/$marker.msa.trim ]; then
 trimal -resoverlap 0.50 -seqoverlap 60 -in $DIR/$marker.aln -out $DIR/$marker.msa.filter
 trimal -automated1 -fasta -in $DIR/$marker.msa.filter -out $DIR/$marker.msa.trim 
fi
