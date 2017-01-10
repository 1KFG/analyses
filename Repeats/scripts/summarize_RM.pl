#!/usr/bin/perl
use warnings;
use strict;

use Getopt::Long;
use Bio::SeqIO;
use List::Util qw(sum);

my ($rdir) = qw(results);

GetOptions('d|results:s'  => \$rdir);

# read dir
my (%tcounts,%repeat_bp_counts,%lens,%seen_types);

opendir(DIR,$rdir) || die "cannot open $rdir: $!";
for my $file ( readdir(DIR) ) {
    next unless $file =~ /(\S+)\.out$/;
    my $stem =$1;
    open(my $fh => "$rdir/$file") || die "cannot open $rdir/$file: $!";
    my $header = <$fh>;
    $header .= <$fh>;
    my %table;
# read each result file
    warn("$stem\n");
    while(<$fh>) {
	next if /^\s+$/;
	my ($score,$perdiv,$perdel,$perins, $queryseq,$qstart,$qend,
	    $qleft, $strand,$repeatname,$repeatfam,$sstart,$send,
	    $sleft,$id) = split;
	# skip these repeats
	next if $repeatfam =~ /Simple_repeat|Low_complexity/;
	if( ! exists $lens{$stem}->{$queryseq} ) {
	#    warn("inferring chrom size for $queryseq ($stem)\n");
	    $qleft =~ s/[()]//g;
	    $lens{$stem}->{$queryseq} = $qleft + $qend;
	}
	my ($famtype,$superfam) = split(/\//,$repeatfam);
	if( ! $superfam ) { $superfam = $famtype }
	$tcounts{$stem}->{$famtype}->{$repeatname}++;
	$seen_types{$famtype}++;
	for my $bp ( $qstart..$qend ) {
	    # last writer wins?
	    if ( exists $table{$queryseq}->{$bp} && 
		 $table{$queryseq}->{$bp} ne $famtype ) {
#		warn"replacing $queryseq ",$table{$queryseq}->{$bp}, 
#		" at $bp w $famtype\n";
	    }
	    $table{$queryseq}->{$bp} = $famtype;
	}
    }
    for my $chrom ( keys %table ) {
	for my $fam ( values %{$table{$chrom}} ) {
	    $repeat_bp_counts{$stem}->{$fam}++;
	}
    }
#    last;
}
my @repeat_type = sort keys %seen_types;
print join("\t",
	   qw(SPECIES GENOMELEN REPEATFRACTION),
	   ( map { sprintf("%s.totalinstances\t%s.types\t%s.genomefrac",
			 $_,$_,$_) } @repeat_type)),"\n";

# summary TE type and % of genome
for my $sp ( sort keys %lens ) {
    my $this_len = $lens{$sp};
    my $this_repeatbpcounts = $repeat_bp_counts{$sp};
    my $this_tcounts = $tcounts{$sp};
    my $totallen = sum values %$this_len;
    my $totalrpt = sum values %$this_repeatbpcounts;
    print join("\t",$sp,$totallen,sprintf("%.5f", $totalrpt/ $totallen),
	       ( map { (sum values %{$this_tcounts->{$_}}), #total instances
		       (scalar keys %{$this_tcounts->{$_}}), #num of types
		       sprintf("%.5f",$this_repeatbpcounts->{$_} / 
			       $totallen) } @repeat_type)
	), "\n";
}


