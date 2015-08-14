#PBS -j oe -l walltime=4:00:00
perl /shared/stajichlab/projects/Phylogenomics/Phyling/scripts/gather_besthmm_build_markerfasta.pl -pep genomes/pep -o genomes_markers -i genomes -cds genomes/cds -e 1e-20
