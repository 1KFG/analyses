Ortholog identification and Tree building

mkdir search aln
ls pep > list
# run once for every genome
qsub -d `pwd` -q js -t 1-269 jobs/do_hmmsearch.AFTOL.sh
bash jobs/make_get_best_hits.sh

# make the per-marker files
perl scripts/construct_unaln_files.pl

# hmmalign each marker file
qsub -d `pwd` -q js -t 1-71 jobs/hmm_align.AFTOL_70.sh
