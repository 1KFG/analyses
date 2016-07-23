#PBS -l nodes=1:ppn=1 -j oe -N combineAll:wq


if [ ! -f expected ]; then
 bash jobs/make_expected_file.sh
fi
EXPECTEDNAMES=expected
MARKERS=JGI_1086
count=`wc -l $EXPECTEDNAMES | awk '{print $1}'`
#echo "count is $count"
perl scripts/combine_fasaln.pl -o all_${count}.${MARKERS}.fasaln -of fasta -d aln/$MARKERS -expected $EXPECTEDNAMES > all_${count}.${MARKERS}.partitions.txt
