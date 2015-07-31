#PBS -l nodes=1:ppn=4,mem=24gb -N cegma -j oe -l walltime=12:00:00
module load perl
module load cegma
hostname

if [ ! $PBS_NP ]; then
 PBS_NP=1
fi

BASE=/bigdata/stajichlab/shared/projects/1KFG
DBFOLDER=$BASE/genomes/final_combine/DNA

LISTFILE=genome_list
MAX_INTRON=1500
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
fi
if [ ! -f $BASE.cegma/output.completeness_report ]; then
 cd $BASE.cegma
 perl -p -e 's/>(\S+)\|(\S+)/>$2/' $DBFOLDER/$GENOME > $GENOME
 cegma -g $GENOME -T $PBS_NP --max_intron $MAX_INTRON
# echo cegma -g $GENOME -T $PBS_NP --max_intron $MAX_INTRON
else
 echo "CEGMA already run for $BASE ($GENOME)"
fi

