module load trimal
out=../aa-aln-trim
if [ ! -d $out ]; then
 mkdir -p $out
fi

for file in *.aa.fasaln; do 
x=`basename $file .aa.fasaln`;
if [ ! -f $out/$x.fasaln_strictplus.pep.trim ]; then
trimal -in $file -out $out/$x.fasaln_strictplus.pep.trim -strictplus -fasta
trimal -in $file -out $out/$x.fasaln_strict.pep.trim -strict -fasta
trimal -in $file -out $out/$x.fasaln_automated1.pep.trim -automated1 -fasta
fi
done
