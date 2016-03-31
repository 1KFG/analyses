#PBS -N makeUaln.JGI_1086 -j oe -l walltime=8:00:00,mem=4gb
#which perl
module load perl
perl scripts/construct_unaln_files.pl -d search/JGI_1086 -db pep -o aln/JGI_1086
