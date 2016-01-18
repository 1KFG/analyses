#PBS -l nodes=1:ppn=1,mem=1gb,walltime=1:00:00 -N yn00.cds -j oe
N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi
if [ ! $N ]; then
 echo "Need a cmdline or PBS_ARRAYID value"
 exit
fi
INFILE=prefix_dirs.txt
dir=`sed -n ${N}p $INFILE`
if [ ! -f kaks/$dir.yn00.tab ]; then
 cat lib/header > kaks/$dir.yn00.tab
~/src/subopt-kaks-0.07/bin/yn00_cds_prealigned pairs/$dir/*.cds.fasaln | grep -v kappa >> kaks/$dir.yn00.tab
else
 echo "not running $dir, kaks/$dir.yn00.tab already exists"
fi

