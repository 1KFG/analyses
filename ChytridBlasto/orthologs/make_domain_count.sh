mkdir -p domain_counts
for clade in ChytridBlasto.I15.mcl.out-profile/*.tab; 
do 
 b=$(basename $clade .phyloprofile.tab);
 grep -P "\t$b\t" *.pergene.tab | awk '{print $4}' | perl -p -e 's/,/\n/g' | sort | uniq -c | sort -nr > domain_counts/$b.domain_counts
done
