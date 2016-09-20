#!env perl
use List::Util qw(sum);
use strict;
use warnings;
use Getopt::Long;
use File::Spec;
# specify on the cmdline the input files to read in to make a matrix of counts for each domain
# in this case do
# perl make_cazy_sum.pl *.tab > cazy_sum.dat
my $min_count = 20;

GetOptions('m|min:i' => \$min_count);

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
		       if( ! defined $val ) { warn("No val for $_\n"); 
					     ($val,$n) = ($_, 1); }
		       [$_,$val,$n] }
		 keys %domains ) {
    my $sum = sum(map { exists $domains{$domain}->{$_} ? 
					$domains{$domain}->{$_} : '0' } 
		  @species);
    next if( $sum < $min_count);
    print join("\t", $domain, map { exists $domains{$domain}->{$_} ? 
					$domains{$domain}->{$_} : '0' } 
	       @species),"\n";
}
