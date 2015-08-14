#!env perl
use strict;
use warnings;

my $expected_list = shift || 'prefix_lookup.tsv';
my $aa_aln_dir = shift || 'genomes_markers/aa-aln';
my $trim_dir = shift || 'genomes_markers/aa-aln-trim';
my %expected;
open(my $fh => $expected_list ) || die $!;
while(<$fh>) {
    my ($pref,$name) = split;
    $expected{$name} = $pref;
}
my @names = sort keys %expected;
opendir(DIR,$trim_dir) || die "Cannot open $trim_dir: $!";
my %stats;
# presence/absence of species in an alignment
open(my $rpt1 => ">aln_completeness.tab") || die $!;
# aln stats
open(my $rpt2 => ">aln_stats.tab") || die $!;

print $rpt1 join("\t", qw(OG), @names), "\n";
print $rpt2 join("\t", qw(OG NUM_TAXA FULL_LEN TRIM_LEN FULL_PERC_ID TRIM_PERC_ID TRIM_RATIO)),
    "\n";
for my $file (sort readdir(DIR) ) {
    if( $file =~ /(\S+)\.fasaln_strict\.pep\.trim$/ ) {
	my $stem = $1;
	open(my $run => "alistat $trim_dir/$file |" ) || die $!;
	while(<$run>) {
	    if(/Alignment length:\s+(\d+)/ ) {
		$stats{$stem}->{trim} = $1;
	    } elsif (/Average identity:\s+(\d+)/ ) {
		$stats{$stem}->{trimpid} = $1;
	    }
	}
	open(my $fh => "grep \"^>\" $aa_aln_dir/$stem.aa.fasaln |") || die $!;
	my %seen;
	while(<$fh>) {
	    if (/^>(\S+)/ ) {
		my $id= $1;
		$seen{$id}++;
		$stats{$stem}->{ntax}++;
	    }
	}
	print $rpt1 join("\t", $stem,
			 map { $seen{$_} || 0 }
			 @names),"\n";
			 
	close($fh);
	open($run => "alistat $aa_aln_dir/$stem.aa.fasaln |" ) || die $!;
	while(<$run>) {
	    if(/Alignment length:\s+(\d+)/ ) {
		$stats{$stem}->{full} = $1;
	    } elsif (/Average identity:\s+(\d+)/ ) {
		$stats{$stem}->{fullpid} = $1;
	    }
	}
	close($run);
    }
}
for my $cluster (sort keys %stats ) {
    print $rpt2 join("\t", $cluster,
		     ( map { $stats{$cluster}->{$_} } 
		       qw(ntax full trim fullpid trimpid)),
		     sprintf("%.2f",
			     $stats{$cluster}->{trim} / 
			     $stats{$cluster}->{full})),"\n";
}
