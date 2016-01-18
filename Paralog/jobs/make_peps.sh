#PBS -l nodes=1:ppn=1,mem=2gb -j oe
module load perl
cd /bigdata/stajichlab/shared/projects/1KFG/analysis/Paralog/transcripts

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi
if [ ! $N ]; then
 echo "Need a cmdline or PBS_ARRAYID value"
 exit
fi
file=`ls *.CDS.fasta | sed -n ${N}p`
base=`basename $file .CDS.fasta`
if [ ! -f ../pep/$base.pep.fasta ]; then
  perl /bigdata/stajichlab/shared/projects/1KFG/analysis/Paralog/jobs/bp_translate_seq.pl $file > ../pep/$base.pep.fasta
fi
