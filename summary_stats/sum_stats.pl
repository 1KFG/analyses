#!env perl
use strict;
use warnings;
use Bio::SeqIO;

my $dir = '../../genomes/final_combine';

opendir(DIR,"$dir/DNA") || die $!;
my %info;
for my $file ( readdir(DIR) ) {
    if( $file =~ /(\S+)\.fasta$/) {
	my $sp = $1;
	open(my $fh => "seqstat $dir/DNA/$file |" ) || die $!;
	while(<$fh>) {
	    if (/^Total # residues:\s+(\d+)/ ) {
		$info{$sp}->{genome} += $1;
	    }
#	my $in = Bio::SeqIO->new(-format => 'fasta',
#				 -file   => "$dir/DNA/$file");
#	while(my $s =$in->next_seq ) {
#	    $info{$sp}->{genome} += $s->length;
#	}
	}
    }
}

# later add gene count
for my $sp ( sort keys %info ) {
    print join("\t", $sp, $info{$sp}->{genome}),"\n";
}


