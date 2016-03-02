#!env perl
use strict;
use warnings;
use Bio::SeqIO;
use Bio::DB::Fasta;
use File::Spec;

my $dbfolder = 'chytrid_proteomes';
my @dbs = qw(blastocladiomycota.aa chytridiomycota.aa);

for my $db( @dbs ) {
    my $dbh = Bio::DB::Fasta->new(File::Spec->catfile($dbfolder,$db));
    my ($clade) = split('\.',$db); 
    open(my $in => "$clade.lst") || die "cannot open $clade.lst";
    my %seen;
    while(<$in>) {
	my ($qname,$clade) = split;
	next if $clade eq 'NONE';
	my ($sp,$nm) = split(/\|/,$qname);
	$seen{$sp}->{$qname}++;
    }
    
    for my $sp ( keys %seen ) {
	my $out = Bio::SeqIO->new(-format => 'fasta',
				  -file   => ">$sp.clade_only.fas");
	for my $t ( keys %{$seen{$sp}} ) {
	    $out->write_seq($dbh->get_Seq_by_acc($t));
	}
    }
}
