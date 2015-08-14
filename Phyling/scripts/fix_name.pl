#!env perl
use strict;
use warnings;
use Bio::SeqIO;
my $csv = 'prefix_lookup.tsv';
my $dir = shift || 'genomes_markers';
open(my $fh => $csv) || die $!;
my $i =0;
my $line = <$fh>;
chomp($line);
my %header  = map { $_ => $i++ } split(/\t/,$line);
my %lookup;
while(<$fh>) {
    chomp;
    my @row = split(/\t/,$_);
    my ($sn, $sp) = map { $row [ $header{$_} ] } ('Pref','Name');
    $sp =~ s/\s+$//;
    $sp =~ s/\s+/_/g;
    $lookup{$sn} = $sp;
}

opendir(DIR,$dir) || die $!;
for my $file( readdir(DIR) ) {
    next unless $file =~ /\.(aa|cds)$/;
    my $in = Bio::SeqIO->new(-format => 'fasta',
			     -file   => "$dir/$file");

    my $out = Bio::SeqIO->new(-format => 'fasta',
			      -file   => ">$dir/$file.rename");
    while( my $seq = $in->next_seq ) {
	my $lid = $seq->id;
	my ($id,$gn) = split(/\|/,$lid);
	if( $lookup{$id} ) {
	    $id = $lookup{$id};
	} else {
	    warn("no $id found\n");
	}
	$seq->id($id);
	$seq->description("$gn ".$seq->description);
	$out->write_seq($seq);
    }
}
