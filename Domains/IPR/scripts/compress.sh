#PBS -l nodes=1:ppn=8 -j oe -o compress.log

for dir in *.d
do
 echo $dir
 b=`basename $dir .d`
 if [ -f "$dir/split-$b.1.IPROUT.gff3" ]; then
 pigz $dir/*.gff3 
 pigz $dir/*.xml
 fi
done
