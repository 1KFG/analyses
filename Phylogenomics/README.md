Ortholog identification and Tree building

mkdir search aln
ls pep > list
# run once for every genome
qsub -d `pwd` -t 1-348 jobs/do_hmmsearch.Roz200.sh
qsub -d `pwd` jobs/make_get_best_hits.Roz200.sh

# make the per-marker files
qsub -d`pwd` jobs/make_unaln.Roz200.sh


# hmmalign each marker file
qsub -d `pwd` -t 1-192 jobs/hmm_align.Roz200.sh
