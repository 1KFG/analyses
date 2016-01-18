#PBS -l nodes=1:ppn=1,mem=1gb -j oe -N makepair -l walltime=1:00:00

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi
if [ ! $N ]; then 
 echo "Need a cmdline or PBS_ARRAYID value"
 exit
fi
INFILE=fasta_results.txt
F=`sed -n ${N}p $INFILE`
perl jobs/make_pair_seqfiles.pl $F
