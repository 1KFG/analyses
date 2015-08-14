#!env perl
use strict;
use warnings;
use Bio::SeqIO;

my $dir = shift || "genomes_markers";
my $remove = shift || "remove_prefix.txt";

open(my $fh => $remove) || die $!;
my %discard;
while(<$fh>) {
    my ($pref,$full) = split;
    $discard{$pref} = $full;
    $discard{$full} = $pref;
}

opendir(DIR,$dir) || die $!;
for my $file ( readdir(DIR) ) {
    next unless ($file =~ /\.(aa|fasaln|cds|rename)$/);
    my $in = Bio::SeqIO->new(-format => 'fasta',
			     -file   => "$dir/$file");
    my $out = Bio::SeqIO->new(-format=> 'fasta',
			      -file  => ">$dir/$file.rm");
    while(my $s=$in->next_seq ) {
	my $id = $s->display_id;
	my $pref = $id;
	if ( $id =~ /\|/ ) {
	    ($pref) = split(/\|/,$id);
	} 
	next if exists $discard{$pref};
	$out->write_seq($s);
    }
}
