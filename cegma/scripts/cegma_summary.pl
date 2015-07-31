#!env perl
use strict;
use warnings;
use Getopt::Long;

my $datfile = "cegma_summary.csv";
my $force = 0;
my $debug = 0;
my $dir;
GetOptions('d|dat:s' => \$datfile,
	   'force!'  => \$force,
	   'v|debug!'=> \$debug,
	   'dir:s'   => \$dir,
    );
$dir ||= shift || ".";

opendir(DIR, $dir) || die "cannot open dir $dir: $!\n";

if( $force || ! -f $datfile ) {
    my %data;
    for my $cegmadir ( readdir(DIR ) ){
	
	next unless ( -d "$dir/$cegmadir" && $cegmadir =~ /(\S+)\.cegma$/);
	my $name = $1;
	if( -f "$dir/$cegmadir/output.completeness_report") {
	    open(my $fh => "$dir/$cegmadir/output.completeness_report") || die "cannt open $dir/$cegmadir/output.completeness_report: $!";
	    while(<$fh>) {
		next if /^\#/ || /^\s+$/;
		if( s/^\s+(Complete|Partial)\s+(\d+)/$2/ ) {
		    my $type = $1;
		    my ($prots,$completeness,undef,$totalmatch,
			$avgmatch, $orthpercent) = split(/\s+/,$_);		
		    $data{$name}->{$type} = { prots => $prots,
					      completepercent => $completeness,
					      total => $totalmatch,
					      avg   => $avgmatch,
					      orth  => $orthpercent };
		}
	    }
	}
    }
    
    my @cols = qw(prots completepercent total avg orth);
    open(my $sum => ">$datfile") || die $!;
    print $sum join(",", qw(SPECIES COMPLETE_N COMPLETE_P COMPLETE_TOTAL 
COMPLETE_AVG COMPLETE_ORTHO PARTIAL_N PARTIAL_P PARTIAL_TOTAL 
PARTIAL_AVG PARTIAL_ORTHO)), "\n";

    for my $sp (
	sort { $data{$a}->{Complete}->{completepercent} <=> 
		   $data{$b}->{Complete}->{completepercent} } 
	keys %data ) {
	print $sum join(",", $sp, ( map { $data{$sp}->{Complete}->{$_} } @cols ),
			( map { $data{$sp}->{Partial}->{$_} } @cols )),"\n";
    }
}

open(my $Rout => "| R --no-save ") || die "Cannot open R: $!\n";
print $Rout "pdf(\"cegma_hist.pdf\");\n";

print $Rout "cegmadata <- read.csv(\"$datfile\",sep=\",\",header=T,row.names=1);\n";
print $Rout "summary(cegmadata);\n";
print $Rout 'hist(cegmadata$COMPLETE_P,20);',"\n";#,main="CEGMA Completeness");',"\n";
print $Rout 'hist(cegmadata$PARTIAL_P,20);',"\n";#main="CEGMA Partial Completeness");',"\n";
print $Rout 'hist(cegmadata$COMPLETE_ORTHO,20);',"\n";#main="CEGMA Ortho Percent");',"\n";
print $Rout 'poor<-subset(cegmadata,cegmadata$COMPLETE_P  < 90);',"\n";
print $Rout 'poor[order(poor$COMPLETE_P),]',"\n";
