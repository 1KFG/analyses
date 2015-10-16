#PBS -N makeUaln.Roz200 -j oe
which perl
module load perl
perl scripts/construct_unaln_files.pl -d search/Roz200 -db pep -o aln/Roz200
