#PBS -N makeUaln.JGI_1086 -j oe -l walltime=8:00:00,mem=4gb
# DO NOT RUN WITH ARRAYJOBS
module load perl
module load cdbfasta
module load hmmer
perl scripts/construct_unaln_files_cdbfasta.pl -d search/JGI_1086 -db pep -o aln/JGI_1086
