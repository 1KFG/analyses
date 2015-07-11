#PBS -l nodes=1:ppn=4,mem=1gb,walltime=2:00:00 -j oe -N dbCAN.CAZY

CPU=$PBS_PPN
if [ ! $CPU ]; then
 CPU=1
fi

CUTOFF=1e-5
CAZYFOLDER=/srv/projects/db/CAZY/CAZyDB/
CAZYDB=$CAZYFOLDER/dbCAN-fam-HMMs.txt.v3
BASE=/bigdata/stajichlab/shared/projects/1KFG
DBFOLDER=$BASE/genomes/final_combine/pep

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
FILEBASE=`basename $GENOME .aa.fasta`

# hmmer 3.0 was used to build this library
module load hmmer

if [ ! -f $FILEBASE.dbCAN.hmmscan ]; then
hmmscan -E $CUTOFF --cpu $CPU --domtblout $FILEBASE.dbCAN_3.domtbl $CAZYDB $DBFOLDER/$GENOME > $FILEBASE.dbCAN.hmmscan
fi

if [ ! -f all.hmm.ps.len ]; then
 ln -s $CAZYFOLDER/all.hmm.ps.len .
fi

bash $CAZYFOLDER/hmmscan-parser.sh $FILEBASE.dbCAN.hmmscan > $FILEBASE.dbCAN.tab
