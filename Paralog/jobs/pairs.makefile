PEPS =  $(wildcard *.pep)
PEPALN = $(patsubst %.pep, %.pep.fasaln, $(PEPS)) 
CDSALN = $(patsubst %.pep, %.cds.fasaln, $(PEPS))

MRTRANS=/bigdata/stajichlab/shared/projects/1KFG/analysis/Paralog/jobs/bp_mrtrans.pl
MUSCLE=/opt/linux/centos/7.x/x86_64/pkgs/muscle/3.8.425/bin/muscle

.PHONY: all 

all: $(CDSALN) $(PEPALN)
	echo "Making all"

%.pep.fasaln: %.pep
	 ${MUSCLE} -in $*.pep -out $@ -quiet

%.cds.fasaln: %.pep.fasaln %.cds
	perl ${MRTRANS} -if fasta -of fasta -o $@ -i $*.pep.fasaln -s $*.cds
