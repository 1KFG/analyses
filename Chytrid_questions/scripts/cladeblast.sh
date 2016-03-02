#PBS -l nodes=1:ppn=16,mem=2gb -j oe -l walltime=8:00:00 -N blastBlastoclad

module load ncbi-blast

MAXALN=20 # max # of alignments to show

N=$PBS_ARRAYID
LST=clades.dat
if [ ! -f $LST ]; then
 `ls *.fas > clades.dat`
fi

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

IN=`head -n $N $LST | tail -n 1`
PREF=`basename $IN .clade_only.fas`
if [ ! -f $PREF-vs-Dikarya.BLASTP.tab ]; then
 blastp -query $IN -db dikarya_zygo_proteomes/dikayra_zygo.aa -num_threads $CPU -use_sw_tback -outfmt 6 -evalue 1e-2 -seg yes -num_alignments $MAXALN -out $PREF-vs-Dikarya.BLASTP.tab
fi

