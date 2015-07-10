#!env perl
use strict;
use File::Spec;

my $peplist = 'peplist'; # file with names of files to process
my $dir = shift || ".";
opendir(DIR, $dir) || die $!;
my $fulldir = File::Spec->rel2abs($dir);
for my $gdir ( readdir(DIR) ) {
    next unless -d "$dir/$gdir" && $gdir =~ /(\S+)\.d$/;
    my $stem = $1;
    if( ! -f "$dir/$gdir/$peplist" ) {
	warn("no peplist for folder $gdir\n");
	next;
    }
    open(my $fh => "$dir/$gdir/$peplist" ) || die "Cannot open $dir/$gdir/$peplist: $!";
    my $n = 1;
    my @rerun;
    while(<$fh>) {
	my $qfile = $_;
	chomp($qfile);
	if( ! -f "$dir/$gdir/$qfile.IPROUT.tsv" ) {
	    push @rerun, $n;
	}
	$n++;
    }
    if( @rerun ) {
	print "qsub -d $fulldir/$gdir -j oe -N $stem -t ", join(",", &collapse_nums(@rerun)), " run_interpro.sh\n";
    }
}

sub collapse_nums {
#------------------
# This is probably not the slickest connectivity algorithm, but will do for now.
    my @a = @_;
    my ($from, $to, $i, @ca, $consec);

    $consec = 0;
    for($i=0; $i < @a; $i++) {
	not $from and do{ $from = $a[$i]; next; };
	if($a[$i] == $a[$i-1]+1) {
	    $to = $a[$i];
	    $consec++;
	} else {
	    if($consec == 1) { $from .= ",$to"; }
	    else { $from .= $consec>1 ? "\-$to" : ""; }
	    push @ca, split(',', $from);
	    $from =  $a[$i];
	    $consec = 0;
	    $to = undef;
	}
    }
    if(defined $to) {
	if($consec == 1) { $from .= ",$to"; }
	else { $from .= $consec>1 ? "\-$to" : ""; }
    }
    push @ca, split(',', $from) if $from;

    @ca;
}

