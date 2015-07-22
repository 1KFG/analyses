use strict;
use warnings;
my $indir = shift || ".";
opendir(DIR,$indir) || die "cannot open $indir: $!";

for my $dir ( sort readdir(DIR) ) {
    if( $dir =~ /(\S+)\.d$/) {
	my $base = $1;
	print "cat $dir/*.tsv | gzip -c > ../tsv/$base.IPROUT.tab.gz\n";
    }
}
