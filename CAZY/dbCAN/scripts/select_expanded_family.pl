
use strict;
use warnings;

use Bio::DB::Fasta;
use Bio::SeqIO;
my $db = Bio::DB::Fasta->new('pep');
my $out = Bio::SeqIO->new(-format => 'fasta');
while(<>) {
 my ($id)= split;
 my $seq = $db->get_Seq_by_acc($id);
 $out->write_seq($seq);
}
# open db
#
#
# # get the family name
#
# get the groupss to consider
