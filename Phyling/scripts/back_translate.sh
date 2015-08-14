#PBS -j oe

for file in aa-aln/*.fasaln
do
 b=`basename $file .aa.fasaln`
 cds=cds/$b.cds.rename
 bp_mrtrans -if fasta -of fasta -i $file -s $cds -o cds-aln/$b.cds.fasaln
done
