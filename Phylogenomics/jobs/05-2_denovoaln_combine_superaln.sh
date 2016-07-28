#PBS -l nodes=1:ppn=1 -j oe -N combineAll
module load RAxML

if [ ! -f expected ]; then
 bash jobs/make_expected_file.sh
fi
EXPECTEDNAMES=expected
MARKERS=JGI_1086
count=`wc -l $EXPECTEDNAMES | awk '{print $1}'`
#echo "count is $count"
perl scripts/combine_fasaln.pl -ext autotrim -o all_${count}.denovo.${MARKERS}.fasaln -of fasta -d aln/$MARKERS -expected $EXPECTEDNAMES > all_${count}.denovo.${MARKERS}.partitions.txt
convertFasta2Phylip.sh all_${count}.denovo.${MARKERS}.fasaln > all_${count}.denovo.${MARKERS}.phy
