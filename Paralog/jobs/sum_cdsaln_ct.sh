for dir in `ls`
do
 echo -n "$dir  " >> ../cdsaln_ct.txt
 ls $dir/*.cds.fasaln | wc -l >> ../cdsaln_ct.txt
done
