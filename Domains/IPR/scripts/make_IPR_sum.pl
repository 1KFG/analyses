#!env perl
use List::Util qw(sum);
use strict;
use warnings;
use File::Spec;

my $min_count = 1;
my $min_Evalue = 1e-5;
my @files = @ARGV;
my %domains;
my %domains_genes;
my @species;
my %dom2desc;
my %dom2ipr;
for my $file ( @files ) {
    my (undef,$path,$fname) = File::Spec->splitpath($file);
    #chop($path);
    my ($species) = split(/\./,$fname); 
    push @species, $species;
#    warn("path is $path\n");
    my $fh;
    if( $file =~ /\.gz$/ ) { 
	open($fh => "zcat $file |") || die $!;
    } else {
	open($fh => $file) || die $!;
    }
    my %seen;
    while(<$fh>) {
	chomp;

	my @row = split(/\t/,$_);
	my $domain = join(":", $row[3], $row[4]);
	$dom2desc{$domain} = $row[5] if defined $row[5];
	my $score = $row[8];
	next if( $score ne '-' && $score > $min_Evalue);
	next if ( $row[9] ne 'T' );
	$dom2ipr{$domain} = [ $row[11], $row[12] ] if ! exists $dom2ipr{$domain};
	$domains_genes{$domain}->{$species}++ unless $seen{$domain."--".$row[0]}++;
	$domains{$domain}->{$species}++;
    }
}

open(my $ofh => ">IPR.domain_counts.tab") || die $!;
open(my $ofh_genes => ">IPR.gene_domain_counts.tab") || die $!;
print $ofh join("\t",qw(FAMILY), @species), "\n";
print $ofh_genes join("\t",qw(FAMILY), @species), "\n";

for my $domain ( sort keys %domains ) {
    my $sum = sum(map { exists $domains{$domain}->{$_} ? 
			    $domains{$domain}->{$_} : '0' } 
		  @species);
    next if( $sum < $min_count);
    print $ofh join("\t", $domain, map { exists $domains{$domain}->{$_} ? 
					     $domains{$domain}->{$_} : '0' } 
		    @species),"\n";

    print $ofh_genes join("\t", $domain, 
			  map { exists $domains_genes{$domain}->{$_} ? 
				    $domains_genes{$domain}->{$_} : '0' } 
			  @species),"\n";
}
