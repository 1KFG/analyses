#PBS -q js -N makeUaln.Roz200 -j oe
 perl scripts/construct_unaln_files.pl -d search/Roz200 -db pep -o aln/Roz200
