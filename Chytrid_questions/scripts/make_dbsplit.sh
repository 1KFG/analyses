#PBS -l nodes=1:ppn=1 -j oe

cd run
bp_dbsplit.pl -p chytridio --size 1000 -i ../chytrid_proteomes/chytridiomycota.aa
bp_dbsplit.pl -p blastoclad --size 1000 -i ../chytrid_proteomes/blastocladiomycota.aa
