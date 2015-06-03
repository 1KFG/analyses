#PBS -q js -N makeUaln.AFTOL70 -j oe
 perl scripts/construct_unaln_files.pl -d search/AFTOL70 -db pep -o aln/AFTOL70
