#PBS -l nodes=1:ppn=4,mem=2gb -j oe -l walltime=8:00:00 -N blastBlastoclad

module load ncbi-blast
PREFIX=blastoclad

MAXALN=20 # max # of alignments to show

N=$PBS_ARRAYID

if [ ! $N ]; then
 N=$1
fi
if [ ! $N ]; then 
 echo "No PBS_ARRAYID or CMDLINE arg for number"
 exit
fi

CPU=1
if [ $PBS_NP ]; then
 CPU=$PBS_NP
fi

DB1=chytrid_proteomes/chytridiomycota.aa
DB2=chytrid_proteomes/blastocladiomycota.aa
DB3=dikarya_zygo_proteomes/dikayra_zygo.aa

OUTSUF=`basename $DB1 .aa`
if [ ! -f run/$PREFIX.$N.$OUTSUF.BLASTP.tab ]; then

blastp -query run/$PREFIX.$N -db $DB1 -use_sw_tback -num_threads $CPU -out run/$PREFIX.$N.$OUTSUF.BLASTP.tab -outfmt 6 -evalue 1e-4 -seg yes -num_alignments $MAXALN
fi

OUTSUF=`basename $DB2 .aa`
if [ ! -f run/$PREFIX.$N.$OUTSUF.BLASTP.tab ]; then
blastp -query run/$PREFIX.$N -db $DB2 -use_sw_tback -num_threads $CPU -out run/$PREFIX.$N.$OUTSUF.BLASTP.tab -outfmt 6 -evalue 1e-4 -seg yes -num_alignments $MAXALN
fi

OUTSUF=`basename $DB3 .aa`
if [ ! -f run/$PREFIX.$N.$OUTSUF.BLASTP.tab ]; then
blastp -query run/$PREFIX.$N -db $DB3 -use_sw_tback -num_threads $CPU -out run/$PREFIX.$N.$OUTSUF.BLASTP.tab -outfmt 6 -evalue 1e-4 -seg yes -num_alignments $MAXALN
fi


