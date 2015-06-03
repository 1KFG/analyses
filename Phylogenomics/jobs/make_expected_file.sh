head -q -n1 pep/*.fasta | awk -F\| '{print $1}' > expected
