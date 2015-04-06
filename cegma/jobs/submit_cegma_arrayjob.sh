#PBS -l nodes=1:ppn=4,mem=24gb -q js -N cegma -j oe -l walltime=12:00:00

module load cegma
module load hmmer
module load wise
module load geneid
module load stajichlab
module load snap
module load augustus/2.7
module load ncbi-blast/2.2.25+
hostname

if [ ! $PBS_NP ]; then
 PBS_NP=1
fi

BASE=/shared/stajichlab/projects/1KFG
DBFOLDER=$BASE/genomes/final_combine/DNA

LISTFILE=genome_list

if [ ! -f $LISTFILE ]; then
 ls $DBFOLDER > $LISTFILE
fi

JOB=$PBS_ARRAYID
if [ ! $JOB ]; then
 # take from CMDLINE
 JOB=$1
fi

if [ ! $JOB ]; then
 echo "need to provide a job ID on cmdline or via -t option in qsub"
 exit
fi

GENOME=`head -n $JOB $LISTFILE | tail -n 1`
BASE=`basename $GENOME .fasta`

if [ ! -d $BASE.cegma ]; then
 mkdir -p $BASE.cegma
 cd $BASE.cegma
 cegma -g $DBFOLDER/$GENOME -T $PBS_NP --max_intron 2000
# echo cegma -g $DBFOLDER/$GENOME -T $PBS_NP --max_intron 2000
else
 echo "CEGMA already run for $BASE ($GENOME)"
fi

