#PBS -l nodes=1:ppn=2,mem=8gb -N interpro -j oe -l walltime=4:00:00 -r n
module load coils 
module load iprscan
DIR=`pwd`
list=$DIR/peplist
line=$PBS_ARRAYID

if [ ! $line ]; then
  line=$1
fi
if [ ! $line ]; then
 echo "need a jobid by cmdline or PBS_ARRAYID"
 exit;
fi
name=`head -n $line $list | tail -n 1`
echo "name is $name, dir $DIR"
base=`basename $name .fasta`
hostname
if [ ! -f $DIR/$base.IPROUT.tsv ];
then
time interproscan.sh -t p -pathways -goterms -i $DIR/$name -b $DIR/$base.IPROUT 
fi
