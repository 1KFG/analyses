#PBS -l nodes=1:ppn=32,mem=64gb -q highmem -N raxmlAVX -j oe
module load RAxML

CPU=2

if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi
count=`wc -l expected | awk '{print $1}'`
datestr=`date +%Y_%b_%d`
str=Zygo.$datestr".JGI1086".${count}sp
IN=all_${count}.JGI_1086
if [ ! -f phylo/$str.fasaln ]; then
 cp $IN.fasaln phylo/$str.fasaln
 cp $IN.partitions.txt phylo/$str.partitions
fi
cd phylo
PREFIX=Zygo_RD2_Standard.$str
raxmlHPC-PTHREADS-AVX -T $CPU -f a -x 227 -p 771 -o Rall -m PROTGAMMAAUTO \
  -s $str.fasaln -n $PREFIX -N autoMRE 
