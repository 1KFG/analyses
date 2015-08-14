module load trimal

out=../cds-aln-trim
cds=../cds
if [ ! -d $out ]; then
 mkdir -p $out
fi


for file in *.aa.fasaln; do
x=`basename $file .aa.fasaln`;
echo $file
trimal -in $file -out $out/$x.cds.fasaln_strictplus.trim -splitbystopcodon -backtrans $cds/$x.cds.rename -strictplus -fasta
trimal -in $file -out $out/$x.cds.fasaln_strict.trim -splitbystopcodon -backtrans $cds/$x.cds.rename -strict -fasta
trimal -in $file -out $out/$x.cds.fasaln_nogap.trim -splitbystopcodon -backtrans $cds/$x.cds.rename -nogaps -fasta
done
