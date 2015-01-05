#!env perl
use strict;
use warnings;
use File::Spec;

my @files = @ARGV;
my %domains;
my @species;
for my $file ( @files ) {
    my (undef,$path,$fname) = File::Spec->splitpath($file);
    #chop($path);
    my ($species) = split(/\./,$fname); 
    push @species, $species;
#    warn("path is $path\n");
    open(my $fh => $file) || die $!;
    while(<$fh>) {
	chomp;
	my @row = split(/\t/,$_);
	$row[1] =~ s/\s+$//;
	$row[1] =~ s/\.hmm//;
	$domains{$row[1]}->{$species}++;
    }
}

print join("\t",qw(FAMILY), @species), "\n";

for my $domain ( map { $_->[0] }
		 sort  { $a->[1] cmp $b->[1] || 
			     ($a->[2] eq 'NC' ? (1) : 
			      $b->[2] eq 'NC' ? (-1) : $a->[2] <=> $b->[2]) }
		 map { my ($val,$n) = ($_ =~ /(\D+)(\d+|NC)/);
		       #warn("val is $val n is $n\n");
		       #if( ! $val ) { warn("key was $_\n") }
		       [$_,$val,$n] }
		 keys %domains ) {
    print join("\t", $domain, map { exists $domains{$domain}->{$_} ? 
					$domains{$domain}->{$_} : '0' } 
	       @species),"\n";
}
