nm=`basename \`pwd\``
tar cfz $nm.tgz *.pep *.cds *.pep.fasaln
rm *.pep *.cds *.pep.fasaln
